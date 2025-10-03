@isTest 
private class ZuoraSubscriptionProductChrgTrigger_Test {
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

		List<Zuora__Subscription__c> suscripcionList = new List<Zuora__Subscription__c>();
		for(Zuora__CustomerAccount__c billingAccount : billingList) {
			Zuora__Subscription__c  suscripcion = new Zuora__Subscription__c ();
			suscripcion.Zuora__Account__c = billingAccount.Zuora__Account__c;
			suscripcion.Zuora__AutoRenew__c = false;
			suscripcion.Zuora__CustomerAccount__c = billingAccount.Id;
			suscripcion.Zuora__CancelledDate__c = null;
			suscripcion.Zuora__MRR__c = 100;
			suscripcion.Zuora__ContractAcceptanceDate__c = date.newInstance(2020,11,20);
			suscripcion.Zuora__ContractEffectiveDate__c = date.newInstance(2020,10,20);
			suscripcion.Zuora__CurrentTerm__c = null;
			suscripcion.Zuora__CurrentTermPeriodType__c = null;
			suscripcion.Zuora__External_Id__c = '8adc9dee75257f0a017544f2a671110b' + billingAccount.Id;
			suscripcion.Zuora__InitialTerm__c = null;
			suscripcion.Zuora__InitialTermPeriodType__c = null;
			suscripcion.Zuora__InvoiceOwner__c = billingAccount.Id;
			suscripcion.Zuora__NextChargeDate__c = date.newInstance(2020,12,20);
			suscripcion.Zuora__NextRenewalDate__c = null;
			suscripcion.Zuora__Notes__c = 'prueba 10';
			suscripcion.Zuora__OpportunityCloseDate__c = null;
			suscripcion.Zuora__OpportunityName__c = null;
			suscripcion.Zuora__OriginalCreated_Date__c = datetime.newInstance(2020,10,20);
			suscripcion.Zuora__OriginalCreatedDate__c = date.newInstance(2020,10,20);
			suscripcion.Zuora__OriginalId__c = '8adc9dee75257f0a017544f2a671110b';
			suscripcion.Zuora__PreviousSubscriptionId__c = '8adc9dee75257f0a017544f2a671110b';
			suscripcion.Zuora__QuoteBusinessType__c = null;
			suscripcion.Zuora__QuoteNumber__c = null;
			suscripcion.Zuora__QuoteType__c = null;
			suscripcion.Zuora__RenewalTerm__c = null;
			suscripcion.Zuora__RenewalTermPeriodType__c = null;
			suscripcion.Zuora__ServiceActivationDate__c = date.newInstance(2020,11,20);
			suscripcion.Zuora__Status__c = 'Active';
			suscripcion.Zuora__SubscriptionEndDate__c = null;
			suscripcion.Name = billingAccount.Id;
			suscripcion.Zuora__SubscriptionNumber__c = 'A-S00000002' + billingAccount.Id;
			suscripcion.Zuora__SubscriptionStartDate__c = date.newInstance(2020,10,20);
			suscripcion.Zuora__TCV__c = null;
			suscripcion.Zuora__TermEndDate__c = null;
			suscripcion.Zuora__TermSettingType__c = 'EVERGREEN';
			suscripcion.Zuora__TermStartDate__c = date.newInstance(2020,10,20);
			suscripcion.Zuora__Version__c = 1;
			suscripcion.Zuora__Zuora_Id__c = '8adc9dee75257f0a017544f2a671110b';
			suscripcionList.add(suscripcion);
		}
		insert suscripcionList;
		Test.stopTest();
	}
	@isTest
	private static void testOne() {
		Zuora__Subscription__c suscripcion = [SELECT Id FROM Zuora__Subscription__c LIMIT 1];
		
		Zuora__SubscriptionProductCharge__c subscriptionProductCharge = new Zuora__SubscriptionProductCharge__c();
		subscriptionProductCharge.Zuora__EffectiveStartDate__c=date.newInstance(2021,03,31);
		subscriptionProductCharge.Zuora__BillingPeriod__c	='Month';
		subscriptionProductCharge.Zuora__Subscription__c = suscripcion.Id;
		subscriptionProductCharge.Name = 'SPC0000000002' + suscripcion.Id;
		subscriptionProductCharge.Zuora__Zuora_Id__c = '900000011';
		Test.startTest();
		insert subscriptionProductCharge;
		subscriptionProductCharge.Zuora__EffectiveStartDate__c = date.newInstance(2021,04,01);
		update subscriptionProductCharge;
		Test.stopTest();
		System.assert(subscriptionProductCharge != null, 'Product Charge creado.');
	}
		@isTest
	private static void test050() {
		List<Zuora__Subscription__c> suscripcionList = [SELECT Id FROM Zuora__Subscription__c LIMIT 50];

		List<Zuora__SubscriptionProductCharge__c> subscriptionProductChargeList = new List<Zuora__SubscriptionProductCharge__c>();
		for(Zuora__Subscription__c suscripcion : suscripcionList) {
			Zuora__SubscriptionProductCharge__c subscriptionProductCharge = new Zuora__SubscriptionProductCharge__c();
			subscriptionProductCharge.Zuora__EffectiveStartDate__c=date.newInstance(2021,03,31);
			subscriptionProductCharge.Zuora__BillingPeriod__c	='Month';
			subscriptionProductCharge.Zuora__Subscription__c = suscripcion.Id;
			subscriptionProductCharge.Name = 'SPC0000000002' + suscripcion.Id;
			subscriptionProductCharge.Zuora__Zuora_Id__c = '900000011';
			subscriptionProductChargeList.add(subscriptionProductCharge);
		}
		Test.startTest();
		insert subscriptionProductChargeList;
		Test.stopTest();
		System.assert(subscriptionProductChargeList != null, 'Product Charges creados.');
	}
	@isTest
	private static void test100() {
		List<Zuora__Subscription__c> suscripcionList = [SELECT Id FROM Zuora__Subscription__c LIMIT 100];

		List<Zuora__SubscriptionProductCharge__c> subscriptionProductChargeList = new List<Zuora__SubscriptionProductCharge__c>();
		for(Zuora__Subscription__c suscripcion : suscripcionList) {
			Zuora__SubscriptionProductCharge__c subscriptionProductCharge = new Zuora__SubscriptionProductCharge__c();
			subscriptionProductCharge.Zuora__EffectiveStartDate__c=date.newInstance(2021,03,31);
			subscriptionProductCharge.Zuora__BillingPeriod__c	='Month';
			subscriptionProductCharge.Zuora__Subscription__c = suscripcion.Id;
			subscriptionProductCharge.Name = 'SPC0000000002' + suscripcion.Id;
			subscriptionProductCharge.Zuora__Zuora_Id__c = '900000011';
			subscriptionProductChargeList.add(subscriptionProductCharge);
		}
		Test.startTest();
		insert subscriptionProductChargeList;
		Test.stopTest();
		System.assert(subscriptionProductChargeList != null, 'Product Charges creados.');
	}
	@isTest
	private static void test150() {
		List<Zuora__Subscription__c> suscripcionList = [SELECT Id FROM Zuora__Subscription__c LIMIT 150];

		List<Zuora__SubscriptionProductCharge__c> subscriptionProductChargeList = new List<Zuora__SubscriptionProductCharge__c>();
		for(Zuora__Subscription__c suscripcion : suscripcionList) {
			Zuora__SubscriptionProductCharge__c subscriptionProductCharge = new Zuora__SubscriptionProductCharge__c();
			subscriptionProductCharge.Zuora__EffectiveStartDate__c=date.newInstance(2021,03,31);
			subscriptionProductCharge.Zuora__BillingPeriod__c	='Month';
			subscriptionProductCharge.Zuora__Subscription__c = suscripcion.Id;
			subscriptionProductCharge.Name = 'SPC0000000002' + suscripcion.Id;
			subscriptionProductCharge.Zuora__Zuora_Id__c = '900000011';
			subscriptionProductChargeList.add(subscriptionProductCharge);
		}
		Test.startTest();
		insert subscriptionProductChargeList;
		Test.stopTest();
		System.assert(subscriptionProductChargeList != null, 'Product Charges creados.');
	}
	@isTest
	private static void test200() {
		List<Zuora__Subscription__c> suscripcionList = [SELECT Id FROM Zuora__Subscription__c LIMIT 200];

		List<Zuora__SubscriptionProductCharge__c> subscriptionProductChargeList = new List<Zuora__SubscriptionProductCharge__c>();
		for(Zuora__Subscription__c suscripcion : suscripcionList) {
			Zuora__SubscriptionProductCharge__c subscriptionProductCharge = new Zuora__SubscriptionProductCharge__c();
			subscriptionProductCharge.Zuora__EffectiveStartDate__c=date.newInstance(2021,03,31);
			subscriptionProductCharge.Zuora__BillingPeriod__c	='Month';
			subscriptionProductCharge.Zuora__Subscription__c = suscripcion.Id;
			subscriptionProductCharge.Name = 'SPC0000000002' + suscripcion.Id;
			subscriptionProductCharge.Zuora__Zuora_Id__c = '900000011';
			subscriptionProductChargeList.add(subscriptionProductCharge);
		}
		Test.startTest();
		insert subscriptionProductChargeList;
		Test.stopTest();
		System.assert(subscriptionProductChargeList != null, 'Product Charges creados.');
	}*/
}