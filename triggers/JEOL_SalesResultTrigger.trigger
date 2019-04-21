trigger JEOL_SalesResultTrigger on SalesResult__c (before insert, before update, after insert, after update) {
    List<SalesResult__c> salesResults = Trigger.new;
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        JEOL_ObjectTriggerHadler.salesResult_relationshipToAccount(salesResults);
    }
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        JEOL_AccessTriggerHandler.createSalesResultShares(salesResults);
    }
}