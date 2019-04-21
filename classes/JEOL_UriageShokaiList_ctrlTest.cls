@IsTest
private class JEOL_UriageShokaiList_ctrlTest {

    // 検索（企業単位）、検索結果取得、各メソッド呼び出し
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_UriageShokaiListPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        System.currentPageReference().getParameters().put('kigyoTani','testT1');
        System.currentPageReference().getParameters().put('bumon','');
        System.currentPageReference().getParameters().put('keiretsu','');
        System.currentPageReference().getParameters().put('nendo','');
        System.currentPageReference().getParameters().put('hanbaisakiCode','testHNcd');
        System.currentPageReference().getParameters().put('hanbaisakiName','testHNname');
        System.currentPageReference().getParameters().put('shukkasakiCode','testSHcd');
        System.currentPageReference().getParameters().put('shukkasakiName','testSHname');
        System.currentPageReference().getParameters().put('seikyusakiCode','testSEcd');
        System.currentPageReference().getParameters().put('seikyusakiName','testSEname');
        System.currentPageReference().getParameters().put('customerCategory','testCCcode');

        JEOL_UriageShokaiList_ctrl ctrl = new JEOL_UriageShokaiList_ctrl();
        ctrl.changeOrder();
        List<JEOL_UriageShokaiList_ctrl.RowWrapper> wraps = ctrl.getSalesResult();
        if (!wraps.isEmpty()) {
            wraps.get(0).getUrl();
        }
        
    }

    // 検索（部門）
    private static testMethod void test02() {

        PageReference testPage = Page.JEOL_UriageShokaiListPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        System.currentPageReference().getParameters().put('bumon','tst');

        JEOL_UriageShokaiList_ctrl ctrl = new JEOL_UriageShokaiList_ctrl();
    }

    // 検索（系列）
    private static testMethod void test03() {

        PageReference testPage = Page.JEOL_UriageShokaiListPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        System.currentPageReference().getParameters().put('keiretsu','testKR');

        JEOL_UriageShokaiList_ctrl ctrl = new JEOL_UriageShokaiList_ctrl();
    }

    // 検索（年度）
    private static testMethod void test04() {

        PageReference testPage = Page.JEOL_UriageShokaiListPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        System.currentPageReference().getParameters().put('nendo','8888');

        JEOL_UriageShokaiList_ctrl ctrl = new JEOL_UriageShokaiList_ctrl();
    }

    // 検索（取引先カテゴリwhere句生成）
    private static testMethod void test05() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_UriageShokaiListPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        System.currentPageReference().getParameters().put('customerCategory','testCCcode');

        JEOL_UriageShokaiList_ctrl ctrl = new JEOL_UriageShokaiList_ctrl();
    }

    // 検索（addEqualCriteriaのwhere句作成、取引先カテゴリ該当なし）
    private static testMethod void test06() {

        // テストデータ作成
        testData();

        PageReference testPage = Page.JEOL_UriageShokaiListPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        System.currentPageReference().getParameters().put('hanbaisakiCode','testHNcd');
        System.currentPageReference().getParameters().put('customerCategory','testCCcodetest');

        JEOL_UriageShokaiList_ctrl ctrl = new JEOL_UriageShokaiList_ctrl();
    }

    // 検索（addLikeCriteriaのwhere句作成）
    private static testMethod void test07() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_UriageShokaiListPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        System.currentPageReference().getParameters().put('hanbaisakiName','testHNname');

        JEOL_UriageShokaiList_ctrl ctrl = new JEOL_UriageShokaiList_ctrl();
    }

    // テストデータ作成
    private static void testData(){
        // 販売先取引先
        Account accHN = new Account();
        accHN.Name = 'testHNname';
        accHN.Code__c = 'testHNcd';
        insert accHN;

        // 出荷先取引先
        Account accSH = new Account();
        accSH.Name = 'testSHname';
        accSH.Code__c = 'testSHcd';
        insert accSH;

        // 請求先取引先
        Account accSE = new Account();
        accSE.Name = 'testSEname';
        accSE.Code__c = 'testSEcd';
        insert accSE;

        // 取引先カテゴリ
        Category__c cc = new Category__c();
        cc.Name = 'testCCname';
        cc.Code__c = 'testCCcode';
        insert cc;

        // 取引先カテゴリジャンクション
        CategoryJunction__c ccj = new CategoryJunction__c();
        ccj.CategoryName__c = cc.Id;
        ccj.Account__c = accHN.Id;  // 販売先取引先を登録
        insert ccj;

        // 売上（１：自社品：ベース）
        SalesResult__c sr11 = new SalesResult__c();
        sr11.Name = 'testSRname11';
        sr11.hanbaisaki__c = accHN.Id;
        sr11.shukkasaki__c = accSH.Id;
        sr11.seikyusaki__c = accSE.Id;
        sr11.kigyoTani__c = 'testT1';
        sr11.uriageNendo__c = '8888';
        sr11.bumon__c = 'tst';
        sr11.keiretsu__c = 'testKR';
        sr11.SalesForeign__c = 10000;
        sr11.JishaTasha__c = '自社品';
        insert sr11;
    }

}