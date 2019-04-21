@isTest
private class JEOLAsia_MaintenanceInspectionList_Test {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
	private static final String COOKIE_LABEL_MONTH = 'JEOL_MaintenanceInspectionList_Month';
    private static final String COOKIE_LABEL_CUSTOMERCODE = 'JEOL_MaintenanceInspectionList_CustomerCode';
    private static final String COOKIE_LABEL_CUSTOMERNAME = 'JEOL_MaintenanceInspectionList_CustomerName';
    private static final String COOKIE_LABEL_STATUS = 'JEOL_MaintenanceInspectionList_Status';
    private static final String COOKIE_LABEL_TARGETSERIES = 'JEOL_MaintenanceInspectionList_TargetSeries';

    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_MaintenanceInspectionList';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';

	private static testMethod void test01()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			insert contMan;

			AsiaMaintenanceAccountBook__c accBk = new AsiaMaintenanceAccountBook__c();
			accBk.Name = 'testAMABName';
			accBk.MaintenanceContractManagement__r = contMan;
			accBk.MaintenanceContractManagement__c = contMan.id;
			insert accBk;

			PageReference pageRef = Page.JEOLAsia_MaintenanceInspectionList;
			Map<String, String> params = new Map<String, String>();
	        params.put('id', String.valueOf(contMan.id));
	        pageRef.getParameters().putAll(params);

	        Test.setCurrentPage(pageRef);

	        createCookies();

	        JEOLAsia_MaintenanceInspectionList_ctrl ctrl = new JEOLAsia_MaintenanceInspectionList_ctrl();
	        List<JEOLAsia_MaintenanceInspectionList_ctrl.rowWrapper> rw = ctrl.getSalesPipelines();
	        JEOLAsia_MaintenanceInspectionList_ctrl.OptionDetail op= new JEOLAsia_MaintenanceInspectionList_ctrl.OptionDetail(new SelectOption('1','1'),true);

	        ctrl.dataId = accBk.Id;
	        ctrl.doFormClear();
			ctrl.doSearch();
			ctrl.nextAndSaveCurrentPageNumber();
			ctrl.previousAndSaveCurrentPageNumber();
			ctrl.firstAndSaveCurrentPageNumber();
			ctrl.lastAndSaveCurrentPageNumber();
			ctrl.setJumpSaveCurrentPageSize();
			ctrl.setSizeSaveCurrentPageSize();
			ctrl.saveFlags();
			ctrl.getCCategoryOptions();
			ctrl.getStatusOptions();
			ctrl.seriesSelectAllSelect();
			ctrl.seriesSelectAllDeselect();
			ctrl.seriesSelectCancel();
			ctrl.seriesSelectApply();
			ctrl.getSelectedSeries();
			ctrl.getSalesPipelines();

			op.val = 'test';
			op.cancel();
			op.apply();
			op.setSelected(true);

			Test.stopTest();
		}
	}

	private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABEL_MONTH, 'testMonth', null, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERCODE, 'testCCcode ', null, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERNAME, 'testACCname ', null, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_STATUS, 'testStatus', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_TARGETSERIES, 'testSeries', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));
        Apexpages.currentPage().setCookies(cookies);
    }
}