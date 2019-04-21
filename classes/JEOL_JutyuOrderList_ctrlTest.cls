/*
@IsTest
private class JEOL_JutyuOrderList_ctrlTest {

    // Cookei用定数 販売タブ
    private static final String COOKIE_LABEL_SALES_CO_NO = 'customerOrderNo_sales';
    private static final String COOKIE_LABEL_SALES_SEBAN = 'Seban_sales';
    private static final String COOKIE_LABEL_SALES_AREA = 'Area_sales';
    private static final String COOKIE_LABEL_SALES_USER_CODE = 'UserCode_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_TYPE = 'AccountType_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_CODE = 'AccountCode_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_NAME = 'AccountName_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_PHONE = 'AccountPhone_sales';
    private static final String COOKIE_LABEL_SALES_PARTS_NO = 'PartsNo_sales';

    // Cookei用定数 サービスタブ
    private static final String COOKIE_LABEL_SERVICE_CO_NO = 'customerOrderNo_service';
    private static final String COOKIE_LABEL_SERVICE_CC_NO = 'callCenterReceptionNo_service';
    private static final String COOKIE_LABEL_SERVICE_UNIT_BODY = 'unitBody_service';
    private static final String COOKIE_LABEL_SERVICE_KSRY = 'KishuRyakushou_service';
    private static final String COOKIE_LABEL_SERVICE_SEBAN = 'Seban_service';
    private static final String COOKIE_LABEL_SERVICE_AREA = 'Area_service';
    private static final String COOKIE_LABEL_SERVICE_USER_CODE = 'UserCode_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_TYPE = 'AccountType_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_CODE = 'AccountCode_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_NAME = 'AccountName_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_PHONE = 'AccountPhone_service';
    private static final String COOKIE_LABEL_SERVICE_PARTS_NO = 'PartsNo_service';
    private static final String COOKIE_LABEL_SERVICE_PARTS_CLASS = 'PartsClass_service';

    // Cookei用定数 共通
    private static final String COOKIE_LABEL_SEARCH_TYPE = 'searchType';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_PATH = '/apex/JEOL_JutyuOrderListPage';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 取引先タイプ定数
    private static final String ACCOUNT_TYPE_SALES = 'sales';
    private static final String ACCOUNT_TYPE_DELIVERY = 'delivery';

    // 検索タイプ定数
    private static final String SEARCH_TYPE_SALES = 'sales';
    private static final String SEARCH_TYPE_SERVICE = 'service';

    // 受注検索（販売）
    private static testMethod void test01() {

        // テストデータ生成（販売）
        testDataSales();

        PageReference testPage = Page.JEOL_JutyuOrderListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定（販売）
        createCookiesSales();

        JEOL_JutyuOrderList_ctrl ctrl = new JEOL_JutyuOrderList_ctrl();

		ctrl.searchType = JEOL_JutyuOrderList_ctrl.SEARCH_TYPE_SALES;
        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getRecords();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各値取得用メソッド呼び出し
        ctrl.getACCOUNT_TYPE_SALES();
        ctrl.getACCOUNT_TYPE_DELIVERY();
        ctrl.getPARTS_CLASS_PARTS_ONLY();
        ctrl.getPARTS_CLASS_SWAP_ONLY();
        ctrl.getRegionOptions();

	    // 全パラメータ指定（販売、AccountType_sales = 'sales'）
		ctrl.orderDesc = true;
        ctrl.customerOrderNo_sales = 'testNo';
        ctrl.Seban_sales = 'testSeban';
        ctrl.Area_sales = 'testArea';
        ctrl.UserCode_sales = 'testUcd';
        ctrl.AccountType_sales = ACCOUNT_TYPE_SALES;
        ctrl.AccountCode_sales = 'testACCcd';
        ctrl.AccountName_sales = 'testACCnm';
        ctrl.AccountPhone_sales = '03-1111-1111';
        ctrl.PartsNo_sales = 'testPN';

        // 検索（販売）
        ctrl.Search1();
        ctrl.clearResult();

		ctrl.orderDesc = true;
        ctrl.customerOrderNo_sales = '';
        ctrl.Seban_sales = '';
        ctrl.Area_sales = '';
        ctrl.UserCode_sales = '';
        ctrl.AccountType_sales = ACCOUNT_TYPE_DELIVERY;
        ctrl.AccountCode_sales = 'testAcctCode';
        ctrl.AccountName_sales = 'testAcctName';
        ctrl.AccountPhone_sales = '03-1111-1111';
        ctrl.PartsNo_sales = '';
        ctrl.Search1();
        ctrl.getRecords();

        // クリアメソッド呼び出し
        ctrl.doFormClear();
    }

    // 受注検索（サービス）
    private static testMethod void test02() {

        // テストデータ生成（サービス）
        testDataService();
        PageReference testPage = Page.JEOL_JutyuOrderListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定（サービス）
        createCookiesService();

        JEOL_JutyuOrderList_ctrl ctrl = new JEOL_JutyuOrderList_ctrl();
		ctrl.searchType = JEOL_JutyuOrderList_ctrl.SEARCH_TYPE_SERVICE;
        // StandardSetController呼び出し
		ctrl.orderDesc = true;

        ctrl.setStandardSetController();
        ctrl.getRecords();
        ctrl.customerOrderNo_sales = 'testNo';
        ctrl.Seban_service = 'testSeban';
        ctrl.Area_service = 'testArea';
        ctrl.UserCode_service = 'testUcd';
        ctrl.customerOrderNo_service = 'testOrderNo';
        ctrl.callCenterReceptionNo_service = 'testNo';
        ctrl.unitBody_service = 'testBody';
        ctrl.KishuRyakushou_service = 'testRyaku';
        ctrl.AccountType_service = ACCOUNT_TYPE_DELIVERY;
        ctrl.AccountCode_service = 'testACCcd';
        ctrl.AccountName_service = 'testACCnm';
        ctrl.AccountPhone_service = '03-1111-1111';
        ctrl.PartsNo_service = 'testPN';
        ctrl.PartsClass_service = 'parts_only';
        ctrl.Search2();

        ctrl.AccountType_service = ACCOUNT_TYPE_SALES;
        ctrl.AccountCode_service = 'testACCcd';
        ctrl.AccountName_service = 'testACCnm';
        ctrl.AccountPhone_service = '03-1111-1111';
        ctrl.PartsClass_service = 'swap_only';
        ctrl.Search2();
    }

    // クッキー生成処理（販売）（画面起動時検索フラグON、一部条件指定）
    private static void createCookiesSales(){
        List<Cookie> cookies = new List<Cookie>();

        // 販売タブ
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CO_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_SEBAN, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_AREA, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_USER_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_TYPE, ACCOUNT_TYPE_SALES, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_CODE, 'testACCSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_NAME, 'testACNSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_PHONE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_PARTS_NO, 'testITEMname', COOKIE_PATH, -1, true));

        // 共通
        cookies.add(new Cookie(COOKIE_LABEL_SEARCH_TYPE, SEARCH_TYPE_SALES, COOKIE_PATH, -1, true));  // 検索タイプは販売タブを指定
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        
        Apexpages.currentPage().setCookies(cookies);
    }

    // クッキー生成処理（サービス）（画面起動時検索フラグON、一部条件指定）
    private static void createCookiesService(){
        List<Cookie> cookies = new List<Cookie>();

        // サービスタブ
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_CO_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_CC_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_UNIT_BODY, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_KSRY, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_SEBAN, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_AREA, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_USER_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_TYPE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_CODE, 'testACCSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_NAME, 'testACNSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_PHONE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_PARTS_NO, 'testITEMname', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_PARTS_CLASS, 'testPartsClass', COOKIE_PATH, -1, true));

        // 共通
        cookies.add(new Cookie(COOKIE_LABEL_SEARCH_TYPE, SEARCH_TYPE_SERVICE, COOKIE_PATH, -1, true));  // 検索タイプはサービスタブを指定
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成（販売）
    private static void testDataSales(){
        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'testPI';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // シリアル番号付品目
        UnitBody__c ub = new UnitBody__c();
        ub.Name = 'testSNPIname';
        ub.ItemLink__c = pi.Id;
        ub.SerialNo__c = 'testSNo';
        ub.UnitBody__c = 'testUnitBody';
        ub.StatusOfUse__c = '1';
        insert ub;

        // 販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACNSL';
        accSL.Code__c = 'testACCSL';
        insert accSL;

        // 出荷先取引先
        Account accSP = new Account();
        accSP.Name = 'testACNSP';
        accSP.Code__c = 'testACCSP';
        insert accSP;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.Name = 'testSOname';
        so.SalesAccount__c = accSL.Id;
        so.ShipmentAccount__c = accSP.Id;
//        so.UnitBodyLink__c = ub.Id;               //20150905 commentout because prod not have this field
        //パーツサプライを指定
        so.SalesOrderTypeCode__c = '5A7';
        insert so;

        // 販売オーダライン
        SalesOrderLine__c sol = new SalesOrderLine__c();
        sol.Name = 'testSOLname';
        sol.SalesOrderLink__c = so.Id;
        sol.ProductItem__c = pi.Id;
        insert sol;
    }

    // テストデータ作成（サービス）
    private static void testDataService(){
        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'testPI';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // シリアル番号付品目
        UnitBody__c ub = new UnitBody__c();
        ub.Name = 'testSNPIname';
        ub.ItemLink__c = pi.Id;
        ub.SerialNo__c = 'testSNo';
        ub.UnitBody__c = 'testUnitBody';
        ub.StatusOfUse__c = '1';
        insert ub;

        // 顧客対応票
        Support__c spt = new Support__c();
        spt.Name = 'testSPTname';
//        spt.UnitBodyLink__c = ub.Id;      //20150905 commentout because prod not have this field
        insert spt;

        // 販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACNSL';
        accSL.Code__c = 'testACCSL';
        insert accSL;

        // 出荷先取引先
        Account accSP = new Account();
        accSP.Name = 'testACNSP';
        accSP.Code__c = 'testACCSP';
        insert accSP;

        // サービスオーダ
        ServiceOrder__c so = new ServiceOrder__c();
        so.Name = 'testSOname';
        so.SalesAccount__c = accSL.Id;
        so.ShipmentAccount__c = accSP.Id;
        so.Customer__c = spt.Id;
        insert so;

        // サービスオーダ材料費
        ServiceOrderControl__c soc = new ServiceOrderControl__c();
        soc.Name = 'testSOLname';
        soc.ServiceOrder__c = so.Id;
        soc.ProductItem__c = pi.Id;
        insert soc;
    }

}
*/


