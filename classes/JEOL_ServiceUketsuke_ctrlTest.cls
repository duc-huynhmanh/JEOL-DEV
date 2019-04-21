@IsTest
private class JEOL_ServiceUketsuke_ctrlTest {
    // 定数
    private static final String SEARCH_TYPE_SALES = 'sales';
    private static final String SEARCH_TYPE_SUPPORT = 'support';

    // Cookie用定数（営業）
    private static final String COOKIE_LABEL_SALES_CUSTOMER_CODE = 'customerCode_sales';
    private static final String COOKIE_LABEL_SALES_CUSTOMER_NAME = 'customerName_sales';
    private static final String COOKIE_LABEL_SALES_CUSTOMER_CATEGORY = 'customerCategory_sales';
    private static final String COOKIE_LABEL_SALES_MODEL_NAME = 'modelName_sales';
    private static final String COOKIE_LABEL_SALES_MAIN_PART_NO_MACHINE = 'mainPartNoMachine_sales';
    private static final String COOKIE_LABEL_SALES_NAME = 'name_sales';
    private static final String COOKIE_LABEL_SALES_PRODUCT_NO = 'productNo_sales';
    private static final String COOKIE_LABEL_SALES_CENTER = 'center_sales';
    private static final String COOKIE_LABEL_SALES_UKETSUKE_SUPPORT_PERSON = 'uketsukeSupportPerson_sales';
    private static final String COOKIE_LABEL_SALES_SERVICE_DATE_STATUS = 'serviceDateStatus_sales';
    private static final String COOKIE_LABEL_SALES_TAIOU_START_DATE = 'taiouStartDate_sales';
    private static final String COOKIE_LABEL_SALES_TAIOU_END_DATE = 'taiouEndDate_sales';
    // Cookie用定数（サポート）
    private static final String COOKIE_LABEL_SUPPORT_CUSTOMER_CODE = 'customerCode_support';
    private static final String COOKIE_LABEL_SUPPORT_CUSTOMER_NAME = 'customerName_support';
    private static final String COOKIE_LABEL_SUPPORT_CENTER = 'center_support';
    private static final String COOKIE_LABEL_SUPPORT_SERIES = 'series_support';
    private static final String COOKIE_LABEL_SUPPORT_MAIN_PART_NO_MACHINE = 'mainPartNoMachine_support';
    private static final String COOKIE_LABEL_SUPPORT_UKETSUKE_SUPPORT_PERSON = 'uketsukeSupportPerson_support';
    private static final String COOKIE_LABEL_SUPPORT_SERVICE_TYPE = 'serviceType_support';
    private static final String COOKIE_LABEL_SUPPORT_NAME = 'name_support';
    private static final String COOKIE_LABEL_SUPPORT_PRODUCT_NO = 'productNo_support';
    private static final String COOKIE_LABEL_SUPPORT_KEYWORD = 'keyword_support';
    private static final String COOKIE_LABEL_SUPPORT_STATUS = 'status_support';
    private static final String COOKIE_LABEL_SUPPORT_UKETSUKE_START_DATE = 'uketsukeStartDate_support';
    private static final String COOKIE_LABEL_SUPPORT_UKETSUKE_END_DATE = 'uketsukeEndDate_support';
    private static final String COOKIE_LABEL_SUPPORT_SERVICE_DATE_STATUS = 'serviceDateStatus_support';
    private static final String COOKIE_LABEL_SUPPORT_TAIOU_START_DATE = 'taiouStartDate_support';
    private static final String COOKIE_LABEL_SUPPORT_TAIOU_END_DATE = 'taiouEndDate_support';
    // Cookie用定数（共通）
    private static final String COOKIE_PATH = '/apex/JEOL_ServiceUketsukePage';
    private static final String COOKIE_LABEL_SEARCH_TYPE = 'searchType';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
// -------------------------------------------------------------------------------------------------------------------

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む、取引先カテゴリ該当あり）
    private static testMethod void test00() {

        // テストデータ作成、本日日付取得
        date myDate = testData();

        PageReference testPage = Page.JEOL_ServiceUketsukePage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_ServiceUketsuke_ctrl ctrl = new JEOL_ServiceUketsuke_ctrl();

        // 検索結果取得（営業）とページ制御系メソッド呼び出し
        ctrl.getSupport();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // 各メソッド呼び出し
        ctrl.getCCategoryOptions();
        ctrl.getSeriesPIOptions();
        ctrl.getAreaOptions();
        ctrl.getServiceDateStatusList();
        ctrl.getServiceTypeList();
        ctrl.getStatusList();

        ctrl.customerCode_sales = '';
        ctrl.customerName_sales = '';
        ctrl.customerCategory_sales = '';
        ctrl.modelName_sales = '';
        ctrl.mainPartNoMachine_sales = '';
        ctrl.name_sales = '';
        ctrl.productNo_sales = '';
        ctrl.center_sales = '';
        ctrl.uketsukeSupportPerson_sales = '';
        ctrl.serviceDateStatus_sales = '';
        ctrl.taiouStartDate_sales = '';
        ctrl.taiouEndDate_sales = '';
        ctrl.search1();
        List<JEOL_ServiceUketsuke_ctrl.rowWrapper> wrapper = ctrl.getSupport(); 
        wrapper.get(0).getUrl();

        
        // クリアメソッド呼び出し
        ctrl.doFormClear();
    }

