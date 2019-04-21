@IsTest
private class JEOL_NonyusakiList_ctrlTest {
    // 定数
    private static final String STATUS_OF_USE_ALL = 'all';  // 使用状況　すべて　value
    private static final String STATUS_OF_USE_USING = 'using';  // 使用状況　使用中　value

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_NonyusakiListPage';  // PATH
    private static final String COOKIE_LABEL_NONYUSAKI_NAME = 'nonyusakiName';  // 納入先名称
    private static final String COOKIE_LABEL_NONYUSAKI_NAME_H = 'nonyusakiNameHankaku';  // 納入先名称（半角）
    private static final String COOKIE_LABEL_NONUSAKI_CODE = 'nonyusakiCode';  // 納入先コード
    private static final String COOKIE_LABEL_SERIES_PI = 'seriesPI';  // 系列
    private static final String COOKIE_LABEL_SHIP_DATE_FROM = 'shipDateFrom';  // 出荷年月From
    private static final String COOKIE_LABEL_SHIP_DATE_TO = 'shipDateTo';  // 出荷年月To
    private static final String COOKIE_LABEL_MODEL_NAME_PI = 'modelNamePI';  // 機種名称
    private static final String COOKIE_LABEL_SALES_ORDER_NO = 'salesOrderNo';  // 販売オーダー番号
    private static final String COOKIE_LABEL_SERVICE_AREA_LIST = 'serviceAreaList';  // サービスエリア
    private static final String COOKIE_LABEL_STATE_LIST = 'stateList';  // 都道府県
    private static final String COOKIE_LABEL_UNIT_BODY = 'unitBody';  // 本体号機
    private static final String COOKIE_LABEL_COUNTRY_CODE = 'countryCode';  // 国コード（左側）
    private static final String COOKIE_LABEL_COUNTRY_CODE_NAME = 'countryCodeName';  // 国コード（右側）
    private static final String COOKIE_LABEL_STATUS_OF_USE = 'statusOfUse';  // 使用状況
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_NonyusakiListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_NonyusakiList_ctrl ctrl = new JEOL_NonyusakiList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getSerialNoProductItems();
        ctrl.getCountryOptions();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各メソッド呼び出し
        ctrl.getStatusOfUseOp();
        ctrl.getSeriesPIOptions();
        ctrl.getStateOptions();
        ctrl.getServiceAreaOptions();
        ctrl.doFormClear();

