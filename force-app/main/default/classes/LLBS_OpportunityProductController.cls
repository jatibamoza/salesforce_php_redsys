public without sharing class LLBS_OpportunityProductController {

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProducts(Id opportunityId) {
        return [
            SELECT Id, Product2.Name, Product2.ProductCode, Quantity, UnitPrice, TotalPrice, PricebookEntry.Pricebook2Id
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId
        ];
    }

@AuraEnabled(cacheable=true)
public static List<PricebookEntry> searchProducts(String searchTerm, Id pricebookId) {
    String queryTerm = '%' + searchTerm + '%';
    Id recordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('LLBS_Producto').getRecordTypeId();

    return [
        SELECT Id, Product2.Name, Product2.ProductCode, UnitPrice
        FROM PricebookEntry
        WHERE
            // Filtros del Pricebook y búsqueda
            IsActive = true AND
            Pricebook2Id = :pricebookId AND
            (Product2.Name LIKE :queryTerm OR Product2.ProductCode LIKE :queryTerm) AND

            // --- NUEVOS FILTROS ---
            Product2.IsActive = true AND
            Product2.Family = 'Master' AND
            Product2.RecordTypeId = :recordTypeId
        LIMIT 10
    ];
}

    @AuraEnabled
    public static void replaceProduct(Id oldOppLineItemId, Id newPricebookEntryId, Decimal quantity) {
        try {
            OpportunityLineItem oldProduct = [SELECT OpportunityId FROM OpportunityLineItem WHERE Id = :oldOppLineItemId];
            PricebookEntry newProduct = [SELECT UnitPrice FROM PricebookEntry WHERE Id = :newPricebookEntryId];

            OpportunityLineItem newLineItem = new OpportunityLineItem(
                OpportunityId = oldProduct.OpportunityId,
                PricebookEntryId = newPricebookEntryId,
                Quantity = quantity,
                UnitPrice = newProduct.UnitPrice
            );
            insert newLineItem;

            delete new OpportunityLineItem(Id = oldOppLineItemId);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}