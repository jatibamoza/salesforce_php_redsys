public class ZuoraPaymentMethodTriggerHandler  {

	/*public static void gestionarAccion(Boolean isBefore,Boolean isAfter,Boolean isDelete,Boolean isInsert,Boolean isUpdate,Boolean isUndelete,
	List<Zuora__PaymentMethod__c> newList,Map<Id, Zuora__PaymentMethod__c> newMap,List<Zuora__PaymentMethod__c> oldList,Map<Id, Zuora__PaymentMethod__c> oldMap){
		if (isAfter) {
			if(isInsert) {
				handleAfterInsert(oldList, newList, oldMap, newMap);
			}
		}
	}
	public static void handleAfterInsert(List<Zuora__PaymentMethod__c> oldList, List<Zuora__PaymentMethod__c> newList, Map<Id, Zuora__PaymentMethod__c> oldMap, Map<Id, Zuora__PaymentMethod__c> newMap) {
		//Código dedicad a la acción PaymentMethod After Insert
		List<Id> billIds = new List<Id>();
        
        List<Id> newIds = new List<Id>();
        for(Zuora__PaymentMethod__c obj : newList){
           newIds.add(obj.Zuora__BillingAccount__c); 
        }
        
		List<AggregateResult> billAgg = [SELECT Zuora__BillingAccount__c FROM Zuora__PaymentMethod__c WHERE Zuora__BillingAccount__c IN :newIds
			GROUP BY Zuora__BillingAccount__c HAVING COUNT(Zuora__BillingAccount__c) = 1];
		
		for (AggregateResult ar : billAgg) {
			billIds.add((Id)ar.get('Zuora__BillingAccount__c'));
		}
		List<Zuora__PaymentMethod__c> pmList = [SELECT Id FROM Zuora__PaymentMethod__c WHERE Zuora__BillingAccount__c IN :billIds AND Id IN: newList];
		FAN_ComunicarDSP.ModificarMetodoPago(pmList, billIds);
	}*/
}