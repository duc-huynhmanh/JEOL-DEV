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

	Map<String, Set<String>> countryMap = new Map<String, Set<String>>();
	Map<String, Set<String>> seriesMap = new Map<String, Set<String>>();

	for(Member_Data__c member : [SELECT Country_Group__c, Name__c, Country_For_Sharing_Rule__c FROM Member_Data__c WHERE (Country_Group__c != null OR Country_For_Sharing_Rule__c != null) AND Master_Country__r.Label__c IN :countries]){
		if(countryMap.containsKey(member.Name__c)){
			Set<String> existingGroups = countryMap.get(member.Name__c);
			if(member.Country_Group__c != null){
				existingGroups.add(member.Country_Group__c);
			}
			if(member.Country_For_Sharing_Rule__c != null){
				existingGroups.add(member.Country_For_Sharing_Rule__c);
			}
			countryMap.put(member.Name__c, existingGroups);
		} else {
			Set<String> newGroups = new Set<String>();
			if(member.Country_Group__c != null){
				newGroups.add(member.Country_Group__c);
			}
			if(member.Country_For_Sharing_Rule__c != null){
				newGroups.add(member.Country_For_Sharing_Rule__c);
			}
			countryMap.put(member.Name__c, newGroups);
		}
	}

	for(Member_Data__c member : [SELECT Series_Group__c, Name__c, Series_For_Sharing_Rule__c FROM Member_Data__c WHERE (Series_Group__c != null OR Series_For_Sharing_Rule__c != null) AND Master_Series__r.Label__c IN :series]){
		if(seriesMap.containsKey(member.Name__c)){
			Set<String> existingGroups = seriesMap.get(member.Name__c);
			if(member.Series_Group__c != null){
				existingGroups.add(member.Series_Group__c);
			}
			if(member.Series_For_Sharing_Rule__c != null){
				existingGroups.add(member.Series_For_Sharing_Rule__c);
			}
			seriesMap.put(member.Name__c, existingGroups);
		} else {
			Set<String> newGroups = new Set<String>();
			if(member.Series_Group__c != null){
				newGroups.add(member.Series_Group__c);
			}
			if(member.Series_For_Sharing_Rule__c != null){
				newGroups.add(member.Series_For_Sharing_Rule__c);
			}
			seriesMap.put(member.Name__c, newGroups);
		}
	}

	for(AsiaProfitCalculation__c item: reshareItems){
		String country = item.ShipmentCountry__c;
		String series = item.Series__c;
		Set<String> countryGroup = countryMap.get(country);
		Set<String> seriesGroup = seriesMap.get(series);

		List<Sharing_Rule__c> rules = [SELECT User__c FROM Sharing_Rule__c 
		WHERE 
		(Country_Group__c IN :countryGroup OR Select_All_Countries__c = True OR Id IN :countryGroup)
		AND
		(Series_Group__c IN :seriesGroup OR Select_All_Series__c = True OR Id IN :seriesGroup)];
		
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