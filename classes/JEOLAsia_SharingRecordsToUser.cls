global class JEOLAsia_SharingRecordsToUser implements Database.Batchable<sObject> {
    public String query;
    public Id userId;

    global JEOLAsia_SharingRecordsToUser(Id uId) {
    	userId = uId;
    	system.debug('userId: ' + userId);
        query = 'SELECT Country__c, Country_Group__r.Countries__c, Series__c, Series_Group__r.Series__c, User__c FROM Sharing_Rule__c WHERE User__c = \'' + userId + '\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    public static String joinWhereConditions(List<String> conditions) {
        String ret = ' WHERE ';
        for (String condition : conditions) {
           	ret += condition + ' OR ';
        }
        return ret.removeEnd(' OR ');
    }

    global void execute(Database.BatchableContext BC, List<Sharing_Rule__c> rules) {
    	List<String> conditions = new List<String>();
        for (Sharing_Rule__c rule : rules) {
        	String countries = String.isBlank(rule.Country_Group__r.Countries__c) ? rule.Country__c : (rule.Country_Group__r.Countries__c + ',' + rule.Country__c);
        	String series = String.isBlank(rule.Series_Group__r.Series__c) ? rule.Series__c : (rule.Series_Group__r.Series__c + ',' + rule.Series__c);

        	String condition;

        	//build condition
        	if(countries.toLowerCase().indexOf('all') >= 0){
        		if(series.toLowerCase().indexOf('all') >= 0) {
        			condition = '';
        		} else {
        			series = series.replace(',', '\',\'');
        			condition = '(Series__c IN (\'' + series + '\'))';
        		}
        	} else {
        		countries = countries.replace(',', '\',\'');
        		if(series.toLowerCase().indexOf('all') >= 0) {
        			condition = '(ShipmentCountry__c IN (\'' + countries + '\'))';
        		} else {
        			series = series.replace(',', '\',\'');
        			condition = '(ShipmentCountry__c IN (\'' + countries + '\')' +
        				' AND Series__c IN (\'' + series + '\'))';
        		}
        	}

        	/*String condition = '(ShipmentCountry__c IN (\'' + countries + '\')' +
        				' AND Series__c IN (\'' + series + '\'))'; */
        	system.debug('condition: ' + condition);
        	conditions.add(condition);
        }

        String whereStr = ' LIMIT 0';
        if(conditions.size() > 0) {
        	whereStr = joinWhereConditions(conditions);
        }
        system.debug('whereStr: ' + whereStr);
        List<AsiaProfitCalculation__c> sharingRecords = (List<AsiaProfitCalculation__c>)Database.query('SELECT Id FROM AsiaProfitCalculation__c' + whereStr);

        List<AsiaProfitCalculation__share> addingShareRecords = new List<AsiaProfitCalculation__share>();
        //sharing Quotation records to user
        for(AsiaProfitCalculation__c record : sharingRecords){
        	AsiaProfitCalculation__share addingShareRecord = new AsiaProfitCalculation__share();
        	addingShareRecord.ParentId = record.Id;
            addingShareRecord.userOrGroupId = userId;
            addingShareRecord.RowCause = Schema.AsiaProfitCalculation__share.RowCause.Manually_Sharing__c;
            addingShareRecord.AccessLevel = 'Edit';
            addingShareRecords.add(addingShareRecord);
        }

        if(addingShareRecords.size() > 0){
        	insert addingShareRecords;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
    
}