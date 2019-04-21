trigger JEOL_ServiceOrderTrigger on ServiceOrder__c (after insert, after update) {
	List<ServiceOrder__c> serviceOrders = Trigger.new;
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        JEOL_AccessTriggerHandler.createServiceOrderShares(serviceOrders);
    }

}