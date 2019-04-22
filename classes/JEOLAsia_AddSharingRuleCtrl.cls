public with sharing class JEOLAsia_AddSharingRuleCtrl {
	public Sharing_Rule__c data{get;set;}
	public List<MemberData> seriesList{get;set;}
	public List<MemberData> countryList{get;set;}
	public String removeCountryId{get;set;}
	public String removeSeriesId{get;set;}

	public JEOLAsia_AddSharingRuleCtrl(ApexPages.StandardController stdController) {
		seriesList = new List<MemberData>();
		countryList = new List<MemberData>();
		data = new Sharing_Rule__c();
		Sharing_Rule__c temp = (Sharing_Rule__c) stdController.getRecord();
		if(temp != null){
			try{
				temp = [SELECT Country_Group__c, Select_All_Countries__c, Select_All_Series__c, Series_Group__c, User__c FROM Sharing_Rule__c WHERE Id = :temp.Id LIMIT 1];
				data.Country_Group__c = temp.Country_Group__c;
				data.Select_All_Countries__c = temp.Select_All_Countries__c;
				data.Select_All_Series__c = temp.Select_All_Series__c;
				data.Series_Group__c = temp.Series_Group__c;
				data.User__c = temp.User__c;
			} catch(Exception ex){}
		}
	}

	public PageReference getSaveResult(Boolean isCreateNew){
		try{
			if(data.Country_Group__c == null && !data.Select_All_Countries__c && countryList.size() == 0){
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select at least 1 country');
        		ApexPages.addMessage(msg);
        		return null;
			} else if(data.Series_Group__c == null && !data.Select_All_Series__c && seriesList.size() == 0){
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select at least 1 series');
        		ApexPages.addMessage(msg);
        		return null;
			}
    		insert data;
    		List<Member_Data__c> memberData = new List<Member_Data__c>();

    		for(Integer i = 0; i<countryList.size(); i++){
    			Member_Data__c member = new Member_Data__c();
    			member.Country_For_Sharing_Rule__c = data.Id;
    			member.Master_Country__c = countryList[i].id;
    			memberData.add(member);
    		}

    		for(Integer i = 0; i<seriesList.size(); i++){
    			Member_Data__c member = new Member_Data__c();
    			member.Series_For_Sharing_Rule__c = data.Id;
    			member.Master_Series__c = seriesList[i].id;
    			memberData.add(member);
    		}
    		insert memberData;

    	} catch(Exception ex){
    		ApexPages.addMessages(ex);
    		return null;
    	}

    	PageReference pg;
    	if(isCreateNew){
    		pg = Page.JEOLAsia_AddSharingRulePage;
    	} else {
    		pg = new PageReference('/' + data.Id);
    	}
    	pg.setRedirect(true);
        return pg; 
	}

	public PageReference SaveNew(){
		return getSaveResult(true);
	}

	public PageReference Save(){
		return getSaveResult(false);
	}

	public void selectAllCountry(){
		/*if(data.Select_All_Countries__c){
			data.Country_Group__c = null;
		}*/
	}

	public void selectAllSeries(){
		/*if(data.Select_All_Series__c){
			data.Series_Group__c = null;
		}*/
	}

	public void addCountry(){
		MemberData member = new MemberData();
		member.id = data.Country_Technique__c;
		data.Country_Technique__c = null;
		SelectListManage__c record = [SELECT Label__c FROM SelectListManage__c WHERE Id = :member.id];
		member.label = record.Label__c;
		countryList.add(member);
	}

	public void removeCountry(){
		for(Integer i = 0; i < countryList.size(); i++){
			if(countryList[i].id == removeCountryId){
				countryList.remove(i);
				break;
			}
		}
	}

	public void addSeries(){
		MemberData member = new MemberData();
		member.id = data.Series_Technique__c;
		data.Series_Technique__c = null;
		SelectListManage__c record = [SELECT Label__c FROM SelectListManage__c WHERE Id = :member.id];
		member.label = record.Label__c;
		seriesList.add(member);
	}

	public void removeSeries(){
		for(Integer i = 0; i < seriesList.size(); i++){
			if(seriesList[i].id == removeSeriesId){
				seriesList.remove(i);
				break;
			}
		}
	}

	public class MemberData {
        public String id{get;set;}
        public String label{get;set;}
    }
}