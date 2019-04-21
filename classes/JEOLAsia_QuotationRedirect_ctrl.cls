public with sharing class JEOLAsia_QuotationRedirect_ctrl {

    public JEOLAsia_QuotationRedirect_ctrl(ApexPages.StandardController stdController) {
    }
    
    public PageReference redirect(){
        String sID = ApexPages.currentPage().getParameters().get('id');
        if(sID != null){
            PageReference pageRef = new PageReference('/apex/JEOLAsia_ProfitCalculationEditorPage');
            pageRef.getParameters().put('id', sID);
            return pageRef;
        } else {
            PageReference pageRef = new PageReference('/apex/JEOLAsia_ProfitCalculationEditorPage');
            return pageRef;
        }
    }
    
}