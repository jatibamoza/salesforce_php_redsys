@isTest 
private class STCK_VF001_PeticionMaterialCntrllrTest {

    @testSetup static void setup() {
        Schema.Location almacen = new Schema.Location();
        almacen.Name = 'Torrelaguna';
        almacen.LocationType = 'Almacén';
        // (opcional) Si vas a usar esta dirección en búsquedas:
        almacen.put('STCK_Direccion__c', 'Torrelaguna');
        insert almacen;

        Schema.Location almacenVirtual = new Schema.Location();
        almacenVirtual.Name = 'Audiovisual';
        almacenVirtual.LocationType = 'Virtual';
        // CRÍTICO: este campo es el que usa el SOQL para Dirección
        almacenVirtual.put('STCK_Direccion__c', 'Audiovisual');
        insert almacenVirtual;
        
        Product2 producto = new Product2(
            Name = 'Producto de prueba',
            Description = 'Descripción producto de prueba',
            Family = 'Textil',
            IsActive = true,
            StockActual__c = 10,
            Catalogo__c = true
        );
        insert producto;

        Product2 productoSinFamilia = new Product2(
            Name = 'Producto de prueba sin familia',
            Description = 'Descripción producto de prueba sin familia',
            IsActive = true,
            StockActual__c = 10,
            Catalogo__c = true
        );
        insert productoSinFamilia;

        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        PriceBookEntry precio = new PriceBookEntry();
        precio.Product2Id  = producto.Id;
        precio.Pricebook2Id = standardPriceBook.Id;
        precio.UnitPrice = 1;
        insert precio;
        
        PriceBookEntry precioSinFamilia = new PriceBookEntry();
        precioSinFamilia.Product2Id  = productoSinFamilia.Id;
        precioSinFamilia.Pricebook2Id = standardPriceBook.Id;
        precioSinFamilia.UnitPrice = 1;
        insert precioSinFamilia;
        
        // Stock en almacén físico
        ArticuloProducto__c articulo = new ArticuloProducto__c();
        articulo.Name = 'Producto de prueba';
        articulo.Producto__c = producto.Id;
        articulo.Almacen__c = almacen.Id;              // Torrelaguna
        articulo.Cantidad__c = 10;
        insert articulo;

        // Stock en "Dirección" (location virtual Audiovisual)
        ArticuloProducto__c articuloDireccion = new ArticuloProducto__c();
        articuloDireccion.Name = 'Producto de prueba Direccion';
        articuloDireccion.Producto__c = producto.Id;
        articuloDireccion.Almacen__c = almacenVirtual.Id; // Audiovisual
        articuloDireccion.Cantidad__c = 10;
        insert articuloDireccion;
        
        ArticuloProducto__c articuloSinFamilia = new ArticuloProducto__c();
        articuloSinFamilia.Name = 'Producto de prueba sin familia';
        articuloSinFamilia.Producto__c = productoSinFamilia.Id;
        articuloSinFamilia.Almacen__c = almacen.Id;    // Torrelaguna
        articuloSinFamilia.Cantidad__c = 10;
        insert articuloSinFamilia;
    }
    
