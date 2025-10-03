@isTest 
private class ZuoraPaymentTrigger_Test {
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
	}
	@isTest
	private static void testOne() {
		Zuora__CustomerAccount__c billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 1];

	    Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = billingAccount.Zuora__Account__r.Id,
														Zuora__BillingAccount__c = billingAccount.Id,
														Zuora__AccountingCode__c = 'ABC', 
														Zuora__Amount__c = 17,
														Zuora__AppliedCreditBalanceAmount__c = 18,
														Zuora__AuthTransactionId__c = '123',
														Zuora__BankIdentificationNumber__c = '161616',
														Zuora__CancelledOn__c =null,
														Zuora__Comment__c = 'Comentario',
														Zuora__Effective_Date__c = date.newInstance(2020,11,20),
														Zuora__GatewayOrderId__c = '456',
														Zuora__GatewayResponse__c = '789',
														Zuora__GatewayResponseCode__c = 'A123',
														Zuora__GatewayStatus__c = 'Submitted',
														Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
														Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
														Zuora__PaymentNumber__c = 'B123',
														Zuora__ReferenceId__c = 'B456',
														Zuora__RefundAmount__c = 0,
														Zuora__SecondPaymentReferenceId__c = 'C123',
														Zuora__SettledOn__c = date.newInstance(2020,11,20),
														Zuora__SoftDescriptor__c = 'C789',
														Zuora__SoftDescriptorPhone__c = 'D123',
														Zuora__Status__c = 'Processed',
														Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
														Zuora__TransferedToAccounting__c = 'D789',
														Zuora__Type__c = 'External');
		Test.startTest();
		insert pago;
        pago.Zuora__Amount__c = 55;
        update pago;
		Test.stopTest();
		System.assert(pago!=null,'Pago creado.');
	}

	@isTest
	private static void testBulk030() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 30];
		
		List<Zuora__Payment__c> pagoList = new List<Zuora__Payment__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = bill.Zuora__Account__r.Id,
															Zuora__BillingAccount__c = bill.Id,
															Zuora__AccountingCode__c = 'ABC', 
															Zuora__Amount__c = 17,
															Zuora__AppliedCreditBalanceAmount__c = 18,
															Zuora__AuthTransactionId__c = '123',
															Zuora__BankIdentificationNumber__c = '161616',
															Zuora__CancelledOn__c =null,
															Zuora__Comment__c = 'Comentario',
															Zuora__Effective_Date__c = date.newInstance(2020,11,20),
															Zuora__GatewayOrderId__c = '456',
															Zuora__GatewayResponse__c = '789',
															Zuora__GatewayResponseCode__c = 'A123',
															Zuora__GatewayStatus__c = 'Submitted',
															Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
															Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
															Zuora__PaymentNumber__c = 'B123',
															Zuora__ReferenceId__c = 'B456',
															Zuora__RefundAmount__c = 0,
															Zuora__SecondPaymentReferenceId__c = 'C123',
															Zuora__SettledOn__c = date.newInstance(2020,11,20),
															Zuora__SoftDescriptor__c = 'C789',
															Zuora__SoftDescriptorPhone__c = 'D123',
															Zuora__Status__c = 'Processed',
															Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
															Zuora__TransferedToAccounting__c = 'D789',
															Zuora__Type__c = 'External');
			pagoList.add(pago);
		}
        Test.startTest();
		insert pagoList;
		Test.stopTest();
		System.assert(pagoList!=null,'Pagos creados.');
	}

	@isTest
	private static void testBulk055() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 55];
		
		List<Zuora__Payment__c> pagoList = new List<Zuora__Payment__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = bill.Zuora__Account__r.Id,
															Zuora__BillingAccount__c = bill.Id,
															Zuora__AccountingCode__c = 'ABC', 
															Zuora__Amount__c = 17,
															Zuora__AppliedCreditBalanceAmount__c = 18,
															Zuora__AuthTransactionId__c = '123',
															Zuora__BankIdentificationNumber__c = '161616',
															Zuora__CancelledOn__c =null,
															Zuora__Comment__c = 'Comentario',
															Zuora__Effective_Date__c = date.newInstance(2020,11,20),
															Zuora__GatewayOrderId__c = '456',
															Zuora__GatewayResponse__c = '789',
															Zuora__GatewayResponseCode__c = 'A123',
															Zuora__GatewayStatus__c = 'Submitted',
															Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
															Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
															Zuora__PaymentNumber__c = 'B123',
															Zuora__ReferenceId__c = 'B456',
															Zuora__RefundAmount__c = 0,
															Zuora__SecondPaymentReferenceId__c = 'C123',
															Zuora__SettledOn__c = date.newInstance(2020,11,20),
															Zuora__SoftDescriptor__c = 'C789',
															Zuora__SoftDescriptorPhone__c = 'D123',
															Zuora__Status__c = 'Processed',
															Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
															Zuora__TransferedToAccounting__c = 'D789',
															Zuora__Type__c = 'External');
			pagoList.add(pago);
		}
		Test.startTest();
        insert pagoList;
		Test.stopTest();
		System.assert(pagoList!=null,'Pagos creados.');
	}

	@isTest
	private static void testBulk080() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 80];
		
		List<Zuora__Payment__c> pagoList = new List<Zuora__Payment__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = bill.Zuora__Account__r.Id,
															Zuora__BillingAccount__c = bill.Id,
															Zuora__AccountingCode__c = 'ABC', 
															Zuora__Amount__c = 17,
															Zuora__AppliedCreditBalanceAmount__c = 18,
															Zuora__AuthTransactionId__c = '123',
															Zuora__BankIdentificationNumber__c = '161616',
															Zuora__CancelledOn__c =null,
															Zuora__Comment__c = 'Comentario',
															Zuora__Effective_Date__c = date.newInstance(2020,11,20),
															Zuora__GatewayOrderId__c = '456',
															Zuora__GatewayResponse__c = '789',
															Zuora__GatewayResponseCode__c = 'A123',
															Zuora__GatewayStatus__c = 'Submitted',
															Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
															Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
															Zuora__PaymentNumber__c = 'B123',
															Zuora__ReferenceId__c = 'B456',
															Zuora__RefundAmount__c = 0,
															Zuora__SecondPaymentReferenceId__c = 'C123',
															Zuora__SettledOn__c = date.newInstance(2020,11,20),
															Zuora__SoftDescriptor__c = 'C789',
															Zuora__SoftDescriptorPhone__c = 'D123',
															Zuora__Status__c = 'Processed',
															Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
															Zuora__TransferedToAccounting__c = 'D789',
															Zuora__Type__c = 'External');
			pagoList.add(pago);
		}
		Test.startTest();
        insert pagoList;
		Test.stopTest();
		System.assert(pagoList!=null,'Pagos creados.');
	}

	@isTest
	private static void testBulk110() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 110];
		
		List<Zuora__Payment__c> pagoList = new List<Zuora__Payment__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = bill.Zuora__Account__r.Id,
															Zuora__BillingAccount__c = bill.Id,
															Zuora__AccountingCode__c = 'ABC', 
															Zuora__Amount__c = 17,
															Zuora__AppliedCreditBalanceAmount__c = 18,
															Zuora__AuthTransactionId__c = '123',
															Zuora__BankIdentificationNumber__c = '161616',
															Zuora__CancelledOn__c =null,
															Zuora__Comment__c = 'Comentario',
															Zuora__Effective_Date__c = date.newInstance(2020,11,20),
															Zuora__GatewayOrderId__c = '456',
															Zuora__GatewayResponse__c = '789',
															Zuora__GatewayResponseCode__c = 'A123',
															Zuora__GatewayStatus__c = 'Submitted',
															Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
															Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
															Zuora__PaymentNumber__c = 'B123',
															Zuora__ReferenceId__c = 'B456',
															Zuora__RefundAmount__c = 0,
															Zuora__SecondPaymentReferenceId__c = 'C123',
															Zuora__SettledOn__c = date.newInstance(2020,11,20),
															Zuora__SoftDescriptor__c = 'C789',
															Zuora__SoftDescriptorPhone__c = 'D123',
															Zuora__Status__c = 'Processed',
															Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
															Zuora__TransferedToAccounting__c = 'D789',
															Zuora__Type__c = 'External');
			pagoList.add(pago);
		}
		Test.startTest();
        insert pagoList;
		Test.stopTest();
		System.assert(pagoList!=null,'Pagos creados.');
	}

	@isTest
	private static void testBulk130() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 130];
		
		List<Zuora__Payment__c> pagoList = new List<Zuora__Payment__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = bill.Zuora__Account__r.Id,
															Zuora__BillingAccount__c = bill.Id,
															Zuora__AccountingCode__c = 'ABC', 
															Zuora__Amount__c = 17,
															Zuora__AppliedCreditBalanceAmount__c = 18,
															Zuora__AuthTransactionId__c = '123',
															Zuora__BankIdentificationNumber__c = '161616',
															Zuora__CancelledOn__c =null,
															Zuora__Comment__c = 'Comentario',
															Zuora__Effective_Date__c = date.newInstance(2020,11,20),
															Zuora__GatewayOrderId__c = '456',
															Zuora__GatewayResponse__c = '789',
															Zuora__GatewayResponseCode__c = 'A123',
															Zuora__GatewayStatus__c = 'Submitted',
															Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
															Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
															Zuora__PaymentNumber__c = 'B123',
															Zuora__ReferenceId__c = 'B456',
															Zuora__RefundAmount__c = 0,
															Zuora__SecondPaymentReferenceId__c = 'C123',
															Zuora__SettledOn__c = date.newInstance(2020,11,20),
															Zuora__SoftDescriptor__c = 'C789',
															Zuora__SoftDescriptorPhone__c = 'D123',
															Zuora__Status__c = 'Processed',
															Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
															Zuora__TransferedToAccounting__c = 'D789',
															Zuora__Type__c = 'External');
			pagoList.add(pago);
		}
		Test.startTest();
        insert pagoList;
		Test.stopTest();
		System.assert(pagoList!=null,'Pagos creados.');
	}

	@isTest
	private static void testBulk155() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 155];
		
		List<Zuora__Payment__c> pagoList = new List<Zuora__Payment__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = bill.Zuora__Account__r.Id,
															Zuora__BillingAccount__c = bill.Id,
															Zuora__AccountingCode__c = 'ABC', 
															Zuora__Amount__c = 17,
															Zuora__AppliedCreditBalanceAmount__c = 18,
															Zuora__AuthTransactionId__c = '123',
															Zuora__BankIdentificationNumber__c = '161616',
															Zuora__CancelledOn__c =null,
															Zuora__Comment__c = 'Comentario',
															Zuora__Effective_Date__c = date.newInstance(2020,11,20),
															Zuora__GatewayOrderId__c = '456',
															Zuora__GatewayResponse__c = '789',
															Zuora__GatewayResponseCode__c = 'A123',
															Zuora__GatewayStatus__c = 'Submitted',
															Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
															Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
															Zuora__PaymentNumber__c = 'B123',
															Zuora__ReferenceId__c = 'B456',
															Zuora__RefundAmount__c = 0,
															Zuora__SecondPaymentReferenceId__c = 'C123',
															Zuora__SettledOn__c = date.newInstance(2020,11,20),
															Zuora__SoftDescriptor__c = 'C789',
															Zuora__SoftDescriptorPhone__c = 'D123',
															Zuora__Status__c = 'Processed',
															Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
															Zuora__TransferedToAccounting__c = 'D789',
															Zuora__Type__c = 'External');
			pagoList.add(pago);
		}
		Test.startTest();
        insert pagoList;
		Test.stopTest();
		System.assert(pagoList!=null,'Pagos creados.');
	}

	@isTest
	private static void testBulk180() {
		List<Zuora__CustomerAccount__c> billingAccount = [SELECT Id, Zuora__Account__r.Id FROM Zuora__CustomerAccount__c LIMIT 180];
		
		List<Zuora__Payment__c> pagoList = new List<Zuora__Payment__c>();
		for(Zuora__CustomerAccount__c bill : billingAccount) {
			Zuora__Payment__c pago = new Zuora__Payment__c( Zuora__Account__c = bill.Zuora__Account__r.Id,
															Zuora__BillingAccount__c = bill.Id,
															Zuora__AccountingCode__c = 'ABC', 
															Zuora__Amount__c = 17,
															Zuora__AppliedCreditBalanceAmount__c = 18,
															Zuora__AuthTransactionId__c = '123',
															Zuora__BankIdentificationNumber__c = '161616',
															Zuora__CancelledOn__c =null,
															Zuora__Comment__c = 'Comentario',
															Zuora__Effective_Date__c = date.newInstance(2020,11,20),
															Zuora__GatewayOrderId__c = '456',
															Zuora__GatewayResponse__c = '789',
															Zuora__GatewayResponseCode__c = 'A123',
															Zuora__GatewayStatus__c = 'Submitted',
															Zuora__MarkedForSubmissionOn__c = date.newInstance(2020,11,20),
															Zuora__PaymentMethodId__c = 'a0D0E000005x7I9UAI',
															Zuora__PaymentNumber__c = 'B123',
															Zuora__ReferenceId__c = 'B456',
															Zuora__RefundAmount__c = 0,
															Zuora__SecondPaymentReferenceId__c = 'C123',
															Zuora__SettledOn__c = date.newInstance(2020,11,20),
															Zuora__SoftDescriptor__c = 'C789',
															Zuora__SoftDescriptorPhone__c = 'D123',
															Zuora__Status__c = 'Processed',
															Zuora__SubmittedOn__c = date.newInstance(2020,11,20),
															Zuora__TransferedToAccounting__c = 'D789',
															Zuora__Type__c = 'External');
			pagoList.add(pago);
		}
		Test.startTest();
        insert pagoList;
		Test.stopTest();
		System.assert(pagoList!=null,'Pagos creados.');
	}*/
}