public with sharing class JEOL_MitsumoriList_ctrl extends JEOL_SearchBase_ctrl {

    // 検索条件の項目
    public String eigyoTantoCode { get; set; }
    public String eigyoTantoName { get; set; }
    public String hanbaisakiCode { get; set; }
    public String hanbaisakiName { get; set; }
    public String shukkasakiCode { get; set; }
    public String shukkasakiName { get; set; }
    public String customerCategory { get; set; }
    public String keiretsu{ get; set; }
    public String tiki { get; set; }
    public String mitsumoriType { get; set; }
    public String mitsumoriNo { get; set; }
    public String kMitsumoriNo { get; set; }
    public String shohinName { get; set; }
    public String RegisteredDateFrom { get; set;}
    public String RegisteredDateTo { get; set;}
    public String userNo {get; set;}
    
    private static final String COOKIE_LABEL_EIGYOTANTO_CODE = 'eigyoTantoCode';
    private static final String COOKIE_LABEL_EIGYOTANTO_NAME = 'eigyoTantoName';
    private static final String COOKIE_LABEL_HANBAISAKI_CODE = 'hanbaisakiCode';
    private static final String COOKIE_LABEL_HANBAISAKI_NAME = 'hanbaisakiName';
    private static final String COOKIE_LABEL_SHUKKASAKI_CODE = 'shukkasakiCode';
    private static final String COOKIE_LABEL_SHUKKASAKI_NAME = 'shukkasakiName';
    private static final String COOKIE_LABEL_KEIRETSU = 'keiretsu';
    private static final String COOKIE_LABEL_TIKI = 'tiki';
    private static final String COOKIE_LABEL_MITSUMORI_TYPE = 'mitsumoriType';
    private static final String COOKIE_LABEL_MITSUMORI_NO = 'mitsumoriNo';
    private static final String COOKIE_LABEL_KOKYAKU_MITSUMORI_NO = 'kMitsumoriNo';
    private static final String COOKIE_LABEL_SHOHIN_NAME = 'shohinName';
    private static final String COOKIE_LABEL_REGISTEREDDATE_FROM = 'RegisteredDateFrom';
    private static final String COOKIE_LABEL_REGISTEREDDATE_TO = 'RegisteredDateTo';
    private static final String COOKIE_LABEL_USER_NO = 'userNo';
    private static final String COOKIE_LABEL_CUSTOMER_CATEGORY = 'customerCategory';
    private static final String COOKIE_PATH = '/apex/JEOL_MitsumoriListPage';

    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    public String criteriaText {get; private set;}

    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';

    // 検索エラーフラグ
    public Boolean errFlg = false;

    public JEOL_MitsumoriList_ctrl() {
        orderBy= 'name';
        currentOrder = 'name';
        orderDesc = false;
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }

    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {

        // エラーフラグ初期化
        errFlg = false;

        String soql = ' SELECT ' +
                    ' id, EigyoTantoshaName__c, EigyoTantoshaCode__c, MitsumoriSogaku__c, HyomenNebikiRitsu__c, ' +
                    ' Keiyakusaki__r.name, Keiyakusaki__r.Code__c, Nonyusaki__r.name, Nonyusaki__r.Code__c, CreatedUserCode__c, ' +
                    ' Series__c, Region__c, RegionName__c, MitsumoriShubetsuName__c, name, BranchNo__c, TitleShohinName__c, KyakusakiMitsumoriIraiNo__c, ' +
                    ' RegisteredDateFormula__c, OrderPlan__c, OrderPlan__r.name, SalesOrder__c, SalesOrder__r.name, CurrencyIsoCode ' +
                ' FROM ' +
                    ' Quote__c ';

        String criteria = '';
        Boolean CategoryNotFountFlg = false;
        
        List<String> whereStrElems = getWhereStrList();
        if (whereStrElems.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrElems);
        }
        
        soql += ' ORDER BY ' + orderBy;
        if (orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000 ';

        ssc = new ApexPages.StandardSetController (Database.getQueryLocator(soql));
        
        if (CategoryNotFountFlg || errFlg) {
            ssc = null;
        } else if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }

    //画面の検索ボタンから呼ばれるメソッド
    public void doSearch() {

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        orderBy= 'name';
        currentOrder = 'name';
        orderDesc = false;
        
        setStandardSetController();
        if(ssc != null) {
            ssc.setPageNumber(1);
        }
        saveInputValues();
    }
    
    public void doFormClear() {
        eigyoTantoCode = null;
        eigyoTantoName = null;
        hanbaisakiCode = null;
        hanbaisakiName = null;
        shukkasakiCode = null;
        shukkasakiName = null;
        customerCategory = null;
        keiretsu = null;
        tiki = null;
        mitsumoriType = null;
        mitsumoriNo = null;
        kMitsumoriNo = null;
        shohinName = null;
        RegisteredDateFrom = null;
        RegisteredDateTo = null;
        userNo = null;
        ssc = null;

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        saveInputValues();
    }
    
    public List<SelectOption> getRegionOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_AREA);
    }
    
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }

    public List<SelectOption> getQuoteTypeOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTE_TYPE);
    }

    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_EIGYOTANTO_CODE, this.eigyoTantoCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_EIGYOTANTO_NAME, this.eigyoTantoName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_HANBAISAKI_CODE, this.hanbaisakiCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_HANBAISAKI_NAME, this.hanbaisakiName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHUKKASAKI_CODE, this.shukkasakiCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHUKKASAKI_NAME, this.shukkasakiName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_KEIRETSU, this.keiretsu, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_TIKI, this.tiki, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_MITSUMORI_TYPE, this.mitsumoriType, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_MITSUMORI_NO, this.mitsumoriNo, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_KOKYAKU_MITSUMORI_NO, this.kMitsumoriNo, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHOHIN_NAME, this.shohinName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_USER_NO, this.userNo, COOKIE_PATH, -1, true));
        
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMER_CATEGORY, this.customerCategory, COOKIE_PATH, -1, true));

        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        String fromDateStr;
        if (this.RegisteredDateFrom != null) {
            fromDateStr = RegisteredDateFrom.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_FROM, fromDateStr, COOKIE_PATH, -1, true));

        String toDateStr;
        if (this.RegisteredDateTo != null) {
            toDateStr = this.RegisteredDateTo.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_TO, toDateStr, COOKIE_PATH, -1, true));
    
        Apexpages.currentPage().setCookies(cookies);

    }

    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();

        Boolean hasSearchValues = false;
        if(cookies.containsKey(COOKIE_LABEL_EIGYOTANTO_CODE)){
            this.eigyoTantoCode = cookies.get(COOKIE_LABEL_EIGYOTANTO_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_EIGYOTANTO_NAME)){
            this.eigyoTantoName = cookies.get(COOKIE_LABEL_EIGYOTANTO_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_HANBAISAKI_CODE)){
            this.hanbaisakiCode = cookies.get(COOKIE_LABEL_HANBAISAKI_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_HANBAISAKI_NAME)){
            this.hanbaisakiName = cookies.get(COOKIE_LABEL_HANBAISAKI_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SHUKKASAKI_CODE)){
            this.shukkasakiCode = cookies.get(COOKIE_LABEL_SHUKKASAKI_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SHUKKASAKI_NAME)){
            this.shukkasakiName = cookies.get(COOKIE_LABEL_SHUKKASAKI_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_KEIRETSU)){
            this.keiretsu = cookies.get(COOKIE_LABEL_KEIRETSU).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_TIKI)){
            this.tiki = cookies.get(COOKIE_LABEL_TIKI).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_MITSUMORI_TYPE)){
            this.mitsumoriType = cookies.get(COOKIE_LABEL_MITSUMORI_TYPE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_MITSUMORI_NO)){
            this.mitsumoriNo = cookies.get(COOKIE_LABEL_MITSUMORI_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_KOKYAKU_MITSUMORI_NO)){
            this.kMitsumoriNo = cookies.get(COOKIE_LABEL_KOKYAKU_MITSUMORI_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SHOHIN_NAME)){
            this.shohinName = cookies.get(COOKIE_LABEL_SHOHIN_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_REGISTEREDDATE_FROM)){
            this.RegisteredDateFrom = cookies.get(COOKIE_LABEL_REGISTEREDDATE_FROM).getValue().replaceAll('-', '/');
        }
        if(cookies.containsKey(COOKIE_LABEL_REGISTEREDDATE_TO)){
            this.RegisteredDateTo = cookies.get(COOKIE_LABEL_REGISTEREDDATE_TO).getValue().replaceAll('-', '/');
        }
        if(cookies.containsKey(COOKIE_LABEL_USER_NO)){
            this.userNo = cookies.get(COOKIE_LABEL_USER_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_CUSTOMER_CATEGORY)){
            this.customerCategory = cookies.get(COOKIE_LABEL_CUSTOMER_CATEGORY).getValue();
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
    public List<rowWrapper> getQuotes() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;
        
        if (ssc != null) {
            for (Quote__c row : (List<Quote__c>)ssc.getRecords()) {
                rowWrapper wrap = new rowWrapper(row, currentCount);
                rows.add(wrap);
                currentCount++;
            }
        }
        return rows;
    }
    
    /*検索結果の設定*/
    public class rowWrapper{
        public Quote__c rec {get; set;}
        public Integer rowNumber {get; set;}
        
        public rowWrapper(Quote__c rec, Integer rowNumber) {
            this.rec = rec;
            this.rowNumber = rowNumber;
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

    private List<String> getWhereStrList() {
        List<String> strList = new List<String>();
        if (String.isNotBlank(this.eigyoTantoCode)) {
            strList.add(JEOLUtil.appendAfterLikeText('EigyoTantoshaCode__c', this.eigyoTantoCode));
        }
        if (String.isNotBlank(this.eigyoTantoName)) {
            strList.add(JEOLUtil.appendLikeText('EigyoTantoshaName__c', this.eigyoTantoName));
        }
        if (String.isNotBlank(this.hanbaisakiCode)) {
            strList.add(JEOLUtil.appendAfterLikeText('Keiyakusaki__r.Code__c', this.hanbaisakiCode));
        }
        if (String.isNotBlank(this.hanbaisakiName)) {
            strList.add(JEOLUtil.appendLikeText('Keiyakusaki__r.name', this.hanbaisakiName));
        }
        if (String.isNotBlank(this.shukkasakiCode)) {
            strList.add(JEOLUtil.appendAfterLikeText('Nonyusaki__r.Code__c', this.shukkasakiCode));
        }
        if (String.isNotBlank(this.shukkasakiName)) {
            strList.add(JEOLUtil.appendLikeText('Nonyusaki__r.name', this.shukkasakiName));
        }
        if (String.isNotBlank(this.keiretsu)) {
            strList.add(JEOLUtil.appendEqualText('Series__c', this.keiretsu));
        }
        if (String.isNotBlank(this.tiki)) {
            strList.add(JEOLUtil.appendEqualText('RegionName__c', this.tiki));
        }
        if (String.isNotBlank(this.mitsumoriType)) {
            strList.add(JEOLUtil.appendEqualText('MitsumoriShubetsu__c', this.mitsumoriType));
        }
        if (String.isNotBlank(this.mitsumoriNo)) {
            strList.add(JEOLUtil.appendEqualText('name', this.mitsumoriNo));
        }
        if (String.isNotBlank(this.kMitsumoriNo)) {
            strList.add(JEOLUtil.appendEqualText('KyakusakiMitsumoriIraiNo__c', this.kMitsumoriNo));
        }
        if (String.isNotBlank(this.shohinName)) {
            strList.add(JEOLUtil.appendLikeText('TitleShohinName__c', this.shohinName));
        }
        if (String.isNotBlank(this.userNo)) {
            strList.add(JEOLUtil.appendAfterLikeText('CreatedUserCode__c', this.userNo));
        }
        try {
            if (String.isNotBlank(this.RegisteredDateFrom)) {
                Date fromDate = Date.parse(RegisteredDateFrom);
                strList.add(JEOLUtil.appendGreaterThanEqualText('RegisteredDateFormula__c', fromDate.format().replaceAll('/', '-'), false));
            }
            if (String.isNotBlank(this.RegisteredDateTo)) {
                Date toDate = Date.parse(RegisteredDateTo);
                strList.add(JEOLUtil.appendLessThanEqualText('RegisteredDateFormula__c', toDate.format().replaceAll('/', '-'), false));
            }
            if (String.isNotBlank(this.RegisteredDateFrom) || String.isNotBlank(this.RegisteredDateTo)){
                strList.add(' RegisteredDateFormula__c != null ');
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '登録日は半角の「年/月/日」で入力してください。'));
            errFlg = true;
        }
        if (String.isNotBlank(this.customerCategory)) {
            List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory);
            String keiyaku = JEOLUtil.appendInText('Keiyakusaki__c', accIdList);
            String Nonyusaki = JEOLUtil.appendInText('Nonyusaki__c', accIdList);
            strList.add('(' + keiyaku + ' OR ' + Nonyusaki + ')');
            strList.add(' Keiyakusaki__c != null ');
            strList.add(' Nonyusaki__c != null ');
        }

        return strList;
    }
}