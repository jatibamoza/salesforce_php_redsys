/**
 * @author:
 * @description: 
*/
public class STCK_RedsysBridgeClient {
	// Si usas Named Credential:
    // - Usa la URL: callout:RedsysBridge  (apunta a bridge_redsys.php)
    // Si no usas Named Credential, sustituye 'callout:RedsysBridge' por la URL absoluta.
    public class Result {
        public Integer statusCode;
        public String body;
        public Map<String, String> requestSent; // eco de lo que enviamos
    }
    /**
     * Envía parámetros a bridge_redsys.php en formato x-www-form-urlencoded.
     * Los nombres de campos son EXACTOS a los de Redsys (DS_MERCHANT_...).
     */
    public static Result sendPaymentFormEncoded(
        String amount,                // "12.34" (euros) o "1234" (céntimos). El puente normaliza.
        String order,                 // 4–12 (los 4 primeros dígitos). El puente refuerza.
        String merchantCode,          // FUC
        String strCurrency,              // "978" para EUR
        String txType,                // "0" compra
        String terminal,              // "1"
        String merchantUrl,           // Notificación server-to-server (URL absoluta)
        String urlOk,                 // URL de OK (URL absoluta)
        String urlKo                  // URL de KO (URL absoluta)
    ) {
        HttpRequest req = new HttpRequest();
        // Named Credential:
        req.setEndpoint('callout:RedsysBridgeNamedCredential');
        // Si NO usas Named Credential, comenta la línea anterior y usa:
        // req.setEndpoint('https://tu-dominio/bridge_redsys.php');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        // Construimos body URL-encoded con los nombres EXACTOS
        Map<String,String> params = new Map<String,String>{
            'DS_MERCHANT_AMOUNT'          => amount,
            'DS_MERCHANT_ORDER'           => order,
            'DS_MERCHANT_MERCHANTCODE'    => merchantCode,
            'DS_MERCHANT_CURRENCY'        => strCurrency,
            'DS_MERCHANT_TRANSACTIONTYPE' => txType,
            'DS_MERCHANT_TERMINAL'        => terminal,
            'DS_MERCHANT_MERCHANTURL'     => merchantUrl,
            'DS_MERCHANT_URLOK'           => urlOk,
            'DS_MERCHANT_URLKO'           => urlKo
        };

        req.setBody(urlEncodeForm(params));

        Http http = new Http();
        HTTPResponse res = http.send(req);

        Result r = new Result();
        r.statusCode = res.getStatusCode();
        r.body       = res.getBody();
        r.requestSent = params;
        return r;
    }
    /**
     * Variante JSON (por si prefieres application/json).
     */
    public static Result sendPaymentJson(
        String amount,
        String order,
        String merchantCode,
        String strCurrency,
        String txType,
        String terminal,
        String merchantUrl,
        String urlOk,
        String urlKo
    ) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:RedsysBridgeNamedCredential');
        // req.setEndpoint('https://tu-dominio/bridge_redsys.php'); // sin Named Credential

        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');

        Map<String,Object> payload = new Map<String,Object>{
            'DS_MERCHANT_AMOUNT'          => amount,
            'DS_MERCHANT_ORDER'           => order,
            'DS_MERCHANT_MERCHANTCODE'    => merchantCode,
            'DS_MERCHANT_CURRENCY'        => strCurrency,
            'DS_MERCHANT_TRANSACTIONTYPE' => txType,
            'DS_MERCHANT_TERMINAL'        => terminal,
            'DS_MERCHANT_MERCHANTURL'     => merchantUrl,
            'DS_MERCHANT_URLOK'           => urlOk,
            'DS_MERCHANT_URLKO'           => urlKo
        };
        req.setBody(JSON.serialize(payload));

        Http http = new Http();
        HTTPResponse res = http.send(req);

        Result r = new Result();
        r.statusCode = res.getStatusCode();
        r.body       = res.getBody();
        r.requestSent = new Map<String,String>{
            'DS_MERCHANT_AMOUNT'          => String.valueOf(amount),
            'DS_MERCHANT_ORDER'           => String.valueOf(order),
            'DS_MERCHANT_MERCHANTCODE'    => String.valueOf(merchantCode),
            'DS_MERCHANT_CURRENCY'        => String.valueOf(strCurrency),
            'DS_MERCHANT_TRANSACTIONTYPE' => String.valueOf(txType),
            'DS_MERCHANT_TERMINAL'        => String.valueOf(terminal),
            'DS_MERCHANT_MERCHANTURL'     => String.valueOf(merchantUrl),
            'DS_MERCHANT_URLOK'           => String.valueOf(urlOk),
            'DS_MERCHANT_URLKO'           => String.valueOf(urlKo)
        };
        return r;
    }
    // --- Helpers ---
    private static String urlEncodeForm(Map<String,String> kv) {
        List<String> parts = new List<String>();
        for (String k : kv.keySet()) {
            String v = kv.get(k);
            parts.add( encodeURIComponent(k) + '=' + encodeURIComponent(v) );
        }
        return String.join(parts, '&');
    }
    // URL-encode estilo JS encodeURIComponent (suficiente para x-www-form-urlencoded simple)
    private static String encodeURIComponent(String s) {
        if (s == null) return '';
        // Apex no tiene un encoder nativo completo para application/x-www-form-urlencoded,
        // aprovechamos que la mayoría de valores son alfanuméricos o URLs y escapamos lo básico:
        // Reemplazamos espacios por %20 (no '+') para no romper URLs.
        String enc = EncodingUtil.urlEncode(s, 'UTF-8');
        enc = enc.replace('+', '%20');
        return enc;
    }
}