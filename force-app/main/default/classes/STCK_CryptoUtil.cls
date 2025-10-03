public with sharing class STCK_CryptoUtil {

    // === Firma V2 (HMAC-SHA512) SOBRE LA CADENA Base64URL (sin =) ===
    //   - merchantKeyPlain: clave completa tal como viene del portal (p.ej. "sq7HjrU...").
    //   - orderNumber:      DS_MERCHANT_ORDER (12 dígitos en tu flujo).
    //   - dsMerchantParametersUrl: CADENA Base64URL SIN '=' (lo mismo que envías en el form).
    public static String computeRedsysSignatureV2(
        String merchantKeyPlain,
        String orderNumber,
        String dsMerchantParametersUrl
    ) {
        if (String.isBlank(merchantKeyPlain)) {
            throw new AuraHandledException('La clave secreta del comercio no puede estar vacía.');
        }
        if (String.isBlank(orderNumber)) {
            throw new AuraHandledException('El número de pedido (DS_MERCHANT_ORDER) es obligatorio.');
        }
        if (String.isBlank(dsMerchantParametersUrl)) {
            throw new AuraHandledException('Ds_MerchantParameters (Base64URL) es obligatorio.');
        }

        // 1) k16: primeros 16 chars o pad con '0' a la derecha (igual que en doc/PHP)
        Blob k16 = buildK16FromPlainKey(merchantKeyPlain);

        // 2) Derivar clave con AES-128-CBC (IV=0x00...00) cifrando el ORDER (texto)
        Blob derivedKeyBlob = deriveKeyAES128(k16, orderNumber);

        // 3) HMAC-SHA512 SOBRE LA CADENA Base64URL (sin '='), tal cual llega aquí
        Blob mac = Crypto.generateMac('HmacSHA512', Blob.valueOf(dsMerchantParametersUrl), derivedKeyBlob);

        // 4) Devolver en Base64URL (sin '='), igual que hace Utils::base64_url_encode_safe en PHP
        return toBase64Url(mac);
    }


    // --- Helpers ---

    /** k16 = primeros 16 caracteres de la clave o pad con '0' a la derecha */
    public static Blob buildK16FromPlainKey(String merchantKey) {
        String key = merchantKey == null ? '' : merchantKey.trim();
        String k16 = (key.length() >= 16) ? key.substring(0, 16) : key.rightPad(16, '0');
        return Blob.valueOf(k16);
    }

    /** AES-128-CBC (IV=0) cifrando el orderNumber (texto) para derivar la clave binaria */
    public static Blob deriveKeyAES128(Blob k16, String orderNumber) {
        Blob ivZeros = EncodingUtil.convertFromHex('00000000000000000000000000000000'); // 16 bytes 0x00
        Blob data = Blob.valueOf(orderNumber == null ? '' : orderNumber);
        return Crypto.encrypt('AES128', k16, ivZeros, data);
    }

    /** Convierte Blob a Base64URL ( - _ , sin '=' ) */
    public static String toBase64Url(Blob b) {
        if (b == null) return '';
        String s = EncodingUtil.base64Encode(b);
        s = s.replace('+','-').replace('/','_');
        while (s.endsWith('=')) {
            s = s.substring(0, s.length() - 1);
        }
        return s;
    }
}