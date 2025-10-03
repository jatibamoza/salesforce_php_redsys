public without sharing class STCK_DevolucionController {

    public class ReturnRequestInfo {
        @AuraEnabled public PeticionMaterial__c materialRequest { get; set; }
        @AuraEnabled public STCK_Solicituddedevolucion__c existingReturn { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static ReturnRequestInfo getMaterialRequestDetails(String requestCode, String email) {
        System.debug('--- INICIO DE BÚSQUEDA DE DEVOLUCIÓN ---');
        System.debug('Código de Solicitud recibido: ' + requestCode + ', Email: ' + email);

        if (String.isBlank(requestCode) || String.isBlank(email)) {
            throw new AuraHandledException('El código de solicitud y el correo no pueden estar vacíos.');
        }

        List<PeticionMaterial__c> requests = [
            SELECT Id, Name, PersonaSolicitante__c, CreatedDate, Estado__c,
                   (SELECT Id FROM Lineas_Peticion_Material__r)
            FROM PeticionMaterial__c
            WHERE Name = :requestCode AND CorreoElectronico__c = :email
            LIMIT 1
        ];

        if (requests.isEmpty()) {
            System.debug('RESULTADO: No se encontró la Petición de Material original.');
            throw new AuraHandledException('No se encontró ninguna solicitud que coincida con el código y el correo electrónico proporcionados.');
        }

        PeticionMaterial__c request = requests[0];
        System.debug('Petición de Material encontrada. ID: ' + request.Id);

        ReturnRequestInfo response = new ReturnRequestInfo();
        response.materialRequest = request;

        List<Id> lineItemIds = new List<Id>();
        if (request.Lineas_Peticion_Material__r != null && !request.Lineas_Peticion_Material__r.isEmpty()) {
            for (LineaPeticionMaterial__c line : request.Lineas_Peticion_Material__r) {
                lineItemIds.add(line.Id);
            }
            System.debug('IDs de Líneas de Petición encontradas: ' + lineItemIds);

            List<STCK_Solicituddedevolucion__c> existingReturns = [
                SELECT Name, Fechadesolicitud__c, Estado__c 
                FROM STCK_Solicituddedevolucion__c 
                WHERE LineadepeticionId__c IN :lineItemIds 
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
            
            if (!existingReturns.isEmpty()) {
                System.debug('ÉXITO: Se encontró una devolución existente. ID de Devolución: ' + existingReturns[0].Name);
                response.existingReturn = existingReturns[0];
            } else {
                System.debug('RESULTADO: No se encontraron devoluciones existentes para estas líneas de petición.');
            }
        } else {
            System.debug('La Petición de Material no tiene líneas de producto asociadas.');
        }

        System.debug('--- FIN DE BÚSQUEDA DE DEVOLUCIÓN ---');
        return response;
    }

    /**
     * Obtiene los valores del picklist "Metododedevolucion__c".
     */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getReturnMethods() {
        List<Map<String, String>> methodOptions = new List<Map<String, String>>();
        try {
            Schema.DescribeFieldResult fieldResult = STCK_Solicituddedevolucion__c.Metododedevolucion__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry entry : picklistEntries) {
                methodOptions.add(new Map<String, String>{'label' => entry.getLabel(), 'value' => entry.getValue()});
            }
        } catch (Exception e) {
            System.debug('Error al obtener los métodos de devolución: ' + e.getMessage());
        }
        return methodOptions;
    }

    /**
     * Crea uno o varios registros de STCK_Solicituddedevolucion__c y notifica al equipo de producción.
     */
    @AuraEnabled
    public static void processLineItemReturns(List<Id> lineItemIds, String returnMethod, Id originalRequestId) {
        if (lineItemIds == null || lineItemIds.isEmpty() || String.isBlank(returnMethod)) {
            throw new AuraHandledException('Debes seleccionar al menos un artículo y un método de devolución.');
        }
        
        List<STCK_Solicituddedevolucion__c> devoluciones = new List<STCK_Solicituddedevolucion__c>();

        for (Id lineId : lineItemIds) {
            devoluciones.add(new STCK_Solicituddedevolucion__c(
                LineadepeticionId__c = lineId,
                Metododedevolucion__c = returnMethod,
                Estado__c = 'Nueva',
                Fechadesolicitud__c = Date.today()
            ));
        }

        try {
            insert devoluciones;
            sendReturnNotificationEmail(originalRequestId, devoluciones);

        } catch (Exception e) {
            throw new AuraHandledException('Error al crear las solicitudes de devolución: ' + e.getMessage());
        }
    }

     /**
     * Envía una notificación por correo al equipo de producción sobre la nueva devolución.
     * AHORA INCLUYE HEADER Y FOOTER DESDE CUSTOM LABELS.
     */
    private static void sendReturnNotificationEmail(Id originalRequestId, List<STCK_Solicituddedevolucion__c> devoluciones) {
        
        PeticionMaterial__c pedidoOriginal = [SELECT Name FROM PeticionMaterial__c WHERE Id = :originalRequestId LIMIT 1];
        
        List<Id> lineasIds = new List<Id>();
        for(STCK_Solicituddedevolucion__c d : devoluciones) {
            lineasIds.add(d.LineadepeticionId__c);
        }
        String productosDevueltosHtml = '<ul>';
        for (LineaPeticionMaterial__c linea : [SELECT Producto__r.Name, Cantidad__c FROM LineaPeticionMaterial__c WHERE Id IN :lineasIds]) {
            productosDevueltosHtml += '<li>' + linea.Cantidad__c + ' x ' + linea.Producto__r.Name + '</li>';
        }
        productosDevueltosHtml += '</ul>';

        List<String> toAddresses = new List<String>();
        for (STCK_Notificacion_Correo__mdt notificacion : [SELECT Notificar__c FROM STCK_Notificacion_Correo__mdt WHERE Tipo__c = 'SOLICITUD_DEVOLUCION']) {
            toAddresses.add(notificacion.Notificar__c);
        }

        if (toAddresses.isEmpty()) {
            System.debug('No hay direcciones de correo configuradas para notificar devoluciones.');
            return;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject('Nueva Solicitud de Devolución registrada: ' + pedidoOriginal.Name);
        mail.setSaveAsActivity(false);

        // --- LÓGICA DE CORREO ACTUALIZADA CON IMÁGENES ---

        // 1. Obtenemos las URLs de las imágenes desde las Etiquetas Personalizadas.
        String headerUrl = System.Label.STCK_HeaderSolicituddeDevolucion;
        String footerUrl = System.Label.STCK_FooterSolicituddeDevolucion;

        // 2. Construimos el cuerpo del correo en formato HTML.
        String body = '';
        // Añadimos la imagen de cabecera si la URL existe.
        if (String.isNotBlank(headerUrl)) {
            body += '<img src="' + headerUrl + '" alt="Header" /><br/><br/>';
        }

        // Añadimos el contenido del mensaje.
        body += 'Se ha registrado una nueva solicitud de devolución para el pedido <b>' + pedidoOriginal.Name + '</b>.<br/><br/>';
        body += 'Los artículos para los que se solicita la devolución son:<br/>';
        body += productosDevueltosHtml;
        body += '<br/>Por favor, gestione la solicitud desde Salesforce.';

        // Añadimos la imagen de pie de página si la URL existe.
        if (String.isNotBlank(footerUrl)) {
            body += '<br/><br/><img src="' + footerUrl + '" alt="Footer" />';
        }

        mail.setHtmlBody(body);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}