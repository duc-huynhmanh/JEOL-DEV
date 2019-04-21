@isTest
private class JEOLAsia_MaintenanceListToRenewAdd_Test {

    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
    private static final String COOKIE_LABEL_SALESPERSON = 'SalesPerson';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_PRONUM = 'ProNum';
    private static final String COOKIE_LABEL_CUSTMER_NAME = 'CustomerName';
    private static final String COOKIE_LABEL_CUSTMER_CODE = 'CustomerCode';
    private static final String COOKIE_LABEL_MODEL = 'Model';
    private static final String COOKIE_LABEL_CONTRACTFROM = 'ContractFrom';
    private static final String COOKIE_LABEL_CONTRACTTO = 'ContractTo';
    private static final String COOKIE_LABEL_CONTRACTMANAGEMENTNO = 'ContractManagementNo';
    private static final String COOKIE_LABEL_SELECTOBJ = 'selectObj';
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_MaintenanceListToRenewAdd';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';

    private static testMethod void test01()
    {
        System.runAs (testUser)
        {
            Test.startTest();

            AsiaProjectMaster__c rec = new AsiaProjectMaster__c();
            rec.ContractName__c = 'testContract';
            insert rec;

            PageReference pageRef = Page.JEOLAsia_MaintenanceListToRenewAdd;
            Test.setCurrentPage(pageRef);

            createCookies();

            JEOLAsia_MaintenanceListToRenewAdd_ctrl ctrl = new JEOLAsia_MaintenanceListToRenewAdd_ctrl();
            ctrl.dataId = rec.id;
            ctrl.pm = new AsiaProjectMaster__c();

            ctrl.doSearch();

            List<JEOLAsia_MaintenanceListToRenewAdd_ctrl.rowWrapper> rw = new List<JEOLAsia_MaintenanceListToRenewAdd_ctrl.rowWrapper>();
            rw = ctrl.getRecords(); 
            JEOLAsia_MaintenanceListToRenewAdd_ctrl.OptionDetail op= new JEOLAsia_MaintenanceListToRenewAdd_ctrl.OptionDetail(new SelectOption('1','1'),true);
            ctrl.doFormClear();
            ctrl.targetRecords = 'testRec';
            ctrl.targetContractCode = 'testCCode';
            ctrl.targetProjectNumber = 'test01';
            ctrl.targetCustomerName = 'testName';
            ctrl.targetCustomerCode = 'testCode';
            ctrl.targetModel = 'testModel';
            ctrl.targetSalesPerson = 'testSPerson';
            ctrl.contractFrom = '2017/05/01';
            ctrl.contractTo = '2017/05/31';

            ctrl.getSeriesOptions();
            ctrl.getSelectedSeries();
            ctrl.seriesSelectAllSelect();
            ctrl.seriesSelectAllDeselect();
            ctrl.seriesSelectCancel();
            ctrl.seriesSelectApply();
            ctrl.addContractMaintenanceAll();
            JEOLAsia_MaintenanceListToRenewAdd_ctrl.addContractMaintenanceBatch();
            ctrl.setSizeSaveCurrentPageSize();
            ctrl.previousAndSaveCurrentPageNumber();
            ctrl.firstAndSaveCurrentPageNumber();
            ctrl.nextAndSaveCurrentPageNumber();
            ctrl.lastAndSaveCurrentPageNumber();
            ctrl.setJumpSaveCurrentPageSize();
            ctrl.getListSelectObj();
            ctrl.getRecords();

            op.val = 'testVal';
            op.cancel();
            op.apply();
            op.setSelected(true);

            Test.stopTest();
        }
    }
    
    private static testMethod void test02() {
        // Preparation(None)
        System.runAs (testUser) 
        {
            Test.startTest();
            PageReference testPage = Page.JEOLAsia_MaintenanceListToRenewAdd;
            Test.setCurrentPage(testPage);
            
            // クッキー設定
            JEOLAsia_MaintenanceListToRenewAdd_ctrl ctrl= new JEOLAsia_MaintenanceListToRenewAdd_ctrl();
            ctrl.targetRecords = 'testRec';
            ctrl.targetContractCode = 'testCCode';
            ctrl.targetProjectNumber = 'test01';
            ctrl.targetCustomerName = 'testName';
            ctrl.targetCustomerCode = 'testCode';
            ctrl.targetModel = 'testModel';
            ctrl.targetSalesPerson = 'testSPerson';
            //ctrl.targetSeries = series;
            ctrl.contractFrom = '2017/05/01';
            ctrl.contractTo = '2017/05/31';
            ctrl.doSearch();


            ctrl.addContractMaintenance();
            ctrl.addContractMaintenanceAll();
            // クリアメソッド呼び出し
            ctrl.doFormClear();
            Test.stopTest();
        }
    }
    
    private static testMethod void test03() {
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();

            AsiaProjectMaster__c rec = new AsiaProjectMaster__c();
            insert rec;

            AsiaMaintenanceContractManagement__c recMCM = new AsiaMaintenanceContractManagement__c();
            insert recMCM;

            PageReference testPage = Page.JEOLAsia_MaintenanceListToRenewAdd;
            Test.setCurrentPage(testPage);            
            // クッキー設定
           
            JEOLAsia_MaintenanceListToRenewAdd_ctrl ctrl= new JEOLAsia_MaintenanceListToRenewAdd_ctrl();
            ctrl.doSearch();
            JEOLAsia_MaintenanceListToRenewAdd_ctrl.rowWrapper wrapper = new JEOLAsia_MaintenanceListToRenewAdd_ctrl.rowWrapper(rec, recMCM, 1); 
            
            // クリアメソッド呼び出し
            ctrl.doFormClear();
            Test.stopTest();
        }
    }
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON, 'testSeries', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERIES, 'testSeries', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_PRONUM, 'testPronum', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_NAME, 'testACCname', null, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_CODE, 'testCCcode', null, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_MODEL, 'testModel', null, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACTFROM, '2017/05/01', null, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACTTO, '2017/05/31', null, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACTMANAGEMENTNO, '0001', null, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SELECTOBJ, 'testObj', null, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        Apexpages.currentPage().setCookies(cookies);
    }
}