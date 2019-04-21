trigger JEOL_SupportTrigger on Support__c (before insert, before update, after insert, after update) {
    List<Support__c> supports = Trigger.new;
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        JEOL_AccessTriggerHandler.createSupportShares(supports);
    }
}