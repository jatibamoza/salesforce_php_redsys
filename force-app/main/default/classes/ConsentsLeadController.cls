public without sharing class ConsentsLeadController  {

    public HRC_ConsentsLead__c consents {get;set;}
    
    public string mensaje {get; private set;}

    public ConsentsLeadController () {
        
        mensaje = getMensaje();

    }

    public void updateConsentLead(){
        consents = [SELECT Id, HRC_AceptoCliente__c, HRC_Fecha_revocacion_de_consentimientos__c FROM HRC_ConsentsLead__c 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        consents.HRC_AceptoCliente__c = false;
        consents.HRC_Fecha_revocacion_de_consentimientos__c = datetime.now();
        update consents;
    }
    
    public String getMensaje(){
        
        String concatenarMensaje;
        
        consents = [SELECT HRC_Nombre__c, HRC_Apellido__c FROM HRC_ConsentsLead__c 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        concatenarMensaje = 'Muchas gracias, '+ consents.HRC_Nombre__c + ' ' + consents.HRC_Apellido__c + ', le confirmamos que se han revocado sus consentimientos correctamente';
        
        return concatenarMensaje;
    }
}