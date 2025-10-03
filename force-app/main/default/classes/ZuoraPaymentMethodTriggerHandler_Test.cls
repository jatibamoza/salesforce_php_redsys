@isTest 
private class ZuoraPaymentMethodTriggerHandler_Test {
	/*@TestSetup
	static void makeData(){
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
			
		Id personAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('FAN_PersonAccount').getRecordTypeId();
		 
		List<Account> accList = new List<Account>();
		for (Integer i=0; i<200; i++) {
			Account cuenta = new Account();
			cuenta.FirstName = 'Prueba Cuenta ';
			cuenta.LastName = i.format();
			cuenta.RecordTypeId  = personAccountId;
			accList.add(cuenta);
		}
		insert accList;

		List<Zuora__CustomerAccount__c> billingList = new List<Zuora__CustomerAccount__c>();
		for (Account acc : accList) {
			Zuora__CustomerAccount__c billingAccount = new Zuora__CustomerAccount__c();
			billingAccount.Name = 'PRUEBA_BILLING_ACCOUNT_000' + acc.LastName;
			billingAccount.Zuora__Account__c = acc.Id;
			billingList.add(billingAccount);
		}
		insert billingList;

		List<Zuora__ZInvoice__c> facList = new List<Zuora__ZInvoice__c>();
		for (Zuora__CustomerAccount__c bill : billingList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = bill.Zuora__Account__c;
			factura.Zuora__BillingAccount__c = bill.Id;
			factura.Zuora__AdjustmentAmount__c = 15;
			factura.Zuora__AmountWithoutTax__c = 16;
			factura.Zuora__Balance__c = 17;
			factura.Zuora__CreditBalanceAdjustmentAmount__c = 18;
			factura.Zuora__DueDate__c = date.newInstance(2020,11,20);
			factura.Zuora__InvoiceDate__c = date.newInstance(2020,11,20);
			factura.name = 'FACTURA-' + bill.Zuora__Account__r.LastName;
			factura.Zuora__PaymentAmount__c = 19;
			factura.Zuora__Posted_Date__c = date.newInstance(2020,11,20);
			factura.Zuora__RefundedAmount__c = 20;
			factura.Zuora__Status__c = 'Processed';
			factura.Zuora__TargetDate__c = date.newInstance(2020,11,20);
			factura.Zuora__TaxAmount__c = 21;
			factura.Zuora__TaxExemptAmount__c = 22;
			facList.add(factura);
		}
		insert facList;
		Test.stopTest();
	}
	
	@isTest
	private static void testOne() {
		Zuora__CustomerAccount__c billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 1];
		Test.startTest();
		Zuora__PaymentMethod__c metodoPago = new Zuora__PaymentMethod__c ();
		metodoPago.Name = metodoPago.Id;
		metodoPago.Zuora__BillingAccount__c = billingAccount.Id;
		metodoPago.Zuora__CreditCardMaskNumber__c = '************9999';
		metodoPago.Zuora__CreditCardType__c = 'MasterCard';
		insert metodoPago;
		Test.stopTest();
		System.assert(metodoPago != null, 'Payment method creado.');
	}
	@isTest
	private static void test025() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 25];
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		Test.startTest();
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}
	@isTest
	private static void test050() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 50];
		Test.startTest();
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}
	@isTest
	private static void test075() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 75];
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		Test.startTest();
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}
	@isTest
	private static void test100() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 100];
		Test.startTest();
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}
	@isTest
	private static void test125() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 125];
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		Test.startTest();
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}
	@isTest
	private static void test150() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 150];
		Test.startTest();
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}
	@isTest
	private static void test175() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 175];
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		Test.startTest();
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}
	@isTest
	private static void test200() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id FROM Zuora__CustomerAccount__c LIMIT 200];
		Test.startTest();
		List<Zuora__PaymentMethod__c> pmList = new List<Zuora__PaymentMethod__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__PaymentMethod__c pm = new Zuora__PaymentMethod__c ();
			pm.Name = pm.Id;
			pm.Zuora__BillingAccount__c = bill.Id;
			pm.Zuora__CreditCardMaskNumber__c = '************9999';
			pm.Zuora__CreditCardType__c = 'MasterCard';
			pmList.add(pm);
		}
		insert pmList;
		Test.stopTest();
		System.assert(pmList != null, 'Payment methods creados.');
	}*/
}