// STCK_CestaDeComprasController.cls
public without sharing class STCK_CestaDeComprasController {

    // --- WRAPPERS ---
    public class PaymentGatewayResponse {
        @AuraEnabled public String redsysUrl { get; set; }
        @AuraEnabled public String dsMerchantParameters { get; set; }
        @AuraEnabled public String dsSignature { get; set; }
        @AuraEnabled public String dsSignatureVersion { get; set; }
        @AuraEnabled public String recoveryToken { get; set; }
    }
    public class DiscountWrapper {
        @AuraEnabled public Boolean isValid { get; set; }
        @AuraEnabled public String message { get; set; }
        @AuraEnabled public String discountType { get; set; }
        @AuraEnabled public Decimal discountValue { get; set; }
    }
    public class RequestWrapper {
        @AuraEnabled public String nombre { get; set; }
        @AuraEnabled public String email { get; set; }
        @AuraEnabled public String opcionEnvio { get; set; } // 'MRW' | 'Oficina Torrelaguna'

        // Facturación estructurada
        @AuraEnabled public String billingStreetName { get; set; }
        @AuraEnabled public String billingStreetNumber { get; set; }
        @AuraEnabled public String billingAddressLine2 { get; set; }
        @AuraEnabled public String billingPostalCode { get; set; }
        @AuraEnabled public String billingCity { get; set; }
        @AuraEnabled public String billingProvince { get; set; }

        // Identificación fiscal
        @AuraEnabled public String dni { get; set; }

        // MRW (sin bultos/peso)
        @AuraEnabled public String recipientName { get; set; }
        @AuraEnabled public String recipientEmail { get; set; }
        @AuraEnabled public String recipientPhone { get; set; }
        @AuraEnabled public String streetName { get; set; }
        @AuraEnabled public String streetNumber { get; set; }
        @AuraEnabled public String addressLine2 { get; set; }
        @AuraEnabled public String recipientZipCode { get; set; }
        @AuraEnabled public String recipientCity { get; set; }
        @AuraEnabled public String recipientState { get; set; }   // Provincia (Envío)
        @AuraEnabled public String recipientCountry { get; set; } // 'ES'
        @AuraEnabled public String serviceCode { get; set; }      // '0800'
        @AuraEnabled public String timeWindow { get; set; }       // '1' | '2'
        @AuraEnabled public String additionalNotes { get; set; }

        // Carrito / totales (como ya tenías)
        @AuraEnabled public List<CartItem> items { get; set; }
        @AuraEnabled public Decimal taxAmount { get; set; }
        @AuraEnabled public Decimal discountAmount { get; set; }
        @AuraEnabled public Decimal finalTotal { get; set; }

        // Otros
        @AuraEnabled public String promoCode { get; set; }
        @AuraEnabled public String siteUrl { get; set; }

        // (para la recuperación de pedido OK)
        @AuraEnabled public String nombreSolicitud { get; set; }
        @AuraEnabled public String orderName { get; set; }
    }

    public class CartItem {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public Integer quantity { get; set; }
        @AuraEnabled public Decimal price { get; set; }
    }

    private class RParams {
        public String DS_MERCHANT_AMOUNT;
        public String DS_MERCHANT_ORDER;
        public String DS_MERCHANT_MERCHANTCODE;
        public String DS_MERCHANT_CURRENCY;
        public String DS_MERCHANT_TRANSACTIONTYPE;
        public String DS_MERCHANT_TERMINAL;
        public String DS_MERCHANT_MERCHANTURL;
        public String DS_MERCHANT_URLOK;
        public String DS_MERCHANT_URLKO;
    }

    // ===== Helpers MRW =====
    private static final Set<String> EXCLUDED_CP_PREFIX = new Set<String>{ '07','35','38','51','52' };
    private static final Set<String> EXCLUDED_PROVINCES = new Set<String>{
        'Illes Balears','Las Palmas','Santa Cruz de Tenerife','Ceuta','Melilla'
    };

    private static Boolean isFiveDigitZip(String cp) {
        if (String.isBlank(cp)) return false;
        String t = cp.trim();
        // 5 dígitos: largo 5 y que al quitar dígitos quede cadena vacía
        return t.length() == 5 && t.replaceAll('[0-9]', '').length() == 0;
    }

     private static Boolean isExcludedZip(String cp) {
        if (!isFiveDigitZip(cp)) return false;
        String pref = cp.trim().substring(0, 2);
        return EXCLUDED_CP_PREFIX.contains(pref);
    }

    private static void validateMrwData(RequestWrapper w) {
        if (String.isBlank(w.recipientName))  throw new AuraHandledException('MRW: faltan el nombre del destinatario.');
        if (String.isBlank(w.recipientEmail)) throw new AuraHandledException('MRW: falta el correo del destinatario.');
        if (String.isBlank(w.streetName))     throw new AuraHandledException('MRW: falta la calle/vía de entrega.');
        if (String.isBlank(w.streetNumber))   throw new AuraHandledException('MRW: falta el número de portal.');
        if (!isFiveDigitZip(w.recipientZipCode)) throw new AuraHandledException('MRW: el código postal debe tener 5 dígitos.');
        if (String.isBlank(w.recipientCity))  throw new AuraHandledException('MRW: falta la ciudad de entrega.');
        if (String.isBlank(w.recipientState)) throw new AuraHandledException('MRW: falta la provincia de entrega.');

        if (EXCLUDED_PROVINCES.contains(w.recipientState)) {
            throw new AuraHandledException('MRW: provincia excluida (solo España peninsular).');
        }
        if (isExcludedZip(w.recipientZipCode)) {
            throw new AuraHandledException('MRW: código postal excluido (solo España peninsular).');
        }

        if (!(w.timeWindow == '1' || w.timeWindow == '2')) {
            throw new AuraHandledException('MRW: selecciona un tramo horario válido.');
        }
        if (String.isBlank(w.serviceCode)) {
            throw new AuraHandledException('MRW: falta el código de servicio.');
        }
    }

    @AuraEnabled
    public static PaymentGatewayResponse createOrderAndGetRedsysParams(RequestWrapper wrapper) {
        Savepoint sp = Database.setSavepoint();
        try {
            // === 1) Reutilizar pedido pendiente idéntico (mismo carrito) si existe ===
            PeticionMaterial__c existingOrder = null;
            if (String.isNotBlank(wrapper.email)) {
                String cartHash = generateCartHash(wrapper.items);
                List<PeticionMaterial__c> existingOrders = [
                    SELECT Id, OrderNumber__c, PaymentStatus__c, RecoveryToken__c
                    FROM PeticionMaterial__c
                    WHERE CorreoElectronico__c = :wrapper.email
                    AND PaymentStatus__c IN ('Pago Fallido', null)
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];
                if (!existingOrders.isEmpty()) {
                    PeticionMaterial__c cand = existingOrders[0];
                    if (cartHash == generateCartHashFromOrder(cand)) {
                        existingOrder = cand;
                        System.debug('DEBUG: Pedido fallido encontrado para reutilizar. Id=' + cand.Id);
                    }
                }
            }

            // === 2) Crear/asegurar cabecera con ORDER de 12 dígitos ===
            PeticionMaterial__c peticion;
            if (existingOrder != null) {
                peticion = existingOrder;
                // Generar SIEMPRE un nuevo ORDER (12) para reintento
                String nuevoNumeroPedido = generateNumericOrder12();
                peticion.OrderNumber__c = nuevoNumeroPedido;
                update peticion;
                System.debug('DEBUG: Reutilizando pedido ' + peticion.Id + ' con nuevo OrderNumber(12)=' + nuevoNumeroPedido);
            } else {
                peticion = new PeticionMaterial__c();
                // Datos solicitante
                peticion.PersonaSolicitante__c   = wrapper.nombre;
                peticion.CorreoElectronico__c    = wrapper.email;
                peticion.NumeroIdentificacion__c = wrapper.dni;
                peticion.TiendaEmpleados__c      = true;
                peticion.CodigodeDescuento__c    = wrapper.promoCode;

                // Facturación (estructurada)
                peticion.CalleViaFacturacion__c       = wrapper.billingStreetName;
                peticion.NumeroCalleViaFacturacion__c = wrapper.billingStreetNumber;
                peticion.PisoPuertaFacturacion__c     = wrapper.billingAddressLine2;
                peticion.CodigoPostal__c              = wrapper.billingPostalCode;
                peticion.CiudadFacturacion__c         = wrapper.billingCity;
                peticion.ProvinciaFacturacion__c      = wrapper.billingProvince;

                // Config y totales
                ConfiguracionTienda__mdt config = [
                    SELECT Porcentaje_IVA__c
                    FROM ConfiguracionTienda__mdt
                    WHERE DeveloperName = 'Default'
                    LIMIT 1
                ];
                peticion.IVA__c           = config.Porcentaje_IVA__c;
                peticion.DiscountValue__c = (wrapper.discountAmount == null ? 0 : wrapper.discountAmount);
                peticion.TotalToPay__c    = (wrapper.finalTotal == null ? 0 : wrapper.finalTotal);

                insert peticion;

                // ORDER (12) + token
                String orderNumber = generateNumericOrder12();
                peticion.OrderNumber__c   = orderNumber;
                peticion.RecoveryToken__c = generateRecoveryToken();
                update peticion;
                System.debug('DEBUG: Pedido nuevo ' + peticion.Id + ' con OrderNumber(12)=' + orderNumber);
            }

            // ===== MRW opcional =====
            if (wrapper.opcionEnvio == 'MRW') {
                validateMrwData(wrapper);
                peticion.CalleViaEntrega__c       = wrapper.streetName;
                peticion.NumeroCalleViaEntrega__c = wrapper.streetNumber;
                peticion.PisoPuertaEnvio__c       = wrapper.addressLine2;
                peticion.CiudadEnvio__c           = wrapper.recipientCity;
                peticion.ProvinciaEnvio__c        = wrapper.recipientState;
                peticion.CodigoPostalEnvio__c     = wrapper.recipientZipCode;
                update peticion;
            }

            // === 3) (si es nuevo) crear líneas — omitido por brevedad ===

            // === 4) Preparar parámetros Redsys ===
            System.debug('DEBUG: Iniciando parámetros Redsys para OrderNumber actual: ' + peticion.OrderNumber__c);

            String cfgName = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox
                ? 'Credenciales_Pruebas' : 'Credenciales_Produccion';

            STCK_RedsysConfig__mdt cfg = [
                SELECT STCK_SecretKey__c, STCK_FUC__c, STCK_Terminal__c, STCK_URL__c
                FROM STCK_RedsysConfig__mdt
                WHERE DeveloperName = :cfgName
                LIMIT 1
            ];

            // 4.0) ORDER a 12 (seguridad extra) y persistir si cambiara
            String rawOrder = String.valueOf(peticion.OrderNumber__c).trim();
            String order12  = (rawOrder.length() > 12) ? rawOrder.substring(0, 12) : rawOrder.leftPad(12, '0');
            if (order12 != rawOrder) {
                peticion.OrderNumber__c = order12;
                update peticion;
                System.debug('DEBUG: ORDER normalizado y persistido a 12 = ' + order12);
            }

            // 4.1) Importe → céntimos
            if (wrapper.finalTotal == null || wrapper.finalTotal <= 0) {
                throw new AuraHandledException('El importe total debe ser mayor que cero. Valor recibido: ' + wrapper.finalTotal);
            }
            Decimal totalRounded = wrapper.finalTotal.setScale(2, RoundingMode.HALF_UP);
            Integer amountInt = (totalRounded * 100).intValue();
            String amountString = String.valueOf(amountInt);

            // 4.2) Construcción JSON (FUC de 9 dígitos)
            String base = String.isBlank(wrapper.siteUrl) ? '' : wrapper.siteUrl.trim();
            while (base.endsWith('/')) base = base.substring(0, base.length()-1);

            // Si quieres reactivar la notificación, usa la línea comentada:
            // String merchantUrl = base + '/services/apexrest/RedsysNotification';
            String merchantUrl = ''; // según tu snippet actual
            String urlOk       = base + '/latiendadelequipo/s/pago-exitoso';
            String urlKo       = base + '/latiendadelequipo/s/pago-fallido';

            String fucRaw = (cfg.STCK_FUC__c == null ? '' : cfg.STCK_FUC__c.trim());
            String fuc9   = fucRaw.leftPad(9, '0');

            // (1) JSON
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('DS_MERCHANT_AMOUNT',          amountString);
            gen.writeStringField('DS_MERCHANT_ORDER',           order12);
            gen.writeStringField('DS_MERCHANT_MERCHANTCODE',    fuc9);
            gen.writeStringField('DS_MERCHANT_CURRENCY',        '978');
            gen.writeStringField('DS_MERCHANT_TRANSACTIONTYPE', '0');
            gen.writeStringField('DS_MERCHANT_TERMINAL',        cfg.STCK_Terminal__c); // "1"
            gen.writeStringField('DS_MERCHANT_MERCHANTURL',     merchantUrl);
            gen.writeStringField('DS_MERCHANT_URLOK',           urlOk);
            gen.writeStringField('DS_MERCHANT_URLKO',           urlKo);
            gen.writeEndObject();
            String jsonParams = gen.getAsString();
			
            // (2) Base64 URL-safe SIN '='  (paridad con tu PHP Utils::base64_url_encode_safe)
            String dsMerchantParametersUrl = EncodingUtil.base64Encode(Blob.valueOf(jsonParams))
                .replace('+','-').replace('/','_');
            while (dsMerchantParametersUrl.endsWith('=')) {
                dsMerchantParametersUrl = dsMerchantParametersUrl.substring(0, dsMerchantParametersUrl.length()-1);
            }

            // (3) Firma V2 sobre LA MISMA CADENA URL-SAFE
            String signature = STCK_CryptoUtil.computeRedsysSignatureV2(
                cfg.STCK_SecretKey__c, // clave completa (CryptoUtil recorta/pad a 16)
                order12,               // 12 dígitos
                dsMerchantParametersUrl
            );

            // === 5) Respuesta ===
            PaymentGatewayResponse resp = new PaymentGatewayResponse();
            resp.redsysUrl            = cfg.STCK_URL__c;           // URL TPV (test/prod)
            resp.dsSignatureVersion   = 'HMAC_SHA512_V2';
            resp.dsMerchantParameters = dsMerchantParametersUrl;   // URL-safe
            resp.dsSignature          = signature;                 // URL-safe
            resp.recoveryToken        = peticion.RecoveryToken__c;
           
            System.debug('DEBUG: Respuesta final para Redsys=' + JSON.serialize(resp));
            return resp;

        } catch (Exception e) {
            Database.rollback(sp);
            String msg = 'Error en el proceso de pago: ' + e.getMessage() +
                ' | Tipo: ' + e.getTypeName() +
                ' | Línea: ' + e.getLineNumber() +
                ' | Stack: ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, 'DEBUG: ' + msg);
            throw new AuraHandledException(e.getMessage());
        }
    }




    @AuraEnabled(cacheable=true)
    public static RequestWrapper getCartForRecovery(String recoveryToken) {
        System.debug('DEBUG getCartForRecovery: token=' + recoveryToken);
        if (String.isBlank(recoveryToken)) {
            System.debug('DEBUG getCartForRecovery: token vacío → return null');
            return null;
        }

        try {
            // 1) Cabecera de la petición (con campos ESTRUCTURADOS de facturación y entrega)
            PeticionMaterial__c p = [
                SELECT Id, Name, OrderNumber__c,
                    PersonaSolicitante__c, CorreoElectronico__c,
                    // Facturación estructurada
                    CalleViaFacturacion__c, NumeroCalleViaFacturacion__c, PisoPuertaFacturacion__c,
                    CodigoPostal__c, CiudadFacturacion__c, ProvinciaFacturacion__c,
                    // Identificación fiscal
                    NumeroIdentificacion__c,
                    // Entrega (MRW)
                    CalleViaEntrega__c, NumeroCalleViaEntrega__c, PisoPuertaEnvio__c,
                    CiudadEnvio__c, ProvinciaEnvio__c, CodigoPostalEnvio__c,
                    // Totales
                    DiscountValue__c, IVA__c, TotalToPay__c
                FROM PeticionMaterial__c
                WHERE RecoveryToken__c = :recoveryToken
                LIMIT 1
            ];

            // 2) Líneas del carrito
            List<LineaPeticionMaterial__c> lines = [
                SELECT Producto__c, Cantidad__c, PrecioUnidad__c
                FROM LineaPeticionMaterial__c
                WHERE PeticionMaterial__c = :p.Id
            ];

            // 3) Construir items y totales
            List<CartItem> items = new List<CartItem>();
            Decimal subtotal = 0;

            for (LineaPeticionMaterial__c l : lines) {
                CartItem ci = new CartItem();
                ci.id       = String.valueOf(l.Producto__c);
                ci.quantity = (l.Cantidad__c == null) ? 0 : Integer.valueOf(String.valueOf(l.Cantidad__c));
                ci.price    = (l.PrecioUnidad__c == null) ? 0 : l.PrecioUnidad__c.setScale(2, RoundingMode.HALF_UP);
                items.add(ci);
                subtotal += (ci.price * ci.quantity);
            }

            Decimal discount = (p.DiscountValue__c == null) ? 0 : p.DiscountValue__c;
            Decimal vatRate  = (p.IVA__c == null) ? 0 : p.IVA__c;

            Decimal baseImponible = subtotal - discount;
            if (baseImponible < 0) baseImponible = 0;

            Decimal taxAmount = (baseImponible * vatRate) / 100;
            Decimal finalTotal = (p.TotalToPay__c != null) ? p.TotalToPay__c : (baseImponible + taxAmount);

            // 4) Armar el wrapper con el NUEVO esquema
            RequestWrapper w = new RequestWrapper();

            // Solicitante e identificación
            w.nombre = p.PersonaSolicitante__c;
            w.email  = p.CorreoElectronico__c;
            w.dni    = p.NumeroIdentificacion__c;

            // Facturación (estructurada)
            w.billingStreetName    = p.CalleViaFacturacion__c;
            w.billingStreetNumber  = p.NumeroCalleViaFacturacion__c;
            w.billingAddressLine2  = p.PisoPuertaFacturacion__c;
            w.billingPostalCode    = p.CodigoPostal__c;
            w.billingCity          = p.CiudadFacturacion__c;
            w.billingProvince      = p.ProvinciaFacturacion__c;

            // Entrega (MRW) – si ya existiera info guardada en la petición
            w.streetName        = p.CalleViaEntrega__c;
            w.streetNumber      = p.NumeroCalleViaEntrega__c;
            w.addressLine2      = p.PisoPuertaEnvio__c;
            w.recipientCity     = p.CiudadEnvio__c;
            w.recipientState    = p.ProvinciaEnvio__c;
            w.recipientZipCode  = p.CodigoPostalEnvio__c;

            // Carrito / totales
            w.items          = items;
            w.discountAmount = discount;
            w.taxAmount      = taxAmount;
            w.finalTotal     = finalTotal;

            // Para la página de OK
            w.nombreSolicitud = p.Name;           // SM-xxxxx
            w.orderName       = p.OrderNumber__c; // 12 dígitos

            System.debug('DEBUG getCartForRecovery: wrapper=' + JSON.serialize(w));
            return w;

        } catch (QueryException qe) {
            System.debug(LoggingLevel.WARN, 'getCartForRecovery: no se encontró Peticion por token. ' + qe.getMessage());
            return null;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'getCartForRecovery: error inesperado: ' + e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static Boolean verifyRedsysSignature(
        String dsMerchantParameters,
        String dsSignature,
        String orderNumber,
        String signatureVersion
    ) {
        try {
            String cfgName = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox
                ? 'Credenciales_Pruebas' : 'Credenciales_Produccion';

            STCK_RedsysConfig__mdt cfg = [
                SELECT STCK_SecretKey__c
                FROM STCK_RedsysConfig__mdt
                WHERE DeveloperName = :cfgName
                LIMIT 1
            ];

            // --- AÑADE ESTA LÍNEA AQUÍ PARA DEPURAR ---
            System.debug('CLAVE SECRETA LEÍDA DE LA METADATA: ' + cfg.STCK_SecretKey__c);

            if (cfg == null || String.isBlank(cfg.STCK_SecretKey__c)) return false;

            // Recalcular firma V2 sobre **URL-safe** tal como llega
            String expected = STCK_CryptoUtil.computeRedsysSignatureV2(
                cfg.STCK_SecretKey__c,
                orderNumber,
                dsMerchantParameters
            );

            // Normaliza firma recibida a URL-safe sin '=' para comparar
            String received = (dsSignature == null ? '' : dsSignature.trim())
                                .replace('+','-').replace('/','_');
            while (received.endsWith('=')) received = received.substring(0, received.length() - 1);

            return expected == received;

        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'verifyRedsysSignature error: ' + e.getMessage());
            return false;
        }
    }

    // === Búsqueda de productos (mid-word en Name/Family/Description) ===
    @AuraEnabled(cacheable=true)
    public static List<PriceBookEntry> getProducts(String searchKey) {
        // Base
        String q = 'SELECT Id, Product2.Id, Product2.Name, Product2.Description, Product2.Family, ' +
                'Product2.Imagen__c, UnitPrice ' +
                'FROM PriceBookEntry ' +
                'WHERE Pricebook2.Name = \'Tienda de Empleados\' ' +
                'AND Product2.StockActual__c > 0 ' +
                'AND Product2.IsActive = true';

        if (String.isNotBlank(searchKey)) {
            // Normalizamos espacios y escapamos comodines y backslash para LIKE ... ESCAPE '\'
            String cleaned   = searchKey.trim();
            // Primero escapamos backslash para que no rompa el ESCAPE '\'
            cleaned = cleaned.replace('\\', '\\\\');
            // Luego escapamos comodines de LIKE
            cleaned = cleaned.replace('%','\\%').replace('_','\\_');

            // Envolvemos con %...% para mid-word
            String term = '%' + cleaned + '%';

            // Escapamos comillas simples para concatenar en SOQL dinámico
            String escTerm = String.escapeSingleQuotes(term);

            // Construimos el filtro repitiendo ESCAPE '\'
            String likeName        = ' Product2.Name LIKE \'' + escTerm + '\' ESCAPE \'\\\\\' ';
            String likeFamily      = ' Product2.Family LIKE \'' + escTerm + '\' ESCAPE \'\\\\\' ';
            String likeDescription = ' Product2.Description LIKE \'' + escTerm + '\' ESCAPE \'\\\\\' ';

            q += ' AND ( ' + likeName + ' OR ' + likeFamily + ' OR ' + likeDescription + ' )';
        }

        q += ' ORDER BY Product2.Name ASC LIMIT 200';
        return Database.query(q);
    }


    // === Lógica de horario (igual que antes) ===
    @AuraEnabled(cacheable=true)
    public static Boolean checkIfStoreIsOpen() {
        if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) return true;
        Date today = Date.today();
        Integer dayOfMonth = today.day();
        Integer dayOfWeek = Integer.valueOf(Datetime.newInstance(today, Time.newInstance(0, 0, 0, 0)).format('u'));
        if (dayOfWeek != 1) return false;
        if (!((dayOfMonth >= 1 && dayOfMonth <= 7) || (dayOfMonth >= 15 && dayOfMonth <= 21))) return false;
        if (![SELECT ActivityDate FROM Holiday WHERE ActivityDate = :today LIMIT 1].isEmpty()) return false;
        return true;
    }


    private static String generateRecoveryToken() {
        // 64 chars: hex de SHA-256(timestamp + random)
        return EncodingUtil.convertToHex(
            Crypto.generateDigest('SHA-256', Blob.valueOf(String.valueOf(Datetime.now().getTime()) + ':' + String.valueOf(Crypto.getRandomInteger())))
        );
    }

    // === Vouchers ===
    @AuraEnabled
    public static DiscountWrapper validatePromoCode(String promoCode, Decimal baseAmount, String email) {
        DiscountWrapper response = new DiscountWrapper();
        response.isValid = false;

        // Validaciones básicas
        if (String.isBlank(promoCode)) {
            response.message = 'Por favor, introduzca un código.';
            return response;
        }
        if (baseAmount == null || baseAmount <= 0) {
            response.message = 'El importe de la compra es inválido o no informado.';
            return response;
        }
        if (String.isBlank(email)) {
            response.message = 'Para validar el voucher necesitamos tu correo electrónico.';
            return response;
        }

        // Traer voucher con nuevos campos
        List<STCK_Voucher__c> vouchers = [
            SELECT VoucherCode__c, IsActive__c, EffectiveDate__c, ExpirationDate__c,
                ExpirationType__c, Type__c, FaceValue__c, DiscountPercentage__c,
                MinPurchase__c, PerEmailLimit__c
            FROM STCK_Voucher__c
            WHERE VoucherCode__c = :promoCode AND IsActive__c = true
            LIMIT 1
        ];
        if (vouchers.isEmpty()) {
            response.message = 'El código del voucher no es válido.';
            return response;
        }

        STCK_Voucher__c voucher = vouchers[0];
        Date today = Date.today();

        // Vigencia (igual que antes)
        if (voucher.ExpirationType__c == 'Fixed Date') {
            if (voucher.EffectiveDate__c == null || today != voucher.EffectiveDate__c) {
                response.message = 'Este voucher es válido únicamente el ' +
                                (voucher.EffectiveDate__c != null ? voucher.EffectiveDate__c.format() : 'día indicado');
                return response;
            }
        } else if (voucher.ExpirationType__c == 'Period') {
            Boolean startsOk = (voucher.EffectiveDate__c == null) ? true : today >= voucher.EffectiveDate__c;
            Boolean endsOk   = (voucher.ExpirationDate__c == null) ? true : today <= voucher.ExpirationDate__c;
            if (!(startsOk && endsOk)) {
                response.message = 'Este voucher no está vigente para la fecha de hoy.';
                return response;
            }
        }

        // >>> NUEVO: compra mínima (se evalúa sobre el importe base antes de IVA)
        if (voucher.MinPurchase__c != null && baseAmount < voucher.MinPurchase__c) {
            response.message = 'Compra mínima no alcanzada. Este voucher requiere al menos ' +
                            String.valueOf(voucher.MinPurchase__c.setScale(2)) + ' € (antes de impuestos).';
            return response;
        }

        // >>> NUEVO: límite por email (contamos canjes ya pagados con este código y email)
        if (voucher.PerEmailLimit__c != null && voucher.PerEmailLimit__c > 0) {
            Integer usedTimes = [
                SELECT COUNT()
                FROM PeticionMaterial__c
                WHERE CorreoElectronico__c = :email
                AND CodigodeDescuento__c = :promoCode
                AND PaymentStatus__c = 'Paid'
            ];
            if (usedTimes >= voucher.PerEmailLimit__c.intValue()) {
                response.message = 'Límite alcanzado. Este correo ya ha canjeado este voucher ' +
                                String.valueOf(usedTimes) + ' de ' +
                                String.valueOf(voucher.PerEmailLimit__c.intValue()) + ' veces permitidas.';
                return response;
            }
        }

        // Tipo / valor (igual que antes)
        response.isValid = true;
        response.message = 'Descuento aplicado correctamente.';

        if (voucher.Type__c == 'Fixed Value') {
            response.discountType  = 'FIXED';
            response.discountValue = (voucher.FaceValue__c == null) ? 0 : voucher.FaceValue__c;
        } else if (voucher.Type__c == 'Discount Percentage') {
            response.discountType  = 'PERCENTAGE';
            response.discountValue = (voucher.DiscountPercentage__c == null) ? 0 : voucher.DiscountPercentage__c;
        } else {
            response.isValid = false;
            response.message = 'Tipo de voucher no reconocido.';
        }
        return response;
    }

    @AuraEnabled(cacheable=true)
    public static ConfiguracionTienda__mdt getStoreConfiguration() {
        return [
            SELECT Porcentaje_IVA__c
            FROM ConfiguracionTienda__mdt
            WHERE DeveloperName = 'Default'
            LIMIT 1
        ];
    }

    // === Helpers de carrito / pedido ===
    private static String generateCartHash(List<CartItem> items) {
        if (items == null || items.isEmpty()) return '';
        // Normalizamos y ordenamos de forma determinista (por id, qty, price)
        List<String> rows = new List<String>();
        for (CartItem it : items) {
            String pid = (it.id == null) ? '' : it.id;
            Integer qty = (it.quantity == null) ? 0 : it.quantity;
            Decimal price = (it.price == null) ? 0 : it.price.setScale(2, RoundingMode.HALF_UP);
            rows.add(pid + '|' + String.valueOf(qty) + '|' + String.valueOf(price));
        }
        rows.sort();
        String acc = String.join(rows, '');
        Blob md5 = Crypto.generateDigest('MD5', Blob.valueOf(acc));
        return EncodingUtil.base64Encode(md5).left(20);
    }

    private static String generateCartHashFromOrder(PeticionMaterial__c order) {
        if (order == null) return '';
        List<LineaPeticionMaterial__c> lines = [
            SELECT Producto__c, Cantidad__c, PrecioUnidad__c
            FROM LineaPeticionMaterial__c
            WHERE PeticionMaterial__c = :order.Id
        ];
        if (lines.isEmpty()) return '';
        // Construimos filas normalizadas y las ordenamos
        List<String> rows = new List<String>();
        for (LineaPeticionMaterial__c l : lines) {
            String pid = (l.Producto__c == null) ? '' : l.Producto__c;
            Integer qty = (l.Cantidad__c == null) ? 0 : Integer.valueOf(l.Cantidad__c);
            Decimal price = (l.PrecioUnidad__c == null) ? 0 :
                Decimal.valueOf(String.valueOf(l.PrecioUnidad__c)).setScale(2, RoundingMode.HALF_UP);
            rows.add(pid + '|' + String.valueOf(qty) + '|' + String.valueOf(price));
        }
        rows.sort();
        String acc = String.join(rows, '');
        Blob md5 = Crypto.generateDigest('MD5', Blob.valueOf(acc));
        return EncodingUtil.base64Encode(md5).left(20);
    }

    // Genera un DS_MERCHANT_ORDER de 12 dígitos numéricos.
    // Base: yyMMddHHmmss (12). Si colisiona, sustituye los 2 últimos por un sufijo aleatorio.
    // Si persiste la colisión, cae a un random de 12 dígitos.
    private static String generateNumericOrder12() {
        // 1) Base determinista de 12 dígitos (TZ fija)
        String base = Datetime.now().format('yyMMddHHmmss', 'UTC'); // o 'Europe/Madrid'
        String candidate = base;

        Integer tries = 0;
        while (tries < 5) {
            Integer cnt = [
                SELECT COUNT()
                FROM PeticionMaterial__c
                WHERE OrderNumber__c = :candidate
            ];
            if (cnt == 0) return candidate;

            // 2) Reemplaza los 2 últimos dígitos por un sufijo aleatorio (00..99)
            Integer rnd = Math.abs(Math.mod(Crypto.getRandomInteger(), 100));
            String suf = String.valueOf(rnd).leftPad(2, '0');

            // Ojo: aquí sí se aplica el sufijo
            candidate = base.substring(0, 10) + suf;
            tries++;
        }

        // 3) Último recurso: 12 dígitos aleatorios (criptográficamente pseudoaleatorios)
        String fallback = '';
        for (Integer i = 0; i < 12; i++) {
            Integer d = Math.abs(Math.mod(Crypto.getRandomInteger(), 10));
            fallback += String.valueOf(d);
        }

        // (Opcional) último check por si acaso
        Integer cnt2 = [
            SELECT COUNT()
            FROM PeticionMaterial__c
            WHERE OrderNumber__c = :fallback
        ];
        return (cnt2 == 0) ? fallback : base; // improbable, pero devuelve base si choca
    }


    /** Suma el peso de los items del carrito a partir de Product2.STCK_Peso__c (gramos). Devuelve Kg. */
    private static Decimal computeCartWeightKg(List<CartItem> items) {
        if (items == null || items.isEmpty()) return 0;

        Set<Id> pids = new Set<Id>();
        for (CartItem it : items) if (it != null && it.id != null) pids.add((Id) it.id);
        if (pids.isEmpty()) return 0;

        Map<Id, Decimal> gramsById = new Map<Id, Decimal>();
        for (Product2 p : [
            SELECT Id, STCK_Peso__c
            FROM Product2
            WHERE Id IN :pids
        ]) {
            gramsById.put(p.Id, (p.STCK_Peso__c == null ? 0 : p.STCK_Peso__c));
        }

        Decimal totalGr = 0;
        for (CartItem it : items) {
            if (it == null || it.id == null) continue;
            Integer qty = (it.quantity == null ? 0 : it.quantity);
            Decimal perGr = gramsById.get((Id) it.id);
            if (perGr == null) perGr = 0;
            totalGr += (perGr * qty);
        }
        // Gramos -> Kg
        Decimal totalKg = (totalGr == 0 ? 0 : (totalGr / 1000));
        return totalKg.setScale(2, RoundingMode.HALF_UP);
    }



}