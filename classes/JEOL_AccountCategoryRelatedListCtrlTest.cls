@IsTest
private class JEOL_AccountCategoryRelatedListCtrlTest {

    private static testMethod void test01() {

        JEOL_AccountCategoryRelatedListCtrl ctrl = new JEOL_AccountCategoryRelatedListCtrl();

        JEOL_AccountCategoryRelatedListCtrl.CustomRelatedListCtrl ret = ctrl.getRelatedListCtrl();
        List<Sobject> ret2 = ret.getRecords();
        integer ret3 = ret.getResultSize();
        ret.AddViewSize();
        integer ret4 = ret.getCurrentViewSize();
        ctrl.isEdit = true;
        ret.sobjectName = 'dummy';
        ret.viewID = 'dummy';
        ret.relationshipName = 'dummy';
        
    }

}