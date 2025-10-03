public without sharing class STCK_SecurityController {

    @AuraEnabled
    public static void sendVerificationCode(String email) {
        // 1. Validación inicial: el email no puede estar en blanco.
        if (String.isBlank(email)) {
            System.debug('DEBUG: Email en blanco proporcionado.');
            throw new AuraHandledException('El email proporcionado no es válido.');
        }

        // 2. Normalizar el email para la comparación (minúsculas y sin espacios extra)
        String normalizedEmail = email.toLowerCase().trim();

        // 3. Lógica de autorización
        Boolean isLaLigaDomain = normalizedEmail.endsWith('@laliga.es');
        Boolean isSpeciallyAuthorized = getAdminEmails().contains(normalizedEmail);

        // El email es válido si es del dominio de LaLiga O si está en la lista de autorizados especiales.
        // Si no cumple NINGUNA de las dos condiciones, se lanza el error.
        if (!isLaLigaDomain && !isSpeciallyAuthorized) {
            System.debug('DEBUG: Email inválido o no autorizado: ' + email);
            throw new AuraHandledException('El email proporcionado no es válido o no está autorizado.');
        }

        // --- El resto del método permanece igual ---
        Integer code = Integer.valueOf(Math.random() * 900000 + 100000);
        Datetime expiration = Datetime.now().addMinutes(10);

        STCK_VerificationCode__c vc = new STCK_VerificationCode__c(
            Email__c = normalizedEmail, // Usar el email normalizado
            Code__c = String.valueOf(code),
            Expiration__c = expiration
        );
        upsert vc Email__c;
        System.debug('DEBUG: Registro creado para: ' + normalizedEmail);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {normalizedEmail});
        mail.setReplyTo('no-reply@produccion.laliga.es');
        mail.setSubject('Tu código de acceso para tu Tienda de LALIGA');
        
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Equipo de la Tienda de LALIGA' LIMIT 1];
        if (!owea.isEmpty()) {
            mail.setOrgWideEmailAddressId(owea[0].Id);
            System.debug('DEBUG: Usando OrgWideEmailAddress: ' + owea[0].Id);
        } else {
            mail.setSenderDisplayName('Equipo de la Tienda de LALIGA');
            System.debug('DEBUG: Usando senderDisplayName y replyTo manualmente');
        }

        String plainBody = 'Hola,\n\nTu código de verificación para acceder a la Tienda de Empleados es: ' + code + '\n\nEste código expirará en 10 minutos.\n\nGracias,\nEquipo de la Tienda de LALIGA';
        mail.setPlainTextBody(plainBody);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(true);

        System.debug('DEBUG: Antes de sendEmail');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        System.debug('DEBUG: Correo encolado para envío');
    }

    @AuraEnabled
    public static Boolean verifyCode(String email, String code) {
        if (String.isBlank(email) || String.isBlank(code)) {
            return false;
        }
        String normalizedEmail = email.toLowerCase().trim();
        List<STCK_VerificationCode__c> codes = [
            SELECT Id FROM STCK_VerificationCode__c 
            WHERE Email__c = :normalizedEmail AND Code__c = :code AND Expiration__c > :Datetime.now() 
            LIMIT 1
        ];
        if (!codes.isEmpty()) {
            delete codes[0];
            return true;
        }
        return false;
    }

    /**
     * Devuelve una lista de emails (en minúsculas) que tienen autorización especial.
     * Incluye a los administradores de sistema activos y emails específicos hardcodeados.
     */
    private static List<String> getAdminEmails() {
        List<String> emails = new List<String>();
        for (User u : [SELECT Email FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true]) {
            if (String.isNotBlank(u.Email)) {
                emails.add(u.Email.toLowerCase());
            }
        }
        emails.add('velozano@ext.laligatech.com');
        return emails;
    }
}