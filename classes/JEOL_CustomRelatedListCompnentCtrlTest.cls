@IsTest
private class JEOL_CustomRelatedListCompnentCtrlTest {

    private static testMethod void test01() {
        
        Account acc = new account();
        acc.Name = 'dummy';
        acc.Code__c = '12345';
        insert acc;
        
        Pagereference ref = Page.JEOL_CustomRelatedListAllRecordViewPage;
        Map<String, String> params = new Map<String, String>();
        params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_SOBJECT, 'Contact');
        params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_FIELD, 'id');
        params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_ID, acc.id);
        params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_RELATIONSHIP, 'Account');
        params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_SORT_TYPE, '-1');
        params.put(JEOL_CustomRelatedListAllRecordViewCtrl.URL_PARAM_START, '1');
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);

        JEOL_CustomRelatedListCompnentCtrl ctrl = new JEOL_CustomRelatedListCompnentCtrl();
        List<string> lsStr = new List<String>();
        lsStr.add('id');
        JEOL_CustomRelatedListCompnentCtrl.CustomRelatedListCtrl cls = new JEOL_CustomRelatedListCompnentCtrl.CustomRelatedListCtrl('Contact', lsStr, '' + acc.id, 'Account');
        
        List<Sobject> ret1 = cls.getRecords();
        Integer ret2 = cls.getResultSize();
        cls.AddViewSize();
        Integer ret3 = cls.getCurrentViewSize();
        Pagereference ret4 = cls.getAllRecordViewUrl();
        cls.viewId = 'dummy';
        cls.title = 'dummy';
        
        JEOL_CustomRelatedListCompnentCtrl.CustomRelatedListCtrl crlc = ctrl.getRelatedListCtrl();
        ctrl.isEdit = true;
        
    }

}