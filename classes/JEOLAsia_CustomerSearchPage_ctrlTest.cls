@isTest
private class JEOLAsia_CustomerSearchPage_ctrlTest {

	private static final String COOKIE_PATH = '/apex/JEOL_CustomerSearchPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';         // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';             // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

	private static testMethod void test01()
    {
    	testData();

    	PageReference testPage = Page.JEOLAsia_CustomerSearchPage;
        Test.setCurrentPage(testPage);

        createCookies();

        JEOLAsia_CustomerSearchPage_ctrl ctrl = new JEOLAsia_CustomerSearchPage_ctrl();

        ctrl.getCountryOptions();
		ctrl.countryCode = 'JPN';
		ctrl.changeCountry();
        ctrl.areaSelectCancel();
        ctrl.AreaOptions.get(0).isSelected = true;
        ctrl.areaSelectApply();
        ctrl.areaSelectAllSelect();
        ctrl.getSelectedAreas();
        ctrl.areaSelectAllDeselect();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        ctrl.code = 'testACCcd';
        ctrl.customerCategory = 'testCCcodeTest';
        ctrl.search1();
        ctrl.getAccount();

        ctrl.name = '';
        ctrl.code = '';
        ctrl.customerCategory  = 'testCCcode';
		ctrl.undergraduate = '';
		ctrl.countryCode = '';
        ctrl.areaSelectAllDeselect();
        ctrl.areaSelectApply();
        ctrl.search1();
        ctrl.getAccount();

        ctrl.getCCategoryOptions();

        ctrl.doFormClear();
    }

    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie('name', 'testACCname', null, -1, true));
        cookies.add(new Cookie('code', 'testACCcd', null, -1, true));
        cookies.add(new Cookie('area', 'testArea', null, -1, true));
        cookies.add(new Cookie('customerCategory', 'testCCcode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('undergraduate', 'undergraduateTest', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('countryCode', 'testCountryCode', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('targetAreas', 'targetAreasTest1&&targetAreasTest2', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        Apexpages.currentPage().setCookies(cookies);
    }

    private static void testData(){
        Account acc = new Account();
        acc.Name = 'testACCname';
        acc.Code__c = 'testACCcd';
        acc.Area__c = 'testArea';
        acc.Undergraduate__c = 'testUG';
        insert acc;

        Category__c cc = new Category__c();
        cc.Name = 'testCCname';
        cc.Code__c = 'testCCcode';
        insert cc;

        // 取引先カテゴリジャンクション
        CategoryJunction__c ccj = new CategoryJunction__c();
        ccj.CategoryName__c = cc.Id;
        ccj.Account__c = acc.Id;
        insert ccj;
        
        SelectListManage__c ctySlm = new SelectListManage__c();
        ctySlm.name = '国';
        ctySlm.referenceName__c = 'country';
        ctySlm.value__c = 'JPN';
        ctySlm.label__c = 'JPN';
        ctySlm.sortNo__c = '1';
        insert ctySlm;

        SelectListManage__c areSlm = new SelectListManage__c();
        areSlm.name = '地域';
        areSlm.referenceName__c = 'Area';
        areSlm.value__c = 'test支店';
        areSlm.label__c = 'test支店';
        areSlm.sortNo__c = '1';
        insert areSlm;
    }
}