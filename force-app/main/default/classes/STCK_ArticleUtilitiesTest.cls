@isTest 
private class STCK_ArticleUtilitiesTest {

	@isTest
	private static void testName() {

		Schema.Location almacen = new Schema.Location();
		almacen.Name = 'Torrelaguna';
		almacen.LocationType = 'Almacén';

		insert almacen;
		ArticuloProducto__c articulo = new ArticuloProducto__c();
		articulo.Name = 'Prueba';
		articulo.Cantidad__c = 100;
		articulo.Almacen__c = almacen.Id;
		insert articulo;

		STCK_ArticuloActualizable articuloActualizar = new STCK_ArticuloActualizable();
		articuloActualizar.key=articulo.Id;
		articuloActualizar.value=articulo.Cantidad__c;


		List<STCK_ArticuloActualizable> articuloActualizarLst = new List<STCK_ArticuloActualizable>();
		articuloActualizarLst.add(articuloActualizar);


		List<List<STCK_ArticuloActualizable>> articuloActualizarLstLst = new List<List<STCK_ArticuloActualizable>>();
		articuloActualizarLstLst.add(articuloActualizarLst);


		Test.startTest();
		STCK_ArticleUtilities.ActualizarArticulos(articuloActualizarLstLst);
		Test.stopTest();
	}
}