/****************************/
@IsTest
private class JEOL_JutyuOrderList_ctrlTest {

    // Cookei用定数 販売タブ
    private static final String COOKIE_LABEL_SALES_CO_NO = 'customerOrderNo_sales';
    private static final String COOKIE_LABEL_SALES_SEBAN = 'Seban_sales';
    private static final String COOKIE_LABEL_SALES_AREA = 'Area_sales';
    private static final String COOKIE_LABEL_SALES_USER_CODE = 'UserCode_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_TYPE = 'AccountType_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_CODE = 'AccountCode_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_NAME = 'AccountName_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_PHONE = 'AccountPhone_sales';
    private static final String COOKIE_LABEL_SALES_PARTS_NO = 'PartsNo_sales';

    // Cookei用定数 サービスタブ
    private static final String COOKIE_LABEL_SERVICE_CO_NO = 'customerOrderNo_service';
    private static final String COOKIE_LABEL_SERVICE_CC_NO = 'callCenterReceptionNo_service';
    private static final String COOKIE_LABEL_SERVICE_UNIT_BODY = 'unitBody_service';
    private static final String COOKIE_LABEL_SERVICE_KSRY = 'KishuRyakushou_service';
    private static final String COOKIE_LABEL_SERVICE_SEBAN = 'Seban_service';
    private static final String COOKIE_LABEL_SERVICE_AREA = 'Area_service';
    private static final String COOKIE_LABEL_SERVICE_USER_CODE = 'UserCode_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_TYPE = 'AccountType_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_CODE = 'AccountCode_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_NAME = 'AccountName_service';
    private static final String COOKIE_LABEL_SERVICE_ACCOUNT_PHONE = 'AccountPhone_service';
    private static final String COOKIE_LABEL_SERVICE_PARTS_NO = 'PartsNo_service';
    private static final String COOKIE_LABEL_SERVICE_PARTS_CLASS = 'PartsClass_service';

