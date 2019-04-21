public with sharing class JEOL_NonyusakiList_ctrl extends JEOL_SearchBase_ctrl {

    // 定数
    private static final String STATUS_OF_USE_ALL = 'all';  // 使用状況　すべて　value
    private static final String STATUS_OF_USE_ALL_LABEL = 'すべて';  // 使用状況　すべて　表示文言
    private static final String STATUS_OF_USE_USING = 'using';  // 使用状況　使用中　value
    private static final String STATUS_OF_USE_USING_LABEL = '使用中';  // 使用状況　使用中　表示文言
    //使用, 常時使用, 適用なし, 廃棄    , 未使用
    private static final String STATUS_OF_USE_USING_SEARCH = '(\'使用\',\'常時使用\')';  // 使用状況　使用中　検索条件
    private static final String STATUS_OF_USE_NO_SEARCH = '(\'9\',\'35\')';  // 使用状況　検索対象外

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_NonyusakiListPage';  // PATH
    private static final String COOKIE_LABEL_NONYUSAKI_NAME = 'nonyusakiName';  // 納入先名称
    private static final String COOKIE_LABEL_NONYUSAKI_NAME_H = 'nonyusakiNameHankaku';  // 納入先名称（半角）
    private static final String COOKIE_LABEL_NONUSAKI_CODE = 'nonyusakiCode';  // 納入先コード
    private static final String COOKIE_LABEL_SERIES_PI = 'seriesPI';  // 系列
    private static final String COOKIE_LABEL_SHIP_DATE_FROM = 'shipDateFrom';  // 出荷年月From
    private static final String COOKIE_LABEL_SHIP_DATE_TO = 'shipDateTo';  // 出荷年月To
    private static final String COOKIE_LABEL_MODEL_NAME_PI = 'modelNamePI';  // 機種名称
    private static final String COOKIE_LABEL_SALES_ORDER_NO = 'salesOrderNo';  // 販売オーダー番号
    private static final String COOKIE_LABEL_SERVICE_AREA_LIST = 'serviceAreaList';  // サービスエリア
    private static final String COOKIE_LABEL_STATE_LIST = 'stateList';  // 都道府県
    private static final String COOKIE_LABEL_UNIT_BODY = 'unitBody';  // 本体号機
    private static final String COOKIE_LABEL_COUNTRY_CODE = 'countryCode';  // 国コード（左側）
    private static final String COOKIE_LABEL_STATUS_OF_USE = 'statusOfUse';  // 使用状況
    private static final String COOKIE_LABEL_POSTAL_CODE = 'postalCode';  // 系列
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 検索項目
    public String nonyusakiName { get; set; }  // 納入先名称
    public String nonyusakiNameHankaku { get; set; }  // 納入先名称（半角）
    public String nonyusakiCode { get; set; }  // 納入先コード
    public String seriesPI { get; set; }  // 系列
    public String shipDateFrom { get; set; }  // 出荷年月From
    public String shipDateTo { get; set; }  // 出荷年月To
    public String modelNamePI { get; set; }  // 機種名称
    public String salesOrderNo { get; set; }  // 販売オーダー番号
    public String serviceAreaList { get; set; }  // サービスエリア
    public String stateList { get; set; }  // 都道府県
    public String unitBody { get; set; }  // 本体号機
    public String countryCode { get; set; }  // 国コード（左側）
    public String statusOfUse { get; set; }  // 使用状況
    public String postalCode {get; set;}
    
    public String currentCountry{get; set;}
    
    private Map<String, String> displayCountryMap = new Map<String, String>();

    // 使用状況
    public List<SelectOption> getStatusOfUseOp(){
        List<SelectOption> statusOfUseOp = new List<SelectOption>();
        statusOfUseOp.add(new SelectOption(STATUS_OF_USE_USING, STATUS_OF_USE_USING_LABEL));
        statusOfUseOp.add(new SelectOption(STATUS_OF_USE_ALL, STATUS_OF_USE_ALL_LABEL)); 
        return statusOfUseOp;
    }

    // 系列選択リスト
    public List<SelectOption> getSeriesPIOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }
    // 都道府県選択リスト
    public List<SelectOption> getStateOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_JAPAN_STATE);
    }
    // サービスエリア選択リスト
    public List<SelectOption> getServiceAreaOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERVICE_AREA);
    }
    //国選択リスト
    public List<SelectOption> getCountryOptions(){
        List<SelectOption> options = JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_COUNTRY);
        List<SelectOption> dispOptions = new List<SelectOption>();
        for (SelectOption option: options) {
            String value = option.getValue();
            String label = option.getLabel();
            if (String.isNotBlank(label)) {
                displayCountryMap.put(value, label);
            }
            SelectOption newOption = new SelectOption(value, value);
            newOption.setDisabled(option.getDisabled());
            dispOptions.add(newOption);
        }
        this.changeCountry();
        return dispOptions;
    }
    
    public void changeCountry() {
        String countryName;
        if (this.displayCountryMap.containsKey(this.countryCode)) {
            countryName = this.displayCountryMap.get(this.countryCode);
        } else {
            countryName = '  ---  ';
        }
        this.currentCountry = countryName;
    }

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';
    
    /**
    *  コンストラクタ
    */
    public JEOL_NonyusakiList_ctrl() {
        orderBy = 'DeliveryAccount__r.Code__c';
        currentOrder = 'DeliveryAccount__r.Code__c';
        orderDesc = false;
        this.StatusOfUse = STATUS_OF_USE_USING;  // 使用状況の初期値は'使用中'
        // Cookie用
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }
        this.salesOrderNo = null;
    }

    /**
    *  ボタン処理系
    */
    // 検索ボタン
    public PageReference search() {
        orderBy = 'DeliveryAccount__r.Code__c';
        currentOrder = 'DeliveryAccount__r.Code__c';
        orderDesc = false;
        doSearch();
        return null;
    }
    // 検索（StandardSetController初期化）
    private void doSearch(){
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON
        
        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        setStandardSetController();
        if (ssc != null){
            ssc.setPageNumber(1);
        }
        saveInputValues();
    }
    // クリアボタン
    public void doFormClear() {
        //検索条件のクリア
        this.nonyusakiName = null;
        this.nonyusakiNameHankaku = null;
        this.nonyusakiCode = null;
        this.seriesPI = null;
        this.shipDateFrom = null;
        this.shipDateTo = null;
        this.modelNamePI = null;
        this.salesOrderNo = null;
        this.serviceAreaList = null;
        this.stateList = null;
        this.unitBody = null;
        this.countryCode = null;
        this.postalCode = null;
        this.statusOfUse = STATUS_OF_USE_USING;

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
    *  検索条件のCookie読み取り
    */
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        // 納入先名称
        if(cookies.containsKey(COOKIE_LABEL_NONYUSAKI_NAME)){
            this.nonyusakiName = cookies.get(COOKIE_LABEL_NONYUSAKI_NAME).getValue();
        }
        // 納入先名称（半角）
        if(cookies.containsKey(COOKIE_LABEL_NONYUSAKI_NAME_H)){
            this.nonyusakiNameHankaku = cookies.get(COOKIE_LABEL_NONYUSAKI_NAME_H).getValue();
        }
        // 納入先コード
        if(cookies.containsKey(COOKIE_LABEL_NONUSAKI_CODE)){
            this.nonyusakiCode = cookies.get(COOKIE_LABEL_NONUSAKI_CODE).getValue();
        }
        // 系列
        if(cookies.containsKey(COOKIE_LABEL_SERIES_PI)){
            this.seriesPI = cookies.get(COOKIE_LABEL_SERIES_PI).getValue();
        }
        // 出荷年月From
        if(cookies.containsKey(COOKIE_LABEL_SHIP_DATE_FROM)){
            this.shipDateFrom = cookies.get(COOKIE_LABEL_SHIP_DATE_FROM).getValue();
        }
        // 出荷年月To
        if(cookies.containsKey(COOKIE_LABEL_SHIP_DATE_TO)){
            this.shipDateTo = cookies.get(COOKIE_LABEL_SHIP_DATE_TO).getValue();
        }
        // 機種名称
        if(cookies.containsKey(COOKIE_LABEL_MODEL_NAME_PI)){
            this.modelNamePI = cookies.get(COOKIE_LABEL_MODEL_NAME_PI).getValue();
        }
        // 販売オーダー番号
        if(cookies.containsKey(COOKIE_LABEL_SALES_ORDER_NO)){
            this.salesOrderNo = cookies.get(COOKIE_LABEL_SALES_ORDER_NO).getValue();
        }
        // サービスエリア
        if(cookies.containsKey(COOKIE_LABEL_SERVICE_AREA_LIST)){
            this.serviceAreaList = cookies.get(COOKIE_LABEL_SERVICE_AREA_LIST).getValue();
        }
        // 都道府県
        if(cookies.containsKey(COOKIE_LABEL_STATE_LIST)){
            this.stateList = cookies.get(COOKIE_LABEL_STATE_LIST).getValue();
        }
        // 本体号機
        if(cookies.containsKey(COOKIE_LABEL_UNIT_BODY)){
            this.unitBody = cookies.get(COOKIE_LABEL_UNIT_BODY).getValue();
        }
        // 国コード
        if(cookies.containsKey(COOKIE_LABEL_COUNTRY_CODE)){
            this.countryCode = cookies.get(COOKIE_LABEL_COUNTRY_CODE).getValue();
        }
        // 使用状況
        if(cookies.containsKey(COOKIE_LABEL_STATUS_OF_USE)){
            this.statusOfUse = cookies.get(COOKIE_LABEL_STATUS_OF_USE).getValue();
        }
        //郵便番号
        if(cookies.containsKey(COOKIE_LABEL_POSTAL_CODE)){
            this.postalCode = cookies.get(COOKIE_LABEL_POSTAL_CODE).getValue();
        }
        // ページ番号（値が設定されていない場合は起動時検索対象外とする）
        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER) && cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue().length() != 0){
            PageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        // ページサイズ（値の取得のみとし、hasSearchValuesで判定させない）
        if(cookies.containsKey(COOKIE_LABEL_PAGE_SIZE) && cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue().length() != 0){
            PageSize = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue());
        }
        // 画面起動時検索フラグ
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }
        return hasSearchValues;
    }

    /**
    *  検索条件のCookie保存
    */
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        
        cookies.add(new Cookie(COOKIE_LABEL_NONYUSAKI_NAME, this.nonyusakiName, COOKIE_PATH, -1, true));  // 納入先名称
        cookies.add(new Cookie(COOKIE_LABEL_NONYUSAKI_NAME_H, this.nonyusakiNameHankaku, COOKIE_PATH, -1, true));  // 納入先名称（半角）
        cookies.add(new Cookie(COOKIE_LABEL_NONUSAKI_CODE, this.nonyusakiCode, COOKIE_PATH, -1, true));  // 納入先コード
        cookies.add(new Cookie(COOKIE_LABEL_SERIES_PI, this.seriesPI, COOKIE_PATH, -1, true));  // 系列
        cookies.add(new Cookie(COOKIE_LABEL_SHIP_DATE_FROM, this.shipDateFrom, COOKIE_PATH, -1, true));  // 出荷年月From
        cookies.add(new Cookie(COOKIE_LABEL_SHIP_DATE_TO, this.shipDateTo, COOKIE_PATH, -1, true));  // 出荷年月To
        cookies.add(new Cookie(COOKIE_LABEL_MODEL_NAME_PI, this.modelNamePI, COOKIE_PATH, -1, true));  // 機種名称
        cookies.add(new Cookie(COOKIE_LABEL_SALES_ORDER_NO, this.salesOrderNo, COOKIE_PATH, -1, true));  // 販売オーダー番号
        cookies.add(new Cookie(COOKIE_LABEL_SERVICE_AREA_LIST, this.serviceAreaList, COOKIE_PATH, -1, true));  // サービスエリア
        cookies.add(new Cookie(COOKIE_LABEL_STATE_LIST, this.stateList, COOKIE_PATH, -1, true));  // 都道府県
        cookies.add(new Cookie(COOKIE_LABEL_UNIT_BODY, this.unitBody, COOKIE_PATH, -1, true));  // 本体号機
        cookies.add(new Cookie(COOKIE_LABEL_COUNTRY_CODE, this.countryCode, COOKIE_PATH, -1, true));  // 国コード
        cookies.add(new Cookie(COOKIE_LABEL_STATUS_OF_USE, this.statusOfUse, COOKIE_PATH, -1, true));  // 使用状況
        cookies.add(new Cookie(COOKIE_LABEL_POSTAL_CODE, this.postalCode, COOKIE_PATH, -1, true));  // 郵便番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        
        Apexpages.currentPage().setCookies(cookies);
    }

    /**
    *  StandardSetController設定
    */
    protected override void setStandardSetController() {

        String queryText = ' SELECT ' +
                                ' DeliveryAccount__r.Code__c ' +
                                ', DeliveryAccount__r.Name' +  // 納入先取引先
                                ', UnitBody__c' +  // 本体号機
                                ', ModelName__c' +  // 機種名称
                                ', Series__c' +  // 系列
                                ', DeliveryAccount__c' + //納入先取引先
                                ', DeliveryAccount__r.CountryCode__c' +  // 納入先取引先．国
                                ', DeliveryAccount__r.ServiceArea__c' +  // 納入先取引先．サービスエリア
                                ', DeliveryAccount__r.Undergraduate__c' +  // 納入先取引先．学部・事業所
                                ', DeliveryAccount__r.PostalCode__c' +  // 納入先取引先.郵便番号
                                ', Contact1__r.Affiliation__c' +  // 本体号機別窓口１．所属
                                ', Contact2__r.Affiliation__c' +  // 本体号機別窓口２．所属
                                ', ShippingDateFormula__c' +  // 出荷年月
                                ', SerialNo__c ' + //販売オーダ番号用
                                ', AcceptanceDateFormula__c' +  // 検収日
                                ', SvcForm__c' +  // SVC形態
                                ', StatusOfUse__c' +  // 使用状況
                                ', StatusOfUseName__c' +  // 使用状況名
                            ' FROM ' +
                                ' UnitBody__c ';

        List<String> whereCondition = new List<String>();
        whereCondition.add(' UnitBody__c != null ');
        //whereCondition.add(' AcceptanceDateFormula__c != 1970-01-01 ');
        //whereCondition.add(' StatusOfUse__c not in ' + STATUS_OF_USE_NO_SEARCH + ' ');
        //whereCondition.add('( not SalesCustomer__r.Code__c like \'0%\')');
        if (String.isNotBlank(this.nonyusakiName)) {
            whereCondition.add(JEOLUtil.appendLikeText('DeliveryAccount__r.Name', this.nonyusakiName));
        }
        if (String.isNotBlank(this.nonyusakiNameHankaku)) {
            whereCondition.add(JEOLUtil.appendLikeText('DeliveryAccount__r.NameUpToKana__c', this.nonyusakiNameHankaku));
        }
        if (String.isNotBlank(this.nonyusakiCode)) {
            whereCondition.add(JEOLUtil.appendAfterLikeText('DeliveryAccount__r.Code__c', this.nonyusakiCode));
        }
        if (String.isNotBlank(this.modelNamePI)) {
            whereCondition.add(JEOLUtil.appendLikeText('ModelName__c', this.modelNamePI));
        }
        if (String.isNotBlank(this.unitBody)) {
            whereCondition.add(JEOLUtil.appendLikeText('UnitBody__c', this.UnitBody));
        }
        if (String.isNotBlank(this.seriesPI)) {
            whereCondition.add(JEOLUtil.appendEqualText('Series__c', this.seriesPI));
        }
        if (String.isNotBlank(this.salesOrderNo)) {
            whereCondition.add(JEOLUtil.appendLikeText('SerialNo__c', this.salesOrderNo));
        }
        if (String.isNotBlank(this.serviceAreaList)) {
            whereCondition.add(JEOLUtil.appendEqualText('DeliveryAccount__r.serviceArea__c', this.serviceAreaList));
        }
        if (String.isNotBlank(this.stateList)) {
            whereCondition.add(JEOLUtil.appendEqualText('DeliveryAccount__r.State__c', this.stateList));
        }
        if (String.isNotBlank(this.postalCode)) {
            whereCondition.add(JEOLUtil.appendAfterLikeText('DeliveryAccount__r.PostalCode__c', this.postalCode));
            
        }
        if (this.statusOfUse != STATUS_OF_USE_ALL) {
            whereCondition.add(' StatusOfUse__c IN ' + STATUS_OF_USE_USING_SEARCH);
        }
        
        try {
            if (String.isNotBlank(this.shipDateFrom)) {
                Date fromDate = Date.parse(this.shipDateFrom);
                whereCondition.add(JEOLUtil.appendGreaterThanEqualText('ShippingDateFormula__c', fromDate.format().replaceAll('/', '-'), false));
            }
            if (String.isNotBlank(this.shipDateTo)) {
                Date toDate = Date.parse(this.shipDateTo);
                //comment out 20150905 mkubomura
                //whereCondition.add(JEOLUtil.appendGreaterThanEqualText('ShippingDateFormula__c', toDate.format().replaceAll('/', '-'), false));
                whereCondition.add(JEOLUtil.appendLessThanEqualText('ShippingDateFormula__c', toDate.format().replaceAll('/', '-'), false));
            }
            if (String.isNotBlank(this.shipDateFrom) || String.isNotBlank(this.shipDateTo)){
                whereCondition.add(' ShippingDateFormula__c != null ');
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'出荷年月日は半角の「年/月/日」で入力してください。'));
            this.ssc = null;
            return;
        }
        if (String.isNotBlank(this.countryCode)) {
            whereCondition.add(JEOLUtil.appendEqualText('DeliveryAccount__r.CountryCode__c', this.countryCode));
        }
        queryText += JEOLUtil.joinWhereConditions(whereCondition);
        
        if (orderBy != 'salesOrderNo') {
            queryText += ' ORDER BY ' + orderBy;
            if (orderDesc) {
                queryText += ' DESC NULLS LAST';
            }
        }
        
        queryText += ' LIMIT 10000 ';

        this.ssc = new ApexPages.StandardSetController(Database.getQueryLocator(queryText));
        if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(this.pageSize);
            ssc.setPageNumber(this.pageNo);
        }
    }

    /**
    *  検索内容の取得
    */
     public List<rowWrapper> getSerialNoProductItems(){
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;

        if (ssc != null){
            Set<String> orderNos = new Set<String>();
            if (orderBy != 'salesOrderNo') {
                for (UnitBody__c row: (List<UnitBody__c>)ssc.getRecords()){
                    rowWrapper wrap = new rowWrapper(row, currentCount);
                    
                    String orderNo = wrap.getSalesOrderNo();
                    if (String.isNotBlank(orderNo)) {
                        orderNos.add(orderNo);
                    }
                    rows.add(wrap);
                    currentCount++;
                }
            } else {
                Integer currentPageSize = ssc.getPageSize();
                Integer currentPageNo = ssc.getPageNumber();
                Integer resultSize = ssc.getResultSize();
                if (resultSize > 0) {
                    
                    List<rowWrapper> wraps = new List<rowWrapper>();
                    Integer lineNum = 1;
                    Integer pageNum = 1;
                    ssc.setPageSize(2000);
                    ssc.setPageNumber(pageNum);
                    while (pageNum*ssc.getPageSize() < resultSize) {
                        ssc.setPageNumber(pageNum);
                        for (UnitBody__c targetRec: (List<UnitBody__c>)ssc.getRecords()) {
                            wraps.add(new rowWrapper(targetRec, lineNum));
                            lineNum++;
                        }
                        pageNum++;
                    }
                    ssc.setPageNumber(pageNum);
                    for (UnitBody__c targetRec: (List<UnitBody__c>)ssc.getRecords()) {
                        wraps.add(new rowWrapper(targetRec, lineNum));
                        lineNum++;
                    }
                    ssc.setPageSize(currentPageSize);
                    ssc.setPageNumber(currentPageNo);
                    wraps.sort();
    
                    List<rowWrapper> retWraps = new List<rowWrapper>();
                    for (Integer i = currentPageSize*(currentPageNo-1); (i < currentPageSize*currentPageNo) && (i < wraps.size()); i++) {
                        rowWrapper targetWrap = wraps.get(i);
                        targetWrap.rowNumber = i + 1;
                        String orderNo = targetWrap.getSalesOrderNo();
                        if (String.isNotBlank(orderNo)) {
                            orderNos.add(orderNo);
                        }
                        retWraps.add(targetWrap);
                    }
                    if (orderDesc) {
                        List<rowWrapper> descList = new List<rowWrapper>();
                        Integer size = retWraps.size();
                        for (Integer i = size; i > 0; i--) {
                            rowWrapper targetWrap = wraps.get(i - 1);
                            targetWrap.rowNumber = size - i;
                            descList.add(targetWrap);
                        }
                        retWraps = descList;
                    }
                    rows = retWraps;
                }
            } 
            Map<String, String> orderIds = new Map<String, String>();
            List<SalesOrder__c> orders = [SELECT id, name FROM SalesOrder__c WHERE name in: new List<String>(orderNos)];
            if (orders != null && orders.size() > 0) {
                for (SalesOrder__c rec: orders) {
                    orderIds.put(rec.name, rec.id);
                }
            }
            for (rowWrapper row: rows) {
                String orderNo = row.getSalesOrderNo();
                if (orderIds.containsKey(orderNo)) {
                    row.salesOrderId = orderIds.get(orderNo);
                }
            }
        }
        return rows;
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
    *  検索結果の設定
    */
    public class rowWrapper  implements Comparable {
        public UnitBody__c rec {get; set;}
        public Integer rowNumber {get; set;}
        public String salesOrderId{get; set;}
        
        public rowWrapper(UnitBody__c rec, Integer rowNumber){
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
        
        public String getSalesOrderNo() {
            //String ret;
            //String serialNo = this.rec.SerialNo__c;
            //if (String.isNotBlank(serialNo)) {
            //    List<String> serialNoTexts = serialNo.split('_', 2);
            //    if (serialNoTexts.size() == 2) {
            //        ret = serialNoTexts.get(1);
            //    }
            //}
            return this.rec.SerialNo__c;
        }
        
        public Pagereference getDetailUrl() {
            Pagereference ref = Page.JEOL_NonyusakiShokaiPage;
            ref.getParameters().put('id', rec.id);
            ref.setRedirect(true);
            return ref;
        }

        public Integer compareTo(Object compareTo) {
            rowWrapper wrap = (rowWrapper)compareTo;
            Integer ret;
            String currentSalesOrderNo = getSalesOrderNo();
            String compareSalesOrderNo = wrap.getSalesOrderNo();
            if (currentSalesOrderNo == compareSalesOrderNo) {
                ret = 0;
            } else if (currentSalesOrderNo > compareSalesOrderNo) {
                ret = 1;
            } else {
                ret = -1;
            }
            return ret;
        }        
        
    }

}