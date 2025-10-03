@isTest 
private class FAN_Callout_Test {

	//Global String respJSON = '{"access_token":"T0k3n"}';


	/*@isTest
	private static void GetToken() {
	
		//creamos un custom label por cada tipo de respuesta
		//en el mock hacemos un if por cada método
		//dentro de ese if haces un if por cada endpoint
		String respJSON = '[ ' + 		
		'{"token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599","expires_on":"1604592345","not_before":"1604588445","resource":"http://v1.digitalplatform.ms/web/api","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCIsImtpZCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCJ9.eyJhdWQiOiJodHRwOi8vdjEuZGlnaXRhbHBsYXRmb3JtLm1zL3dlYi9hcGkiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC85YzM1NWNmMi1jOWUzLTQyOWMtODVhNy1kZDY3NGMwMjQ2NjEvIiwiaWF0IjoxNjA0NTg4NDQ1LCJuYmYiOjE2MDQ1ODg0NDUsImV4cCI6MTYwNDU5MjM0NSwiYWlvIjoiRTJSZ1lDalpaM1dOdjduWk1lRnRrbjg0VTNZNkFBPT0iLCJhcHBpZCI6IjNkMDg2YTFjLWQ0NjUtNGI2YS05MjA5LWNjNmQzYmI4MTFkNSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MS8iLCJvaWQiOiI1MjNlNDRmYy1lNzg3LTQzMDYtOWVmMC03MzNkZTAzMjhhNzgiLCJyaCI6IjAuQUFBQThsdzFuT1BKbkVLRnA5MW5UQUpHWVJ4cUNEMWwxR3BMa2duTWJUdTRFZFVqQUFBLiIsInN1YiI6IjUyM2U0NGZjLWU3ODctNDMwNi05ZWYwLTczM2RlMDMyOGE3OCIsInRpZCI6IjljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MSIsInV0aSI6IlpidTUxek1XNTBtcmZoQjdHTV9IQUEiLCJ2ZXIiOiIxLjAifQ.W2KEcFLVpUs9wJYWpDWPQbEqebYbh7jzfOR8rQZkovjf5HgItDXfKE12rOTlOWSuveFZdPL1_gQFEwFnDUxpZYU6_nTbQMDF9YXn5_MWODsngxCGmVv9JXhwR0DhecqvrCo5VNE2kwbtU8nRvFVJMq6H1xPMXgGWGV49JWdi4PlIZB96gI9V1PDFPotzhMTlplZ9J85XnkSC2c9VeJbYD7s58qhxRwUETSl-eRcxdgITv42g8zYt3KoZ2LWVTVVY8h-SioPchk_fhGQp7NtLw22pgBYuz1ZqMKiJzRgHmVJJd0xkjP7sUxnMcx9ite5NFRQYqy5c-45hpsksZeixXw"}'+
		']';

		String respJSON = '{"access_token":"T0k3n"}';
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);
		Test.startTest();
		FAN_Callout wsDSP = new FAN_Callout();

		wsDSP.GetToken();

		Test.stopTest();
	}

	@isTest
	private static void testComunicarProductoDSPOK() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		//TriggersManager.StopAllZuoraProductTriggers = true;
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);
		
		Test.startTest();

		Zuora__Product__c producto = new Zuora__Product__c( Zuora__Description__c = 'Producto La Liga',
															Zuora__EffectiveEndDate__c = date.newInstance(2023,10,31),
															Zuora__EntityID__c = '8adcd9eb75258ddc01752ad6877b29ad',
															Zuora__External_Id__c = '8adc9dee75257f0a017540ffa6ca1095',
															Name = 'Producto La Liga Previo',
															Zuora__SKU__c = 'SKU-00000056');
		insert producto;

		//FAN_ComunicarDSP.FAN_ComunicarDSP(producto.Id, 'Producto', true, 'prueba');
		//FAN_ComunicarDSP.FAN_ComunicarDSP(producto.Id, 'Producto', false, 'prueba');
	
		//{"token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599","expires_on":"1604592345","not_before":"1604588445","resource":"http://v1.digitalplatform.ms/web/api","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCIsImtpZCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCJ9.eyJhdWQiOiJodHRwOi8vdjEuZGlnaXRhbHBsYXRmb3JtLm1zL3dlYi9hcGkiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC85YzM1NWNmMi1jOWUzLTQyOWMtODVhNy1kZDY3NGMwMjQ2NjEvIiwiaWF0IjoxNjA0NTg4NDQ1LCJuYmYiOjE2MDQ1ODg0NDUsImV4cCI6MTYwNDU5MjM0NSwiYWlvIjoiRTJSZ1lDalpaM1dOdjduWk1lRnRrbjg0VTNZNkFBPT0iLCJhcHBpZCI6IjNkMDg2YTFjLWQ0NjUtNGI2YS05MjA5LWNjNmQzYmI4MTFkNSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MS8iLCJvaWQiOiI1MjNlNDRmYy1lNzg3LTQzMDYtOWVmMC03MzNkZTAzMjhhNzgiLCJyaCI6IjAuQUFBQThsdzFuT1BKbkVLRnA5MW5UQUpHWVJ4cUNEMWwxR3BMa2duTWJUdTRFZFVqQUFBLiIsInN1YiI6IjUyM2U0NGZjLWU3ODctNDMwNi05ZWYwLTczM2RlMDMyOGE3OCIsInRpZCI6IjljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MSIsInV0aSI6IlpidTUxek1XNTBtcmZoQjdHTV9IQUEiLCJ2ZXIiOiIxLjAifQ.W2KEcFLVpUs9wJYWpDWPQbEqebYbh7jzfOR8rQZkovjf5HgItDXfKE12rOTlOWSuveFZdPL1_gQFEwFnDUxpZYU6_nTbQMDF9YXn5_MWODsngxCGmVv9JXhwR0DhecqvrCo5VNE2kwbtU8nRvFVJMq6H1xPMXgGWGV49JWdi4PlIZB96gI9V1PDFPotzhMTlplZ9J85XnkSC2c9VeJbYD7s58qhxRwUETSl-eRcxdgITv42g8zYt3KoZ2LWVTVVY8h-SioPchk_fhGQp7NtLw22pgBYuz1ZqMKiJzRgHmVJJd0xkjP7sUxnMcx9ite5NFRQYqy5c-45hpsksZeixXw"}

		
        producto.Zuora__Description__c = 'Producto La Liga 2';

        update producto;
		
		delete producto;
		
		undelete producto;

		Test.stopTest();
	}

	@isTest
	private static void testComunicarSuscricionDSPOK() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		//TriggersManager.StopAllSubscriptionTriggers= true;
		//TriggersManager.StopAllZuoraSubscriptionProductChargeTriggers= true;

		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);
		
		Test.startTest();

		List <RecordType> personAccount = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'FAN_PersonAccount'];
		
		String personAccountId = personAccount.get(0).Id;
		 
		Account cuenta = new Account();

		cuenta.FirstName = 'Prueba Cuenta';
		cuenta.LastName = 'test';
		cuenta.RecordTypeId  = personAccountId;
		
		insert cuenta;

		Zuora__CustomerAccount__c billingAccount = new Zuora__CustomerAccount__c();

		billingAccount.name = 'Prueba clase test';
		billingAccount.Zuora__Account__c = cuenta.Id;
		billingAccount.Zuora__AccountNumber__c = 'A00000001';
		billingAccount.Zuora__Zuora_Id__c = '8adcd9eb76fafcc20176fc2524bb4b12';

		insert billingAccount;

		Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = cuenta.Id,
																			Zuora__AutoRenew__c = false,
																			Zuora__CustomerAccount__c = billingAccount.Id,
																			Zuora__CancelledDate__c = null,
																			Zuora__MRR__c = 100,
																			Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																			Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																			Zuora__CurrentTerm__c = null,
																			Zuora__CurrentTermPeriodType__c = null,
																			Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b',
																			Zuora__InitialTerm__c = null,
																			Zuora__InitialTermPeriodType__c = null,
																			Zuora__InvoiceOwner__c =  billingAccount.Id,
																			Zuora__NextChargeDate__c = date.newInstance(2020,12,20),
																			Zuora__NextRenewalDate__c = null,
																			Zuora__Notes__c = 'prueba 10',
																			Zuora__OpportunityCloseDate__c = null,
																			Zuora__OpportunityName__c = null,
																			Zuora__OriginalCreated_Date__c = datetime.newInstance(2020,10,20),
																			Zuora__OriginalCreatedDate__c = date.newInstance(2020,10,20),
																			Zuora__OriginalId__c = '8adc9dee75257f0a017544f2a671110b',
																			Zuora__PreviousSubscriptionId__c = '8adc9dee75257f0a017544f2a671110b',
																			Zuora__QuoteBusinessType__c = null,
																			Zuora__QuoteNumber__c = null,
																			Zuora__QuoteType__c = null,
																			Zuora__RenewalTerm__c = null,
																			Zuora__RenewalTermPeriodType__c = null,
																			Zuora__ServiceActivationDate__c = date.newInstance(2020,11,20),
																			Zuora__Status__c = 'Active',
																			Zuora__SubscriptionEndDate__c = null,
																			Name = 'A-S00000002',
																			Zuora__SubscriptionNumber__c = 'A-S00000002',
																			Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																			Zuora__TCV__c = null,
																			Zuora__TermEndDate__c = null,
																			Zuora__TermSettingType__c = 'EVERGREEN',
																			Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																			Zuora__Version__c = 1,
																			Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');

		insert suscripcion;

		Zuora__SubscriptionProductCharge__c subscriptionProductCharge = new Zuora__SubscriptionProductCharge__c();

		subscriptionProductCharge.Zuora__EffectiveStartDate__c=date.newInstance(2021,03,31);
		subscriptionProductCharge.Zuora__BillingPeriod__c	='Month';
		subscriptionProductCharge.Zuora__Subscription__c =suscripcion.Id;
		subscriptionProductCharge.Name = 'SPC0000000002';
		subscriptionProductCharge.Zuora__Zuora_Id__c = '900000011';

		insert subscriptionProductCharge;

		subscriptionProductCharge.Zuora__EffectiveStartDate__c = date.newInstance(2021,04,01);
		
		update subscriptionProductCharge;
				
		//FAN_ComunicarDSP.FAN_ComunicarDSP(suscripcion.Id, 'Suscripcion', true, 'prueba');
		//FAN_ComunicarDSP.FAN_ComunicarDSP(suscripcion.Id, 'Suscripcion', false, 'prueba');
		Test.stopTest();

	}

	@isTest
	private static void testComunicarPagoDSPOK() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		//TriggersManager.StopAllZuoraPaymentTriggers = true;
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);
		
		Test.startTest();


		List <RecordType> personAccount = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'FAN_PersonAccount'];
		
		String personAccountId = personAccount.get(0).Id;
		 
		Account cuenta = new Account();

		cuenta.FirstName = 'Prueba Cuenta';
		cuenta.LastName = 'test';
		cuenta.RecordTypeId  = personAccountId;
		
		insert cuenta;

		Zuora__CustomerAccount__c billingAccount = new Zuora__CustomerAccount__c();

		billingAccount.name = 'Prueba clase test';
		billingAccount.Zuora__Account__c = cuenta.Id;
		billingAccount.Zuora__AccountNumber__c = 'A00000001';
		billingAccount.Zuora__Zuora_Id__c = '8adcd9eb76fafcc20176fc2524bb4b12';

		insert billingAccount;

		Zuora__Payment__c pago = new Zuora__Payment__c();
		
		pago.Zuora__Account__c = cuenta.Id;
		pago.Zuora__BillingAccount__c = billingAccount.Id;
		pago.Zuora__AccountingCode__c = 'ABC';
		pago.Zuora__Amount__c = 17;
		pago.Zuora__AppliedCreditBalanceAmount__c = 18;
		pago.Zuora__AuthTransactionId__c = '123';
		pago.Zuora__BankIdentificationNumber__c = '161616';
		pago.Zuora__CancelledOn__c =null;
		pago.Zuora__Comment__c = 'Comentario';
		pago.Zuora__Effective_Date__c = date.newInstance(2020,11,20);
		pago.Zuora__GatewayOrderId__c = '456';
		pago.Zuora__GatewayResponse__c = '789';
		pago.Zuora__GatewayResponseCode__c = 'A123';
		pago.Zuora__GatewayStatus__c = 'Submitted';
		pago.Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20);
		pago.Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI';
		pago.Zuora__PaymentNumber__c = 'B123';
		pago.Zuora__ReferenceId__c = 'B456';
		pago.Zuora__RefundAmount__c = 0;
		pago.Zuora__SecondPaymentReferenceId__c = 'C123';
		pago.Zuora__SettledOn__c = date.newInstance(2020,11,20);
		pago.Zuora__SoftDescriptor__c = 'C789';
		pago.Zuora__SoftDescriptorPhone__c = 'D123';
		pago.Zuora__Status__c = 'Processed';
		pago.Zuora__SubmittedOn__c = date.newInstance(2020,11,20);
		pago.Zuora__TransferedToAccounting__c = 'D789';
		pago.Zuora__Type__c = 'External';

        insert pago;

		//FAN_ComunicarDSP.FAN_ComunicarDSP(pago.Id, 'Pago', true, 'prueba');
		//FAN_ComunicarDSP.FAN_ComunicarDSP(pago.Id, 'Pago', false, 'prueba');
	
		//{"token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599","expires_on":"1604592345","not_before":"1604588445","resource":"http://v1.digitalplatform.ms/web/api","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCIsImtpZCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCJ9.eyJhdWQiOiJodHRwOi8vdjEuZGlnaXRhbHBsYXRmb3JtLm1zL3dlYi9hcGkiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC85YzM1NWNmMi1jOWUzLTQyOWMtODVhNy1kZDY3NGMwMjQ2NjEvIiwiaWF0IjoxNjA0NTg4NDQ1LCJuYmYiOjE2MDQ1ODg0NDUsImV4cCI6MTYwNDU5MjM0NSwiYWlvIjoiRTJSZ1lDalpaM1dOdjduWk1lRnRrbjg0VTNZNkFBPT0iLCJhcHBpZCI6IjNkMDg2YTFjLWQ0NjUtNGI2YS05MjA5LWNjNmQzYmI4MTFkNSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MS8iLCJvaWQiOiI1MjNlNDRmYy1lNzg3LTQzMDYtOWVmMC03MzNkZTAzMjhhNzgiLCJyaCI6IjAuQUFBQThsdzFuT1BKbkVLRnA5MW5UQUpHWVJ4cUNEMWwxR3BMa2duTWJUdTRFZFVqQUFBLiIsInN1YiI6IjUyM2U0NGZjLWU3ODctNDMwNi05ZWYwLTczM2RlMDMyOGE3OCIsInRpZCI6IjljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MSIsInV0aSI6IlpidTUxek1XNTBtcmZoQjdHTV9IQUEiLCJ2ZXIiOiIxLjAifQ.W2KEcFLVpUs9wJYWpDWPQbEqebYbh7jzfOR8rQZkovjf5HgItDXfKE12rOTlOWSuveFZdPL1_gQFEwFnDUxpZYU6_nTbQMDF9YXn5_MWODsngxCGmVv9JXhwR0DhecqvrCo5VNE2kwbtU8nRvFVJMq6H1xPMXgGWGV49JWdi4PlIZB96gI9V1PDFPotzhMTlplZ9J85XnkSC2c9VeJbYD7s58qhxRwUETSl-eRcxdgITv42g8zYt3KoZ2LWVTVVY8h-SioPchk_fhGQp7NtLw22pgBYuz1ZqMKiJzRgHmVJJd0xkjP7sUxnMcx9ite5NFRQYqy5c-45hpsksZeixXw"}

		pago.Zuora__Amount__c = 55;

        update pago;

		delete pago;

		undelete pago;

		Test.stopTest();
	}

	@isTest
	private static void testComunicarFacturaDSPOK() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		//TriggersManager.StopAllZuoraInvoiceTriggers = true;

		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();

		List <RecordType> personAccount = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'FAN_PersonAccount'];
		
		String personAccountId = personAccount.get(0).Id;
		 
		Account cuenta = new Account();

		cuenta.FirstName = 'Prueba Cuenta';
		cuenta.LastName = 'test';
		cuenta.RecordTypeId  = personAccountId;
		
		insert cuenta;

		Zuora__CustomerAccount__c billingAccount = new Zuora__CustomerAccount__c();
			
		billingAccount.Name = 'PRUEBA_BILLING_ACCOUNT_0001';
		billingAccount.Zuora__Account__c = cuenta.Id;

		insert billingAccount;

		Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();

		factura.Zuora__Account__c = cuenta.Id;
		factura.Zuora__BillingAccount__c = billingAccount.Id;
		factura.Zuora__AdjustmentAmount__c = 15;
		factura.Zuora__AmountWithoutTax__c = 16;
		factura.Zuora__Balance__c = 17;
		factura.Zuora__CreditBalanceAdjustmentAmount__c = 18;
		factura.Zuora__DueDate__c = date.newInstance(2020,11,20);
		factura.Zuora__InvoiceDate__c = date.newInstance(2020,11,20);
		factura.name = 'FACTURA-123';
		factura.Zuora__PaymentAmount__c = 19;
		factura.Zuora__Posted_Date__c = date.newInstance(2020,11,20);
		factura.Zuora__RefundedAmount__c = 20;
		factura.Zuora__Status__c = 'Processed';
		factura.Zuora__TargetDate__c = date.newInstance(2020,11,20);
		factura.Zuora__TaxAmount__c = 21;
		factura.Zuora__TaxExemptAmount__c = 22;

		insert factura;

		Zuora__PaymentMethod__c metodoPago = new Zuora__PaymentMethod__c ();

		metodoPago.Name = metodoPago.Id;
		metodoPago.Zuora__BillingAccount__c = billingAccount.Id;
		metodoPago.Zuora__CreditCardMaskNumber__c = '************9999';
		metodoPago.Zuora__CreditCardType__c = 'MasterCard';

		insert metodoPago;

		metodoPago.Zuora__CreditCardHolderName__c = 'Prueba';

		update metodoPago;

		delete metodoPago;

		undelete metodoPago;

		//FAN_ComunicarDSP.FAN_ComunicarDSP(factura.Id, 'Factura', true, 'prueba');
		//FAN_ComunicarDSP.FAN_ComunicarDSP(factura.Id, 'Factura', false, 'prueba');
	
		//{"token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599","expires_on":"1604592345","not_before":"1604588445","resource":"http://v1.digitalplatform.ms/web/api","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCIsImtpZCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCJ9.eyJhdWQiOiJodHRwOi8vdjEuZGlnaXRhbHBsYXRmb3JtLm1zL3dlYi9hcGkiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC85YzM1NWNmMi1jOWUzLTQyOWMtODVhNy1kZDY3NGMwMjQ2NjEvIiwiaWF0IjoxNjA0NTg4NDQ1LCJuYmYiOjE2MDQ1ODg0NDUsImV4cCI6MTYwNDU5MjM0NSwiYWlvIjoiRTJSZ1lDalpaM1dOdjduWk1lRnRrbjg0VTNZNkFBPT0iLCJhcHBpZCI6IjNkMDg2YTFjLWQ0NjUtNGI2YS05MjA5LWNjNmQzYmI4MTFkNSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MS8iLCJvaWQiOiI1MjNlNDRmYy1lNzg3LTQzMDYtOWVmMC03MzNkZTAzMjhhNzgiLCJyaCI6IjAuQUFBQThsdzFuT1BKbkVLRnA5MW5UQUpHWVJ4cUNEMWwxR3BMa2duTWJUdTRFZFVqQUFBLiIsInN1YiI6IjUyM2U0NGZjLWU3ODctNDMwNi05ZWYwLTczM2RlMDMyOGE3OCIsInRpZCI6IjljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MSIsInV0aSI6IlpidTUxek1XNTBtcmZoQjdHTV9IQUEiLCJ2ZXIiOiIxLjAifQ.W2KEcFLVpUs9wJYWpDWPQbEqebYbh7jzfOR8rQZkovjf5HgItDXfKE12rOTlOWSuveFZdPL1_gQFEwFnDUxpZYU6_nTbQMDF9YXn5_MWODsngxCGmVv9JXhwR0DhecqvrCo5VNE2kwbtU8nRvFVJMq6H1xPMXgGWGV49JWdi4PlIZB96gI9V1PDFPotzhMTlplZ9J85XnkSC2c9VeJbYD7s58qhxRwUETSl-eRcxdgITv42g8zYt3KoZ2LWVTVVY8h-SioPchk_fhGQp7NtLw22pgBYuz1ZqMKiJzRgHmVJJd0xkjP7sUxnMcx9ite5NFRQYqy5c-45hpsksZeixXw"}
		Test.stopTest();
	}

	/*
	@isTest
	private static void testComunicarDSPKO() {
		String respJSON = '[ ]';
		Zuora__Product__c producto = new Zuora__Product__c( Zuora__Description__c = 'Producto La Liga',
															Zuora__EffectiveEndDate__c = date.newInstance(2023,10,31),
															Zuora__EntityID__c = '8adcd9eb75258ddc01752ad6877b29ad',
															Zuora__External_Id__c = '8adc9dee75257f0a017540ffa6ca1095',
															Name = 'Producto La Liga Previo',
															Zuora__SKU__c = 'SKU-00000056');

		FAN_MockResponseComunicarDSP koResponse = new FAN_MockResponseComunicarDSP(404, 'Status=Not Found', respJSON, null);
	
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, koResponse);
		FAN_Callout.ComunicarDSP(producto.Id, 'Producto', true);
		FAN_Callout.ComunicarDSP(producto.Id, 'Producto', false);
	
			//{"token_type":"Bearer","expires_in":"3599","ext_expires_in":"3599","expires_on":"1604592345","not_before":"1604588445","resource":"http://v1.digitalplatform.ms/web/api","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCIsImtpZCI6ImtnMkxZczJUMENUaklmajRydDZKSXluZW4zOCJ9.eyJhdWQiOiJodHRwOi8vdjEuZGlnaXRhbHBsYXRmb3JtLm1zL3dlYi9hcGkiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC85YzM1NWNmMi1jOWUzLTQyOWMtODVhNy1kZDY3NGMwMjQ2NjEvIiwiaWF0IjoxNjA0NTg4NDQ1LCJuYmYiOjE2MDQ1ODg0NDUsImV4cCI6MTYwNDU5MjM0NSwiYWlvIjoiRTJSZ1lDalpaM1dOdjduWk1lRnRrbjg0VTNZNkFBPT0iLCJhcHBpZCI6IjNkMDg2YTFjLWQ0NjUtNGI2YS05MjA5LWNjNmQzYmI4MTFkNSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MS8iLCJvaWQiOiI1MjNlNDRmYy1lNzg3LTQzMDYtOWVmMC03MzNkZTAzMjhhNzgiLCJyaCI6IjAuQUFBQThsdzFuT1BKbkVLRnA5MW5UQUpHWVJ4cUNEMWwxR3BMa2duTWJUdTRFZFVqQUFBLiIsInN1YiI6IjUyM2U0NGZjLWU3ODctNDMwNi05ZWYwLTczM2RlMDMyOGE3OCIsInRpZCI6IjljMzU1Y2YyLWM5ZTMtNDI5Yy04NWE3LWRkNjc0YzAyNDY2MSIsInV0aSI6IlpidTUxek1XNTBtcmZoQjdHTV9IQUEiLCJ2ZXIiOiIxLjAifQ.W2KEcFLVpUs9wJYWpDWPQbEqebYbh7jzfOR8rQZkovjf5HgItDXfKE12rOTlOWSuveFZdPL1_gQFEwFnDUxpZYU6_nTbQMDF9YXn5_MWODsngxCGmVv9JXhwR0DhecqvrCo5VNE2kwbtU8nRvFVJMq6H1xPMXgGWGV49JWdi4PlIZB96gI9V1PDFPotzhMTlplZ9J85XnkSC2c9VeJbYD7s58qhxRwUETSl-eRcxdgITv42g8zYt3KoZ2LWVTVVY8h-SioPchk_fhGQp7NtLw22pgBYuz1ZqMKiJzRgHmVJJd0xkjP7sUxnMcx9ite5NFRQYqy5c-45hpsksZeixXw"}
	    Test.stopTest();

	}*/

}