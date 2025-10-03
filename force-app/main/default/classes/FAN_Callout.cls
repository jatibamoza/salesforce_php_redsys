public class FAN_Callout  {

    /*public static String token  { get;set; }
    private static FAN_Callout wsDSP = new FAN_Callout();

    public String GetToken(){
        
        String input;
        masterpackage.CalloutUtility.CalloutResult log = new masterpackage.CalloutUtility.CalloutResult();
        System.debug('--------   Recuperando token de sesión   --------');
        input = 'Recuperando token de sesión\n';

        FAN_DSPConnection__mdt securityConnection = FAN_DSPConnection__mdt.getInstance('DSP_TOKEN');

        TokenRequestWrapper tokenRequestWrapper = new TokenRequestWrapper();
                
        tokenRequestWrapper.client_id       = securityConnection.client_id__c;
        tokenRequestWrapper.client_secret   = securityConnection.client_secret__c;
        tokenRequestWrapper.resource        = securityConnection.resource__c;
        tokenRequestWrapper.grant_type      = securityConnection.grant_type__c;
        
        String endpoint     = securityConnection.endpoint__c;
        String contentType  = securityConnection.content_Type__c ;
        String method       = securityConnection.method__c;

        Http http = new Http();
        HttpResponse response = new HttpResponse();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', contentType);
        req.setMethod(method);

        //String llamada = JSON.serialize(tokenRequestWrapper);
        String llamada = 'grant_type='+securityConnection.grant_type__c+'&client_id='+securityConnection.client_id__c+'&client_secret='+securityConnection.client_secret__c+'&resource='+securityConnection.resource__c;

        System.debug('--------   Petición enviada para recuperar token: ' + llamada);
        input = input + 'Destino: ' + endpoint + '\n';
        input = input + 'Petición enviada para recuperar token: ' + llamada + '\n';

        req.setBody(llamada);

        try {
            system.debug('--------   Mensaje de salida: ' + req.getBody());
            log.RequestXML = req.getBody();
            response = http.send(req);
            String respuesta = response.getBody();

            system.debug('--------   Mensaje de respuesta: ' + respuesta);
            log.Output = respuesta;

            log.ResponseHeader = response.getStatusCode() + ': ' + response.getStatus();

            log.Successful = String.valueOf(response.getStatusCode()).substring(0,1) !='2' ? false : true;

            Map<String, Object> responseLoginMap = (Map<String, Object>) JSON.deserializeUntyped(respuesta);

            //Obtenemos el Token de la respuesta, lo almacenamos en una variable y llamamos a EnviarSubscripcion pasándole el token.
            token = (String) responseLoginMap.get('access_token');

            System.debug('--------   RESPUESTAWSLOGIN: ' + responseLoginMap);
            System.debug('--------   AUTHORIZATION KEY: ' + token);
            System.debug('--------   Recuperado token de sesión   --------');
            
            input = input + 'Recuperado token de sesión\n';

        } catch(Exception e) {
            system.debug('--------   Error no controlado en llamada a WS token: ' + e.getMessage());
            log.Successful = false;
            log.Message = e.getMessage() + ' // ' + e.getStackTraceString();
        }

        log.Input = input;

        masterpackage.CalloutUtility.CreateCalloutLog_SF_EXT('ObtenerToken', log);
        return token;
    }

    public HttpResponse EnviarProducto(String IdProducto, String authorizationkey, Boolean nuevo) {

        String input;
        masterpackage.CalloutUtility.CalloutResult log = new masterpackage.CalloutUtility.CalloutResult();

        FAN_DSPConnection__mdt securityConnection = nuevo ? FAN_DSPConnection__mdt.getInstance('DSP_NUEVO_PRODUCTO') : FAN_DSPConnection__mdt.getInstance('DSP_ACTUALIZAR_PRODUCTO');

        Zuora__Product__c ProductoEnvio = [SELECT Id, CreatedById, CreatedDate, LastModifiedDate, Zuora__SKU__c, Zuora__EffectiveStartDate__c, LastModifiedById, Name, Zuora__EffectiveEndDate__c, Zuora__Description__c, AppId__c, InstanciaID__c, B2B__c FROM Zuora__Product__c WHERE Id = :IdProducto LIMIT 1];

        System.debug('--------   Envío Producto en invocación: ' + IdProducto);
        input = 'Envío Producto en invocación: ' + IdProducto + '\n';

        String contentType      = securityConnection.content_Type__c;
        String authorization    = securityConnection.authorization__c;
        String endpoint = nuevo ? securityConnection.endpoint__c : securityConnection.endpoint__c + '/' + IdProducto;
        String method           = securityConnection.method__c;


        ProductoWrapper productoWrapper = New ProductoWrapper();

        productoWrapper.id                  = ProductoEnvio.Id;
        productoWrapper.createdById         = ProductoEnvio.CreatedById;
        productoWrapper.createdDate         = ProductoEnvio.CreatedDate;
        productoWrapper.updatedDate         = ProductoEnvio.LastModifiedDate;
        productoWrapper.sku                 = ProductoEnvio.Zuora__SKU__c;
        productoWrapper.effectiveStartDate  = ProductoEnvio.Zuora__EffectiveStartDate__c;
        productoWrapper.updatedById         = ProductoEnvio.LastModifiedById;
        productoWrapper.name                = ProductoEnvio.Name;
        productoWrapper.effectiveEndDate    = ProductoEnvio.Zuora__EffectiveEndDate__c;
        productoWrapper.description         = ProductoEnvio.Zuora__Description__c;
        productoWrapper.AppId               = ProductoEnvio.AppId__c;
        productoWrapper.InstanciaID         = ProductoEnvio.InstanciaId__c;
        productoWrapper.B2B                 = ProductoEnvio.B2B__c ? 'verdadero' : 'falso';
        
        Http http = new Http();
        HttpResponse res = new HttpResponse();

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', contentType);
        req.setHeader('Authorization', authorization + ' ' + authorizationkey);
        req.setEndpoint(endpoint);
        req.setMethod(method);

        System.debug('--------   Petición enviada para crear/actualizar producto: ' + JSON.serialize(productoWrapper));
        System.debug('--------   Authorization: ' + req.getHeader('Authorization'));
        input = input + 'Destino: ' + endpoint + '\n';
        input = input + 'Petición enviada para crear/actualizar producto\n';

        String llamada = JSON.serializePretty(productoWrapper,false);

        req.setBody(llamada);
        req.setTimeout(120000);

        try {

            log.RequestXML = req.getBody();
            res = http.send(req);
            System.debug('--------   Contenido de la respuesta ENVÍO: ' + res.getBody());
            log.Output = res.getBody();
            log.ResponseHeader = res.getStatusCode() + ': ' + res.getStatus();

            log.Successful = String.valueOf(res.getStatusCode()).substring(0,1) !='2' ? false : true;

        } catch(Exception e) {
            system.debug('--------   Error no controlado en llamada a WS producto: ' + e.getMessage());
            log.Successful = false;
            log.Message = e.getMessage() + ' // ' + e.getStackTraceString();
        }

        log.Input = input;

        masterpackage.CalloutUtility.CreateCalloutLog_SF_EXT('EnviarProducto'+(nuevo?'Nuevo':'Actualizar'), log);

        return res;
    }

    public HttpResponse EnviarSuscripcion(String IdSuscripcion, String authorizationkey, Boolean nuevo) {
    
        String input;
        masterpackage.CalloutUtility.CalloutResult log = new masterpackage.CalloutUtility.CalloutResult();

        Zuora__Subscription__c suscripcionEnvio = [SELECT   Id, Zuora__Account__r.IdFan__c, Zuora__TermStartDate__c, LastModifiedDate, Zuora__Version__c,
                                                            Zuora__AutoRenew__c, Zuora__SubscriptionStartDate__c, Zuora__InitialTerm__c, Zuora__InitialTermPeriodType__c,
                                                            Zuora__CurrentTermPeriodType__c, Zuora__Account__r.Id,  Zuora__CurrentTerm__c, Zuora__RenewalTermPeriodType__c,
                                                            Zuora__ContractEffectiveDate__c, LastModifiedById, Zuora__ContractAcceptanceDate__c, CreatedById,
                                                            CreatedDate, Name, Zuora__Status__c, Zuora__ServiceActivationDate__c,
                                                            Zuora__OriginalId__c, Zuora__RenewalTerm__c, Zuora__TermEndDate__c, Zuora__TermSettingType__c,
                                                            Zuora__OriginalCreated_Date__c, Zuora__SubscriptionEndDate__c, CancelRequested__c, 
                                                            CancelRequestedDate__c, CancelExpectedDate__c
                                                            FROM Zuora__Subscription__c WHERE Id = :IdSuscripcion];

        List<masterpackage__CalloutLog__c> logList = [SELECT Id FROM masterpackage__CalloutLog__c WHERE masterpackage__Record_Id__c =: suscripcionEnvio.Name];
		nuevo = logList.size() == 0 ? true : false;
        if (masterpackage.CalloutUtility.PendingLogs.size() > 0) {
			for (masterpackage__CalloutLog__c pending : masterpackage.CalloutUtility.PendingLogs) {
				nuevo = pending.masterpackage__Record_Id__c == suscripcionEnvio.Name ? false : nuevo;
			}
		} 

        FAN_DSPConnection__mdt securityConnection = nuevo ? FAN_DSPConnection__mdt.getInstance('DSP_NUEVA_SUSCRIPCION') : FAN_DSPConnection__mdt.getInstance('DSP_ACTUALIZAR_SUSCRIPCION');

        System.debug('--------    Envío suscripción en invocación: ' + IdSuscripcion);
        input = 'Envío suscripción en invocación: ' + IdSuscripcion + '/n';

        String contentType      = securityConnection.content_Type__c;
        String authorization    = securityConnection.authorization__c;
        
        String endpoint = nuevo ? securityConnection.endpoint__c : securityConnection.endpoint__c + '/' + SuscripcionEnvio.Name;
        String method           = securityConnection.method__c;

        SuscripcionWrapper suscripcionWrapper = New SuscripcionWrapper();

        suscripcionWrapper.id                       = SuscripcionEnvio.Id;
        suscripcionWrapper.idUser                   = SuscripcionEnvio.Zuora__Account__r.IdFan__c;
        suscripcionWrapper.termStartDate            = SuscripcionEnvio.Zuora__TermStartDate__c;
        suscripcionWrapper.updatedDate              = SuscripcionEnvio.LastModifiedDate;
        suscripcionWrapper.version                  = SuscripcionEnvio.Zuora__Version__c==null?null:Integer.valueof(SuscripcionEnvio.Zuora__Version__c);
        suscripcionWrapper.autoRenew                = SuscripcionEnvio.Zuora__AutoRenew__c;
        suscripcionWrapper.subscriptionStartDate    = SuscripcionEnvio.Zuora__SubscriptionStartDate__c;
        suscripcionWrapper.initialTerm              = SuscripcionEnvio.Zuora__InitialTerm__c==null?null:Integer.valueof(SuscripcionEnvio.Zuora__InitialTerm__c);
        suscripcionWrapper.initialTermPeriodType    = SuscripcionEnvio.Zuora__InitialTermPeriodType__c;
        suscripcionWrapper.accountId                = SuscripcionEnvio.Zuora__Account__r.Id;
        suscripcionWrapper.currentTermPeriodType    = SuscripcionEnvio.Zuora__CurrentTermPeriodType__c;
        suscripcionWrapper.currentTerm              = SuscripcionEnvio.Zuora__CurrentTerm__c==null?null:Integer.valueof(SuscripcionEnvio.Zuora__CurrentTerm__c);
        suscripcionWrapper.renewalTermPeriodType    = SuscripcionEnvio.Zuora__RenewalTermPeriodType__c;
        suscripcionWrapper.contractEffectiveDate    = SuscripcionEnvio.Zuora__ContractEffectiveDate__c;
        suscripcionWrapper.updatedById              = SuscripcionEnvio.LastModifiedById;
        suscripcionWrapper.contractAcceptanceDate   = SuscripcionEnvio.Zuora__ContractAcceptanceDate__c;
        suscripcionWrapper.createdById              = SuscripcionEnvio.CreatedById;
        suscripcionWrapper.createdDate              = SuscripcionEnvio.CreatedDate;
        suscripcionWrapper.name                     = SuscripcionEnvio.Name;
        suscripcionWrapper.status                   = SuscripcionEnvio.Zuora__Status__c;
        suscripcionWrapper.serviceActivationDate    = SuscripcionEnvio.Zuora__ServiceActivationDate__c;
        suscripcionWrapper.originalId               = SuscripcionEnvio.Zuora__OriginalId__c;
        suscripcionWrapper.renewalTerm              = SuscripcionEnvio.Zuora__RenewalTerm__c==null?null:Integer.valueof(SuscripcionEnvio.Zuora__RenewalTerm__c);
        suscripcionWrapper.termEndDate              = SuscripcionEnvio.Zuora__TermEndDate__c;
        suscripcionWrapper.termType                 = SuscripcionEnvio.Zuora__TermSettingType__c;
        suscripcionWrapper.originalCreatedDate      = SuscripcionEnvio.Zuora__OriginalCreated_Date__c;
        suscripcionWrapper.subscriptionEndDate      = SuscripcionEnvio.Zuora__SubscriptionEndDate__c;
        suscripcionWrapper.CancelRequested          = SuscripcionEnvio.CancelRequested__c=='Y'?true:false;
        suscripcionWrapper.CancelRequestedDate      = SuscripcionEnvio.CancelRequestedDate__c;
        suscripcionWrapper.CancelExpectedDate       = SuscripcionEnvio.CancelExpectedDate__c;

        Http http = new Http();
        HttpResponse res = new HttpResponse();

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', contentType);
        req.setHeader('Authorization', authorization + ' ' + authorizationkey);
        req.setEndpoint(endpoint);
        req.setMethod(method);

        System.debug('--------   Petición enviada para crear/actualizar suscripción: ' + JSON.serialize(suscripcionWrapper));
        System.debug('--------   Authorization: ' + req.getHeader('Authorization'));
        input = input + 'Destino: ' + endpoint + '\n';
        input = input + 'Petición enviada para crear/actualizar suscripción\n';

        String llamada = JSON.serializePretty(suscripcionWrapper,false);

        req.setBody(llamada);
        req.setTimeout(120000);

        try {

            log.RequestXML = req.getBody();
            res = http.send(req);
            System.debug('--------   Contenido de la respuesta ENVÍO: ' + res.getBody());
            log.Output = res.getBody();
            log.ResponseHeader = res.getStatusCode() + ': ' + res.getStatus();
            String statuscode = String.valueOf(res.getStatusCode());
            String tipoError = statuscode.substring(0,1);
            system.debug('--------   tipoError: ' + statuscode+'/'+tipoError);

            log.Successful = tipoError != '2' ? false : true;
            log.RecordId = tipoError == '2' ? suscripcionEnvio.Name : null; 
        } 
        catch(Exception e) {
            system.debug('--------   Error no controlado en llamada a WS suscripcion: ' + e.getMessage());
            log.Successful = false;
            log.Message = e.getMessage() + ' // ' + e.getStackTraceString();
        }
        log.Input = input;
        masterpackage.CalloutUtility.CreateCalloutLog_SF_EXT('EnviarSuscripcion'+(nuevo?'Nuevo':'Actualizar'), log);
        return res;
    }

    public HttpResponse EnviarPago(String IdPago, String authorizationkey, Boolean nuevo) {

        String input;
        String creditCardMaskNumber = '';
        String creditCardType = '';
        masterpackage.CalloutUtility.CalloutResult log = new masterpackage.CalloutUtility.CalloutResult();

        FAN_DSPConnection__mdt securityConnection = nuevo ? FAN_DSPConnection__mdt.getInstance('DSP_NUEVO_PAGO') : FAN_DSPConnection__mdt.getInstance('DSP_ACTUALIZAR_PAGO');

        Zuora__Payment__c pagoEnvio = [SELECT Id,  Zuora__Account__r.IdFan__c, Zuora__Account__r.Id,   Zuora__AccountingCode__c, 
                                        Zuora__Amount__c, Zuora__AppliedCreditBalanceAmount__c, 
                                        Zuora__AuthTransactionId__c, Zuora__BankIdentificationNumber__c, Zuora__CancelledOn__c, Zuora__Comment__c, 
                                        CreatedById, CreatedDate, 
                                        Zuora__Effective_Date__c, Zuora__GatewayOrderId__c, Zuora__GatewayResponse__c, 
                                        Zuora__GatewayResponseCode__c, Zuora__GatewayStatus__c, Zuora__MarkedForSubmissionOn__c, Zuora__PaymentMethodId__c, 
                                        Zuora__PaymentNumber__c, Zuora__ReferenceId__c, Zuora__RefundedAmount__c, Zuora__SecondPaymentReferenceId__c, 
                                        Zuora__SettledOn__c, Zuora__SoftDescriptor__c, Zuora__SoftDescriptorPhone__c, 
                                        Zuora__Status__c, Zuora__SubmittedOn__c, Zuora__TransferedToAccounting__c, Zuora__Type__c, 
                                        LastModifiedDate, LastModifiedById, Zuora__BillingAccount__c, Zuora_Currency__c
                                        FROM Zuora__Payment__c
                                        WHERE Id = :IdPago LIMIT 1];

        List <Zuora__PaymentMethod__c> metodoPago = [SELECT Id, Zuora__CreditCardMaskNumber__c, Zuora__CreditCardType__c
                                        FROM Zuora__PaymentMethod__c
                                        WHERE Zuora__BillingAccount__c = :pagoEnvio.Zuora__BillingAccount__c AND Zuora__DefaultPaymentMethod__c  = true];
    
        if (metodoPago.size()>0)
        {
            creditCardMaskNumber = metodoPago.get(0).Zuora__CreditCardMaskNumber__c;
            creditCardType = metodoPago.get(0).Zuora__CreditCardType__c;
        }

        System.debug('--------   Envío Pago en invocación: ' + IdPago);
        input = 'Envío Pago en invocación: ' + IdPago + '\n';

        String contentType      = securityConnection.content_Type__c;
        String authorization    = securityConnection.authorization__c;
        
        String endpoint = nuevo ? securityConnection.endpoint__c : securityConnection.endpoint__c + '/' + IdPago;
        String method = securityConnection.method__c;

        PagoWrapper pagoWrapper = New PagoWrapper();
        
        pagoWrapper.id                          = pagoEnvio.Id;
        pagoWrapper.idUser                      = pagoEnvio.Zuora__Account__r.IdFan__c;
        pagoWrapper.accountId                   = pagoEnvio.Zuora__Account__r.Id;
        pagoWrapper.accountingCode              = pagoEnvio.Zuora__AccountingCode__c;
        pagoWrapper.amount                      = pagoEnvio.Zuora__Amount__c;
        pagoWrapper.appliedCreditBalanceAmount  = pagoEnvio.Zuora__AppliedCreditBalanceAmount__c;
        pagoWrapper.authTransactionId           = pagoEnvio.Zuora__AuthTransactionId__c;
        pagoWrapper.bankIdentificationNumber    = pagoEnvio.Zuora__BankIdentificationNumber__c;
        pagoWrapper.cancelledOn                 = pagoEnvio.Zuora__CancelledOn__c;
        pagoWrapper.comment                     = pagoEnvio.Zuora__Comment__c;
        pagoWrapper.createdById                 = pagoEnvio.CreatedById;
        pagoWrapper.createdDate                 = pagoEnvio.CreatedDate;
        pagoWrapper.creditCardMaskNumber        = creditCardMaskNumber;                                                     
        pagoWrapper.creditCardType              = creditCardType;                                                               
        pagoWrapper.effectiveDate               = pagoEnvio.Zuora__Effective_Date__c;
        pagoWrapper.gatewayOrderId              = pagoEnvio.Zuora__GatewayOrderId__c;
        pagoWrapper.gatewayResponse             = pagoEnvio.Zuora__GatewayResponse__c;
        pagoWrapper.gatewayResponseCode         = pagoEnvio.Zuora__GatewayResponseCode__c;
        pagoWrapper.gatewayState                = pagoEnvio.Zuora__GatewayStatus__c;
        pagoWrapper.markedForSubmissionOn       = pagoEnvio.Zuora__MarkedForSubmissionOn__c;
        pagoWrapper.paymentMethodId             = pagoEnvio.Zuora__PaymentMethodId__c;
        pagoWrapper.paymentNumber               = pagoEnvio.Zuora__PaymentNumber__c;
        pagoWrapper.referenceId                 = pagoEnvio.Zuora__ReferenceId__c;
        pagoWrapper.refundAmount                = pagoEnvio.Zuora__RefundedAmount__c;
        pagoWrapper.secondPaymentReferenceId    = pagoEnvio.Zuora__SecondPaymentReferenceId__c;
        pagoWrapper.settledOn                   = pagoEnvio.Zuora__SettledOn__c;
        pagoWrapper.softDescriptor              = pagoEnvio.Zuora__SoftDescriptor__c;
        pagoWrapper.softDescriptorPhone         = pagoEnvio.Zuora__SoftDescriptorPhone__c;
        pagoWrapper.status                      = pagoEnvio.Zuora__Status__c;
        pagoWrapper.submittedOn                 = pagoEnvio.Zuora__SubmittedOn__c;
        pagoWrapper.transferredToAccounting     = pagoEnvio.Zuora__TransferedToAccounting__c;
        pagoWrapper.type                        = pagoEnvio.Zuora__Type__c;
        pagoWrapper.updatedById                 = pagoEnvio.LastModifiedById;
        pagoWrapper.updatedDate                 = pagoEnvio.LastModifiedDate;
        pagoWrapper.currencyType				= pagoEnvio.Zuora_Currency__c;
                
        Http http = new Http();
        HttpResponse res = new HttpResponse();

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', contentType);
        req.setHeader('Authorization', authorization + ' ' + authorizationkey);
        req.setEndpoint(endpoint);
        req.setMethod(method);

        System.debug('--------   Petición enviada para crear/actualizar pago: ' + JSON.serialize(pagoWrapper));
        System.debug('--------   Authorization: ' + req.getHeader('Authorization'));
        input = input + 'Destino: ' + endpoint + '\n';
        input = input + 'Petición enviada para crear/actualizar pago\n';

        String llamada = JSON.serializePretty(pagoWrapper,false);
        String llamada2 = llamada.replaceAll('currencyType', 'currency');
		
        req.setBody(llamada2);
        req.setTimeout(120000);

        try {

            log.RequestXML = req.getBody();
            res = http.send(req);
            System.debug('--------   Contenido de la respuesta ENVÍO: ' + res.getBody());
            log.Output = res.getBody();
            log.ResponseHeader = res.getStatusCode() + ': ' + res.getStatus();

            log.Successful = String.valueOf(res.getStatusCode()).substring(0,1) !='2' ? false : true;

        } catch(Exception e) {
            system.debug('--------   Error no controlado en llamada a WS pago: ' + e.getMessage());
            log.Successful = false;
            log.Message = e.getMessage() + ' // ' + e.getStackTraceString();
        }

        log.Input = input;

        masterpackage.CalloutUtility.CreateCalloutLog_SF_EXT('EnviarPago'+(nuevo?'Nuevo':'Actualizar'), log);
        System.debug('----> Número de queries: ' + Limits.getQueries());
        return res;
    }

    public HttpResponse EnviarFactura(String IdFactura, String authorizationkey, Boolean nuevo) {

        String input;
        String creditCardMaskNumber = '';
        String creditCardType = '';
        masterpackage.CalloutUtility.CalloutResult log = new masterpackage.CalloutUtility.CalloutResult();

        FAN_DSPConnection__mdt securityConnection = nuevo ? FAN_DSPConnection__mdt.getInstance('DSP_NUEVA_FACTURA') : FAN_DSPConnection__mdt.getInstance('DSP_ACTUALIZAR_FACTURA');

        Zuora__ZInvoice__c facturaEnvio = [ SELECT Id, Zuora__Account__r.IdFan__c, Zuora__Account__r.id, Zuora__AdjustmentAmount__c, 
                                            Zuora__AmountWithoutTax__c, Zuora__Balance2__c, CreatedById, CreatedDate, 
                                            Zuora__CreditBalanceAdjustmentAmount__c, Zuora__DueDate__c, Zuora__InvoiceDate__c, name, 
                                            Zuora__PaymentAmount__c, Zuora__Posted_Date__c, Zuora__RefundedAmount__c, Zuora__Status__c, 
                                            Zuora__TargetDate__c, Zuora__TaxAmount__c, Zuora__TaxExemptAmount__c, LastModifiedById, 
                                            LastModifiedDate, Zuora__BillingAccount__c, Zuora__TotalAmount__c, Zuora_Currency__c
                                        FROM Zuora__ZInvoice__c
                                        WHERE Id = :IdFactura LIMIT 1];

        System.debug('--------   Billing Account: ' + facturaEnvio.Zuora__BillingAccount__c);
        List <Zuora__PaymentMethod__c> metodoPagoEnvio = [SELECT Zuora__CreditCardMaskNumber__c, Zuora__CreditCardType__c FROM Zuora__PaymentMethod__c WHERE Zuora__BillingAccount__c = :facturaEnvio.Zuora__BillingAccount__c AND Zuora__PaymentMethodStatus__c = 'Active' AND Zuora__DefaultPaymentMethod__c  = true];

        if (metodoPagoEnvio.size()>0)
        {
            creditCardMaskNumber = metodoPagoEnvio.get(0).Zuora__CreditCardMaskNumber__c;
            creditCardType = metodoPagoEnvio.get(0).Zuora__CreditCardType__c;
        }

        System.debug('--------   Envío factura en invocación: ' + IdFactura);
        input = 'Envío factura en invocación: ' + IdFactura + '\n';

        String contentType      = securityConnection.content_Type__c;
        String authorization    = securityConnection.authorization__c;
        
        String endpoint = nuevo ? securityConnection.endpoint__c : securityConnection.endpoint__c + '/' + IdFactura;
        String method = securityConnection.method__c;

        FacturaWrapper facturaWrapper = New FacturaWrapper();
                                                    
        facturaWrapper.id                               = facturaEnvio.Id;
        facturaWrapper.idUser                           = facturaEnvio.Zuora__Account__r.IdFan__c;
        facturaWrapper.accountId                        = facturaEnvio.Zuora__Account__r.id;
        //facturaWrapper.adjustmentAmount                   = facturaEnvio.Zuora__AdjustmentAmount__c==null?null:Integer.valueof(facturaEnvio.Zuora__AdjustmentAmount__c);
        facturaWrapper.adjustmentAmount                 = facturaEnvio.Zuora__AdjustmentAmount__c;
        facturaWrapper.amount                           = facturaEnvio.Zuora__TotalAmount__c;
        facturaWrapper.amountWithoutTax                 = facturaEnvio.Zuora__AmountWithoutTax__c;
        facturaWrapper.balance                          = facturaEnvio.Zuora__Balance2__c;
        //facturaWrapper.body                               = facturaEnvio.                                     //No sabemos cuál es
        //facturaWrapper.comments                           = facturaEnvio.                                     //No sabemos cuál es
        facturaWrapper.createdById                      = facturaEnvio.CreatedById;
        facturaWrapper.createdDate                      = facturaEnvio.CreatedDate;
        facturaWrapper.creditBalanceAdjustmentAmount    = facturaEnvio.Zuora__CreditBalanceAdjustmentAmount__c;
        facturaWrapper.CreditCardMaskNumber             = creditCardMaskNumber;
        facturaWrapper.CreditCardType                   = creditCardType;
        facturaWrapper.dueDate                          = facturaEnvio.Zuora__DueDate__c;
        //facturaWrapper.includesOneTime                    = facturaEnvio.                                     //No sabemos cuál es
        //facturaWrapper.includesRecurring              = facturaEnvio.                                         //No sabemos cuál es
        //facturaWrapper.includesUsage                  = facturaEnvio.                                         //No sabemos cuál es
        facturaWrapper.invoiceDate                      = facturaEnvio.Zuora__InvoiceDate__c;
        facturaWrapper.invoiceNumber                    = facturaEnvio.name;
        //facturaWrapper.lastEmailSentDate              = facturaEnvio.                                         //No sabemos cuál es
        facturaWrapper.paymentAmount                    = facturaEnvio.Zuora__PaymentAmount__c;
        //facturaWrapper.postedBy                           = facturaEnvio.                                     //No sabemos cuál es
        facturaWrapper.postedDate                       = facturaEnvio.Zuora__Posted_Date__c;
        facturaWrapper.refundAmount                     = facturaEnvio.Zuora__RefundedAmount__c;
        facturaWrapper.status                           = facturaEnvio.Zuora__Status__c;
        facturaWrapper.targetDate                       = facturaEnvio.Zuora__TargetDate__c;
        facturaWrapper.taxAmount                        = facturaEnvio.Zuora__TaxAmount__c;
        facturaWrapper.taxExemptAmount                  = facturaEnvio.Zuora__TaxExemptAmount__c;
        //facturaWrapper.transferredToAccounting            = facturaEnvio.                                     //No sabemos cuál es
        facturaWrapper.updatedById                      = facturaEnvio.LastModifiedById;
        facturaWrapper.updatedDate                      = facturaEnvio.LastModifiedDate;
        facturaWrapper.currencyType						= facturaEnvio.Zuora_Currency__c;
                
        Http http = new Http();
        HttpResponse res = new HttpResponse();

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', contentType);
        req.setHeader('Authorization', authorization + ' ' + authorizationkey);
        req.setEndpoint(endpoint);
        req.setMethod(method);

        System.debug('--------   Petición enviada para crear/actualizar factura: ' + JSON.serialize(FacturaWrapper));
        System.debug('--------   Authorization: ' + req.getHeader('Authorization'));
        input = input + 'Destino: ' + endpoint + '\n';
        input = input + 'Petición enviada para crear/actualizar factura\n';

        String llamada = JSON.serializePretty(facturaWrapper,false);
        
		String llamada2 = llamada.replaceAll('currencyType', 'currency');

        req.setBody(llamada2);
        req.setTimeout(120000);
        

        try {

            log.RequestXML = req.getBody();
            res = http.send(req);
            System.debug('--------   Contenido de la respuesta ENVÍO: ' + res.getBody());
            log.Output = res.getBody();
            log.ResponseHeader = res.getStatusCode() + ': ' + res.getStatus();

            log.Successful = String.valueOf(res.getStatusCode()).substring(0,1) !='2' ? false : true;

        } catch(Exception e) {
            system.debug('--------   Error no controlado en llamada a WS factura: ' + e.getMessage());
            log.Successful = false;
            log.Message = e.getMessage() + ' // ' + e.getStackTraceString();
        }

        log.Input = input;

        masterpackage.CalloutUtility.CreateCalloutLog_SF_EXT('EnviarFactura'+(nuevo?'Nuevo':'Actualizar'), log);

        return res;
    }

	@future (callout = true)
    public static void enviarSRP(Boolean nuevo, List<Id> IdList) {
        String token = wsDSP.GetToken();
        for (Zuora__SubscriptionRatePlan__c srp : [SELECT Id, Zuora__AmendmentId__c, Zuora__AmendmentType__c, CreatedById, CreatedDate, Name, Zuora__Subscription__r.Name, LastModifiedById, LastModifiedDate, Zuora__OriginalProductRatePlanId__c, Zuora__Account__r.IdFan__c FROM Zuora__SubscriptionRatePlan__c WHERE Id IN :IdList]) {
			masterpackage.CalloutUtility.CalloutResult log = new masterpackage.CalloutUtility.CalloutResult();
			FAN_DSPConnection__mdt securityConnection = nuevo ? FAN_DSPConnection__mdt.getInstance('DSP_NUEVO_SRP') : FAN_DSPConnection__mdt.getInstance('DSP_ACTUALIZAR_SRP');

			String contentType      = securityConnection.content_Type__c;
			String authorization    = securityConnection.authorization__c;
			String endpoint         = nuevo ? securityConnection.endpoint__c : securityConnection.endpoint__c + '/' + srp.Id;
			String method           = securityConnection.method__c;

			SRPWrapper srpWrapper           = new SRPWrapper();
			srpWrapper.AmendmentId          = srp.Zuora__AmendmentId__c;
			srpWrapper.AmendmentType        = srp.Zuora__AmendmentType__c;
			srpWrapper.CreatedById          = srp.CreatedById;
			srpWrapper.CreatedDate          = srp.CreatedDate;
			srpWrapper.Id                   = srp.Id;
			srpWrapper.Name                 = srp.Name;
			srpWrapper.SubscriptionName     = srp.Zuora__Subscription__r.Name;
			srpWrapper.UpdatedById          = srp.LastModifiedById;
			srpWrapper.UpdatedDate          = srp.LastModifiedDate;
			srpWrapper.ProductRatePlanId    = srp.Zuora__OriginalProductRatePlanId__c;
			srpWrapper.IdUser               = srp.Zuora__Account__r.IdFan__c;

			Http http = new Http();
			HttpResponse res = new HttpResponse();
			HttpRequest req = new HttpRequest();
			req.setHeader('Content-Type', contentType);
			req.setHeader('Authorization', authorization + ' ' + token);
			req.setEndpoint(endpoint);
			req.setMethod(method);
			req.setBody(JSON.serializePretty(srpWrapper, true));

			log.Input = endpoint;
			log.RequestXML = req.getBody();

			try {
				res = http.send(req);
				log.Output = res.getBody();
				log.ResponseHeader = res.getStatusCode().format();
				log.Successful = res.getStatusCode().format().startsWith('2') ? true : false;
				log.Message = res.getStatus();
			}
			catch (Exception e) {
				log.Successful = false;
				log.Message = e.getMessage();
			}

			masterpackage.CalloutUtility.CreateCalloutLog_SF_EXT('EnviarSRP' + (nuevo ? 'Nuevo' : 'Actualizar'), log);
		}
        masterpackage.CalloutUtility.FlushLogs();
    }

	@future (callout = true)
    public static void enviarSPC(Boolean nuevo, List<Id> IdList) {
		String token = wsDSP.GetToken();
        for (Zuora__SubscriptionProductCharge__c spc : [SELECT Id, Zuora__Product__c, CreatedById, CreatedDate, Zuora__Description__c, Zuora__EffectiveEndDate__c, Zuora__EffectiveStartDate__c, Name, Zuora__External_Id__c, LastModifiedById, LastModifiedDate FROM Zuora__SubscriptionProductCharge__c WHERE Id IN :IdList]) {
			masterpackage.CalloutUtility.CalloutResult log = new masterpackage.CalloutUtility.CalloutResult();
			FAN_DSPConnection__mdt securityConnection = nuevo ? FAN_DSPConnection__mdt.getInstance('DSP_NUEVO_SPC') : FAN_DSPConnection__mdt.getInstance('DSP_ACTUALIZAR_SPC');

			//Zuora__SubscriptionProductCharge__c spc = [SELECT Zuora__Product__c, CreatedById, CreatedDate, Zuora__Description__c, Zuora__EffectiveEndDate__c, Zuora__EffectiveStartDate__c, Name, Zuora__External_Id__c, LastModifiedById, LastModifiedDate FROM Zuora__SubscriptionProductCharge__c WHERE Id =: idSPC WITH SECURITY_ENFORCED];

			String contentType      = securityConnection.content_Type__c;
			String authorization    = securityConnection.authorization__c;
			String endpoint         = nuevo ? securityConnection.endpoint__c : securityConnection.endpoint__c + '/' + spc.Id;
			String method           = securityConnection.method__c;

			SPCWrapper spcWrapper           = new SPCWrapper();
			spcWrapper.CreatedById          = spc.CreatedById;
			spcWrapper.CreatedDate          = spc.CreatedDate;
			spcWrapper.Description          = spc.Zuora__Description__c;
			spcWrapper.EffectiveEndDate     = spc.Zuora__EffectiveEndDate__c;
			spcWrapper.EffectiveStartDate   = spc.Zuora__EffectiveStartDate__c;
			spcWrapper.Id                   = spc.Zuora__External_Id__c;
			spcWrapper.Name                 = spc.Name;
			spcWrapper.ProductId            = spc.Zuora__Product__c;
			spcWrapper.UpdatedById          = spc.LastModifiedById;
			spcWrapper.UpdatedDate          = spc.LastModifiedDate;

			Http http = new Http();
			HttpResponse res = new HttpResponse();
			HttpRequest req = new HttpRequest();
			req.setHeader('Content-Type', contentType);
			req.setHeader('Authorization', authorization + ' ' + token);
			req.setEndpoint(endpoint);
			req.setMethod(method);
			req.setBody(JSON.serializePretty(spcWrapper, true));

			log.Input = endpoint;
			log.RequestXML = req.getBody();

			try {
				res = http.send(req);
				log.Output = res.getBody();
				log.ResponseHeader = res.getStatusCode().format();
				log.Successful = res.getStatusCode().format().startsWith('2') ? true : false;
				log.Message = res.getStatus();
			}
			catch (Exception e) {
				log.Successful = false;
				log.Message = e.getMessage();
			}

			masterpackage.CalloutUtility.CreateCalloutLog_SF_EXT('EnviarSPC' + (nuevo ? 'Nuevo' : 'Actualizar'), log);
		}
        masterpackage.CalloutUtility.FlushLogs();
    }

    //Definimos los Wrapper
    public class TokenRequestWrapper {
        public string   client_id;
        public string   client_secret;
        public string   resource;
        public string   grant_type;
    }

    private class ProductoWrapper {
        private string   id;
        private string   createdById;
        private Datetime createdDate;
        private Datetime updatedDate;
        private string   sku;
        private Datetime effectiveStartDate;
        private string   updatedById;
        private string   name;
        private Datetime effectiveEndDate;
        private string   description;
        private String   AppId;
        private String   InstanciaID;
        private String   B2B;
    }

    public class SuscripcionWrapper {
        public string   id;
        public string   idUser;
        public Datetime termStartDate;
        public Datetime updatedDate;
        public Integer  version;
        public Boolean  autoRenew;
        public Datetime subscriptionStartDate;
        public Decimal  initialTerm;
        public string   initialTermPeriodType;
        public string   accountId;
        //public Boolean    isInvoiceSeparate;
        public string   currentTermPeriodType;
        public Integer  currentTerm;
        public string   renewalTermPeriodType;
        public Datetime contractEffectiveDate;
        public string   updatedById;
        public Datetime contractAcceptanceDate;
        public string   createdById;
        public Datetime createdDate;
        public string   name;
        public string   status;
        public Datetime serviceActivationDate;
        public string   originalId;
        public Integer  renewalTerm;
        public Datetime termEndDate;
        public string   termType;
        //public string renewalSetting;
        public Datetime originalCreatedDate;
        public Datetime subscriptionEndDate;
        public Boolean  CancelRequested;
        public Datetime CancelRequestedDate;
        public Datetime CancelExpectedDate;
    }

    public class PagoWrapper {
        public string   id;
        public string   idUser;
        public string   accountId;
        public string   accountingCode;
        public Decimal  amount;
        public Decimal  appliedCreditBalanceAmount;
        public string   authTransactionId;
        public string   bankIdentificationNumber;
        public Datetime cancelledOn;
        public string   comment;
        public string   createdById;
        public Datetime createdDate;
        public string   creditCardMaskNumber;
        public string   creditCardType;
        public Datetime effectiveDate;
        //public string gateway;//no sabemos
        public string   gatewayOrderId;
        public string   gatewayResponse;
        public string   gatewayResponseCode;
        public string   gatewayState;
        public Datetime markedForSubmissionOn;
        public string   paymentMethodId;
        //public string paymentMethodSnapshotId;//no existe
        public string   paymentNumber;
        public string   referenceId;
        public Decimal  refundAmount;
        public string   secondPaymentReferenceId;
        public Datetime settledOn;
        public string   softDescriptor;
        public string   softDescriptorPhone;
        //public string source;//
        //public string sourceName;
        public string   status;
        public Datetime submittedOn;
        public string   transferredToAccounting;
        public string   type;
        public string   updatedById;
        public Datetime updatedDate;
        public string currencyType;
    }

    public class FacturaWrapper {
        public string   id;
        public string   idUser;
        public string   accountId;
        public Decimal  adjustmentAmount;
        public Decimal  amount;
        public Decimal  amountWithoutTax;
        public Decimal balance;
        //public string body;
        //public string comments;
        public string   createdById;
        public Datetime createdDate;
        public Decimal  creditBalanceAdjustmentAmount;
        public string   CreditCardMaskNumber;
        public string   CreditCardType;
        public Datetime dueDate;
        //public Boolean    includesOneTime;
        //public Boolean    includesRecurring;
        //public Boolean    includesUsage;
        public Datetime invoiceDate;
        public string   invoiceNumber;
        //public Datetime   lastEmailSentDate;
        public Decimal  paymentAmount;
        //public string postedBy;
        public Datetime postedDate;
        public Decimal  refundAmount;
        public string   status;
        public Datetime targetDate;
        public Decimal  taxAmount;
        public Decimal  taxExemptAmount;
        //public string transferredToAccounting;
        public string   updatedById;
        public Datetime updatedDate;
        public string currencyType;
    }

    public class SRPWrapper {
        public String AmendmentId;
        public String AmendmentType;
        public String CreatedById;
        public Datetime CreatedDate;
        public String Id;
        public String Name;
        public String SubscriptionName;
        public String UpdatedById;
        public Datetime UpdatedDate;
        public String ProductRatePlanId;
        public String IdUser;
    }

    public class SPCWrapper {
        public String CreatedById;
        public Datetime CreatedDate;
        public String Description;
        public Datetime EffectiveEndDate;
        public Datetime EffectiveStartDate;
        public String Id;
        public String Name;
        public String ProductId;
        public String UpdatedById;
        public Datetime UpdatedDate;
    } */
}