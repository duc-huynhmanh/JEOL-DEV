trigger JEOL_QuoteTrigger on Quote__c (after insert, after update) {
	List<Quote__c> quotes = Trigger.new;
	if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
		JEOL_AccessTriggerHandler.createQuoteShares(quotes);
	}
	
}