    // Cookei用定数 共通
    private static final String COOKIE_LABEL_SEARCH_TYPE = 'searchType';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_PATH = '/apex/JEOL_JutyuOrderListPage';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 取引先タイプ定数
    private static final String ACCOUNT_TYPE_SALES = 'sales';
    private static final String ACCOUNT_TYPE_DELIVERY = 'delivery';

    // 検索タイプ定数
    private static final String SEARCH_TYPE_SALES = 'sales';
    private static final String SEARCH_TYPE_SERVICE = 'service';

    // 受注検索（販売）
    private static testMethod void test01() {

        // テストデータ生成（販売）
        testDataSales();

        PageReference testPage = Page.JEOL_JutyuOrderListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定（販売）
        createCookiesSales();

        JEOL_JutyuOrderList_ctrl ctrl = new JEOL_JutyuOrderList_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getRecords();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各値取得用メソッド呼び出し
        ctrl.getACCOUNT_TYPE_SALES();
        ctrl.getACCOUNT_TYPE_DELIVERY();
        ctrl.getPARTS_CLASS_PARTS_ONLY();
        ctrl.getPARTS_CLASS_SWAP_ONLY();
        ctrl.getRegionOptions();

        // 全パラメータ指定（販売、AccountType_sales = 'sales'）
        ctrl.orderDesc = true;
        ctrl.customerOrderNo_sales = 'testNo';
        ctrl.Seban_sales = 'testSeban';
        ctrl.Area_sales = 'testArea';
        ctrl.UserCode_sales = 'testUcd';
        ctrl.AccountType_sales = ACCOUNT_TYPE_SALES;
        ctrl.AccountCode_sales = 'testACCcd';
        ctrl.AccountName_sales = 'testACCnm';
        ctrl.AccountPhone_sales = '03-1111-1111';
        ctrl.PartsNo_sales = 'testPN';

        // 検索（販売）
        ctrl.Search1();
        ctrl.clearResult();

        ctrl.orderDesc = true;
        ctrl.customerOrderNo_sales = '';
        ctrl.Seban_sales = '';
        ctrl.Area_sales = '';
        ctrl.UserCode_sales = '';
        ctrl.AccountType_sales = ACCOUNT_TYPE_DELIVERY;
        ctrl.AccountCode_sales = 'testAcctCode';
        ctrl.AccountName_sales = 'testAcctName';
        ctrl.AccountPhone_sales = '03-1111-1111';
        ctrl.PartsNo_sales = '';
        ctrl.Search1();
        ctrl.getRecords();

        // クリアメソッド呼び出し
        ctrl.doFormClear();
    }

