public with sharing class ZuoraSubscriptionTriggerHandler  {

	/*public static void gestionarAccion(
		Boolean isBefore,
		Boolean isAfter,
		Boolean isDelete,
		Boolean isInsert,
		Boolean isUpdate,
		Boolean isUndelete,
		List<Zuora__Subscription__c> oldList,
		List<Zuora__Subscription__c> newList,
		Map<Id, Zuora__Subscription__c> oldMap,
		Map<Id, Zuora__Subscription__c> newMap){
		if (isAfter) {
			if(isInsert)	handleAfterInsert(oldList, newList, oldMap, newMap);
			if(isUpdate)	handleAfterUpdate(oldList, newList, oldMap, newMap);
		}
	}

	public static void handleAfterInsert(List<Zuora__Subscription__c> oldList, List<Zuora__Subscription__c> newList, Map<Id, Zuora__Subscription__c> oldMap, Map<Id, Zuora__Subscription__c> newMap) {
		List<Id> listIds = new List<Id>();
		for(Zuora__Subscription__c suscripcion : newList) {
			listIds.add(suscripcion.Id);
		}

		FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Suscripcion', true);
	}

	public static void handleAfterUpdate(List<Zuora__Subscription__c> oldList, List<Zuora__Subscription__c> newList, Map<Id, Zuora__Subscription__c> oldMap, Map<Id, Zuora__Subscription__c> newMap) {
		List<Id> listIds = new List<Id>();
		for(Zuora__Subscription__c suscripcion : newList) {
			listIds.add(suscripcion.Id);
		}

		FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Suscripcion', false);
	}*/
}