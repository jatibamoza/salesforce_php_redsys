@isTest 
private class ZuoraSubscriptionTrigger_Test {
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
		Test.stopTest();
	}
	@isTest
	private static void testOne() {
		Zuora__CustomerAccount__c billingAccount = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 1];
		Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
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
																			Zuora__InvoiceOwner__c = billingAccount.Id,
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
																			Name = billingAccount.Id,
																			Zuora__SubscriptionNumber__c = 'A-S00000002',
																			Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																			Zuora__TCV__c = null,
																			Zuora__TermEndDate__c = null,
																			Zuora__TermSettingType__c = 'EVERGREEN',
																			Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																			Zuora__Version__c = 1,
																			Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
		Test.startTest();
		insert suscripcion;
		suscripcion.Zuora__Notes__c = 'prueba';
		update suscripcion;
		Test.stopTest();
		System.assert(suscripcion != null, 'Suscripción creada.');
	}

	@isTest
	private static void test035() {
		List<Zuora__CustomerAccount__c> billingList = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 35];

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
																				Zuora__AutoRenew__c = false,
																				Zuora__CustomerAccount__c = billingAccount.Id,
																				Zuora__CancelledDate__c = null,
																				Zuora__MRR__c = 100,
																				Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																				Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																				Zuora__CurrentTerm__c = null,
																				Zuora__CurrentTermPeriodType__c = null,
																				Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id,
																				Zuora__InitialTerm__c = null,
																				Zuora__InitialTermPeriodType__c = null,
																				Zuora__InvoiceOwner__c = billingAccount.Id,
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
																				Name = billingAccount.Id,
																				Zuora__SubscriptionNumber__c = billingAccount.Id,
																				Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																				Zuora__TCV__c = null,
																				Zuora__TermEndDate__c = null,
																				Zuora__TermSettingType__c = 'EVERGREEN',
																				Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																				Zuora__Version__c = 1,
																				Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
			suscripcionList.add(suscripcion);
		}
		Test.startTest();
		insert suscripcionList;
		Test.stopTest();
		System.assert(suscripcionList != null, 'Suscripción creada.');
	}

	@isTest
	private static void test060() {
		List<Zuora__CustomerAccount__c> billingList = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 60];

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
																				Zuora__AutoRenew__c = false,
																				Zuora__CustomerAccount__c = billingAccount.Id,
																				Zuora__CancelledDate__c = null,
																				Zuora__MRR__c = 100,
																				Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																				Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																				Zuora__CurrentTerm__c = null,
																				Zuora__CurrentTermPeriodType__c = null,
																				Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id,
																				Zuora__InitialTerm__c = null,
																				Zuora__InitialTermPeriodType__c = null,
																				Zuora__InvoiceOwner__c = billingAccount.Id,
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
																				Name = billingAccount.Id,
																				Zuora__SubscriptionNumber__c = billingAccount.Id,
																				Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																				Zuora__TCV__c = null,
																				Zuora__TermEndDate__c = null,
																				Zuora__TermSettingType__c = 'EVERGREEN',
																				Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																				Zuora__Version__c = 1,
																				Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
			suscripcionList.add(suscripcion);
		}
		Test.startTest();
		insert suscripcionList;
		Test.stopTest();
		System.assert(suscripcionList != null, 'Suscripción creada.');
	}

	@isTest
	private static void test085() {
		List<Zuora__CustomerAccount__c> billingList = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 85];

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
																				Zuora__AutoRenew__c = false,
																				Zuora__CustomerAccount__c = billingAccount.Id,
																				Zuora__CancelledDate__c = null,
																				Zuora__MRR__c = 100,
																				Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																				Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																				Zuora__CurrentTerm__c = null,
																				Zuora__CurrentTermPeriodType__c = null,
																				Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id,
																				Zuora__InitialTerm__c = null,
																				Zuora__InitialTermPeriodType__c = null,
																				Zuora__InvoiceOwner__c = billingAccount.Id,
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
																				Name = billingAccount.Id,
																				Zuora__SubscriptionNumber__c = billingAccount.Id,
																				Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																				Zuora__TCV__c = null,
																				Zuora__TermEndDate__c = null,
																				Zuora__TermSettingType__c = 'EVERGREEN',
																				Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																				Zuora__Version__c = 1,
																				Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
			suscripcionList.add(suscripcion);
		}
		Test.startTest();
		insert suscripcionList;
		Test.stopTest();
		System.assert(suscripcionList != null, 'Suscripción creada.');
	}

	@isTest
	private static void test110() {
		List<Zuora__CustomerAccount__c> billingList = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 110];

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
																				Zuora__AutoRenew__c = false,
																				Zuora__CustomerAccount__c = billingAccount.Id,
																				Zuora__CancelledDate__c = null,
																				Zuora__MRR__c = 100,
																				Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																				Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																				Zuora__CurrentTerm__c = null,
																				Zuora__CurrentTermPeriodType__c = null,
																				Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id,
																				Zuora__InitialTerm__c = null,
																				Zuora__InitialTermPeriodType__c = null,
																				Zuora__InvoiceOwner__c = billingAccount.Id,
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
																				Name = billingAccount.Id,
																				Zuora__SubscriptionNumber__c = billingAccount.Id,
																				Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																				Zuora__TCV__c = null,
																				Zuora__TermEndDate__c = null,
																				Zuora__TermSettingType__c = 'EVERGREEN',
																				Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																				Zuora__Version__c = 1,
																				Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
			suscripcionList.add(suscripcion);
		}
		Test.startTest();
		insert suscripcionList;
		Test.stopTest();
		System.assert(suscripcionList != null, 'Suscripción creada.');
	}

	@isTest
	private static void test135() {
		List<Zuora__CustomerAccount__c> billingList = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 135];

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
																				Zuora__AutoRenew__c = false,
																				Zuora__CustomerAccount__c = billingAccount.Id,
																				Zuora__CancelledDate__c = null,
																				Zuora__MRR__c = 100,
																				Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																				Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																				Zuora__CurrentTerm__c = null,
																				Zuora__CurrentTermPeriodType__c = null,
																				Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id,
																				Zuora__InitialTerm__c = null,
																				Zuora__InitialTermPeriodType__c = null,
																				Zuora__InvoiceOwner__c = billingAccount.Id,
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
																				Name = billingAccount.Id,
																				Zuora__SubscriptionNumber__c = billingAccount.Id,
																				Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																				Zuora__TCV__c = null,
																				Zuora__TermEndDate__c = null,
																				Zuora__TermSettingType__c = 'EVERGREEN',
																				Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																				Zuora__Version__c = 1,
																				Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
			suscripcionList.add(suscripcion);
		}
		Test.startTest();
		insert suscripcionList;
		Test.stopTest();
		System.assert(suscripcionList != null, 'Suscripción creada.');
	}

	@isTest
	private static void test160() {
		List<Zuora__CustomerAccount__c> billingList = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 160];

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
																				Zuora__AutoRenew__c = false,
																				Zuora__CustomerAccount__c = billingAccount.Id,
																				Zuora__CancelledDate__c = null,
																				Zuora__MRR__c = 100,
																				Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																				Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																				Zuora__CurrentTerm__c = null,
																				Zuora__CurrentTermPeriodType__c = null,
																				Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id,
																				Zuora__InitialTerm__c = null,
																				Zuora__InitialTermPeriodType__c = null,
																				Zuora__InvoiceOwner__c = billingAccount.Id,
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
																				Name = billingAccount.Id,
																				Zuora__SubscriptionNumber__c = billingAccount.Id,
																				Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																				Zuora__TCV__c = null,
																				Zuora__TermEndDate__c = null,
																				Zuora__TermSettingType__c = 'EVERGREEN',
																				Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																				Zuora__Version__c = 1,
																				Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
			suscripcionList.add(suscripcion);
		}
		Test.startTest();
		insert suscripcionList;
		Test.stopTest();
		System.assert(suscripcionList != null, 'Suscripción creada.');
	}

	@isTest
	private static void test200() {
		List<Zuora__CustomerAccount__c> billingList = [SELECT Id, Zuora__Account__c FROM Zuora__CustomerAccount__c LIMIT 200];

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c (	Zuora__Account__c = billingAccount.Zuora__Account__c,
																				Zuora__AutoRenew__c = false,
																				Zuora__CustomerAccount__c = billingAccount.Id,
																				Zuora__CancelledDate__c = null,
																				Zuora__MRR__c = 100,
																				Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20),
																				Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20),
																				Zuora__CurrentTerm__c = null,
																				Zuora__CurrentTermPeriodType__c = null,
																				Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id,
																				Zuora__InitialTerm__c = null,
																				Zuora__InitialTermPeriodType__c = null,
																				Zuora__InvoiceOwner__c = billingAccount.Id,
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
																				Name = billingAccount.Id,
																				Zuora__SubscriptionNumber__c = billingAccount.Id,
																				Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20),
																				Zuora__TCV__c = null,
																				Zuora__TermEndDate__c = null,
																				Zuora__TermSettingType__c = 'EVERGREEN',
																				Zuora__TermStartDate__c = date.newInstance(2020,10,20),
																				Zuora__Version__c = 1,
																				Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b');
			suscripcionList.add(suscripcion);
		}
		Test.startTest();
		insert suscripcionList;
		Test.stopTest();
		System.assert(suscripcionList != null, 'Suscripción creada.');
	}*/
}