    // 受注検索（サービス）
    private static testMethod void test02() {

        // テストデータ生成（サービス）
        testDataService();
        PageReference testPage = Page.JEOL_JutyuOrderListPage;
        Test.setCurrentPage(testPage);

        // クッキー設定（サービス）
        createCookiesService();

        JEOL_JutyuOrderList_ctrl ctrl = new JEOL_JutyuOrderList_ctrl();

        // StandardSetController呼び出し
        ctrl.setStandardSetController();

        ctrl.orderDesc = true;
        ctrl.customerOrderNo_sales = 'testNo';
        ctrl.Seban_service = 'testSeban';
        ctrl.Area_service = 'testArea';
        ctrl.UserCode_service = 'testUcd';
        ctrl.customerOrderNo_service = 'testOrderNo';
        ctrl.callCenterReceptionNo_service = 'testNo';
        ctrl.unitBody_service = 'testBody';
        ctrl.KishuRyakushou_service = 'testRyaku';
        ctrl.AccountType_service = ACCOUNT_TYPE_DELIVERY;
        ctrl.AccountCode_service = 'testACCcd';
        ctrl.AccountName_service = 'testACCnm';
        ctrl.AccountPhone_service = '03-1111-1111';
        ctrl.PartsNo_service = 'testPN';
        ctrl.PartsClass_service = 'parts_only';
        ctrl.Search2();

        ctrl.AccountType_service = ACCOUNT_TYPE_SALES;
        ctrl.AccountCode_service = 'testACCcd';
        ctrl.AccountName_service = 'testACCnm';
        ctrl.AccountPhone_service = '03-1111-1111';
        ctrl.PartsClass_service = 'swap_only';
        ctrl.Search2();
    }

