@IsTest
private class JEOL_QuotationRedirect_ctrlTest {

    private static testMethod void test01() {
        
        Account acc = new account();
        acc.Name = 'dummy';
        acc.Code__c = '12345';
        insert acc;

        Pagereference ref = Page.JEOL_QuotationEditorPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', acc.id);
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationRedirect_ctrl ctrl = new JEOL_QuotationRedirect_ctrl(new ApexPages.StandardController(acc));
        
        PageReference ret = ctrl.redirect();
    }

    private static testMethod void test02() {
        
        Account acc = new account();
        acc.Name = 'dummy';
        acc.Code__c = '12345';
        insert acc;

        Pagereference ref = Page.JEOL_QuotationEditorPage;                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationRedirect_ctrl ctrl = new JEOL_QuotationRedirect_ctrl(new ApexPages.StandardController(acc));
        
        PageReference ret = ctrl.redirect();
    }
}