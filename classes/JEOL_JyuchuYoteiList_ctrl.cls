public with sharing class JEOL_JyuchuYoteiList_ctrl extends JEOL_SearchBase_ctrl {
    
    public String eigyoTantoshaCode{get; set;}
    public String eigyoTantoshaName{get; set;}
    public String customerCode{get; set;}
    public String customerName{get; set;}
    public String customerCategory{get; set;}
    public String series{get; set;}
    public String region{get; set;}
    public String shohinName{get; set;}
    public String jutyuyoteiYearFrom{get; set;}
    public String jutyuyoteiYearTo{get; set;}

    private static final String COOKIE_LABLE_EIGYOTANTOSHA_CODE = 'eigyoTantoshaCode';
    private static final String COOKIE_LABLE_EIGYOTANTOSHA_NAME = 'eigyoTantoshaName';
    private static final String COOKIE_LABLE_CUSTOMER_CODE = 'customerCode';
    private static final String COOKIE_LABLE_CUSTOMER_NAME = 'customerName';
    private static final String COOKIE_LABLE_CUSTOMER_CATEGORY = 'customerCategory';
    private static final String COOKIE_LABLE_SERIES = 'series';
    private static final String COOKIE_LABLE_REGION = 'region';
    private static final String COOKIE_LABLE_SHOHIN_NAME = 'shohinName';
    private static final String COOKIE_LABLE_JUTYU_YEAR_FROM = 'jutyuyoteiYearFrom';
    private static final String COOKIE_LABLE_JUTYU_YEAR_TO = 'jutyuyoteiYearTo';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOL_JyuchuYoteiListPage';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }
    
    public List<SelectOption> getRegionOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTATION_AREA_CODE);
    }
    
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }


    // 画面起動時検索フラグ（'true'の場合に検索する）
    private String initSearchFlg = '';

    // エラーフラグ
    private Boolean errFlg = false;

    public JEOL_JyuchuYoteiList_ctrl() {
        orderBy= 'name';
        currentOrder = 'name';
        orderDesc = false;
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }
        
    }
    
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        if(cookies.containsKey(COOKIE_LABLE_EIGYOTANTOSHA_CODE)){
            this.eigyoTantoshaCode = cookies.get(COOKIE_LABLE_EIGYOTANTOSHA_CODE).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_EIGYOTANTOSHA_NAME)) {
            this.eigyoTantoshaName = cookies.get(COOKIE_LABLE_EIGYOTANTOSHA_NAME).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_CUSTOMER_CODE)) {
            this.customerCode = cookies.get(COOKIE_LABLE_CUSTOMER_CODE).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_CUSTOMER_NAME)) {
            this.customerName = cookies.get(COOKIE_LABLE_CUSTOMER_NAME).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_CUSTOMER_CATEGORY)) {
            this.customerCategory = cookies.get(COOKIE_LABLE_CUSTOMER_CATEGORY).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_SERIES)) {
            this.series = cookies.get(COOKIE_LABLE_SERIES).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_REGION)) {
            this.region = cookies.get(COOKIE_LABLE_REGION).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_SHOHIN_NAME)) {
            this.shohinName = cookies.get(COOKIE_LABLE_SHOHIN_NAME).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_JUTYU_YEAR_FROM)) {
            this.jutyuyoteiYearFrom = cookies.get(COOKIE_LABLE_JUTYU_YEAR_FROM).getValue();
        }
        if (cookies.containsKey(COOKIE_LABLE_JUTYU_YEAR_TO)) {
            this.jutyuyoteiYearTo = cookies.get(COOKIE_LABLE_JUTYU_YEAR_TO).getValue();
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
    
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        
        cookies.add(new Cookie(COOKIE_LABLE_EIGYOTANTOSHA_CODE, this.eigyoTantoshaCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_EIGYOTANTOSHA_NAME, this.eigyoTantoshaName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_CUSTOMER_CODE, this.customerCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_CUSTOMER_NAME, this.customerName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_CUSTOMER_CATEGORY, this.customerCategory, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_SERIES, this.series, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_REGION, this.region, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_SHOHIN_NAME, this.shohinName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_JUTYU_YEAR_FROM, this.jutyuyoteiYearFrom, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABLE_JUTYU_YEAR_TO, this.jutyuyoteiYearTo, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        
        Apexpages.currentPage().setCookies(cookies);
    }
    
    protected override void setStandardSetController() {
        String soql = ' SELECT ' +
                    ' Id, Name, SalesOrder__c, ShodanStatus__c, Series__c, EigyoTantoshaMain__r.Name, RegionName__c, ' +
                    ' CustomerAccount__c, CustomerAccount__r.name, CustomerAccountCode__c, ShohinName__c, JishaPrice__c, ' +
                    ' YosanKakudoValue__c, JuchuKakudoValue__c, JuchuYoteiTsuki__c, CreatedDateFormula__c, CurrencyIsoCode, ' +
                    ' Quotation__c, Quotation__r.Name, RecordType.DeveloperName ' +
                ' FROM ' +
                    ' SalesPipeline__c ';
                    

        List<String> whereStrElems = getWhereStrList();
        if (whereStrElems.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrElems);
        }

        soql += ' ORDER BY ' + this.orderBy;
        if (this.orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000 ';
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(soql));

        if (this.errFlg) {
            ssc = null;
        } else if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }
    
    public void doFormClear() {
        eigyoTantoshaCode = null;
        eigyoTantoshaName = null;
        customerCode = null;
        customerName = null;
        customerCategory = null;
        series = null;
        region = null;
        shohinName = null;
        jutyuyoteiYearFrom = null;
        jutyuyoteiYearTo = null;
        ssc = null;
        this.pageNo = 1;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        saveInputValues();
    }
    
    /*  検索結果の取得   */
    public List<rowWrapper> getSalesPipelines() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;
        
        if(ssc != null) {
            for (SalesPipeline__c row: (List<SalesPipeline__c>)ssc.getRecords()) {
                rowWrapper orderPlan = new rowWrapper(row, currentCount);
                rows.add(orderPlan);
                currentCount++;
            }
        }
        return rows;
    }
    /*  検索結果の設定　*/
    public class rowWrapper{
        public SalesPipeline__c rec {get; set;}
        public Integer rowNumber {get; set;}
        
        public rowWrapper(SalesPipeline__c rec, Integer rowNumber) {
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
    }
    public void doSearch() {
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        orderBy= 'name';
        currentOrder = 'name';
        orderDesc = false;
        
        setStandardSetController();
        if(ssc != null) {
            ssc.setPageNumber(1);
        }
        saveInputValues();
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

    private List<String> getWhereStrList() {
        this.errFlg = false;  // エラーフラグ初期化
        List<String> strList = new List<String>();
        if (String.isNotBlank(this.eigyoTantoshaCode)) {
            strList.add(JEOLUtil.appendAfterLikeText('EigyoTantoshaMain__r.UserCode__c', this.eigyoTantoshaCode));
        }
        if (String.isNotBlank(this.eigyoTantoshaName)) {
            strList.add(JEOLUtil.appendLikeText('EigyoTantoshaMain__r.Name', this.eigyoTantoshaName));
        }
        if (String.isNotBlank(this.customerCode)) {
            strList.add(JEOLUtil.appendAfterLikeText('CustomerAccount__r.Code__c', this.customerCode));
        }
        if (String.isNotBlank(this.customerName)) {
            strList.add(JEOLUtil.appendLikeText('CustomerAccount__r.name', this.customerName));
        }
        if (String.isNotBlank(this.series)) {
            strList.add(JEOLUtil.appendEqualText('Series__c', this.series));
        }
        if (String.isNotBlank(this.region)) {
            strList.add(JEOLUtil.appendEqualText('RegionName__c', this.region));
        }
        if (String.isNotBlank(this.shohinName)) {
            strList.add(JEOLUtil.appendLikeText('ShohinName__c', this.shohinName));
        }
        if (String.isNotBlank(this.jutyuyoteiYearFrom)) {
            if (this.jutyuyoteiYearFrom.isNumeric()) {
                strList.add(JEOLUtil.appendGreaterThanEqualText('JuchuYoteiTsuki__c', this.jutyuyoteiYearFrom + '00'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '年度は数字で入力してください。'));
                this.errFlg = true;
            }
        }
        if (String.isNotBlank(this.jutyuyoteiYearTo)) {
            if (this.jutyuyoteiYearTo.isNumeric()) {
                strList.add(JEOLUtil.appendLessThanEqualText('JuchuYoteiTsuki__c', this.jutyuyoteiYearTo + '99'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '年度は数字で入力してください。'));
                this.errFlg = true;
            }
        }
        if (String.isNotBlank(this.jutyuyoteiYearTo) || String.isNotBlank(this.jutyuyoteiYearFrom)) {
            strList.add(' JuchuYoteiTsuki__c != NULL ');
        }
        if (String.isNotBlank(this.customerCategory)) {
            List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory);
            strList.add(JEOLUtil.appendInText('CustomerAccount__c', accIdList));
            strList.add(' CustomerAccount__c != null ');
        }
        
        return strList;
    }
}