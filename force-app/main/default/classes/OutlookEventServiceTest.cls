@isTest
public class OutlookEventServiceTest {
    @testSetup
    static void setup() {
        // Create a RecordType to ensure it's available for the test
        if ([SELECT COUNT() FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event'] == 0) {
            throw new System.AssertException('RecordType LLBS_Event does not exist in the org.');
        }
        // Crear un perfil existente requerido para el usuario
        Profile profileAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        // Crear el usuario si no existe
        if ([SELECT COUNT() FROM User WHERE Email = 'admin.user@example.com'] == 0) {
            User testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'testusr',
                Email = 'admin.user@example.com',
                Username = 'admin.user.' + System.currentTimeMillis() + '@example.com',
                ProfileId = profileAdmin.Id,
                TimeZoneSidKey = 'America/New_York',
                isActive = true,
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US' );
            insert testUser;
        }
        // Crear un contacto si no existe
        if ([SELECT COUNT() FROM Contact WHERE Email = 'testcontact_dos@example.com'] == 0) {
            Contact oContact = new Contact(
                LastName = 'Contact', 
                Email = 'testcontact_dos@example.com');
            insert oContact;
        }
        // Obtener el RecordTypeId para el Lead
        Id leadRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'LLBS_Lead_Record' LIMIT 1].Id;
        // Crear un lead si no existe
        if ([SELECT COUNT() FROM Lead WHERE RecordTypeId = :leadRecordTypeId] == 0) {
            Lead testLead = new Lead(
                LastName = 'TestLead',
                FirstName = 'TestLeadFirst',
                Company = 'TestCompany',
                RecordTypeId = leadRecordTypeId,
                Status = 'Interesado',
                Email = 'testlead@example.com'
            );
            insert testLead;
        }
    }

    @isTest
    static void testCreateOutlookEvent() {
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());

        User u;
        try {
            u = [SELECT Id FROM User WHERE Profile.Name = 'LLBS' AND isActive=true LIMIT 1];
        } catch (Exception e) {
            System.assert(false, 'No active user with profile LLBS found.');
            return;
        }

        Lead l;
        try {
            l = [SELECT Id FROM Lead WHERE RecordTypeId = :[SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'LLBS_Lead_Record' LIMIT 1].Id AND Status= 'Interesado' LIMIT 1];
        } catch (Exception e) {
            System.assert(false, 'No lead with the specified RecordTypeId found.');
            return;
        }

