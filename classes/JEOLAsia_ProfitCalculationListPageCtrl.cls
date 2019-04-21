public with sharing class JEOLAsia_ProfitCalculationListPageCtrl {

    //検索条件格納用
    private String conditionStr = null;
    //現在のソート対象項目
    private String orderBy = null;
    //LIMIT値格納用
    private String limitStr = null;
    //オブジェクト
    public AsiaProfitCalculation__c rec{get; set;}
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
    public String targetQTNo{get; set;}                 //Quotation No
    public String targetRecords{get; set;}              //レコード
    public String targetSalesPerson{get; set;}          //営業担当者
    public String targetCustomerCode{get; set;}         //Customer Code
    public String targetCustomerName{get; set;}         //Customer Name
    public String targetProjectNumber{get; set;}        //Project Number
    public String targetCountry{get; set;}        //Project Number
    public String targetModelType{get; set;}        //Project Number
    public List<String> targetSeries{get; set;}         //系列
    public String targetProfitCalcType{get; set;}       //Profit Calc Type
    public String status{get; set;}                     //Status
    public String RegisteredDateFrom { get; set;}       //登録日From
    public String RegisteredDateTo { get; set;}         //登録日to
    public List<OptionDetail> SeriesOptions{get; set;}  //選択系列

    private User currentUser = [SELECT CompanyName, AvailableMarket__c FROM User WHERE id = :UserInfo.getUserId()];

    //保持項目有無判定
    private static final String COOKIE_LABEL_QT_NO = 'QTNo';
    private static final String COOKIE_LABEL_NAME = 'name';
    private static final String COOKIE_LABEL_EIGYOTANTOSHA_CODE = 'EigyoTantoshaCode';
    private static final String COOKIE_LABEL_EIGYOTANTOSHA_NAME = 'EigyoTantoshaName';
    private static final String COOKIE_LABEL_SALESPERSON = 'SalesPerson';
    private static final String COOKIE_LABEL_TITLESHOHIN_NAME = 'TitleShohinName';
    private static final String COOKIE_LABEL_CUSTMER_CODE = 'CustomerCode';
    private static final String COOKIE_LABEL_CUSTMER_NAME = 'CustomerName';
    private static final String COOKIE_LABEL_PRONUM = 'ProNum';
    private static final String COOKIE_LABEL_COUNTRY = 'Country';
    private static final String COOKIE_LABEL_MODELTYPE = 'ModelType';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_PROFITCALC_TYPE = 'ProfitCalcType';
    private static final String COOKIE_LABEL_STATUS = 'Status';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    private static final String COOKIE_PATH = '/apex/JEOLAsia_ProfitCalculationListPage';
    private static final String COOKIE_LABEL_REGISTEREDDATE_FROM = 'RegisteredDateFrom';
    private static final String COOKIE_LABEL_REGISTEREDDATE_TO = 'RegisteredDateTo';
    //cookie有効期限
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
    //クエリ
    //Modification-VAIB-Begins(2015/05/27 UAT_QA_List No.80)
    private static final String BASE_QUERY_STRING = ' SELECT name, Status__c, RecordType.Name, RecordType.DeveloperName, BranchNo__c, ' +
                                                    '        SalesPerson__c, SalesAssistant__c, ContractCode__c, ContractName__c, ShipmentCode__c, ' +
                                                    '        ShipmentName__c, ProfitCalculationNo__c, TotalTaxAmount__c, TotalAmount__c, ' +
                                                    '        CreatedDateFormula__c, Series__c, ShipmentCountry__c, SalesCurrency__c, GrandTotal__c, ' +
                                                    '        ContractAccount__c, ShipmentAccount__c, OfferAmount__c, CreatedBy.Name, IssueDate__c, ' +
                                                    '        LastModifiedDate, ' +
                                                    '        (SELECT ModelType__c ' +
                                                    '         FROM ProfitCalculation_ProfitCalculatioDetail__r ' +
                                                    '         WHERE Category__c = \'A\' ' +
                                                    '         AND Type__c = \'1\' ' +
                                                    '         ORDER BY SortNo__c ' +
                                                    '         LIMIT 1)' +
                                                    ' FROM AsiaProfitCalculation__c';
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
        targetRecordsOption.add(new SelectOption(SELECTOPTION_LASTMODIFIED, Label.JEOLAsia_ProfitCalculation_List1000));
        targetRecordsOption.add(new SelectOption(SELECTOPTION_ALL, Label.JEOLAsia_ProfitCalculation_ListAll));
    }
    //コンストラクタ
    public JEOLAsia_ProfitCalculationListPageCtrl() {
        this.targetRecords = SELECTOPTION_LASTMODIFIED;
        this.orderDesc = true;
        this.orderTarget = 'LastModifiedDate';
        //recordSearch();
system.debug('コンストラクタ');

        Boolean hasSearchValue = initFieldFromCookie();//保持項目有無チェック

        // 系列項目設定
        List<optionDetail> seriesOptions = new List<optionDetail>();
        Set<String> series;
        if (this.targetSeries != null) {
            series = new Set<String>(this.targetSeries);
        }
system.debug('コンストラクタ:this.targetSeries = ' + this.targetSeries);

        List<SelectOption> options = new List<SelectOption>();
        options = JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);

        for (SelectOption option: options) {
            Boolean isSelected = false;
            if (series != null) {
                isSelected = series.contains(option.getValue());
            }

            if (option.getValue() <> '') {
                seriesOptions.add(new OptionDetail(option, isSelected));
            }
        }

        this.seriesOptions = seriesOptions;
