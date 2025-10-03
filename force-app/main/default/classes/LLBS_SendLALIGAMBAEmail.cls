public without sharing class LLBS_SendLALIGAMBAEmail {

    /**
     * @description Clase interna para agrupar los parámetros de entrada para el método invocable.
     */
    public class EmailRequest {
        @InvocableVariable(label='Email del Destinatario' required=true)
        public String recipientEmail; // Cambiado de List<String> a String

        @InvocableVariable(label='Asunto del Correo' required=true)
        public String subject;

        @InvocableVariable(label='Cuerpo HTML del Correo' required=true)
        public String htmlBody;
    }

    /**
     * @description Envía un correo electrónico con un cuerpo y asunto dinámicos a un único destinatario.
     * @param requests Lista de solicitudes de envío (Flow siempre envía una lista, pero solo procesaremos el primer elemento).
     */
    @InvocableMethod(label='Enviar Email Genérico LLBS (Un Destinatario)' description='Envía un email con contenido HTML personalizado a un solo destinatario desde LALIGA Business School.' category='LALIGA Business School')
    public static void sendEmail(List<EmailRequest> requests) {

        // --- 0. Validar la entrada ---
        if (requests == null || requests.isEmpty() || requests[0] == null) {
            System.debug('LLBS_SendLALIGAMBAEmail: La solicitud de envío está vacía.');
            return;
        }

        EmailRequest request = requests[0];
        String recipientEmail = request.recipientEmail;
        String subject = request.subject;
        String htmlBody = request.htmlBody;

        if (String.isBlank(recipientEmail) || String.isBlank(htmlBody) || String.isBlank(subject)) {
            System.debug('LLBS_SendLALIGAMBAEmail: El email del destinatario, el asunto o el cuerpo HTML están vacíos.');
            return;
        }

        // --- 1. Obtener la dirección de correo de la organización ---
        OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'LALIGA Business School' LIMIT 1];

        System.debug('DEBUG_OWA_RESULTADO: ' + owa);

        if (owa == null) {
            System.debug('LLBS_SendLALIGAMBAEmail: ERROR: No se encontró la Org-Wide Email Address "LALIGA Business School".');
            return;
        }

        // --- 2. Preparar el correo a enviar ---
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{ recipientEmail });
        mail.setOrgWideEmailAddressId(owa.Id);
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        mail.setSaveAsActivity(false);

        // --- 3. Enviar el correo ---
        try {
            // El método sendEmail espera una lista, aunque solo contenga un elemento.
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
            System.debug('LLBS_SendLALIGAMBAEmail: Se ha procesado el envío del correo a ' + recipientEmail);
        } catch (Exception e) {
            // Si hay un error en el envío, se registra en el log.
            System.debug('LLBS_SendLALIGAMBAEmail: Ocurrió un error al intentar enviar el correo. Causa: ' + e.getMessage());
        }
    }
}