    private static testMethod void test01() {
        // テストデータ作成、本日日付取得
        date myDate = testData();

        Test.starttest();
        JEOL_ServiceUketsuke_ctrl ctrl = new JEOL_ServiceUketsuke_ctrl();
        
        ctrl.orderDesc = true;
        ctrl.serviceDateStatus_sales = '対応開始日';
        ctrl.taiouStartDate_sales = '3999/12/31';
        ctrl.customerCategory_sales = 'testCCcodetest';
        ctrl.search1();

        ctrl.customerName_sales = 'testCName';
        ctrl.serviceDateStatus_sales = '対応開始日';
        ctrl.taiouEndDate_sales = '1900/01/01';
        ctrl.search1();

        ctrl.serviceDateStatus_sales = '対応終了日';
        ctrl.taiouStartDate_sales = '3999/12/31';
        ctrl.taiouEndDate_sales = '1900/01/01';
        ctrl.search1();

        ctrl.serviceDateStatus_sales = '対応開始日';
        ctrl.taiouStartDate_sales = '';
        ctrl.taiouEndDate_sales = '';
        ctrl.search1();


        ctrl.serviceDateStatus_sales = '対応開始日';
        ctrl.taiouStartDate_sales = 'exeptionTest';
        ctrl.search1();

        ctrl.customerCode_sales = 'testCCode';
        ctrl.customerName_sales = 'testCName';
        ctrl.customerCategory_sales = 'testCCCode';
        ctrl.modelName_sales = 'testModelName';
        ctrl.mainPartNoMachine_sales = 'testPNM';
        ctrl.name_sales = 'testName';
        ctrl.productNo_sales = 'testPN';
        ctrl.center_sales = 'testCenter';
        ctrl.uketsukeSupportPerson_sales = 'testUSP';
        ctrl.serviceDateStatus_sales = '対応開始日';
        ctrl.taiouStartDate_sales = 'testTSD';
        ctrl.taiouEndDate_sales = 'testTED';

        ctrl.search1();
        Test.stoptest();
    }

// -------------------------------------------------------------------------------------------------------------------

    //search2テスト(対応開始日startDate、受付日startDate)
    private static testMethod void test09() {
        Test.starttest();
        JEOL_ServiceUketsuke_ctrl ctrl = new JEOL_ServiceUketsuke_ctrl();

        ctrl.serviceDateStatus_support = '対応開始日';
        ctrl.taiouStartDate_support = '3999/12/31';
        ctrl.uketsukeStartDate_support = '3999/12/31';
        ctrl.search2();

        ctrl.serviceDateStatus_support = '対応終了日';
        ctrl.taiouEndDate_support = '1900/01/01';
        ctrl.uketsukeEndDate_support = '1900/01/01';
        ctrl.search2();

        ctrl.serviceDateStatus_support = '対応終了日';
        ctrl.taiouStartDate_support = '';
        ctrl.taiouEndDate_support = '';
        ctrl.search2();

        ctrl.serviceDateStatus_support = '対応終了日';
        ctrl.taiouStartDate_support = 'testDate';
        ctrl.taiouEndDate_support = 'testDate';
        ctrl.search2();

        ctrl.serviceDateStatus_support = '';
        ctrl.uketsukeStartDate_support = '3999/12/31';
        ctrl.uketsukeEndDate_support = '1900/01/01';
        ctrl.search2();

        ctrl.customerCode_support = 'testCCode';
        ctrl.customerName_support = 'testCName';
        ctrl.center_support = 'testCenter';
        ctrl.series_support = 'testSeries';
        ctrl.mainPartNoMachine_support = 'testMPNM';
        ctrl.uketsukeSupportPerson_support = 'testUSP';
        ctrl.serviceType_support = 'testST';
        ctrl.name_support = 'testName';
        ctrl.productNo_support = 'testPN';
        ctrl.keyword_support = 'testKeyword';
        ctrl.status_support = 'testSTS';
        ctrl.uketsukeStartDate_support = 'testUSD';
        ctrl.uketsukeEndDate_support = 'testUED';
        ctrl.serviceDateStatus_support = '対応終了日';
        ctrl.taiouStartDate_support = '';
        ctrl.taiouEndDate_support = '';
        ctrl.search2();

        Test.stoptest();
    }

// -------------------------------------------------------------------------------------------------------------------

