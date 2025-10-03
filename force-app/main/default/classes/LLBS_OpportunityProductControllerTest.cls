@isTest
private class LLBS_OpportunityProductControllerTest {

    @TestSetup
    static void makeData(){
        // 1. Crear la Cuenta
        Account acc = new Account(Name='Test Account');
        insert acc;

        // 2. OBTENER el ID del Tipo de Registro
        Id recordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('LLBS_Producto').getRecordTypeId();

        // 3. Crear los Productos
        Product2 standardProduct = new Product2(Name='Standard Product', IsActive=true);
        Product2 masterProduct = new Product2(
            Name='Master Product Test',
            ProductCode = 'MST-001',
            Family = 'Master',
            RecordTypeId = recordTypeId,
            IsActive = true
        );
        insert new List<Product2>{standardProduct, masterProduct};

        // 4. Obtener el Libro de Precios Estándar de forma correcta para pruebas
        Id standardPricebookId = Test.getStandardPricebookId();

        // 5. Crear las entradas en el Libro de Precios
        PricebookEntry pbeStandard = new PricebookEntry(
            Pricebook2Id = standardPricebookId, // Usar el ID obtenido
            Product2Id = standardProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        PricebookEntry pbeMaster = new PricebookEntry(
            Pricebook2Id = standardPricebookId, // Usar el ID obtenido
            Product2Id = masterProduct.Id,
            UnitPrice = 500,
            IsActive = true
        );
        insert new List<PricebookEntry>{pbeStandard, pbeMaster};

        // 6. Crear la Oportunidad
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Pricebook2Id = standardPricebookId // Usar el ID obtenido
        );
        insert opp;

        // 7. Añadir el producto inicial a la Oportunidad
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId = pbeStandard.Id,
            Quantity = 2,
            UnitPrice = 100
        );
        insert oli;
    }

    // Test para obtener los productos de una oportunidad
    @isTest
    static void testGetOppProducts() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];
        Test.startTest();
        List<OpportunityLineItem> results = LLBS_OpportunityProductController.getOpportunityProducts(opp.Id);
        Test.stopTest();
        System.assertEquals(1, results.size(), 'Debería encontrar un producto en la oportunidad.');
    }

    // Test para la búsqueda filtrada de productos
    @isTest
    static void testSearchProducts() {
        Id standardPricebookId = Test.getStandardPricebookId();
        Test.startTest();
        List<PricebookEntry> results = LLBS_OpportunityProductController.searchProducts('Master', standardPricebookId);
        Test.stopTest();
        System.assertEquals(1, results.size(), 'Debería encontrar un producto "Master".');
        System.assertEquals('Master Product Test', results[0].Product2.Name, 'El nombre del producto no es el esperado.');
        
        List<PricebookEntry> noResults = LLBS_OpportunityProductController.searchProducts('XYZ-NO-EXISTE', standardPricebookId);
        System.assertEquals(0, noResults.size(), 'No debería encontrar productos con este término.');
    }

    // Test para el reemplazo de un producto
    @isTest
    static void testReplaceProduct() {
        OpportunityLineItem oldOli = [SELECT Id, Quantity FROM OpportunityLineItem LIMIT 1];
        PricebookEntry newPbe = [SELECT Id FROM PricebookEntry WHERE Product2.Name = 'Master Product Test'];
        Test.startTest();
        LLBS_OpportunityProductController.replaceProduct(oldOli.Id, newPbe.Id, oldOli.Quantity);
        Test.stopTest();
        List<OpportunityLineItem> oldItems = [SELECT Id FROM OpportunityLineItem WHERE Id = :oldOli.Id];
        System.assertEquals(0, oldItems.size(), 'El producto antiguo debería haber sido eliminado.');
        List<OpportunityLineItem> newItems = [SELECT Id, Quantity, PricebookEntryId FROM OpportunityLineItem WHERE PricebookEntryId = :newPbe.Id];
        System.assertEquals(1, newItems.size(), 'El nuevo producto debería haber sido creado.');
        System.assertEquals(oldOli.Quantity, newItems[0].Quantity, 'La cantidad del nuevo producto debería ser la misma que la del antiguo.');
    }
}