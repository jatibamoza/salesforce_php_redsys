public without sharing class STCK_VF001_PeticionMaterialController {

    //list<PriceBookEntry> producto = [SELECT Product2.Name, Product2.Description, Product2.Family, Product2.Imagen__c, UnitPrice FROM PriceBookEntry WHERE Pricebook2.name = 'Departamento de produccion' AND Product2.Catalogo__c = true ORDER BY Product2.Name ASC]; 

    private final static String PAGE_NUMBER5 = '5';
    private final static String PAGE_NUMBER10 = '10';
    private final static String PAGE_NUMBER15 = '15';
    private final static String PAGE_NUMBER20 = '20';
    private final static String PAGE_NUMBER25 = '25';
    private final static String PAGE_NUMBER50 = '50';
    private final static String PAGE_NUMBER100 = '100';
    private final static String PAGE_NUMBER200 = '200';
    
    public PeticionMaterial__c peticionConsulta {get;set;}
    public PeticionMaterial__c peticion {get;set;}
    public STCK_JobRequest__c solicitudTrabajo {get;set;}
    public transient  blob file { get; set; }
    public List<LineaPeticionMaterial__c> lineaList {get; set;}
    public Map<Id,Double> productPriceMap;

    public STCK_SolicitudLogistica__c peticionSL {get;set;}
    
    public String numPet {get;set;}
    public boolean queryMode{get;set;}
    public boolean createMode{get;set;}
    public String categoriaElegida {get;set;}
    public String categoriaElegidaN {get;set;}
    public String referidor{get; set;}
    public boolean accesoPermitido{get; set;}
    public String searchKey {get;set;}
    public String searchKeyN {get;set;}
    public String modo;
    public Boolean banderaModo;
    


    //Inicio novedades
    
    public String productQuery          = 'SELECT Product2.Name, Product2.Description, Product2.Family, Product2.Imagen__c, UnitPrice, Product2.NombreAuxiliar__c ' +
                                          'FROM PriceBookEntry ' +
                                          'WHERE Pricebook2.name = \'Departamento de produccion\' AND '+
                                          'Product2.StockActual__c > 0 AND '+
                                          'Product2.IsActive = true AND '+        
                                          'Product2.Catalogo__c = true ';
    Public String familySearchClauseBgn = 'AND Product2.Family = \'';
    Public String familySearchClauseEnd = '\' ';
    Public String searchClauseBgn       = 'AND Product2.Name Like \'%';
    Public String searchClauseEnd       = '%\' ';
    Public String numSearchClauseBgn    = 'AND ((Name <=\'9\' AND Name >=\'0\') OR Name Like \'9%\') ';
    Public String alphaSearchClauseBgn  = 'AND Product2.Name Like \'';
    Public String newsSearchClause  = '';
    public String orderClause           = 'ORDER BY Product2.Name ASC';
    public list<PriceBookEntry> producto{get;set;}
    
   //Fin novedades
   
   //Inicio Consultar Stock

    public String articuloQuery =   'SELECT Producto__r.name, Producto__r.Description, Producto__r.Family, Cantidad__c, Imagen__c, Almacen__r.Name ' +
                                    'FROM ArticuloProducto__c ';
   
    public String direccionElegidaCS {get;set;}
    public String categoriaElegidaCS {get;set;}
    public String areaElegidaCS {get;set;}
    
    public list<ArticuloProducto__c> articulo{get;set;}    
    
    public String searchKeyCS {get;set;}
    
	Public String direccionDummySearch      = 'WHERE Producto__r.IsActive = true AND Producto__r.Catalogo__c = true AND Cantidad__c > 0 AND Id = \'000000000000000000\'';
        
	Public String direccionSearchClauseBgn  = 'WHERE Producto__r.IsActive = true AND Producto__r.Catalogo__c = true AND Cantidad__c > 0 AND Almacen__r.STCK_Direccion__c = \'';
    Public String direccionSearchClauseEnd  = '\' ';
    Public String direccionOrderClause      = 'ORDER BY Producto__r.name ASC';
    Public String familyCSSearchClauseBgn = 'AND Producto__r.Family = \'';
    Public String areaCSSearchClauseBgn = 'AND Almacen__r.Name = \'';
    Public String searchCSClauseBgn       = 'AND Producto__r.Name Like \'%';
    Public String alphaCSSearchClauseBgn  = 'AND Producto__r.Name Like \'';
    
    public PeticionMaterial__c peticionMS {get;set;}
    public PeticionMaterial__c peticionTemporal {get;set;}
    public List<LineaPeticionMaterial__c> lineaListMS {get; set;}
    public List<LineaPeticionMaterial__c> lineaListCG {get; set;}
        
   //Fin Consultar Stock

    public ApexPages.StandardSetController stdSetController{            //Instantiating a standard set controller
        get{
            if(stdSetController==null){
                 stdSetController = new ApexPages.StandardSetController(producto);
                 System.debug('stdSetControllerProd: ' + producto);
            }
            stdSetController.setPageSize(recordsPerPageslist);      //Limiting Number of records to be displayed per page
            System.debug('------ seteando stdSetController');
            return stdSetController;   
        }
        set;
    }

    public ApexPages.StandardSetController stdSetControllerN{            //Instantiating a standard set controller
        get{
            if(stdSetControllerN==null){
                 stdSetControllerN = new ApexPages.StandardSetController(producto);
            }
            stdSetControllerN.setPageSize(recordsPerPageslistN);      //Limiting Number of records to be displayed per page 
            System.debug('------ seteando stdSetControllerN');
            return stdSetControllerN;   
        }
        set;
    }
    public ApexPages.StandardSetController stdSetControllerCS{            //Instantiating a standard set controller
        get{
            if(stdSetControllerCS==null){
                 stdSetControllerCS = new ApexPages.StandardSetController(articulo);
            }
            stdSetControllerCS.setPageSize(recordsPerPageslistCS);      //Limiting Number of records to be displayed per page 
            System.debug('------ seteando stdSetControllerCS');
            return stdSetControllerCS;   
        }
        set;
    }    
    public Integer recordsPerPageslist{ 
        get;set{                                                        //To select number of records per page
            System.debug('------ setRecordsPerPageslist: ' + value);
            if(value!=null){
                this.recordsPerPageslist=value;
                System.debug('------ this.recordsPerPageslist:'+this.recordsPerPageslist);
            }
        }
    }

    public Integer recordsPerPageslistN{ 
        get;set{                                                        //To select number of records per page
            System.debug('------ setRecordsPerPageslistN: ' + value);
            if(value!=null){
                this.recordsPerPageslistN=value;
                System.debug('------ this.recordsPerPageslistN:' + this.recordsPerPageslistN);
            }
        }
    }

    public Integer recordsPerPageslistCS{ 
        get;set{                                                        //To select number of records per page
            System.debug('------ setRecordsPerPageslistCS: ' + value);
            if(value!=null){
                this.recordsPerPageslistCS=value;
                System.debug('------ this.recordsPerPageslistCS:' + this.recordsPerPageslistCS);
            }
        }
    }
    
    public string clickedRow{
        get{
            clickedRow =  ApexPages.CurrentPage().getParameters().get('clickedRow');
            return clickedRow;
        }
        set;
    }

    public string clickedRowMS{
        get{
            clickedRowMS =  ApexPages.CurrentPage().getParameters().get('clickedRowMS');
            return clickedRowMS;
        }
        set;
    }

    public string clickedRowCG{
        get{
            clickedRowCG =  ApexPages.CurrentPage().getParameters().get('clickedRowCG');
            return clickedRowCG;
        }
        set;
    }
    
    public string productSelected{
        get{
            productSelected =  ApexPages.CurrentPage().getParameters().get('productSelected');
            return productSelected;
        }
        set;
    }
    
    public STCK_VF001_PeticionMaterialController(){
        String allProductsSearchSpec = productQuery + orderClause;
        System.debug('------ allProductsSearchSpec: ' + allProductsSearchSpec);
        //producto = Database.query (allProductsSearchSpec);
        list<PricebookEntry>  listaPreciosTest = new List<PricebookEntry>();
        list<PricebookEntry>  listaPrecios = Database.query (allProductsSearchSpec);
        List<String> nombreProductos = new List<String>();
        for(PricebookEntry pb : listaPrecios){
                System.debug('auxName: ' + pb.Product2.NombreAuxiliar__c);
                if(!nombreProductos.contains(pb.Product2.NombreAuxiliar__c) && pb.Product2.NombreAuxiliar__c != null){
                    nombreProductos.add(pb.Product2.NombreAuxiliar__c);
                    listaPreciosTest.add(pb);
                }else if(!nombreProductos.contains(pb.Product2.name) && pb.Product2.NombreAuxiliar__c == null){
                    listaPreciosTest.add(pb);
                    nombreProductos.add(pb.Product2.name);
                }
        }
        producto = listaPreciosTest;
        System.debug('------ listaPreciosTest: ' + listaPreciosTest);
        System.debug('------ producto: ' + producto);
       
        recordsPerPageslist     = Integer.valueOf(PAGE_NUMBER10);
        recordsPerPageslistN    = Integer.valueOf(PAGE_NUMBER10);
        recordsPerPageslistCS   = Integer.valueOf(PAGE_NUMBER5);
            
        accesoPermitido = true;
        referidor = ApexPages.currentPage().getHeaders().get('Referer');
        System.debug('------ Referidor: '+referidor);
        
        if (referidor!=null)
        {
            System.debug('------ Consultando referidores permitidos en la metadata');
            List<STCK_AllowedReferer__mdt> allowedList = STCK_AllowedReferer__mdt.getall().values();
        
            System.debug('------ Registros obtenidos');
            for (STCK_AllowedReferer__mdt allowed : allowedList) {
                System.debug('------ Iterando referidor Id: ' + allowed.Id + ' DeveloperName: ' + allowed.DeveloperName + ' MasterLabel: ' + allowed.MasterLabel + ' Label: ' + allowed.Label + ' Domain__c: ' + allowed.Domain__c);
                accesoPermitido=referidor.contains(allowed.Domain__c)||accesoPermitido;
            }
            System.debug('------ Todos los referidores procesados.');
        }

        System.debug('------ accesoPermitido: '+accesoPermitido);

        categoriaElegida = '';
        categoriaElegidaN = '';
        categoriaElegidaCS = '';
        areaElegidaCS = '';
        searchKey = '';
        searchKeyN = '';
        searchKeyCS = '';
        newsSearchClause = ' ';
        modo='Normal';
            
        articulo = Database.query (articuloQuery + direccionDummySearch);
        
        numPet = Apexpages.currentPage().getParameters().get('numPet');
        if (String.isBlank(numPet)){
            peticion= new PeticionMaterial__c();
            lineaList = new List<LineaPeticionMaterial__c>();
            addRow();
        }
        solicitudTrabajo = new STCK_JobRequest__c();
        peticionSL = new STCK_SolicitudLogistica__c();
        
    }

    public List<SelectOption> getCategoriaDisponible(){

        return consultarCategoriaDisponible(false);
    }

    public List<SelectOption> getCategoriaDisponibleN(){

        return consultarCategoriaDisponible(true);
    }

    public List<SelectOption> getDireccionCSDisponible(){

        return consultarDireccionDisponible();
    }

    public List<SelectOption> getCategoriaDisponibleCS(){

        return consultarCategoriaDisponibleCS();
    }
    //Area picklist
public List<SelectOption> getAreaDisponibleCS() {
    System.debug('------ Buscando áreas disponibles en Location para la Dirección: ' + direccionElegidaCS);

    List<SelectOption> options = new List<SelectOption>();

    if (direccionElegidaCS != null && direccionElegidaCS != '') {
        try {
            // Consulta SOQL con el prefijo Schema para evitar conflicto de nombres
            List<Schema.Location> almacenes = [
                SELECT Name 
                FROM Location 
                WHERE STCK_Direccion__c = :direccionElegidaCS
                AND Activo__c = true
                ORDER BY Name ASC
            ];

            // Agregamos la opción inicial
            options.add(new SelectOption('', '-- Selecciona un Área --'));

            // Agregamos cada área encontrada en la lista de opciones
            for (Schema.Location almacen : almacenes) {
                options.add(new SelectOption(almacen.Name, almacen.Name));
            }
            System.debug('------ Áreas obtenidas: ' + almacenes);

        } catch (Exception e) {
            System.debug('Error en getAreaDisponibleCS: ' + e.getMessage());
        }
    } else {
        options.add(new SelectOption('', '-- Selecciona una Dirección Primero --'));
    }

    return options;
}



    
    public List<SelectOption> consultarCategoriaDisponible(Boolean novedades){

        System.debug('------ Buscando categoría');
        String searchspec = '';
        if (novedades)
            searchspec = productQuery + 'AND Product2.STCK_Novedad__c = true AND Product2.Family <> null ORDER BY Product2.Family ASC';
        else
            searchspec = productQuery + 'AND Product2.Family <> null ORDER BY Product2.Family ASC';
        System.debug('------ searchSpec: ' + searchSpec);
        List<PriceBookEntry> productoFamilia = new List<PriceBookEntry>();
        Map<String,String> prodNameMap = new Map<String,String>();
        productoFamilia = Database.query (searchSpec);
        
        for (PriceBookEntry prod: productoFamilia){
            prodNameMap.put(prod.Product2.Family,prod.Product2.Family);
        }
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        for (String key : prodNameMap.keySet()) {
            options.add(new SelectOption(prodNameMap.get(key), prodNameMap.get(key)));
        }
        
        return options;
    }

    public List<SelectOption> consultarDireccionDisponible(){

        System.debug('------ Buscando direcciones');
        String searchspec = 'SELECT Name ' +
                            'FROM Location ' +
                            'WHERE LocationType = \'Virtual\' '+
                            'AND Activo__c = true ' +
                    'ORDER BY Name ASC';

        List<Schema.Location> direccionesList = new List<Schema.Location>();
        Map<String,String> direccionMap = new Map<String,String>();

        
        Schema.DescribeFieldResult direccionesPicklist = Location.STCK_Direccion__c.getDescribe();
        List<Schema.PicklistEntry> direccionesListEntries = direccionesPicklist.getPicklistValues();
        
        for( Schema.PicklistEntry direccionesListEntry : direccionesListEntries) {
            direccionMap.put(direccionesListEntry.getValue(),direccionesListEntry.getLabel());
        }

        /*Duda 1 y 2
         * direccionesList = Database.query (searchSpec);
       
        for (Schema.Location direccion: direccionesList){
            direccionMap.put(direccion.Name,direccion.Name);
        }*/
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        for (String key : direccionMap.keySet()) {
            options.add(new SelectOption(direccionMap.get(key), direccionMap.get(key)));
        }
        
        return options;
    }

    public List<SelectOption> consultarCategoriaDisponibleCS(){

        List<SelectOption> options = new List<SelectOption>();
        
        if (direccionElegidaCS <> null){
            System.debug('------ Buscando categoría');
            String searchspec = articuloQuery + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd + 'AND Producto__r.Family <> null ' + direccionOrderClause;
            
            System.debug('------ searchSpec: ' + searchSpec);
            List<ArticuloProducto__c> articuloFamilia = new List<ArticuloProducto__c>();
            Map<String,String> articuloMap = new Map<String,String>();
            articuloFamilia = Database.query (searchSpec);
            
            for (ArticuloProducto__c articulo: articuloFamilia){
                articuloMap.put(articulo.Producto__r.Family,articulo.Producto__r.Family);
            }
            
            options.add(new SelectOption('', ''));
            for (String key : articuloMap.keySet()) {
                options.add(new SelectOption(articuloMap.get(key), articuloMap.get(key)));
            }
        }
        
        return options;
    }
    
    public List<SelectOption> consultarAreaDisponibleCS(){

        List<SelectOption> options = new List<SelectOption>();
        
        if (direccionElegidaCS <> null){
            System.debug('------ Buscando Area');
            String searchspec = articuloQuery + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd + 'AND Almacen__r.Name <> null ' + direccionOrderClause;
            
            System.debug('------ searchSpec: ' + searchSpec);
            List<ArticuloProducto__c> articuloFamilia = new List<ArticuloProducto__c>();
            Map<String,String> articuloMap = new Map<String,String>();
            articuloFamilia = Database.query (searchSpec);
            
            for (ArticuloProducto__c articulo: articuloFamilia){
                articuloMap.put(articulo.Almacen__r.Name,articulo.Almacen__r.Name);
            }
            
            options.add(new SelectOption('', ''));
            for (String key : articuloMap.keySet()) {
                options.add(new SelectOption(articuloMap.get(key), articuloMap.get(key)));
            }
        }
        
        return options;
    }
    
    public Pagereference search(){
        
        System.debug('------ ejecutando búsqueda');
        String searchSpec;
        String formatSearchKey = ( searchKey != '' && searchKey != null )?searchKey:searchKeyN;
            
        if (formatSearchKey!=''){
            searchSpec = productQuery +  searchClauseBgn + formatSearchKey + searchClauseEnd + newsSearchClause + orderClause;
            System.debug('------ searchSpec A: ' + searchSpec);
        }
        else{
            searchSpec = productQuery + newsSearchClause + orderClause;
            System.debug('------ searchSpec B: ' + searchSpec);
        }
        
        //producto = Database.query (searchSpec);

        list<PricebookEntry>  listaPreciosTest = new List<PricebookEntry>();
        list<PricebookEntry>  listaPrecios = Database.query (searchSpec);
        List<String> nombreProductos = new List<String>();
        for(PricebookEntry pb : listaPrecios){
                System.debug('auxName: ' + pb.Product2.NombreAuxiliar__c);
                if(!nombreProductos.contains(pb.Product2.NombreAuxiliar__c) && pb.Product2.NombreAuxiliar__c != null){
                    nombreProductos.add(pb.Product2.NombreAuxiliar__c);
                    listaPreciosTest.add(pb);
                }else if(!nombreProductos.contains(pb.Product2.name) && pb.Product2.NombreAuxiliar__c == null){
                    listaPreciosTest.add(pb);
                    nombreProductos.add(pb.Product2.name);
                }
        }
        producto = listaPreciosTest;
        System.debug('------ listaPreciosTest: ' + listaPreciosTest);
        System.debug('------ producto: ' + producto);

        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(producto);
        if (modo=='Normal')
            stdSetController= ssc;
        else
            stdSetControllerN= ssc;
        return null;
    }

    public Pagereference searchCS(){
        System.debug('------ ejecutando búsqueda');
        String searchSpec;

        if (!String.isBlank(direccionElegidaCS)) {

            // Base: siempre por Dirección
            searchSpec = articuloQuery
                    + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd;

            // Si hay Área, añadir filtro
            if (!String.isBlank(areaElegidaCS)) {
                searchSpec += areaCSSearchClauseBgn + areaElegidaCS + familySearchClauseEnd;
            }

            // Si hay texto, añadirlo (arreglando el bug de concatenación)
            if (!String.isBlank(searchKeyCS)) {
                searchSpec += searchCSClauseBgn + searchKeyCS + searchClauseEnd;
            }

            searchSpec += direccionOrderClause;
            System.debug('------ searchSpec (CS): ' + searchSpec);

        } else {
            // Sin Dirección: dummy para no devolver nada
            searchSpec = articuloQuery + direccionDummySearch;
            System.debug('------ searchSpec dummy (sin dir): ' + searchSpec);
        }

        articulo = Database.query(searchSpec);
        stdSetControllerCS = new ApexPages.StandardSetController(articulo);
        return null;
    }

    
    public Pagereference buscarFamilia(){
        
        System.debug('------ Búsqueda por familia');
        searchKey = '';
        searchKeyN = '';
        String searchSpec;
        String formatCategoriaElegida = ( categoriaElegida != '' && categoriaElegida != null )?categoriaElegida:categoriaElegidaN;
        
        if ( formatCategoriaElegida != '' && formatCategoriaElegida  != null ){
            searchSpec = productQuery +  familySearchClauseBgn + formatCategoriaElegida + familySearchClauseEnd + newsSearchClause + orderClause;
            System.debug('------ searchSpec: ' + searchSpec);
        }
        else{
            searchSpec = productQuery + newsSearchClause + orderClause;
            System.debug('------ allProductsSearchSpec: ' + searchSpec);
        }
        
        //producto = Database.query (searchSpec);

        list<PricebookEntry>  listaPreciosTest = new List<PricebookEntry>();
        list<PricebookEntry>  listaPrecios = Database.query (searchSpec);
        List<String> nombreProductos = new List<String>();
        for(PricebookEntry pb : listaPrecios){
                System.debug('auxName: ' + pb.Product2.NombreAuxiliar__c);
                if(!nombreProductos.contains(pb.Product2.NombreAuxiliar__c) && pb.Product2.NombreAuxiliar__c != null){
                    nombreProductos.add(pb.Product2.NombreAuxiliar__c);
                    listaPreciosTest.add(pb);
                }else if(!nombreProductos.contains(pb.Product2.name) && pb.Product2.NombreAuxiliar__c == null){
                    listaPreciosTest.add(pb);
                    nombreProductos.add(pb.Product2.name);
                }
        }
        producto = listaPreciosTest;
        System.debug('------ listaPreciosTest: ' + listaPreciosTest);
        System.debug('------ producto: ' + producto);



        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(producto);

        if (modo=='Normal')
            stdSetController= ssc;
        else
            stdSetControllerN= ssc;
        return null;
    }

    public Pagereference buscarDireccionCS() {
        System.debug('------ Dirección seleccionada: ' + direccionElegidaCS);

        // Reset de estado al cambiar Dirección
        searchKey = '';
        searchKeyN = '';
        searchKeyCS = '';
        alphaSearchProdct = null; // Reset alfabético
        areaElegidaCS = '';       // limpiar Área

        String searchSpec;
        if (!String.isBlank(direccionElegidaCS)) {
            // Listar TODO por Dirección (sin texto, sin área)
            searchSpec = articuloQuery
                    + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd
                    + direccionOrderClause;
            System.debug('------ searchSpec (dir): ' + searchSpec);
        } else {
            searchSpec = articuloQuery + direccionDummySearch;
            System.debug('------ allProductsSearchSpec: ' + searchSpec);
        }

        try {
            articulo = Database.query(searchSpec);
            stdSetControllerCS = new ApexPages.StandardSetController(articulo);
            System.debug('------ Registros encontrados: ' + articulo.size());
        } catch (Exception e) {
            System.debug('Error en buscarDireccionCS: ' + e.getMessage());
        }
        return null;
    }

    
    public Pagereference buscarFamiliaCS(){
        
        System.debug('------ Búsqueda por familia');
        searchKey = '';
        searchKeyN = '';
        String searchSpec;

        if ( categoriaElegidaCS != '' && categoriaElegidaCS  != null ){
            searchSpec = articuloQuery + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd +  familyCSSearchClauseBgn + categoriaElegidaCS + familySearchClauseEnd + direccionOrderClause;
            System.debug('------ searchSpec: ' + searchSpec);
            articulo = Database.query (searchSpec);
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(articulo);
    
            stdSetControllerCS= ssc;
        }
        
        return null;
    }

    public Pagereference buscarAreaCS(){
        System.debug('------ Búsqueda por área');
        searchKey = '';
        searchKeyN = '';
        searchKeyCS = '';
        alphaSearchProdct = null; // Reset alfabético

        String searchSpec;

        if (!String.isBlank(direccionElegidaCS) && !String.isBlank(areaElegidaCS)) {
            // Dirección + Área, sin texto: listar TODO de esa combinación
            searchSpec = articuloQuery
                    + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd
                    + areaCSSearchClauseBgn + areaElegidaCS + familySearchClauseEnd
                    + direccionOrderClause;
            System.debug('------ searchSpec (dir+area): ' + searchSpec);
            articulo = Database.query(searchSpec);
            stdSetControllerCS = new ApexPages.StandardSetController(articulo);
        } else if (!String.isBlank(direccionElegidaCS) && String.isBlank(areaElegidaCS)) {
            // Solo Dirección (Área vacía)
            searchSpec = articuloQuery
                    + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd
                    + direccionOrderClause;
            System.debug('------ searchSpec (solo dir): ' + searchSpec);
            articulo = Database.query(searchSpec);
            stdSetControllerCS = new ApexPages.StandardSetController(articulo);
        } else {
            System.debug('------ Dirección no seleccionada');
        }
        return null;
    }
    

    public void setModoNormal(){
        System.debug('------ Modo normal');
        modo='Normal';
        
        categoriaElegida = '';
        categoriaElegidaN = '';
        searchKey = '';
        searchKeyN = '';
        newsSearchClause = ' ';
        
        search();
    }
    
    public void setModoNovedades(){
        
        System.debug('------ Modo novedades');
        modo='Novedades';
        
        categoriaElegida = '';
        categoriaElegidaN = '';
        searchKey = '';
        searchKeyN = '';

        newsSearchClause = 'AND Product2.STCK_Novedad__c = true ';
        search();
    }

    public void setModoSolicitudes(){
        System.debug('------ Modo solicitudes');
        modo='solicitudes';
    }
        
    public void setModoConsultarStock(){
        
        System.debug('------ Modo consultar stock');
        modo='consultarStock';
        banderaModo = false;
        
        direccionElegidaCS = '';
        categoriaElegidaCS = '';
        areaElegidaCS = '';
        searchKeyCS = '';

        getPricesMap();
        
        peticionMS = new PeticionMaterial__c();
        
        peticionTemporal = new PeticionMaterial__c();
        peticionTemporal.Temporal__c            = true;
        peticionTemporal.Direccion__c           = 'AUDIOVISUAL';
        peticionTemporal.PersonaSolicitante__c  = 'Temporal';
        peticionTemporal.CorreoElectronico__c   = 'test@laliga.es';
        peticionTemporal.FechaTopeEntrega__c    = date.newinstance(1980, 1, 1);
        peticionTemporal.LugarEntrega__c        = 'Oficina Torrelaguna';
        peticionTemporal.CodigoCargo__c         = '99999999';
        peticionTemporal.Sociedad__c            = 'LaLiga';
        insert peticionTemporal;
        
        lineaListMS = new List<LineaPeticionMaterial__c>();
        lineaListCG = new List<LineaPeticionMaterial__c>();
    }
    
    public list<String> alphabet{
        get{                                                                                                                    //To display a list of alphabets on vf page 
            alphabet = new list<string>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0-9','Todos'};
            return alphabet;
        }
        set;
    }
    
    public String alphaSearchProdct{get;set;}                           // To get commandlink parameter for alphabet selected

    public Pagereference getalphaSearch(){                              //To update product list as per the alphabet selected by the user
        
        categoriaElegida = '';
        categoriaElegidaN = '';
        searchKey = '';
        searchKeyN = '';
        
        String searchSpec;
        
        if (alphaSearchProdct=='Todos'){
            searchSpec = (productQuery + newsSearchClause + orderClause);
            System.debug('------ allProductsSearchSpec: ' + searchSpec);
        }
        else if (alphaSearchProdct=='0-9'){
            searchSpec = productQuery + numSearchClauseBgn + newsSearchClause + orderClause;
            System.debug('------ 0-9SearchSpec: ' + searchSpec);
            }
            else{
                searchSpec = productQuery +  alphaSearchClauseBgn + alphaSearchProdct + searchClauseEnd + newsSearchClause + orderClause;
                System.debug('------ alphaSearchProdctSearchSpec: ' + searchSpec);
            }

        //producto = Database.query (searchSpec);

        list<PricebookEntry>  listaPreciosTest = new List<PricebookEntry>();
        list<PricebookEntry>  listaPrecios = Database.query (searchSpec);
        List<String> nombreProductos = new List<String>();
        for(PricebookEntry pb : listaPrecios){
                System.debug('auxName: ' + pb.Product2.NombreAuxiliar__c);
                if(!nombreProductos.contains(pb.Product2.NombreAuxiliar__c) && pb.Product2.NombreAuxiliar__c != null){
                    nombreProductos.add(pb.Product2.NombreAuxiliar__c);
                    listaPreciosTest.add(pb);
                }else if(!nombreProductos.contains(pb.Product2.name) && pb.Product2.NombreAuxiliar__c == null){
                    listaPreciosTest.add(pb);
                    nombreProductos.add(pb.Product2.name);
                }
        }
        producto = listaPreciosTest;
        System.debug('------ listaPreciosTest: ' + listaPreciosTest);
        System.debug('------ producto: ' + producto);



        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(producto);
        if (modo=='Normal')
            stdSetController= ssc;
        else
            stdSetControllerN= ssc;
        return null;
    }

    public Pagereference getalphaSearchCS(){                              //To update product list as per the alphabet selected by the user
        
        categoriaElegidaCS = '';
        areaElegidaCS = '';
        searchKeyCS = '';

        String searchSpec;

        if ( direccionElegidaCS != '' && direccionElegidaCS != null ){
    
            if (alphaSearchProdct=='Todos'){
                searchSpec = (articuloQuery + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd + direccionOrderClause);
                System.debug('------ allProductsSearchSpec CS: ' + searchSpec);
            }
            else if (alphaSearchProdct=='0-9'){
                searchSpec = articuloQuery + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd + numSearchClauseBgn + direccionOrderClause;
                System.debug('------ 0-9SearchSpec CS: ' + searchSpec);
                }
                else{
                    searchSpec = articuloQuery + direccionSearchClauseBgn + direccionElegidaCS + direccionSearchClauseEnd +  alphaCSSearchClauseBgn + alphaSearchProdct + searchClauseEnd + direccionOrderClause;
                    System.debug('------ alphaSearchProdctSearchSpec CS: ' + searchSpec);
                }
            articulo = Database.query (searchSpec);
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(articulo);
            stdSetControllerCS= ssc;
        }else{
            System.debug('------ direccionElegidaCS vacía');
        }
        
        
        return null;
    }
    
    public Integer pageNumber{
        get{                                                            //To get current page number
            this.pageNumber=stdSetController.getPageNumber();
            return this.pageNumber;
        }
        set{                                                            // To navigate to the page number entered by the user
            stdSetController.setPageNumber(value);
        }
    }

    public Integer pageNumberN{
        get{                                                            //To get current page number
            this.pageNumberN=stdSetControllerN.getPageNumber();
            return this.pageNumberN;
        }
        set{                                                            // To navigate to the page number entered by the user
            stdSetControllerN.setPageNumber(value);
        }
    }

    public Integer pageNumberCS{
        get{                                                            //To get current page number
            this.pageNumberCS=stdSetControllerCS.getPageNumber();
            return this.pageNumberCS;
        }
        set{                                                            // To navigate to the page number entered by the user
            stdSetControllerCS.setPageNumber(value);
        }
    }
    
    public Integer totalPages{                                          // Total number of pages as per user selection of Records per page
        get{
            if(stdSetController.getResultSize() <=1){
                  this.totalPages=1;
            }
            if(Math.Mod(stdSetController.getResultSize() ,stdSetController.getPageSize()) == 0){
                this.totalPages =(stdSetController.getResultSize()/stdSetController.getPageSize());
            }
            else{
                this.totalPages = (stdSetController.getResultSize()/stdSetController.getPageSize())+1;
            }
            System.Debug(this.totalPages);
            return totalpages;
        }
        set;
    }
    
    public Integer totalPagesN{                                          // Total number of pages as per user selection of Records per page
        get{
            if(stdSetControllerN.getResultSize() <=1){
                  this.totalPagesN=1;
            }
            if(Math.Mod(stdSetControllerN.getResultSize() ,stdSetControllerN.getPageSize()) == 0){
                this.totalPagesN =(stdSetControllerN.getResultSize()/stdSetControllerN.getPageSize());
            }
            else{
                this.totalPagesN = (stdSetControllerN.getResultSize()/stdSetControllerN.getPageSize())+1;
            }
            System.Debug(this.totalPagesN);
            return totalpagesN;
        }
        set;
    }

    public Integer totalPagesCS{                                          // Total number of pages as per user selection of Records per page
        get{
            if(stdSetControllerCS.getResultSize() <=1){
                  this.totalPagesCS=1;
            }
            if(Math.Mod(stdSetControllerCS.getResultSize() ,stdSetControllerCS.getPageSize()) == 0){
                this.totalPagesCS =(stdSetControllerCS.getResultSize()/stdSetControllerCS.getPageSize());
            }
            else{
                this.totalPagesCS = (stdSetControllerCS.getResultSize()/stdSetControllerCS.getPageSize())+1;
            }
            System.Debug(this.totalPagesCS);
            return totalpagesCS;
        }
        set;
    }
    
    public Integer maxNumberOfRecords{                                  //Maximum number of records in a query list
        get{
            return stdSetController.getRecords().size();
        }
        set;
    }
    
    public Integer maxNumberOfRecordsN{                                  //Maximum number of records in a query list
        get{
            return stdSetControllerN.getRecords().size();
        }
        set;
    }

    public Integer maxNumberOfRecordsCS{                                  //Maximum number of records in a query list
        get{
            return stdSetControllerCS.getRecords().size();
        }
        set;
    }

    
    public Integer numberOfRecords{                                    //Number of records in a query list
        get{
            return stdSetController.getResultSize();
        }
        set;
    }

    public Integer numberOfRecordsN{                                    //Number of records in a query list
        get{
            return stdSetControllerN.getResultSize();
        }
        set;
    }

    public Integer numberOfRecordsCS{                                    //Number of records in a query list
        get{
            return stdSetControllerCS.getResultSize();
        }
        set;
    }
    
    public list<SelectOption> getRecordsPerPageOptionList(){            //To display a drop down list on vf page  
        list<SelectOption>  options = new list<SelectOption>();
        options.add(new selectOption(PAGE_NUMBER10,PAGE_NUMBER10));
        options.add(new selectOption(PAGE_NUMBER25,PAGE_NUMBER25));
        options.add(new selectOption(PAGE_NUMBER50,PAGE_NUMBER50));
        options.add(new selectOption(PAGE_NUMBER100,PAGE_NUMBER100));
        options.add(new selectOption(PAGE_NUMBER200,PAGE_NUMBER200));
        return options;
    }

    public list<SelectOption> getRecordsPerPageOptionListN(){            //To display a drop down list on vf page  
        list<SelectOption>  options = new list<SelectOption>();
        options.add(new selectOption(PAGE_NUMBER10,PAGE_NUMBER10));
        options.add(new selectOption(PAGE_NUMBER25,PAGE_NUMBER25));
        options.add(new selectOption(PAGE_NUMBER50,PAGE_NUMBER50));
        options.add(new selectOption(PAGE_NUMBER100,PAGE_NUMBER100));
        options.add(new selectOption(PAGE_NUMBER200,PAGE_NUMBER200));
        return options;
    }

    public list<SelectOption> getRecordsPerPageOptionListCS(){            //To display a drop down list on vf page  
        list<SelectOption>  options = new list<SelectOption>();
        options.add(new selectOption(PAGE_NUMBER5,PAGE_NUMBER5));
        options.add(new selectOption(PAGE_NUMBER10,PAGE_NUMBER10));
        options.add(new selectOption(PAGE_NUMBER15,PAGE_NUMBER15));
        options.add(new selectOption(PAGE_NUMBER20,PAGE_NUMBER20));
        options.add(new selectOption(PAGE_NUMBER25,PAGE_NUMBER25));
        return options;
    }
    
    public void first(){
        this.stdSetController.first();
    }
    
    public void next(){
        this.stdSetController.next();
    }

    public void previous(){
        this.stdSetController.previous();
    }
    
    public void last(){
        this.stdSetController.last();
    }

    public void firstN(){
        this.stdSetControllerN.first();
    }
    
    public void nextN(){
        this.stdSetControllerN.next();
    }

    public void previousN(){
        this.stdSetControllerN.previous();
    }
    
    public void lastN(){
        this.stdSetControllerN.last();
    }

    public void firstCS(){
        this.stdSetControllerCS.first();
    }
    
    public void nextCS(){
        this.stdSetControllerCS.next();
    }

    public void previousCS(){
        this.stdSetControllerCS.previous();
    }
    
    public void lastCS(){
        this.stdSetControllercS.last();
    }

    
    public list<PriceBookEntry> getProductoList(){                      //to display records on vf page
        System.debug('----getProductoList: '+(list<PriceBookEntry>)stdSetController.getRecords());
       return (list<PriceBookEntry>)stdSetController.getRecords();
       /* list<PricebookEntry>  listaPreciosAux = [SELECT  Id, Product2.name, Product2.Description, Product2.Family, UnitPrice, Product2.Imagen__c,Product2.NombreAuxiliar__c 
                                                FROM PricebookEntry 
                                                WHERE Pricebook2.name = 'Departamento de produccion' AND Product2.Catalogo__c = true ORDER BY Product2.Name ASC];
       list<PricebookEntry>  listaPrecios = new List<PricebookEntry>();
       List<String> nombreProductos = new List<String>();
       for(PricebookEntry pb : listaPreciosAux){
            if(!nombreProductos.contains(pb.Product2.NombreAuxiliar__c) && pb.Product2.NombreAuxiliar__c != null){
                nombreProductos.add(pb.Product2.NombreAuxiliar__c);
                listaPrecios.add(pb);
            }else if(!nombreProductos.contains(pb.Product2.name) && pb.Product2.NombreAuxiliar__c == null){
                listaPrecios.add(pb);
                nombreProductos.add(pb.Product2.name);
            }
       }
       return listaPrecios; */
    }

    public list<PriceBookEntry> getProductoListN(){                      //to display records on vf page
       return (list<PriceBookEntry>)stdSetControllerN.getRecords();
    }

    public list<ArticuloProducto__c> getProductoListCS(){                      //to display records on vf page
       return (list<ArticuloProducto__c>)stdSetControllerCS.getRecords();
    }
    
    public void queryButton()
    {
        queryMode=true;
        createMode=false;
        buscarPeticion();
    }
    
    public void createButton()
    {
        System.debug('------ createButton');
        queryMode=false;
        createMode=true;
        modo='solicitudes';
        banderaModo = true;
        
        lineaList.clear();
        numPet='';
        peticion = new PeticionMaterial__c();
        addRow();
        getPricesMap();
    }

    public void getPricesMap()
    {
        System.debug('------ getPricesMap');
        if (productPriceMap == null || productPriceMap.isEmpty()) {
            System.debug('------ Rellenando mapa de precios.');
            productPriceMap = new Map<Id,Double>();
            list<PriceBookEntry> preciosLinea = [SELECT Product2Id, UnitPrice FROM PriceBookEntry WHERE Pricebook2.name = 'Departamento de produccion' AND Product2.StockActual__c > 0 AND Product2.Catalogo__c = true AND Product2.IsActive = true];
            for(PriceBookEntry precioLinea : preciosLinea){
                System.debug('------ producto/precio: ' + precioLinea.Product2Id + '/' + precioLinea.UnitPrice);
                productPriceMap.put(precioLinea.Product2Id,precioLinea.UnitPrice);
            }
        }
        System.debug('------ productPriceMap:'+productPriceMap);
    }
    
    public void addRow() {
        if ( modo=='solicitudes' || modo=='Normal' ){
            lineaList.add(new LineaPeticionMaterial__c(Cantidad__c=0));        
        }
        else if (modo=='consultarStock'){
            lineaListCG.add(new LineaPeticionMaterial__c(Cantidad__c=0));    
        }
        
    }

    public PageReference addRowMS() {
        
        if ( peticionMS.Direccion__c == null || peticionMS.Direccion__c == '' ){
            String errorMsg = '';
            errorMsg = 'Rellene el campo dirección de la solicitud por favor.';
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, errorMsg));
            
        }
        else{
            LineaPeticionMaterial__c auxLinea =  new LineaPeticionMaterial__c(Cantidad__c=0, DireccionMiStock__c=peticionMS.Direccion__c, PeticionMaterial__c=peticionTemporal.Id);
            insert auxLinea;
            lineaListMS.add(auxLinea);
        }
        return null;
    }
    
    public PageReference removeRow() {
        
        if ( modo=='solicitudes' ){
            if (lineaList.size()>0){
                lineaList.remove(lineaList.size()-1);
            }
        }
        else if (modo=='consultarStock'){
            if (lineaListCG.size()>0){            
                lineaListCG.remove(lineaListCG.size()-1);
            }
        }
  
        return null;
    }

    public PageReference removeRowMS() {
        if (lineaListMS.size()>0){            
            lineaListMS.remove(lineaListMS.size()-1);
        }
  
        return null;
    }

    public PageReference updateRowsMS() {
        for(LineaPeticionMaterial__c line : lineaListMS){
            line.DireccionMiStock__c = peticionMS.Direccion__c;
        }
        update lineaListMS;
        return null;
    }
    
    public void guardarPrecio()
    {
        System.debug('------ Guardando precios.');
        System.debug('------ productSelected: [' + productSelected +']');
        System.debug('------ productPriceMap: [' + productPriceMap +']');
        
        if ( modo=='solicitudes' || modo=='Normal' ){
            double precio = productPriceMap.get(lineaList[Integer.valueOf(clickedRow)-1].Producto_CG__c);
            System.debug('------ Precio:' + precio);
            lineaList[Integer.valueOf(clickedRow)-1].PrecioUnidad__c = precio;
            lineaList[Integer.valueOf(clickedRow)-1].recalculateFormulas();
        }
        else if (modo=='consultarStock'){
            double precio = productPriceMap.get(lineaListCG[Integer.valueOf(clickedRowCG)-1].Producto_CG__c);
            System.debug('------ Precio:' + precio);
            lineaListCG[Integer.valueOf(clickedRowCG)-1].PrecioUnidad__c = precio;
            lineaListCG[Integer.valueOf(clickedRowCG)-1].recalculateFormulas();
        }
        System.debug('------ Actualizado precio');
    }
    
    public void recalcularPrecios()
    {
        //Formula.recalculateFormulas(lineaList);
        System.debug('------ clickedRow:'+clickedRow);
        if ( modo=='solicitudes' || modo=='Normal' ){
            lineaList[Integer.valueOf(clickedRow)-1].recalculateFormulas();
        }
        else if (modo=='consultarStock'){
            lineaListCG[Integer.valueOf(clickedRowCG)-1].recalculateFormulas();
        }
    }

