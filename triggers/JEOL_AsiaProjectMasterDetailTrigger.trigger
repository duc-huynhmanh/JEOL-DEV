trigger JEOL_AsiaProjectMasterDetailTrigger on AsiaProjectMasterDetail__c (before insert, before update) {
    
    if (Trigger.isBefore && Trigger.isInsert) {
        for (AsiaProjectMasterDetail__c data : Trigger.new) {
        	
        	//Create the lookUps for Category A AsiaProjectMasterDetail
        	if (data.Category__c == 'A') {
	            Component__c cp = [select Id from Component__c where ComponentManageId__c= :data.Component_GaibuID__c limit 1];
	            data.Component__c = cp.Id;
	            ProductItem__c pi = [select Id from ProductItem__c where GaibuID__c= :data.ProductItem_GaibuID__c limit 1];
	            data.ProductItem__c = pi.Id;
	            SalesOrderLine__c sol = [select Id from SalesOrderLine__c where SalesOrderLineNo_Sync__c= :data.SalesOrderLine_GaibuID__c limit 1];
	            data.SalesOrderLine__c = sol.Id;
        	}
            
            //From old Trigger wrongly named JEOL_AsiaProjectMasterTriger
            if (Trigger.isBefore && Trigger.isInsert) {
	            if (data.Category__c == 'C') {
	                data.QuantityUpdatedDatetime__c = Datetime.Now();
	            }
            }
        }    
    }
    
}