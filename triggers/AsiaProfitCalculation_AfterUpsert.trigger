trigger AsiaProfitCalculation_AfterUpsert on AsiaProfitCalculation__c (after insert, after update) {
	List<AsiaProfitCalculation__c> reshareItems = new List<AsiaProfitCalculation__c>();
	List<Id> reshareIds = new List<Id>();
	for (AsiaProfitCalculation__c pro : Trigger.New){
        if(Trigger.isUpdate) {
            AsiaProfitCalculation__c old = Trigger.oldMap.get(pro.Id);
            if (old.Series__c != pro.Series__c || old.ShipmentCountry__c != pro.ShipmentCountry__c)
            {
                reshareItems.add(pro);
                reshareIds.add(pro.Id);
            }
        } else if(Trigger.isInsert) {
            reshareItems.add(pro);
            reshareIds.add(pro.Id);
        }
    }
    //remove existing share records
    List<AsiaProfitCalculation__share> removingShareRecords = [SELECT Id FROM AsiaProfitCalculation__share 
    WHERE RowCause = :Schema.AsiaProfitCalculation__share.RowCause.Manually_Sharing__c AND ParentId IN :reshareIds];
	if(removingShareRecords != null && removingShareRecords.size() > 0){
		delete removingShareRecords;
	}

	List<AsiaProfitCalculation__share> insertShareRecords = new List<AsiaProfitCalculation__share>();
	for(AsiaProfitCalculation__c item: reshareItems){
		String countryLikeStr = '%'+item.ShipmentCountry__c+'%';
		String seriesLikeStr = '%'+item.Series__c+'%';
		List<Sharing_Rule__c> rules = [SELECT User__c FROM Sharing_Rule__c 
		WHERE 
		(Country__c LIKE :countryLikeStr OR Country_Group__r.Countries__c LIKE :countryLikeStr OR Country_Group__r.Name = 'ALL')
		AND
		(Series__c LIKE :seriesLikeStr OR Series_Group__r.Series__c LIKE :seriesLikeStr OR Series_Group__r.Name = 'ALL')];
		
		for(Sharing_Rule__c rule : rules){
			AsiaProfitCalculation__share addingShareRecord = new AsiaProfitCalculation__share();
        	addingShareRecord.ParentId = item.Id;
            addingShareRecord.userOrGroupId = rule.User__c;
            addingShareRecord.RowCause = Schema.AsiaProfitCalculation__share.RowCause.Manually_Sharing__c;
            addingShareRecord.AccessLevel = 'Edit';
            insertShareRecords.add(addingShareRecord);
		}
	}
	if(insertShareRecords != null && insertShareRecords.size() > 0){
		insert insertShareRecords;
	}
}