    // クッキー生成処理（画面起動時検索フラグON、検索タイプ＝販売）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        // 営業タブ
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CUSTOMER_CODE, 'k001', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CUSTOMER_NAME, '花子', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CUSTOMER_CATEGORY, 'testCCcode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_MODEL_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_MAIN_PART_NO_MACHINE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_PRODUCT_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CENTER, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_UKETSUKE_SUPPORT_PERSON, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_SERVICE_DATE_STATUS, '対応開始日', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_TAIOU_START_DATE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_TAIOU_END_DATE, '', COOKIE_PATH, -1, true));
        // サポートタブ
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_CUSTOMER_CODE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_CUSTOMER_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_CENTER, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_SERIES, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_MAIN_PART_NO_MACHINE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_UKETSUKE_SUPPORT_PERSON, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_SERVICE_TYPE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_NAME, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_PRODUCT_NO, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_KEYWORD, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_STATUS, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_UKETSUKE_START_DATE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_UKETSUKE_END_DATE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_SERVICE_DATE_STATUS, '対応開始日', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_TAIOU_START_DATE, '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_TAIOU_END_DATE, '', COOKIE_PATH, -1, true));
        // 共通
        cookies.add(new Cookie(COOKIE_LABEL_SEARCH_TYPE, 'sales', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        // クッキー生成
        Apexpages.currentPage().setCookies(cookies);
    }

    //テストデータ作成
    private static date testData(){

        //取引先
        Account acc = new Account();
        acc.Name = '取テスト１';
        acc.Code__c = 'tt01';
        acc.ServiceAreaBranch__c = '';
        acc.ServiceArea__c = '関東';
        acc.ServiceAreaBranch__c = '01';
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

        //品目
        ProductItem__c pItem = new ProductItem__c();
        pItem.Name = 'Test';
        pItem.Model__c = 'T001';
        pItem.Series__c = 'TS';
        pItem.JapaneseName__c = 'テスト';
        pItem.EnglishName__c = 'test';
        insert pItem;
        
        //シリアル番号付品目
        date myDate = date.today();
        datetime myDateTime = datetime.now();
        SerialNoProductItem__c spItem = new SerialNoProductItem__c();
        spItem.Name = 'Test';
        spItem.EfProductNo__c = 'No001';
        spItem.EfProductNoEndDate__c = myDateTime;
        spItem.SvcForm__c = 's01';
        spItem.SerialNo__c = 's00001';
        spItem.ModelsAbbreviation__c = 'c3';
        spItem.AcceptanceDate__c = myDateTime;
        spItem.StatusOfUse__c = 'use';
        spItem.ShipDate__c = myDateTime; 
        spItem.ParentNumber__c = 'p01';
        spItem.ParentItem__c = 'pItem';
        spItem.SpecialNote__c = 'memo'; 
        spItem.SalesTargetCustomer__c = 'sc01';
        spItem.ItemLink__c = pItem.Id;
        spItem.UnitBody__c = 'h01';
        insert spItem;

        //顧客対応票
        Support__c spp = new Support__c();
        spp.Name = 'u001';
        spp.TypeOfService__c = '1：パーコール';
        spp.ServiceTypeCode__c = 'Z1';
        spp.ContactMatter__c = '至急でお願いします';
        spp.SerialNoItemsLink__c = spItem.Id;
        spp.Status__c = 'コール応答中';
        spp.RequestContent1__c = '依頼１';
        spp.RequestContent2__c = '依頼２';
        spp.RequestContent3__c = '依頼３';
        spp.FirstSupportPerson__c = '荒木';
        spp.CustomerFacultyOffice__c = '○支店';
        spp.RelevanceCcReceiptNo__c = 'ku001';
        spp.Search_StartDate__c = myDate;
        spp.Search_EndDate__c = myDate;
        spp.FailureCause1__c = '原因１';
        spp.FailureCause2__c = '原因２';
        spp.FailureCause3__c = '原因３';
        spp.CustomerCode__c = 'k001';
        spp.ServiceStartDate__c = myDate;
        spp.ServiceEndDate__c = myDate;
        spp.CustomerName__c = '花子';
        spp.CustomerAffiliation__c = '○株式会社';
        spp.CustomerContactPerson__c = '太郎';
        spp.SalesCustomer__c = acc.Id;
        spp.UketsukeSupportPerson__c = '荒木';
        spp.ServiceDate2__c = '受付開始日';
        spp.ReceptionDatetime__c = myDate;
        spp.ClassificationDeal1__c = '処置１';
        spp.ClassificationDeal2__c = '処置２';
        spp.ClassificationDeal3__c = '処置３';
        spp.FaultLocation1__c = '障害１';
        spp.FaultLocation2__c = '障害２';
        spp.FaultLocation3__c = '障害３';
        spp.ProductNo__c = 'sei001';
        spp.Responce__c = '対応';
        spp.ServiceDate__c = '対応開始日';
        spp.ServicePerson__c = '荒木';
        spp.CustomerPhone__c = '0120100123';
        spp.CustomerExtension__c = 'memo';
        spp.SecondSupportPerson__c = '新井';
        spp.SalesOrderNo__c = 'so001';
        spp.MaintenanceSerialNo__c = 'M00001';
        spp.UnitBody__c = 'g01';
        insert spp;
        
        return myDate;
    }

}