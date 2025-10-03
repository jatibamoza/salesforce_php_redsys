public class ZuoraPaymentTriggerHandler  {

    /*public static void gestionarAccion(
        Boolean isBefore,
        Boolean isAfter,
        Boolean isDelete,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isUndelete,
        List<Zuora__Payment__c> newList,
        Map<Id, Zuora__Payment__c> newMap,
        List<Zuora__Payment__c> oldList,
        Map<Id, Zuora__Payment__c> oldMap){

        if (isBefore) { 
            if(isInsert) handleBeforeInsert(oldList, newList, oldMap, newMap);
            if(isUpdate) handleBeforeUpdate(oldList, newList, oldMap, newMap);
            if(isDelete) handleBeforeDelete(oldList, newList, oldMap, newMap);
        }
        else if (isAfter) {
            if(isInsert)    handleAfterInsert(oldList, newList, oldMap, newMap);
            if(isUpdate)    handleAfterUpdate(oldList, newList, oldMap, newMap);
            if(isDelete)    handleAfterDelete(oldList, newList, oldMap, newMap);
            if(isUndelete)  handleAfterUnDelete(oldList, newList, oldMap, newMap);
        }
    }

    public static void handleBeforeInsert(List<Zuora__Payment__c> oldList, List<Zuora__Payment__c> newList, Map<Id, Zuora__Payment__c> oldMap, Map<Id, Zuora__Payment__c> newMap) {
        
        //Código dedicado a la acción Zuora Payment Before Insert
    }

    public static void handleBeforeUpdate(List<Zuora__Payment__c> oldList, List<Zuora__Payment__c> newList, Map<Id, Zuora__Payment__c> oldMap, Map<Id, Zuora__Payment__c> newMap) {
        
        //Código dedicado a la acción Zuora Payment Before Update
    }

    public static void handleBeforeDelete(List<Zuora__Payment__c> oldList, List<Zuora__Payment__c> newList, Map<Id, Zuora__Payment__c> oldMap, Map<Id, Zuora__Payment__c> newMap) {
        
        //Código dedicado a la acción Zuora Payment Before Delete
    }

    public static void handleAfterInsert(List<Zuora__Payment__c> oldList, List<Zuora__Payment__c> newList, Map<Id, Zuora__Payment__c> oldMap, Map<Id, Zuora__Payment__c> newMap) {
        
        //Código dedicad a la acción Zuora Payment After Insert
        for (Zuora__Payment__c payment : newList)
        {
            //if (!Test.isRunningTest()){
				//System.debug('--------   Pago nuevo');
				List<Id> listIds = new List<Id>();
				for(Zuora__Payment__c pay : newList) {
					listIds.add(pay.Id);
				}

				FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Pago', true);
                //FAN_ComunicarDSP.FAN_ComunicarDSP(payment.Id, 'Pago', true, '');
			//}
        //}
    }

    public static void handleAfterUpdate(List<Zuora__Payment__c> oldList, List<Zuora__Payment__c> newList, Map<Id, Zuora__Payment__c> oldMap, Map<Id, Zuora__Payment__c> newMap) {
        
        //Código dedicado a la acción Zuora Payment After Update
        for (Zuora__Payment__c payment : newList)
        {
            //if (!Test.isRunningTest()){
				//System.debug('--------   Pago existente');
				List<Id> listIds = new List<Id>();
				for(Zuora__Payment__c pay : newList) {
					listIds.add(pay.Id);
				}

				FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Pago', false);
				//FAN_ComunicarDSP.FAN_ComunicarDSP(payment.Id, 'Pago', false, '');
			//}
        //}
    }

    public static void handleAfterDelete(List<Zuora__Payment__c> oldList, List<Zuora__Payment__c> newList, Map<Id, Zuora__Payment__c> oldMap, Map<Id, Zuora__Payment__c> newMap) {
        
        //Código dedicado a la acción Zuora Payment After Delete
    }

    public static void handleAfterUndelete(List<Zuora__Payment__c> oldList, List<Zuora__Payment__c> newList, Map<Id, Zuora__Payment__c> oldMap, Map<Id, Zuora__Payment__c> newMap) {
        
        //Código dedicado a la acción Zuora Payment After Undelete
    }*/

}