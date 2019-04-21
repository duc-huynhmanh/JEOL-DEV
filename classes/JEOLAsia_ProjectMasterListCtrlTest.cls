@IsTest
private class JEOLAsia_ProjectMasterListCtrlTest {

//保持項目有無判定
    private static final String COOKIE_LABEL_SALESPERSON = 'SalesPerson';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    private static final String COOKIE_PATH = '/apex/JEOLAsia_ProjectMasterList';
    private static final String COOKIE_LABEL_PRONUM = 'ProNum';
    private static final String COOKIE_LABEL_CUSTMER_NAME = 'CustomerName';
    private static final String COOKIE_LABEL_CUSTMER_CODE = 'CustomerCode';
    private static final String COOKIE_LABEL_MODEL = 'Model';

    //cookie有効期限
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
// User(ユーザ)
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
    
    private static testMethod void test01() {
        System.runAs (testUser) {
            Test.startTest();

            createCookies();

			JEOLAsia_ProjectMasterListCtrl ctrl = new JEOLAsia_ProjectMasterListCtrl();
			ctrl.getSeriesOptions();
			ctrl.searchItemClear();
			ctrl.recordSearch();
			ctrl.switchingOrder();
			ctrl.getOrderBy();
			ctrl.getRecords();
			ctrl.getSelectedSeries();
			ctrl.seriesSelectAllSelect();
			ctrl.seriesSelectAllDeselect();
			ctrl.seriesSelectCancel();
			ctrl.seriesSelectApply();

            Test.stopTest();
        }
    }

    private static testMethod void test02() {
        System.runAs (testUser) {
            Test.startTest();

            JEOLAsia_ProjectMasterListCtrl ctrl = createData();
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
            Test.stopTest();
        }
    }

    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_PRONUM, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERIES, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_CODE, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_NAME, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_MODEL, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, '', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));  


        Apexpages.currentPage().setCookies(cookies);
    }

    private static JEOLAsia_ProjectMasterListCtrl createData(){
    	JEOLAsia_ProjectMasterListCtrl ctrl = new JEOLAsia_ProjectMasterListCtrl();
    	ctrl.targetProjectNumber = 'test';
    	ctrl.targetSeries = new List<String>();
        ctrl.targetSeries.add('AP');
        ctrl.targetSeries.add('BS');
        ctrl.targetSeries.add('CA');
        ctrl.targetSeries.add('EB');
        ctrl.targetSeries.add('EH');

        ctrl.targetCustomerCode = 'test';
        ctrl.targetCustomerName = 'test';
        ctrl.targetModel = 'test';
        ctrl.targetSalesPerson = 'test';
        ctrl.initSearchFlg = '';

        return ctrl;
    }
}