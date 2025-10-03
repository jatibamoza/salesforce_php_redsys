global class UpdateIndividualBatch_RevoqueConsents implements Database.Batchable<SObject>, Schedulable {

    global UpdateIndividualBatch_RevoqueConsents() {
    }
    /**
     * @description gets invoked when the batch job starts
     * @param context contains the job ID
     * @returns the record set as a QueryLocator object that will be batched for execution
     */ 
    global Database.QueryLocator start(Database.BatchableContext contexto) {
        return Database.getQueryLocator('SELECT Id, CreatedDate, HRC_CoFFVV__c, HRC_CoLead__c, HRC_Movistar__c, HRC_Vodafone__c, HRC_Mediapro__c, HRC_Orange__c, HRC_Avatel__c, HRC_Telecable__c, HRC_AgileTV__c, HRC_OTT__c, HRC_Mahou__c, HRC_LaLiga__c, HRC_AceptoPropuestas__c, HRC_Comunicaciones_comerciales__c, HRC_AceptoCliente__c, HRC_Fecha_aceptacion_de_consentimientos__c, HRC_Fecha_revocacion_de_consentimientos__c, HRC_ProcessDate__c FROM HRC_ConsentsLead__c WHERE HRC_AceptoCliente__c = false AND HRC_IsProcess__c = true AND HRC_IsProcessNoAcepto__c = false AND HRC_CoFFVV__c != null AND HRC_CoLead__c != null');
    }
    
    /**
     * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
     * @param context contains the job ID
     * @param scope contains the batch of records to process.
     */ 
    global void execute(Database.BatchableContext contexto, List<HRC_ConsentsLead__c> consentsLeads) {
        
        List<String> coFFVVList = new List<String>();
        List<String> coLeadList = new List<String>();
        List<Datetime> maxDates = new List<Datetime>();
        
        Map<String,HRC_ConsentsLead__c> consentsMap = new Map<String,HRC_ConsentsLead__c>();
        
        List<AggregateResult> consentGroup = [SELECT HRC_CoFFVV__c, HRC_CoLead__c, max(CreatedDate) maxDate  
                                              FROM HRC_ConsentsLead__c WHERE HRC_AceptoCliente__c = false AND HRC_IsProcess__c = true
                                              AND HRC_IsProcessNoAcepto__c = false AND HRC_CoFFVV__c != null AND HRC_CoLead__c != null
                                              GROUP BY HRC_CoFFVV__c, HRC_CoLead__c];
        
        
        if(!consentGroup.isEmpty()){
           for(AggregateResult ar : consentGroup){
            coFFVVList.add((String)ar.get('HRC_CoFFVV__c'));
            system.debug('coFFVV'+(String)ar.get('HRC_CoFFVV__c'));
            coLeadList.add((String)ar.get('HRC_CoLead__c'));
            system.debug('coLead'+(String)ar.get('HRC_CoLead__c'));
            maxDates.add((Datetime)ar.get('maxDate'));
           } 
        }
        
        List<HRC_ConsentsLead__c> consentsList = [SELECT Id, LastModifiedDate, HRC_CoFFVV__c, HRC_IdBusiness__c, 
                                              HRC_CoLead__c, HRC_Movistar__c, HRC_Vodafone__c, HRC_Mediapro__c, 
                                              HRC_Orange__c, HRC_Avatel__c, HRC_Telecable__c, HRC_AgileTV__c, 
                                              HRC_OTT__c, HRC_Mahou__c, HRC_LaLiga__c, HRC_AceptoPropuestas__c, 
                                              HRC_Comunicaciones_comerciales__c, HRC_AceptoCliente__c, 
                                              HRC_Fecha_aceptacion_de_consentimientos__c, HRC_Fecha_revocacion_de_consentimientos__c, 
                                              HRC_ProcessDate__c
                                              FROM HRC_ConsentsLead__c WHERE HRC_CoFFVV__c IN :coFFVVList
                                              AND HRC_CoLead__c IN :coLeadList AND CreatedDate IN :maxDates];

        system.debug('consents lead recogidos'+consentsList.size());
        //Si se han recogido consentimientos, almaceno los ids relevantes para obtener las cuentas y contactos
        //y creamos el mapa de los consentimientos para poder acceder posteriormente para actualizar los individuals
        if(!consentsList.isEmpty()){
            for(HRC_ConsentsLead__c con : consentsList){
                consentsMap.put(con.HRC_CoFFVV__c, con); 
                system.debug('hecho el mapeo de consentlead');
            }
        }
        
        //Se obtienen las cuentas relacionadas con los consentimientos
        Map<ID, Account> accountsMap = new Map<ID, Account>([SELECT Id, HRC_CoFFVV__c, HRC_IdBusinessText__c FROM Account 
                                                              WHERE HRC_CoFFVV__c IN :coFFVVList AND TECH_Application__c = 'HRC' AND HRC_CoFFVV__c != null]);
            
        if(!accountsMap.isEmpty()){
            //Se obtienen los contactos relacionadas con los consentimientos
            system.debug('Se han encontrado cuentas');
            Map<String,Contact> contactsMap = new Map<String, Contact>([SELECT Id, AccountId, HRC_CoLead__c, IndividualId FROM Contact 
                                                                 WHERE HRC_CoLead__c IN :coLeadList AND AccountId IN :accountsMap.keySet()
                                                                 AND Account.TECH_Application__c ='HRC' AND HRC_CoLead__c != null]);
            
            for(Contact contact : contactsMap.values()){
                contactsMap.put(contact.IndividualId, contact);
            }
            
            if(!contactsMap.isEmpty()){
                //Se obtienen los individuals relacionadas con los consentimientos
                system.debug('Se han encontrado contactos');
                List<Individual> individualsList = [SELECT Id, HRC_AceptoCliente__c, HRC_AgileTV__c, HRC_Avatel__c, HRC_LaLiga__c, 
                                                    HRC_Mahou__c, HRC_Mediapro__c, HRC_Movistar__c, HRC_OTT__c, HRC_Orange__c, HRC_Telecable__c, 
                                                    HRC_Vodafone__c, HRC_Aceptopropuestas__c, HRC_CesionDatos__c FROM Individual WHERE Id IN :contactsMap.keySet()];
                
                system.debug('Hay individuals de esos contactos:'+individualsList.size());
                    
                //Si hay individuals creados, se actualizan sus campos con los consentimientos recogidos
                if(!individualsList.isEmpty()){
                    
                    system.debug('Entrando a actualizar individuals');
                    HRC_ConsentsLead__c cl = new HRC_ConsentsLead__c();
                    List<HRC_ConsentsLead__c> consentLeadsUpdate = new List<HRC_ConsentsLead__c>();
                            
                    for(Individual ind : individualsList){
                        cl = consentsMap.get(accountsMap.get(contactsMap.get(ind.Id).AccountId).HRC_CoFFVV__c);
                        consentLeadsUpdate.add(cl);   
                        ind.HRC_Movistar__c = cl.HRC_Movistar__c;
                        ind.HRC_Vodafone__c = cl.HRC_Vodafone__c;
                        ind.HRC_Mediapro__c = cl.HRC_Mediapro__c;
                        ind.HRC_Orange__c = cl.HRC_Orange__c;
                        ind.HRC_Avatel__c = cl.HRC_Avatel__c;
                        ind.HRC_Telecable__c = cl.HRC_Telecable__c;
                        ind.HRC_AgileTV__c = cl.HRC_AgileTV__c;
                        ind.HRC_OTT__c = cl.HRC_OTT__c;
                        ind.HRC_Mahou__c = cl.HRC_Mahou__c;
                        ind.HRC_LaLiga__c = cl.HRC_LaLiga__c;
                        ind.HRC_AceptoCliente__c = cl.HRC_AceptoCliente__c;
                        ind.HRC_Aceptopropuestas__c = cl.HRC_AceptoPropuestas__c;
                        ind.HRC_CesionDatos__c = cl.HRC_Comunicaciones_comerciales__c;
                        ind.HRC_Fecha_revocacion_de_consentimientos__c = cl.HRC_Fecha_revocacion_de_consentimientos__c;
                        ind.HRC_Fecha_de_procesamiento__c = Date.today();
                    }
                    Database.update(individualsList, false);
                    
                    for(HRC_ConsentsLead__c clUpdate : consentLeadsUpdate){
                        clUpdate.HRC_IsProcessNoAcepto__c = true;
                        clUpdate.HRC_ProcessDate__c = Date.today();
                    }
                    
                    Database.update(consentLeadsUpdate, false);
                }
            }                
        }
    }
    /**
     * @description gets invoked when the batch job finishes. Place any clean up code in this method.
     * @param context contains the job ID
     */ 
    global void finish(Database.BatchableContext contexto) {
    }
    
    global void execute(SchedulableContext scontect) {
         UpdateIndividualBatch_RevoqueConsents upind_rc = new UpdateIndividualBatch_RevoqueConsents();
         
         Database.executebatch(upind_rc,20);
     }
}