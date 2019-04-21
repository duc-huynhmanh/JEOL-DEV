@IsTest
private class JEOLAsia_ProfitCalculationListPageCtTest {

    // User(ユーザ)
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
        
    //保持項目有無判定
    private static final String COOKIE_LABEL_QT_NO = 'QTNo';
    private static final String COOKIE_LABEL_NAME = 'name';
    private static final String COOKIE_LABEL_EIGYOTANTOSHA_CODE = 'EigyoTantoshaCode';
    private static final String COOKIE_LABEL_EIGYOTANTOSHA_NAME = 'EigyoTantoshaName';
    private static final String COOKIE_LABEL_SALESPERSON = 'SalesPerson';
    private static final String COOKIE_LABEL_TITLESHOHIN_NAME = 'TitleShohinName';
    private static final String COOKIE_LABEL_CUSTMER_CODE = 'CustomerCode';
    private static final String COOKIE_LABEL_CUSTMER_NAME = 'CustomerName';
    private static final String COOKIE_LABEL_PRONUM = 'ProNum';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_PROFITCALC_TYPE = 'ProfitCalcType';
    private static final String COOKIE_LABEL_STATUS = 'Status';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    private static final String COOKIE_PATH = '/apex/JEOLAsia_ProfitCalculationListPage';
    private static final String COOKIE_LABEL_REGISTEREDDATE_FROM = 'RegisteredDateFrom';
    private static final String COOKIE_LABEL_REGISTEREDDATE_TO = 'RegisteredDateTo';
    //cookie有効期限
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
    
    private static testMethod void test01() {
        System.runAs (testUser) {

            Test.startTest();

           	JEOLAsia_ProfitCalculationListPageCtrl ctrl = new JEOLAsia_ProfitCalculationListPageCtrl();
            ctrl.getUrlParamFromEditorCopy();
            ctrl.getUrlParamFromEditorBranch();
            ctrl.searchItemClear();
            ctrl.getProfitCalcTypeOptions();
            ctrl.getStatusOptions();
            ctrl.getSeriesOptions();            
            ctrl.recordSearch();
            ctrl.switchingOrder();
            ctrl.getOrderBy();
            ctrl.getRecords();
            ctrl.getSelectedSeries();
            ctrl.seriesSelectAllSelect();
            ctrl.seriesSelectAllDeselect();
            ctrl.seriesSelectCancel();
            ctrl.seriesSelectApply();
            ctrl.getListRecordTypeID();
                
            Test.stopTest();
        }
    }
    
    private static testMethod void test02() {
        System.runAs (testUser) {
            Test.startTest();
            
            PageReference testPage = Page.JEOLAsia_ProfitCalculationListPage;
            Test.setCurrentPage(testPage);

            // クッキー設定
            createCookies();
            
            JEOLAsia_ProfitCalculationListPageCtrl ctrl = new JEOLAsia_ProfitCalculationListPageCtrl();
            ctrl.getUrlParamFromEditorCopy();
            ctrl.getUrlParamFromEditorBranch();
            ctrl.getProfitCalcTypeOptions();
            ctrl.getStatusOptions();
            ctrl.getSeriesOptions();            
            ctrl.recordSearch();
            ctrl.switchingOrder();
            ctrl.getOrderBy();
            ctrl.getRecords();
            ctrl.getSelectedSeries();
            ctrl.seriesSelectAllSelect();
            ctrl.seriesSelectAllDeselect();
            ctrl.seriesSelectCancel();
            ctrl.seriesSelectApply();
            ctrl.getListRecordTypeID();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void test03() {
        System.runAs (testUser) {
            Test.startTest();
            
            JEOLAsia_ProfitCalculationListPageCtrl ctrl = createData();
            ctrl.recordSearch();         
                
            Test.stopTest();
        }
    }

    private static JEOLAsia_ProfitCalculationListPageCtrl createData(){
        JEOLAsia_ProfitCalculationListPageCtrl ctrl = new JEOLAsia_ProfitCalculationListPageCtrl();
        ctrl.targetSeries = new List<String>();
        ctrl.targetSeries.add('AP');
        ctrl.targetSeries.add('BS');
        ctrl.targetSeries.add('CA');
        ctrl.targetSeries.add('EB');
        ctrl.targetSeries.add('EH');
        
        ctrl.targetQTNo = 'test';
        ctrl.targetSalesPerson = 'test';
        ctrl.targetCustomerCode = 'test';
        ctrl.targetCustomerName = 'test';
        ctrl.targetProjectNumber = 'test';
        ctrl.targetProfitCalcType = 'test';
        ctrl.status =  'test';
        ctrl.RegisteredDateFrom =  'test';
        ctrl.RegisteredDateTo = 'test';
        return ctrl;
    }
    
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
		
        cookies.add(new Cookie(COOKIE_LABEL_QT_NO, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_CODE, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_NAME, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_PROFITCALC_TYPE, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_STATUS, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, '1', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));  // 画面起動時検索フラグ
        cookies.add(new Cookie(COOKIE_LABEL_PRONUM, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        
        cookies.add(new Cookie(COOKIE_LABEL_SERIES,  'AP&&BS&&CA&&EB', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_FROM, '1900/01/01', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_TO, '2017/01/01', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        
        Apexpages.currentPage().setCookies(cookies);
    }
}