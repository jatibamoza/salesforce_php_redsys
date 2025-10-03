// STCK_ProductCatalogController.cls
public with sharing class STCK_ProductCatalogController {

	private static final String PRICEBOOK_NAME = 'Tienda de Empleados';

	/**
	 * @description Obtiene las categorías (familias) de productos únicos y activos del catálogo.
	 * @return List<String> Lista de nombres de familias de productos.
	 */
	@AuraEnabled(cacheable=true)
	public static List<String> getProductCategories() {
		Set<String> categorySet = new Set<String>();
		for (AggregateResult ar : [
			SELECT Product2.Family
			FROM PriceBookEntry
			WHERE Pricebook2.Name = :PRICEBOOK_NAME
			AND Product2.IsActive = true
			AND Product2.Catalogo__c = true
			AND Product2.Uso_Empleado__c = true
			AND Product2.StockActual__c > 0
			AND Product2.Family != null
			GROUP BY Product2.Family
			ORDER BY Product2.Family ASC
		]) {
			categorySet.add((String)ar.get('Family'));
		}
		return new List<String>(categorySet);
	}

	/**
	 * @description Obtiene una lista de productos filtrada por un término de búsqueda y/o una categoría.
	 * Replica la lógica de de-duplicación del controlador original.
	 * @param searchKey Término para buscar en el nombre del producto.
	 * @param category Categoría (familia) para filtrar los productos.
	 * @return List<PriceBookEntry> Lista de registros de PriceBookEntry.
	 */
	@AuraEnabled(cacheable=true)
	public static List<PriceBookEntry> getProducts(String searchKey, String category) {
		String baseQuery = 'SELECT Product2.Name, Product2.Description, Product2.Family, Product2.Imagen__c, UnitPrice, Product2.NombreAuxiliar__c ' +
						   'FROM PriceBookEntry ' +
						   'WHERE Pricebook2.name = :PRICEBOOK_NAME AND Product2.StockActual__c > 0 AND Product2.IsActive = true AND Product2.Catalogo__c = true AND Product2.Uso_Empleado__c = true ';

		if (String.isNotBlank(category)) {
			baseQuery += 'AND Product2.Family = :category ';
		}

		if (String.isNotBlank(searchKey)) {
			String sanitizedKey = '%' + String.escapeSingleQuotes(searchKey) + '%';
			baseQuery += 'AND (Product2.Name LIKE :sanitizedKey OR Product2.NombreAuxiliar__c LIKE :sanitizedKey) ';
		}

		baseQuery += 'ORDER BY Product2.Name ASC';

		List<PriceBookEntry> allProducts = Database.query(baseQuery);
		
		// --- Lógica de De-duplicación (idéntica a la del controlador original) ---
		List<PriceBookEntry> uniqueProducts = new List<PriceBookEntry>();
		Set<String> processedNames = new Set<String>();

		for(PriceBookEntry pbe : allProducts) {
			String mainName = pbe.Product2.Name;
			String auxName = pbe.Product2.NombreAuxiliar__c;

			if (String.isNotBlank(auxName) && !processedNames.contains(auxName)) {
				processedNames.add(auxName);
				uniqueProducts.add(pbe);
			} else if (String.isBlank(auxName) && !processedNames.contains(mainName)) {
				processedNames.add(mainName);
				uniqueProducts.add(pbe);
			}
		}
		
		return uniqueProducts;
	}
}