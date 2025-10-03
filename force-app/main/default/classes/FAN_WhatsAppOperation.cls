public class FAN_WhatsAppOperation  {

	@InvocableMethod(label='Buscar Cuenta')
	public static List<Account> buscarCuenta(List<MessagingEndUser> usuarioMensajeria){
		
		List <Account> cuenta;
		//String idCuenta;
		
		List<List<sObject>> searchList;

		String platformKey = usuarioMensajeria.get(0).MessagingPlatformKey;
		Integer posicion = platformKey.indexOf('+');
		String prefijo =  platformKey.substring(posicion+1,posicion+3);
		String telefono = platformKey.substring(posicion+3);
		String telefonoConPrefijo = platformKey.substring(posicion);
		
		System.debug('--------   platformKey: ' + platformKey + '   --------');

		System.debug('--------   posicion: ' + String.valueOf(posicion) + '   --------');
		System.debug('--------   prefijo: ' + prefijo + '   --------');
		System.debug('--------   telefono: ' + telefono + '   --------');
		System.debug('--------   telefonoConPrefijo: ' + telefonoConPrefijo + '   --------');

		

		if (prefijo=='34')
		{
			System.debug('--------   Prefijo 34 --------');
			//cuenta = [SELECT Id FROM Account WHERE Phone != null AND Phone = :telefono];
			searchList = [FIND :telefono IN Phone FIELDS RETURNING Account(Id)];
			cuenta = searchList[0];
			if(cuenta.size() > 0)
			{
				System.debug('--------   Encontrado teléfono   --------');
				//idCuenta = cuenta.get(0).Id;
			}
			else
			{
				System.debug('--------   No encontrado teléfono, buscamos con prefijo   --------');
				//cuenta = [SELECT Id FROM Account WHERE Phone != null AND Phone = :telefonoConPrefijo];
				searchList = [FIND :telefonoConPrefijo IN Phone FIELDS RETURNING Account(Id)];
				cuenta = searchList[0];
				if(cuenta.size() > 0)
				{
					System.debug('--------   Encontrado teléfono con prefijo   --------');
					//idCuenta = cuenta.get(0).Id;
				}
			}
		}
		else
		{
			System.debug('--------   Prefijo <> 34 --------');
			System.debug('--------   Buscamos con prefijo   --------');
			//cuenta = [SELECT Id FROM Account WHERE Phone != null AND Phone = :telefonoConPrefijo];
			searchList = [FIND :telefonoConPrefijo IN Phone FIELDS RETURNING Account(Id)];
			cuenta = searchList[0];
			if(cuenta.size() > 0)
			{
				System.debug('--------   Encontrado teléfono con prefijo   --------');
				//idCuenta = cuenta.get(0).Id;
			}
		}

		return cuenta;
	}
}