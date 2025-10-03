trigger LineaSolicitudMaterialTrigger on LineaPeticionMaterial__c (after insert, after update, before delete) {
     if (Trigger.isBefore ){
          If(Trigger.isDelete){
               LineaSolicitudMaterialTriggerHandler.modificacionPedido(Trigger.old, 'delete'); 
          }
     }else{
          if(Trigger.isInsert){
               LineaSolicitudMaterialTriggerHandler.modificacionPedido(Trigger.new, 'insert');
          }else if(Trigger.isUpdate){
               LineaSolicitudMaterialTriggerHandler.actualizarPedido(Trigger.new, Trigger.oldMap);
          }
     }
}