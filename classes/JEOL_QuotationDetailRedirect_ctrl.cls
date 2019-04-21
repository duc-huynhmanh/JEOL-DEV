public with sharing class JEOL_QuotationDetailRedirect_ctrl {

    String sParentID = null;
    
    public JEOL_QuotationDetailRedirect_ctrl(ApexPages.StandardController stdController) {
    
        if(!Test.isRunningTest()) {
            stdController.addFields(new List<String>{'Parent__r'});
        }
        QuotationDetailInformation__c quotDet = (QuotationDetailInformation__c) stdController.getRecord();
        If (quotDet != null && quotDet.id != null && quotDet.Parent__r != null) {
            sParentID = '' + quotDet.Parent__r.id;
        }
    
    }
    
    public PageReference redirect(){
        if(sParentID != null){
            PageReference pageRef = new PageReference('/apex/JEOL_QuotationEditorPage');
            pageRef.getParameters().put('id', sParentID);
            return pageRef;
        } else {
            return null;
        }
    }
    
}