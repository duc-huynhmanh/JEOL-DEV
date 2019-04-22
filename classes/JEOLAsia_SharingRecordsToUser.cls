global class JEOLAsia_SharingRecordsToUser implements Database.Batchable<sObject> {
    public String query;
    public Id userId;

    global JEOLAsia_SharingRecordsToUser(Id uId) {
    	userId = uId;
    	system.debug('userId: ' + userId);
        query = 'SELECT Country_Group__c, Series_Group__c, Select_All_Countries__c, Select_All_Series__c, (SELECT Name__c FROM Country_List__r), (SELECT Name__c FROM Series_List__r) FROM Sharing_Rule__c WHERE User__c = \'' + userId + '\'';
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
        List<Id> groupIds = new List<Id>();
        for (Sharing_Rule__c rule : rules){
            groupIds.add(rule.Country_Group__c);
            groupIds.add(rule.Series_Group__c);
        }
        List<Group_Data__c> groups = [SELECT Group_Type__c, (SELECT Name__c FROM Country_Members__r), (SELECT Name__c FROM Series_Members__r) FROM Group_Data__c WHERE Id IN :groupIds];
        Map<Id, String> groupMap = new Map<Id, String>();

        for(Group_Data__c g : groups){
            if(g.Group_Type__c == 'Country' && g.Country_Members__r != null && g.Country_Members__r.size() > 0){
                String countries = '';
                for(Integer i = 0; i < g.Country_Members__r.size(); i++){
                    countries = countries + g.Country_Members__r[i].Name__c + ',';
                }
                groupMap.put(g.Id, countries);
            }
            if(g.Group_Type__c == 'Series' && g.Series_Members__r != null && g.Series_Members__r.size() > 0){
                String series = '';
                for(Integer i = 0; i < g.Series_Members__r.size(); i++){
                    series = series + g.Series_Members__r[i].Name__c + ',';
                }
                groupMap.put(g.Id, series);
            }
        }

        for (Sharing_Rule__c rule : rules) {
            String countries = '';
            String series = '';

            //add country from member data which are under Group
            if(rule.Country_Group__c != null){
                if(groupMap.containsKey(rule.Country_Group__c)){
                    countries = groupMap.get(rule.Country_Group__c);
                }
            }
            //add series from member data which are under Group
            if(rule.Series_Group__c != null){
                if(groupMap.containsKey(rule.Series_Group__c)){
                    series = groupMap.get(rule.Series_Group__c);
                }
            }
            //add country from member data which are under Rule
        	if(rule.Country_List__r != null && rule.Country_List__r.size() > 0){
                for(Integer i = 0; i < rule.Country_List__r.size(); i++){
                    countries = countries + rule.Country_List__r[i].Name__c + ',';
                }
            }
            countries = countries.removeEnd(',');

            //add series from member data which are under Rule
            if(rule.Series_List__r != null && rule.Series_List__r.size() > 0){
                for(Integer i = 0; i < rule.Series_List__r.size(); i++){
                    series = series + rule.Series_List__r[i].Name__c + ',';
                }
            }
            series = series.removeEnd(',');

        	String condition;

        	//build condition
        	if(rule.Select_All_Countries__c){
        		if(rule.Select_All_Series__c) {
        			condition = '(ShipmentCountry__c <> \'\' AND Series__c <> \'\')'; //if select all series and all countries
        		} else {
        			series = series.replace(',', '\',\''); //if select all country
        			condition = '(ShipmentCountry__c <> \'\' AND Series__c IN (\'' + series + '\'))';
        		}
        	} else {
        		countries = countries.replace(',', '\',\'');
        		if(rule.Select_All_Series__c) {
        			condition = '(ShipmentCountry__c IN (\'' + countries + '\') AND Series__c <> \'\')'; //if select all series
        		} else {
        			series = series.replace(',', '\',\'');
        			condition = '(ShipmentCountry__c IN (\'' + countries + '\')' +
        				' AND Series__c IN (\'' + series + '\'))';
        		}
        	}

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