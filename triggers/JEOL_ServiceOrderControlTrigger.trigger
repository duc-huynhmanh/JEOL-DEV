trigger JEOL_ServiceOrderControlTrigger on ServiceOrderControl__c (before insert, before update) {
    List<ServiceOrderControl__c> recs = Trigger.new;
    if (JEOL_ObjectTriggerHadler.isServiceOrderControlUpdate && Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        JEOL_ObjectTriggerHadler.serviceOrderControl_dateSync(recs);
    }
}