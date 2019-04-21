@isTest
private class JEOLAsia_MaintenanceBillingList_ctrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static final String COOKIE_LABEL_MONTH = 'JEOL_MaintenanceBillingList_Month';
    private static final String COOKIE_LABEL_SERIES = 'JEOL_MaintenanceBillingList_Series';
    private static final String COOKIE_LABEL_CUSTOMERCODE = 'JEOL_MaintenanceBillingList_CustomerCode';
    private static final String COOKIE_LABEL_CUSTOMERNAME = 'JEOL_MaintenanceBillingList_CustomerName';
    private static final String COOKIE_LABEL_INVOICENUMBER = 'JEOL_MaintenanceBillingList_InvoiceNumber';
    private static final String COOKIE_LABEL_STATUS = 'JEOL_MaintenanceBillingList_Status';
    private static final String COOKIE_LABEL_TARGETSERIES = 'JEOL_MaintenanceBillingList_TargetSeries';

    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_MaintenanceBillingList';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

	private static testMethod void test01()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			PageReference pageRef = Page.JEOLAsia_MaintenanceBillingList;
			/*Map<String, String> params = new Map<String, String>();
	        params.put('id', String.valueOf(contMan.id));
	        pageRef.getParameters().putAll(params);*/

	        Test.setCurrentPage(pageRef);

	        createCookies();

			JEOLAsia_MaintenanceBillingList_ctrl ctrl = new JEOLAsia_MaintenanceBillingList_ctrl();

			ctrl.doFormClear();
			ctrl.doSearch();
			ctrl.getSalesPipelines();
			ctrl.saveFlags();
			ctrl.nextAndSaveCurrentPageNumber();
			ctrl.previousAndSaveCurrentPageNumber();
			ctrl.firstAndSaveCurrentPageNumber();
			ctrl.lastAndSaveCurrentPageNumber();
			ctrl.setJumpSaveCurrentPageSize();
			ctrl.setSizeSaveCurrentPageSize();
			ctrl.getCCategoryOptions();
			ctrl.getStatusOptions();
			ctrl.seriesSelectAllSelect();
			ctrl.seriesSelectAllDeselect();
			ctrl.seriesSelectCancel();
			ctrl.seriesSelectApply();
			ctrl.getSelectedSeries();

			Test.stopTest();
		}
	}

	private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABEL_MONTH, 'testMonth', null, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERCODE, 'testCCcode ', null, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERNAME, 'testACCname ', null, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_STATUS, 'testStatus', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_INVOICENUMBER, 'testInvoice', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_TARGETSERIES, 'testSeries', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));
        Apexpages.currentPage().setCookies(cookies);
    }
}