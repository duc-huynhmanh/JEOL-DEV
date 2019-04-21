@IsTest
private class JEOL_SchoolSeminarList_ctrlTest {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_SchoolSeminarListPage';  // ページのパス
    private static final String COOKIE_LABLE_SCHOOLSEMINAR_TYPE = 'SchoolSeminarType';  // 講習種別
    private static final String COOKIE_LABLE_SCHOOLSEMINAR_NAME = 'schoolSeminarName';  // 講習名
    private static final String COOKIE_LABLE_SERIES_PI = 'seriesPI';  // 系列
    private static final String COOKIE_LABLE_PLACE = 'place';  // 場所
    private static final String COOKIE_LABLE_JUKOCUSTOMER_NAME = 'jukoCustomerName';  // 受講顧客名称
    private static final String COOKIE_LABLE_GAITO_MODEL = 'gaitoModel';  // 該当機種
    private static final String COOKIE_LABLE_STATUS = 'Status';  // 状態
    private static final String COOKIE_LABLE_USE_FIELD = 'UseField';  // 利用分野
    private static final String COOKIE_LABLE_JUKOSHA_NAME = 'jukoshaName';  // 受講者名
    private static final String COOKIE_LABLE_START_DATE_FROM = 'startDateFrom';  // 開催日From
    private static final String COOKIE_LABLE_START_DATE_TO = 'startDateTo';  // 開催日To
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_SchoolSeminarListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_SchoolSeminarList_ctrl ctrl = new JEOL_SchoolSeminarList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getSchoolSeminarEntry();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各メソッド呼び出し
        ctrl.getSeriesPIOptions();
        ctrl.getTypeOptions();
        ctrl.getStatusOptions();
        ctrl.getUseFieldOptions();
        ctrl.doFormClear();

    }

    // 日付チェックエラー
    private static testMethod void test02() {
        Test.starttest();
        JEOL_SchoolSeminarList_ctrl ctrl = new JEOL_SchoolSeminarList_ctrl();

        ctrl.startDateFrom = 'aaa';

        ctrl.search();
        Test.stoptest();
    }

    // 検索（出荷年月From指定）
    private static testMethod void test03(){
        Test.starttest();
        JEOL_SchoolSeminarList_ctrl ctrl = new JEOL_SchoolSeminarList_ctrl();

        ctrl.schoolSeminarName = 'testName';
        ctrl.seriesPI = 'testPI';
        ctrl.place = 'testPlace';
        ctrl.jukoCustomerName = 'testJCName';
        ctrl.gaitoModel = 'testGModel';
        ctrl.jukoshaName = 'testJName';
        ctrl.startDateFrom = '1900/01/01';
        ctrl.startDateTo = '';
        ctrl.type = 'testType';
        ctrl.status = 'testStatus';
        ctrl.useField = 'testUseField';

        ctrl.search();
        Test.stoptest();
    }

    // 検索（出荷年月To指定）
    private static testMethod void test04(){
        Test.starttest();
        JEOL_SchoolSeminarList_ctrl ctrl = new JEOL_SchoolSeminarList_ctrl();

        ctrl.schoolSeminarName = 'testName';
        ctrl.seriesPI = 'testPI';
        ctrl.place = 'testPlace';
        ctrl.jukoCustomerName = 'testJCName';
        ctrl.gaitoModel = 'testGModel';
        ctrl.jukoshaName = 'testJName';
        ctrl.startDateFrom = '';
        ctrl.startDateTo = '3999/12/31';
        ctrl.type = 'testType';
        ctrl.status = 'testStatus';
        ctrl.useField = 'testUseField';

        ctrl.search();
        Test.stoptest();
    }

    // 検索（出荷年月FromTo指定、それ以外なし、日付部分where句生成用）
    private static testMethod void test05(){
        Test.starttest();
        JEOL_SchoolSeminarList_ctrl ctrl = new JEOL_SchoolSeminarList_ctrl();

        ctrl.schoolSeminarName = '';
        ctrl.seriesPI = '';
        ctrl.place = '';
        ctrl.jukoCustomerName = '';
        ctrl.gaitoModel = '';
        ctrl.jukoshaName = '';
        ctrl.startDateFrom = '1900/01/01';
        ctrl.startDateTo = '3999/12/31';
        ctrl.type = '';
        ctrl.status = '';
        ctrl.useField = '';

        ctrl.search();
        Test.stoptest();
    }

    // クッキー生成処理（画面起動時検索フラグON）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABLE_SCHOOLSEMINAR_TYPE, '', COOKIE_PATH, -1, true));  // 講習種別
        cookies.add(new Cookie(COOKIE_LABLE_SCHOOLSEMINAR_NAME, 'testSSName', COOKIE_PATH, -1, true));  // 講習名
        cookies.add(new Cookie(COOKIE_LABLE_SERIES_PI, '', COOKIE_PATH, -1, true));  // 系列
        cookies.add(new Cookie(COOKIE_LABLE_PLACE, '', COOKIE_PATH, -1, true));  // 場所
        cookies.add(new Cookie(COOKIE_LABLE_JUKOCUSTOMER_NAME, '', COOKIE_PATH, -1, true));  // 受講顧客名称
        cookies.add(new Cookie(COOKIE_LABLE_GAITO_MODEL, '', COOKIE_PATH, -1, true));  // 該当機種
        cookies.add(new Cookie(COOKIE_LABLE_STATUS, '', COOKIE_PATH, -1, true));  // 状態
        cookies.add(new Cookie(COOKIE_LABLE_USE_FIELD, '', COOKIE_PATH, -1, true));  // 利用分野
        cookies.add(new Cookie(COOKIE_LABLE_JUKOSHA_NAME, '', COOKIE_PATH, -1, true));  // 受講者名
        cookies.add(new Cookie(COOKIE_LABLE_START_DATE_FROM, '', COOKIE_PATH, -1, true));  // 開催日From
        cookies.add(new Cookie(COOKIE_LABLE_START_DATE_TO, '', COOKIE_PATH, -1, true));  // 開催日To
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成
    private static void testData(){
        // 講習会・セミナー情報
        SchoolSeminar__c ss = new SchoolSeminar__c();
        ss.Name = 'testSSName';
        insert ss;

        // 講習会・セミナー申込情報
        SchoolSeminarEntry__c sse = new SchoolSeminarEntry__c();
        sse.Name = 'testSSEName';
        sse.SchoolSeminar__c = ss.Id;
        insert sse;
    }

}