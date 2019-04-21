public with sharing class JEOLAsia_MaintenanceListToRenewAdd_ctrl extends JEOL_SearchBase_ctrl {

    //検索条件項目
    public String targetRecords{get; set;}              //レコード
    public String targetSalesPerson{get; set;}          //営業担当者
    public String targetContractCode{get; set;}         //契約先コード
    public List<String> targetSeries{get; set;}         //系列
    public String targetProjectNumber{get; set;}        //Project Number
    public String targetCustomerName{get; set;}         //Customer Name
    public String targetCustomerCode{get; set;}         //Customer Code
    public String targetModel{get; set;}                //Model
    public String contractFrom { get; set;}             //Contract End Date From
    public String contractTo { get; set;}               //Contract End Date To
    public String mcmNo{get; set;}                      //MaintenanceContractManagementNo

    public static String selectObj{get; set;}                   // search panel radio value
    public Boolean isClear;
    //系列項目設定
    public List<OptionDetail> SeriesOptions{get; set;}

    public Id dataId{get; set;}
    //保持項目有無判定
    private static final String COOKIE_LABEL_SALESPERSON = 'SalesPerson';
    private static final String COOKIE_LABEL_SERIES = 'Series';
    private static final String COOKIE_LABEL_PRONUM = 'ProNum';
    private static final String COOKIE_LABEL_CUSTMER_NAME = 'CustomerName';
    private static final String COOKIE_LABEL_CUSTMER_CODE = 'CustomerCode';
    private static final String COOKIE_LABEL_MODEL = 'Model';
    private static final String COOKIE_LABEL_CONTRACTFROM = 'ContractFrom';
    private static final String COOKIE_LABEL_CONTRACTTO = 'ContractTo';
    private static final String COOKIE_LABEL_CONTRACTMANAGEMENTNO = 'ContractManagementNo';
    private static final String COOKIE_LABEL_SELECTOBJ = 'selectObj';

    //cookie有効期限
    private static final Integer COOKIE_EXPIRATION_DATE = -1;
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_MaintenanceListToRenewAdd';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    //VF datepicker を動作させるため
    public AsiaProjectMaster__c pm {get;set;}

    // 画面起動時検索フラグ（'true'の場合に検索する）
    private String initSearchFlg = '';

    // エラーフラグ
    private Boolean errFlg = false;

    List<rowWrapper> rows = new List<rowWrapper>();
    public JEOLAsia_MaintenanceListToRenewAdd_ctrl() {
        orderBy= 'name';
        currentOrder = 'name';
        orderDesc = false;
        Boolean hasSearchValue = initFieldFromCookie();

        if(hasSearchValue){
            this.isClear = false;
        }else{
            this.isClear = true;
            selectObj = '1';
        }

        // 系列項目設定
        List<optionDetail> seriesOptions = new List<optionDetail>();
        Set<String> series;
        if (this.targetSeries != null) {
            series = new Set<String>(this.targetSeries);
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
        if (hasSearchValue) {
            setStandardSetController();
        }
    }

    public override void setStandardSetController() {
        String relation = 'ProjectMaster__r.';
        String soql = ' SELECT Id, Name, ';
        if(selectObj == '1'){
            if(this.orderBy != 'ContractEndDate__c' && this.orderBy != 'Name'){
                if(this.orderBy.contains(relation)){
                    this.orderBy = this.orderBy.replace(relation, '');
                }
            }
            if(this.orderBy == 'NewContractEndDate__c'){
                this.orderBy = 'ContractEndDate__c';
            }
            soql += 'ProjectNumber__c, ';
            soql += 'Series__c, ';
            soql += 'ContractAccount__c, ';
            soql += 'ShipmentAccount__c, ';
            soql += 'Model__c, ';
            soql += 'SalesPerson__c, ';
            soql += 'SalesAssistant__c, ';
            soql += 'ShipmentName__c, ';
            soql += 'ShipmentName1__c, ';
            soql += 'ShipmentName2__c, ';
            soql += 'ContractName__c, ';
            soql += 'ContractName1__c, ';
            soql += 'ContractName2__c, ';
            soql += 'ContractCode__c, ';
            soql += 'ShipmentCode__c, ';
            soql += 'ContractPrice__c, ';
            soql += 'CurrencyContractPrice__c, ';
            soql += 'CreatedDateFormula__c, ';
            soql += 'ContractEndDate__c, ';
            //soql += '( SELECT Name FROM MaintenanceContractManagement__r ), ';
            soql += 'LastModifiedDate ';
            soql += 'FROM ';
            soql += 'AsiaProjectMaster__c ';
        }else{
            if(this.orderBy != 'NewContractEndDate__c' && this.orderBy != 'Name'){
                if(!this.orderBy.contains(relation)){
                    this.orderBy = relation + this.orderBy;
                }

            }
            if(this.orderBy == 'ContractEndDate__c'){
                this.orderBy = 'NewContractEndDate__c';
            }
            soql += 'NewContractEndDate__c, ';
            soql += 'ProjectMaster__c, ';
            soql += 'ProjectMaster__r.Id, ';
            soql += 'ProjectMaster__r.Name, ';
            soql += 'ProjectMaster__r.ProjectNumber__c, ';
            soql += 'ProjectMaster__r.Series__c, ';
            soql += 'ProjectMaster__r.ContractAccount__c, ';
            soql += 'ProjectMaster__r.ShipmentAccount__c, ';
            soql += 'ProjectMaster__r.Model__c, ';
            soql += 'ProjectMaster__r.SalesPerson__c, ';
            soql += 'ProjectMaster__r.SalesAssistant__c, ';
            soql += 'ProjectMaster__r.ShipmentName__c, ';
            soql += 'ProjectMaster__r.ShipmentName1__c, ';
            soql += 'ProjectMaster__r.ShipmentName2__c, ';
            soql += 'ProjectMaster__r.ContractName__c, ';
            soql += 'ProjectMaster__r.ContractName1__c, ';
            soql += 'ProjectMaster__r.ContractName2__c, ';
            soql += 'ProjectMaster__r.ContractCode__c, ';
            soql += 'ProjectMaster__r.ShipmentCode__c, ';
            soql += 'ProjectMaster__r.ContractPrice__c, ';
            soql += 'ProjectMaster__r.CurrencyContractPrice__c, ';
            soql += 'ProjectMaster__r.CreatedDateFormula__c, ';
            soql += 'ProjectMaster__r.ContractEndDate__c, ';
            soql += 'ProjectMaster__r.LastModifiedDate ';
            soql += 'FROM ';
            soql += 'AsiaMaintenanceContractManagement__c ';
        }
        // the Id List : for query
        List<Id> mcmIdList = preMcmIdList();
        List<String> whereStrElems = getWhereStrList();
        if (whereStrElems.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrElems);
        }
        soql += ' ORDER BY ' + this.orderBy;
        if (this.orderDesc) {
            soql += ' DESC NULLS LAST ';
        }

        soql += ' LIMIT 10000 ';
        system.debug('検索クエリ===' + soql);
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(soql));

        if (this.errFlg) {
            ssc = null;
        } else if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, Label.JEOLAsia_MaintRenewalAdd_Message_TooMuchData));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }

    private List<String> getWhereStrList() {
        Date dTodayFirstDay = Date.newInstance(date.today().year(), date.today().month(), 1);
        this.errFlg = false;  // エラーフラグ初期化
        List<String> conditions = new List<String>();
        if(selectObj == '1'){
            conditions.add('Id NOT IN (SELECT ProjectMaster__c FROM AsiaMaintenanceContractManagement__c) ');
            // Project Number
            if (String.isNotBlank(this.targetProjectNumber)) {
                conditions.add(JEOLUtil.appendLikeText('Name', this.targetProjectNumber));
            }

            // Customer Code
            if (String.isNotBlank(this.targetCustomerCode)) {
                conditions.add('((' +
                    JEOLUtil.appendAfterLikeText('ContractCode__c', this.targetCustomerCode) +
                    ') OR (' +
                    JEOLUtil.appendAfterLikeText('ShipmentCode__c', this.targetCustomerCode) +
                    '))' );
            }

            // Customer Name
            if (String.isNotBlank(this.targetCustomerName)) {
                conditions.add('((' +
                    JEOLUtil.appendLikeText('ContractName__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ContractName1__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ContractName2__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ShipmentName__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ShipmentName1__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ShipmentName2__c', this.targetCustomerName) +
                    '))' );
            }

            // Model
            if (String.isNotBlank(this.targetModel)) {
                conditions.add(JEOLUtil.appendLikeText('Model__c', this.targetModel));
            }

            // Salesperson
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

            // Series
            if (this.targetSeries != null && this.targetSeries.size() > 0) {
                    conditions.add(JEOLUtil.appendInText('Series__c', this.targetSeries));
            }
            try{
                if (String.isNotBlank(this.contractFrom)) {
                    Date fromDate = Date.parse(this.contractFrom);
                    String fromDateToStr = String.valueOf(fromDate);
                    conditions.add(JEOLUtil.appendGreaterThanEqualText('ContractEndDate__c', fromDateToStr, false));
                }
                if (String.isNotBlank(this.contractTo)) {
                    Date toDate = Date.parse(this.contractTo);
                    String toDateToStr = String.valueOf(toDate);
                    conditions.add(JEOLUtil.appendLessThanEqualText('ContractEndDate__c', toDateToStr, false));
                }
            }catch(Exception e) {
                errFlg = true;
            }
        }else{
            conditions.add('Id NOT IN :mcmIdList ');
            // Project Number
            if (String.isNotBlank(this.targetProjectNumber)) {
                conditions.add(JEOLUtil.appendLikeText('ProjectMaster__r.Name', this.targetProjectNumber));
            }

            // Customer Code
            if (String.isNotBlank(this.targetCustomerCode)) {
                conditions.add('((' +
                    JEOLUtil.appendAfterLikeText('ProjectMaster__r.ContractCode__c', this.targetCustomerCode) +
                    ') OR (' +
                    JEOLUtil.appendAfterLikeText('ProjectMaster__r.ShipmentCode__c', this.targetCustomerCode) +
                    '))' );
            }

            // Customer Name
            if (String.isNotBlank(this.targetCustomerName)) {
                conditions.add('((' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.ContractName__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.ContractName1__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.ContractName2__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.ShipmentName__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.ShipmentName1__c', this.targetCustomerName) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.ShipmentName2__c', this.targetCustomerName) +
                    '))' );
            }

            // Model
            if (String.isNotBlank(this.targetModel)) {
                conditions.add(JEOLUtil.appendLikeText('ProjectMaster__r.Model__c', this.targetModel));
            }

            // Salesperson
            if (String.isNotBlank(this.targetSalesPerson)) {
                conditions.add('((' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.SalesPerson__r.Name', this.targetSalesPerson) +
                    ') OR (' +
                    JEOLUtil.appendAfterLikeText('ProjectMaster__r.SalesPerson__r.UserCode__c', this.targetSalesPerson) +
                    ') OR (' +
                    JEOLUtil.appendLikeText('ProjectMaster__r.SalesAssistant__r.Name', this.targetSalesPerson) +
                    ') OR (' +
                    JEOLUtil.appendAfterLikeText('ProjectMaster__r.SalesAssistant__r.UserCode__c', this.targetSalesPerson) +
                    '))' );
            }

            // Series
            if (this.targetSeries != null && this.targetSeries.size() > 0) {
                    conditions.add(JEOLUtil.appendInText('ProjectMaster__r.Series__c', this.targetSeries));
            }

            try{
                if (String.isNotBlank(this.contractFrom)) {
                    Date fromDate = Date.parse(this.contractFrom);
                    String fromDateToStr = String.valueOf(fromDate);
                    conditions.add(JEOLUtil.appendGreaterThanEqualText('NewContractEndDate__c', fromDateToStr, false));
                }
                if (String.isNotBlank(this.contractTo)) {
                    Date toDate = Date.parse(this.contractTo);
                    String toDateToStr = String.valueOf(toDate);
                    conditions.add(JEOLUtil.appendLessThanEqualText('NewContractEndDate__c', toDateToStr, false));
                }
            }catch(Exception e) {
                errFlg = true;
            }

            if(this.mcmNo != null){
                conditions.add(JEOLUtil.appendLikeText('Name ', this.mcmNo));
            }
        }


        return conditions;
    }

    //リスト項目取得
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);
    }

    //系列選択
    public String getSelectedSeries() {

        String value = System.Label.JEOLAsia_MaintRenewalAdd_Label_None;
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

    public void seriesSelectAllSelect() {
        List<OptionDetail> seriesOptions = this.SeriesOptions;
        for (OptionDetail detail: seriesOptions) {
            detail.isSelected = true;
        }
    }

    public void seriesSelectAllDeselect() {
        List<OptionDetail> seriesOptions = this.SeriesOptions;
        for (OptionDetail detail: seriesOptions) {
            detail.isSelected = false;
        }
    }

    public void seriesSelectCancel() {
        List<OptionDetail> seriesOptions = this.SeriesOptions;
        for (OptionDetail detail: seriesOptions) {
            detail.cancel();
        }
    }

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

    //検索キーワードクリアメソッド
    public void doFormClear() {
        this.ssc = null;
        this.isClear = true;
        // Row 1
        this.targetProjectNumber = null;
        this.targetCustomerName = null;
        this.targetCustomerCode = null;
        // Row 2
        this.targetModel = null;
        this.targetSalesPerson = null;
        // Row 3
        this.targetSeries = null;
        // Row 4
        this.contractFrom = null;
        this.contractTo = null;
        // Row 5
        this.mcmNo = null;

        selectObj = '1';
        for (OptionDetail detail: this.SeriesOptions) {
            detail.setSelected(false);
        }

        saveInputValues();  //cookie保存
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
        cookies.add(new Cookie(COOKIE_LABEL_MODEL, this.targetModel, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESPERSON, this.targetSalesPerson, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        String fromDateStr;
        if (this.contractFrom != null) {
            fromDateStr = contractFrom.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACTFROM, fromDateStr, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        String toDateStr;
        if (this.contractTo != null) {
            toDateStr = this.contractTo.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACTTO, toDateStr, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_CONTRACTMANAGEMENTNO, this.mcmNo, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));
        cookies.add(new Cookie(COOKIE_LABEL_SELECTOBJ, selectObj, COOKIE_PATH, COOKIE_EXPIRATION_DATE, true));

        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);
    }

    public void doSearch() {
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON
        this.isClear = false;
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

    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;

        if(cookies.containsKey(COOKIE_LABEL_PRONUM)){
                this.targetProjectNumber = cookies.get(COOKIE_LABEL_PRONUM).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SERIES)){
            String targetSeriesText = cookies.get(COOKIE_LABEL_SERIES).getValue();
            if (String.isNotBlank(targetSeriesText)) {
                this.targetSeries = targetSeriesText.split('&&');
            }
        }
        if(cookies.containsKey(COOKIE_LABEL_CUSTMER_NAME)){
            this.targetCustomerName = cookies.get(COOKIE_LABEL_CUSTMER_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_CUSTMER_CODE)){
            this.targetCustomerCode = cookies.get(COOKIE_LABEL_CUSTMER_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_MODEL)){
            this.targetModel = cookies.get(COOKIE_LABEL_MODEL).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALESPERSON)){
            this.targetSalesPerson = cookies.get(COOKIE_LABEL_SALESPERSON).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_CONTRACTMANAGEMENTNO)){
            this.mcmNo = cookies.get(COOKIE_LABEL_CONTRACTMANAGEMENTNO).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_CONTRACTFROM)){
            this.contractFrom = cookies.get(COOKIE_LABEL_CONTRACTFROM).getValue().replaceAll('-', '/');
        }

        if(cookies.containsKey(COOKIE_LABEL_CONTRACTTO)){
            this.contractTo = cookies.get(COOKIE_LABEL_CONTRACTTO).getValue().replaceAll('-', '/');
        }

        if(cookies.containsKey(COOKIE_LABEL_SELECTOBJ)){
            selectObj = cookies.get(COOKIE_LABEL_SELECTOBJ).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER) && cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue().length() != 0){
            PageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        if(cookies.containsKey(COOKIE_LABEL_PAGE_SIZE) && cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue().length() != 0){
            PageSize = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue());
        }

        //画面起動時検索フラグチェック
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }
        return hasSearchValues;
    }

    public void addContractMaintenance() {
        List<Id> lsId = new List<id>();
        lsId.add(dataId);
        addContractMaintenanceList(lsId, false, null);
        setStandardSetController();

    }

    public void addContractMaintenanceAll() {
        List<id> lsId = new List<id>();
        if(selectObj == '1'){
            for (rowWrapper row : rows) {
                lsId.add(row.projectMaster.id);
            }
        }else{
            for (rowWrapper row : rows) {
                lsId.add(row.mcm.id);
            }
        }

        addContractMaintenanceList(lsId, false, null);
        setStandardSetController();
    }

    /**
     * [addContractMaintenanceList : add action]
     * @param lsId           [target obj id list]
     * @param isBatch        [true: execute batch, false : don't execute batch]
     * @param selectedObjSet [1: projectMaster sObj, 2: maintenanceContractManagement sObj]
     */
    private static void addContractMaintenanceList(List<id> lsId, Boolean isBatch, String selectedObjSet) {
        List<AsiaMaintenanceContractManagement__c> lsToBeAded = new List<AsiaMaintenanceContractManagement__c>();
        List<String> fieldList = new List<String>();
        // クエリ条件
        String condition = '';
        // クエリ全体文字列
        String query = '';
        List<AsiaProjectMaster__c> projectMasterList = new List<AsiaProjectMaster__c>();
        List<AsiaMaintenanceContractManagement__c> mcmList = new List<AsiaMaintenanceContractManagement__c>();
        if(selectedObjSet != null && selectedObjSet != ''){
            selectObj = selectedObjSet;
        }
        // add target is projectMaster
        if(selectObj == '1'){
            // custome field relation
            fieldList.add('ProfitCalculation__r.UnitBody__c');

            condition += 'WHERE Id IN :lsId ';
            condition += 'AND Id NOT IN (SELECT ProjectMaster__c FROM AsiaMaintenanceContractManagement__c) ';
            query += getSelectAllQuery('AsiaProjectMaster__c', condition, false, fieldList);
            // ProjectMaster search result list
            projectMasterList = Database.query(query);

            if(projectMasterList != null && projectMasterList.size() > 0){
                for(AsiaProjectMaster__c pm :projectMasterList){
                    // Copy from projectMaster
                    AsiaMaintenanceContractManagement__c row = new AsiaMaintenanceContractManagement__c();
                    // Row1
                    row.ProjectMaster__c = pm.Id;
                    row.Company__c = pm.Company__c;
                    // Row2
                    row.NewOdrFlagshipProduct__c = pm.Model__c;
                    row.CompanyName__c = pm.CompanyName__c;
                    // Row3
                    row.OrgName__c = pm.OrgName__c;
                    // Row4
                    row.NewOdrSeries__c = pm.Series__c;
                    // Row5
                    row.NewOdrSalesStaff__c = pm.SalesPerson__c;
                    // Row6
                    row.NewOdrAssistant__c = pm.SalesAssistant__c;
                    // Row7
                    row.NewOdrSalesAccount__c = pm.ContractAccount_dummyField__c;
                    row.NewOdrShipmentAccount__c = pm.ShipmentAccount_dummyField__c;
                    // Office and Address is auto copy
                    // Row10
                    row.NewOdrSalesContactPosition__c = pm.ContractBelong__c;
                    row.NewOdrShipmentContactPosition__c = pm.ShipmentBelong__c;
                    // Row11
                    row.NewOdrSalesContactPost__c = pm.ContractPost__c;
                    row.NewOdrShipmentContactPost__c = pm.ShipmentPost__c;
                    // Row12
                    row.NewOdrSalesTantoshya__c = pm.ContractPersonInCharge__c;
                    row.NewOdrShipmentTantosha__c = pm.ShipmentPersonInCharge__c;
                    // Row13
                    row.NewOdrSalesContactTel__c = pm.ContractPhone__c;
                    row.NewOdrShipmentContact_Tel__c = pm.ShipmentPhone__c;
                    // Row14
                    row.NewOdrSalesContactFax__c = pm.ContractFax__c;
                    row.NewOdrShipmentContact_Fax__c = pm.ShipmentFax__c;
                    // Row15
                    row.NewOdrSalesContactEmail__c = pm.ContractEmail__c;
                    row.NewOdrShipmentContact_Email__c = pm.ShipmentEmail__c;
                    // Row17
                    row.NewContractStartDate__c = pm.ContractEndDate__c.addDays(+1);
                    // Add one year
                    row.NewContractEndDate__c = row.NewContractStartDate__c.addYears(+1);
                    // Sub one day
                    row.NewContractEndDate__c = row.NewContractEndDate__c.addDays(-1);

                    // previous contract period is not one year
                    if( !checkContractPeriod(pm.ContractStartDate__c , pm.ContractEndDate__c) ){
                        row.ContractPrice__c = null;
                        row.Status__c = '1';
                        row.NewOdrSalesPipeline__c = null;
                        row.StatusMemo__c = null;
                        row.QuotationCreated__c = false;
                        row.QuotationSentDate__c = null;
                        row.NewOdrProfitCalculation__c = null;
                        row.SACreated__c = false;
                        row.ContractSentDate__c = null;
                        row.NextYearNotes__c = null;
                        row.Memo__c = null;
                    }
                    lsToBeAded.add(row);
                }
            }else{
                projectMasterList = new List<AsiaProjectMaster__c>();
            }
            if (lsToBeAded != null && lsToBeAded.size() > 0) {
                insert lsToBeAded;
                if (!isBatch) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.JEOLAsia_MaintRenewalAdd_Message_DataAdded));
                }
            }
        }else {
            // add target is MaintenanceContractManagement
            List<Id> mcmIdList = preMcmIdList();
            condition += 'WHERE Id IN :lsId ';
            condition += 'AND ProjectMaster__c != null ';
            condition += 'AND Id NOT IN :mcmIdList ';
            query += getSelectAllQuery('AsiaMaintenanceContractManagement__c', condition, false, fieldList);
            // MaintenanceContractManagement search result list
            mcmList = Database.query(query);
            if(mcmList != null && mcmList.size() > 0){
                for(AsiaMaintenanceContractManagement__c mcm :mcmList){
                    AsiaMaintenanceContractManagement__c row = new AsiaMaintenanceContractManagement__c();
                    row = mcm.clone(false, true);
                    // Set Contract Date
                    row.NewContractStartDate__c = row.NewContractEndDate__c.addDays(+1);
                    row.NewContractEndDate__c = row.NewContractStartDate__c.addYears(+1);
                    row.NewContractEndDate__c = row.NewContractEndDate__c.addDays(-1);
                    // Set Previous Pipline
                    row.PreviousYearPipeline__c = mcm.Id;

                    // previous contract period is not one year
                    if(!checkContractPeriod(mcm.NewContractStartDate__c , mcm.NewContractEndDate__c)){
                        row.ContractPrice__c = null;
                        row.Status__c = '1';
                        row.NewOdrSalesPipeline__c = null;
                        row.StatusMemo__c = null;
                        row.QuotationCreated__c = false;
                        row.QuotationSentDate__c = null;
                        row.NewOdrProfitCalculation__c = null;
                        row.SACreated__c = false;
                        row.ContractSentDate__c = null;
                        row.NextYearNotes__c = null;
                        row.Memo__c = null;
                    }
                    lsToBeAded.add(row);
                }
            }else{
                mcmList = new List<AsiaMaintenanceContractManagement__c>();
            }
            if (lsToBeAded != null && lsToBeAded.size() > 0) {
                insert lsToBeAded;
                if (!isBatch) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.JEOLAsia_MaintRenewalAdd_Message_DataAdded));
                }
            }
        }
    }

    // inner sObject query is not work so use it
    private static List<Id> preMcmIdList(){
        List<Id> mcmIdList = new List<Id>();
        List<AsiaMaintenanceContractManagement__c> preMcmList = [SELECT PreviousYearPipeline__c FROM AsiaMaintenanceContractManagement__c];
        if(preMcmList != null && preMcmList.size() > 0){
            for(AsiaMaintenanceContractManagement__c mcm :preMcmList){
                mcmIdList.add(mcm.PreviousYearPipeline__c);
            }
        }
        return mcmIdList;
    }

    /**
     * [checkContractPeriod: check previous contract period is one year or not]
     * @param  startDate [previous contract start date]
     * @param  endDate   [previous contract end date]
     * @return isOneYear [true: is one year, false: no one year]
     */
    private static Boolean checkContractPeriod(Date startDate, Date endDate){
        Boolean isOneYear = false;
        // contract start date and end date is exist
        if( String.isNotEmpty(String.valueOf(startDate)) &&
            String.isNotEmpty(String.valueOf(endDate))
          ) {
            Date startDateAdd1Year = startDate.addYears(1);
            Date oneYearAfter = startDateAdd1Year.addDays(-1);
            if(oneYearAfter == endDate){
                isOneYear = true;
            }else {
                isOneYear = false;
            }
        }else {
        // contract start date or end date is not exist
            isOneYear = false;
        }
        return isOneYear;
    }

    public static void addContractMaintenanceBatch() {

        Date dTodayFirstDay = Date.newInstance(Date.today().year(), Date.today().month(), 1);
        Date dToday = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day());
        // copy projectMaster that haven't child records(MaintenanceContractManagement) to create MaintenanceContractManagement
        List<Id> addPMIdList = PMShipmentAccountMaintRenewDays(dTodayFirstDay, dToday);
        // copy MaintenanceContractManagement that have parent records(projectMaster) to create MaintenanceContractManagement
        List<Id> addCMCIdList = MCMShipmentAccountMaintRenewDays(dTodayFirstDay, dToday);
        // add target is projectMaster
        if(addPMIdList != null && addPMIdList.size() > 0){
            addContractMaintenanceList(addPMIdList, true, '1');
        }
        // add target is mcm
        if(addCMCIdList != null && addCMCIdList.size() > 0){
            addContractMaintenanceList(addCMCIdList, true, '2');
        }
    }

    /**
     * [PMShipmentAccountMaintRenewDays: when batch is working, vis the mothod to search target projectMaster and get the days that user seted]
     * @param  dTodayFirstDay [this month first day]
     * @param  dToday         [today]
     * @return                [target projectMaster Id List]
     */
    private static List<Id> PMShipmentAccountMaintRenewDays(Date dTodayFirstDay, Date dToday){
        // get all projectMaster in conditions
        List<AsiaProjectMaster__c> pmList = [SELECT Id, ContractEndDate__c, ShipmentAccount__c
                                           FROM AsiaProjectMaster__c
                                           WHERE Id NOT IN (SELECT ProjectMaster__c from AsiaMaintenanceContractManagement__c)
                                           AND ContractEndDate__c >= :dTodayFirstDay
                                           ];
        List<Id> pmIdList = new List<Id>();
        // account id list in geted projectMaster list
        for(AsiaProjectMaster__c pm :pmList){
            pmIdList.add(pm.ShipmentAccount__c);
        }

        Map<Id, Integer> accountMap = new Map<Id, Integer>();
        // target account list to map (key: accountId, value: MaintRenewalDays)
        for(Account acc :[SELECT Id, MaintRenewalDays__c FROM Account WHERE Id In :pmIdList]){
            accountMap.put(acc.Id, Integer.valueOf(acc.MaintRenewalDays__c));
        }
        List<Id> pmAddIdList = new List<Id>();
        // insert target projectMaster list in conditions
        for(AsiaProjectMaster__c pm :pmList){
            if(accountMap.get(pm.ShipmentAccount__c) != null){
                if(pm.ContractEndDate__c <= dToday.addDays(Integer.valueOf(accountMap.get(pm.ShipmentAccount__c)))){
                    pmAddIdList.add(pm.Id);
                }
            }
        }
        return pmAddIdList;
    }

    /**
     * [MCMShipmentAccountMaintRenewDays: when batch is working,
     *                                    invoke the mothod to search target MaintenanceContractManagement
     *                                    and get the days that user seted
     * ]
     * @param  dTodayFirstDay [the month first day]
     * @param  dToday         [today]
     * @return                [target MaintenanceContractManagement Id List]
     */
    private static List<Id> MCMShipmentAccountMaintRenewDays(Date dTodayFirstDay, Date dToday){
        List<Id> mcmIdList = preMcmIdList();
        // get all MaintenanceContractManagement in conditions
        List<AsiaMaintenanceContractManagement__c> mcmList = [SELECT Id, NewContractEndDate__c, NewOdrShipmentAccount__c
                                                               FROM AsiaMaintenanceContractManagement__c
                                                               WHERE ProjectMaster__c != null
                                                               AND Id NOT IN :mcmIdList
                                                               AND NewContractEndDate__c >= :dTodayFirstDay
                                                               ];
        List<Id> cmcIdList = new List<Id>();
        // account id list in geted MaintenanceContractManagement list
        for(AsiaMaintenanceContractManagement__c mcm :mcmList){
            cmcIdList.add(mcm.NewOdrShipmentAccount__c);
        }

        Map<Id, Integer> accountMap = new Map<Id, Integer>();
        // target account list to map (key: accountId, value: MaintRenewalDays)
        for(Account acc :[SELECT Id, MaintRenewalDays__c FROM Account WHERE Id In :cmcIdList]){
            accountMap.put(acc.Id, Integer.valueOf(acc.MaintRenewalDays__c));
        }

        List<Id> mcmAddIdList = new List<Id>();
        // insert target MaintenanceContractManagement list in conditions
        for(AsiaMaintenanceContractManagement__c mcm :mcmList){
            if(accountMap.get(mcm.NewOdrShipmentAccount__c) != null){
                if(mcm.NewContractEndDate__c <= dToday.addDays(Integer.valueOf(accountMap.get(mcm.NewOdrShipmentAccount__c)))){
                    mcmAddIdList.add(mcm.Id);
                }
            }
        }
        return mcmAddIdList;
    }

    /**
     * [Get target table all field query string]
     * @param  tableName         [Target sObj]
     * @param  whereCondition    [Query Condition String]
     * @param  isCustomFieldOnly [True: Only CustomField]
     * @param  staticFields      [For Only CustomField]
     * @return                   [Target sObj all Field Query String]
     */
    private static String getSelectAllQuery(String tableName, String whereCondition, Boolean isCustomFieldOnly, String[] staticFields) {
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(tableName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String, Schema.SObjectField> fields = r.fields.getMap() ;
        String soql = '';
        for (String fieldName : fields.keyset()) {
            if(isCustomFieldOnly && (fieldName.indexOf('__c') < 0)) {
                continue;
            }
            if (soql != '') {
                soql += ', ';
            }
            soql += fieldName;
        }
        for (String fieldName : staticFields) {
            if (soql != '') {
                soql += ', ';
            }
            soql += fieldName;
        }
        soql = 'SELECT ' + soql + ' FROM ' + tableName + ' ' + whereCondition;
        return soql;
    }

    public void setSizeSaveCurrentPageSize() {
        changeSize();
        setCookieCurrentPageSize();
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

    public void nextAndSaveCurrentPageNumber() {
        next();
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

    private void setCookieCurrentPageSize() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(ssc.getPageSize()), COOKIE_PATH, -1, true)});
        }
    }

    private void setCookieCurrentPageNumber() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(ssc.getPageNumber()), COOKIE_PATH, -1, true)});
        }
    }

    public List<SelectOption> getListSelectObj() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'First Year'));
        options.add(new SelectOption('2', 'Second Year After'));
        return options;
    }

    /*  検索結果の取得   */
    public List<rowWrapper> getRecords() {
        rows = new List<rowWrapper>();
        Integer currentCount = 0;
        if(this.isClear){
            this.ssc = null;
        }else{
            String objApiName = String.valueOf(ssc);
            objApiName = objApiName.replace('ApexPages.StandardSetController[', '');
            objApiName = objApiName.replace(']', '');
            if(selectObj == '1' && objApiName != 'AsiaProjectMaster__c'){
                setStandardSetController();
            }
            if(selectObj != '1' && objApiName != 'AsiaMaintenanceContractManagement__c'){
                setStandardSetController();
            }
        }

        if(selectObj == '1'){
            if(ssc != null) {
                for (AsiaProjectMaster__c row: (List< AsiaProjectMaster__c >)ssc.getRecords()) {
                    // child record mcm not exist
                    rowWrapper orderPlan = new rowWrapper(row, null, currentCount);
                    rows.add(orderPlan);
                    currentCount++;
                }
            }
        }else{
            if(ssc != null) {
                for (AsiaMaintenanceContractManagement__c row: (List< AsiaMaintenanceContractManagement__c >)ssc.getRecords()) {
                    // child record mcm exist
                    rowWrapper orderPlan = new rowWrapper(null, row, currentCount);
                    rows.add(orderPlan);
                    currentCount++;
                }
            }
        }
        return rows;
    }

    /*  検索結果の設定　*/
    public class rowWrapper{
        public AsiaProjectMaster__c projectMaster {get; set;}
        public Integer rowNumber {get; set;}
        public AsiaMaintenanceContractManagement__c mcm {get; set;}

        public rowWrapper(AsiaProjectMaster__c projectMaster, AsiaMaintenanceContractManagement__c mcm, Integer rowNumber) {
            if(projectMaster != null){
                this.projectMaster = projectMaster;
            }else{
                this.projectMaster = new AsiaProjectMaster__c();
            }
            this.rowNumber = rowNumber;
            if(mcm != null){
                this.mcm = mcm;
            }else{
                this.mcm = new AsiaMaintenanceContractManagement__c();
            }
        }
    }

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