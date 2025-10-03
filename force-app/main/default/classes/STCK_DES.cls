public class STCK_DES {
    public static Blob encrypt(Blob data, Blob key) {
        try {
            System.debug('[DES DEBUG] Intentando cifrar con DES. Tamaño del dato: ' + data.size());
            Blob result = Crypto.encrypt('DES', key, null, data);
            System.debug('[DES DEBUG] Cifrado DES exitoso. Tamaño del resultado: ' + (result != null ? String.valueOf(result.size()) : 'null'));
            return result;
        } catch (Exception e) {
            System.debug('[DES DEBUG] ERROR en cifrado DES: ' + e.getMessage());
            throw new AuraHandledException('Fallo en la encriptación DES: ' + e.getMessage());
        }
    }
    
    public static Blob decrypt(Blob data, Blob key) {
        try {
            System.debug('[DES DEBUG] Intentando descifrar con DES. Tamaño del dato: ' + data.size());
            Blob result = Crypto.decrypt('DES', key, null, data);
            System.debug('[DES DEBUG] Descifrado DES exitoso. Tamaño del resultado: ' + (result != null ? String.valueOf(result.size()) : 'null'));
            return result;
        } catch (Exception e) {
            System.debug('[DES DEBUG] ERROR en descifrado DES: ' + e.getMessage());
            throw new AuraHandledException('Fallo en la desencriptación DES: ' + e.getMessage());
        }
    }
}