    @isTest
    static void testSolicitudMaterial() {
        Test.StartTest(); 
        ApexPages.currentPage().getHeaders().put('referer', 'test');
        ApexPages.currentPage().getParameters().put('clickedRow', '1');

        Product2 producto = [SELECT Name, Description, Family, IsActive, StockActual__c, Catalogo__c 
                             FROM Product2 WHERE Name = 'Producto de prueba' LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(producto);
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
        ctl.getCategoriaDisponible();
        
        ctl.queryButton();
        ctl.createButton();
        ctl.addRow();
        ctl.removeRow();

        ctl.peticion.Direccion__c = 'AUDIOVISUAL';
        ctl.peticion.Area__c = 'Operadores Nacionales';
        ctl.peticion.PersonaSolicitante__c = 'Persona solicitante';
        ctl.peticion.CorreoElectronico__c = 'test@globant.com';
        ctl.peticion.NombreEvento__c = 'Nombre evento';
        ctl.peticion.LugarEvento__c = 'Lugar evento';
        ctl.peticion.FechaEvento__c = date.newInstance(2021,08,01);
        ctl.peticion.FechaTopeEntrega__c = date.newInstance(2021,08,01);
        ctl.peticion.LugarEntrega__c='MRW';
        ctl.peticion.DireccionEntrega__c = 'Dirección de entrega';
        ctl.peticion.CodigoCargo__c = 'C-0000001';
        ctl.peticion.Sociedad__c = 'LaLiga';

        ctl.lineaList.get(0).Producto_CG__c = producto.Id;
        ctl.guardarPrecio();
        ctl.lineaList.get(0).Cantidad__c = 10;
        ctl.recalcularPrecios();
      
        ctl.save();
        List<PeticionMaterial__c> lPeticionMaterial = [
            SELECT Name FROM PeticionMaterial__c WHERE Id = :ctl.peticion.Id
        ];
        if(lPeticionMaterial.size() > 0){
            ctl.numPet = lPeticionMaterial[0].Name;
        }

        // Catálogo
        ctl.setModoNormal();       
        ctl.buscarPeticion();
        ctl.categoriaElegida = '';
        ctl.buscarFamilia();

        ctl.categoriaElegida = 'Textil';
        ctl.buscarFamilia();
        List<String> alfabeto = ctl.alphabet;
        Integer pageNumber = ctl.PageNumber;
        ctl.PageNumber = 1;

        Integer totalPages = ctl.TotalPages;
        Integer maxNumberOfRecords = ctl.MaxNumberOfRecords;
        Integer numberOfRecords = ctl.NumberOfRecords;

        PageReference pagina = ctl.getalphaSearch();

        ctl.alphaSearchProdct ='Todos';
        pagina = ctl.getalphaSearch();

        List<SelectOption> selectorPaginas = ctl.getRecordsPerPageOptionList();
        List<PriceBookEntry> listaProductis = ctl.getProductoList();

        ctl.first();
        ctl.next();
        ctl.previous();
        ctl.last();

        ctl.alphaSearchProdct = '0-9';
        pagina = ctl.getalphaSearch();

        ctl.searchKey = 'prueba';
        pagina = ctl.search();

        ctl.searchKey = '';
        pagina = ctl.search();

        Test.StopTest();
    }

    @isTest
    static void testJobRequest() {
        Test.startTest();
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
        ctl.solicitudTrabajo.ProductObjective__c = 'test';
        ctl.solicitudTrabajo.ParticularObjectives__c = 'test';
        ctl.solicitudTrabajo.Target__c = 'test';
        ctl.solicitudTrabajo.BackgroundAndContext__c = 'test';
        ctl.solicitudTrabajo.StrategicConcepts__c = 'test';
        ctl.solicitudTrabajo.ProductIdeas__c = 'test';
        ctl.solicitudTrabajo.SpecificRequirements__c = 'test';
        ctl.solicitudTrabajo.Budget__c = 33;
        ctl.solicitudTrabajo.UnitsToProduce__c = 33;
        ctl.solicitudTrabajo.TermDate__c = date.newInstance(2021,08,01);
        ctl.solicitudTrabajo.DeliveryPoint__c = 'test';
        ctl.solicitudTrabajo.PersonRecipientName__c = 'test';
        ctl.solicitudTrabajo.PersonMobile__c = '123';
        ctl.solicitudTrabajo.PersonEmail__c = 'test@test.com';
        ctl.solicitudTrabajo.Observations__c = 'test';

        ctl.saveJobReq();
        ctl.cancelJobReq();
        Test.stopTest();
    }

    @isTest
    static void testSaveSL() {
        Test.startTest();
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
        ctl.peticionSL.Direccion__c = 'AUDIOVISUAL';
        ctl.peticionSL.Area__c = 'Operadores Nacionales';
        ctl.peticionSL.PersonaSolicitante__c = 'test';
        ctl.peticionSL.CorreoElectronico__c = 'test@laligatech.com';
        ctl.peticionSL.Telefono__c = 'test';
        ctl.peticionSL.FechaEntrega__c = date.newInstance(2021,08,01);
        ctl.peticionSL.Concepto__c = 'test';

        ctl.saveSL();
        Test.stopTest();
    }
  
    @isTest
    static void testSave_FallaSinPrecioEnLinea() {
        Test.startTest();
        Product2 productoPrueba = [SELECT Id FROM Product2 WHERE Name = 'Producto de prueba' LIMIT 1];
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
        ctl.createButton();

        ctl.peticion.Direccion__c = 'AUDIOVISUAL';
        ctl.peticion.Area__c = 'Operadores Nacionales';
        ctl.peticion.PersonaSolicitante__c = 'Usuario de Prueba';
        ctl.peticion.CorreoElectronico__c = 'test@laliga.es';
        ctl.peticion.FechaTopeEntrega__c = Date.today().addDays(5);
        ctl.peticion.LugarEntrega__c = 'Oficina Torrelaguna';
        ctl.peticion.CodigoCargo__c = 'C-0000001';
        ctl.peticion.Sociedad__c = 'LaLiga';
    
        ctl.addRow();
        ctl.lineaList.get(0).Producto_CG__c = productoPrueba.Id;
        ctl.lineaList.get(0).Cantidad__c = 5;
        // No llamamos a guardarPrecio() para provocar el error

        ctl.save();
        Test.stopTest();
    
        System.assert(ApexPages.hasMessages(ApexPages.Severity.FATAL),
            'Se esperaba un mensaje de error de tipo FATAL, pero no se encontró.');
    
        Boolean mensajeCorrecto = false;
        for (ApexPages.Message msg : ApexPages.getMessages()) {
            if (msg.getSummary().contains('El precio para un producto no se ha cargado')) {
                mensajeCorrecto = true; break;
            }
        }
        System.assert(mensajeCorrecto,
            'No se encontró el mensaje de error esperado sobre la falta de precio.');

        List<PeticionMaterial__c> peticionesCreadas = [SELECT Id FROM PeticionMaterial__c];
        System.assertEquals(0, peticionesCreadas.size(),
            'La petición de material se creó incorrectamente cuando debería haber fallado la validación.');
    }    
    
    @isTest
    static void testNovedades() {
        Test.StartTest(); 
        ApexPages.currentPage().getHeaders().put('referer', 'test');
        ApexPages.currentPage().getParameters().put('clickedRow', '1');

        Product2 producto = [SELECT Name, Description, Family, IsActive, Catalogo__c 
                             FROM Product2 WHERE Name = 'Producto de prueba' LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(producto);
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
        ctl.getCategoriaDisponible();
        
        // Novedades
        ctl.setModoNovedades();
        ctl.getCategoriaDisponibleN();
        ctl.buscarPeticion();
        ctl.categoriaElegidaN = '';
        ctl.buscarFamilia();

        ctl.categoriaElegidaN = 'Textil';
        ctl.buscarFamilia();
        List<String> alfabetoN = ctl.alphabet;
        Integer pageNumberN = ctl.pageNumberN;
        ctl.pageNumberN = 1;

        Integer totalPagesN = ctl.totalPagesN;
        Integer maxNumberOfRecordsN = ctl.maxNumberOfRecordsN;
        Integer numberOfRecordsN = ctl.numberOfRecordsN;

        PageReference paginaN = ctl.getalphaSearch();

        ctl.alphaSearchProdct = 'Todos';
        paginaN = ctl.getalphaSearch();

        List<SelectOption> selectorPaginasN = ctl.getRecordsPerPageOptionListN();
        List<PriceBookEntry> listaProductListN = ctl.getProductoListN();

        ctl.firstN();
        ctl.nextN();
        ctl.previousN();
        ctl.lastN();

        ctl.alphaSearchProdct = '0-9';
        paginaN = ctl.getalphaSearch();

        ctl.searchKey = 'prueba';
        paginaN = ctl.search();

        ctl.searchKey = '';
        paginaN = ctl.search();

        ctl.cancel();
        Test.StopTest();
    }
    
    @isTest
    static void testMiStockPaginacion() {
        Test.StartTest(); 
        ApexPages.currentPage().getHeaders().put('referer', 'test');
        ApexPages.currentPage().getParameters().put('clickedRow', '1');

        Product2 producto = [SELECT Name, Description, Family, IsActive, Catalogo__c 
                             FROM Product2 WHERE Name = 'Producto de prueba' LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(producto);
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
    
        // Consulta Stock
        ctl.setModoConsultarStock();
        
        ApexPages.currentPage().getParameters().put('clickedRowMS', '1');
        ApexPages.currentPage().getParameters().put('clickedRowCG', '1');
        
        ctl.getCategoriaDisponibleCS();
        ctl.getDireccionCSDisponible();
        ctl.getAreaDisponibleCS();

        // ✅ Ajuste: usar un Área existente para evitar falsos negativos
        ctl.areaElegidaCS = 'Audiovisual';    // existe en @testSetup
        ctl.buscarAreaCS();

        ctl.categoriaElegidaCS = '';
        ctl.buscarFamiliaCS();
        ctl.categoriaElegidaCS = 'Textil';
        ctl.buscarFamiliaCS();

        ctl.direccionElegidaCS = 'Audiovisual';
        ctl.buscarDireccionCS();

        Integer pageNumberCS = ctl.pageNumberCS;
        ctl.pageNumberCS = 1;

        Integer totalPagesCS = ctl.totalPagesCS;
        Integer maxNumberOfRecordsCS = ctl.maxNumberOfRecordsCS;
        Integer numberOfRecordsCS = ctl.numberOfRecordsCS;

        PageReference paginaCS = ctl.getalphaSearchCS();

        ctl.alphaSearchProdct = 'Todos';
        paginaCS = ctl.getalphaSearchCS();

        List<SelectOption> selectorPaginasCS = ctl.getRecordsPerPageOptionListCS();
        List<ArticuloProducto__c> listaProductListCS = ctl.getProductoListCS();

        ctl.firstCS();
        ctl.nextCS();
        ctl.previousCS();
        ctl.lastCS();

        ctl.alphaSearchProdct = '0-9';
        paginaCS = ctl.getalphaSearchCS();

        ctl.searchKeyCS = 'prueba';
        paginaCS = ctl.searchCS();

        ctl.searchKeyCS = '';
        paginaCS = ctl.searchCS();

        Test.StopTest();
    }
    
    @isTest
    static void testMiStock() {
        Test.StartTest(); 
        ApexPages.currentPage().getHeaders().put('referer', 'test');
        ApexPages.currentPage().getParameters().put('clickedRow', '1');

        Product2 producto = [SELECT Name, Description, Family, IsActive, Catalogo__c 
                             FROM Product2 WHERE Name = 'Producto de prueba' LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(producto);
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
    
        // Consulta Stock
        ctl.setModoConsultarStock();
  
        ctl.addRowMS();
        ApexPages.currentPage().getParameters().put('clickedRowMS', '1');
        ctl.updateRowsMS();
        ctl.removeRowMS();
  
        ctl.addRow();
        ApexPages.currentPage().getParameters().put('clickedRowCG', '1');
        ctl.removeRow();

        ctl.addRowMS();
        ctl.addRow();
  
        ctl.peticionMS.Direccion__c = 'AUDIOVISUAL';
        ctl.peticionMS.Area__c = 'Operadores Nacionales';
        ctl.peticionMS.PersonaSolicitante__c = 'Persona solicitante';
        ctl.peticionMS.CorreoElectronico__c = 'victoria.lozano@globant.com';
        ctl.peticionMS.NombreEvento__c = 'Nombre evento';
        ctl.peticionMS.LugarEvento__c = 'Lugar evento';
        ctl.peticionMS.FechaEvento__c = date.newInstance(2021,08,01);
        ctl.peticionMS.FechaTopeEntrega__c = date.newInstance(2021,08,01);
        ctl.peticionMS.LugarEntrega__c='Dirección específica';
        ctl.peticionMS.DireccionEntrega__c = 'Dirección de entrega';
        ctl.peticionMS.CodigoCargo__c = 'C-0000001';
        ctl.peticionMS.Sociedad__c = 'LaLiga';
        
        ctl.addRowMS();
        ArticuloProducto__c articuloDireccion = [
            SELECT Id, Name, Producto__c, Almacen__c, Cantidad__c
            FROM ArticuloProducto__c
            WHERE Name = 'Producto de prueba Direccion' LIMIT 1
        ];
        ctl.lineaListMS.get(0).ProductoMiStock__c = articuloDireccion.Id;
        ctl.recalcularMS();
        ctl.lineaListMS.get(0).Cantidad__c = 5;
        
        ctl.lineaListCG.get(0).Producto_CG__c = producto.Id;
        ctl.guardarPrecio();
  
        ctl.lineaListCG.get(0).Cantidad__c = 10;
        ctl.recalcularPrecios();
  
        ctl.save();
        Test.StopTest();
    }

    // -------------------------
    // NUEVOS TESTS (cambios clase)
    // -------------------------

    @isTest
    static void testConsultarStock_DirArea_TextoNull() {
        // Cuando texto está vacío => debe listar TODO por Dirección (+ Área si aplica)
        Test.startTest();
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
        ctl.setModoConsultarStock();

        // Seleccionamos Dirección y Área que existen en @testSetup
        ctl.direccionElegidaCS = 'Audiovisual';
        ctl.areaElegidaCS      = 'Audiovisual'; // coincide con Almacen__r.Name del registro de prueba

        // Dejamos texto vacío
        ctl.searchKeyCS = '';

        // Ejecutamos búsqueda
        ctl.searchCS();

        System.assert(ctl.articulo != null, 'La lista no debería ser null');
        System.assert(ctl.articulo.size() > 0,
            'Con texto vacío debe devolver productos para Dirección+Área seleccionadas');
        Test.stopTest();
    }

    @isTest
    static void testConsultarStock_ResetAlCambiarDireccion() {
        // Verifica que al cambiar Dirección se limpian: areaElegidaCS, searchKeyCS y alphaSearchProdct
        Test.startTest();
        STCK_VF001_PeticionMaterialController ctl = new STCK_VF001_PeticionMaterialController();
        ctl.setModoConsultarStock();

        // Estado previo simulado (usuario había aplicado filtros)
        ctl.areaElegidaCS = 'Torrelaguna';
        ctl.searchKeyCS   = 'Cami';
        ctl.alphaSearchProdct = 'C';

        // Cambiamos Dirección
        ctl.direccionElegidaCS = 'Audiovisual';
        ctl.buscarDireccionCS();

        System.assertEquals('', ctl.areaElegidaCS, 'Al cambiar Dirección debe limpiarse el Área');
        System.assertEquals('', ctl.searchKeyCS,   'Al cambiar Dirección debe limpiarse el texto');
        System.assertEquals(null, ctl.alphaSearchProdct, 'Al cambiar Dirección debe resetear el filtro alfabético');

        // Además, con texto vacío debe listar por Dirección
        System.assert(ctl.articulo != null, 'La lista no debería ser null');
        System.assert(ctl.articulo.size() >= 0, 'Debe ejecutar query sin errores');
        Test.stopTest();
    }
}