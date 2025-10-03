public class ZuoraProductTriggerHandler  {

    /*public static void gestionarAccion(
        Boolean isBefore,
        Boolean isAfter,
        Boolean isDelete,
        Boolean isInsert,
        Boolean isUpdate,
        Boolean isUndelete,
        List<Zuora__Product__c> newList,
        Map<Id, Zuora__Product__c> newMap,
        List<Zuora__Product__c> oldList,
        Map<Id, Zuora__Product__c> oldMap){

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

    public static void handleBeforeInsert(List<Zuora__Product__c> oldList, List<Zuora__Product__c> newList, Map<Id, Zuora__Product__c> oldMap, Map<Id, Zuora__Product__c> newMap) {
        
        //Código dedicado a la acción Product Before Insert
    }

    public static void handleBeforeUpdate(List<Zuora__Product__c> oldList, List<Zuora__Product__c> newList, Map<Id, Zuora__Product__c> oldMap, Map<Id, Zuora__Product__c> newMap) {
        
        //Código dedicado a la acción Product Before Update
    }

    public static void handleBeforeDelete(List<Zuora__Product__c> oldList, List<Zuora__Product__c> newList, Map<Id, Zuora__Product__c> oldMap, Map<Id, Zuora__Product__c> newMap) {
        
        //Código dedicado a la acción Product Before Delete
    }

    public static void handleAfterInsert(List<Zuora__Product__c> oldList, List<Zuora__Product__c> newList, Map<Id, Zuora__Product__c> oldMap, Map<Id, Zuora__Product__c> newMap) {
        
        //Código dedicad a la acción Product After Insert
        for (Zuora__Product__c product : newList)
        {
            //if (!Test.isRunningTest()){
				List<Id> listIds = new List<Id>();
				for(Zuora__Product__c pro : newList) {
					listIds.add(pro.Id);
				}

				FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Producto', true);
                //FAN_ComunicarDSP.FAN_ComunicarDSP(product.Id, 'Producto', true, '');
			//}
        //}
    }

    public static void handleAfterUpdate(List<Zuora__Product__c> oldList, List<Zuora__Product__c> newList, Map<Id, Zuora__Product__c> oldMap, Map<Id, Zuora__Product__c> newMap) {
        
        //Código dedicado a la acción Product After Update
        for (Zuora__Product__c product : newList)
        {
            //if (!Test.isRunningTest()){
				List<Id> listIds = new List<Id>();
				for(Zuora__Product__c pro : newList) {
					listIds.add(pro.Id);
				}

				FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Producto', false);
				//FAN_ComunicarDSP.FAN_ComunicarDSP(product.Id, 'Producto', false, '');
			//}
       // }
    }

    public static void handleAfterDelete(List<Zuora__Product__c> oldList, List<Zuora__Product__c> newList, Map<Id, Zuora__Product__c> oldMap, Map<Id, Zuora__Product__c> newMap) {
        
        //Código dedicado a la acción Product After Delete
    }

    public static void handleAfterUndelete(List<Zuora__Product__c> oldList, List<Zuora__Product__c> newList, Map<Id, Zuora__Product__c> oldMap, Map<Id, Zuora__Product__c> newMap) {
        
        //Código dedicado a la acción Product After Undelete
    }*/

}