    // クッキー生成処理（販売）（画面起動時検索フラグON、一部条件指定）
    private static void createCookiesSales(){
        List<Cookie> cookies = new List<Cookie>();

        // 販売タブ
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CO_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_SEBAN, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_AREA, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_USER_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_TYPE, ACCOUNT_TYPE_SALES, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_CODE, 'testACCSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_NAME, 'testACNSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_PHONE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_PARTS_NO, 'testITEMname', COOKIE_PATH, -1, true));

        // 共通
        cookies.add(new Cookie(COOKIE_LABEL_SEARCH_TYPE, SEARCH_TYPE_SALES, COOKIE_PATH, -1, true));  // 検索タイプは販売タブを指定
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        
        Apexpages.currentPage().setCookies(cookies);
    }

    // クッキー生成処理（サービス）（画面起動時検索フラグON、一部条件指定）
    private static void createCookiesService(){
        List<Cookie> cookies = new List<Cookie>();

        // サービスタブ
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_CO_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_CC_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_UNIT_BODY, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_KSRY, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_SEBAN, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_AREA, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_USER_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_TYPE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_CODE, 'testACCSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_NAME, 'testACNSL', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_PHONE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_PARTS_NO, 'testITEMname', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_PARTS_CLASS, 'testPartsClass', COOKIE_PATH, -1, true));

        // 共通
        cookies.add(new Cookie(COOKIE_LABEL_SEARCH_TYPE, SEARCH_TYPE_SERVICE, COOKIE_PATH, -1, true));  // 検索タイプはサービスタブを指定
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成（販売）
    private static void testDataSales(){
        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'testPI';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // シリアル番号付品目
        SerialNoProductItem__c snpi = new SerialNoProductItem__c();
        snpi.Name = 'testSNPIname';
        snpi.ItemLink__c = pi.Id;
        snpi.SerialNo__c = 'testSNo';
        snpi.UnitBody__c = 'testUnitBody';
        snpi.StatusOfUse__c = '1';
        snpi.SalesTargetCustomer__c = 'testCode';
        insert snpi;

        // 販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACNSL';
        accSL.Code__c = 'testACCSL';
        insert accSL;

        // 出荷先取引先
        Account accSP = new Account();
        accSP.Name = 'testACNSP';
        accSP.Code__c = 'testACCSP';
        insert accSP;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.Name = 'testSOname';
        so.SalesAccount__c = accSL.Id;
        so.ShipmentAccount__c = accSP.Id;
        so.SerialNoItemLink__c = snpi.Id;
        //パーツサプライを指定
        so.SalesOrderTypeCode__c = '5A7';
        insert so;

        // 販売オーダライン
        SalesOrderLine__c sol = new SalesOrderLine__c();
        sol.Name = 'testSOLname';
        sol.SalesOrderLink__c = so.Id;
        sol.ProductItem__c = pi.Id;
        insert sol;
    }

    // テストデータ作成（サービス）
    private static void testDataService(){
        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'testPI';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // シリアル番号付品目
        SerialNoProductItem__c snpi = new SerialNoProductItem__c();
        snpi.Name = 'testSNPIname';
        snpi.ItemLink__c = pi.Id;
        snpi.SerialNo__c = 'testSNo';
        snpi.UnitBody__c = 'testUnitBody';
        snpi.StatusOfUse__c = '1';
        snpi.SalesTargetCustomer__c = 'testCode';
        insert snpi;

        // 顧客対応票
        Support__c spt = new Support__c();
        spt.Name = 'testSPTname';
        spt.SerialNoItemsLink__c = snpi.Id;
        insert spt;

        // 販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACNSL';
        accSL.Code__c = 'testACCSL';
        insert accSL;

        // 出荷先取引先
        Account accSP = new Account();
        accSP.Name = 'testACNSP';
        accSP.Code__c = 'testACCSP';
        insert accSP;

        // サービスオーダ
        ServiceOrder__c so = new ServiceOrder__c();
        so.Name = 'testSOname';
        so.SalesAccount__c = accSL.Id;
        so.ShipmentAccount__c = accSP.Id;
        so.Customer__c = spt.Id;
        insert so;

        // サービスオーダ材料費
        ServiceOrderControl__c soc = new ServiceOrderControl__c();
        soc.Name = 'testSOLname';
        soc.ServiceOrder__c = so.Id;
        soc.ProductItem__c = pi.Id;
        insert soc;
    }

}