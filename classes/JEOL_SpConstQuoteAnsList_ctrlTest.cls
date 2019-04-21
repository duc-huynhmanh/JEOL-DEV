@IsTest
private class JEOL_SpConstQuoteAnsList_ctrlTest {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_SpConstQuoteAnsListPage';  // PATH
    private static final String COOKIE_LABEL_COMPANY_DIVISION = 'companyDivision';  // 会社区分
    private static final String COOKIE_LABEL_QUOTE_REQUEST_NO = 'quoteRequestNo';  // 見積回答No
    private static final String COOKIE_LABEL_REQUEST_EMP_CODE = 'requestEmployeeCode';  // 依頼社員コード
    private static final String COOKIE_LABEL_REQUEST_EMP_NAME = 'requestEmployeeName';  // 依頼社員名称
    private static final String COOKIE_LABEL_ACCOUNT_CODE = 'accountCode';  // 顧客コード
    private static final String COOKIE_LABEL_ACCOUNT_NAME_KANA = 'accountNameKana';  // 顧客名称(半角)
    private static final String COOKIE_LABEL_ACCOUNT_NAME = 'accountName';  // 顧客名称
    private static final String COOKIE_LABEL_CUSTOMER_CATEGORY = 'customerCategory';  // 顧客カテゴリ
    private static final String COOKIE_LABEL_FORM = 'form';  // 形式
    private static final String COOKIE_LABEL_AREA_NAME = 'areaName';  // 地域名称
    private static final String COOKIE_LABEL_DELI_BODY_SERIAL_NO = 'deliveredBodySerialNo';  // 既納本体製番
    private static final String COOKIE_LABEL_SUBJECT = 'subject';  // 件名
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_SpConstQuoteAnsListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_SpConstQuoteAnsList_ctrl ctrl = new JEOL_SpConstQuoteAnsList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getSpConstQuoteAns();
        ctrl.getConpanyDivisionOptions();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各メソッド呼び出し
        ctrl.getAreaOptions();
        ctrl.getCCategoryOptions();
        ctrl.doFormClear();

    }

    // 全パラメータ指定
    private static testMethod void test02() {
        Test.starttest();
        JEOL_SpConstQuoteAnsList_ctrl ctrl = new JEOL_SpConstQuoteAnsList_ctrl();

        ctrl.companyDivision = 'testCDiv';
        ctrl.quoteRequestNo = 'testQRNo';
        ctrl.requestEmployeeCode = 'testECode';
        ctrl.requestEmployeeName = 'testEName';
        ctrl.accountCode = 'testACCcd';
        ctrl.accountNameKana = 'testACCnameK';
        ctrl.accountName = 'testACCname';
        ctrl.customerCategory = 'testCCcode';
        ctrl.form = 'testForm';
        ctrl.areaName = 'testAreaName';
        ctrl.deliveredBodySerialNo = 'testDBSNo';
        ctrl.subject = 'testSub';

        ctrl.search();
        Test.stoptest();
    }

    // 取引先カテゴリ検索時'where'生成用
    private static testMethod void test03() {
        // テストデータ作成
        testData();

        Test.starttest();
        JEOL_SpConstQuoteAnsList_ctrl ctrl = new JEOL_SpConstQuoteAnsList_ctrl();

        ctrl.companyDivision = '';
        ctrl.quoteRequestNo = '';
        ctrl.requestEmployeeCode = '';
        ctrl.requestEmployeeName = '';
        ctrl.accountCode = '';
        ctrl.accountNameKana = '';
        ctrl.accountName = '';
        ctrl.customerCategory = 'testCCcode';
        ctrl.form = '';
        ctrl.areaName = '';
        ctrl.deliveredBodySerialNo = '';
        ctrl.subject = '';

        ctrl.search();
        Test.stoptest();
    }

    // クッキー生成処理（画面起動時検索フラグON、一部条件指定）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABEL_COMPANY_DIVISION, '', COOKIE_PATH, -1, true));  // 会社区分
        cookies.add(new Cookie(COOKIE_LABEL_QUOTE_REQUEST_NO, 'testSCQANo', COOKIE_PATH, -1, true));  // 見積回答No
        cookies.add(new Cookie(COOKIE_LABEL_REQUEST_EMP_CODE, '', COOKIE_PATH, -1, true));  // 依頼社員コード
        cookies.add(new Cookie(COOKIE_LABEL_REQUEST_EMP_NAME, '', COOKIE_PATH, -1, true));  // 依頼社員名称
        cookies.add(new Cookie(COOKIE_LABEL_ACCOUNT_CODE, 'testACCcd', COOKIE_PATH, -1, true));  // 顧客コード
        cookies.add(new Cookie(COOKIE_LABEL_ACCOUNT_NAME_KANA, '', COOKIE_PATH, -1, true));  // 顧客名称(半角)
        cookies.add(new Cookie(COOKIE_LABEL_ACCOUNT_NAME, 'testACCname', COOKIE_PATH, -1, true));  // 顧客名称
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMER_CATEGORY, 'testCCcode', COOKIE_PATH, -1, true));  // 顧客カテゴリ
        cookies.add(new Cookie(COOKIE_LABEL_FORM, '', COOKIE_PATH, -1, true));  // 形式
        cookies.add(new Cookie(COOKIE_LABEL_AREA_NAME, '', COOKIE_PATH, -1, true));  // 地域
        cookies.add(new Cookie(COOKIE_LABEL_DELI_BODY_SERIAL_NO, '', COOKIE_PATH, -1, true));  // 既納本体製番
        cookies.add(new Cookie(COOKIE_LABEL_SUBJECT, '', COOKIE_PATH, -1, true));  // 件名
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成
    private static void testData(){
        // 取引先
        Account acc = new Account();
        acc.Name = 'testACCname';
        acc.Code__c = 'testACCcd';
        insert acc;

        // 特殊工事見積回答
        SpecialConstructionQuoteAnswer__c scqa = new SpecialConstructionQuoteAnswer__c();
        scqa.Name = 'testSCQAName';
        scqa.QuoteAnswerNo__c = 'testSCQANo';
        scqa.Account__c = acc.Id;
        scqa.QuoteAnswerDateTime__c = datetime.now();
        insert scqa;

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