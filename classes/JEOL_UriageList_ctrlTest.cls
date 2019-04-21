@IsTest
private class JEOL_UriageList_ctrlTest {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_UriageListPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';         // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';             // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_UriageListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_UriageList_ctrl ctrl = new JEOL_UriageList_ctrl();

        // 検索（年度from～年度Toのand句生成、取引先カテゴリand句生成）
        ctrl.search();
        ctrl.getCCategoryOptions();
        ctrl.getDepartmentOptions();
        ctrl.getSeriesOptions();
        ctrl.getOrgUnitOptions();

        JEOL_UriageList_ctrl.SalesResultDetail detail = ctrl.getSalesResult().get(0);
        detail.getEncNendoResultUrl();
        detail.getEncBumonResultUrl();
        detail.getEncTaniResultUrl();
        detail.getParametrs();
        detail.getEncKeiretsuResultUrl();
        detail.setParametrs('testParam', 'param1');
        // クリアメソッド呼び出し
        ctrl.doFormClear();
        
        ctrl.getSalesResult();

        ctrl.customerCategory = '顧客カテゴリ TESTCLASS';
        ctrl.search();

        //年度のエラーチェック
        ctrl.kigyoTani = '企業単位 TESTCLASS';
        ctrl.bumon = '部門 TESTCLASS';
        ctrl.keiretsu = '系列 TESTCLASS';
        ctrl.nendoFrom = null;
        ctrl.nendoTo = '2999';
        ctrl.search();
        ctrl.nendoFrom = null;
        ctrl.nendoTo = '年度TO TESTCLASS';
        ctrl.search();
        ctrl.nendoFrom = '2999';
        ctrl.nendoTo = null;
        ctrl.search();
        ctrl.nendoFrom = '年度FROM TESTCLASS';
        ctrl.nendoTo = null;
        ctrl.search();
        ctrl.nendoFrom = '2999';
        ctrl.nendoTo = '2999';
        ctrl.search();
        ctrl.nendoFrom = '年度FROM TESTCLASS';
        ctrl.nendoTo = '年度To TESTCLASS';
        ctrl.search();
    }


    // クッキー生成処理（画面起動時検索フラグON）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie('kigyoTani', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiCode', 'testHNcd', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiName', 'testHNname', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiCode', 'testSHcd', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiName', 'testSHname', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('seikyusakiCode', 'testSEcd', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('seikyusakiName', 'testSEname', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerCategory', 'testCCcode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('bumon', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('keiretsu', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('nendoFrom', '1000', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('nendoTo', '9999', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        Apexpages.currentPage().setCookies(cookies);
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

        // 売上（１：自社品：ベースと年度違い）
        SalesResult__c sr12 = new SalesResult__c();
        sr12.Name = 'testSRname12';
        sr12.hanbaisaki__c = accHN.Id;
        sr12.shukkasaki__c = accSH.Id;
        sr12.seikyusaki__c = accSE.Id;
        sr12.kigyoTani__c = 'testT1';
        sr12.uriageNendo__c = '8889';
        sr12.bumon__c = 'tst';
        sr12.keiretsu__c = 'testKR';
        sr12.SalesForeign__c = 50000;
        sr12.JishaTasha__c = '自社品';
        insert sr12;

        // 売上（１：自社品：ベースと企業単位違い）
        SalesResult__c sr13 = new SalesResult__c();
        sr13.Name = 'testSRname13';
        sr13.hanbaisaki__c = accHN.Id;
        sr13.shukkasaki__c = accSH.Id;
        sr13.seikyusaki__c = accSE.Id;
        sr13.kigyoTani__c = 'testT2';
        sr13.uriageNendo__c = '8888';
        sr13.bumon__c = 'tst';
        sr13.keiretsu__c = 'testKR';
        sr13.SalesForeign__c = 50000;
        sr13.JishaTasha__c = '自社品';
        insert sr13;

        // 売上（１：自社品：ベースと部門違い）
        SalesResult__c sr14 = new SalesResult__c();
        sr14.Name = 'testSRname14';
        sr14.hanbaisaki__c = accHN.Id;
        sr14.shukkasaki__c = accSH.Id;
        sr14.seikyusaki__c = accSE.Id;
        sr14.kigyoTani__c = 'testT1';
        sr14.uriageNendo__c = '8888';
        sr14.bumon__c = 'ts2';
        sr14.keiretsu__c = 'testKR';
        sr14.SalesForeign__c = 50000;
        sr14.JishaTasha__c = '自社品';
        insert sr14;

        // 売上（２：他社品）
        SalesResult__c sr21 = new SalesResult__c();
        sr21.Name = 'testSRname21';
        sr21.hanbaisaki__c = accHN.Id;
        sr21.shukkasaki__c = accSH.Id;
        sr21.seikyusaki__c = accSE.Id;
        sr21.kigyoTani__c = 'testT1';
        sr21.uriageNendo__c = '8888';
        sr21.bumon__c = 'tst';
        sr21.keiretsu__c = 'testKR';
        sr21.SalesForeign__c = 20000;
        sr21.JishaTasha__c = '他社品';
        insert sr21;

        // 売上（３：SVC）
        SalesResult__c sr31 = new SalesResult__c();
        sr31.Name = 'testSRname31';
        sr31.hanbaisaki__c = accHN.Id;
        sr31.shukkasaki__c = accSH.Id;
        sr31.seikyusaki__c = accSE.Id;
        sr31.kigyoTani__c = 'testT1';
        sr31.uriageNendo__c = '8888';
        sr31.bumon__c = 'tst';
        sr31.keiretsu__c = 'testKR';
        sr31.SalesForeign__c = 30000;
        sr31.JishaTasha__c = 'SVC';
        insert sr31;

        // 売上（４：EF）
        SalesResult__c sr41 = new SalesResult__c();
        sr41.Name = 'testSRname41';
        sr41.hanbaisaki__c = accHN.Id;
        sr41.shukkasaki__c = accSH.Id;
        sr41.seikyusaki__c = accSE.Id;
        sr41.kigyoTani__c = 'testT1';
        sr41.uriageNendo__c = '8888';
        sr41.bumon__c = 'tst';
        sr41.keiretsu__c = 'testKR';
        sr41.SalesForeign__c = 40000;
        sr41.JishaTasha__c = 'EF';
        insert sr41;

        // 売上（５：口銭）
        SalesResult__c sr51 = new SalesResult__c();
        sr51.Name = 'testSRname51';
        sr51.hanbaisaki__c = accHN.Id;
        sr51.shukkasaki__c = accSH.Id;
        sr51.seikyusaki__c = accSE.Id;
        sr51.kigyoTani__c = 'testT1';
        sr51.uriageNendo__c = '8888';
        sr51.bumon__c = 'tst';
        sr51.keiretsu__c = 'testKR';
        sr51.SalesForeign__c = 50000;
        sr51.JishaTasha__c = '口銭';
        insert sr51;
    }

}