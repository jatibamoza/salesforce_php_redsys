@RestResource(urlMapping='/RedsysNotification')
global without sharing class RedsysNotification {

    @HttpPost
    global static void handleNotification() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String dsMerchantParameters = req.params.get('Ds_MerchantParameters');
        String dsSignature          = req.params.get('Ds_Signature'); // Redsys firma en Base64URL

        if (String.isBlank(dsMerchantParameters) || String.isBlank(dsSignature)) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Parámetros faltantes.');
            return;
        }

        try {
            // 1) Decodificar Ds_MerchantParameters (Redsys lo envía en Base64 estándar)
            String base64Std  = toBase64Std(dsMerchantParameters); // tolera si viniera url-safe
            String jsonParams = EncodingUtil.base64Decode(base64Std).toString();

            // 2) Parsear JSON de Redsys
            Map<String, Object> paramsMap =
                (Map<String, Object>) System.JSON.deserializeUntyped(jsonParams);

            String orderNumber = (String) paramsMap.get('Ds_Order');
            if (String.isBlank(orderNumber)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('Ds_Order no presente.');
                return;
            }

            // 3) Cargar clave secreta
            String cfgName = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox
                ? 'Credenciales_Pruebas' : 'Credenciales_Produccion';

            STCK_RedsysConfig__mdt cfg = [
                SELECT STCK_SecretKey__c
                FROM STCK_RedsysConfig__mdt
                WHERE DeveloperName = :cfgName
                LIMIT 1
            ];
            if (cfg == null || String.isBlank(cfg.STCK_SecretKey__c)) {
                res.statusCode = 500;
                res.responseBody = Blob.valueOf('Clave secreta no configurada.');
                return;
            }

            // 4) Verificar firma V2 (HMAC-SHA512). Esperado en Base64URL canonical
            String expected = STCK_CryptoUtil.computeRedsysSignatureV2(
                cfg.STCK_SecretKey__c,
                orderNumber,
                dsMerchantParameters // ¡IMPORTANTE! tal cual lo recibimos
            );
            String received = normalizeBase64Url(dsSignature);

            if (expected != received) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('Firma inválida.');
                return;
            }

            // 5) Éxito si Ds_Response ∈ [0..99]
            Boolean isSuccess = false;
            if (paramsMap.containsKey('Ds_Response')) {
                String codeStr = String.valueOf(paramsMap.get('Ds_Response')); // puede venir "0000" o "0"
                Integer code;
                try { code = Integer.valueOf(codeStr); } catch (Exception ignore) { code = 999; }
                isSuccess = (code >= 0 && code <= 99);
            }

            // 6) Actualizar pedido por OrderNumber__c
            List<PeticionMaterial__c> orders = [
                SELECT Id, PaymentStatus__c
                FROM PeticionMaterial__c
                WHERE OrderNumber__c = :orderNumber
                LIMIT 1
            ];
            if (orders.isEmpty()) {
                res.statusCode = 404;
                res.responseBody = Blob.valueOf('Pedido no encontrado.');
                return;
            }

            PeticionMaterial__c o = orders[0];
            o.PaymentStatus__c = isSuccess ? 'Paid' : 'Failed';
            update o;

            res.statusCode = 200;
            res.responseBody = Blob.valueOf('OK');
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
                'Error RedsysNotification: ' + e.getMessage() + ' | ' + e.getStackTraceString());
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('Error interno.');
        }
    }

    // --- Helpers Base64 ---

    // Convierte posible Base64URL a Base64 estándar y añade padding si falta
    private static String toBase64Std(String s) {
        String t = (s == null) ? '' : s.trim().replace('-', '+').replace('_', '/');
        Integer mod = Math.mod(t.length(), 4);
        if (mod != 0) t = t + ''.leftPad(4 - mod, '='); // padding a múltiplo de 4
        return t;
    }

    // Normaliza a Base64URL canónico (sin '=')
    private static String normalizeBase64Url(String s) {
        if (s == null) return '';
        String r = s.trim().replace('+','-').replace('/','_');
        while (r.endsWith('=')) r = r.substring(0, r.length()-1);
        return r;
    }
}