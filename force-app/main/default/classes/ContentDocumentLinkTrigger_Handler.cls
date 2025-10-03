public without sharing class ContentDocumentLinkTrigger_Handler {
    
    public static void afterInsert(List<ContentDocumentLink> cdlList){
        
        List<ContentDocumentLink> cdlInsert = new List<ContentDocumentLink>(); 
        List<ContentDocumentLink> cdlTrigger = [SELECT Id, ContentDocumentId, TYPEOF LinkedEntity WHEN EmailMessage THEN ActivityId END FROM ContentDocumentLink WHERE Id IN :Trigger.newMap.keySet()]; 
        List<ContentDocumentLink> cdlTrigger_sinImagenes = new List<ContentDocumentLink>(); 
        Set<Id> setIds = new Set<Id>();
        Set<Id> contentDocumentIdList = new Set<Id>();
        
        if(cdlTrigger.size()>0){
            
            for(ContentDocumentLink cdl : cdlTrigger) {
                if(cdl.ContentDocumentId != null){
                    contentDocumentIdList.add(cdl.ContentDocumentId);
                } 
        	}
            
            if(contentDocumentIdList.size()>0){
                
                for(ContentDocument cd : [SELECT Id, FileExtension FROM ContentDocument WHERE Id IN :contentDocumentIdList]){
                    for(ContentDocumentLink cdlnew : [SELECT Id,ContentDocumentId, TYPEOF LinkedEntity WHEN EmailMessage THEN ActivityId END FROM ContentDocumentLink WHERE ContentDocumentId = :cd.Id AND Id IN :Trigger.newMap.keySet()]){
                        if(!cd.FileExtension.contains('jpg') && !cd.FileExtension.contains('jpeg') && !cd.FileExtension.contains('png')){
                            setIds.add(cdlnew.LinkedEntityId);
                            cdlTrigger_sinImagenes.add(cdlnew);
                    	}
                	}
            	}
            
            	Map<ID, Task> taskMap = new Map<ID, Task>([SELECT Id, WhoId, AccountId FROM Task WHERE Id IN (SELECT ActivityId FROM EmailMessage WHERE Id IN :setIds)]);
            
            	List<Task> tasks = new List<Task>();
            
            	String idlinked = '';
            	String tipoObjeto = '';
                
                if(cdlTrigger_sinImagenes.size()>0){
                    for(ContentDocumentLink cdl : cdlTrigger_sinImagenes) {
                        if(String.valueOf(cdl.LinkedEntityId).startsWith('02s')) {
                            ContentDocumentLink newCDL = new ContentDocumentLink();
                        	EmailMessage em = cdl.LinkedEntity;
                        	newCDL.LinkedEntityId = (taskMap.get(em.ActivityId).WhoId == null) 
                                ? taskMap.get(em.ActivityId).AccountId : taskMap.get(em.ActivityId).WhoId; 
                        	newCDL.ContentDocumentId = cdl.ContentDocumentId;
                        	cdlInsert.add(newCDL);
        
                        	if(taskMap.get(em.ActivityId).WhoId == null){
                            	idlinked = taskMap.get(em.ActivityId).AccountId;
                            	tipoObjeto = 'Cuenta';
                        	} else if(String.valueOf(taskMap.get(em.ActivityId).WhoId).startsWith('003')){
                            	idlinked = taskMap.get(em.ActivityId).WhoId;
                            	tipoObjeto = 'Contacto';
                        	}	
                    	}
                	}
                
                    if(tipoObjeto.equalsIgnoreCase('Cuenta')){
                        Task task = createTask(idlinked,null);
                        insert task;
                    } else if(tipoObjeto.equalsIgnoreCase('Contacto')){
                        Task task = createTask(null,idlinked);
                        insert task;
                    }     
                    insert cdlInsert;
                } 
            } 
        }
    }
    
    public static Task createTask(Id whatId, Id whoId){
        Task task = new Task();
        task.Type = 'Other';
        task.Status = 'Open';
        task.Subject = 'Revisar documento recibido';
        task.ActivityDate = Date.today();
        task.WhatId = whatId;
        task.WhoId = whoId;
        return task;
    }
}