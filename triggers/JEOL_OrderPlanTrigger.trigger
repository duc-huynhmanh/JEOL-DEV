trigger JEOL_OrderPlanTrigger on OrderPlan__c (after insert, after update) {
	List<OrderPlan__c> orderPlans = Trigger.new;
	if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
		JEOL_AccessTriggerHandler.createOrderPlanShares(orderPlans);
	}
}