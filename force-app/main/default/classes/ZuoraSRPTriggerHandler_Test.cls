@isTest
public class ZuoraSRPTriggerHandler_Test {
    /*@TestSetup
    private static void testSetup() {
        List<Zuora__SubscriptionRatePlan__c> srpList = new List<Zuora__SubscriptionRatePlan__c>();
        for(Integer i=0;i<200;i++) {
            Zuora__SubscriptionRatePlan__c srp = new Zuora__SubscriptionRatePlan__c();
            srp.Zuora__SubscriptionRatePlanName__c = i.format();
            srpList.add(srp);
        }
        insert srpList;
    }
    @isTest
    private static void testInsertOne() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        Zuora__SubscriptionRatePlan__c srp = new Zuora__SubscriptionRatePlan__c();
        insert srp;
        System.assert(srp != null, 'Rate plan creado.');
        Test.stopTest();
	}
    @isTest
    private static void testInsert040() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        List<Zuora__SubscriptionRatePlan__c> srpList = new List<Zuora__SubscriptionRatePlan__c>();
        for(Integer i=0;i<40;i++) {
            Zuora__SubscriptionRatePlan__c srp = new Zuora__SubscriptionRatePlan__c();
            srp.Zuora__SubscriptionRatePlanName__c = i.format();
            srpList.add(srp);
        }
        insert srpList;
        System.assert(srpList != null, 'Rate plans creados.');
        Test.stopTest();
	}
    @isTest
    private static void testInsert090() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        List<Zuora__SubscriptionRatePlan__c> srpList = new List<Zuora__SubscriptionRatePlan__c>();
        for(Integer i=0;i<90;i++) {
            Zuora__SubscriptionRatePlan__c srp = new Zuora__SubscriptionRatePlan__c();
            srp.Zuora__SubscriptionRatePlanName__c = i.format();
            srpList.add(srp);
        }
        insert srpList;
        System.assert(srpList != null, 'Rate plans creados.');
        Test.stopTest();
	}
    @isTest
    private static void testInsert140() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        List<Zuora__SubscriptionRatePlan__c> srpList = new List<Zuora__SubscriptionRatePlan__c>();
        for(Integer i=0;i<140;i++) {
            Zuora__SubscriptionRatePlan__c srp = new Zuora__SubscriptionRatePlan__c();
            srp.Zuora__SubscriptionRatePlanName__c = i.format();
            srpList.add(srp);
        }
        insert srpList;
        System.assert(srpList != null, 'Rate plans creados.');
        Test.stopTest();
	}
    @isTest
    private static void testUpdateOne() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        Zuora__SubscriptionRatePlan__c srp = [SELECT Id FROM Zuora__SubscriptionRatePlan__c WHERE Zuora__SubscriptionRatePlanName__c = '1'];
        srp.Zuora__AmendmentId__c = '123456789';
        update srp;
        System.assert(srp != null, 'Rate plan actualizado.');
        Test.stopTest();
	}
    @isTest
    private static void testUpdate040() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        List<Zuora__SubscriptionRatePlan__c> srpList = [SELECT Id, Zuora__AmendmentId__c FROM Zuora__SubscriptionRatePlan__c LIMIT 40];
        List<Zuora__SubscriptionRatePlan__c> srpUpd = new List<Zuora__SubscriptionRatePlan__c>();
        for (Zuora__SubscriptionRatePlan__c srp : srpList) {
            srp.Zuora__AmendmentId__c = '123456789';
            srpUpd.add(srp);
        }        
        update srpUpd;
        System.assert(srpUpd != null, 'Rate plans actualizados.');
        Test.stopTest();
	}
    @isTest
    private static void testUpdate090() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        List<Zuora__SubscriptionRatePlan__c> srpList = [SELECT Id, Zuora__AmendmentId__c FROM Zuora__SubscriptionRatePlan__c LIMIT 90];
        List<Zuora__SubscriptionRatePlan__c> srpUpd = new List<Zuora__SubscriptionRatePlan__c>();
        for (Zuora__SubscriptionRatePlan__c srp : srpList) {
            srp.Zuora__AmendmentId__c = '123456789';
            srpUpd.add(srp);
        }        
        update srpUpd;
        System.assert(srpUpd != null, 'Rate plans actualizados.');
        Test.stopTest();
	}
    @isTest
    private static void testUpdate140() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        List<Zuora__SubscriptionRatePlan__c> srpList = [SELECT Id, Zuora__AmendmentId__c FROM Zuora__SubscriptionRatePlan__c LIMIT 140];
        List<Zuora__SubscriptionRatePlan__c> srpUpd = new List<Zuora__SubscriptionRatePlan__c>();
        for (Zuora__SubscriptionRatePlan__c srp : srpList) {
            srp.Zuora__AmendmentId__c = '123456789';
            srpUpd.add(srp);
        }        
        update srpUpd;
        System.assert(srpUpd != null, 'Rate plans actualizados.');
        Test.stopTest();
	}
    @isTest
    private static void testUpdate200() {
		String respJSON = '{"access_token":"T0k3n"}';
		
		FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
		Test.setMock(HttpCalloutMock.class, okResponse);

		Test.startTest();
        List<Zuora__SubscriptionRatePlan__c> srpList = [SELECT Id, Zuora__AmendmentId__c FROM Zuora__SubscriptionRatePlan__c LIMIT 200];
        List<Zuora__SubscriptionRatePlan__c> srpUpd = new List<Zuora__SubscriptionRatePlan__c>();
        for (Zuora__SubscriptionRatePlan__c srp : srpList) {
            srp.Zuora__AmendmentId__c = '123456789';
            srpUpd.add(srp);
        }        
        update srpUpd;
        System.assert(srpUpd != null, 'Rate plans actualizados.');
        Test.stopTest();
	}*/
}