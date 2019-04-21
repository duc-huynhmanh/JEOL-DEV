@IsTest
private class JEOL_JyuchuYoteiList_ctrlTest {
    // 定数
    private static final String STATUS_OF_USE_ALL = 'all';  // 使用状況　すべて　value
    private static final String STATUS_OF_USE_USING = 'using';  // 使用状況　使用中　value

    // Cookei用定数
    private static final String COOKIE_LABLE_EIGYOTANTOSHA_CODE = 'eigyoTantoshaCode';
    private static final String COOKIE_LABLE_EIGYOTANTOSHA_NAME = 'eigyoTantoshaName';
    private static final String COOKIE_LABLE_CUSTOMER_CODE = 'customerCode';
    private static final String COOKIE_LABLE_CUSTOMER_NAME = 'customerName';
    private static final String COOKIE_LABLE_CUSTOMER_CATEGORY = 'customerCategory';
    private static final String COOKIE_LABLE_SERIES = 'series';
    private static final String COOKIE_LABLE_REGION = 'region';
    private static final String COOKIE_LABLE_SHOHIN_NAME = 'shohinName';
    private static final String COOKIE_LABLE_JUTYU_YEAR_FROM = 'jutyuyoteiYearFrom';
    private static final String COOKIE_LABLE_JUTYU_YEAR_TO = 'jutyuyoteiYearTo';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOL_JyuchuYoteiListPage';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_JyuchuYoteiListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_JyuchuYoteiList_ctrl ctrl = new JEOL_JyuchuYoteiList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getSalesPipelines();
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

        ctrl.jutyuyoteiYearFrom = 'aaa';
        ctrl.jutyuyoteiYearTo = 'bbb';
        ctrl.doSearch();
        ctrl.doFormClear();

        ctrl.orderDesc = true;
        ctrl.customerCategory = 'testCCcode';
        ctrl.doSearch();
        ctrl.doFormClear();

        ctrl.eigyoTantoshaCode = 'testETcode';
        ctrl.eigyoTantoshaName = 'testETname';
        ctrl.customerCode = 'testCcode';
        ctrl.customerName = 'testCname';
        ctrl.series = 'testSeries';
        ctrl.region = 'testRegion';
        ctrl.shohinName = 'testShohinName';
        ctrl.jutyuyoteiYearFrom = '1000';
        ctrl.jutyuyoteiYearTo = '9999';
        ctrl.customerCategory = 'testCCcodetest';
        ctrl.doSearch();
        ctrl.doFormClear();

    }

    // クッキー生成処理（画面起動時検索フラグON）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABLE_EIGYOTANTOSHA_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_EIGYOTANTOSHA_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_CUSTOMER_CODE, 'testCode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_CUSTOMER_NAME, 'testName', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_CUSTOMER_CATEGORY, 'testCCcode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_SERIES, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_REGION, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_SHOHIN_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_JUTYU_YEAR_FROM, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_JUTYU_YEAR_TO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成
    private static void testData(){

        // 取引先（受注予定．顧客名称）
        Account acc = new Account();
        acc.Name = 'testName';
        acc.Code__c = 'testCode';
        acc.NameUpToKana__c = 'testNameHankaku';
        acc.serviceArea__c = 'testServiceArea';
        acc.State__c = '東京都';
        acc.CountryCode__c = 'JPN';
        insert acc;

        // 見積
        Quote__c qt = new Quote__c();
        qt.Name = 'testQTname';
        insert qt;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.Name = 'testSalesOrderNo';
        insert so;

        // 受注予定
        OrderPlan__c op = new OrderPlan__c();
        op.Name = 'testOPname';
        op.CustomerAccount__c = acc.Id;
        op.Quote__c = qt.Id;
        op.SalesOrder__c = so.Id;
        insert op;

        // 取引先カテゴリ
        Category__c cc = new Category__c();
        cc.Name = 'testCCname';
        cc.Code__c = 'testCCcode';
        insert cc;

        // 取引先カテゴリジャンクション
        CategoryJunction__c ccj = new CategoryJunction__c();
        ccj.CategoryName__c = cc.Id;
        ccj.Account__c = acc.Id;
        insert ccj;

    }

}