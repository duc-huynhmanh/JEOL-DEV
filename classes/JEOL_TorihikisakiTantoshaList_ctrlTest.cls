@IsTest
private class JEOL_TorihikisakiTantoshaList_ctrlTest {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_TorihikisakiTantoshaListPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_TorihikisakiTantoshaListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_TorihikisakiTantoshaList_ctrl ctrl = new JEOL_TorihikisakiTantoshaList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getContactList();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各値取得メソッド呼び出し
        ctrl.getCCategoryOptions();

        // クリアメソッド呼び出し
        ctrl.doFormClear();
    }

    // 検索（取引先カテゴリwhere句生成）
    private static testMethod void test02() {

        // テストデータ作成
        testData();

        Test.starttest();
        JEOL_TorihikisakiTantoshaList_ctrl ctrl = new JEOL_TorihikisakiTantoshaList_ctrl();

        ctrl.customerCategory  = 'testCCcode';

        ctrl.search1();
        Test.stoptest();
    }

    // 検索（addLikeCriteriaのwhere句生成、取引先カテゴリ該当なし）
    private static testMethod void test03() {

        // テストデータ作成
        testData();

        Test.starttest();
        JEOL_TorihikisakiTantoshaList_ctrl ctrl = new JEOL_TorihikisakiTantoshaList_ctrl();

        ctrl.customerName = 'testACCname';
        ctrl.customerCategory = 'testCCcodetest';

        ctrl.search1();
        Test.stoptest();
    }

    // クッキー生成処理（画面起動時検索フラグON）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie('customerCode', 'testACCcd', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerNameHan', 'testACCHankakuKanaName', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerName', 'testACCname', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerCategory', 'testCCcode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('tantoshaCode', 'testCntCd1', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('tantoshaName', 'testContactLastName testContactFirstName', COOKIE_PATH, -1, true));
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
        acc.NameUpToKana__c = 'testACCHankakuKanaName';
        insert acc;

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

        // 取引先責任者
        Contact cnt = new Contact();
        cnt.AccountId = acc.Id;
        cnt.LastName = 'testContactLastName';
        cnt.FirstName = 'testContactFirstName';
        cnt.TantoshaCode__c = 'testCntCd1';
        insert cnt;
    }

    private static testMethod void test04() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_TorihikisakiTantoshaListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_TorihikisakiTantoshaList_ctrl ctrl = new JEOL_TorihikisakiTantoshaList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.orderBy = 'caseSort';
        ctrl.orderDesc = true;
        ctrl.getContactList();
        
        JEOL_TorihikisakiTantoshaList_ctrl.rowWrapper rw1 = new JEOL_TorihikisakiTantoshaList_ctrl.rowWrapper(new Contact(), 1);
        JEOL_TorihikisakiTantoshaList_ctrl.rowWrapper rw2 = new JEOL_TorihikisakiTantoshaList_ctrl.rowWrapper(new Contact(), 1);
        Integer ret1 = rw1.compareTo(rw2);
        
    }
    
}