        ctrl.search();
        ctrl.getSerialNoProductItems();
        ctrl.orderBy = 'salesOrderNo';
        ctrl.getSerialNoProductItems();
        System.debug(ctrl.ssc.getResultSize());
        // 存在する国コードに対する国名称取得
        ctrl.countryCode  = 'JPN';

    }

    // 日付不正時エラー
    private static testMethod void test02() {
        Test.starttest();
        JEOL_NonyusakiList_ctrl ctrl = new JEOL_NonyusakiList_ctrl();

        ctrl.shipDateFrom = 'aaa';

        ctrl.search();
        Test.stoptest();
    }

    // 検索（出荷年月From指定、使用状況'使用中'）
    private static testMethod void test03(){
        Test.starttest();
        JEOL_NonyusakiList_ctrl ctrl = new JEOL_NonyusakiList_ctrl();

        ctrl.nonyusakiName = 'testName';
        ctrl.nonyusakiNameHankaku = 'testNameHankaku';
        ctrl.nonyusakiCode = 'testCode';
        ctrl.seriesPI = 'testSeriesPI';
        ctrl.shipDateFrom = '1900/01/01';
        ctrl.shipDateTo = '';
        ctrl.modelNamePI = 'testModelNamePI';
        ctrl.salesOrderNo = 'testSNo_01';
        ctrl.serviceAreaList = 'testServiceArea';
        ctrl.stateList = 'testState';
        ctrl.unitBody = 'testUnitBody';
        ctrl.countryCode = 'testCC';
        ctrl.statusOfUse = STATUS_OF_USE_USING;
        ctrl.search();

        Test.stoptest();
    }

    // 検索（出荷年月To指定、使用状況'すべて'）
    private static testMethod void test04(){
        Test.starttest();
        JEOL_NonyusakiList_ctrl ctrl = new JEOL_NonyusakiList_ctrl();

        ctrl.nonyusakiName = 'testName';
        ctrl.nonyusakiNameHankaku = 'testNameHankaku';
        ctrl.nonyusakiCode = 'testCode';
        ctrl.seriesPI = 'testSeriesPI';
        ctrl.shipDateFrom = '';
        ctrl.shipDateTo = '3999/12/31';
        ctrl.modelNamePI = 'testModelNamePI';
        ctrl.salesOrderNo = 'testSNo_01';
        ctrl.serviceAreaList = 'testServiceArea';
        ctrl.stateList = 'testState';
        ctrl.unitBody = 'testUnitBody';
        ctrl.countryCode = 'testCC';
        ctrl.statusOfUse = STATUS_OF_USE_ALL;
        ctrl.search();

        Test.stoptest();
    }

    // 検索（出荷年月FromTo指定、使用状況'すべて'）
    private static testMethod void test05(){
        Test.starttest();
        JEOL_NonyusakiList_ctrl ctrl = new JEOL_NonyusakiList_ctrl();

        ctrl.nonyusakiName = 'testName';
        ctrl.nonyusakiNameHankaku = 'testNameHankaku';
        ctrl.nonyusakiCode = 'testCode';
        ctrl.seriesPI = 'EE';
        ctrl.shipDateFrom = '1900/01/01';
        ctrl.shipDateTo = '3999/12/31';
        ctrl.modelNamePI = 'testModelNamePI';
        ctrl.salesOrderNo = 'testSNo_01';
        ctrl.serviceAreaList = 'testServiceArea';
        ctrl.stateList = '東京都';
        ctrl.unitBody = 'testUnitBody';
        ctrl.countryCode = 'JPN';
        ctrl.statusOfUse = STATUS_OF_USE_ALL;

        ctrl.search();
        Test.stoptest();
    }

    // クッキー生成処理（画面起動時検索フラグON、一部パラメータ指定）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABEL_NONYUSAKI_NAME, 'testName', COOKIE_PATH, -1, true));  // 納入先名称
        cookies.add(new Cookie(COOKIE_LABEL_NONYUSAKI_NAME_H, 'testNameHankaku', COOKIE_PATH, -1, true));  // 納入先名称（半角）
        cookies.add(new Cookie(COOKIE_LABEL_NONUSAKI_CODE, 'testCode', COOKIE_PATH, -1, true));  // 納入先コード
        cookies.add(new Cookie(COOKIE_LABEL_SERIES_PI, 'testPI', COOKIE_PATH, -1, true));  // 系列
        cookies.add(new Cookie(COOKIE_LABEL_SHIP_DATE_FROM, '', COOKIE_PATH, -1, true));  // 出荷年月From
        cookies.add(new Cookie(COOKIE_LABEL_SHIP_DATE_TO, '', COOKIE_PATH, -1, true));  // 出荷年月To
        cookies.add(new Cookie(COOKIE_LABEL_MODEL_NAME_PI, '', COOKIE_PATH, -1, true));  // 機種名称
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ORDER_NO, '', COOKIE_PATH, -1, true));  // 販売オーダー番号
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_AREA_LIST, '', COOKIE_PATH, -1, true));  // サービスエリア
        cookies.add(new Cookie(COOKIE_LABEL_STATE_LIST, '', COOKIE_PATH, -1, true));  // 都道府県
        cookies.add(new Cookie(COOKIE_LABEL_UNIT_BODY, '', COOKIE_PATH, -1, true));  // 本体号機
        cookies.add(new Cookie(COOKIE_LABEL_COUNTRY_CODE, '', COOKIE_PATH, -1, true));  // 国コード（左側）
        cookies.add(new Cookie(COOKIE_LABEL_COUNTRY_CODE_NAME, '', COOKIE_PATH, -1, true));  // 国コード（右側）
        cookies.add(new Cookie(COOKIE_LABEL_STATUS_OF_USE, STATUS_OF_USE_ALL, COOKIE_PATH, -1, true));  // 使用状況
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成
    private static void testData(){

        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'EE';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // 取引先（シリアル番号付品目．販売先取引先）
        Account acc = new Account();
        acc.Name = 'testName';
        acc.Code__c = 'testCode';
        acc.NameUpToKana__c = 'testNameHankaku';
        acc.serviceArea__c = 'testServiceArea';
        acc.State__c = '東京都';
        acc.CountryCode__c = 'JPN';
        insert acc;
        
        // シリアル番号付品目
        UnitBody__c ub = new UnitBody__c();
        ub.ItemLink__c = pi.Id;
        ub.SerialNo__c = 'testSNo_01';
        ub.SalesAccount__c = acc.Id;
        ub.UnitBody__c = 'testUnitBody';
        ub.StatusOfUse__c = '使用';
        ub.ShippingDate__c = Datetime.parse('2000/01/01 0:00');
        ub.ShippingDate__c = Date.parse('2000/01/01');

        insert ub;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.UnitBodyLink__c = ub.Id;
        so.Name = 'testSalesOrderNo';
        insert so;
    }

}