/**
 * =================================================================================
 * CLASE PRINCIPAL: STCK_RedsysController
 * =================================================================================
 * @description Controlador para la integración con RedSys. Versión final que incluye
 * formato forzado de FUC/Terminal y depuración avanzada.
 */
public with sharing class STCK_RedsysController {

    public class STCK_RedsysPaymentData {
        @AuraEnabled public String redsysUrl { get; set; }
        @AuraEnabled public String dsMerchantParameters { get; set; }
        @AuraEnabled public String dsSignature { get; set; }
        @AuraEnabled public String dsSignatureVersion { get; set; }
    }

    @AuraEnabled(cacheable=false)
    public static STCK_RedsysPaymentData getRedsysParameters(Id recordId, String siteUrl, Decimal totalAmount) {
        
        System.debug('[REDSYS DEBUG] --- INICIO PROCESO DE PAGO ---');
        System.debug('[REDSYS DEBUG] RecordId recibido: ' + recordId);
        System.debug('[REDSYS DEBUG] SiteUrl recibido: ' + siteUrl);
        System.debug('[REDSYS DEBUG] TotalAmount recibido: ' + totalAmount);

        // --- 1. Obtener Configuración ---
        String configName = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox 
            ? 'Credenciales_Pruebas' 
            : 'Credenciales_Produccion';
        
        STCK_RedsysConfig__mdt config = [
            SELECT STCK_SecretKey__c, STCK_FUC__c, STCK_Terminal__c, STCK_URL__c 
            FROM STCK_RedsysConfig__mdt 
            WHERE DeveloperName = :configName LIMIT 1
        ];
        String secretKey = config.STCK_SecretKey__c;

        System.debug('[REDSYS DEBUG] Entorno detectado: ' + configName);
        System.debug('[REDSYS DEBUG] FUC leído de Metadata: "' + config.STCK_FUC__c + '"');
        System.debug('[REDSYS DEBUG] Terminal leído de Metadata: "' + config.STCK_Terminal__c + '"');
        if (String.isBlank(secretKey)) {
            System.debug('[REDSYS DEBUG] FATAL: La clave secreta está vacía.');
            throw new AuraHandledException('Error: La clave secreta de RedSys no está configurada.');
        }

        // --- 2. Obtener Datos del Pedido y Validar Importe ---
        PeticionMaterial__c peticion = [SELECT Name FROM PeticionMaterial__c WHERE Id = :recordId];
        if (totalAmount == null || totalAmount <= 0) {
            throw new AuraHandledException('El importe del pedido no es válido para el pago. Total: ' + totalAmount);
        }
        System.debug('[REDSYS DEBUG] Pedido a procesar: ' + peticion.Name);

        // --- 3. Forzar Formato Correcto (Solución Definitiva) ---
        String fucCorrecto = String.valueOf(config.STCK_FUC__c).leftPad(9, '0');
        String terminalCorrecto = String.valueOf(config.STCK_Terminal__c).leftPad(3, '0');
        
        System.debug('[REDSYS DEBUG] FUC formateado (9 dígitos): "' + fucCorrecto + '"');
        System.debug('[REDSYS DEBUG] Terminal formateado (3 dígitos): "' + terminalCorrecto + '"');

        // --- 4. Definir Parámetros de RedSys ---
        Integer amount = (Integer)(totalAmount * 100); 
        String orderNumber = peticion.Name.replaceAll('[^a-zA-Z0-9]', '') + String.valueOf(Datetime.now().getTime());
        orderNumber = orderNumber.left(12);

        System.debug('[REDSYS DEBUG] OrderNumber generado para la firma: "' + orderNumber + '"');
        System.debug('[REDSYS DEBUG] Amount en céntimos para la firma: ' + amount);

        String urlOk = siteUrl + '/pago-confirmado';
        String urlKo = siteUrl + '/pago-fallido';
        String urlNotification = siteUrl + '/services/apexrest/RedsysNotification'; 

        Map<String, Object> merchantParamsMap = new Map<String, Object>{
            'DS_MERCHANT_AMOUNT' => String.valueOf(amount),
            'DS_MERCHANT_ORDER' => orderNumber,
            'DS_MERCHANT_MERCHANTCODE' => fucCorrecto,
            'DS_MERCHANT_CURRENCY' => '978',
            'DS_MERCHANT_TRANSACTIONTYPE' => '0',
            'DS_MERCHANT_TERMINAL' => terminalCorrecto,
            'DS_MERCHANT_URLOK' => urlOk,
            'DS_MERCHANT_URLKO' => urlKo,
            'DS_MERCHANT_MERCHANTURL' => urlNotification
        };

        // --- 5. Generar Firma ---
        String jsonParams = JSON.serialize(merchantParamsMap);
        System.debug('[REDSYS DEBUG] Parámetros en JSON (antes de Base64): ' + jsonParams);

        String base64Params = EncodingUtil.base64Encode(Blob.valueOf(jsonParams));
        System.debug('[REDSYS DEBUG] Ds_MerchantParameters (Base64): ' + base64Params);
        
        Blob derivedKey = STCK_TripleDES.encrypt(Blob.valueOf(orderNumber), Blob.valueOf(secretKey));
        
        Blob signatureBlob = Crypto.generateMac('HMACSHA256', Blob.valueOf(base64Params), derivedKey);
        
        String finalSignature = EncodingUtil.base64Encode(signatureBlob);
        System.debug('[REDSYS DEBUG] Ds_Signature (Base64): ' + finalSignature);

        // --- 6. Preparar Respuesta ---
        STCK_RedsysPaymentData response = new STCK_RedsysPaymentData();
        response.redsysUrl = config.STCK_URL__c;
        response.dsMerchantParameters = base64Params;
        response.dsSignature = finalSignature;
        response.dsSignatureVersion = 'HMAC_SHA256_V1';

        System.debug('[REDSYS DEBUG] --- FIN PROCESO DE PAGO ---');
        return response;
    }
// --- MÉTODO DE PRUEBA PARA AISLAR LA FIRMA ---
    @AuraEnabled
    public static String generateTestSignature(String orderNumber, String base64Params, String secretKey) {
        try {
            System.debug('--- INICIO PRUEBA DE FIRMA AISLADA ---');
            System.debug('Order Number: ' + orderNumber);
            System.debug('Base64 Params: ' + base64Params);
            
            Blob decodedSecretKey = EncodingUtil.base64Decode(secretKey);
            System.debug('Clave Secreta Decodificada.');
            
            Blob derivedKey = STCK_TripleDES.encrypt(Blob.valueOf(orderNumber), decodedSecretKey);
            System.debug('Clave Diversificada (3DES) generada.');
            
            Blob signatureBlob = Crypto.generateMac('HMACSHA256', Blob.valueOf(base64Params), derivedKey);
            System.debug('HMAC-SHA256 calculado.');
            
            String finalSignature = EncodingUtil.base64Encode(signatureBlob);
            System.debug('Firma Final: ' + finalSignature);
            
            return finalSignature;
        } catch (Exception e) {
            System.debug('ERROR EN PRUEBA DE FIRMA: ' + e.getMessage());
            return 'ERROR: ' + e.getMessage();
        }
    }
}