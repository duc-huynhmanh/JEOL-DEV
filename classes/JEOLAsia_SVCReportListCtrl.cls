public with sharing class JEOLAsia_SVCReportListCtrl {
    
    //検索条件格納用
    private String conditionStr = null;
    //現在のソート対象項目
    private String orderBy = null;
    //ページ
    private Integer pageNum = 1;
    private Integer pageSize = 50;
    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';
    // 検索エラーフラグ
    public Boolean errFlg = false;
    //現在ソート中の対象項目
    private String selectedOrderTarget = null;
    //LIMIT値格納用
    private String limitStr = null;
    //ソートする項目指定
    public String orderTarget{get;set;}
    //
    public String SVCURL{get;set;}
    //昇順、降順指定
    public Boolean orderDesc{get; set;}
    //オブジェクト
    public SVC_Report__c rec{get; set;}
    //StandardSetController
    public ApexPages.StandardSetController ssc{get; set;}
    
    //検索条件項目
    public String targetSvcNumber{get; set;}        	//SVC Number
    public String RegisteredDateTo { get; set;}			//Register Date
    public String targetCustomerCode{get; set;}         //Customer Code(取引先コード)
    public String targetCustomerName{get; set;}         //Customer Name(取引先名)
    public String targetCountry{get; set;}				//国
    public String targetModel{get; set;}                //Model
    public List<String> targetSeries{get; set;}         //系列
    public String targetSerialNumber{get; set;}         //SerialNumber
    public String targetFreeword{get; set;}				//Free word
    
    
    //系列項目設定
    public List<OptionDetail> SeriesOptions{get; set;}
    
    //保持項目有無判定
    private static final String COOKIE_LABEL_SVCNUM = 'SvcNum';
    private static final String COOKIE_LABEL_CUSTMER_CODE = 'CustomerCode';
    private static final String COOKIE_LABEL_CUSTMER_NAME = 'CustomerName';
    private static final String COOKIE_LABEL_COUNTRY = 'SvcCountry';
    private static final String COOKIE_LABEL_MODEL = 'Model';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_SERIAL_NUMBEL = 'serialNumber';
    private static final String COOKIE_LABEL_FREE_WORD = 'FreeWord';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_SVCReportList';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    
    //cookie有効期限
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
    
    private static final String BASE_QUERY_STRING = 'SELECT Name,BuyerName__c,CustomerName__c,ProjectMaster__r.ContractName__c,ProjectMaster__r.ContractName1__c,ProjectMaster__r.ContractName2__c,ProjectMaster__r.ContractAccount__r.Country__c,ProjectMaster__r.ContractAccount__r.CountryCode__c,FreeWord__c,Model__c,RegisterDate__c,SerialNumber__c,Series__c,SVCTitle__c,LastModifiedDate FROM SVC_Report__c';
    						  
    
    private static final String QUERY_LIMIT_MAX = '10000'; //クエリ件数全件表示用    
    
    //コンストラクタ
    public JEOLAsia_SVCReportListCtrl(){
        SVCURL = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        this.orderDesc = true;
        this.orderTarget = 'LastModifiedDate';
        
        Boolean hasSearchValue = initFieldFromCookie();//保持項目有無チェック
        
        // 系列項目設定
        List<optionDetail> SeriesOptions = new List<optionDetail>();
        Set<String> series;
        
        if(this.targetSeries != null){
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
                SeriesOptions.add(new OptionDetail(option, isSelected));
            }
        }
        this.SeriesOptions = SeriesOptions;
        
        if (hasSearchValue) {
             recordSearch();
        }
    }
    
    //cookie保存
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        
        cookies.add(new Cookie(COOKIE_LABEL_SVCNUM, this.targetSvcNumber, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        
        String targetSeriesText = '';
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            targetSeriesText = String.join(this.targetSeries, '&&');
        }
        cookies.add(new Cookie(COOKIE_LABEL_SERIES, targetSeriesText, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_CODE, this.targetCustomerCode, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTMER_NAME, this.targetCustomerName, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_COUNTRY, this.targetCountry, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_MODEL, this.targetModel, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SERIAL_NUMBEL, this.targetSerialNumber, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_FREE_WORD, this.targetFreeword, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));  // 画面起動時検索フラグ
        
        Apexpages.currentPage().setCookies(cookies);
        
    }
    
    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        
        if(cookies.containsKey('SvcNum')){
            this.targetSvcNumber = cookies.get('SvcNum').getValue();
        }
        if(cookies.containsKey('CustomerCode')){
            this.targetCustomerCode = cookies.get('CustomerCode').getValue();
        }
        if(cookies.containsKey('CustomerName')){
            this.targetCustomerName = cookies.get('CustomerName').getValue();
        }
        if(cookies.containsKey('Model')){
            this.targetModel = cookies.get('Model').getValue();
        }
        if(cookies.containsKey('SerialNumber')){
            this.targetSerialNumber = cookies.get('SerialNumber').getValue();
        }
        if(cookies.containsKey('Country')){
            this.targetCountry = cookies.get('Country').getValue();
        }
        if(cookies.containsKey('FreeWord')){
            this.targetFreeword = cookies.get('FreeWord').getValue();
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
        system.debug('■■■this.targetSeries:' + this.targetSeries);
        // SVC Number 
        if (String.isNotBlank(this.targetSvcNumber)) {
            
            conditions.add(JEOLUtil.appendLikeText('Name', this.targetSvcNumber));
        }
        if (String.isNotBlank(this.targetCustomerCode)) {
            conditions.add(JEOLUtil.appendAfterLikeText('CustomerCode__c', this.targetCustomerCode));
            
        }
        if (String.isNotBlank(this.targetCustomerName)) {
             conditions.add(JEOLUtil.appendLikeText('CustomerName__c', this.targetCustomerName));
            /*conditions.add('((' +
                           JEOLUtil.appendLikeText('CustomerName__c', this.targetCustomerName) +
                           ') OR (' +
                           JEOLUtil.appendLikeText('ProjectMaster__r.ContractName__c', this.targetCustomerName) +
                           ') OR (' +
                           JEOLUtil.appendLikeText('ProjectMaster__r.ContractName1__c', this.targetCustomerName) +
                           ') OR (' +
                           JEOLUtil.appendLikeText('ProjectMaster__r.ContractName2__c', this.targetCustomerName) +
                           '))' );*/           
        }
        //Country Customer
        if(String.isNotBlank(this.targetCountry)){
            conditions.add(JEOLUtil.appendLikeText('CustomerCountry__c',this.targetCountry));
            /*conditions.add('((' +
                           JEOLUtil.appendLikeText('ProjectMaster__r.ContractAccount__r.CountryCode__c',this.targetCountry) +
                           ') OR (' +
                           JEOLUtil.appendLikeText('ProjectMaster__r.ContractAccount__r.Country__c',this.targetCountry) +   
                           '))' );*/
        }
        /* Model */
        if (String.isNotBlank(this.targetModel)) {
            conditions.add(JEOLUtil.appendLikeText('Model__c', this.targetModel));
        }
        // Series 
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            conditions.add(JEOLUtil.appendInText('Series__c', this.targetSeries));
        }
        // Free word 
        if(String.isNotBlank(this.targetFreeword)) {
            conditions.add(JEOLUtil.appendLikeText('FreeWord__c', this.targetFreeword));
        }
        //Serial Number
        if (String.isNotBlank(this.targetSerialNumber)) {
            conditions.add(JEOLUtil.appendLikeText('SerialNumber__c', this.targetSerialNumber));
        }
        return JEOLUtil.joinWhereConditions(conditions);
    }
    
    //レコード取得メソッド WHERE句、LIMIT句設定&検索時のSOQL発行
    public void recordSearch() {
        
        String queryStr = BASE_QUERY_STRING; //SELECT、FROM設定
        system.debug('BASE_QUERY_STRING：' + queryStr.length());
        this.initSearchFlg = 'true';         //画面起動時検索フラグON
        
        //検索WHERE句作成
        String conditionStr = getContditions();
        
        //ソート項目(ORDER BY)取得
        String orderBy = getOrderBy(); //ORDER BY句、ASC/DESC、nulls last
        //最大10000件
        String range = QUERY_LIMIT_MAX;
        String limitStr = ' LIMIT ' + range;
        queryStr += conditionStr + orderBy + limitStr;
        if(errFlg){
            system.debug('errFlg：' + errFlg);
            this.ssc = null;
            
        }else {
            this.ssc = createSsc(queryStr);
            this.conditionStr = conditionStr;
            system.debug('conditionStr' + conditionStr);
            this.limitStr = limitStr;
            system.debug('ssc：' + ssc);
        }
        saveInputValues(); //cookie保存
    }
    //検索キーワードクリアメソッド
    public void searchItemClear() {
        this.ssc = null;
        this.targetSvcNumber = null;
        this.targetCustomerName = null;
        this.targetCustomerCode = null;
        this.targetCountry = null;
        this.targetModel = null;
        this.targetSeries = null;
        this.targetSerialNumber = null;
        this.targetFreeword = null;
        for (OptionDetail detail: this.SeriesOptions) {
            detail.setSelected(false);
        }
        
        saveInputValues();  //cookie保存
    }
    
    
    //ソートSOQL発行  WHERE句、LIMITを使って、SOQL発行
    public void switchingOrder(){
        String querystr = BASE_QUERY_STRING;
        //降順の場合、null値を最後に表示
        //同じ項目を選択

        if(this.orderTarget == this.selectedOrderTarget) {
            this.orderDesc = !this.orderDesc;
            //降順の場合、null値を最後に表示
        } else { //別の項目を選択
            this.orderDesc = false;
            this.limitStr = limitStr;
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
    
    private ApexPages.StandardSetController createSsc(String queryStr) {
        system.debug('■■■queryStr:' + queryStr);
        ApexPages.StandardSetController localSsc = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));
        system.debug('localSsc:'+ localSsc);
        localSsc.setPageSize(this.pageSize);
        localSsc.setPageNumber(this.pageNum);
        return localSsc;
    }
     //一括取得したレコードを一覧表示させるためにPage(Records)に渡す
     public List<SVC_Report__c> getRecords() {
        List<SVC_Report__c> recs = null;
        if(this.ssc != null) {
            recs = (List<SVC_Report__c>)this.ssc.getRecords();
        }
        if(recs == null){
            recs = new List<SVC_Report__c>();

        }
        system.debug('recs'+recs);
        return recs;
    }
  /*  public List<infor> getRecords() {
        List<infor> inforList = new List<infor>();
        List<Id> idlist = new List<Id>();
        List<SVC_Report__c> recs = null;
        
        if(this.ssc != null) {
            system.debug(this.ssc.getRecords());
            recs = (List<SVC_Report__c>)this.ssc.getRecords();
        }
        if(recs == null){
            recs = new List<SVC_Report__c>();

        }
        for(SVC_Report__c svc : recs){
            idlist.add(svc.ProjectMaster__c);
        }
        List<AsiaProjectMaster__c> ProjectList = [SELECT Series__c,	SerialNumber__c,ContractName__c,ShipmentName__c,Model__c 
                                                  FROM AsiaProjectMaster__c
                                                  WHERE id IN:idlist ];
            
            //99999
            List<Id> idlist = new List<Id>();
            for (SVC_Report__c is :recs) {
                idlist.add(is.ProjectMaster__c);
            }
            list<fuObj> fulist = [selece fu__c,fuaa__c from fuobj where id = : idlist];
            
            retun List<infor> var='a';
            a.ziObj.aa__c;
            a.fuObj.fu__c;
            public class infor{
                public ziObj {}
                public fu {}
            }
            //99999
            
        }
        if(recs == null){
            recs = new List<SVC_Report__c>();

        }
        system.debug('recs'+inforList);
        return inforList;
    }*/
    
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
    public class infor{
        public SVC_Report__c SVC_Report{get; set;}
        public AsiaProjectMaster__c ProjectMaster{get; set;}
    }
}