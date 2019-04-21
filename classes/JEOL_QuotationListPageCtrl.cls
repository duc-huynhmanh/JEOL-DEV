public with sharing class JEOL_QuotationListPageCtrl {

    //検索条件格納用
    private String conditionStr = null;
    //現在のソート対象項目
    private String orderBy = null;
    //LIMIT値格納用
    private String limitStr = null;
    //オブジェクト
    public QuotationInformation__c rec{get; set;}
    //StandardSetController
    public ApexPages.StandardSetController ssc{get; set;}
    //ページ
    private Integer pageNum = 1;
    private Integer pageSize = 50;
    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';
    // 検索エラーフラグ
    public Boolean errFlg = false;
    //現在ソート中の対象項目
    private String selectedOrderTarget = null;
    //ソートする項目指定
    public String orderTarget{get;set;}
    //昇順、降順指定
    public Boolean orderDesc{get; set;}
    //検索条件項目
    public String targetQuoteNo{get; set;}              //見積No
    public String targetName{get; set;}                 //見積名
    public String targetRecords{get; set;}              //レコード
    public String targetSalesPersonCode{get; set;}      //営業担当者コード
    public String targetSalesPerson{get; set;}          //営業担当者
    public String targetContractCode{get; set;}         //契約先コード
    public String targetContractName{get; set;}         //契約先名
    public String targetShipmentCode{get; set;}         //納入先コード
    public String targetShipmentName{get; set;}         //納入先名
    public String targetSeries{get; set;}               //系列
    public String targetCustomerQuotationRequestedNo{get; set;} //客先見積No
    public String targetQuotationType{get; set;}        //見積種別
    public String targetRecordType{get; set;}           //レコードタイプ
    public String targetSalesArea{get; set;}            //地域
    public String RegisteredDateFrom { get; set;}       //登録日From
    public String RegisteredDateTo { get; set;}         //登録日to
    //保持項目有無判定
    private static final String COOKIE_LABEL_QUOTE_NO = 'QuoteNo';
    private static final String COOKIE_LABEL_NAME = 'name';
    private static final String COOKIE_LABEL_CONTRACT_NAME = 'ContractName';
    private static final String COOKIE_LABEL_CUSTOMER_QUOTATION_REQUESTED_NO = 'CustomerQuotationRequestedNo';
    private static final String COOKIE_LABEL_EIGYOTANTOSHA_CODE = 'EigyoTantoshaCode';
    private static final String COOKIE_LABEL_EIGYOTANTOSHA_NAME = 'EigyoTantoshaName';
    private static final String COOKIE_LABEL_SALESPERSON = 'SalesPerson';
    private static final String COOKIE_LABEL_SALESPERSON_CODE = 'SalesPersonCode';
    private static final String COOKIE_LABEL_TITLESHOHIN_NAME = 'TitleShohinName';
    private static final String COOKIE_LABEL_CONTRACT_CODE = 'ContractCode';
    private static final String COOKIE_LABEL_SHIPMENT_CODE = 'ShipmentCode';
    private static final String COOKIE_LABEL_SHIPMENT_ACCOUNT_NAME = 'ShipmentAccountName';
    private static final String COOKIE_LABEL_SHIPMENT_NAME = 'ShipmentName';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_SALESAREA = 'SalesArea';
    private static final String COOKIE_LABEL_QUOTATION_TYPE = 'QuotationType';  
    private static final String COOKIE_LABEL_RECORD_TYPE = 'RecordType';  
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    private static final String COOKIE_PATH = '/apex/JEOL_QuotationListPage';
    private static final String COOKIE_LABEL_REGISTEREDDATE_FROM = 'RegisteredDateFrom';
    private static final String COOKIE_LABEL_REGISTEREDDATE_TO = 'RegisteredDateTo';
    //cookie有効期限
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
    //クエリ
    //Modification-VAIB-Begins(2015/05/27 UAT_QA_List No.80)
    private static final String BASE_QUERY_STRING = 'SELECT name, RecordType.Name, RecordType.DeveloperName, BranchNo__c, QuotationType__c, SalesPerson__c, SalesAssistant__c, DepartmentName__c, DepartmentCode__c, SalesArea__c, ContractCode__c, ContractName__c, ContractShortName__c, ShipmentCode__c, ShipmentName__c, ShipmentShortName__c, QuoteNo__c, TotalTaxAmount__c,TotalAmount__c, CreatedDateFormula__c, CustomerQuotationRequestedNo__c, Series__c, CreatedBy.Name, RegisterDate__c, IssueDate__c, LastModifiedDate FROM QuotationInformation__c';
    //Modification-VAIB-Ends(2015/05/27 UAT_QA_List No.80)
    
    private static final String BASE_QUERY_FROM_QUOTE = 'SELECT EigyoTantoshaName__c, TitleShohinName__c, EigyoTantoshaCode__c FROM Quote__c';

    private static final String SELECTOPTION_LASTMODIFIED = '1'; //最終更新ラジオボタン判定
    private static final String SELECTOPTION_ALL = '2'; //すべて表示ラジオボタン判定
    private static final String QUERY_LIMIT = '1000'; //クエリ件数ソート表示用
    private static final String QUERY_LIMIT_MAX = '10000'; //クエリ件数全件表示用
    
    //検索方法のオプション表示(ラジオボタン)
    public static List<SelectOption> targetRecordsOption{get; set;}
    static {
        targetRecordsOption = new List<SelectOption>();
        targetRecordsOption.add(new SelectOption(SELECTOPTION_LASTMODIFIED, Label.JEOL_Quotation_Label_List1000));
        targetRecordsOption.add(new SelectOption(SELECTOPTION_ALL, Label.JEOL_Quotation_Label_ListAll));
    }
    //コンストラクタ
    public JEOL_QuotationListPageCtrl() {
        this.targetRecords = SELECTOPTION_LASTMODIFIED;
        this.orderDesc = true;
        this.orderTarget = 'LastModifiedDate';
        //recordSearch();
        
        Boolean hasSearchValue = initFieldFromCookie();//保持項目有無チェック
        if (hasSearchValue) {
            system.debug('recordSearchメソッドコール');
            recordSearch();
        }
    }
    
    public String getUrlParamFromEditorCopy() {
        return JEOL_QuotationEditorPageCtrl.URL_PARAM_NAME_ISCOPY;
    }
    public String getUrlParamFromEditorBranch() {
        return JEOL_QuotationEditorPageCtrl.URL_PARAM_NAME_ISBRANCH;
    }

    //cookie保存
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie(COOKIE_LABEL_QUOTE_NO, this.targetQuoteNo, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_NAME, this.targetName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACT_NAME, this.targetContractName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMER_QUOTATION_REQUESTED_NO, this.targetCustomerQuotationRequestedNo, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON, this.targetSalesPerson, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON_CODE, this.targetSalesPersonCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACT_CODE, this.targetContractCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHIPMENT_CODE, this.targetShipmentCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHIPMENT_NAME, this.targetShipmentName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERIES, this.targetSeries, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESAREA, this.targetSalesArea, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_QUOTATION_TYPE, this.targetQuotationType, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_RECORD_TYPE, this.targetRecordType, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));  // 画面起動時検索フラグ

        String fromDateStr;
        if (this.RegisteredDateFrom != null) {
            fromDateStr = RegisteredDateFrom.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_FROM, fromDateStr, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        String toDateStr;
        if (this.RegisteredDateTo != null) {
            toDateStr = this.RegisteredDateTo.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_REGISTEREDDATE_TO, toDateStr, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        Apexpages.currentPage().setCookies(cookies);
    }
    
    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        
        if(cookies.containsKey('QuoteNo')){
                this.targetQuoteNo = cookies.get('QuoteNo').getValue();
        }
        if(cookies.containsKey('name')){
                this.targetName = cookies.get('name').getValue();
        }
        if(cookies.containsKey('ContractName')){
                this.targetContractName = cookies.get('ContractName').getValue();
        }
        
        if(cookies.containsKey('SalesPersonCode')){
                this.targetSalesPersonCode = cookies.get('SalesPersonCode').getValue();
        }
        if(cookies.containsKey('SalesPerson')){
                this.targetSalesPerson = cookies.get('SalesPerson').getValue();
        }
        if(cookies.containsKey('ContractCode')){
                this.targetContractCode = cookies.get('ContractCode').getValue();
        }
        
        if(cookies.containsKey('ContractName')){
                this.targetContractName = cookies.get('ContractName').getValue();
        }
        if(cookies.containsKey('ShipmentCode')){
                this.targetShipmentCode = cookies.get('ShipmentCode').getValue();
        }
        if(cookies.containsKey('ShipmentName')){
                this.targetShipmentName = cookies.get('ShipmentName').getValue();
        }
        if(cookies.containsKey('Series')){
                this.targetSeries = cookies.get('Series').getValue();
        }
        if(cookies.containsKey('CustomerQuotationRequestedNo')){
                this.targetCustomerQuotationRequestedNo = cookies.get('CustomerQuotationRequestedNo').getValue();
        }
        if(cookies.containsKey('QuotationType')){
                this.targetQuotationType = cookies.get('QuotationType').getValue();
        }
        if(cookies.containsKey('RecordType')){
                this.targetRecordType = cookies.get('RecordType').getValue();
        }
        if(cookies.containsKey('SalesArea')){
                this.targetSalesArea = cookies.get('SalesArea').getValue();
        }
        //登録日
        if(cookies.containsKey(COOKIE_LABEL_REGISTEREDDATE_FROM)){
            this.RegisteredDateFrom = cookies.get(COOKIE_LABEL_REGISTEREDDATE_FROM).getValue().replaceAll('-', '/');
            system.debug('RegisteredDateFromの値：' + this.RegisteredDateFrom);
        }
        if(cookies.containsKey(COOKIE_LABEL_REGISTEREDDATE_TO)){
            this.RegisteredDateTo = cookies.get(COOKIE_LABEL_REGISTEREDDATE_TO).getValue().replaceAll('-', '/');
            system.debug('RegisteredDateToの値：' + this.RegisteredDateTo);
        }
        
        //画面起動時検索フラグチェック
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
        hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }
        return hasSearchValues;
    }
        
    //リスト項目取得
    public List<SelectOption> getSalesAreaOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_AREA);
    }
    public List<SelectOption> getQuoteTypeOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTE_TYPE);
    }
    public List<SelectOption> getRecordTypeOptions() {
    
        // In order to keep a correct order, the list of the record type has intentionally not been retrieved dynamically
        List<SelectOption> lsReturn = new List<SelectOption>();
        lsReturn.add(new SelectOption('', ''));
        lsReturn.add(new SelectOption('SFDC', 'SFDC'));
        lsReturn.add(new SelectOption('BaaN', 'BaaN'));
        lsReturn.add(new SelectOption('PCS', 'PCS'));
        
        return lsReturn;
    }
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }
    
    //検索キーワード設定 WHERE句作成 
    private String getContditions() {
        errFlg = false;
        List<String> conditions = new List<String>();
        if (String.isNotBlank(this.targetQuoteNo)) {
            conditions.add(JEOLUtil.appendLikeText('QuoteNo__c', this.targetQuoteNo));
        }
        if (String.isNotBlank(this.targetName)) {
            conditions.add(JEOLUtil.appendLikeText('name', this.targetName));
        }
        if (String.isNotBlank(this.targetCustomerQuotationRequestedNo)) {
            conditions.add(JEOLUtil.appendLikeText('CustomerQuotationRequestedNo__c', this.targetCustomerQuotationRequestedNo));
        }
        if (String.isNotBlank(this.targetSalesPersonCode)) {
            conditions.add(JEOLUtil.appendLikeText('SalesPerson__r.UserCode__c', this.targetSalesPersonCode));
        }
        
        if (String.isNotBlank(this.targetSalesPerson)) {
            conditions.add(JEOLUtil.appendLikeText('SalesPerson__r.Name', this.targetSalesPerson));
        }
        
        if (String.isNotBlank(this.targetContractCode)) {
            conditions.add(JEOLUtil.appendAfterLikeText('ContractCode__c', this.targetContractCode));
        }
        if (String.isNotBlank(this.targetContractName)) {
            conditions.add(JEOLUtil.appendLikeText('ContractName__c', this.targetContractName));
        }
        if (String.isNotBlank(this.targetShipmentCode)) {
            conditions.add(JEOLUtil.appendAfterLikeText('ShipmentCode__c', this.targetShipmentCode));
        }
        if (String.isNotBlank(this.targetShipmentName)) {
            conditions.add(JEOLUtil.appendLikeText('ShipmentName__c', this.targetShipmentName));
        }
        if (String.isNotBlank(this.targetSeries)) {
            conditions.add(JEOLUtil.appendEqualText('Series__c', this.targetSeries));
        }
        if (String.isNotBlank(this.targetSalesArea)) {
            conditions.add(JEOLUtil.appendEqualText('SalesArea__c', this.targetSalesArea));
        }
        if (String.isNotBlank(this.targetQuotationType)) {
        //TODOBP
            String sQuotationTypeCode = 'DUMMYDUMMYDUMMY';
            List<SelectOption> QuoteTypeOptions = JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTE_TYPE);                
            if (QuoteTypeOptions != null && QuoteTypeOptions.size() > 0)
            {
                For (SelectOption so : QuoteTypeOptions)
                {
                    If (so.getLabel() == this.targetQuotationType)
                    {
                        sQuotationTypeCode = so.getvalue();
                        break;
                    }
                }
            }
            conditions.add(JEOLUtil.appendEqualText('QuotationType__c', sQuotationTypeCode));
        }
        if (String.isNotBlank(this.targetRecordType)) {
            if (this.targetRecordType ==  'SFDC')
            {
                conditions.add('RecordType.DeveloperName in (NULL, \'' + String.escapeSingleQuotes(this.targetRecordType) + '\')');
            } else {
                conditions.add(JEOLUtil.appendEqualText('RecordType.DeveloperName', this.targetRecordType));
            }
        }
        
        try {
            if (String.isNotBlank(this.RegisteredDateFrom)) {
                Date fromDate = Date.parse(RegisteredDateFrom); //Date型2012-12-30 00:00:00に変換
                String fromDateToStr =fromDate.format();    //String型変換
                fromDateToStr = fromDateToStr.replaceAll('/', '-'); // + 'T00:00:00Z';  //T00:00:00Z付与
                conditions.add(JEOLUtil.appendGreaterThanEqualText('CreatedDateFormula__c', fromDateToStr, false));
            }
            if (String.isNotBlank(this.RegisteredDateTo)) {
                Date toDate = Date.parse(RegisteredDateTo); //Date型2012-12-30 00:00:00に変換
                String toDateToStr =toDate.format();    //String型変換
                toDateToStr = toDateToStr.replaceAll('/', '-'); // + 'T00:00:00Z';  //T00:00:00Z付与
                conditions.add(JEOLUtil.appendLessThanEqualText('CreatedDateFormula__c', toDateToStr, false));
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '登録日は半角の「年/月/日」で入力してください。'));
            errFlg = true;
        }
        
        return JEOLUtil.joinWhereConditions(conditions);
    }
    
    //検索キーワードクリアメソッド
    public void searchItemClear() {
        this.ssc = null;
        this.targetQuoteNo = null;
        this.targetName = null;
        this.targetCustomerQuotationRequestedNo = null;
        this.targetSalesPersonCode = null;
        this.targetSalesPerson = null;
        this.targetContractCode = null;
        this.targetContractName = null;
        this.targetShipmentCode = null;
        this.targetShipmentName = null;
        this.targetSeries = null;
        this.targetSalesArea = null;
        this.targetQuotationType = null;
        this.targetRecordType = null;
        this.RegisteredDateFrom = null;
        this.RegisteredDateto = null;
        saveInputValues();  //cookie保存
    }
    
    //検索条件(ラジオボタン)でのレコード取得メソッド WHERE句、LIMIT句設定&検索時のSOQL発行
    public void recordSearch() {
        String queryStr = BASE_QUERY_STRING;//SELECT、FROM設定
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        //検索WHERE句作成 
        String conditionStr = getContditions();

        //ソート項目(ORDER BY)取得
        String orderBy = getOrderBy(); //ORDER BY句、ASC/DESC、nulls last
        
        //LIMIT句作成
        String range = QUERY_LIMIT_MAX;
        //「ソート項目で1000件」表示かどうかの判定
        if (this.targetRecords == SELECTOPTION_LASTMODIFIED) {
            range = QUERY_LIMIT;
        }
        String limitStr = ' LIMIT ' + range;
        
        //SELECT文、 WHERE句、LIMIT句を連結
        queryStr += conditionStr + orderBy + limitStr;

        if(errFlg){
            this.ssc = null;
        }else {
            this.ssc = createSsc(queryStr);
            this.conditionStr = conditionStr;
            system.debug('conditionStrは：' + conditionStr);
            this.limitStr = limitStr;
        }
        saveInputValues();//cookie保存
    }
    
    //ソートSOQL発行  WHERE句、LIMITを使って、SOQL発行
    public void switchingOrder() {
        String querystr = BASE_QUERY_STRING;

        //降順の場合、null値を最後に表示
        //同じ項目を選択
        
        if(this.orderTarget == this.selectedOrderTarget) {
            this.orderDesc = !this.orderDesc;
            //降順の場合、null値を最後に表示
        } else { //別の項目を選択
            this.orderDesc = false;
            this.selectedOrderTarget = this.orderTarget;//現在のソート対象項目保持
        }
        
        this.orderBy = getOrderBy();    // ORDER BY句作成
        queryStr += this.conditionStr + this.orderBy +  this.limitStr;
        this.ssc = createSsc(querystr);
    }
    
    
    //ソート項目(ORDER BY)を指定する ORDER BY句、ASC/DESC、nulls last作成 
    public String getOrderBy() {
        String orderByStr = ' ORDER BY '+ orderTarget; //ソート項目(ORDER BY)を指定
        String descStr = '';//昇順/降順、nulls last作成用 
        
        //降順の場合、NULL値は最後に表示
        if(this.orderDesc){
            descStr = ' Desc nulls last ';
        }
        orderByStr += descStr; //ORDER BY句、ASC/DESC、nulls last作成
        return orderByStr;
    }
    
    //レコードをVFに出力するにあたっての操作
    private ApexPages.StandardSetController createSsc(String queryStr) {
        ApexPages.StandardSetController localSsc = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));
        localSsc.setPageSize(this.pageSize);
        localSsc.setPageNumber(this.pageNum);
        return localSsc;
    }
    //一括取得したレコードを一覧表示させるためにPage(Records)に渡す
    public List<QuotationInformation__c> getRecords() {
        List<QuotationInformation__c> recs = null;
        if(this.ssc != null) {
            recs = (List<QuotationInformation__c>)this.ssc.getRecords();
        }
        if(recs == null){
            recs = new List<QuotationInformation__c>();
        }
        return recs;
    }
}