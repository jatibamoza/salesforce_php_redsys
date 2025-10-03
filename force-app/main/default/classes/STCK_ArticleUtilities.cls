public class STCK_ArticleUtilities  {
	@InvocableMethod(label='ActualizarArticulos' description='Actualizamos los artículos')
	public static List<FlowOutputs> ActualizarArticulos (List<List<STCK_ArticuloActualizable>> listArtclsActLists)
	{
		String resultado = 'Ok';
		Id peticionMaterialId = null;
		//System.debug('## Inicio actualizar artículos');

		Set<Id> records = new Set<Id>{};
		Map<Id, double> articulosActualizar = new Map<Id, double>();

		List<STCK_ArticuloActualizable> articulosList = new List<STCK_ArticuloActualizable>(listArtclsActLists.get(0));
		
		if (!articulosList.isEmpty())
		{
			for (STCK_ArticuloActualizable articulo : articulosList) {
				//System.debug('  key:' + articulo.key + ' value: '+articulo.value);
				//System.debug('  peticionMaterialId:' + peticionMaterialId );
				articulosActualizar.put(articulo.key, articulo.value);
				records.add(articulo.key);

				if (peticionMaterialId==null)
				{
					peticionMaterialId = articulo.peticionMaterialId;
					//System.debug('  Actualizamos peticionMaterialId:' + peticionMaterialId );
				}
			}

			List<ArticuloProducto__c> results = [	SELECT Id, Cantidad__c, TECH_OperacionRelacionada__c, TECH_UltimaModificacion__c
														FROM ArticuloProducto__c 
														WHERE Id IN :records];

			for (ArticuloProducto__c result : results) {
				//System.debug('  Id:' + result.Id );
				//System.debug('  Cantidad actual: '+result.Cantidad__c);
				//System.debug('  Cantidad a decrementar:' + articulosActualizar.get(result.Id) );
				result.Cantidad__c = result.Cantidad__c - articulosActualizar.get(result.Id);
				result.TECH_OperacionRelacionada__c = peticionMaterialId;
				result.TECH_UltimaModificacion__c = 'Salida';
				//System.debug('  Cantidad final:' + result.Cantidad__c );
			}

			update results;
		}

		//System.debug('## Fin actualizar artículos');
		//System.debug('Resultado: ' + resultado);
		
        FlowOutputs fout = new FlowOutputs();
        fout.result = resultado;
        return new List<FlowOutputs>{fout};

	}

    public class FlowOutputs {
        @InvocableVariable
        public String result;
    }
}