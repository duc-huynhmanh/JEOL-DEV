public with sharing class JEOL_HanbaiList_ctrl extends JEOL_SearchBase_ctrl {


    private static final String COOKIE_PATH = '/apex/JEOL_HanbaiListPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';

    // 検索条件の項目
    public String kigyoTani { get; set; }
    public String eTantoCode { get; set; }
    public String eTantoName { get; set; }
    public String hanbaisakiCode { get; set; }
    public String hanbaisakiNameHan { get; set; }
    public String hanbaisakiName { get; set; }
    public String shukkasakiCode { get; set; }
    public String shukkasakiNameHan { get; set; }
    public String shukkasakiName { get; set; }
    public String customerCategory { get; set; }
    public String orderType { get; set; }
    public String keiretsu { get; set; }
    public String tiki { get; set; }
    public String shohinName { get; set; }
    public String goki { get; set; }
    public Boolean isExcludePartsSupply{get; set;}

    // 地域選択リスト値取得
    public List<SelectOption> getRegionOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_AREA);
    }
    // 系列選択リスト値取得
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }
    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }
    // 販売オーダタイプ選択リスト値取得
    public List<SelectOption> getOrderTypeOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SALES_ORDER_TYPE);
    }
    // 企業単位選択リスト値取得
    public List<SelectOption> getOrgUnitOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_ORG_UNIT);
    }

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';

    /**
    *  コンストラクタ
    */
    public JEOL_HanbaiList_ctrl() {
        orderBy= 'CompanyUnit__c, OrderYear__c, Name';
        currentOrder = 'CompanyUnit__c, OrderYear__c, Name';
        orderDesc = true;
        this.isExcludePartsSupply= true;
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }
    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {

        // SOQLを作成する
        String soql = ' SELECT ' +
                            ' Id, ' +
                            ' CurrencyIsoCode, ' +
                            ' SalesOrderType__c, ' +
                            ' ContractsDivision__c, ' +
                            ' Name, ' +
                            ' Area__c, ' +
                            ' SalesStaff__c, ' +
                            ' FlagshipProduct__c, ' +
                            ' SalesAccount__c, ' +
                            ' SalesAccountCode__c, ' +
                            ' SalesAccountName__c, ' +
                            ' ShipmentAccount__c, ' +
                            ' ShipmentAccountCode__c, ' +
                            ' ShipmentAccountName__c, ' +
                            ' OrderAmount__c, ' +
                            ' OrderDateFormula__c, ' +
                            ' ConfirmedOrderDateFormula__c, ' +
                            ' SeishikiShoriDateFormula__c ' +
                        ' from ' +
                            ' SalesOrder__c ';

        List<String> whereConditions = new List<String>();
        if (this.isExcludePartsSupply) {
            whereConditions.add(' SalesOrderTypeCode__c NOT IN (\'5A7\', \'2A2\') ');
        }
        if (String.isNotBlank(this.kigyoTani)) {
            whereConditions.add(JEOLUtil.appendLikeText('CompanyUnit__c', this.kigyoTani));
        }
        if (String.isNotBlank(this.eTantoCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('SalesStaffCode__c', this.eTantoCode));
        }
        if (String.isNotBlank(this.eTantoName)) {
            whereConditions.add(JEOLUtil.appendLikeText('SalesStaff__c', this.eTantoName));
        }
        if (String.isNotBlank(this.hanbaisakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('SalesAccountCode__c', this.hanbaisakiCode));
        }
        if (String.isNotBlank(this.hanbaisakiNameHan)) {
            whereConditions.add(JEOLUtil.appendLikeText('SalesAccount__r.NameUpToKana__c', this.hanbaisakiNameHan));
        }
        if (String.isNotBlank(this.hanbaisakiName)) {
            whereConditions.add(JEOLUtil.appendLikeText('SalesAccountName__c', this.hanbaisakiName));
        }
        if (String.isNotBlank(this.shukkasakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('ShipmentAccountCode__c', this.shukkasakiCode));
        }
        if (String.isNotBlank(this.shukkasakiNameHan)) {
            whereConditions.add(JEOLUtil.appendLikeText('ShipmentAccount__r.NameUpToKana__c', this.shukkasakiNameHan));
        }
        if (String.isNotBlank(this.shukkasakiName)) {
            whereConditions.add(JEOLUtil.appendLikeText('ShipmentAccountName__c', this.shukkasakiName));
        }
        if (String.isNotBlank(this.customerCategory)) {
            List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory);
            String sales = JEOLUtil.appendInText('SalesAccount__c', accIdList);
            String shipment = JEOLUtil.appendInText('ShipmentAccount__c', accIdList);
            whereConditions.add('(' + sales + 'OR' + shipment + ')');
            whereConditions.add('SalesAccount__c != null');
            whereConditions.add('ShipmentAccount__c != null');
        }
        if (String.isNotBlank(this.orderType)) {
            whereConditions.add(JEOLUtil.appendEqualText('SalesOrderTypeCode__c', this.orderType));
        }
        if (String.isNotBlank(this.keiretsu)) {
            whereConditions.add(JEOLUtil.appendEqualText('Series__c', this.keiretsu));
        }
        if (String.isNotBlank(this.tiki)) {
            whereConditions.add(JEOLUtil.appendEqualText('Area__c', this.tiki));
        }
        if (String.isNotBlank(this.shohinName)) {
            whereConditions.add(JEOLUtil.appendLikeText('FlagshipProduct__c', this.shohinName));
        }
        if (String.isNotBlank(this.goki)) {
            whereConditions.add(JEOLUtil.appendLikeText('UnitBody__c', this.goki));
        }
        

        soql += JEOLUtil.joinWhereConditions(whereConditions);
        soql += ' ORDER BY ' + orderBy;
        if (orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000 ';

        ssc = new ApexPages.StandardSetController (Database.getQueryLocator(soql));

        if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }

    //画面の検索ボタンから呼ばれるメソッド
    public PageReference search1() {
        search();
        return null;
    }

    //画面のクリアボタンから呼ばれるメソッド
    public void doFormClear() {
        // 検索条件のクリア
        this.kigyoTani = null;
        this.eTantoCode = null;
        this.eTantoName = null;
        this.hanbaisakiCode = null;
        this.hanbaisakiNameHan = null;
        this.hanbaisakiName = null;
        this.shukkasakiCode = null;
        this.shukkasakiNameHan = null;
        this.shukkasakiName = null;
        this.customerCategory = null;
        this.orderType = null;
        this.keiretsu = null;
        this.tiki = null;
        this.shohinName = null;
        this.goki = null;
        this.isExcludePartsSupply = true;

        //ページ初期化
        pageNo = 1;
        pageSize = 50;
        
        // 検索結果のクリア
        ssc = null;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        // 検索条件のCookie保存
        saveInputValues();
    }

    /**
     *  検索（StandardSetController初期化）
     */
    private void search() {
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        setStandardSetController();
        if (ssc != null) {
            ssc.setPageNumber(1);
        }
        // 検索条件のCookie保存
        saveInputValues();
    }

    //検索条件保持
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        
        cookies.add(new Cookie('kigyoTani', this.kigyoTani, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('eTantoCode', this.eTantoCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('eTantoName', this.eTantoName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiCode', this.hanbaisakiCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiNameHan', this.hanbaisakiNameHan, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiName', this.hanbaisakiName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiCode', this.shukkasakiCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiNameHan', this.shukkasakiNameHan, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiName', this.shukkasakiName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerCategory', this.customerCategory, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('orderType', this.orderType, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('keiretsu', this.keiretsu, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('tiki', this.tiki, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shohinName', this.shohinName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('goki', this.goki, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('isExcludePartsSupply', (this.isExcludePartsSupply ? 'true' : 'false'), COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, initSearchFlg, COOKIE_PATH, -1, true));
        
        Apexpages.currentPage().setCookies(cookies);

    }

    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();

        Boolean hasSearchValues = false;

        if(cookies.containsKey('kigyoTani')){
            this.kigyoTani = cookies.get('kigyoTani').getValue();
        }
        if(cookies.containsKey('eTantoCode')){
            this.eTantoCode = cookies.get('eTantoCode').getValue();
        }
        if(cookies.containsKey('eTantoName')){
            this.eTantoName = cookies.get('eTantoName').getValue();
        }
        if(cookies.containsKey('hanbaisakiCode')){
            this.hanbaisakiCode = cookies.get('hanbaisakiCode').getValue();
        }
        if(cookies.containsKey('hanbaisakiNameHan')){
            this.hanbaisakiNameHan = cookies.get('hanbaisakiNameHan').getValue();
        }
        if(cookies.containsKey('hanbaisakiName')){
            this.hanbaisakiName = cookies.get('hanbaisakiName').getValue();
        }
        if(cookies.containsKey('shukkasakiCode')){
            this.shukkasakiCode = cookies.get('shukkasakiCode').getValue();
        }
        if(cookies.containsKey('shukkasakiNameHan')){
            this.shukkasakiNameHan = cookies.get('shukkasakiNameHan').getValue();
        }
        if(cookies.containsKey('shukkasakiName')){
            this.shukkasakiName = cookies.get('shukkasakiName').getValue();
        }
        if(cookies.containsKey('customerCategory')){
            this.customerCategory = cookies.get('customerCategory').getValue();
        }
        if(cookies.containsKey('orderType')){
            this.orderType = cookies.get('orderType').getValue();
        }
        if(cookies.containsKey('keiretsu')){
            this.keiretsu = cookies.get('keiretsu').getValue();
        }
        if(cookies.containsKey('keiretsu')){
            this.keiretsu = cookies.get('keiretsu').getValue();
        }
        if(cookies.containsKey('tiki')){
            this.tiki = cookies.get('tiki').getValue();
        }
        if(cookies.containsKey('shohinName')){
            this.shohinName = cookies.get('shohinName').getValue();
        }
        if(cookies.containsKey('goki')){
            this.goki = cookies.get('goki').getValue();
        }
        if(cookies.containsKey('isExcludePartsSupply')){
            this.isExcludePartsSupply = (cookies.get('isExcludePartsSupply').getValue() == 'true');
        }
        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER)){
            pageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        if(cookies.containsKey(COOKIE_LABEL_PAGE_SIZE)){
            pageSize = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue());
        }
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }        
        return hasSearchValues;
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

    /**
    *  検索内容の取得
    */
     public List<rowWrapper> getSalesOrderList(){
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;

        if (ssc != null){
            for (SalesOrder__c row: (List<SalesOrder__c>)ssc.getRecords()){
                rowWrapper wrap = new rowWrapper(row, currentCount);
                rows.add(wrap);
                currentCount++;
            }
        }
        return rows;
    }

    /**
    *  検索結果の設定
    */
    public class rowWrapper{
        public SalesOrder__c rec {get; set;}
        public Integer rowNumber {get; set;}
        
        public rowWrapper(SalesOrder__c rec, Integer rowNumber){
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
    }

}