public class ZuoraZInvoiceTriggerHandler  {

    /*public static void gestionarAccion(Boolean isBefore,Boolean isAfter,Boolean isDelete,Boolean isInsert,Boolean isUpdate,Boolean isUndelete,
    List<Zuora__ZInvoice__c> newList,Map<Id, Zuora__ZInvoice__c> newMap,List<Zuora__ZInvoice__c> oldList,Map<Id, Zuora__ZInvoice__c> oldMap){
        if (isAfter) {
            if(isInsert) {
                handleAfterInsert(oldList, newList, oldMap, newMap);
            }
            if(isUpdate) {
                handleAfterUpdate(oldList, newList, oldMap, newMap);
            }
        }
    }
    public static void handleAfterInsert(List<Zuora__ZInvoice__c> oldList, List<Zuora__ZInvoice__c> newList, Map<Id, Zuora__ZInvoice__c> oldMap, Map<Id, Zuora__ZInvoice__c> newMap) {
        List<Id> listIds = new List<Id>();
        for(Zuora__ZInvoice__c inv : newList) {
            listIds.add(inv.Id);
        }
        FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Factura', true);
    }
    public static void handleAfterUpdate(List<Zuora__ZInvoice__c> oldList, List<Zuora__ZInvoice__c> newList, Map<Id, Zuora__ZInvoice__c> oldMap, Map<Id, Zuora__ZInvoice__c> newMap) {
        List<Id> listIds = new List<Id>();
        for(Zuora__ZInvoice__c inv : newList) {
            listIds.add(inv.Id);
        }
        FAN_ComunicarDSP.FAN_ComunicarDSP(listIds, 'Factura', false);
    }*/
}