public with sharing class ListViewController {
    
     /**This is the list which will be passed to Visualforce Page and in turn passed to Flow from Visualforce**/
    public List <HRC_ConsentsLead__c> LstSelectedConsentLeads {get;set;}
    
    public ListViewController(ApexPages.StandardSetController listcontroller) {
      
        Set <Id> consentLeadsSelectedIds = new set <Id>();
        LstSelectedConsentLeads = new List <HRC_ConsentsLead__c>();
            
        for (HRC_ConsentsLead__c cl: (HRC_ConsentsLead__c[]) listcontroller.getSelected()) {
            consentLeadsSelectedIds.add(cl.Id);
        }
        
        /**Querying on the Selected records and fetching fields which are required in Flow **/
        LstSelectedConsentLeads = [SELECT Id, HRC_Email__c, HRC_AceptoCliente__c, HRC_Fecha_ultimo_envio_email__c, HRC_Numero_de_envios_de_email__c FROM HRC_ConsentsLead__c WHERE Id IN :consentLeadsSelectedIds];
    }

}