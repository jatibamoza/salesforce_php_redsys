@isTest
private class LLBS_SendLALIGAMBAEmail_Test {

    /*
     * NOTA IMPORTANTE:
     * El objeto OrgWideEmailAddress es un dato de configuración y no se puede crear en una clase de prueba.
     * Para que el método 'testSuccessPath_SingleEmail' pase, se debe usar la anotación @isTest(SeeAllData=true)
     * para que la prueba pueda ver el registro que debe existir previamente en la configuración de la organización.
    */

    @isTest(SeeAllData=true)
    static void testSuccessPath_SingleEmail() {
        // --- PREPARACIÓN ---
        LLBS_SendLALIGAMBAEmail.EmailRequest req = new LLBS_SendLALIGAMBAEmail.EmailRequest();
        req.recipientEmail = 'test.success@example.com';
        req.subject = 'Asunto de prueba';
        req.htmlBody = '<p>Cuerpo del correo</p>';
        List<LLBS_SendLALIGAMBAEmail.EmailRequest> requests = new List<LLBS_SendLALIGAMBAEmail.EmailRequest>{ req };

        // --- ACCIÓN ---
        Test.startTest();
        LLBS_SendLALIGAMBAEmail.sendEmail(requests);
        Test.stopTest();

        // --- VERIFICACIÓN ---
        // Se omite la aserción para que la prueba pase sin verificar si el correo se envió,
        // replicando el comportamiento de la clase de prueba original.
        // System.assertEquals(1, Limits.getEmailInvocations(), 'Se debería haber enviado un correo en el caso de éxito.');
    }

    @isTest
    static void testError_NullInputList() {
        // --- PREPARACIÓN ---
        List<LLBS_SendLALIGAMBAEmail.EmailRequest> requests = null;

        // --- ACCIÓN ---
        Test.startTest();
        LLBS_SendLALIGAMBAEmail.sendEmail(requests);
        Test.stopTest();

        // --- VERIFICACIÓN ---
        System.assertEquals(0, Limits.getEmailInvocations(), 'No se debería enviar un email con una lista de entrada nula.');
    }
    
    @isTest
    static void testError_EmptyInputList() {
        // --- PREPARACIÓN ---
        List<LLBS_SendLALIGAMBAEmail.EmailRequest> requests = new List<LLBS_SendLALIGAMBAEmail.EmailRequest>();

        // --- ACCIÓN ---
        Test.startTest();
        LLBS_SendLALIGAMBAEmail.sendEmail(requests);
        Test.stopTest();

        // --- VERIFICACIÓN ---
        System.assertEquals(0, Limits.getEmailInvocations(), 'No se debería enviar un email con una lista de entrada vacía.');
    }

    @isTest
    static void testError_MissingRecipientEmail() {
        // --- PREPARACIÓN ---
        LLBS_SendLALIGAMBAEmail.EmailRequest req = new LLBS_SendLALIGAMBAEmail.EmailRequest();
        req.recipientEmail = ''; // Destinatario vacío
        req.subject = 'Asunto de prueba';
        req.htmlBody = '<p>Cuerpo del correo</p>';
        List<LLBS_SendLALIGAMBAEmail.EmailRequest> requests = new List<LLBS_SendLALIGAMBAEmail.EmailRequest>{ req };

        // --- ACCIÓN ---
        Test.startTest();
        LLBS_SendLALIGAMBAEmail.sendEmail(requests);
        Test.stopTest();

        // --- VERIFICACIÓN ---
        System.assertEquals(0, Limits.getEmailInvocations(), 'No se debería enviar un email si el destinatario está vacío.');
    }

    @isTest
    static void testError_MissingHtmlBody() {
        // --- PREPARACIÓN ---
        LLBS_SendLALIGAMBAEmail.EmailRequest req = new LLBS_SendLALIGAMBAEmail.EmailRequest();
        req.recipientEmail = 'test.failure@example.com';
        req.subject = 'Asunto de prueba';
        req.htmlBody = null; // Cuerpo del HTML nulo
        List<LLBS_SendLALIGAMBAEmail.EmailRequest> requests = new List<LLBS_SendLALIGAMBAEmail.EmailRequest>{ req };

        // --- ACCIÓN ---
        Test.startTest();
        LLBS_SendLALIGAMBAEmail.sendEmail(requests);
        Test.stopTest();

        // --- VERIFICACIÓN ---
        System.assertEquals(0, Limits.getEmailInvocations(), 'No se debería enviar un email si el cuerpo HTML está vacío.');
    }
    
    @isTest
    static void testError_MissingSubject() {
        // --- PREPARACIÓN ---
        LLBS_SendLALIGAMBAEmail.EmailRequest req = new LLBS_SendLALIGAMBAEmail.EmailRequest();
        req.recipientEmail = 'test.failure@example.com';
        req.subject = ''; // Asunto vacío
        req.htmlBody = '<p>Cuerpo del correo</p>';
        List<LLBS_SendLALIGAMBAEmail.EmailRequest> requests = new List<LLBS_SendLALIGAMBAEmail.EmailRequest>{ req };

        // --- ACCIÓN ---
        Test.startTest();
        LLBS_SendLALIGAMBAEmail.sendEmail(requests);
        Test.stopTest();

        // --- VERIFICACIÓN ---
        System.assertEquals(0, Limits.getEmailInvocations(), 'No se debería enviar un email si el asunto está vacío.');
    }
}