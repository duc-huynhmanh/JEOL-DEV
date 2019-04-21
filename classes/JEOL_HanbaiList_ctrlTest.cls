@IsTest
private class JEOL_HanbaiList_ctrlTest {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_HanbaiListPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_HanbaiListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_HanbaiList_ctrl ctrl = new JEOL_HanbaiList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getSalesOrderList();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各値取得用メソッド呼び出し
        ctrl.getRegionOptions();
        ctrl.getOrderTypeOptions();
        ctrl.getSeriesOptions();
        ctrl.getOrgUnitOptions();
        ctrl.getCCategoryOptions();

        // クリアメソッド呼び出し
        ctrl.doFormClear();

	    // 全パラメータ指定
        ctrl.kigyoTani = 'testTani';
        ctrl.eTantoCode = 'testETcd';
        ctrl.eTantoName = 'testETname';
        ctrl.hanbaisakiCode = 'testACSLcd';
        ctrl.hanbaisakiNameHan = 'testACSLnameHan';
        ctrl.hanbaisakiName = 'testACSLname';
        ctrl.shukkasakiCode = 'testACSPcd';
        ctrl.shukkasakiNameHan = 'testACSPnameHan';
        ctrl.shukkasakiName = 'testACSPname';
        ctrl.customerCategory = 'testCCcode';
        ctrl.orderType = 'testOtype';
        ctrl.keiretsu = 'testKiretsu';
        ctrl.tiki = 'testTiki';
        ctrl.shohinName = 'testSname';
        ctrl.goki = 'testGoky';
        ctrl.Search1();

	    // 取引先カテゴリ検索時'where'生成用
        ctrl.kigyoTani = '';
        ctrl.eTantoCode = '';
        ctrl.eTantoName = '';
        ctrl.hanbaisakiCode = '';
        ctrl.hanbaisakiNameHan = '';
        ctrl.hanbaisakiName = '';
        ctrl.shukkasakiCode = '';
        ctrl.shukkasakiNameHan = '';
        ctrl.shukkasakiName = '';
        ctrl.customerCategory = 'testCCcode';
        ctrl.orderType = '';
        ctrl.keiretsu = '';
        ctrl.tiki = '';
        ctrl.shohinName = '';
        ctrl.goki = '';
        ctrl.Search1();
    }

    // クッキー生成処理（画面起動時検索フラグON、一部条件指定）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie('kigyoTani', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('eTantoCode', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('eTantoName', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiCode', 'testACCSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiNameHan', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiName', 'testACNSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiCode', 'testACCSP', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiNameHan', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiName', 'testACNSP', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerCategory', 'testCCcode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('orderType', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('keiretsu', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('tiki', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shohinName', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('goki', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('isExcludePartsSupply', 'true', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成
    private static void testData(){
        
        //品目
        ProductItem__c pItem = new ProductItem__c();
        pItem.name = 'SalsOrderTest';
        pItem.Meka__c = 'testMeka';
        pItem.Model__c = 'mTest';
        pItem.Kikaku__c = 'kTest';
        pItem.Series__c = 'NM';
        pItem.ZaikoKanriKubun__c = 'zTest';
        pItem.ShireSakiCode__c = 'ssc';
        pItem.ShukkaStatusName__c = 'ssnTestName';
        pItem.ShiyoKishu__c ='skTest';
        pItem.Soko__c = 'sTest';
        pItem.Tani__c = 'kg';
        pItem.HyozyunNoki__c = 9999.99;
        pItem.HalfTextName__c = 'ﾃｽﾄ';
        pItem.JapaneseName__c = 'テスト';
        pItem.EnglishName__c = 'test';
        pItem.GaibuID__c = 'T999999999';
        insert pItem;
        
        SerialNoProductItem__c snpItem = new SerialNoProductItem__c();
        snpItem.itemLink__c = pItem.id;
        snpItem.SerialNo__c = 'test' + pItem.id;
        insert snpItem;
        
        // 販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACNSL';
        accSL.Code__c = 'testACCSL';
        insert accSL;

        // 請求先取引先
        Account accSEL = new Account();
        accSEL.Name = 'testSEL';
        accSEL.Code__c = 'testSEL';
        insert accSEL;

        // 出荷先取引先
        Account accSP = new Account();
        accSP.Name = 'testACNSP';
        accSP.Code__c = 'testACCSP';
        insert accSP;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.SerialNoItemLink__c = snpItem.id;
        so.Name = 'testSOname';
        so.SalesAccount__c = accSL.Id;
        so.ShipmentAccount__c = accSP.Id;
        insert so;

        SalesResult__c res = new SalesResult__c();
        res.name = 'testResult';
        res.SalesOrder__c = so.id;
        res.shukkasaki__c = accSP.id;
        res.seikyusaki__c = accSEL.id;
        res.hanbaisaki__c = accSL.id;
        insert res;
        update so;
        update res;

        // 取引先カテゴリ
        Category__c cc = new Category__c();
        cc.Name = 'testCCname';
        cc.Code__c = 'testCCcode';
        insert cc;

        // 取引先カテゴリジャンクション
        CategoryJunction__c ccj = new CategoryJunction__c();
        ccj.CategoryName__c = cc.Id;
        ccj.Account__c = accSL.Id;  // 販売先取引先のほうを紐づけ
        insert ccj;

        SelectListManage__c slm = new SelectListManage__c();
        slm.name = 'オーダタイプ';
        slm.referenceName__c = JEOLUtil.REFERENCE_NAME_SALES_ORDER_TYPE;
        slm.value__c = 'testType';
        slm.label__c = 'testType';
        slm.sortNo__c = '1';
        insert slm;

        slm = new SelectListManage__c();
        slm.name = '企業単位';
        slm.referenceName__c = JEOLUtil.REFERENCE_NAME_ORG_UNIT;
        slm.value__c = 'j';
        slm.label__c = 'j';
        slm.sortNo__c = '1';
        insert slm;
    }

}