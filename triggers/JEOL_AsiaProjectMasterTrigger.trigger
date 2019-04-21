trigger JEOL_AsiaProjectMasterTrigger on AsiaProjectMaster__c (before insert, before update) {
	
    if (Trigger.isBefore && Trigger.isInsert) {
        for (AsiaProjectMaster__c data : Trigger.new) {
        	
        	//Create the LookUps
            UnitBody__c ub = [select Id from UnitBody__c where UnitBody__c= :data.UnitBody_GaibuID__c limit 1];
            data.UnitBody__c = ub.Id;
            ProductItem__c pi = [select Id from ProductItem__c where GaibuID__c= :data.ProductItem_GaibuID__c limit 1];
            data.ProductItem__c = pi.Id;
            Account ac = [select Id from Account where 	Code__c= :data.Account_GaibuID__c limit 1];
            data.Account__c = ac.Id;
            
        }    
    }
    
}