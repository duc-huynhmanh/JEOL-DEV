public with sharing class JEOLAsia_AddMemberDataCtrl {
	public Member_Data__c data{get;set;}
	public String addType{get;set;}
	public String objectType{get;set;}
	public String name{get;set;}
	public String parentId{get;set;}

	public JEOLAsia_AddMemberDataCtrl() {
		
	}
    
    public JEOLAsia_AddMemberDataCtrl(ApexPages.StandardController stdController) {
    	addType = Apexpages.currentPage().getParameters().get('addType');
    	data = new Member_Data__c();
    	switch on addType{
    		when '1'{ //add country from Sharing Rule
    			parentId = Apexpages.currentPage().getParameters().get('ruleid');
    			data.Country_For_Sharing_Rule__c = parentId;
    			objectType = 'Country';
    		}
    		when '2'{ //add country from Country Group
    			parentId = Apexpages.currentPage().getParameters().get('groupId');
    			data.Country_Group__c = parentId;
    			objectType = 'Country';
    		}
    		when '3'{ //add series from Sharing Rule
    			parentId = Apexpages.currentPage().getParameters().get('ruleid');
    			data.Series_For_Sharing_Rule__c = parentId;
    			objectType = 'Series';
    		}
    		when '4'{ //add series from Country Group
    			parentId = Apexpages.currentPage().getParameters().get('groupId');
    			data.Series_Group__c = parentId;
    			objectType = 'Series';
    		}
    	}
    	system.debug('addType: ' + addType);
    	system.debug('data: ' + data);
    }

    public void refreshName(){
    	String recordId;
    	switch on objectType{
    		when 'Country'{
    			recordId = data.Master_Country__c;
    		}
    		when 'Series'{
    			recordId = data.Master_Series__c;
    		}
    	}
    	if(!String.isBlank(recordId)){
    		SelectListManage__c record = [SELECT Label__c FROM SelectListManage__c WHERE Id = :recordId];
    		name = record.Label__c;
    	} else {
    		name = '';
    	}
    }

    public PageReference Save(){
    	try{
    		insert data;
    	} catch(Exception ex){
    		ApexPages.addMessages(ex);
    		return null;
    	}
    	PageReference pg = new PageReference('/' + parentId);
    	pg.setRedirect(true);
        return pg; 
    }

    public PageReference Cancel(){
    	PageReference pg = new PageReference('/' + parentId);
    	pg.setRedirect(true);
        return pg; 
    }
}