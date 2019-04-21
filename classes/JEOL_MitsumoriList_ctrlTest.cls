@IsTest
private class JEOL_MitsumoriList_ctrlTest {
    // 定数
    private static final String STATUS_OF_USE_ALL = 'all';  // 使用状況　すべて　value
    private static final String STATUS_OF_USE_USING = 'using';  // 使用状況　使用中　value

    // Cookei用定数
    private static final String COOKIE_LABEL_EIGYOTANTO_CODE = 'eigyoTantoCode';
    private static final String COOKIE_LABEL_EIGYOTANTO_NAME = 'eigyoTantoName';
    private static final String COOKIE_LABEL_HANBAISAKI_CODE = 'hanbaisakiCode';
    private static final String COOKIE_LABEL_HANBAISAKI_NAME = 'hanbaisakiName';
    private static final String COOKIE_LABEL_SHUKKASAKI_CODE = 'shukkasakiCode';
    private static final String COOKIE_LABEL_SHUKKASAKI_NAME = 'shukkasakiName';
    private static final String COOKIE_LABEL_KEIRETSU = 'keiretsu';
    private static final String COOKIE_LABEL_TIKI = 'tiki';
    private static final String COOKIE_LABEL_MITSUMORI_TYPE = 'mitsumoriType';
    private static final String COOKIE_LABEL_MITSUMORI_NO = 'mitsumoriNo';
    private static final String COOKIE_LABEL_KOKYAKU_MITSUMORI_NO = 'kMitsumoriNo';
    private static final String COOKIE_LABEL_SHOHIN_NAME = 'shohinName';
    private static final String COOKIE_LABEL_REGISTEREDDATE_FROM = 'RegisteredDateFrom';
    private static final String COOKIE_LABEL_REGISTEREDDATE_TO = 'RegisteredDateTo';
    private static final String COOKIE_LABEL_CUSTOMER_CATEGORY = 'customerCategory';
    private static final String COOKIE_LABEL_USER_NO = 'userNo';
    private static final String COOKIE_PATH = '/apex/JEOL_MitsumoriListPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_MitsumoriListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_MitsumoriList_ctrl ctrl = new JEOL_MitsumoriList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getQuotes();
        ctrl.getQuoteTypeOptions();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各取得用メソッド呼び出し
        ctrl.getCCategoryOptions();
        ctrl.getRegionOptions();
        ctrl.getSeriesOptions();

        // クリアメソッド呼び出し
        ctrl.doFormClear();

		ctrl.orderDesc = true;
        ctrl.eigyoTantoCode ='';
        ctrl.eigyoTantoName ='';
        ctrl.hanbaisakiCode ='';
        ctrl.hanbaisakiName ='';
        ctrl.shukkasakiCode ='';
        ctrl.shukkasakiName ='';
        ctrl.customerCategory ='';
        ctrl.keiretsu ='';
        ctrl.tiki ='';
        ctrl.mitsumoriType ='';
        ctrl.mitsumoriNo ='';
        ctrl.kMitsumoriNo ='';
        ctrl.shohinName ='';
        ctrl.userNo ='';
        ctrl.RegisteredDateFrom ='';
        ctrl.RegisteredDateTo ='';
        ctrl.customerCategory = 'testCCcode';
        ctrl.doSearch();
        ctrl.getQuotes();
		
        ctrl.eigyoTantoCode ='testETcd';
        ctrl.eigyoTantoName ='testETname';
        ctrl.hanbaisakiCode ='testCodeK';
        ctrl.hanbaisakiName ='testNameK';
        ctrl.shukkasakiCode ='testCodeN';
        ctrl.shukkasakiName ='testNameN';
        ctrl.customerCategory ='testCCcodetest';
        ctrl.keiretsu ='testKT';
        ctrl.tiki ='testTK';
        ctrl.mitsumoriType ='testMtype';
        ctrl.mitsumoriNo ='testMno';
        ctrl.kMitsumoriNo ='testKMno';
        ctrl.shohinName ='testSname';
        ctrl.userNo ='testUserNo';
        ctrl.RegisteredDateFrom ='1900/01/01';
        ctrl.RegisteredDateTo ='3999/12/31';
        ctrl.doSearch();
        ctrl.doFormClear();

        ctrl.RegisteredDateFrom = 'aaa';
        ctrl.RegisteredDateTo = 'bbb';
        ctrl.doSearch();
        ctrl.doFormClear();
    }

    // クッキー生成処理（画面起動時検索フラグON）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABEL_EIGYOTANTO_CODE, 'testETcd', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_EIGYOTANTO_NAME, 'testETname', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_HANBAISAKI_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_HANBAISAKI_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHUKKASAKI_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHUKKASAKI_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_KEIRETSU, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_TIKI, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_MITSUMORI_TYPE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_MITSUMORI_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_KOKYAKU_MITSUMORI_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHOHIN_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_FROM, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_TO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_USER_NO, 'testUserNo', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMER_CATEGORY, 'testCCcode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成
    private static void testData(){

        // 取引先（見積．契約先）
        Account accK = new Account();
        accK.Name = 'testNameK';
        accK.Code__c = 'testCodeK';
        accK.NameUpToKana__c = 'testNameHankakuK';
        accK.serviceArea__c = 'testServiceAreaK';
        accK.State__c = '東京都';
        accK.CountryCode__c = 'JPN';
        insert accK;

        // 取引先（見積．納入先）
        Account accN = new Account();
        accN.Name = 'testNameN';
        accN.Code__c = 'testCodeN';
        accN.NameUpToKana__c = 'testNameHankakuN';
        accN.serviceArea__c = 'testServiceAreaN';
        accN.State__c = '東京都';
        accN.CountryCode__c = 'JPN';
        insert accN;

        // 受注予定
        OrderPlan__c op = new OrderPlan__c();
        op.Name = 'testOPname';
        insert op;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.Name = 'testSalesOrderNo';
        insert so;

        // 見積
        Quote__c qt = new Quote__c();
        qt.Name = 'testQTname';
        qt.EigyoTantoshaCode__c = 'testETcd';
        qt.EigyoTantoshaName__c = 'testETname';
        qt.Keiyakusaki__c = accK.Id;
        qt.Nonyusaki__c = accN.Id;
        qt.OrderPlan__c = op.Id;
        qt.SalesOrder__c = so.Id;
        insert qt;

        // 取引先カテゴリ
        Category__c cc = new Category__c();
        cc.Name = 'testCCname';
        cc.Code__c = 'testCCcode';
        insert cc;

        // 取引先カテゴリジャンクション
        CategoryJunction__c ccj = new CategoryJunction__c();
        ccj.CategoryName__c = cc.Id;
        ccj.Account__c = accK.Id;  // 契約先のほうを登録
        insert ccj;
    }

}