trigger EventSync on Event (after insert, after update, after delete) { 

    // Manejo de inserciones
    if (Trigger.isInsert) {
        for (Event ev : Trigger.new) {
            if (ev.Outlook_Event_Id__c == null) { // Asegurarse de no duplicar
                // Llama al método Future para crear el evento en Outlook
                OutlookEventService.createOutlookEventAsync(ev.Id);
            }
        }
    }

    // Manejo de actualizaciones
    if (Trigger.isUpdate) {

        Id llbsRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id;

        for (Event ev : Trigger.new) {
            Event oldEvent = Trigger.oldMap.get(ev.Id);
            
            // Verifica si el estado cambia a "Refused" y el evento debe ser eliminado
            if (ev.RecordTypeId == llbsRecordTypeId &&
            oldEvent.LLBS_EventStatus__c != 'Refused' &&
            ev.LLBS_EventStatus__c == 'Refused' &&
            ev.Outlook_Event_Id__c != null) {

                // Llama al método para eliminar el evento en Outlook
                OutlookEventService.deleteOutlookEventAsync(ev.Outlook_Event_Id__c);
            }
            
            // Lógica para actualizar en Outlook si el estado cambia a 'Accepted'
            if (ev.RecordTypeId == llbsRecordTypeId &&
            oldEvent.LLBS_EventStatus__c != 'Accepted' &&
            ev.LLBS_EventStatus__c == 'Accepted' &&
            ev.Outlook_Event_Id__c != null) {

                OutlookEventService.updateOutlookEventAsync(ev.Id);
            }
        }
    }

    // Manejo de eliminaciones
    if (Trigger.isDelete) {
        for (Event ev : Trigger.old) {
            if (ev.Outlook_Event_Id__c != null) {
                // Llama al método para eliminar el evento en Outlook
                OutlookEventService.deleteOutlookEventAsync(ev.Outlook_Event_Id__c);
            }
        }
    }
}