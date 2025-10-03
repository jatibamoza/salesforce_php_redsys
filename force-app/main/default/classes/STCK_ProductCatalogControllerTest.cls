@IsTest
public with sharing class STCK_ProductCatalogControllerTest {

    @TestSetup
    static void makeData() {
        // Create Pricebook
        Pricebook2 pb = new Pricebook2(Name = 'Tienda de Empleados', IsActive = true);
        insert pb;

        // Create Products
        List<Product2> products = new List<Product2>();
        
        // Product 1: With Family, Stock, Catalogo, Uso_Empleado
        products.add(new Product2(
            Name = 'Test Product A',
            ProductCode = 'TPA',
            IsActive = true,
            Family = 'Electronics',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 10,
            Description = 'Description for Product A',
            Imagen__c = 'http://example.com/imageA.png'
        ));

        // Product 2: With Family, Stock, Catalogo, Uso_Empleado, and NombreAuxiliar
        products.add(new Product2(
            Name = 'Test Product B',
            ProductCode = 'TPB',
            IsActive = true,
            Family = 'Clothing',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 5,
            Description = 'Description for Product B',
            Imagen__c = 'http://example.com/imageB.png'
        ));

        // Product 3: Duplicate of Product B by NombreAuxiliar (should be de-duplicated)
        products.add(new Product2(
            Name = 'Test Product B Duplicate',
            ProductCode = 'TPBD',
            IsActive = true,
            Family = 'Clothing',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 3,
            Description = 'Another Description for Product B'
        ));

        // Product 4: Without Family
        products.add(new Product2(
            Name = 'Test Product C',
            ProductCode = 'TPC',
            IsActive = true,
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 20
        ));

        // Product 5: Inactive
        products.add(new Product2(
            Name = 'Test Product D',
            ProductCode = 'TPD',
            IsActive = false,
            Family = 'Electronics',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 15
        ));

        // Product 6: StockActual__c = 0
        products.add(new Product2(
            Name = 'Test Product E',
            ProductCode = 'TPE',
            IsActive = true,
            Family = 'Electronics',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 0
        ));

        // Product 7: Catalogo__c = false
        products.add(new Product2(
            Name = 'Test Product F',
            ProductCode = 'TPF',
            IsActive = true,
            Family = 'Electronics',
            Catalogo__c = false,
            Uso_Empleado__c = true,
            StockActual__c = 10
        ));

        // Product 8: Uso_Empleado__c = false
        products.add(new Product2(
            Name = 'Test Product G',
            ProductCode = 'TPG',
            IsActive = true,
            Family = 'Electronics',
            Catalogo__c = true,
            Uso_Empleado__c = false,
            StockActual__c = 10
        ));

        // Product 9: Regular Product, not for de-duplication
        products.add(new Product2(
            Name = 'Test Product H',
            ProductCode = 'TPH',
            IsActive = true,
            Family = 'Furniture',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 7,
            Description = 'Description for Product H'
        ));
        
        // Product 10: Duplicate of Product H by Name (should be de-duplicated)
        products.add(new Product2(
            Name = 'Test Product H', // Same Name as Product 9
            ProductCode = 'TPHD',
            IsActive = true,
            Family = 'Furniture',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 2,
            Description = 'Another Description for Product H'
        ));

        insert products;

        // Get standard pricebook entry for currency conversion if needed
        Id standardPricebookId = Test.getStandardPricebookId();

        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 p : products) {
            pbes.add(new PricebookEntry(
                Pricebook2Id = pb.Id,
                Product2Id = p.Id,
                UnitPrice = 100.00,
                IsActive = true
            ));
        }
        insert pbes;
    }

    @IsTest
    static void testGetProductCategories() {
        Test.startTest();
        List<String> categories = STCK_ProductCatalogController.getProductCategories();
        Test.stopTest();

        System.debug('Categories: ' + categories);
        System.assertEquals(3, categories.size(), 'Should return 3 unique active categories with stock, catalogo and uso_empleado true.');
        System.assert(categories.contains('Clothing'), 'Categories should contain Clothing.');
        System.assert(categories.contains('Electronics'), 'Categories should contain Electronics.');
        System.assert(categories.contains('Furniture'), 'Categories should contain Furniture.');
        System.assertEquals('Clothing', categories[0], 'Categories should be sorted alphabetically.');
        System.assertEquals('Electronics', categories[1], 'Categories should be sorted alphabetically.');
        System.assertEquals('Furniture', categories[2], 'Categories should be sorted alphabetically.');
    }

    @IsTest
    static void testGetProducts_NoFilters() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('', '');
        Test.stopTest();

        System.debug('Products (No Filters): ' + products);
        System.assertEquals(4, products.size(), 'Should return 4 unique products meeting criteria (A, B, H, C) after de-duplication.');

        Set<String> productNames = new Set<String>();
        for(PricebookEntry pbe : products) {
            if (pbe.Product2.NombreAuxiliar__c != null) {
                productNames.add(pbe.Product2.NombreAuxiliar__c);
            } else {
                productNames.add(pbe.Product2.Name);
            }
        }
        System.assert(productNames.contains('Test Product A'), 'Should contain Test Product A.');
        System.assert(productNames.contains('Auxiliar Name B'), 'Should contain Auxiliar Name B (from Product B).');
        System.assert(productNames.contains('Test Product H'), 'Should contain Test Product H (from Product H).');
        System.assert(productNames.contains('Test Product C'), 'Should contain Test Product C (no family).');
        System.assert(!productNames.contains('Test Product B Duplicate'), 'Should not contain Test Product B Duplicate due to de-duplication.');
        System.assert(!productNames.contains('Test Product D'), 'Should not contain Inactive Product D.');
        System.assert(!productNames.contains('Test Product E'), 'Should not contain Product E with 0 stock.');
        System.assert(!productNames.contains('Test Product F'), 'Should not contain Product F with Catalogo__c = false.');
        System.assert(!productNames.contains('Test Product G'), 'Should not contain Product G with Uso_Empleado__c = false.');
    }

    @IsTest
    static void testGetProducts_ByCategory() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('', 'Electronics');
        Test.stopTest();

        System.debug('Products (Category Electronics): ' + products);
        System.assertEquals(1, products.size(), 'Should return 1 product in Electronics category (Test Product A).');
        System.assertEquals('Test Product A', products[0].Product2.Name, 'Product should be Test Product A.');
    }

    @IsTest
    static void testGetProducts_BySearchKey_Name() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('Product A', '');
        Test.stopTest();

        System.debug('Products (Search Product A): ' + products);
        System.assertEquals(1, products.size(), 'Should return 1 product matching "Product A".');
        System.assertEquals('Test Product A', products[0].Product2.Name, 'Product should be Test Product A.');
    }

    @IsTest
    static void testGetProducts_BySearchKey_AuxiliaryName() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('Auxiliar Name B', '');
        Test.stopTest();

        System.debug('Products (Search Auxiliar Name B): ' + products);
        System.assertEquals(1, products.size(), 'Should return 1 product matching "Auxiliar Name B" via NombreAuxiliar__c.');
        System.assertEquals('Test Product B', products[0].Product2.Name, 'Product should be Test Product B.');
    }

    @IsTest
    static void testGetProducts_ByCategoryAndSearchKey() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('Product B', 'Clothing');
        Test.stopTest();

        System.debug('Products (Category Clothing & Search Product B): ' + products);
        System.assertEquals(1, products.size(), 'Should return 1 product matching category and search key.');
        System.assertEquals('Test Product B', products[0].Product2.Name, 'Product should be Test Product B.');
    }

    @IsTest
    static void testGetProducts_NoMatch() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('NonExistent', 'NonExistentCategory');
        Test.stopTest();

        System.debug('Products (No Match): ' + products);
        System.assert(products.isEmpty(), 'Should return an empty list when no products match.');
    }

    @IsTest
    static void testGetProducts_SanitizeSearchKey() {
        Test.startTest();
        // Test with a search key containing a single quote to ensure sanitization
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('Product\'s', '');
        Test.stopTest();

        System.debug('Products (Sanitized Search Key): ' + products);
        // Assuming no products actually have an apostrophe, this should return empty.
        // The main point is to ensure no SOQL injection error.
        System.assert(products.isEmpty(), 'Should return empty if no matching product after sanitization.');

        // Create a product to actually match the sanitized key
        Product2 productWithApostrophe = new Product2(
            Name = 'Product\'s Special',
            ProductCode = 'TPS',
            IsActive = true,
            Family = 'Gadgets',
            Catalogo__c = true,
            Uso_Empleado__c = true,
            StockActual__c = 1
        );
        insert productWithApostrophe;

        PricebookEntry pbeWithApostrophe = new PricebookEntry(
            Pricebook2Id = [SELECT Id FROM Pricebook2 WHERE Name = 'Tienda de Empleados'].Id,
            Product2Id = productWithApostrophe.Id,
            UnitPrice = 50.00,
            IsActive = true
        );
        insert pbeWithApostrophe;

        Test.startTest();
        List<PricebookEntry> productsAfterInsert = STCK_ProductCatalogController.getProducts('Product\'s Special', '');
        Test.stopTest();
        
        System.assertEquals(1, productsAfterInsert.size(), 'Should return product with apostrophe after matching.');
        System.assertEquals('Product\'s Special', productsAfterInsert[0].Product2.Name, 'Should match product with apostrophe.');
    }

    @IsTest
    static void testGetProducts_DeDuplicationLogic_AuxName() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('', 'Clothing');
        Test.stopTest();

        // Product B and Product B Duplicate have the same NombreAuxiliar__c.
        // Only one should be returned. The one added first to the list by the query will be picked.
        System.assertEquals(1, products.size(), 'Should return only one product for Clothing category due to NombreAuxiliar__c de-duplication.');
        System.assertEquals('Test Product B', products[0].Product2.Name, 'Should return Test Product B as it was likely processed first.');
    }

    @IsTest
    static void testGetProducts_DeDuplicationLogic_MainName() {
        Test.startTest();
        List<PricebookEntry> products = STCK_ProductCatalogController.getProducts('', 'Furniture');
        Test.stopTest();

        // Product H and Product H Duplicate have the same Name and no NombreAuxiliar__c.
        // Only one should be returned.
        System.assertEquals(1, products.size(), 'Should return only one product for Furniture category due to main Name de-duplication.');
        System.assertEquals('Test Product H', products[0].Product2.Name, 'Should return Test Product H as it was likely processed first.');
    }
}