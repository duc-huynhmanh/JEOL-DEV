public with sharing class JEOLAsia_MaintenanceAccountBookRed_ctrl {
	String sParentID = null;
    public JEOLAsia_MaintenanceAccountBookRed_ctrl(ApexPages.StandardController stdController) {
		if(!Test.isRunningTest()) {
            stdController.addFields(new List<String>{'MaintenanceContractManagement__r'});
        }
        AsiaMaintenanceAccountBook__c accBk = (AsiaMaintenanceAccountBook__c) stdController.getRecord();
        If (accBk != null && accBk.id != null && accBk.MaintenanceContractManagement__r != null) {
            sParentID = '' + accBk.MaintenanceContractManagement__r.id;
        }
	}

    public PageReference redirect(){
        if(sParentID != null){
            PageReference pageRef = new PageReference('/apex/JEOLAsia_MaintenanceAccountBook');
            pageRef.getParameters().put('id', sParentID);
            return pageRef;

        } else {
            return null;
        }
    }
}