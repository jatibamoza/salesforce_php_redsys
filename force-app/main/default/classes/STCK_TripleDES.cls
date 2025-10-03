// STCK_TripleDES.cls
public with sharing class STCK_TripleDES {
    /**
     * Deriva la clave por operación aplicando 3DES-CBC(IV=0) sobre Ds_Merchant_Order.
     * @param data                Blob con Ds_Merchant_Order
     * @param keyBase64Decoded    Clave YA decodificada desde Base64 (16 o 24 bytes)
     */
    public static Blob encrypt(Blob data, Blob keyBase64Decoded) {
        // IV 8 bytes a cero
        Blob iv = EncodingUtil.convertFromHex('0000000000000000');

        // Asegurar longitud de clave (24 bytes para 3DES).
        Integer sz = keyBase64Decoded.size();
        if (sz == 24) {
            // OK
        } else if (sz == 16) {
            // Expandir a 24 bytes (2-key 3DES): K1|K2|K1
            String hex = EncodingUtil.convertToHex(keyBase64Decoded);
            String k1 = hex.substring(0, 16);   // 8 bytes
            String k2 = hex.substring(16, 32);  // 8 bytes
            String k24 = k1 + k2 + k1;
            keyBase64Decoded = EncodingUtil.convertFromHex(k24);
        } else {
            throw new AuraHandledException('La clave decodificada debe ser de 16 o 24 bytes. Tamaño actual: ' + sz);
        }
        return Crypto.encrypt('3DES', keyBase64Decoded, iv, data);
    }
}