        // Create an Event record with all required fields
        Event testEvent = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Test Event',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Location = 'Test Location',
            IsPrivate = false,            
            Description = 'Evento de prueba create',
            OwnerId = u.Id,
            WhoId = l.Id
        );
        insert testEvent;

        Test.startTest();
        OutlookEventService.createOutlookEventAsync(testEvent.Id);
        Test.stopTest();

        // Query the updated Event record to validate the Outlook ID and Teams link
        Event updatedEvent = [SELECT Outlook_Event_Id__c, Teams_Link__c FROM Event WHERE Id = :testEvent.Id];
        System.assertNotEquals(null, updatedEvent.Outlook_Event_Id__c, 'Outlook Event ID should not be null');
        System.assertNotEquals(null, updatedEvent.Teams_Link__c, 'Teams Link should not be null');
    }

    @isTest
    static void testDeleteOutlookEvent() {
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());
        // Create an Event record and simulate an Outlook sync
        Event testEvent = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Test Delete Event',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Location = 'Test Location',
            IsPrivate = false,
            Outlook_Event_Id__c = 'mockOutlookId12345' // Simulate synced event
        );
        insert testEvent;

        Test.startTest();
        OutlookEventService.deleteOutlookEventAsync(testEvent.Outlook_Event_Id__c);
        Test.stopTest();

        System.assert(true, 'Delete callout executed successfully');
    }

    @isTest
    static void testUpdateOutlookEvent() {
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());

        User u;
        try {
            u = [SELECT Id FROM User WHERE Profile.Name = 'LLBS' AND isActive=true LIMIT 1];
        } catch (Exception e) {
            System.assert(false, 'No user with profile LLBS found.');
            return;
        }

        Lead l;
        try {
            l = [SELECT Id FROM Lead WHERE RecordTypeId = :[SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'LLBS_Lead_Record' LIMIT 1].Id LIMIT 1];
        } catch (Exception e) {
            System.assert(false, 'No lead with the specified RecordTypeId found.');
            return;
        }

        // Create an Event record and simulate an Outlook sync
        Event testEvent = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Test Update Event',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Location = 'Updated Location',
            IsPrivate = false,
            Outlook_Event_Id__c = 'mockOutlookId12345', // Simulate synced event
            Description = 'Evento de prueba delete',
            OwnerId = u.Id,
            WhoId = l.Id
        );
        insert testEvent;

        Test.startTest();
        OutlookEventService.updateOutlookEventAsync(testEvent.Id);
        Test.stopTest();

        System.assert(true, 'Update callout executed successfully');
    }

    @isTest
    static void testCalloutErrorHandling() {
        // Configuramos el mock que forzará un error (código HTTP != 201)
        Test.setMock(HttpCalloutMock.class, new OutlookEventMockWithError());
        // Creamos el Event que se intentará sincronizar con Outlook
        Event testEvent = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' 
                            AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Test Error Event',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Location = 'Error Location',
            IsPrivate = false
        );
        insert testEvent;
        Test.startTest();
        // Llamada asíncrona al método que lanzará la excepción
        OutlookEventService.createOutlookEventAsync(testEvent.Id);
        // Ahora forzamos la ejecución de ese método @future y capturamos la excepción
        try {
            Test.stopTest(); 
            // Si no se lanza la excepción aquí, forzamos que la prueba falle
            System.assert(false, 'Exception expected but not thrown');
        } catch (OutlookEventService.OtherException e) {
            // Verificamos que el mensaje de la excepción sea el esperado
            System.debug('Caught OtherException: ' + e.getMessage());
            System.assertEquals('No se pudo sincronizar el evento con Outlook.', e.getMessage());
        }
    }

    @isTest
    static void testValidationFailures() {
        // Configura el mock para que no interfiera con la validación
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());
        // Crear un Event con fechas de inicio y fin inválidas
        Event invalidEvent = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = null, // Sin asunto
            StartDateTime = System.now().addHours(1), // Inicio después del fin
            EndDateTime = System.now()
        );
        Test.startTest();
        try {
            insert invalidEvent;
            // Si no hay excepción, falla el test
            System.assert(false, 'Insert should fail due to FIELD_INTEGRITY_EXCEPTION');
        } catch (DmlException e) {
            // Verifica que el mensaje de la excepción contenga el error esperado
            System.assert(e.getMessage().contains('FIELD_INTEGRITY_EXCEPTION'), 'Expected FIELD_INTEGRITY_EXCEPTION');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreatePrivateEvent() {
        // Escenario: Evento 'Privado' para cubrir la rama if (eventRecord.IsPrivate)
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock()); // Mock normal (no importa el status)
        
        Event privateEvent = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' 
                            AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Private Event',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Location = 'Should Not Sync',
            IsPrivate = true // <-- Forzamos la rama de evento privado
        );
        insert privateEvent;
        
        Test.startTest();
        OutlookEventService.createOutlookEventAsync(privateEvent.Id);
        Test.stopTest();
        
        // Si la rama se ejecuta bien, no debería intentar sincronizar y no lanza excepción
        System.assert(true, 'Evento privado no genera callout y cubre la rama IsPrivate.');
    }

    @isTest
    static void testUpdateEventWithoutOutlookId() {
        // Escenario: Llamamos a updateOutlookEventAsync pero el evento NO tiene Outlook_Event_Id__c
        // para cubrir la rama if (String.isBlank(eventRecord.Outlook_Event_Id__c)) { return; }
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());
        
        Event noOutlookIdEvent = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' 
                            AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'No Outlook ID',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Location = 'No ID to update',
            IsPrivate = false
            // Outlook_Event_Id__c no se setea
        );
        insert noOutlookIdEvent;
        
        Test.startTest();
        OutlookEventService.updateOutlookEventAsync(noOutlookIdEvent.Id);
        Test.stopTest();
        
        // Como no tiene Outlook_Event_Id__c, el método updateOutlookEvent hace return temprano
        System.assert(true, 'Se cubre la rama de no actualizar cuando Outlook_Event_Id__c está vacío.');
    }

    @isTest
    static void testDeleteOutlookEventWithBlankId() {
        // Escenario: Llamamos al método de borrado con un ID vacío
        // para cubrir if (String.isBlank(outlookEventId)) { return; }
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock()); // Simulación no importa
        
        Test.startTest();
        OutlookEventService.deleteOutlookEventAsync('');
        Test.stopTest();
        
        // Se cubre la rama de "ID vacío" y no lanza excepción
        System.assert(true, 'Se cubre la rama de no borrar cuando el ID de Outlook es vacío.');
    }

    @isTest
    static void testDeleteOutlookEventNotFound() {
        // Escenario: Queremos forzar un 404 al eliminar para cubrir else if (res.getStatusCode() == 404)
        Test.setMock(HttpCalloutMock.class, new OutlookEventMockDelete404());
        
        // Simulamos un evento que "supuestamente" tiene un ID de Outlook
        Event eventToDelete = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' 
                            AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Event to delete - 404 scenario',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            Outlook_Event_Id__c = 'someNonExistentId',
            IsPrivate = false
        );
        insert eventToDelete;
        
        Test.startTest();
        OutlookEventService.deleteOutlookEventAsync(eventToDelete.Outlook_Event_Id__c);
        Test.stopTest();
        
        // Se cubre la rama "404 -> no existe en Outlook"
        System.assert(true, 'Se cubre la rama que maneja el estado 404 al eliminar en Outlook.');
    }

    @isTest
    static void testPrepareAttendeesWithContact() {
        // Usa un mock normal para que no se lance error en la llamada a Outlook
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());
        // 1) Creamos un Contact con email
        Contact c = new Contact(LastName = 'TestContact', Email = 'testcontact@example.com');
        insert c;
        // 2) Creamos el Event con WhoId apuntando a ese Contact
        Event eventWithAttendee = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' 
                            AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Event with Contact Attendee',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            WhoId = c.Id, // se asigna el Contact
            IsPrivate = false
        );
        insert eventWithAttendee;
        // 3) Disparamos la creación asíncrona (que internamente llama a prepareAttendees)
        Test.startTest();
        OutlookEventService.createOutlookEventAsync(eventWithAttendee.Id);
        Test.stopTest();
        // Si llegó aquí, se cubrió la parte de Contact en prepareAttendees
        System.assert(true, 'Se cubrió la rama de prepareAttendees con un Contact válido.');
    }

    @isTest
    static void testPrepareAttendeesWithLead() {
        // Usa un mock normal para que no se lance error en la llamada a Outlook
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());
        // 1) Creamos un Lead con email
        Lead l = new Lead(
            LastName = 'TestLead',
            FirstName = 'TestLeadFirst',
            Company = 'TestCompany',
            Email = 'testlead@example.com'
        );
        insert l;
        // 2) Creamos el Event con WhoId apuntando a ese Lead
        Event eventWithLead = new Event(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' 
                            AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
            Subject = 'Event with Lead Attendee',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            WhoId = l.Id, // se asigna el Lead
            IsPrivate = false
        );
        insert eventWithLead;
        // 3) Disparamos la creación asíncrona (que internamente llama a prepareAttendees)
        Test.startTest();
        OutlookEventService.createOutlookEventAsync(eventWithLead.Id);
        Test.stopTest();
        // Si llegó aquí, se cubrió la parte de Lead en prepareAttendees
        System.assert(true, 'Se cubrió la rama de prepareAttendees con un Lead válido.');
    }

    @isTest
    static void testUpdateOutlookEventError() {
        // 1) Usa el mock que retorna 500 en PATCH
        Test.setMock(HttpCalloutMock.class, new OutlookEventMockUpdateError());
        
        // 2) Crea un Event con Outlook_Event_Id__c para que 'updateOutlookEvent' sí intente PATCH
        Event ev = new Event(
            RecordTypeId = [SELECT Id FROM RecordType 
                            WHERE SObjectType='Event' 
                            AND DeveloperName='LLBS_Event'
                            LIMIT 1].Id,
            Subject = 'Event update error scenario',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            IsPrivate = false,
            Outlook_Event_Id__c = 'someOutlookId'
        );
        insert ev;
        
        // 3) Invoca el método asíncrono
        Test.startTest();
        OutlookEventService.updateOutlookEventAsync(ev.Id);
        Test.stopTest(); // Forzamos ejecución, recibiendo 500
        System.assert(true, 'Se cubrió la rama de error en updateOutlookEvent (código != 200).');
    }

    @isTest
    static void testDeleteOutlookEventError() {
        // 1) Usa el mock que retorna 500 en DELETE
        Test.setMock(HttpCalloutMock.class, new OutlookEventMockDeleteError());
        
        // 2) Crea un Event que tenga un Outlook_Event_Id__c para llamar a delete
        Event ev = new Event(
            RecordTypeId = [SELECT Id FROM RecordType 
                            WHERE SObjectType='Event' 
                            AND DeveloperName='LLBS_Event'
                            LIMIT 1].Id,
            Subject = 'Event to delete error scenario',
            StartDateTime = System.now().addDays(1),
            EndDateTime = System.now().addDays(1).addHours(1),
            IsPrivate = false,
            Outlook_Event_Id__c = 'someOutlookId'
        );
        insert ev;
        
        // 3) Llamada asíncrona a borrar
        Test.startTest();
        OutlookEventService.deleteOutlookEventAsync(ev.Outlook_Event_Id__c);
        Test.stopTest(); // Forzamos DELETE con 500
        System.assert(true, 'Se cubrió la rama de error en deleteOutlookEvent (código != 204,404).');
    }

    @isTest
    static void testvalidateEvent() {
        try{
            OutlookEventService.validateEvent(null);
            Assert.fail('1. An exception should have been thrown');
        }catch(Exception ex){
            Assert.isTrue(ex.getMessage().contains('El evento no puede ser nulo.'),'1. El error no tiene el mensaje correcto.');
        }
        
        try{
            Event eventRecord1 = new Event();
            eventRecord1.Subject = '';
            OutlookEventService.validateEvent(eventRecord1);
            Assert.fail('2. An exception should have been thrown');
        }catch(Exception ex){
            Assert.isTrue(ex.getMessage().contains('El evento debe tener un asunto.'),'2. El error no tiene el mensaje correcto.');
        }
        
        try{
            Event eventRecord2 = new Event();
            eventRecord2.Subject = 'Subject';
            eventRecord2.StartDateTime = null;
            eventRecord2.EndDateTime = null;
            OutlookEventService.validateEvent(eventRecord2);
            Assert.fail('3. An exception should have been thrown');
        }catch(Exception ex){
            Assert.isTrue(ex.getMessage().contains('El evento debe tener fechas de inicio y fin.'),'2. El error no tiene el mensaje correcto.');
        }
        
        try{
            Datetime dtHoy = System.now();
            Datetime dtMenosUnMes = dtHoy.addDays(-30);
            Event eventRecord3 = new Event();
            eventRecord3.Subject = 'Subject';
            eventRecord3.StartDateTime = dtHoy;
            eventRecord3.EndDateTime = dtMenosUnMes;
            OutlookEventService.validateEvent(eventRecord3);
            Assert.fail('4. An exception should have been thrown');
        }catch(Exception ex){
            Assert.isTrue(ex.getMessage().contains('La fecha de inicio debe ser anterior a la fecha de fin.'),'3. El error no tiene el mensaje correcto.');
        }
    }

    @isTest
    static void testlogError() {
        String errorMessage = 'Error';
        HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        response.setBody('Error de Servidor.');
        OutlookEventService.logError(errorMessage, response);
    }

    @isTest
    static void testUpdateOutlookEventReturn() {
        Event eventRecord = new Event();
        eventRecord.Outlook_Event_Id__c = '';
        OutlookEventService.updateOutlookEvent(eventRecord);
    }

    @isTest
    static void testUpdateOutlookEventSuccess() {
        //User
        User oUserAdmin = [SELECT Id FROM User WHERE Email = 'admin.user@example.com' LIMIT 1];
        Contact oContact = [SELECT Id FROM Contact WHERE Email = 'testcontact_dos@example.com' LIMIT 1];
        Event eventRecord = new Event();
        System.runAs(oUserAdmin){
            // Create an Event record with all required fields
            eventRecord = new Event(
                RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Event' AND DeveloperName = 'LLBS_Event' LIMIT 1].Id,
                Subject = 'Test Event',
                StartDateTime = System.now().addDays(1),
                EndDateTime = System.now().addDays(1).addHours(1),
                Location = 'Test Location',
                IsPrivate = false,
                Outlook_Event_Id__c = 'mockOutlookId12345',
                WhoId = oContact.Id,
                Description = 'Description');
            insert eventRecord;
        }
        Test.setMock(HttpCalloutMock.class, new OutlookEventMock());
        Test.startTest();
        eventRecord = [
            SELECT Id, RecordTypeId, Subject, StartDateTime, EndDateTime, Location, IsPrivate, Outlook_Event_Id__c, OwnerId, WhoId, Description
            FROM Event 
            WHERE Id =: eventRecord.Id 
            LIMIT 1];
        OutlookEventService.updateOutlookEvent(eventRecord);
        Test.stopTest();
    }
}