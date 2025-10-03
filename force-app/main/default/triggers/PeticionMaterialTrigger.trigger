trigger PeticionMaterialTrigger on PeticionMaterial__c (before update) {
     if (Trigger.isBefore ){
          If(Trigger.isUpdate){
               PeticionMaterialTriggerHandler.peticionModificada(Trigger.new, Trigger.oldMap);
          }
     }
}