public with sharing class JEOL_JutyuOrderList_ctrl extends JEOL_SearchBase_ctrl {
    public String customerOrderNo_sales{get; set;}
    public String Seban_sales{get; set;}
    public String Area_sales{get; set;}
    public String UserCode_sales{get; set;}
    public String AccountType_sales{get; set;}
    public String AccountCode_sales{get; set;}
    public String AccountName_sales{get; set;}
    public String AccountPhone_sales{get; set;}
    public String PartsNo_sales{get; set;}

    public String customerOrderNo_service{get; set;}
    public String callCenterReceptionNo_service{get; set;}
    public String unitBody_service{get; set;}
    public String KishuRyakushou_service{get; set;}
    public String Seban_service{get; set;}
    public String Area_service{get; set;}
    public String UserCode_service{get; set;}
    public String AccountType_service{get; set;}
    public String AccountCode_service{get; set;}
    public String AccountName_service{get; set;}
    public String AccountPhone_service{get; set;}
    public String PartsNo_service{get; set;}
    public String PartsClass_service{get; set;}

    private static final String COOKIE_LABEL_SALES_CO_NO = 'customerOrderNo_sales';
    private static final String COOKIE_LABEL_SALES_SEBAN = 'Seban_sales';
    private static final String COOKIE_LABEL_SALES_AREA = 'Area_sales';
    private static final String COOKIE_LABEL_SALES_USER_CODE = 'UserCode_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_TYPE = 'AccountType_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_CODE = 'AccountCode_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_NAME = 'AccountName_sales';
    private static final String COOKIE_LABEL_SALES_ACCOUNT_PHONE = 'AccountPhone_sales';
    private static final String COOKIE_LABEL_SALES_PARTS_NO = 'PartsNo_sales';

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

    private static final String COOKIE_LABEL_SEARCH_TYPE = 'searchType';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_PATH = '/apex/JEOL_JutyuOrderListPage';

    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    private static final String ACCOUNT_TYPE_SALES = 'sales';
    private static final String ACCOUNT_TYPE_DELIVERY = 'delivery';

    private static final String PARTS_CLASS_PARTS_ONLY = 'parts_only';
    private static final String PARTS_CLASS_SWAP_ONLY = 'swap_only';
    
    public static final String SEARCH_TYPE_SALES = 'sales';
    public static final String SEARCH_TYPE_SERVICE = 'service';

    public String searchType{get; set;}
    private String lastQueryString;

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';

    // タブ遷移時検索結果クリア制御用フラグ
    private Boolean noResultClearFlg = false;

    public JEOL_JutyuOrderList_ctrl() {
        orderBy= 'Name';
        currentOrder = 'Name';
        orderDesc = false;
        this.AccountType_sales = ACCOUNT_TYPE_SALES;
        this.AccountType_service = ACCOUNT_TYPE_SALES;
        this.PartsClass_service = '';
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            noResultClearFlg = true;
            if (searchType == SEARCH_TYPE_SALES) {
                doSearchSalesOrder();
            } else if (searchType == SEARCH_TYPE_SERVICE) {
                doSearchServiceOrder();
            }
        }
    }
    
    public String getACCOUNT_TYPE_SALES() {
        return ACCOUNT_TYPE_SALES;
    }
    
    public String getACCOUNT_TYPE_DELIVERY() {
        return ACCOUNT_TYPE_DELIVERY;
    }

    public String getPARTS_CLASS_PARTS_ONLY() {
        return PARTS_CLASS_PARTS_ONLY;
    }

    public String getPARTS_CLASS_SWAP_ONLY() {
        return PARTS_CLASS_SWAP_ONLY;
    }

    public List<SelectOption> getRegionOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_AREA);
    }
    
    // タブ遷移時検索結果クリア
    public void clearResult(){
        if(!noResultClearFlg){
            ssc = null;
        }
        noResultClearFlg = false;
    }

    public override void setStandardSetController() {
        if (this.lastQueryString != null) {
            setStandardSetController(lastQueryString);
        }
    }
    
    public void setStandardSetController(String queryStr) {
        
        String soql = queryStr;
        
        soql += ' ORDER BY ' + orderBy;
        if (orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000 ';

        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        
        if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
        saveInputValues();
    }
    
    public void doSearchSalesOrder() {
        String soql = ' SELECT ' +
            ' Id, Name, CustomerOrder__c, ShipmentAccount__c, ShipmentAccount__r.Code__c, ShipmentAccount__r.name, ShipmentAccount__r.Phone, ' +
            ' SalesAccount__c, SalesAccount__r.Code__c, SalesAccount__r.name, SalesAccount__r.Phone, Area__c, SalesStaff__c, OrderDateFormula__c, ' +
            ' PlanningDeliveryTimeFormula__c, ProductNumber__c, OrderStatus__c, UnitBodyLink__r.ItemLink__r.Name, CurrencyIsoCode, ' +
            ' (SELECT id, Name, ProductItem__r.name, PositionText__c FROM SalesOrderLines__r)' +
        ' FROM ' +
            ' salesOrder__c';

        List<String> whereStrList = getWhereStrList_Sales();
        if (whereStrList.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrList);
        }
        
        lastQueryString = soql;
        searchType = SEARCH_TYPE_SALES;

        setStandardSetController(soql);
    }
    
    public void doSearchServiceOrder() {
        String soql = ' SELECT ' +
            ' Id, Name, CustomerOrder__c, ShipmentAccount__c, ShipmentAccount__r.Code__c, ShipmentAccount__r.name, ShipmentAccount__r.Phone, ' +
            ' SalesAccount__c, SalesAccount__r.Code__c, SalesAccount__r.name, SalesAccount__r.Phone, Center__c, SalesStaff__c, OrderDateFormula__c,' +
            ' DesiredDeliveryDateFormula__c, ProductNo__c, OrderStatus__c, CallCenterReceptionNo__c, CurrencyIsoCode, ' +
            ' Customer__r.UnitBodyLink__r.UnitBody__c, Customer__r.UnitBodyLink__r.ModelName__c, Customer__r.UnitBodyLink__r.ItemLink__r.Name, ' +
            ' (SELECT id, name, ProductItem__r.name, SetNo__c FROM ServiceOrderControls__r)' +
        ' FROM ' +
            ' ServiceOrder__c ';

        List<String> whereStrList = getWhereStrList_Service();
        if (whereStrList.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrList);
        }
        
        lastQueryString = soql;
        searchType = SEARCH_TYPE_SERVICE;

        setStandardSetController(soql);
    }

    /*検索ボタン押下時*/    
    /* 営業向け検索 */
    public PageReference search1() {
        
        orderBy= 'Name';
        currentOrder = 'Name';
        orderDesc = false;
        
        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        doSearchSalesOrder();
        if (ssc != null){
            ssc.setPageNumber(1);
        }
        return null;
    }

    /* サポート向け検索*/
    public PageReference search2() {
        
        orderBy= 'Name';
        currentOrder = 'Name';
        orderDesc = false;
        
        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        doSearchServiceOrder();
        if (ssc != null){
            ssc.setPageNumber(1);
        }
        return null;
    }
    
    public void doFormClear() {
        customerOrderNo_sales = null;
        Seban_sales = null;
        Area_sales = null;
        UserCode_sales = null;
        AccountCode_sales = null;
        AccountName_sales = null;
        AccountPhone_sales = null;
        PartsNo_sales = null;
        
        customerOrderNo_service = null;
        callCenterReceptionNo_service = null;
        unitBody_service = null;
        KishuRyakushou_service = null;
        Seban_service = null;
        Area_service = null;
        UserCode_service = null;
        AccountCode_service = null;
        AccountName_service = null;
        AccountPhone_service = null;
        PartsNo_service = null;
        PartsClass_service = null;
        
        this.AccountType_sales = ACCOUNT_TYPE_SALES;
        this.AccountType_service = ACCOUNT_TYPE_SALES;

        ssc = null;

        //ページ初期化
        pageNo = 1;
//        pageSize = 10;
        pageSize = 50;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        saveInputValues();
    }
    
    
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_SALES_CO_NO, this.customerOrderNo_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_SEBAN, this.Seban_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_AREA, this.Area_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_USER_CODE, this.UserCode_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_TYPE, this.AccountType_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_CODE, this.AccountCode_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_NAME, this.AccountName_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ACCOUNT_PHONE, this.AccountPhone_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_PARTS_NO, this.PartsNo_sales, COOKIE_PATH, -1, true));
    
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_CO_NO, this.customerOrderNo_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_CC_NO, this.callCenterReceptionNo_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_UNIT_BODY, this.unitBody_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_KSRY, this.KishuRyakushou_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_SEBAN, this.Seban_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_AREA, this.Area_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_USER_CODE, this.UserCode_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_TYPE, this.AccountType_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_CODE, this.AccountCode_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_NAME, this.AccountName_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_ACCOUNT_PHONE, this.AccountPhone_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_PARTS_NO, this.PartsNo_service, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_PARTS_CLASS, this.PartsClass_service, COOKIE_PATH, -1, true));

        cookies.add(new Cookie(COOKIE_LABEL_SEARCH_TYPE, this.searchType, COOKIE_PATH, -1, true));

        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);

    }
    
        //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();

        Boolean hasSearchValues = false;
        if(cookies.containsKey(COOKIE_LABEL_SALES_CO_NO)){
            this.customerOrderNo_sales = cookies.get(COOKIE_LABEL_SALES_CO_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_SEBAN)){
            this.Seban_sales = cookies.get(COOKIE_LABEL_SALES_SEBAN).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_AREA)){
            this.Area_sales = cookies.get(COOKIE_LABEL_SALES_AREA).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_USER_CODE)){
            this.UserCode_sales = cookies.get(COOKIE_LABEL_SALES_USER_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_ACCOUNT_TYPE)){
            this.AccountType_sales = cookies.get(COOKIE_LABEL_SALES_ACCOUNT_TYPE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_ACCOUNT_CODE)){
            this.AccountCode_sales = cookies.get(COOKIE_LABEL_SALES_ACCOUNT_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_ACCOUNT_NAME)){
            this.AccountName_sales = cookies.get(COOKIE_LABEL_SALES_ACCOUNT_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_ACCOUNT_PHONE)){
            this.AccountPhone_sales = cookies.get(COOKIE_LABEL_SALES_ACCOUNT_PHONE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_PARTS_NO)){
            this.PartsNo_sales = cookies.get(COOKIE_LABEL_SALES_PARTS_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_CO_NO)){
            this.customerOrderNo_service = cookies.get(COOKIE_LABEL_SERVICE_CO_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_CC_NO)){
            this.callCenterReceptionNo_service = cookies.get(COOKIE_LABEL_SERVICE_CC_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_UNIT_BODY)){
            this.unitBody_service = cookies.get(COOKIE_LABEL_SERVICE_UNIT_BODY).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_KSRY)){
            this.KishuRyakushou_service = cookies.get(COOKIE_LABEL_SERVICE_KSRY).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_SEBAN)){
            this.Seban_service = cookies.get(COOKIE_LABEL_SERVICE_SEBAN).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_AREA)){
            this.Area_service = cookies.get(COOKIE_LABEL_SERVICE_AREA).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_USER_CODE)){
            this.UserCode_service = cookies.get(COOKIE_LABEL_SERVICE_USER_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_ACCOUNT_TYPE)){
            this.AccountType_service = cookies.get(COOKIE_LABEL_SERVICE_ACCOUNT_TYPE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_ACCOUNT_CODE)){
            this.AccountCode_service = cookies.get(COOKIE_LABEL_SERVICE_ACCOUNT_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_ACCOUNT_NAME)){
            this.AccountName_service = cookies.get(COOKIE_LABEL_SERVICE_ACCOUNT_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_ACCOUNT_PHONE)){
            this.AccountPhone_service = cookies.get(COOKIE_LABEL_SERVICE_ACCOUNT_PHONE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_PARTS_NO)){
            this.PartsNo_service = cookies.get(COOKIE_LABEL_SERVICE_PARTS_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_PARTS_CLASS)){
            this.PartsClass_service = cookies.get(COOKIE_LABEL_SERVICE_PARTS_CLASS).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SEARCH_TYPE)){
            this.searchType = cookies.get(COOKIE_LABEL_SEARCH_TYPE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER)){
            this.pageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER) && cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue().length() != 0){
            PageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        if(cookies.containsKey(COOKIE_LABEL_PAGE_SIZE) && cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue().length() != 0){
            PageSize = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue());
        }
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }

        return hasSearchValues;
    }

    /*検索内容の取得*/    
    public List<rowWrapper> getRecords() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;
        String targetChildeReferenceName;
        if (searchType == SEARCH_TYPE_SALES) {
            targetChildeReferenceName = 'SalesOrderLines__r';
        } else if (searchType == SEARCH_TYPE_SERVICE) {
            targetChildeReferenceName = 'ServiceOrderControls__r';
        }
        
        if (ssc != null && String.isNotBlank(targetChildeReferenceName)) {
            for (Sobject row : (List<Sobject>)ssc.getRecords()) {
                rowWrapper wrap = new rowWrapper(row, currentCount, targetChildeReferenceName);
                rows.add(wrap);
                currentCount++;
            }
        }
        return rows;
    }
   
    /*検索結果の設定*/
    public class rowWrapper{
        public Sobject rec {get; set;}
        public Integer rowNumber {get; set;}
        public List<Sobject> partsNoRecs{get; set;}

        public rowWrapper(Sobject rec, Integer rowNumber, String childReferenceName){
            this.rec = rec;
            this.rowNumber = rowNumber;
            List<Sobject> children = rec.getSobjects(childReferenceName);
            String targetField;
            if (childReferenceName == 'SalesOrderLines__r') {
                targetField = 'PositionText__c';
            } else if (childReferenceName == 'ServiceOrderControls__r') {
                targetField = 'SetNo__c';
            }
            if (children == null) {
                children = new List<Sobject>();
            }
            Map<String, Sobject> targetChildren = new Map<String, Sobject>();
            for (Sobject child: children) {
                Sobject productItem = (Sobject)child.getSobject('ProductItem__r');
                if (productItem != null) {
                    String partsNo = (String) productItem.get('name');
                    if (targetChildren.containsKey(partsNo)) {
                        Sobject compareChild = targetChildren.get(partsNo);
                        if ((String)compareChild.get(targetField) > (String)child.get(targetField)) {
                            targetChildren.put(partsNo, child);
                        }
                    } else {
                        targetChildren.put(partsNo, child);
                    }
                }
            }
            partsNoRecs = targetChildren.values();
        }
    }
    
    public void nextAndSaveCurrentPageNumber() {
        next();
        setCookieCurrentPageNumber();
    }
    public void previousAndSaveCurrentPageNumber() {
        previous();
        setCookieCurrentPageNumber();
    }
    public void firstAndSaveCurrentPageNumber() {
        first();
        setCookieCurrentPageNumber();
    }
    public void lastAndSaveCurrentPageNumber() {
        last();
        setCookieCurrentPageNumber();
    }
    public void setJumpSaveCurrentPageSize() {
        jump();
        setCookieCurrentPageSize();
        setCookieCurrentPageNumber();
    }
    public void setSizeSaveCurrentPageSize() {
        changeSize();
        setCookieCurrentPageSize();
        setCookieCurrentPageNumber();
    }
    private void setCookieCurrentPageNumber() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(ssc.getPageNumber()), COOKIE_PATH, -1, true)});
        }
    }
    private void setCookieCurrentPageSize() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(ssc.getPageSize()), COOKIE_PATH, -1, true)});
        }
    }

    public List<String> getWhereStrList_Sales() {
        List<String> whereStrList = new List<String>();

        //販売オーダはパーツサプライのみを検索する
        whereStrList.add(' SalesOrderTypeCode__c IN (\'5A7\', \'2A2\') ');

        if (String.isNotBlank(customerOrderNo_sales)) {
            whereStrList.add(JEOLUtil.appendEqualText('CustomerOrder__c', customerOrderNo_sales));
        }
        if (String.isNotBlank(Seban_sales)) {
            whereStrList.add(JEOLUtil.appendLikeText('ProductNumber__c', Seban_sales));
        }
        if (String.isNotBlank(Area_sales)) {
            whereStrList.add(JEOLUtil.appendEqualText('Area__c', Area_sales));
        }
        if (String.isNotBlank(UserCode_sales)) {
            whereStrList.add(JEOLUtil.appendEqualText('SalesStaffCode__c', UserCode_sales));
        }
        if (AccountType_sales == ACCOUNT_TYPE_SALES) {
            if (String.isNotBlank(AccountCode_sales)) {
                whereStrList.add(JEOLUtil.appendAfterLikeText('SalesAccount__r.Code__c', AccountCode_sales));
            }
            if (String.isNotBlank(AccountName_sales)) {
                whereStrList.add(JEOLUtil.appendLikeText('SalesAccount__r.name', AccountName_sales));
            }
            if (String.isNotBlank(AccountPhone_sales)) {
                whereStrList.add(JEOLUtil.appendEqualText('SalesAccount__r.Phone', AccountPhone_sales));
            }
        } else if (AccountType_sales == ACCOUNT_TYPE_DELIVERY) {
            if (String.isNotBlank(AccountCode_sales)) {
                whereStrList.add(JEOLUtil.appendAfterLikeText('ShipmentAccount__r.Code__c', AccountCode_sales));
            }
            if (String.isNotBlank(AccountName_sales)) {
                whereStrList.add(JEOLUtil.appendLikeText('ShipmentAccount__r.name', AccountName_sales));
            }
            if (String.isNotBlank(AccountPhone_sales)) {
                whereStrList.add(JEOLUtil.appendEqualText('ShipmentAccount__r.Phone', AccountPhone_sales));
            }
        }
        if (String.isNotBlank(PartsNo_sales)) {
            Set<String> parentIds = new Set<String>();
            for (SalesOrderLine__c rec: [SELECT SalesOrderLink__c FROM SalesOrderLine__c WHERE ProductItem__r.name =: PartsNo_sales]) {
                parentIds.add(rec.SalesOrderLink__c);
            }
            whereStrList.add(JEOLUtil.appendInText('Id', new List<String>(parentIds)));
        }
        
        return whereStrList;
    }
    
    public List<String> getWhereStrList_Service() {
        List<String> whereStrList = new List<String>();
        if (String.isNotBlank(customerOrderNo_service)) {
            whereStrList.add(JEOLUtil.appendEqualText('CustomerOrder__c', customerOrderNo_service));
        }
        if (String.isNotBlank(callCenterReceptionNo_service)) {
            whereStrList.add(JEOLUtil.appendEqualText('CallCenterReceptionNo__c', callCenterReceptionNo_service));
        }
        if (String.isNotBlank(unitBody_service)) {
            whereStrList.add(JEOLUtil.appendLikeText('Customer__r.UnitBodyLink__r.UnitBody__c', unitBody_service));
        }
        if (String.isNotBlank(KishuRyakushou_service)) {
            whereStrList.add(JEOLUtil.appendLikeText('Customer__r.UnitBodyLink__r.ModelName__c', KishuRyakushou_service));
        }
        if (String.isNotBlank(Seban_service)) {
            whereStrList.add(JEOLUtil.appendLikeText('ProductNo__c', Seban_service));
        }
        if (String.isNotBlank(Area_service)) {
            whereStrList.add(JEOLUtil.appendEqualText('Center__c', Area_service));
        }
        if (String.isNotBlank(UserCode_service)) {
            whereStrList.add(JEOLUtil.appendAfterLikeText('SalesStaffCode__c', UserCode_service));
        }
        if (String.isNotBlank(PartsClass_service)) {
            if (PartsClass_service == PARTS_CLASS_PARTS_ONLY) {
                //whereStrList.add(JEOLUtil.appendAfterLikeText('name', 'H'));  //Comment out for spec update by mkubomura 20150821

                /* この方式ではインデックスが効かず、フルスキャンになるため、レコードが増えると将来的にタイムアウト
                 * が起きることが予想される。タイムアウトした場合は、SFDCサポートに問合せ、Nameにインデックスを張る
                 * ことで対応できるか、もしくは数式を作ってカスタムインデックスをつけるかどちらが効果があるか、確認して
                 * インデックス対応する。
                 */ 
                whereStrList.add('( (not name like \'H%\') and (not name like \'S%\') )'); //Added by mkubomura 20150821
            }
            if (PartsClass_service == PARTS_CLASS_SWAP_ONLY) {

                //whereStrList.add(JEOLUtil.appendAfterLikeText('name', 'S'));
                /* タイムアウトに対するインデックスは上記の対応と同じ */
                whereStrList.add('( name like \'H%\'or name like \'S%\')'); //Added by mkubomura 20150821
            }
        }
        if (AccountType_service == ACCOUNT_TYPE_SALES) {
            if (String.isNotBlank(AccountCode_service)) {
                whereStrList.add(JEOLUtil.appendAfterLikeText('SalesAccount__r.Code__c', AccountCode_service));
            }
            if (String.isNotBlank(AccountName_service)) {
                whereStrList.add(JEOLUtil.appendLikeText('SalesAccount__r.name', AccountName_service));
            }
            if (String.isNotBlank(AccountPhone_service)) {
                whereStrList.add(JEOLUtil.appendEqualText('SalesAccount__r.Phone', AccountPhone_service));
            }
        } else if (AccountType_service == ACCOUNT_TYPE_DELIVERY) {
            if (String.isNotBlank(AccountCode_service)) {
                whereStrList.add(JEOLUtil.appendAfterLikeText('ShipmentAccount__r.Code__c', AccountCode_service));
            }
            if (String.isNotBlank(AccountName_service)) {
                whereStrList.add(JEOLUtil.appendLikeText('ShipmentAccount__r.name', AccountName_service));
            }
            if (String.isNotBlank(AccountPhone_service)) {
                whereStrList.add(JEOLUtil.appendEqualText('ShipmentAccount__r.Phone', AccountPhone_service));
            }
        }
        if (String.isNotBlank(PartsNo_service)) {
            Set<String> parentIds = new Set<String>();
            for (ServiceOrderControl__c rec: [SELECT ServiceOrder__c FROM ServiceOrderControl__c WHERE ProductItem__r.name =: PartsNo_service]) {
                parentIds.add(rec.ServiceOrder__c);
            }
            whereStrList.add(JEOLUtil.appendInText('Id', new List<String>(parentIds)));
        }
        return whereStrList;
    }

}