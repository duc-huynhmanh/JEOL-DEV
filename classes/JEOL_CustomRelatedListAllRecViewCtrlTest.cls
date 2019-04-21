@IsTest
private class JEOL_CustomRelatedListAllRecViewCtrlTest {

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

        JEOL_CustomRelatedListAllRecordViewCtrl ctrl = new JEOL_CustomRelatedListAllRecordViewCtrl();
        ctrl.getListSobjectName();
        ctrl.pageNext();
        ctrl.pagePrev();
        ctrl.sortAction();
        
    }

}