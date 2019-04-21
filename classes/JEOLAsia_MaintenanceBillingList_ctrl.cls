public with sharing class JEOLAsia_MaintenanceBillingList_ctrl extends JEOL_SearchBase_ctrl {
    public String month{get; set;}
    public String customerCode{get; set;}
    public String customerName{get; set;}
    public String invoiceNumber{get; set;}
    public String status{get; set;}

    public Id dataId{get; set;}

    private List<String> targetSeries;
    public List<OptionDetail> SeriesOptions{get; set;}

    private static final String COOKIE_LABEL_MONTH = 'JEOL_MaintenanceBillingList_Month';
    private static final String COOKIE_LABEL_SERIES = 'JEOL_MaintenanceBillingList_Series';
    private static final String COOKIE_LABEL_CUSTOMERCODE = 'JEOL_MaintenanceBillingList_CustomerCode';
    private static final String COOKIE_LABEL_CUSTOMERNAME = 'JEOL_MaintenanceBillingList_CustomerName';
    private static final String COOKIE_LABEL_INVOICENUMBER = 'JEOL_MaintenanceBillingList_InvoiceNumber';
    private static final String COOKIE_LABEL_STATUS = 'JEOL_MaintenanceBillingList_Status';
    private static final String COOKIE_LABEL_TARGETSERIES = 'JEOL_MaintenanceBillingList_TargetSeries';

    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_MaintenanceBillingList';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 画面起動時検索フラグ（'true'の場合に検索する）
    private String initSearchFlg = '';

    // エラーフラグ
    private Boolean errFlg = false;

    List<rowWrapper> rows = new List<rowWrapper>();
    public JEOLAsia_MaintenanceBillingList_ctrl() {

        orderBy= 'name';
        currentOrder = 'name';
        orderDesc = false;
        Boolean hasSearchValue = initFieldFromCookie();
        List<OptionDetail> seriesOptions = new List<OptionDetail>();
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

    protected override void setStandardSetController() {
        String soql = ' SELECT '
                    + ' Id, Name, Month__c, MaintenanceContractManagement__r.NewOdrSeries__c, '
                    + ' MaintenanceContractManagement__r.NewOdrFlagshipProduct__c, '
                    + ' MaintenanceContractManagement__r.ContractPrice__c, MaintenanceContractManagement__r.CurrencyContractPrice__c, '
                    + ' BillingDone__c, BillingAmount__c, InvoiceNumber__c, '
                    + ' MaintenanceContractManagement__r.NewOdrSalesAccount__c, MaintenanceContractManagement__r.NewOdrShipmentAccount__c, '
                    + ' MaintenanceContractManagement__r.NewOdrMaintenancePeriodText__c, MaintenanceContractManagement__c '
                    + ' FROM '
                    + ' AsiaMaintenanceAccountBook__c ';

        List<String> whereStrElems = getWhereStrList();
        if (whereStrElems.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrElems);
        }

        soql += ' ORDER BY ' + this.orderBy;
        if (this.orderDesc) {
            soql += ' DESC NULLS LAST';
        }

        soql += ' LIMIT 10000 ';
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        if (this.errFlg) {
            ssc = null;
        } else if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, System.Label.JEOLAsia_MaintInspList_Message_TooMuchData));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }

    private List<String> getWhereStrList() {
        this.errFlg = false;  // エラーフラグ初期化
        List<String> strList = new List<String>();

        strList.add('BillingAmount__c > 0');

        if (String.isNotBlank(this.month)) {
            strList.add(JEOLUtil.appendAfterLikeText('month__c', this.month));
        }

        // 系列
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            strList.add('(' + JEOLUtil.appendInText('MaintenanceContractManagement__r.NewOdrSeries__c', this.targetSeries) + ')');
        }
        if (String.isNotBlank(this.customerCode)) {
            strList.add('((' + JEOLUtil.appendAfterLikeText('MaintenanceContractManagement__r.NewOdrShipmentAccount__r.Code__c', this.customerCode) + ') OR ' +
                         '(' + JEOLUtil.appendAfterLikeText('MaintenanceContractManagement__r.NewOdrSalesAccount__r.Code__c', this.customerCode) + '))');
        }
        if (String.isNotBlank(this.customerName)) {
            strList.add('((' + JEOLUtil.appendLikeText('MaintenanceContractManagement__r.NewOdrShipmentAccount__r.Name', this.customerName) + ') OR ' +
                         '(' + JEOLUtil.appendLikeText('MaintenanceContractManagement__r.NewOdrSalesAccount__r.Name', this.customerName) + '))');
        }

        if (String.isNotBlank(this.status)) {
            if (this.status == '1') {
                strList.add('BillingDone__c = true');
            } else if (this.status == '2') {
                strList.add('BillingDone__c = false');
            }
        }
        if (String.isNotBlank(this.invoiceNumber)) {
            strList.add(JEOLUtil.appendAfterLikeText('InvoiceNumber__c', this.invoiceNumber));
        }

        return strList;
    }

    public void doFormClear() {
        month = null;
        customerCode = null;
        customerName = null;
        invoiceNumber = null;
        status = null;
        this.targetSeries = null;
        for (OptionDetail detail: this.SeriesOptions) {
            detail.setSelected(false);
        }

        ssc = null;
        this.pageNo = 1;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        saveInputValues();
    }

    public void doSearch() {
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

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

    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_MONTH, this.month, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERCODE, this.customerCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERNAME, this.customerName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_STATUS, this.status, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_INVOICENUMBER, this.invoiceNumber, COOKIE_PATH, -1, true));

        String targetSeriesText = '';
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            targetSeriesText = String.join(this.targetSeries, '&&');
        }
        cookies.add(new Cookie(COOKIE_LABEL_TARGETSERIES, targetSeriesText, COOKIE_PATH, -1, true));

        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);
    }

    /*  検索結果の取得   */
    public List<rowWrapper> getSalesPipelines() {
        rows = new List<rowWrapper>();
        Integer currentCount = 0;
        
        if(ssc != null) {
            for (AsiaMaintenanceAccountBook__c row: (List<AsiaMaintenanceAccountBook__c>)ssc.getRecords()) {
                rowWrapper orderPlan = new rowWrapper(row, currentCount);
                rows.add(orderPlan);
                currentCount++;
            }
        }

        return rows;
    }

    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        if(cookies.containsKey(COOKIE_LABEL_MONTH)){
            this.month = cookies.get(COOKIE_LABEL_MONTH).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_CUSTOMERCODE)) {
            this.customerCode = cookies.get(COOKIE_LABEL_CUSTOMERCODE).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_CUSTOMERNAME)) {
            this.customerName = cookies.get(COOKIE_LABEL_CUSTOMERNAME).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_INVOICENUMBER)) {
            this.invoiceNumber = cookies.get(COOKIE_LABEL_INVOICENUMBER).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_STATUS)) {
            this.status = cookies.get(COOKIE_LABEL_STATUS).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_TARGETSERIES)) {
            String targetSeriesText = cookies.get(COOKIE_LABEL_TARGETSERIES).getValue();
            if (String.isNotBlank(targetSeriesText)) {
                this.targetSeries = targetSeriesText.split('&&');
            }
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

    public void saveFlags() {

        for (rowWrapper row : rows) {
            if (row.rec.id == dataId) {
                upsert row.rec;
                break;
            }
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

    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }

    public List<SelectOption> getStatusOptions() {
        List<SelectOption> lsReturn = new List<SelectOption>();
        lsReturn.add(new SelectOption('', ''));
        lsReturn.add(new SelectOption('1', 'Only Billed'));
        lsReturn.add(new SelectOption('2', 'Only Not Billed'));
        return lsReturn;
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

    public String getSelectedSeries() {
        String value = 'None';
        Integer selectedCount = 0;
        Set<String> series = new Set<String>();
        for (OptionDetail detail: this.SeriesOptions) {
            if (detail.isSelected) {
                series.add(detail.option.getLabel());
                selectedCount++;
            }
        }
        if (selectedCount == this.SeriesOptions.size()) {
            value = 'All';
        } else if (series.size() > 0) {
            value = String.join(new List<String>(series), ', ');
        }
        return value;
    }

    /* 検索結果の設定 */
    public class rowWrapper{
        public AsiaMaintenanceAccountBook__c rec {get; set;}
        public Integer rowNumber {get; set;}

        public rowWrapper(AsiaMaintenanceAccountBook__c rec, Integer rowNumber) {
            this.rec = rec;
            this.rowNumber = rowNumber;
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