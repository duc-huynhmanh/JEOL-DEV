@isTest
public class JEOLAsia_MaintenanceNewList_ctrlTest {
    // User(ユーザ)
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
    // Cookie用定数（営業）
    private static final String COOKIE_LABEL_CUSTOMERCODE = 'JEOL_MaintenanceListNew_CustomerCode';
    private static final String COOKIE_LABEL_CUSTOMERNAME = 'JEOL_MaintenanceListNew_CustomerName';
    private static final String COOKIE_LABEL_CUSTCODETYPE = 'JEOL_MaintenanceListNew_CustCodeType';
    private static final String COOKIE_LABEL_CUSTNAMETYPE = 'JEOL_MaintenanceListNew_CustNameType';
    private static final String COOKIE_LABEL_SALESRESPONSIBLE = 'JEOL_MaintenanceListNew_SalesResponsible';
    private static final String COOKIE_LABEL_SHIPMENTADDRESS = 'JEOL_MaintenanceListNew_ShipmentAddress';
    private static final String COOKIE_LABEL_QUOTATIONCREATED = 'JEOL_MaintenanceListNew_QuotationCreated';
    private static final String COOKIE_LABEL_SACREATED = 'JEOL_MaintenanceListNew_SACreated';
    private static final String COOKIE_LABEL_EXISTLASTACTIVITYDATE = 'JEOL_MaintenanceListNew_ExistLastActivityDate';
    private static final String COOKIE_LABEL_LASTACTIVITYDATEFROM = 'JEOL_MaintenanceListNew_LastActivityDateFrom';
    private static final String COOKIE_LABEL_LASTACTIVITYDATETO = 'JEOL_MaintenanceListNew_LastActivityDateTo';
    private static final String COOKIE_LABEL_QUOTATIONSENTDATEFROM = 'JEOL_MaintenanceListNew_QuotationSentDateFrom';
    private static final String COOKIE_LABEL_QUOTATIONSENTDATETO = 'JEOL_MaintenanceListNew_QuotationSentDateTo';
    private static final String COOKIE_LABEL_PERIODFROM = 'JEOL_MaintenanceListNew_PeriodFrom';
    private static final String COOKIE_LABEL_PERIODTO = 'JEOL_MaintenanceListNew_PeriodTo';
    private static final String COOKIE_LABEL_ORDERPROBABILITYFROM = 'JEOL_MaintenanceListNew_OrderProbabilityFrom';
    private static final String COOKIE_LABEL_ORDERPROBABILITYTO = 'JEOL_MaintenanceListNew_OrderProbabilityTo';
    private static final String COOKIE_LABEL_TARGETSERIES = 'JEOL_MaintenanceListNew_TargetSeries';
    
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_MaintenanceNewList';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    /*
* Description: Test Constructor
* MethodName : Test01
*/
    private static testMethod void test01() {
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();
            PageReference testPage = Page.JEOLAsia_MaintenanceNewList;
            Test.setCurrentPage(testPage);            
            // クッキー設定
            createCookies(true,true,true,true,true);
            JEOLAsia_MaintenanceNewList_ctrl ctrl= new JEOLAsia_MaintenanceNewList_ctrl();
            ctrl.doSearch();
            List<JEOLAsia_MaintenanceNewList_ctrl.rowWrapper> wrapper = ctrl.getMaintenanceContractManagements(); 
           
           JEOLAsia_MaintenanceNewList_ctrl.OptionDetail op= new JEOLAsia_MaintenanceNewList_ctrl.OptionDetail(new SelectOption('1','1'),true);
          	String s=  op.val;
        	ctrl.setSizeSaveCurrentPageSize();
            ctrl.firstAndSaveCurrentPageNumber();
            ctrl.previousAndSaveCurrentPageNumber();
            ctrl.nextAndSaveCurrentPageNumber();
            ctrl.lastAndSaveCurrentPageNumber();
            ctrl.setJumpSaveCurrentPageSize();
            ctrl.getRedirectExportCsvURL();
            ctrl.getListAccountTypeCode();
            ctrl.getListAccountTypeName();
            ctrl.getListQuotationCreated();
            ctrl.getListSACreated();
            ctrl.getListExistLastActivityDate();
            ctrl.getSelectedSeries();
            ctrl.seriesSelectCancel();
            ctrl.seriesSelectApply();
            ctrl.seriesSelectAllSelect();
            ctrl.seriesSelectAllDeselect();
            // クリアメソッド呼び出し
            ctrl.doFormClear();
            Test.stopTest();
        }
        
    }
    private static testMethod void test02() {
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();
            PageReference testPage = Page.JEOLAsia_MaintenanceNewList;
            Test.setCurrentPage(testPage);
            
            // クッキー設定
            createCookies(false,false,false,false,false);
            JEOLAsia_MaintenanceNewList_ctrl ctrl= new JEOLAsia_MaintenanceNewList_ctrl();
            ctrl.doSearch();
            // クリアメソッド呼び出し
            ctrl.doFormClear();
            Test.stopTest();
        }
        
    }
    private static testMethod void test03() {
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();
            PageReference testPage = Page.JEOLAsia_MaintenanceNewList;
            Test.setCurrentPage(testPage);            
            // クッキー設定
           
            JEOLAsia_MaintenanceNewList_ctrl ctrl= new JEOLAsia_MaintenanceNewList_ctrl();
            ctrl.doSearch();
            List<JEOLAsia_MaintenanceNewList_ctrl.rowWrapper> wrapper = ctrl.getMaintenanceContractManagements(); 
        	
            // クリアメソッド呼び出し
            ctrl.doFormClear();
            Test.stopTest();
        }
        
    }
    private static void createCookies(boolean hasCustCodeType,boolean hasCustNameType,boolean isQTCreated,boolean isSACreated,boolean hasLastActivity){
        List<Cookie> cookies = new List<Cookie>();
        // 営業タブ
        cookies.add(new Cookie(COOKIE_LABEL_TARGETSERIES, 'AP', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));
        if(hasCustCodeType)
            cookies.add(new Cookie(COOKIE_LABEL_CUSTCODETYPE, '2', COOKIE_PATH, -1, true));
        if(hasCustNameType)
            cookies.add(new Cookie(COOKIE_LABEL_CUSTNAMETYPE, '2', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERCODE, 'T', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERNAME, 't', COOKIE_PATH, -1, true));
        
        
        cookies.add(new Cookie(COOKIE_LABEL_SALESRESPONSIBLE, 'i', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHIPMENTADDRESS, 'I', COOKIE_PATH, -1, true));
        if(isQTCreated)
            cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONCREATED, '1', COOKIE_PATH, -1, true));
        else
            cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONCREATED, '2', COOKIE_PATH, -1, true));
        
        if(isSACreated)
            cookies.add(new Cookie(COOKIE_LABEL_SACREATED, '1', COOKIE_PATH, -1, true));
        else
            cookies.add(new Cookie(COOKIE_LABEL_SACREATED, '2', COOKIE_PATH, -1, true));
        if(hasLastActivity)
            cookies.add(new Cookie(COOKIE_LABEL_EXISTLASTACTIVITYDATE, '1', COOKIE_PATH, -1, true));
        else
            cookies.add(new Cookie(COOKIE_LABEL_EXISTLASTACTIVITYDATE, '2', COOKIE_PATH, -1, true));
        
        cookies.add(new Cookie(COOKIE_LABEL_LASTACTIVITYDATEFROM, '2016/01/01', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_LASTACTIVITYDATETO, '2017/01/12', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONSENTDATEFROM, '2016/01/01', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONSENTDATETO, '2017/01/12', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PERIODFROM, '2016/01/01', COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PERIODTO, '2017/01/12', COOKIE_PATH, -1, true));
        
        
          cookies.add(new Cookie(COOKIE_LABEL_ORDERPROBABILITYFROM, '30', COOKIE_PATH, -1, true));
         cookies.add(new Cookie(COOKIE_LABEL_ORDERPROBABILITYTO, '30', COOKIE_PATH, -1, true));
        
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        
        Apexpages.currentPage().setCookies(cookies);
    }
}