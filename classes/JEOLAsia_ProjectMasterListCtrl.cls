public with sharing class JEOLAsia_ProjectMasterListCtrl{

    //検索条件格納用
    private String conditionStr = null;
    //現在のソート対象項目
    private String orderBy = null;
    //LIMIT値格納用
    private String limitStr = null;
    //オブジェクト
    public AsiaProjectMaster__c rec{get; set;}
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
    public String targetRecords{get; set;}              //レコード
    public String targetSalesPerson{get; set;}          //営業担当者
    public String targetCountry{get; set;}				//国
    public String targetContractCode{get; set;}         //契約先コード
    public List<String> targetSeries{get; set;}         //系列
    public String RegisteredDateFrom { get; set;}       //登録日From
    public String RegisteredDateTo { get; set;}         //登録日to
    public String targetProjectNumber{get; set;}        //Project Number
    public String targetCustomerName{get; set;}         //Customer Name
    public String targetCustomerCode{get; set;}         //Customer Code
    public String targetBuyerName{get; set;}           //Buyer Name
    public String targetBuyerCode{get; set;}           //Buyer Code
    public String targetModel{get; set;}                //Model
    public String targetSerialNumber{get; set;}         //SerialNumber

    //系列項目設定
    public List<OptionDetail> SeriesOptions{get; set;}

    //保持項目有無判定
    private static final String COOKIE_LABEL_SALESPERSON = 'SalesPerson';
    private static final String COOKIE_LABEL_COUNTRY = 'SCountry';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    private static final String COOKIE_PATH = '/apex/JEOLAsia_ProjectMasterList';
    private static final String COOKIE_LABEL_PRONUM = 'ProNum';
    private static final String COOKIE_LABEL_CUSTMER_NAME = 'CustomerName';
    private static final String COOKIE_LABEL_CUSTMER_CODE = 'CustomerCode';
    private static final String COOKIE_LABEL_BUYER_NAME = 'BuyerName';
    private static final String COOKIE_LABEL_BUYER_CODE = 'BuyerCode';
    private static final String COOKIE_LABEL_MODEL = 'Model';
    private static final String COOKIE_LABEL_SERIAL_NUMBEL = 'serialNumber';

    //cookie有効期限
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
    //クエリ
/*
        'SELECT
           name,
           ProjectNumber__c,
           Series__c,
           Model__c,
           SalesPerson__c,
           SalesAssistant__c,
           ShipmentName__c,
           ShipmentName1__c,
           ShipmentName2__c,
           ContractName__c,
           ContractName1__c,
           ContractName2__c,
           ContractCode__c,
           ShipmentCode__c,
           ContractPrice__c,
           CurrencyContractPrice__c,
           CreatedDateFormula__c,
           LastModifiedDatef,
           ContractAccount__r.code__c
         FROM
           AsiaProjectMaster__c';
*/
    private static final String BASE_QUERY_STRING = 'SELECT Name,ContractAccount__r.CountryCode__c,ContractAccount__r.Country__c,ShipmentAccount__c,ProjectNumber__c, Series__c, Model__c, SalesPerson__r.UserCode__c,SalesPerson__r.Name,SalesAssistant__c, ShipmentName__c, ShipmentName1__c, ShipmentName2__c, SerialNumber__c,ContractName__c, ContractName1__c, ContractName2__c, ContractCode__c, ShipmentCode__c, ContractPrice__c, CurrencyContractPrice__c, CreatedDateFormula__c,ContractEndDate__c,CertificatdDate__c,SalesAssistant__r.Name, LastModifiedDate FROM AsiaProjectMaster__c';
								
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
    public JEOLAsia_ProjectMasterListCtrl() {
        this.targetRecords = SELECTOPTION_ALL;
        this.orderDesc = true;
        this.orderTarget = 'LastModifiedDate';

        Boolean hasSearchValue = initFieldFromCookie();//保持項目有無チェック

        // 系列項目設定
        List<optionDetail> SeriesOptions = new List<optionDetail>();
        Set<String> series;
        if (this.targetSeries != null) {
            series = new Set<String>(this.targetSeries);
system.debug('■■■series ：' + series );
        }

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

system.debug('■■■コンストラクタ、系列：' + this.SeriesOptions);

        if (hasSearchValue) {
            system.debug('recordSearchメソッドコール');
            recordSearch();
        }
    }

    //cookie保存
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_PRONUM, this.targetProjectNumber, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        String targetSeriesText = '';
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            targetSeriesText = String.join(this.targetSeries, '&&');
        }
        cookies.add(new Cookie(COOKIE_LABEL_SERIES, targetSeriesText, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_CODE, this.targetCustomerCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_NAME, this.targetCustomerName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_BUYER_CODE, this.targetBuyerCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_BUYER_NAME, this.targetBuyerName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_MODEL, this.targetModel, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERIAL_NUMBEL, this.targetSerialNumber, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON, this.targetSalesPerson, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_COUNTRY, this.targetCountry, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);
        system.debug('Apexpages.currentPage().setCookies(cookies);' + cookies);
    }

    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;

        if(cookies.containsKey('ProNum')){
                this.targetProjectNumber = cookies.get('ProNum').getValue();
        }
        if(cookies.containsKey('Series')){
            String targetSeriesText = cookies.get('Series').getValue();
            if (String.isNotBlank(targetSeriesText)) {
                this.targetSeries = targetSeriesText.split('&&');
            }
system.debug('■■■targetSeriesText ：' + this.targetSeries);
        }
        if(cookies.containsKey('CustomerName')){
                this.targetCustomerName = cookies.get('CustomerName').getValue();
        }
        if(cookies.containsKey('CustomerCode')){
                this.targetCustomerCode = cookies.get('CustomerCode').getValue();
        }
        if(cookies.containsKey('BuyerName')){
                this.targetBuyerName = cookies.get('BuyerName').getValue();
        }
        if(cookies.containsKey('BuyerCode')){
                this.targetBuyerCode = cookies.get('BuyerCode').getValue();
        }
        if(cookies.containsKey('Model')){
                this.targetModel = cookies.get('Model').getValue();
        }
        if(cookies.containsKey('SerialNumber')){
                this.targetSerialNumber = cookies.get('SerialNumber').getValue();
        }
        if(cookies.containsKey('SalesPerson')){
                this.targetSalesPerson = cookies.get('SalesPerson').getValue();
        }
        if(cookies.containsKey('Country')){
                this.targetCountry = cookies.get('Country').getValue();
        }

        //画面起動時検索フラグチェック
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }
        return hasSearchValues;
    }

    //リスト項目取得
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);
    }

    //検索キーワード設定 WHERE句作成
    private String getContditions() {
        errFlg = false;
        List<String> conditions = new List<String>();

system.debug('■■■this.targetProjectNumber:' + this.targetProjectNumber);
system.debug('■■■this.targetCustomerCode:' + this.targetCustomerCode);
system.debug('■■■this.targetCustomerName:' + this.targetCustomerName);
system.debug('■■■this.targetModel:' + this.targetModel);
system.debug('■■■this.targetSalesPerson:' + this.targetSalesPerson);
system.debug('■■■this.targetSeries:' + this.targetSeries);

        /* Project Number */
        if (String.isNotBlank(this.targetProjectNumber)) {
            //conditions.add(JEOLUtil.appendLikeText('ProjectNumber__c', this.targetProjectNumber));
            conditions.add(JEOLUtil.appendLikeText('Name', this.targetProjectNumber));
        }

        /* Customer Code */
        if (String.isNotBlank(this.targetCustomerCode)) {
            conditions.add(JEOLUtil.appendAfterLikeText('ContractCode__c', this.targetCustomerCode));
            /*conditions.add('((' +
                JEOLUtil.appendAfterLikeText('ContractCode__c', this.targetCustomerCode) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('ShipmentCode__c', this.targetCustomerCode) +
                '))' );*/
        }

        // Customer Name 
        if (String.isNotBlank(this.targetCustomerName)) {
            //conditions.add(JEOLUtil.appendAfterLikeText('CustomerName__c', this.targetCustomerName));
            conditions.add('((' +
                JEOLUtil.appendLikeText('ContractName__c', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ContractName1__c', this.targetCustomerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ContractName2__c', this.targetCustomerName) +
                '))' );
                
        }
        //Buyer Code
        if (String.isNotBlank(this.targetBuyerCode)) {
            conditions.add(JEOLUtil.appendAfterLikeText('ShipmentCode__c', this.targetBuyerCode));
        }
		//Buyer Name
        if (String.isNotBlank(this.targetBuyerName)) {
              conditions.add('((' +
                JEOLUtil.appendLikeText('ShipmentName__c', this.targetBuyerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ShipmentName1__c', this.targetBuyerName) +
                ') OR (' +
                JEOLUtil.appendLikeText('ShipmentName2__c', this.targetBuyerName) +
                '))' );
        }

        /* Model */
        if (String.isNotBlank(this.targetModel)) {
            conditions.add(JEOLUtil.appendLikeText('Model__c', this.targetModel));
        }
        //Serial Number
        if (String.isNotBlank(this.targetSerialNumber)) {
            conditions.add(JEOLUtil.appendLikeText('SerialNumber__c', this.targetSerialNumber));
        }

        /* Salesperson */
        if (String.isNotBlank(this.targetSalesPerson)) {
            conditions.add('((' +
                JEOLUtil.appendLikeText('SalesPerson__r.Name', this.targetSalesPerson) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('SalesPerson__r.UserCode__c', this.targetSalesPerson) +
               /* ') OR (' +
                JEOLUtil.appendLikeText('SalesAssistant__r.Name', this.targetSalesPerson) +
                ') OR (' +
                JEOLUtil.appendAfterLikeText('SalesAssistant__r.UserCode__c', this.targetSalesPerson) +*/
                '))' );
        }
        //Country Customer
        if(String.isNotBlank(this.targetCountry)){
            conditions.add('((' +
                 JEOLUtil.appendLikeText('ContractAccount__r.CountryCode__c',this.targetCountry) +
                 ') OR (' +
                 JEOLUtil.appendLikeText('ContractAccount__r.Country__c',this.targetCountry) +   
                 '))' );
            
         }

        /* Series */
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
                conditions.add(JEOLUtil.appendInText('Series__c', this.targetSeries));
        }
       

        return JEOLUtil.joinWhereConditions(conditions);
    }

    //検索キーワードクリアメソッド
    public void searchItemClear() {
        this.ssc = null;

        this.targetProjectNumber = null;
        this.targetCustomerName = null;
        this.targetCustomerCode = null;
		this.targetBuyerName = null;
        this.targetBuyerCode = null;
        this.targetModel = null;
        this.targetSerialNumber = null;
        this.targetSalesPerson = null;
		this.targetCountry = null;
        this.targetSeries = null;
        for (OptionDetail detail: this.SeriesOptions) {
            detail.setSelected(false);
        }

        saveInputValues();  //cookie保存
    }

    //検索条件(ラジオボタン)でのレコード取得メソッド WHERE句、LIMIT句設定&検索時のSOQL発行
    public void recordSearch() {

        String queryStr = BASE_QUERY_STRING; //SELECT、FROM設定
        system.debug('BASE_QUERY_STRING：' + queryStr.length());
        this.initSearchFlg = 'true';         //画面起動時検索フラグON

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
	system.debug('queryStr：' + limitStr.length());
        //SELECT文、 WHERE句、LIMIT句を連結
        queryStr += conditionStr + orderBy + limitStr;

        system.debug('queryStr：' + queryStr.length());
        if(errFlg){
            system.debug('errFlg：' + errFlg);
            this.ssc = null;
            
        }else {
            this.ssc = createSsc(queryStr);
            system.debug('conditionStr：' + ssc);
            this.conditionStr = conditionStr;
            system.debug('conditionStr：' + conditionStr);
            system.debug('errFlg2：' + errFlg);
            this.limitStr = limitStr;
            system.debug('limitStr：' + limitStr);
        }
        saveInputValues(); //cookie保存
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
        String descStr = ''; //昇順/降順、nulls last作成用

        //降順の場合、NULL値は最後に表示
        if(this.orderDesc){
            descStr = ' Desc nulls last ';
        }
        orderByStr += descStr; //ORDER BY句、ASC/DESC、nulls last作成
        return orderByStr;
    }

    //レコードをVFに出力するにあたっての操作
    private ApexPages.StandardSetController createSsc(String queryStr) {
system.debug('■■■queryStr:' + queryStr);
        ApexPages.StandardSetController localSsc = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));
        localSsc.setPageSize(this.pageSize);
        localSsc.setPageNumber(this.pageNum);
        return localSsc;
    }

    //一括取得したレコードを一覧表示させるためにPage(Records)に渡す
    public List<AsiaProjectMaster__c> getRecords() {
        List<AsiaProjectMaster__c> recs = null;
        if(this.ssc != null) {
            recs = (List<AsiaProjectMaster__c>)this.ssc.getRecords();
        }
        if(recs == null){
            recs = new List<AsiaProjectMaster__c>();

        }
        system.debug('recs'+recs);
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

system.debug('■■■selectedCount :' + selectedCount);
system.debug('■■■series:' + series);
system.debug('■■■value:' + value);
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