@isTest
private class EventSyncTest {

    @testSetup
    static void setup() {
        // Verifica que exista un RecordType con DeveloperName 'LLBS_Event'
        if ([SELECT COUNT() FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event'] == 0) {
            throw new System.AssertException('Se requiere un RecordType LLBS_Event en la org.');
        }

        // Crear un perfil existente requerido para el usuario
        Profile profileStandard = [SELECT Id FROM Profile WHERE Name = 'LLBS' LIMIT 1];
        
        // Crear el usuario si no existe
        if ([SELECT COUNT() FROM User WHERE Email = 'standard.user@example.com'] == 0) {
            User testUser = new User(
                FirstName = 'Standard',
                LastName = 'User',
                Alias = 'stdusr',
                Email = 'standard.user@example.com',
                Username = 'standard.user.' + System.currentTimeMillis() + '@example.com',
                ProfileId = profileStandard.Id,
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                IsActive = true 
            );
            insert testUser;
        }

        // Crear un contacto si no existe
        if ([SELECT COUNT() FROM Contact WHERE Email = 'testcontact@example.com'] == 0) {
            Contact testContact = new Contact(
                LastName = 'TestContact',
                Email = 'testcontact@example.com'
            );
            insert testContact;
        }
    }

    @isTest
    static void testTriggerInsert() {
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());

        // Consultar el RecordType existente
        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id;

        Event ev = new Event(
            RecordTypeId = rtId,
            Subject = 'Test Event Insert',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            IsPrivate = false
        );
        insert ev;
    }

    @isTest
    static void testTriggerUpdateToRefused() {
        // Consultar el RecordType existente
        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType='Event' AND DeveloperName='LLBS_Event' LIMIT 1].Id;

        // Obtener el usuario de prueba
        User u = [SELECT Id FROM User WHERE Email = 'standard.user@example.com' AND IsActive = true LIMIT 1];

        // Obtener el contacto de prueba
        Contact c = [SELECT Id FROM Contact WHERE Email = 'testcontact@example.com' LIMIT 1];

        // Crear un evento con estado inicial 'Accepted' (válido)
        Event ev = new Event(
            RecordTypeId = rtId,
            Subject = 'Test Event Update',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            LLBS_EventStatus__c = null,
            Outlook_Event_Id__c = 'fakeId',
            Description = 'Evento de prueba update',
            OwnerId = u.Id,
            WhoId = c.Id         
        );
        insert ev;

        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());

        // Actualizar el estado a 'Refused'
        ev.LLBS_EventStatus__c = 'Refused'; 
        update ev;
    }

    @isTest
    static void testTriggerUpdateToAccepted() {
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());

        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType='Event' AND DeveloperName='LLBS_Event' LIMIT 1].Id;

        User u = [SELECT Id FROM User WHERE Email = 'standard.user@example.com' AND IsActive = true LIMIT 1];

        Contact c = [SELECT Id FROM Contact WHERE Email = 'testcontact@example.com' LIMIT 1];

        Event ev = new Event(
            RecordTypeId = rtId,
            Subject = 'Test Event Accepted',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            LLBS_EventStatus__c = 'Accepted', // Usa un valor permitido
            Outlook_Event_Id__c = 'fakeId',
            Description = 'Evento de prueba accepted',
            OwnerId = u.Id,
            WhoId = c.Id
        );
        insert ev;

        // Actualizar el estado a 'Accepted'
        ev.LLBS_EventStatus__c = 'Accepted';
        update ev;
    }
    
    @isTest
    static void testTriggerDelete() {
        // Consultar el RecordType existente
        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id;

        Event ev = new Event(
            RecordTypeId = rtId,
            Subject = 'Test Event Delete',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Outlook_Event_Id__c = 'fakeId'
        );
        insert ev;

        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());

        delete ev;
    }
}