@isTest 
private class ZuoraZInvoiceTrigger_Test {
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
		Test.stopTest();
	}
	@isTest
	private static void testOne() {
		Account cuenta = [SELECT Id FROM Account LIMIT 1]; 
		
		Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
		factura.Zuora__Account__c = cuenta.Id;
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
		Test.startTest();
		insert factura;
		factura.Zuora__PaymentAmount__c = 55;
		update factura;
		Test.stopTest();
		System.assert(factura != null, 'Factura creada.');
	}

	@isTest
	private static void test040() {
		List<Account> accList = [SELECT Id FROM Account LIMIT 40];

		List<Zuora__ZInvoice__c> facturaList = new List<Zuora__ZInvoice__c>();
		for(Account cuenta: accList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = cuenta.Id;
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
			facturaList.add(factura);
		}
		Test.startTest();
		insert facturaList;
		Test.stopTest();
		System.assert(facturaList != null, 'Facturas creadas.');
	}

	@isTest
	private static void test065() {
		List<Account> accList = [SELECT Id FROM Account LIMIT 65];

		List<Zuora__ZInvoice__c> facturaList = new List<Zuora__ZInvoice__c>();
		for(Account cuenta: accList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = cuenta.Id;
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
			facturaList.add(factura);
		}
		Test.startTest();
		insert facturaList;
		Test.stopTest();
		System.assert(facturaList != null, 'Facturas creadas.');
	}

	@isTest
	private static void test090() {
		List<Account> accList = [SELECT Id FROM Account LIMIT 90];

		List<Zuora__ZInvoice__c> facturaList = new List<Zuora__ZInvoice__c>();
		for(Account cuenta: accList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = cuenta.Id;
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
			facturaList.add(factura);
		}
		Test.startTest();
		insert facturaList;
		Test.stopTest();
		System.assert(facturaList != null, 'Facturas creadas.');
	}

	@isTest
	private static void test115() {
		List<Account> accList = [SELECT Id FROM Account LIMIT 115];

		List<Zuora__ZInvoice__c> facturaList = new List<Zuora__ZInvoice__c>();
		for(Account cuenta: accList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = cuenta.Id;
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
			facturaList.add(factura);
		}
		Test.startTest();
		insert facturaList;
		Test.stopTest();
		System.assert(facturaList != null, 'Facturas creadas.');
	}

	@isTest
	private static void test140() {
		List<Account> accList = [SELECT Id FROM Account LIMIT 140];

		List<Zuora__ZInvoice__c> facturaList = new List<Zuora__ZInvoice__c>();
		for(Account cuenta: accList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = cuenta.Id;
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
			facturaList.add(factura);
		}
		Test.startTest();
		insert facturaList;
		Test.stopTest();
		System.assert(facturaList != null, 'Facturas creadas.');
	}

	@isTest
	private static void test165() {
		List<Account> accList = [SELECT Id FROM Account LIMIT 165];

		List<Zuora__ZInvoice__c> facturaList = new List<Zuora__ZInvoice__c>();
		for(Account cuenta: accList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = cuenta.Id;
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
			facturaList.add(factura);
		}
		Test.startTest();
		insert facturaList;
		Test.stopTest();
		System.assert(facturaList != null, 'Facturas creadas.');
	}

	@isTest
	private static void test200() {
		List<Account> accList = [SELECT Id FROM Account LIMIT 200];

		List<Zuora__ZInvoice__c> facturaList = new List<Zuora__ZInvoice__c>();
		for(Account cuenta: accList) {
			Zuora__ZInvoice__c factura = new Zuora__ZInvoice__c ();
			factura.Zuora__Account__c = cuenta.Id;
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
			facturaList.add(factura);
		}
		Test.startTest();
		insert facturaList;
		Test.stopTest();
		System.assert(facturaList != null, 'Facturas creadas.');
	}*/
}