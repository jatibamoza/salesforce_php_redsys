@isTest 
private class ContentDocumentLinkTrigger_Test {
	@TestSetup
	private static void dataTest() {
        
        Lead lead = new Lead();
        lead.FirstName = 'Prueba';
        lead.LastName = 'Test';
        lead.Company = 'Company Test';
        lead.Email = 'prueba@test.com';
        insert lead;
        
        Id accRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('LLBS_Alumno').getRecordTypeId();
        
        Account account = new Account();
        account.RecordTypeId = accRT;
        account.PersonEmail = 'pruebatest@test.com';
        account.LastName = 'Prueba Test';
        account.FirstName = 'Prueba Test';
        insert account;
        
        Contact con = [SELECT Id FROM Contact where AccountId =: account.Id];
        
        Contact contact = new Contact();
        contact.FirstName = 'Prueba Test';
        contact.LastName = 'Prueba Test';
        contact.Email = 'pruebatest@test.com';
        insert contact;
        
        
        EmailMessage eml = new EmailMessage (Subject = 'Test email', Status = '3');  
        insert eml;
        
        EmailMessage eml2 = new EmailMessage (Subject = 'Test email2', Status = '3'); 
        insert eml2;
        
        EmailMessage eml3 = new EmailMessage (Subject = 'Test email3', Status = '3'); 
        insert eml3;
        
        EmailMessageRelation emlR = new EmailmessageRelation(EmailMessageId = eml.Id, RelationId = lead.Id, RelationType = 'ToAddress');
        insert emlR;
        
        EmailMessageRelation emlR2 = new EmailmessageRelation(EmailMessageId = eml2.Id, RelationId = contact.Id, RelationType = 'ToAddress');
        insert emlR2; 
        
        EmailMessageRelation emlR3 = new EmailmessageRelation(EmailMessageId = eml3.Id, RelationId = con.Id, RelationType = 'ToAddress');
        insert emlR3;
        
        ContentVersion contentVersion =new ContentVersion(); 
        contentVersion.Title = 'Task_Test'; 
        contentVersion.PathOnClient='/' + contentVersion.Title + '.pdf'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        contentVersion.VersionData=bodyBlob; 
        contentVersion.origin = 'H';
        insert contentVersion;
        
	}

	@isTest
	private static void testName() {
        EmailMessage em = [SELECT Id, ActivityId FROM EmailMessage WHERE Subject = 'Test email'];   
        EmailMessage em2 = [SELECT Id, ActivityId FROM EmailMessage WHERE Subject = 'Test email2'];
        EmailMessage em3 = [SELECT Id, ActivityId FROM EmailMessage WHERE Subject = 'Test email3'];
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        
        Test.startTest();
        
        ContentDocumentLink contentlink1 = new ContentDocumentLink();
        contentlink1.LinkedEntityId = em.Id;
        contentlink1.ContentDocumentId = [SELECT ContentDocumentId from ContentVersion where Title = 'Task_Test'].ContentDocumentId;
        contentlink1.ShareType = 'V';
        contentlink1.Visibility = 'AllUsers';
        cdlList.add(contentlink1);
        
        ContentDocumentLink contentlink2 = new ContentDocumentLink();
        contentlink2.LinkedEntityId = em2.Id;
        contentlink2.ContentDocumentId = [SELECT ContentDocumentId from ContentVersion where Title = 'Task_Test'].ContentDocumentId;
        contentlink2.ShareType = 'V';
        contentlink2.Visibility = 'AllUsers';
        cdlList.add(contentlink2);
        
        ContentDocumentLink contentlink3 = new ContentDocumentLink();
        contentlink3.LinkedEntityId = em3.Id;
        contentlink3.ContentDocumentId = [SELECT ContentDocumentId from ContentVersion where Title = 'Task_Test'].ContentDocumentId;
        contentlink3.ShareType = 'V';
        contentlink3.Visibility = 'AllUsers';
        cdlList.add(contentlink3);
        
        insert cdlList;
        
		Test.stopTest();
	}
}