trigger JEOL_OperationHistoryTrigger on OperationHistory__c (after insert, after update, before insert, before update) {
	List<OperationHistory__c> recs = Trigger.new;

	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
		JEOL_ObjectTriggerHadler.operationHistory_descriptionToMemo(recs);
		JEOL_ObjectTriggerHadler.operationHistory_relationshipToSupport(recs);
	}
	
	if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
		JEOL_ObjectTriggerHadler.operationHistory_putServiceDateToSupport(recs);
	}
}