system.debug('コンストラクタ:this.seriesOptions = ' + this.seriesOptions);

        if (hasSearchValue) {
            system.debug('recordSearchメソッドコール');
            recordSearch();
        }
    }

    public String getUrlParamFromEditorCopy() {
        return JEOLAsia_ProfitCalculationEditorPageCtrl.URL_PARAM_NAME_ISCOPY;
    }
    public String getUrlParamFromEditorBranch() {
        return JEOLAsia_ProfitCalculationEditorPageCtrl.URL_PARAM_NAME_ISBRANCH;
    }

    //cookie保存
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_QT_NO, this.targetQTNo, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON, this.targetSalesPerson, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_CODE, this.targetCustomerCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_NAME, this.targetCustomerName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_PROFITCALC_TYPE, this.targetProfitCalcType, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_STATUS, this.status, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));  // 画面起動時検索フラグ
        cookies.add(new Cookie(COOKIE_LABEL_PRONUM, this.targetProjectNumber, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_COUNTRY, this.targetCountry, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_MODELTYPE, this.targetModelType, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        String targetSeriesText = '';
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            targetSeriesText = String.join(this.targetSeries, '&&');
        }
        cookies.add(new Cookie(COOKIE_LABEL_SERIES, targetSeriesText, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

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

        if(cookies.containsKey(COOKIE_LABEL_CUSTMER_CODE)){
                this.targetCustomerCode = cookies.get(COOKIE_LABEL_CUSTMER_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_CUSTMER_NAME)){
                this.targetCustomerName = cookies.get(COOKIE_LABEL_CUSTMER_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALESPERSON)){
                this.targetSalesPerson = cookies.get(COOKIE_LABEL_SALESPERSON).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_QT_NO)){
                this.targetQTNo = cookies.get(COOKIE_LABEL_QT_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_PROFITCALC_TYPE)){
                this.targetProfitCalcType = cookies.get(COOKIE_LABEL_PROFITCALC_TYPE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_STATUS)){
                this.status = cookies.get(COOKIE_LABEL_STATUS).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_PRONUM)){
                this.targetProjectNumber = cookies.get(COOKIE_LABEL_PRONUM).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_COUNTRY)){
                this.targetCountry = cookies.get(COOKIE_LABEL_COUNTRY).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_MODELTYPE)){
                this.targetModelType = cookies.get(COOKIE_LABEL_MODELTYPE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_REGISTEREDDATE_FROM)){
            this.RegisteredDateFrom = cookies.get(COOKIE_LABEL_REGISTEREDDATE_FROM).getValue().replaceAll('-', '/');
            system.debug('RegisteredDateFromの値：' + this.RegisteredDateFrom);
        }
        if(cookies.containsKey(COOKIE_LABEL_REGISTEREDDATE_TO)){
            this.RegisteredDateTo = cookies.get(COOKIE_LABEL_REGISTEREDDATE_TO).getValue().replaceAll('-', '/');
            system.debug('RegisteredDateToの値：' + this.RegisteredDateTo);
        }
        if(cookies.containsKey(COOKIE_LABEL_SERIES)){
            String targetSeriesText = cookies.get(COOKIE_LABEL_SERIES).getValue();
            if (String.isNotBlank(targetSeriesText)) {
                this.targetSeries = targetSeriesText.split('&&');
            }
        }

        //画面起動時検索フラグチェック
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
        hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }
        return hasSearchValues;
    }

    //リスト項目取得
    public List<SelectOption> getProfitCalcTypeOptions() {

        List<SelectOption> lsReturn = new List<SelectOption>();
        lsReturn.add(new SelectOption('', ''));

        List<RecordTypeInfo> infos = AsiaProfitCalculation__c.SObjectType.getDescribe().getRecordTypeInfos();
            
        for (Schema.PicklistEntry f : AsiaProfitCalculation__c.ProfitCalculationType__c.getDescribe().getPicklistValues()) {
            for (RecordTypeInfo i : infos) {
               if (i.isAvailable() 
               // Ignore the Master Record Type, whose Id always ends with 'AAA'.
               // We check the Id because Name can change depending on the user's language.
                && !String.valueOf(i.getRecordTypeId()).endsWith('AAA')
                && i.getName() == f.getValue()) {
                    lsReturn.add(new selectOption(i.getName(), i.getName()));
                }
            }
        }

        return lsReturn;
    }

    public List<SelectOption> getStatusOptions() {

        List<SelectOption> lsReturn = new List<SelectOption>();        
        lsReturn.add(new SelectOption('', ''));

        List<Schema.PicklistEntry> ple = AsiaProfitCalculation__c.Status__c.getDescribe().getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            lsReturn.add(new SelectOption(f.getValue(), f.getLabel()));
        }       

        return lsReturn;
    }

    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);
    }

    //検索キーワード設定 WHERE句作成
    private String getContditions() {
        errFlg = false;
        List<String> conditions = new List<String>();
        //List<String> availableMarkets = String.isBlank(currentUser.AvailableMarket__c) ? new List<String>() : currentUser.AvailableMarket__c.split(';');
        //conditions.add(JEOLUtil.appendInText('TargetMarket__c', availableMarkets));
        conditions.add(JEOLUtil.appendInText('RecordTypeID', getListRecordTypeID()));


        if (String.isNotBlank(this.targetQTNo)) {
            conditions.add(JEOLUtil.appendLikeText('ProfitCalculationNo__c', this.targetQTNo));
        }
        if (String.isNotBlank(this.targetSalesPerson)) {
            conditions.add('((' +
                JEOLUtil.appendLikeText('SalesPerson__r.Name', this.targetSalesPerson) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('SalesPerson__r.UserCode__c', this.targetSalesPerson) +
                ') OR (' +
                JEOLUtil.appendLikeText('SalesAssistant__r.Name', this.targetSalesPerson) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('SalesAssistant__r.UserCode__c', this.targetSalesPerson) +
                '))' );
        }

        if (String.isNotBlank(this.targetCustomerCode)) {
            conditions.add('((' +
                JEOLUtil.appendAfterLikeText('ContractCode__c', this.targetCustomerCode) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('ContractAccount__r.Code__c', this.targetCustomerCode) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('ShipmentCode__c', this.targetCustomerCode) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('ShipmentAccount__r.Code__c', this.targetCustomerCode) +
                '))' );
        }
        if (String.isNotBlank(this.targetCustomerName)) {
            conditions.add('((' +
                JEOLUtil.appendLikeText('ContractName__c', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ContractAccount__r.Name', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ContractName1__c', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ContractName2__c', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ShipmentName__c', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ShipmentAccount__r.Name', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ShipmentName1__c', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ShipmentName2__c', this.targetCustomerName) +
                '))' );
        }
        if (String.isNotBlank(this.targetProjectNumber)) {
            conditions.add(JEOLUtil.appendLikeText('AsiaProjectMaster__r.Name', this.targetProjectNumber));
        }
        if (String.isNotBlank(this.targetCountry)) {
            conditions.add(JEOLUtil.appendLikeText('ShipmentCountry__c', this.targetCountry));
        }
        if (String.isNotBlank(this.targetModelType)) {            
            conditions.add('(ID IN (SELECT Parent__c ' +
                                  ' FROM AsiaProfitCalculationDetail__c ' +
                                  ' WHERE Category__c = \'A\' ' +
                                  ' AND Type__c = \'1\' ' + 
                                  ' AND ' + JEOLUtil.appendLikeText('ModelType__c', this.targetModelType) +
                                  '))');
        }

        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            conditions.add(JEOLUtil.appendInText('Series__c', this.targetSeries));
        }

        if (String.isNotBlank(this.targetProfitCalcType)) {
            conditions.add(JEOLUtil.appendEqualText('RecordType.Name', this.targetProfitCalcType));
        }

        if (String.isNotBlank(this.status)) {
            conditions.add(JEOLUtil.appendEqualText('Status__c', this.status));
        }

        try {
            if (String.isNotBlank(this.RegisteredDateFrom)) {
                Date fromDate = Date.parse(RegisteredDateFrom); //Date型2012-12-30 00:00:00に変換
                Datetime fromDt = Datetime.newInstance(fromDate.year(), fromDate.month(), fromDate.day()); // 一度Datetime型に変換
                String fromDateToStr = fromDt.format('yyyy-MM-dd'); // 'yyyy-MM-dd'形式でString型変換
System.debug('fromDateToStr = ' + fromDateToStr);
//                String fromDateToStr =fromDate.format();    //String型変換
//                fromDateToStr = fromDateToStr.replaceAll('/', '-'); // + 'T00:00:00Z';  //T00:00:00Z付与
                conditions.add(JEOLUtil.appendGreaterThanEqualText('IssueDate__c', fromDateToStr, false));
            }
            if (String.isNotBlank(this.RegisteredDateTo)) {
                Date toDate = Date.parse(RegisteredDateTo); //Date型2012-12-30 00:00:00に変換
                Datetime toDt = Datetime.newInstance(toDate.year(), toDate.month(), toDate.day()); // 一度Datetime型に変換
                String toDateToStr = toDt.format('yyyy-MM-dd'); // 'yyyy-MM-dd'形式でString型変換
System.debug('toDateToStr = ' + toDateToStr);
//                String toDateToStr =toDate.format();    //String型変換
//                toDateToStr = toDateToStr.replaceAll('/', '-'); // + 'T00:00:00Z';  //T00:00:00Z付与
                conditions.add(JEOLUtil.appendLessThanEqualText('IssueDate__c', toDateToStr, false));
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
        this.targetQTNo = null;
        this.targetSalesPerson = null;
        this.targetCustomerCode = null;
        this.targetCustomerName = null;
        this.targetProjectNumber = null;
        this.targetCountry = null;
        this.targetModelType = null;
        this.targetSeries = null;
        for (OptionDetail detail: this.SeriesOptions) {
            detail.setSelected(false);
        }
        this.targetProfitCalcType = null;
        this.status = null;
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
    public List<AsiaProfitCalculation__c> getRecords() {
        List<AsiaProfitCalculation__c> recs = null;
        if(this.ssc != null) {
            recs = (List<AsiaProfitCalculation__c>)this.ssc.getRecords();
        }
        if(recs == null){
            recs = new List<AsiaProfitCalculation__c>();
        }
        return recs;
    }

    //系列の選択パネル関連処理

    //系列選択
    public String getSelectedSeries() {

        String value = System.Label.JEOLAsia_ProjectMasterList_Label_None;
        Integer selectedCount = 0;
        Set<String> series = new Set<String>();

        for (OptionDetail detail: this.SeriesOptions) {
            if (detail.isSelected) {
                series.add(detail.option.getLabel());
                selectedCount++;
            }
        }

        if (selectedCount == this.SeriesOptions.size()) {
            //すべて選択されている場合
            value = System.Label.JEOLAsia_ProjectMasterList_Label_All;
        } else if (series.size() > 0) {
            //上記以外
            value = String.join(new List<String>(series), ', ');
        }
        return value;
    }

    //すべて選択
    public void seriesSelectAllSelect() {
        List<OptionDetail> seriesOptions = this.SeriesOptions;
        for (OptionDetail detail: seriesOptions) {
            detail.isSelected = true;
        }
    }

    //選択解除
    public void seriesSelectAllDeselect() {
        List<OptionDetail> seriesOptions = this.SeriesOptions;
        for (OptionDetail detail: seriesOptions) {
            detail.isSelected = false;
        }
    }

    //キャンセル
    public void seriesSelectCancel() {
        List<OptionDetail> seriesOptions = this.SeriesOptions;
        for (OptionDetail detail: seriesOptions) {
            detail.cancel();
        }
    }

    //適用する
    public void seriesSelectApply() {
        Set<String> series = new Set<String>();
        List<OptionDetail> seriesOptions = this.SeriesOptions;
        for (OptionDetail detail: seriesOptions) {
            detail.apply();
            if (detail.isSelected) {
                series.add(detail.option.getValue());
            }
        }
        targetSeries = new List<String>(series);
    }

    //オプション詳細クラス
    public class OptionDetail {
        public Boolean isSelected{get; set;}
        public Boolean beforeSelected{get; set;}
        public SelectOption option{get; set;}
        public String val{get; set;}
        public OptionDetail(SelectOption option, Boolean isSelected) {
            this.option = option;
            this.isSelected = isSelected;
            this.beforeSelected = this.isSelected;
        }

        public void cancel() {
            this.isSelected = this.beforeSelected;
        }

        public void apply() {
            this.beforeSelected = this.isSelected;
        }

        public void setSelected(Boolean isSelected) {
            this.isSelected = isSelected;
            this.beforeSelected = this.isSelected;
        }
    }

    public List<id> getListRecordTypeID(){

        List<id> options = new List<id>();

        List<RecordTypeInfo> infos = AsiaProfitCalculation__c.SObjectType.getDescribe().getRecordTypeInfos();
        // If there are 2 or more RecordTypes...
        if (infos.size() > 1) {
            for (RecordTypeInfo i : infos) {
               if (i.isAvailable() 
               // Ignore the Master Record Type, whose Id always ends with 'AAA'.
               // We check the Id because Name can change depending on the user's language.
                && !String.valueOf(i.getRecordTypeId()).endsWith('AAA'))
                options.add(i.getRecordTypeId());
            }
        } else {
            // Otherwise there's just the Master record type,
            // so add it in, since it MUST always be available
            options.add(infos[0].getRecordTypeId());
        }

        return options;
    }

}