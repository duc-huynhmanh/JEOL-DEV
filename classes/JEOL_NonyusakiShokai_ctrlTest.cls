@IsTest
private class JEOL_NonyusakiShokai_ctrlTest {

    // 販売オーダ指定なし
    private static testMethod void test01() {
        Test.starttest();
        PageReference testPage = Page.JEOL_NonyusakiShokaiPage;
        testPage.getParameters().put('id', '');
        Test.setCurrentPage(testPage);
        
        Apexpages.Standardcontroller stdCtrl = new Apexpages.Standardcontroller(new UnitBody__c());
        JEOL_NonyusakiShokai_ctrl ctrl = new JEOL_NonyusakiShokai_ctrl(stdCtrl);
        Test.stoptest();
    }

    // 販売オーダ該当なし
    private static testMethod void test02() {
        Test.starttest();

        PageReference testPage = Page.JEOL_NonyusakiShokaiPage;
        testPage.getParameters().put('id', '');
        Test.setCurrentPage(testPage);

        Apexpages.Standardcontroller stdCtrl = new Apexpages.Standardcontroller(new UnitBody__c());
        JEOL_NonyusakiShokai_ctrl ctrl = new JEOL_NonyusakiShokai_ctrl(stdCtrl);
        Test.stoptest();
    }

    // 販売オーダ該当あり
    private static testMethod void test03() {
        Test.starttest();

        String salesOrderId = testData();

        PageReference testPage = Page.JEOL_NonyusakiShokaiPage;
        testPage.getParameters().put('id', salesOrderId);
        Test.setCurrentPage(testPage);

        Apexpages.Standardcontroller stdCtrl = new Apexpages.Standardcontroller(new UnitBody__c());
        JEOL_NonyusakiShokai_ctrl ctrl = new JEOL_NonyusakiShokai_ctrl(stdCtrl);
//        ctrl.getSalesOrderNo();
        List<JEOL_NonyusakiShokai_ctrl.PartsItem> parts = ctrl.getPartsItems();
        if (parts.size() > 0) {
            parts.get(0).getModelText();
        }
        Test.stoptest();
    }

    //テストデータ作成
    private static String testData() {

        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'K999999';
        insert pi;

        // シリアル番号付品目
        UnitBody__c ub = new UnitBody__c();
        ub.ItemLink__c = pi.Id;
        ub.Name = 'testSNPIname';
        ub.SerialNo__c = 'testシリアル番号_00001';
        ub.UnitBody__c = 'test本体号機';
        insert ub;
        
        Component__c comp = new Component__c();
        comp.UnitBody__c = ub.id;
        comp.ItemLink__c = pi.id;
        insert comp;

        // 販売オーダ（メイン情報）
        SalesOrder__c so = new SalesOrder__c();
        so.UnitBodyLink__c = ub.Id;
        so.Name = 'testSO';
        insert so;

        return ub.Id;
    }

}