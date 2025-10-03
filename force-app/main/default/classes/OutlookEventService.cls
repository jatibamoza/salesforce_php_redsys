public with sharing class OutlookEventService {
    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}
    
    private static final String BASE_ENDPOINT = 'callout:Outlook_API/v1.0/users';
    
    /**
    * Método Future para manejar callouts desde triggers.
    * @param eventId El ID del registro Event en Salesforce.
    */
    @Future(callout=true)
    public static void createOutlookEventAsync(String eventId) {
        try {
            // Consulta SOQL ajustada con manejo de excepciones
            Event eventRecord;
            try {
                eventRecord = [
                    SELECT Id, Subject, StartDateTime, EndDateTime, Location, IsPrivate, WhoId, Description,OwnerId
                    FROM Event
                    WHERE Id = :eventId
                    LIMIT 1
                ];
            } catch (Exception e) {
                throw new OtherException('No se pudo consultar el evento con el ID proporcionado.');
            }
            // Validación adicional si el evento no se encuentra
            if (eventRecord == null) {
                throw new OtherException('El evento no existe o no es accesible.');
            }
            // Llamada al método principal para crear el evento en Outlook
            createOutlookEvent(eventRecord);
        } catch (Exception e) {
            throw new OtherException('No se pudo sincronizar el evento con Outlook.');
        }
    }
    /**
    * Método original que realiza el callout HTTP.
    * @param eventRecord El registro Event en Salesforce.
    */
    public static void createOutlookEvent(Event eventRecord) {
        try {
            validateEvent(eventRecord);
            if (eventRecord.IsPrivate) {
                return;
            }
            // Obtener información del propietario del evento
            User ownerUser = [SELECT Id, Email FROM User WHERE Id = :eventRecord.OwnerId LIMIT 1];
            if(ownerUser == null || String.isBlank(ownerUser.Email)) {
                throw new OtherException('No se pudo obtener el email del propietario del evento.');
            }       
            // Obtener el email (User Principal Name) del propietario del evento
            String ownerEmail = ownerUser.Email;  // Asegúrate de que sea el UPN válido
            // Construir endpoint
            // Antes: String ownerEndpoint = BASE_ENDPOINT + '/' + ownerEmail + '/calendar/events';
            String ownerEndpoint = BASE_ENDPOINT + '/' + ownerEmail + '/calendar/events';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ownerEndpoint);
            req.setMethod('POST');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            // Invocar prepareAttendees para incluir asistentes
            List<Map<String, Object>> attendees = prepareAttendees(eventRecord);
            Map<String, Object> body = new Map<String, Object>{
                'subject' => eventRecord.Subject,
                    'start' => new Map<String, Object>{
                        'dateTime' => formatDateTime(eventRecord.StartDateTime),
                            'timeZone' => 'UTC'
                            },
                                'end' => new Map<String, Object>{
                                    'dateTime' => formatDateTime(eventRecord.EndDateTime),
                                        'timeZone' => 'UTC'
                                        },
                                            'location' => new Map<String, Object>{
                                                // Si no hay ubicación en Salesforce, se asigna "Microsoft Teams Meeting"
                                                'displayName' => String.isNotBlank(eventRecord.Location) ? eventRecord.Location : 'Microsoft Teams Meeting'
                                                    },
                                                        'attendees' => prepareAttendees(eventRecord),
                                                        'isOnlineMeeting' => true,
                                                        'onlineMeetingProvider' => 'teamsForBusiness',
                                                        'body' => new Map<String, Object>{
                                                            'contentType' => 'HTML',
                                                                // Usamos 'Description' como contenido si está disponible
                                                                'content' => String.isNotBlank(eventRecord.Description) ? eventRecord.Description : 'Sin descripción'
                                                         },
                                                         'showAs' => 'tentative'
            };
            req.setBody(JSON.serialize(body));
            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() != 201) {
                throw new OtherException('Error al sincronizar con Outlook.');
            }
            Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String outlookEventId = (String) response.get('id');
            String teamsLink = (String) response.get('onlineMeetingUrl');
            // Verificar si el enlace está en el objeto 'onlineMeeting' si 'onlineMeetingUrl' es null
            if (teamsLink == null && response.containsKey('onlineMeeting')) {
                Map<String, Object> onlineMeeting = (Map<String, Object>) response.get('onlineMeeting');
                if (onlineMeeting != null && onlineMeeting.containsKey('joinUrl')) {
                    teamsLink = (String) onlineMeeting.get('joinUrl');
                }
            }
            // Debug adicional para validar valores en la respuesta
            // Actualizar los campos en Salesforce
            if (String.isNotBlank(outlookEventId)) {
                eventRecord.Outlook_Event_Id__c = outlookEventId;
            }
            if (String.isNotBlank(teamsLink)) {
                eventRecord.Teams_Link__c = teamsLink;
            }
            update eventRecord;
        } catch (Exception e) {
            throw new OtherException('No se pudo sincronizar el evento con Outlook.');
        }
    }
    /**
    * Elimina un evento de Outlook utilizando su ID.
    * @param outlookEventId El ID del evento en Outlook.
    */
    public static void deleteOutlookEvent(String outlookEventId) {
        try {
            if (String.isBlank(outlookEventId)) {
                return; // No hacer nada si el ID está vacío
            }
            // 1) Buscar el Event que tenga ese Outlook_Event_Id__c
            Event e = [
                SELECT Id, OwnerId
                FROM Event
                WHERE Outlook_Event_Id__c = :outlookEventId
                LIMIT 1 ];
            if (e == null) {
                return;
            }
            // 2) Obtener el User dueño del evento
            User ownerUser = [
                SELECT Email
                FROM User
                WHERE Id = :e.OwnerId
                LIMIT 1 ];
            if (ownerUser == null || String.isBlank(ownerUser.Email)) {
                return;
            }
            // 3) Construir el endpoint
            String deleteEndpoint = BASE_ENDPOINT + '/' + ownerUser.Email + '/calendar/events/' + outlookEventId;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(deleteEndpoint);
            req.setMethod('DELETE');
            Http http = new Http();
            HttpResponse res = http.send(req);
            /*
            if( res.getStatusCode() == 204 ){
                System.debug('Evento eliminado en Outlook. ID: ' + outlookEventId);
            } else if (res.getStatusCode() == 404) {
                System.debug('El evento con ID ' + outlookEventId + ' no existe en Outlook. No se requiere acción adicional.');
            } else {
                logError('Error al eliminar el evento en Outlook', res);
            }*/
        }catch (Exception e) {
            System.debug('Error en deleteOutlookEvent: ' + e.getMessage());
            // No lanzar excepción para evitar interrumpir procesos no críticos
        }
    }
    /**
    * Método asíncrono para eliminar un evento de Outlook.
    * @param outlookEventId El ID del evento en Outlook.
    */
    @future(callout=true)
    public static void deleteOutlookEventAsync(String outlookEventId) {
        try {
            deleteOutlookEvent(outlookEventId);
        } catch (Exception e) {
            System.debug('Error en deleteOutlookEventAsync: ' + e.getMessage());
        }
    }
    @future(callout=true)
    public static void updateOutlookEventAsync(String eventId) {
        try {
            // Consulta el evento en Salesforce
            Event eventRecord = [
                SELECT Id, Subject, StartDateTime, EndDateTime, Location, Outlook_Event_Id__c, Description, OwnerId, WhoId
                FROM Event
                WHERE Id = :eventId
                LIMIT 1 ];
            // Llama al método principal para actualizar el evento en Outlook
            updateOutlookEvent(eventRecord);
        } catch (Exception e) {
            System.debug('Error en updateOutlookEventAsync: ' + e.getMessage());
        }
    }
    
    public static void updateOutlookEvent(Event eventRecord) {
        try {
            // Validar que el evento tiene un ID de Outlook para actualizar
            if( String.isBlank(eventRecord.Outlook_Event_Id__c) ) {
                System.debug('El evento no tiene un ID de Outlook. No se puede actualizar.');
                return;
            }
            // 1) Obtener el Owner Email del evento
            System.debug('##Owner Id: ' + eventRecord.OwnerId );
            List<User> ownerUser = [
                SELECT Id, Email
                FROM User
                WHERE Id =: eventRecord.OwnerId
                LIMIT 1 ];
            String ownerEmail = ownerUser[0].Email;
            // 2) Construir la URL
            // Ejemplo de BASE_ENDPOINT: 'callout:Outlook_API/v1.0/users'
            String endpointUrl = BASE_ENDPOINT + '/' + ownerEmail + '/calendar/events/' + eventRecord.Outlook_Event_Id__c;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointUrl);
            req.setMethod('PATCH');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json'); // Encabezado requerido
            // invocar prepareAttendees para incluir asistentes
            List<Map<String, Object>> attendees = prepareAttendees(eventRecord);
            // Construir el cuerpo del evento a actualizar
            Map<String, Object> body = new Map<String, Object>{
                'subject' => eventRecord.Subject,
                'start' => new Map<String, Object>{
                	'dateTime' => formatDateTime(eventRecord.StartDateTime),
                	'timeZone' => 'UTC'},
                'end' => new Map<String, Object>{
                    'dateTime' => formatDateTime(eventRecord.EndDateTime),
                    'timeZone' => 'UTC'
                    },
                'location' => new Map<String, Object>{
                    'displayName' => String.isNotBlank(eventRecord.Location) ? eventRecord.Location : 'Microsoft Teams Meeting'
                    },
                'body' => new Map<String, Object>{
                    'contentType' => 'HTML',
                    'content' => String.isNotBlank(eventRecord.Description) ? eventRecord.Description : 'Sin descripción'
                    },
				'attendees' => attendees,
                'showAs' => 'busy'        
                };
			// Log para depuración
            System.debug('Cuerpo del evento actualizado: ' + JSON.serialize(body));
            req.setBody(JSON.serialize(body));
            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                System.debug('Evento actualizado correctamente en Outlook.');
            } else {
                logError('Error al actualizar el evento en Outlook', res);
            }
        } catch (Exception e) {
            System.debug('Error en updateOutlookEvent: ' + e.getMessage());
        }
    }
    /**
    * Valida que el evento tenga los datos necesarios antes de sincronizar.
    * @param eventRecord El registro del evento.
    */
    @TestVisible
    private static void validateEvent(Event eventRecord) {
        if (eventRecord == null) {
            throw new IllegalArgumentException('El evento no puede ser nulo.');
        }
        if (String.isBlank(eventRecord.Subject)) {
            throw new IllegalArgumentException('El evento debe tener un asunto.');
        }
        if (eventRecord.StartDateTime == null || eventRecord.EndDateTime == null) {
            throw new IllegalArgumentException('El evento debe tener fechas de inicio y fin.');
        }
        if (eventRecord.StartDateTime >= eventRecord.EndDateTime) {
            throw new IllegalArgumentException('La fecha de inicio debe ser anterior a la fecha de fin.');
        }
    }
    /**
    * Formatea una fecha para enviarla a la API de Outlook.
    * @param dateTime La fecha/hora a formatear.
    * @return La fecha en formato ISO-8601.
    */
    public static String formatDateTime(Datetime dateValue) {
        return dateValue.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }
    /**
    * Prepara la lista de asistentes para el evento.
    * @param eventRecord El registro del evento.
    * @return Una lista de asistentes en formato compatible con Outlook.
    */
    private static List<Map<String, Object>> prepareAttendees(Event eventRecord) {
        List<Map<String, Object>> attendees = new List<Map<String, Object>>();
        // Verifica si el WhoId no está vacío
        if (!String.isBlank(eventRecord.WhoId)) {
            try {
                // Determina si WhoId es un Contact o Lead
                String whoType = eventRecord.WhoId.getSObjectType().getDescribe().getName();
                if (whoType == 'Contact') {
                    // Si es un Contact, consulta el correo electrónico
                    Contact contact = [SELECT Email, Name FROM Contact WHERE Id = :eventRecord.WhoId LIMIT 1];
                    if (contact != null && String.isNotBlank(contact.Email)) {
                        attendees.add(new Map<String, Object>{
                            'emailAddress' => new Map<String, String>{'address' => contact.Email, 'name' => contact.Name},
                                'type' => 'required'
                                });
                    }
                } else if (whoType == 'Lead') {
                    // Si es un Lead, consulta el correo electrónico
                    Lead lead = [SELECT Email, Name FROM Lead WHERE Id = :eventRecord.WhoId LIMIT 1];
                    if (lead != null && String.isNotBlank(lead.Email)) {
                        attendees.add(new Map<String, Object>{
                            'emailAddress' => new Map<String, String>{'address' => lead.Email, 'name' => lead.Name},
                                'type' => 'required'
                                });
                    }
                }
            }catch( Exception e ){
                System.debug('Error al preparar asistentes: ' + e.getMessage());
            }
        }
        return attendees;
    }
    /**
    * Log de errores detallado.
    * @param errorMessage El mensaje de error.
    * @param response La respuesta HTTP.
    */
    @TestVisible
    private static void logError(String errorMessage, HttpResponse response) {
        System.debug(errorMessage + ': ' + response.getStatusCode() + ' - ' + response.getBody());
    }
}