trigger JEOL_ProductItem_BeforeUpsertTrigger on ProductItem__c (Before Insert, Before Update) {

    List<Profile> lsProf = [SELECT Id FROM Profile WHERE Id = :userinfo.getProfileId() AND Name = 'Asia User'];
    
    if (lsProf != NULL && lsProf.size() > 0) {
        for (ProductItem__c salesPL : Trigger.new) {
            salesPL.ProductItemType__c = '2';    
        }
    }

    for (ProductItem__c salesPL : Trigger.new) {
        if (salesPL.ProductItemType__c == '2') {
            salesPL.EnglishName__c = salesPL.Name;            	
        } 
    }
    
}