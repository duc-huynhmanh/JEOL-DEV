@IsTest
private class JEOL_QuotationDetailRedirect_ctrlTest {

    private static testMethod void test01() {
        
        QuotationInformation__c quot = new QuotationInformation__c();
        insert quot;
        
        QuotationDetailInformation__c quotdet = new QuotationDetailInformation__c();
        quotdet.Parent__r = quot;
        quotdet.Parent__c = quot.id;
        quotdet.Depth__c = 1;
        quotdet.SortNo__c = 0;
        insert quotdet;

        Pagereference ref = Page.JEOL_QuotationEditorPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', quot.id);
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationDetailRedirect_ctrl ctrl = new JEOL_QuotationDetailRedirect_ctrl(new ApexPages.StandardController(quotdet));
        
        PageReference ret = ctrl.redirect();
    }

    private static testMethod void test02() {
        
        QuotationInformation__c quot = new QuotationInformation__c();
        insert quot;
        
        QuotationDetailInformation__c quotdet = new QuotationDetailInformation__c();
        quotdet.Parent__c = quot.id;
        quotdet.Depth__c = 1;
        quotdet.SortNo__c = 0;
        insert quotdet;

        Pagereference ref = Page.JEOL_QuotationEditorPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', quot.id);
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationDetailRedirect_ctrl ctrl = new JEOL_QuotationDetailRedirect_ctrl(new ApexPages.StandardController(quotdet));
        
        PageReference ret = ctrl.redirect();
    }
}