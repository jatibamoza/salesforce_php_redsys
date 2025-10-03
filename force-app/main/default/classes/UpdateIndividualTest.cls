@isTest
private class UpdateIndividualTest {
   
    public static String CRON_EXP = '0 0 0 15 3 ? 2030';
    
    static testmethod void testScheduledJob() {
        
        HRC_ConsentsLead__c obj = new HRC_ConsentsLead__c(HRC_CoFFVV__c = '1234', HRC_IdBusiness__c = '1234', HRC_CoLead__c = '1234',
                                                         HRC_Movistar__c = true, HRC_Vodafone__c = true, HRC_AceptoCliente__c = true,
                                                         HRC_Email__c = 'manu.estada.calvente@gmail.com');
        insert obj;
        
        HRC_Facility__c est = new HRC_Facility__c(Name = 'Establecimiento de Prueba', HRC_CoFFVV__c = '1234');
        insert est;
        
        Id accRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('HRC_BusinessAccount').getRecordTypeId();
        Account acc = new Account(Name = 'TestScheduledAccount', HRC_IdBusiness__c = 1234, recordTypeId = accRT, TECH_Application__c = 'HRC', HRC_Facility__c = est.Id);
        insert acc;        
        
        Contact con = new Contact(FirstName = 'Test', LastName = 'ScheduledContact', AccountId = acc.Id, HRC_CoLead__c = '1234');
        insert con;
        
        Individual ind = new Individual(FirstName = 'Test', LastName = 'ScheduledIndividual', HRC_Contact__c = con.Id, HRC_AceptoCliente__c = false);
        insert ind;

        
        Test.startTest();
        
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new UpdateIndividualBatch());
        
        Test.stopTest();
        
        //Individual ind = [SELECT Id, HRC_AceptoCliente__c FROM Individual WHERE HRC_Contact__c = :con.Id LIMIT 1];
        
        System.assert(ind.HRC_AceptoCliente__c = true, 'No se ha actualizado el objeto Individual');
    }
}