public with sharing class JEOL_QuotationRedirect_ctrl {

    public JEOL_QuotationRedirect_ctrl(ApexPages.StandardController stdController) {
    }
    
    public PageReference redirect(){
        String sID = ApexPages.currentPage().getParameters().get('id');
        if(sID != null){
            PageReference pageRef = new PageReference('/apex/JEOL_QuotationEditorPage');
            pageRef.getParameters().put('id', sID);
            return pageRef;
        } else {
            PageReference pageRef = new PageReference('/apex/JEOL_QuotationEditorPage');
            return pageRef;
        }
    }
    
}