/*	public void recalcularMS()
	{
    	System.debug('------ clickedRow:'+clickedRowMS);
    	System.debug('------ recalcularMS:'+lineaListMS[Integer.valueOf(clickedRowMS)-1].ProductoMiStock__c );
    
    	// Se añade Producto__r.Catalogo__c a la consulta
    	ArticuloProducto__c articuloseleccionado = [SELECT Producto__c,Cantidad__c,Producto__r.IsActive, Producto__r.Catalogo__c, Producto__r.Name FROM ArticuloProducto__c WHERE Id = :lineaListMS[Integer.valueOf(clickedRowMS)-1].ProductoMiStock__c LIMIT 1];
    
    	// Se añade la comprobación de Catalogo__c y se mejora el mensaje de error
    	if(articuloseleccionado.Producto__r.IsActive == true && articuloseleccionado.Producto__r.Catalogo__c == true){
        	lineaListMS[Integer.valueOf(clickedRowMS)-1].Producto_CG__c =  String.valueOf(articuloseleccionado.Producto__c);
        	lineaListMS[Integer.valueOf(clickedRowMS)-1].CantidadTemporal__c = articuloseleccionado.Cantidad__c;
    	}else{
        	System.debug('------ Error activo o no en catalogo' );
        	String errorMsg = 'El producto '+ articuloseleccionado.Producto__r.Name +' no está activo o no pertenece al catálogo. Favor seleccionar los productos siempre buscándolos desde la lupa.';
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, errorMsg));
    	}
	}
*/
	public void recalcularMS()
	{
    	System.debug('------ clickedRow:'+clickedRowMS);

    	if (lineaListMS == null || lineaListMS.isEmpty() || String.isBlank(clickedRowMS)) {
        	return; // Salir si no hay datos para procesar
    	}

    	try {
        	Integer rowIndex = Integer.valueOf(clickedRowMS) - 1;
        	if (rowIndex < 0 || rowIndex >= lineaListMS.size()) {
            	return; // Salir si el índice es inválido
        	}
        
        	String articuloId = lineaListMS[rowIndex].ProductoMiStock__c;
        	if (String.isBlank(articuloId)) {
            	return; // Salir si no se ha seleccionado un artículo
        	}

        	List<ArticuloProducto__c> articulos = [SELECT Producto__c, Cantidad__c, Producto__r.IsActive, Producto__r.Catalogo__c, Producto__r.Name 
                                               FROM ArticuloProducto__c 
                                               WHERE Id = :articuloId LIMIT 1];

        	if (articulos.isEmpty()) {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'El artículo seleccionado ya no existe.'));
            	return;
        	}

        	ArticuloProducto__c articuloseleccionado = articulos[0];

        	// Comprobación robusta: verificar que el producto relacionado no es nulo
        	if (articuloseleccionado.Producto__r != null && articuloseleccionado.Producto__r.IsActive == true && articuloseleccionado.Producto__r.Catalogo__c == true) {
            	lineaListMS[rowIndex].Producto_CG__c = String.valueOf(articuloseleccionado.Producto__c);
            	lineaListMS[rowIndex].CantidadTemporal__c = articuloseleccionado.Cantidad__c;
        	} else {
            	String productName = (articuloseleccionado.Producto__r != null) ? articuloseleccionado.Producto__r.Name : 'desconocido';
            	String errorMsg = 'El producto ' + productName + ' no es válido, no está activo o no pertenece al catálogo.';
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, errorMsg));
        	}

    	} catch (Exception e) {
        	System.debug('Error en recalcularMS: ' + e.getMessage());
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'Ha ocurrido un error inesperado al procesar la línea.'));
    	}
	}
    public PageReference saveJobReq() {
        try
        {
            String errorMsg = '';
                 
            errorMsg = ( solicitudTrabajo.ProductObjective__c == '' || solicitudTrabajo.ProductObjective__c == null )               ? errorMsg + 'Para qué se requiere el producto<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.ParticularObjectives__c == '' || solicitudTrabajo.ParticularObjectives__c == null )       ? errorMsg + 'Objetivos<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.Target__c == '' || solicitudTrabajo.Target__c == null )                                   ? errorMsg + 'Público Objetivo<br/>' : errorMsg;
            errorMsg = ( solicitudTrabajo.BackgroundAndContext__c == '' || solicitudTrabajo.BackgroundAndContext__c == null )       ? errorMsg + 'Antecedentes y Contextoo<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.StrategicConcepts__c == null )                                                            ? errorMsg + 'Conceptos Estratégicos Deseados<br/>' : errorMsg;
            errorMsg = ( solicitudTrabajo.ProductIdeas__c == '' || solicitudTrabajo.ProductIdeas__c == null )                       ? errorMsg + 'Ideas de Producto<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.SpecificRequirements__c == '' || solicitudTrabajo.SpecificRequirements__c == null )       ? errorMsg + 'Requerimientos Específicoso<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.Budget__c == null )                                                                       ? errorMsg + 'Presupuesto<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.UnitsToProduce__c == null )                                                               ? errorMsg + 'Unidades a producir<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.TermDate__c == null )                                                                     ? errorMsg + 'Plazo<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.PersonRecipientName__c == '' || solicitudTrabajo.PersonRecipientName__c == null )         ? errorMsg + 'Nombre y apellidos de receptor<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.PersonMobile__c == '' || solicitudTrabajo.PersonMobile__c == null )                       ? errorMsg + 'Número móvil persona receptora<br/>': errorMsg;
            errorMsg = ( solicitudTrabajo.PersonEmail__c == '' || solicitudTrabajo.PersonEmail__c == null )                         ? errorMsg + 'Correo Electrónico persona receptora<br/>': errorMsg;
            
            errorMsg = ( errorMsg != '') ? 'Los siguientes campos son obligatorios:<br/>' + errorMsg : errorMsg;
            
            if ( errorMsg != ''){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, errorMsg));
            }
        } catch(Exception ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'Se ha producido un error:' + ex.getMessage() ));
            System.debug('------ Se ha producido un error:' + ex.getMessage() );
            System.debug('------ Trace: '+ ex.getStackTraceString());
            System.debug('------ Tipo de error: '+ ex.getTypeName());
        }
        if(solicitudTrabajo != null){
            upsert solicitudTrabajo;
        }
        return null;
    }
    
    public PageReference save() {
        try
        {
            System.debug('------ STCK_VF001_PeticionMaterialController save');
            System.debug('modo: ' + modo);

            integer numLineas = 0;
            String errorMsg = '';
            
            if (modo=='consultarStock'){
                peticion = peticionMS;
            }
                 
            errorMsg = ( peticion.Direccion__c == '' || peticion.Direccion__c == null )                     ? errorMsg + 'Dirección<br/>'               : errorMsg;
            errorMsg = ( peticion.Area__c == '' || peticion.Area__c == null )                               ? errorMsg + 'Área<br/>'                : errorMsg;
            errorMsg = ( peticion.PersonaSolicitante__c == '' || peticion.PersonaSolicitante__c == null )   ? errorMsg + 'Persona solicitante<br/>'     : errorMsg;
            errorMsg = ( peticion.CorreoElectronico__c == '' || peticion.CorreoElectronico__c == null )     ? errorMsg + 'Correo electrónico<br/>'      : errorMsg;
            errorMsg = ( peticion.FechaTopeEntrega__c == null )                                             ? errorMsg + 'Fecha tope de entrega<br/>'   : errorMsg;
            errorMsg = ( peticion.LugarEntrega__c == '' || peticion.LugarEntrega__c == null )               ? errorMsg + 'Lugar de entrega<br/>'        : errorMsg;
            errorMsg = ( peticion.CodigoCargo__c == '' || peticion.CodigoCargo__c == null )                 ? errorMsg + 'Código de cargo<br/>'         : errorMsg;
            errorMsg = ( peticion.Sociedad__c == '' || peticion.Sociedad__c == null )                       ? errorMsg + 'Sociedad<br/>'                : errorMsg;
            
            errorMsg = ( errorMsg != '') ? 'Los siguientes campos son obligatorios:<br/>' + errorMsg : errorMsg;
    
            if ( peticion.CorreoElectronico__c != '' && peticion.CorreoElectronico__c != null )
            {
                String dominio = peticion.CorreoElectronico__c.split('@').get(1);
                if (!dominio.contains('laliga.es') && !dominio.contains('laligatech.com') && !dominio.contains('sd.laliga.es')  && !dominio.contains('mad.vass.es'))
                    errorMsg = errorMsg + '<br/>El correo electrónico debe ser una dirección de laliga.es, laligatech.com o sd.laliga.es';
            }
            
            String errorProductos = '';
            String errorCantidades = '';
            
        	if (modo=='solicitudes' || (banderaModo && modo!='consultarStock')){
            	System.debug('------ STCK_VF001_PeticionMaterialController save modo solicitudes');
            	for(LineaPeticionMaterial__c line : lineaList){
                	numLineas = numLineas + 1;
                	if(line.Producto_CG__c == null && errorProductos ==''){
                    	errorProductos = '<br/>Existen líneas de pedido donde no se ha especificado el producto. Por favor, utilice el icono de búsqueda para seleccionarlo.';
                	}
                	// --- MEJORA DE VALIDACIÓN ---
                	// Se añade una comprobación para asegurar que el precio se ha cargado.
                	// Si no hay precio, el producto no fue seleccionado correctamente.
                	else if (line.PrecioUnidad__c == null && errorProductos == '') {
                     	errorProductos = '<br/>El precio para un producto no se ha cargado. Por favor, asegúrese de seleccionar el producto correctamente desde la búsqueda (DESDE LA LUPA) para que se calcule su precio.';
                	}
                
                	if((line.Cantidad__c == null || line.Cantidad__c == 0 ) && errorCantidades ==''){
                    	errorCantidades = errorCantidades + '<br/>Existen líneas de pedido donde no se ha especificado la cantidad';
                	}
                
                	if( errorProductos !='' && errorCantidades !='')
                    	break;
            		}
            
        	}
            else if (modo=='consultarStock'){
                System.debug('------ STCK_VF001_PeticionMaterialController save modo consultarStock');

				// Se extraen los IDs de producto de las líneas para una sola consulta
				List<String> productoLinea = new List<String>();
				for(LineaPeticionMaterial__c line : lineaListMS){
    				if(line.Producto_CG__c != null) {
        				productoLinea.add(line.Producto_CG__c);
    				}
				}

				// Se consulta una sola vez y se guardan los productos en un mapa
				Map<Id, Product2> productosEnLineas = new Map<Id, Product2>([
    				SELECT Id, IsActive, Catalogo__c, Name 
    				FROM Product2 
    				WHERE Id IN :productoLinea
				]);

				// Se itera sobre las líneas para validar
				for(LineaPeticionMaterial__c line : lineaListMS){
    				numLineas = numLineas + 1;
    				if(line.ProductoMiStock__c == null && errorProductos ==''){
        				errorProductos = '<br/>Existen líneas de pedido donde no se ha especificado el producto';
    				}
    
    				if((line.Cantidad__c == null || line.Cantidad__c == 0 ) && errorCantidades ==''){
        				errorCantidades = errorCantidades + '<br/>Existen líneas de pedido donde no se ha especificado la cantidad';
    				}
    				else if(line.Cantidad__c > line.CantidadTemporal__c){
        				errorCantidades = errorCantidades + '<br/>Existen líneas de pedido sobre mi stock que superan el stock privado';
    				}

    				// Nueva validación usando el mapa de productos
    				if (line.Producto_CG__c != null && productosEnLineas.containsKey(line.Producto_CG__c)) {
        				Product2 p = productosEnLineas.get(line.Producto_CG__c);
        				if ((!p.IsActive || !p.Catalogo__c) && errorProductos == '') {
            				errorProductos = '<br/>Existen líneas de pedido donde el producto no está activo o no pertenece al catálogo. Favor seleccionar los productos siempre buscándolos desde la lupa.';
        				}
    				}
    
    				if( errorProductos !='' && errorCantidades !='')
        				break;
				}                

                
                if( errorProductos =='' && errorCantidades =='' ){
                    for(LineaPeticionMaterial__c line : lineaListCG){
                        numLineas = numLineas + 1;
                        if(line.Producto_CG__c == null && errorProductos ==''){
                            errorProductos = '<br/>Existen líneas de pedido donde no se ha especificado el producto';
                        }
                        
                        if((line.Cantidad__c == null || line.Cantidad__c == 0 ) && errorCantidades ==''){
                            errorCantidades = errorCantidades + '<br/>Existen líneas de pedido donde no se ha especificado la cantidad';
                        }
                        
                        if( errorProductos !='' && errorCantidades !='')
                            break;
                    }
                }
            }
            
            errorMsg = errorMsg + errorProductos + errorcantidades;
            
            if ( numLineas == 0 ){
                errorMsg = errorMsg + 'La solicitud debe contener al menos una línea';
            }

            if ( errorMsg != ''){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, errorMsg));
            }
            else
            {
                System.debug('------ STCK_VF001_PeticionMaterialController save creando petición');
                
                List<LineaPeticionMaterial__c> lineas = new List<LineaPeticionMaterial__c>();
                
                if(peticion != null && ( (lineaList.size()>0 && (modo=='solicitudes' || banderaModo)) || (modo=='consultarStock' && (lineaListMS.size()>0 || lineaListCG.size()>0)) ) ){// && continuar) {
                    upsert peticion;
                    System.debug('------ STCK_VF001_PeticionMaterialController save petición creada: ' + peticion.Id);
                    if (modo=='solicitudes'){
                        for(LineaPeticionMaterial__c l : lineaList) {
                            l.PeticionMaterial__c = peticion.Id;
                            l.Producto__c = l.Producto_CG__c;
                            lineas.add(l);
                        }
                    } else if (modo=='consultarStock'){
                        for(LineaPeticionMaterial__c l : lineaListMS) {
                            LineaPeticionMaterial__c forlayo = new LineaPeticionMaterial__c(Producto__c = l.Producto_CG__c, Cantidad__c=l.Cantidad__c, PeticionMaterial__c=peticion.Id);
                            lineas.add(forlayo);
                        }
                        
                        for(LineaPeticionMaterial__c l : lineaListCG) {
                            l.PeticionMaterial__c = peticion.Id;
                            l.Producto__c = l.Producto_CG__c;
                            lineas.add(l);
                        }
                    }
                }
                if(lineas != null) {
                    upsert lineas;
                    if (peticionTemporal !=null){
                        delete peticionTemporal;
                    }
                    peticion.LinesUpdated__c = true;
                    update peticion;
                }
                List<PeticionMaterial__c> nuevaPeticion = [SELECT Name FROm PeticionMaterial__c WHERE Id = :peticion.Id];
                
                if (nuevaPeticion.size()>0 ) {// && continuar){
                    numPet = nuevaPeticion.get(0).Name;
                    
       //             if(peticion.CorreoElectronico__c!=''){
       //                 sendEmail();
       //             }
                }
            }
        } catch(Exception ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, 'Se ha producido un error:' + ex.getMessage() ));
            
            System.debug('------ Se ha producido un error:' + ex.getMessage() );
            System.debug('------ Trace: '+ ex.getStackTraceString());
            System.debug('------ Tipo de error: '+ ex.getTypeName());
        }
        return null;
    }

    public PageReference saveSL() {
        try
        {
            System.debug('------ STCK_VF001_PeticionMaterialController saveSL');
            String errorMsg = '';

            errorMsg = ( peticionSL.Direccion__c == '' || peticionSL.Direccion__c == null )                     ? errorMsg + 'Dirección<br/>'           : errorMsg;
            errorMsg = ( peticionSL.Area__c == '' || peticionSL.Area__c == null )                               ? errorMsg + 'Área<br/>'                : errorMsg;
            errorMsg = ( peticionSL.PersonaSolicitante__c == '' || peticionSL.PersonaSolicitante__c == null )   ? errorMsg + 'Persona solicitante<br/>' : errorMsg;
            errorMsg = ( peticionSL.CorreoElectronico__c == '' || peticionSL.CorreoElectronico__c == null )     ? errorMsg + 'Correo electrónico<br/>'  : errorMsg;
            errorMsg = ( peticionSL.Telefono__c == '' || peticionSL.Telefono__c == null )                       ? errorMsg + 'Teléfono<br/>'            : errorMsg;
            errorMsg = ( peticionSL.FechaEntrega__c == null )                                                   ? errorMsg + 'Fecha de entrega<br/>'   : errorMsg;
            errorMsg = ( peticionSL.Concepto__c == '' || peticionSL.Concepto__c == null )                       ? errorMsg + 'Concepto<br/>'            : errorMsg;

            errorMsg = ( errorMsg != '') ? 'Los siguientes campos son obligatorios:<br/>' + errorMsg : errorMsg;
            
            if ( peticionSL.CorreoElectronico__c != '' && peticionSL.CorreoElectronico__c != null )
            {
                if (peticionSL.CorreoElectronico__c.split('@').get(0)==''){
                    errorMsg = errorMsg + '<br/>Correo electrónico no valido';
                }
                else{
                    String dominio = peticionSL.CorreoElectronico__c.split('@').get(1);
                    System.debug('dominio:'+dominio);
                    if (!dominio.contains('laliga.es') && !dominio.contains('laligatech.com') && !dominio.contains('sd.laliga.es')  && !dominio.contains('mad.vass.es'))
                        errorMsg = errorMsg + '<br/>El correo electrónico debe ser una dirección de laliga.es, laligatech.com o sd.laliga.es';
                }
            }
            
            if ( errorMsg != ''){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, errorMsg));
            }
            else{
                System.debug('------ STCK_VF001_PeticionMaterialController save creando petición');
                upsert peticionSL;
                List<STCK_SolicitudLogistica__c> nuevaPeticion = [SELECT Name FROm STCK_SolicitudLogistica__c WHERE Id = :peticionSL.Id];
                
                if (nuevaPeticion.size()>0){
                    numPet = nuevaPeticion.get(0).Name;
                    
                    if(peticion.CorreoElectronico__c!=''){
                        System.debug('------ Correo' );
                        sendEmailSL();
                        System.debug('------ Correo B' );
                    }
                }
            }
        } catch(Exception ex){
            System.debug('------ Se ha producido un error:' + ex.getMessage() );
            System.debug('------ Trace: '+ ex.getStackTraceString());
            System.debug('------ Tipo de error: '+ ex.getTypeName());
        }
        
        return null;
    }

    public void cancel() {
        System.debug('------ Cancelando');
        createMode=false;
        lineaList.clear();
        peticion = null;
        peticion= new PeticionMaterial__c();
    }
    public void cancelJobReq() {
        solicitudTrabajo.clear();
        solicitudTrabajo = null;
        solicitudTrabajo = new STCK_JobRequest__c();
    }

    
  /*  public PageReference sendEmail() {

        String subject = 'Solicitud de material creada: ' + numPet;
        String body = '<html><body> Hola ' + peticion.PersonaSolicitante__c + '.<br><br>Se ha creado la solicitud de material número ' + numPet + ', en breve una persona del departamento de producción la gestionará.<br><br>Gracias y recibe un cordial saludo.<br>El departamento de producción.</body></html>';

        String[] toAddresses = new String[] {peticion.CorreoElectronico__c};
        String[] ccAddresses;

        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        if (org.IsSandbox){
            ccAddresses = new String[] {'victoria.lozano@globant.com'};
        }
        else{
            ccAddresses = new String[] {'produccion@laliga.es'};
        }

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        // Sets the paramaters of the email
        email.setSubject( subject );
        email.setToAddresses( toAddresses );
        email.setCcAddresses( ccAddresses );
        email.setHtmlBody( body );
    
        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        return null;
    }
*/

    public PageReference sendEmailSL() {

        String subject = 'Solicitud logística creada: ' + numPet;
        /*String body = '<html><body> Hola ' + peticionSL.PersonaSolicitante__c + '.<br><br>Se ha creado la solicitud logística número ' + numPet + ', en breve el responsable de logística la gestionará.<br><br>Gracias y recibe un cordial saludo.<br>El departamento de producción.</body></html>';*/
        String[] toAddresses = new String[] {peticionSL.CorreoElectronico__c};
        
        String body = '<html><body>' +
        'Hola ' + peticionSL.PersonaSolicitante__c + '.<br><br>' +
        'Se ha creado la solicitud logística número ' + numPet + ', en breve el responsable de logística la gestionará.<br><br>' +
        'Te enviamos el código QR de esta solicitud para que en el momento de la recogida del paquete, la persona de Logística lo escanee y confirme su nombre y la fecha/hora de recibo. Agradecemos que guarde esta notificación:<br><br>' +
        '<b>Código QR:</b> ' + peticionSL.CodigoQR__c + '<br><br>' +
        'Gracias y recibe un cordial saludo.<br>' +
        'El departamento de producción.' +
        '</body></html>';
        
        
        List<STCK_Notificacion_Correo__mdt> notificaraList = [SELECT Notificar__c FROM STCK_Notificacion_Correo__mdt WHERE Tipo__c = 'SOLICITUD_LOGISTICA'];
        
        String[] ccAddresses = new String[notificaraList.size()];
        Integer i = 0;
        for (STCK_Notificacion_Correo__mdt notificara: notificaraList ){
            ccAddresses[i] = notificara.Notificar__c;
            i++;
        }
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = toAddresses;
        message.ccAddresses = ccAddresses;
        
        message.setSubject( subject );
        message.setHtmlBody( body );
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        return null;
    }
    
    public void buscarPeticion() {

        List<PeticionMaterial__c> peticionExistente = [SELECT Id, Name, Estado__c, Direccion__c, Area__c, PersonaSolicitante__c, CorreoElectronico__c, NombreEvento__c, LugarEvento__c, FechaEvento__c, FechaTopeEntrega__c, LugarEntrega__c, DireccionEntrega__c, CodigoCargo__c, Sociedad__c, PrecioTotal__c FROm PeticionMaterial__c WHERE Name = :numPet];
                            
        if (peticionExistente.size()>0){
            peticionConsulta = peticionExistente.get(0);
            lineaList = [SELECT Producto__r.Name, Cantidad__c, PrecioUnidad__c, PrecioLinea__c, Estado__c, Producto__r.Imagen__c FROM LineaPeticionMaterial__c WHERE PeticionMaterial__c = :peticionExistente.get(0).Id];
        }
    }

}