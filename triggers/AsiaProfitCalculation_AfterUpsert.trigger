trigger AsiaProfitCalculation_AfterUpsert on AsiaProfitCalculation__c (after insert, after update) {
	List<AsiaProfitCalculation__c> reshareItems = new List<AsiaProfitCalculation__c>();
	Set<String> countries = new Set<String>();
	Set<String> series = new Set<String>();
	List<Id> reshareIds = new List<Id>();

	for (AsiaProfitCalculation__c pro : Trigger.New){
        if(Trigger.isUpdate) {
            AsiaProfitCalculation__c old = Trigger.oldMap.get(pro.Id);
            if (old.Series__c != pro.Series__c || old.ShipmentCountry__c != pro.ShipmentCountry__c)
            {
                reshareItems.add(pro);
                reshareIds.add(pro.Id);
                countries.add(pro.ShipmentCountry__c);
                series.add(pro.Series__c);
            }
        } else if(Trigger.isInsert) {
            reshareItems.add(pro);
            reshareIds.add(pro.Id);
            countries.add(pro.ShipmentCountry__c);
            series.add(pro.Series__c);
        }
    }
    //remove existing share records
    List<AsiaProfitCalculation__share> removingShareRecords = [SELECT Id FROM AsiaProfitCalculation__share 
    WHERE RowCause = :Schema.AsiaProfitCalculation__share.RowCause.Manually_Sharing__c AND ParentId IN :reshareIds];
	if(removingShareRecords != null && removingShareRecords.size() > 0){
		delete removingShareRecords;
	}

	List<AsiaProfitCalculation__share> insertShareRecords = new List<AsiaProfitCalculation__share>();

	Map<String, List<String>> countryMap = new Map<String, List<String>>();
	Map<String, List<String>> seriesMap = new Map<String, List<String>>();

	for(Member_Data__c member : [SELECT Country_Group__c, Name__c FROM Member_Data__c WHERE Country_Group__c != null AND Master_Country__r.Label__c IN :countries]){
		if(countryMap.containsKey(member.Name__c)){
			List<String> existingGroups = countryMap.get(member.Name__c);
			existingGroups.add(member.Country_Group__c);
			countryMap.put(member.Name__c, existingGroups);
		} else {
			countryMap.put(member.Name__c, new List<String>{member.Country_Group__c});	
		}
	}

	for(Member_Data__c member : [SELECT Series_Group__c, Name__c FROM Member_Data__c WHERE Series_Group__c != null AND Master_Series__r.Label__c IN :series]){
		if(seriesMap.containsKey(member.Name__c)){
			List<String> existingSeries = seriesMap.get(member.Name__c);
			existingSeries.add(member.Series_Group__c);
			seriesMap.put(member.Name__c, existingSeries);
		} else {
			seriesMap.put(member.Name__c, new List<String>{member.Series_Group__c});	
		}
	}

	for(AsiaProfitCalculation__c item: reshareItems){
		String country = item.ShipmentCountry__c;
		String series = item.Series__c;
		List<String> countryGroup = countryMap.get(country);
		List<String> seriesGroup = seriesMap.get(country);

		List<Sharing_Rule__c> rules = [SELECT User__c FROM Sharing_Rule__c 
		WHERE 
		(Country_Name__c = :country OR Country_Group__c IN :countryGroup OR Country_Group__r.Is_All__c = True)
		AND
		(Series_Name__c = :series OR Series_Group__c IN :seriesGroup OR Series_Group__r.Is_All__c = True)];
		
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