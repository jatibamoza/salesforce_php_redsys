@isTest
private class OpportunityLineItemTrigger_Test {
    
    @TestSetup
    private static void dataTest() {
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 product = new Product2();
        product.Name = 'Prueba';
        product.ProductCode = 'Prueba';
        product.IsActive = true;
        insert product;

        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = pricebookId;
        pbEntry.Product2Id = product.Id;
        pbEntry.UnitPrice = 1;
        pbEntry.IsActive = true;
        insert pbEntry;

        Pricebook2 customPB = new Pricebook2();
		customPB.Name = 'Custom Pricebook';
        customPB.IsActive = true;
        insert customPB;
        
        Opportunity opp = new Opportunity();
        opp.StageName = 'Entrevista con Director';
        opp.CloseDate = Date.today();
        opp.Name = 'Prueba';
        opp.Pricebook2Id = pricebookId;
        insert opp;
        
	}

	@isTest
	private static void testName() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Prueba'];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'Prueba'];
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id =: prod.Id];
        
        Test.startTest();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbe.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 1000;
        insert oli;
		Test.stopTest();
	}
}