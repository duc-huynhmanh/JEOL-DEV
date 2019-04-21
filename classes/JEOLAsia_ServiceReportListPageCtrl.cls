public with sharing class JEOLAsia_ServiceReportListPageCtrl {

    //検索条件格納用
    private String conditionStr = null;
    //現在のソート対象項目
    private String orderBy = null;
    //LIMIT値格納用
    private String limitStr = null;
    //オブジェクト

    public AsiaServiceReport__c filterRec {get; set;}
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
    public String targetRecords{get; set;}              // レコード
    public String targetProjectNumber{get; set;}        // Project Number
    public String targetModel{get; set;}                // Model
    public String targetSerialNumber{get; set;}         // Serial Number
    public String targetEndUserCode{get; set;}          // End User Code
    public String targetEndUserName{get; set;}          // End User Name
    public String targetEndUserCountry{get; set;}       // End User Country
    public String targetBuyerCode{get; set;}            // Buyer Code
    public String targetBuyerName{get; set;}            // Buyer Name
    public String targetContractDate {get; set;}        // Contract Date
    public String targetWarrantyDate {get; set;}        // Warranty Date

    public List<String> targetSeries{get; set;}         //系列

    public List<OptionDetail> SeriesOptions{get; set;}  //選択系列

    //保持項目有無判定
    private static final String COOKIE_LABEL_PROJECT_NUMBER = 'ProjectNumber';
    private static final String COOKIE_LABEL_MODEL = 'Model';
    private static final String COOKIE_LABEL_SERIAL_NUMBER = 'SerialNumber';
    private static final String COOKIE_LABEL_END_USER_CODE = 'EndUserCode';
    private static final String COOKIE_LABEL_END_USER_NAME = 'EndUserName';
    private static final String COOKIE_LABEL_END_USER_COUNTRY = 'EndUserCountry';
    private static final String COOKIE_LABEL_BUYER_CODE = 'BuyerCode';
    private static final String COOKIE_LABEL_BUYER_NAME = 'BuyerName';
    private static final String COOKIE_LABEL_CONTRACT_DATE = 'ContractDate';
    private static final String COOKIE_LABEL_WARRANTY_DATE = 'WarrantyDate';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    private static final String COOKIE_PATH = '/apex/JEOLAsia_ServiceReportListPage';
    private static final Integer COOKIE_EXPIRATION_DATE = -1;

    //クエリ
    private static final String BASE_QUERY_STRING = ' SELECT Id, name, ServiceNumber__c' +
                                                    ' FROM AsiaServiceReport__c';

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
    public JEOLAsia_ServiceReportListPageCtrl() {

        this.targetRecords = SELECTOPTION_LASTMODIFIED;
        this.orderDesc = true;
        this.orderTarget = 'LastModifiedDate';

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

        cookies.add(new Cookie(COOKIE_LABEL_PROJECT_NUMBER, this.targetProjectNumber, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_MODEL, this.targetModel, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERIAL_NUMBER, this.targetSerialNumber, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_END_USER_CODE, this.targetEndUserCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_END_USER_NAME, this.targetEndUserName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_END_USER_COUNTRY, this.targetEndUserCountry, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_BUYER_CODE, this.targetBuyerCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_BUYER_NAME, this.targetBuyerName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        String targetSeriesText = '';
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            targetSeriesText = String.join(this.targetSeries, '&&');
        }
        cookies.add(new Cookie(COOKIE_LABEL_SERIES, targetSeriesText, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        String contractDateStr;
        if (this.targetContractDate != null) {
            contractDateStr = targetContractDate.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACT_DATE, contractDateStr, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        String warrantyDateStr;
        if (this.targetWarrantyDate != null) {
            warrantyDateStr = this.targetWarrantyDate.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_WARRANTY_DATE, warrantyDateStr, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);
    }

    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;

        if(cookies.containsKey(COOKIE_LABEL_PROJECT_NUMBER)){
            this.targetProjectNumber = cookies.get(COOKIE_LABEL_PROJECT_NUMBER).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_MODEL)){
            this.targetModel = cookies.get(COOKIE_LABEL_MODEL).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_SERIAL_NUMBER)){
            this.targetSerialNumber = cookies.get(COOKIE_LABEL_SERIAL_NUMBER).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_END_USER_CODE)){
            this.targetEndUserCode = cookies.get(COOKIE_LABEL_END_USER_CODE).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_END_USER_NAME)){
            this.targetEndUserName = cookies.get(COOKIE_LABEL_END_USER_NAME).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_END_USER_COUNTRY)){
            this.targetEndUserCountry = cookies.get(COOKIE_LABEL_END_USER_COUNTRY).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_BUYER_CODE)){
            this.targetBuyerCode = cookies.get(COOKIE_LABEL_BUYER_CODE).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_BUYER_NAME)){
            this.targetBuyerName = cookies.get(COOKIE_LABEL_BUYER_NAME).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_CONTRACT_DATE)){
            this.targetContractDate = cookies.get(COOKIE_LABEL_CONTRACT_DATE).getValue().replaceAll('-', '/');
        }

        if(cookies.containsKey(COOKIE_LABEL_WARRANTY_DATE)){
            this.targetWarrantyDate = cookies.get(COOKIE_LABEL_WARRANTY_DATE).getValue().replaceAll('-', '/');
        }

        if(cookies.containsKey(COOKIE_LABEL_SERIES)){
            String targetSeriesText = cookies.get(COOKIE_LABEL_SERIES).getValue();
            if (String.isNotBlank(targetSeriesText)) {
                this.targetSeries = targetSeriesText.split('&&');
            }
        }

        //画面起動時検索フラグチェック
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0) {
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') || hasSearchValues;
        }

        return hasSearchValues;
    }

    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);
    }

    //検索キーワード設定 WHERE句作成
    private String getConditions() {
        errFlg = false;
        List<String> conditions = new List<String>();

        if (String.isNotBlank(this.targetProjectNumber)) {
            conditions.add(JEOLUtil.appendLikeText('ProjectNumber__c', this.targetProjectNumber));
        }

        if (String.isNotBlank(this.targetModel)) {
            conditions.add(JEOLUtil.appendAfterLikeText('Model__c', this.targetModel));
        }

        if (String.isNotBlank(this.targetSerialNumber)) {
            conditions.add(JEOLUtil.appendAfterLikeText('SerialNumber__c', this.targetSerialNumber));
        }

        if (String.isNotBlank(this.targetEndUserCode)) {
            conditions.add(JEOLUtil.appendAfterLikeText('ShipmentCode__c', this.targetEndUserCode));
        }

        if (String.isNotBlank(this.targetEndUserName)) {
            conditions.add(JEOLUtil.appendLikeText('ShipmentName__c', this.targetEndUserName));
        }

        if (String.isNotBlank(this.targetEndUserCountry)) {
            conditions.add(JEOLUtil.appendAfterLikeText('ShipmentCountry__c', this.targetEndUserCountry));
        }

        if (String.isNotBlank(this.targetBuyerCode)) {
            conditions.add(JEOLUtil.appendAfterLikeText('ContractCode__c', this.targetBuyerCode));
        }

        if (String.isNotBlank(this.targetBuyerName)) {
            conditions.add(JEOLUtil.appendLikeText('ContractName__c', this.targetBuyerName));
        }

        try {
            if (String.isNotBlank(this.targetContractDate)) {
                Date contractDate = Date.parse(targetContractDate);
                Datetime contractDt = Datetime.newInstance(contractDate.year(), contractDate.month(), contractDate.day());
                String contractDateToStr = contractDt.format('yyyy-MM-dd');

                conditions.add('(Id IN (SELECT ProjectMaster__c' +
                                      ' FROM AsiaMaintenanceContractManagement__c' +
                                      ' WHERE Status__c = \'2\'' +
                                      ' AND (NewContractStartDate__c <> NULL OR NewContractEndDate__c <> NULL)' +
                                      ' AND (NewContractStartDate__c = NULL OR NewContractStartDate__c <= ' + contractDateToStr + ')' +
                                      ' AND (NewContractEndDate__c = NULL OR NewContractEndDate__c >= ' + contractDateToStr + ')' +
                                      '))');

            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contract Date should be with a YYYY/MM/DD format.'));
            errFlg = true;
        }

        try {
            if (String.isNotBlank(this.targetWarrantyDate)) {
                Date warrantyDate = Date.parse(targetwarrantyDate);
                Datetime warrantyDt = Datetime.newInstance(warrantyDate.year(), warrantyDate.month(), warrantyDate.day());
                String warrantyDateToStr = warrantyDt.format('yyyy-MM-dd');
                conditions.add('(ContractStartDate__c <> NULL OR ContractEndDate__c <> NULL)');
                conditions.add('(ContractStartDate__c = NULL OR ContractStartDate__c <=' + warrantyDateToStr + ')');
                conditions.add('(ContractEndDate__c = NULL OR ContractEndDate__c >=' + warrantyDateToStr + ')');
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contract Date should be with a YYYY/MM/DD format.'));
            errFlg = true;
        }

        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            conditions.add(JEOLUtil.appendInText('Series__c', this.targetSeries));
        }

        return JEOLUtil.joinWhereConditions(conditions);
    }

    //検索キーワードクリアメソッド
    public void searchItemClear() {
        this.ssc = null;

        this.targetProjectNumber = null;
        this.targetModel = null;
        this.targetSerialNumber = null;
        this.targetEndUserCode = null;
        this.targetEndUserName = null;
        this.targetEndUserCountry = null;
        this.targetBuyerCode = null;
        this.targetBuyerName = null;
        this.targetContractDate = null;
        this.targetWarrantyDate = null;

        this.targetSeries = null;
        for (OptionDetail detail: this.SeriesOptions) {
            detail.setSelected(false);
        }

        saveInputValues();  //cookie保存
    }

    //検索条件(ラジオボタン)でのレコード取得メソッド WHERE句、LIMIT句設定&検索時のSOQL発行
    public void recordSearch() {
        String queryStr = BASE_QUERY_STRING;//SELECT、FROM設定
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        //検索WHERE句作成
        String conditionStr = getConditions();

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
    public List<AsiaServiceReport__c> getRecords() {

        List<AsiaServiceReport__c> recs = null;
        if(this.ssc != null) {
            recs = (List<AsiaServiceReport__c>)this.ssc.getRecords();
        }
        if(recs == null){
            recs = new List<AsiaServiceReport__c>();
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

}