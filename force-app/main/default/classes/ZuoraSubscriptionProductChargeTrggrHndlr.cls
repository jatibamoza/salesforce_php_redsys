public class ZuoraSubscriptionProductChargeTrggrHndlr  {

	/*public static void gestionarAccion(
		Boolean isBefore,
		Boolean isAfter,
		Boolean isDelete,
		Boolean isInsert,
		Boolean isUpdate,
		Boolean isUndelete,
		List<Zuora__SubscriptionProductCharge__c> newList,
		Map<Id, Zuora__SubscriptionProductCharge__c> newMap,
		List<Zuora__SubscriptionProductCharge__c> oldList,
		Map<Id, Zuora__SubscriptionProductCharge__c> oldMap){
		if (isAfter) {
			if(isInsert) {
				handleAfterInsert(oldList, newList, oldMap, newMap);
			}
			if(isUpdate) {
				handleAfterUpdate(oldList, newList, oldMap, newMap);
			}
		}
	}

	public static void handleAfterInsert(List<Zuora__SubscriptionProductCharge__c> oldList, List<Zuora__SubscriptionProductCharge__c> newList, Map<Id, Zuora__SubscriptionProductCharge__c> oldMap, Map<Id, Zuora__SubscriptionProductCharge__c> newMap) {
		//Código dedicado a la acción SubscriptionProductCharge After Insert
		List<Id> listIds = new List<Id>();
        
        List<Id> newIds = new List<Id>();
        for(Zuora__SubscriptionProductCharge__c obj : newList){
           newIds.add(obj.Zuora__Subscription__c); 
        }
        
		Map<Id,Zuora__Subscription__c> subsList = new Map<Id,Zuora__Subscription__c>();

		List<AggregateResult> result  = [select COUNT(Id) from Zuora__SubscriptionProductCharge__c];       
		Integer recordCount = (Integer)result[0].get('expr0');
		Integer sizeBlock = recordCount/2000 + (math.mod(recordCount,2000) != 0 ? 1 : 0);
		Map<Id,Date> billId = new Map<Id,Date>();
		for(Integer i=0; i<sizeBlock; i++) {
			for(AggregateResult ar : [SELECT Zuora__Subscription__c, max(Zuora__EffectiveStartDate__c) FROM Zuora__SubscriptionProductCharge__c
			WHERE Id not in :billId.keySet() AND Zuora__Subscription__c in :newIds GROUP BY Zuora__Subscription__c limit 2000]){
				billId.put((Id)ar.get('Zuora__Subscription__c'), (Date)ar.get('expr0'));
			}
		}
		Map<Id,Zuora__SubscriptionProductCharge__c> billMap = new Map<Id,Zuora__SubscriptionProductCharge__c>([SELECT Id, Zuora__BillingPeriod__c, Zuora__Subscription__c FROM Zuora__SubscriptionProductCharge__c WHERE Zuora__Subscription__c IN: billId.keySet() AND Zuora__EffectiveStartDate__c IN: billId.values()]);
		List<Zuora__SubscriptionProductCharge__c> spcList = billMap.values();
		List<Id> subsId = new List<Id>();
		for (Zuora__SubscriptionProductCharge__c spcId : spcList) {
			subsId.add(spcId.Zuora__Subscription__c);
		}
		Map<Id, Zuora__Subscription__c> subsMap = new Map<Id, Zuora__Subscription__c>([SELECT Id, Zuora__CurrentTermPeriodType__c FROM Zuora__Subscription__c 
			WHERE Id IN :billId.keySet()]);
		for(Zuora__SubscriptionProductCharge__c spc : newList) {
			listIds.add(spc.Id);
			if (billMap.containsKey(spc.Id)) {
				Zuora__SubscriptionProductCharge__c spcPeriod = billMap.get(spc.Id);
				String period = spcPeriod.Zuora__BillingPeriod__c;
				Zuora__Subscription__c subs = subsMap.get(spcPeriod.Zuora__Subscription__c);
				subs.Zuora__CurrentTermPeriodType__c = period;
				subsList.put(subs.Id,subs);
			}
		}
		update subsList.values();
		callDSP(true, listIds);
	}

	public static void handleAfterUpdate(List<Zuora__SubscriptionProductCharge__c> oldList, List<Zuora__SubscriptionProductCharge__c> newList, Map<Id, Zuora__SubscriptionProductCharge__c> oldMap, Map<Id, Zuora__SubscriptionProductCharge__c> newMap) {
		//Código dedicado a la acción SubscriptionProductCharge After Update
		List<Id> listIds = new List<Id>();
        
        List<Id> newIds = new List<Id>();
        for(Zuora__SubscriptionProductCharge__c obj : newList){
           newIds.add(obj.Id); 
        }
        
		Map<Id,Zuora__Subscription__c> subsList = new Map<Id,Zuora__Subscription__c>();
		
        List<AggregateResult> result  = [select COUNT(Id) from Zuora__SubscriptionProductCharge__c];       
		Integer recordCount = (Integer)result[0].get('expr0');
		Integer sizeBlock = recordCount/2000 + (math.mod(recordCount,2000) != 0 ? 1 : 0);
		Map<Id,Date> billId = new Map<Id,Date>();
		for(Integer i=0; i<sizeBlock; i++) {
			for(AggregateResult ar : [SELECT Zuora__Subscription__c, max(Zuora__EffectiveStartDate__c) FROM Zuora__SubscriptionProductCharge__c
			WHERE Id not in :billId.keySet() AND Id in :newIds GROUP BY Zuora__Subscription__c limit 2000]){
				billId.put((Id)ar.get('Zuora__Subscription__c'), (Date)ar.get('expr0'));
			}
		}
		Map<Id,Zuora__SubscriptionProductCharge__c> billMap = new Map<Id,Zuora__SubscriptionProductCharge__c>([SELECT Id, Zuora__BillingPeriod__c, Zuora__Subscription__c FROM Zuora__SubscriptionProductCharge__c WHERE Zuora__Subscription__c IN: billId.keySet() AND Zuora__EffectiveStartDate__c IN: billId.values()]);
		List<Zuora__SubscriptionProductCharge__c> spcList = billMap.values();
		List<Id> subsId = new List<Id>();
		for (Zuora__SubscriptionProductCharge__c spcId : spcList) {
			subsId.add(spcId.Zuora__Subscription__c);
		}
		Map<Id, Zuora__Subscription__c> subsMap = new Map<Id, Zuora__Subscription__c>([SELECT Id, Zuora__CurrentTermPeriodType__c FROM Zuora__Subscription__c 
			WHERE Id IN :billId.keySet()]);
		for (Zuora__SubscriptionProductCharge__c spc : newList)
		{
			if (spc.Zuora__BillingPeriod__c != oldmap.get(spc.Id).Zuora__BillingPeriod__c)
			{
				listIds.add(spc.Id);
				if (billMap.containsKey(spc.Id)) {
					Zuora__SubscriptionProductCharge__c spcPeriod = billMap.get(spc.Id);
					String period = spcPeriod.Zuora__BillingPeriod__c;
					Zuora__Subscription__c subs = subsMap.get(spcPeriod.Zuora__Subscription__c);
					subs.Zuora__CurrentTermPeriodType__c = period;
					subsList.put(subs.Id,subs);
				}
			}
		}
		update subsList.values();
		callDSP(true, listIds);
	}
	public static void callDSP(Boolean nuevo, List<Id> listIds) {
		FAN_Callout.enviarSPC(nuevo, listIds);
	}*/
}