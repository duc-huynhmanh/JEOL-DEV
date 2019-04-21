public with sharing class JEOL_HosyuKeiyaku_ctrl extends JEOL_SearchBase_ctrl {
    // 検索項目
    public String unitBody { get; set; }
    public String kikaku { get; set; }
    public String itemName { get; set; }
    public String productNumber { get; set; }
    public String accountCode { get; set; }
    public String accountName { get; set; }
    public String shipmentAccountCode { get; set; }
    public String shipmentAccountName { get; set; }
    public String area { get; set; }
    public String updateStatus { get; set; }
    public String contractPeriodTarget{get; set;}
    public String contractPeriodFrom{get; set;}
    public String contractPeriodTo{get; set;}

    private static final String CONTRACT_PERIOD_TARGET_NAME_START = 'Start';  //契約開始日選択値
    private static final String CONTRACT_PERIOD_TARGET_NAME_END = 'End';    //契約終了日選択値

    // Cookei用定数
    public final String COOKIE_PATH = '/apex/JEOL_HosyuKeiyakuPage';  // PATH
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';
    private String targetRecordTypeId;

    /**
    *  コンストラクタ
    */
    public JEOL_HosyuKeiyaku_ctrl() {
        orderBy= 'Name';
        currentOrder = 'Name';
        orderDesc = false;
        
        List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'SalesOrder__c' AND developerName = 'HosyuKeiyaku'];
        String recordTypeId;
        for (RecordType recType: recordTypes) {
            recordTypeId = recType.id;
        }
        if (recordTypeId == null) {
            recordTypeId = '';
        }
        this.targetRecordTypeId = recordTypeId;
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }
    }
    
    public List<SelectOption> getContractPeriodTargetList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption(CONTRACT_PERIOD_TARGET_NAME_START, '契約開始日'));
        options.add(new SelectOption(CONTRACT_PERIOD_TARGET_NAME_END, '契約終了日'));
        return options;
    }
    
    public void contractPeriodListChangeAction() {
        String targetName = this.contractPeriodTarget;
        if (String.isBlank(targetName)) {
            this.contractPeriodFrom = null;
            this.contractPeriodTo = null;
        }
    }
    
    public List<SelectOption> getContractUpdateStatus (){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_CONTRACT_STATUS);
    }
    
    public List<SelectOption> getRegionOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_AREA);
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

    // クリアボタン
    public void doFormClear() {
        // 検索条件のクリア
        this.unitBody = null;
        this.kikaku = null;
        this.itemName = null;
        this.productNumber = null;
        this.accountCode = null;
        this.accountName = null;
        this.shipmentAccountCode = null;
        this.shipmentAccountName = null;
        this.area = null;
        this.updateStatus = null;
        this.contractPeriodTarget = '';
        this.contractPeriodFrom = null;
        this.contractPeriodTo = null;

        // 検索結果のクリア
        ssc = null;

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        // 検索条件のCookie保存
        saveInputValues();
    }

    /**
     * 検索条件のCookie読み込み、画面起動時検索判定 
     */
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        if(cookies.containsKey('unitBody')){
          this.unitBody = cookies.get('unitBody').getValue();
        }
        if(cookies.containsKey('kikaku')){
          this.kikaku = cookies.get('kikaku').getValue();
        }
        if(cookies.containsKey('itemName')){
          this.itemName = cookies.get('itemName').getValue();
        }
        if(cookies.containsKey('productNumber')){
          this.productNumber = cookies.get('productNumber').getValue();
        }
        if(cookies.containsKey('accountCode')){
          this.accountCode = cookies.get('accountCode').getValue();
        }
        if(cookies.containsKey('accountName')){
          this.accountName = cookies.get('accountName').getValue();
        }
        if(cookies.containsKey('shipmentAccountCode')){
          this.shipmentAccountCode = cookies.get('shipmentAccountCode').getValue();
        }
        if(cookies.containsKey('shipmentAccountName')){
          this.shipmentAccountName = cookies.get('shipmentAccountName').getValue();
        }
        if(cookies.containsKey('area')){
          this.area = cookies.get('area').getValue();
        }
        if(cookies.containsKey('updateStatus')){
          this.updateStatus = cookies.get('updateStatus').getValue();
        }
        if(cookies.containsKey('contractPeriodTarget')){
          this.contractPeriodTarget = cookies.get('contractPeriodTarget').getValue();
        }
        if(cookies.containsKey('contractPeriodFrom')){
          this.contractPeriodFrom = cookies.get('contractPeriodFrom').getValue();
        }
        if(cookies.containsKey('contractPeriodTo')){
          this.contractPeriodTo = cookies.get('contractPeriodTo').getValue();
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

    /**
     *  検索条件Cookie保存
     */
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie('unitBody', this.unitBody, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('kikaku', this.kikaku, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('itemName', this.itemName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('productNumber', this.productNumber, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('accountCode', this.accountCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('accountName', this.accountName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shipmentAccountCode', this.shipmentAccountCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shipmentAccountName', this.shipmentAccountName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('area', this.area, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('updateStatus', this.updateStatus, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('contractPeriodTarget', this.contractPeriodTarget, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('contractPeriodFrom', this.contractPeriodFrom, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('contractPeriodTo', this.contractPeriodTo, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, initSearchFlg, COOKIE_PATH, -1, true));

        Apexpages.currentPage().setCookies(cookies);
    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {

        String soql = 'select Id, UnitBody__c, Kikaku__c, ItemName__c, ProductNumber__c, OrderDateFormula__c, ' +
                            'MaintenanceStartDateFormula__c, MaintenanceEndDateFormula__c, AmountOfContract__c, NewUpdated__c, UpdateStatus__c, ' +
                            'ShipmentAccount__r.name, ShipmentAccount__r.code__c, CurrencyIsoCode,' +
                            'Name, Area__c, SalesAccount__r.name, SalesAccount__r.code__c, MaintenancePeriod__c' +
                        ' FROM ' +
                            ' SalesOrder__c ';

        List<String> whereConditions = new List<String>();
        //レコードタイプが保守契約のレコードのみ取得
        whereConditions.add(JEOLUtil.appendEqualText('RecordTypeId', this.targetRecordTypeId));
        if (String.isNotBlank(this.unitBody)) {
            whereConditions.add(JEOLUtil.appendLikeText('UnitBody__c', this.unitBody));
        }
        if (String.isNotBlank(this.kikaku)) {
            whereConditions.add(JEOLUtil.appendLikeText('Kikaku__c', this.Kikaku));
        }
        if (String.isNotBlank(this.itemName)) {
            whereConditions.add(JEOLUtil.appendLikeText('ItemName__c', this.itemName));
        }
        if (String.isNotBlank(this.productNumber)) {
            whereConditions.add(JEOLUtil.appendLikeText('ProductNumber__c', this.productNumber));
        }
        if (String.isNotBlank(this.accountCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('SalesAccount__r.Code__c', this.accountCode));
        }
        if (String.isNotBlank(this.accountName)) {
            whereConditions.add(JEOLUtil.appendLikeText('SalesAccount__r.name', this.accountName));
        }
        if (String.isNotBlank(this.shipmentAccountCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('ShipmentAccount__r.Code__c', this.shipmentAccountCode));
        }
        if (String.isNotBlank(this.shipmentAccountName)) {
            whereConditions.add(JEOLUtil.appendLikeText('ShipmentAccount__r.name', this.shipmentAccountName));
        }
        if (String.isNotBlank(this.area)) {
            whereConditions.add(JEOLUtil.appendEqualText('Area__c', this.area));
        }
        if (String.isNotBlank(this.updateStatus)) {
            whereConditions.add(JEOLUtil.appendEqualText('UpdateStatus__c', this.updateStatus));
        }
        if (String.isNotBlank(this.contractPeriodTarget)) {
            String targetFieldName;
            if (this.contractPeriodTarget == CONTRACT_PERIOD_TARGET_NAME_START) {
                targetFieldName = 'MaintenanceStartDateFormula__c';
            } else if (this.contractPeriodTarget == CONTRACT_PERIOD_TARGET_NAME_END) {
                targetFieldName = 'MaintenanceEndDateFormula__c';
            }
            try {
                if (String.isNotBlank(targetFieldName)) {
                    if (String.isNotBlank(this.contractPeriodFrom)) {
                        Date fromDate = Date.parse(contractPeriodFrom);
                        whereConditions.add(JEOLUtil.appendGreaterThanEqualText(targetFieldName, fromDate.format().replace('/','-'), false));
                    }
                    if (String.isNotBlank(this.contractPeriodTo)) {
                        Date toDate = Date.parse(contractPeriodTo);
                        whereConditions.add(JEOLUtil.appendLessThanEqualText(targetFieldName, toDate.format().replace('/','-'), false));
                    }
                    if (String.isBlank(this.contractPeriodFrom) && String.isBlank(this.contractPeriodTo)) {
                        whereConditions.add(' ' + targetFieldName + ' = null ');
                    }
                }
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'契約更新日は半角の「年/月/日」で入力してください。'));
                return;
            }
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

    public PageReference search1() {
        orderBy= 'Name';
        currentOrder = 'Name';
        orderDesc = false;
        search();
        return null;
    }

    /**
     *  検索（StandardSetController初期化）
     */
    private void search() {

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        setStandardSetController();
        if(ssc != null) {
            ssc.setPageNumber(1);
        }

        // 検索条件のCookie保存
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