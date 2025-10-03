@isTest
private class UpdateIndividualRevoqueTest {
    
    public static String CRON_EXPRESS = '0 0 0 15 4 ? 2023';
    
    static testmethod void testScheduledJob2() {
        
        HRC_ConsentsLead__c objCL = new HRC_ConsentsLead__c(HRC_CoFFVV__c = '4321', HRC_IdBusiness__c = '4321', HRC_CoLead__c = '4321',
                                                         HRC_Movistar__c = true, HRC_Vodafone__c = true, HRC_AceptoCliente__c = false,
                                                         HRC_IsProcess__c = true, HRC_IsProcessNoAcepto__c = false,
                                                         HRC_Email__c = 'test@gmail.com');
        insert objCL;
        
        HRC_Facility__c estab = new HRC_Facility__c(Name = 'Establecimiento de Prueba2', HRC_CoFFVV__c = '4321');
        insert estab;
        
        Id accoRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('HRC_BusinessAccount').getRecordTypeId();
        Account accoun = new Account(Name = 'TestScheduledAccount2', HRC_IdBusiness__c = 4321, recordTypeId = accoRT, TECH_Application__c = 'HRC', HRC_Facility__c = estab.Id);
        insert accoun;        
        
        Contact conta = new Contact(FirstName = 'Test2', LastName = 'ScheduledContact2', AccountId = accoun.Id, HRC_CoLead__c = '4321');
        insert conta;
        
        Individual indiv = new Individual(FirstName = 'Test2', LastName = 'ScheduledIndividual2', HRC_Contact__c = conta.Id, HRC_AceptoCliente__c = true);
        insert indiv;

        
        Test.startTest();
                
        String jobId2 = System.schedule('ScheduledApexTest2',
            CRON_EXPRESS,
            new UpdateIndividualBatch_RevoqueConsents());
        
        Test.stopTest();
        
    }
}