public class FAN_ComunicarDSP  {

	/*@future(callout = true)
	public static void FAN_ComunicarDSP(List<Id> IdList, String tipo, Boolean ins) {
		String token = '';
		FAN_Callout wsDSP = new FAN_Callout();
		if (String.isEmpty(token)) {
			token = wsDSP.GetToken();
		}

		//Invocamos el servicio web Externo de C&G para Enviar un pedido
		if (!String.isEmpty(token)) {
			HttpResponse respuestaws = new HttpResponse();
			//Almacenamos la respuesta del servicio web al que invocamos
			switch on tipo {
				when 'Producto' {
					for (Zuora__Product__c producto : [SELECT Id FROM Zuora__Product__c WHERE Id IN :IdList]) {
						Id Id = producto.Id;
						System.debug('--------   Producto: ' + Id + 'nuevo: ' + ins);
						respuestaws = wsDSP.EnviarProducto(Id, token, ins);
					}
				}	
				when 'Suscripcion' {
					for (Zuora__Subscription__c suscripcion : [SELECT Id, Zuora__Version__c FROM Zuora__Subscription__c WHERE Id IN :IdList]) {
						Id Id = suscripcion.Id;
						boolean nuevo;			
						nuevo = suscripcion.Zuora__Version__c > 1 || !ins ? false : true;
						System.debug('--------   Suscripcion: ' + Id + 'nuevo: ' + nuevo);
						respuestaws = wsDSP.EnviarSuscripcion(Id, token, nuevo);
					}
				}
				when 'Pago' {
					for (Zuora__Payment__c pago : [SELECT Id FROM Zuora__Payment__c WHERE Id IN :IdList]) {
						Id Id = pago.Id;
						System.debug('--------   Pago: ' + Id + 'nuevo: ' + ins);
						respuestaws = wsDSP.EnviarPago(Id, token, ins);
					}
				}
				when 'Factura' {
					for (Zuora__ZInvoice__c factura : [SELECT Id FROM Zuora__ZInvoice__c WHERE Id IN :IdList]) {
						Id Id = factura.Id;
						System.debug('--------   Factura: ' + Id + 'nuevo: ' + ins);
						respuestaws = wsDSP.EnviarFactura(Id, token, ins);
					}
				}
				when else {
					//Do nothing
				}
			}

			System.debug('--------   Respuesta DSP Envio '+ tipo + ':' + respuestaws);
		}
		masterpackage.CalloutUtility.FlushLogs();
	}

	public static void ModificarMetodoPago(List<Zuora__PaymentMethod__c> pmList, List<Id> billIds) {
		Map<Id,Zuora__ZInvoice__c> facturaUpd = new Map<Id,Zuora__ZInvoice__c>();
		Map<Id,Zuora__Payment__c> pagoUpd = new Map<Id,Zuora__Payment__c>();
		List<Zuora__ZInvoice__c> facturaList = [SELECT Id, Name, Zuora__BillingAccount__c FROM Zuora__ZInvoice__c 
			WHERE Zuora__BillingAccount__c IN :billIds AND Payment_Method__c = null];
		List<Zuora__Payment__c> pagoList = [SELECT Id, Name, Zuora__BillingAccount__c, Zuora__Payment_Method__c FROM Zuora__Payment__c 
			WHERE Zuora__BillingAccount__c IN :billIds AND Zuora__Payment_Method__c = null];

		for (Zuora__PaymentMethod__c pm : pmList) {
			for(Zuora__ZInvoice__c factura : facturaList) {
				factura.Payment_Method__c = pm.Id;
				facturaUpd.put(factura.Id, factura);
			}
			for(Zuora__Payment__c pago : pagoList) {
				pago.Zuora__Payment_Method__c = pm.Id;
				pagoUpd.put(pago.Id, pago);
			}
		}
		update facturaUpd.values();
		update pagoUpd.values();
	}*/
}