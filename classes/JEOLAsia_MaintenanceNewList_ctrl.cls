public with sharing class JEOLAsia_MaintenanceNewList_ctrl extends JEOL_SearchBase_ctrl{

    public String customerCode{get; set;}
    public String customerName{get; set;}
    public String custCodeType{get; set;}
    public String custNameType{get; set;}
    public String salesResponsible{get; set;}
    public String shipmentAddress{get; set;}

    public String filterSerialNumber{get; set;}
    public String filterModel{get; set;}
    public String filterCountry{get; set;}
    public String filterStatus{get; set;}
    public String filterMonth{get; set;}

    public String quotationCreated{get; set;}
    public String saCreated{get; set;}
    public String existLastActivityDate{get; set;}

    public String lastActivityDateFrom{get; set;}
    public String lastActivityDateTo{get; set;}
    public String quotationSentDateFrom{get; set;}
    public String quotationSentDateTo{get; set;}
    public String periodFrom{get; set;}
    public String periodTo{get; set;}


    private List<String> targetSeries;
    public List<OptionDetail> SeriesOptions{get; set;}

    public String lastSearchTargetSeries{get; set;}

    public String lastSearchCustomerCode{get; set;}
    public String lastSearchCustomerName{get; set;}
    public String lastSearchCustCodeType{get; set;}
    public String lastSearchCustNameType{get; set;}
    public String lastSearchSalesResponsible{get; set;}
    public String lastSearchShipmentAddress{get; set;}
    public String lastSearchQuotationCreated{get; set;}
    public String lastSearchSACreated{get; set;}
    public String lastSearchExistLastActivityDate{get; set;}

    public String lastSearchFilterSerialNumber{get; set;}
    public String lastSearchFilterModel{get; set;}
    public String lastSearchFilterCountry{get; set;}
    public String lastSearchFilterStatus{get; set;}
    public String lastSearchFilterMonth{get; set;}

    public String lastSearchLastActivityDateFrom{get; set;}
    public String lastSearchLastActivityDateTo{get; set;}
    public String lastSearchQuotationSentDateFrom{get; set;}
    public String lastSearchQuotationSentDateTo{get; set;}
    public String lastSearchPeriodFrom{get; set;}
    public String lastSearchPeriodTo{get; set;}

    //VF datepicker を動作させるため
    public AsiaMaintenanceContractManagement__c mcm{get; set;}

    public Id dataId{get; set;}
    List<id> lsIdChecked = new List<id>();

    private static final String COOKIE_LABEL_CUSTOMERCODE = 'JEOL_MaintenanceListNew_CustomerCode';
    private static final String COOKIE_LABEL_CUSTOMERNAME = 'JEOL_MaintenanceListNew_CustomerName';
    private static final String COOKIE_LABEL_CUSTCODETYPE = 'JEOL_MaintenanceListNew_CustCodeType';
    private static final String COOKIE_LABEL_CUSTNAMETYPE = 'JEOL_MaintenanceListNew_CustNameType';
    private static final String COOKIE_LABEL_SALESRESPONSIBLE = 'JEOL_MaintenanceListNew_SalesResponsible';
    private static final String COOKIE_LABEL_SHIPMENTADDRESS = 'JEOL_MaintenanceListNew_ShipmentAddress';
    private static final String COOKIE_LABEL_QUOTATIONCREATED = 'JEOL_MaintenanceListNew_QuotationCreated';
    private static final String COOKIE_LABEL_SACREATED = 'JEOL_MaintenanceListNew_SACreated';
    private static final String COOKIE_LABEL_EXISTLASTACTIVITYDATE = 'JEOL_MaintenanceListNew_ExistLastActivityDate';
    private static final String COOKIE_LABEL_LASTACTIVITYDATEFROM = 'JEOL_MaintenanceListNew_LastActivityDateFrom';
    private static final String COOKIE_LABEL_LASTACTIVITYDATETO = 'JEOL_MaintenanceListNew_LastActivityDateTo';
    private static final String COOKIE_LABEL_QUOTATIONSENTDATEFROM = 'JEOL_MaintenanceListNew_QuotationSentDateFrom';
    private static final String COOKIE_LABEL_QUOTATIONSENTDATETO = 'JEOL_MaintenanceListNew_QuotationSentDateTo';
    private static final String COOKIE_LABEL_PERIODFROM = 'JEOL_MaintenanceListNew_PeriodFrom';
    private static final String COOKIE_LABEL_PERIODTO = 'JEOL_MaintenanceListNew_PeriodTo';
    private static final String COOKIE_LABEL_TARGETSERIES = 'JEOL_MaintenanceListNew_TargetSeries';
    private static final String COOKIE_LABEL_FILTERSERIALNUMBER = 'JEOL_MaintenanceListNew_SerialNumber';
    private static final String COOKIE_LABEL_FILTERMODEL = 'JEOL_MaintenanceListNew_Model';
    private static final String COOKIE_LABEL_FILTERCOUNTRY = 'JEOL_MaintenanceListNew_Country';
    private static final String COOKIE_LABEL_FILTERSTATUS = 'JEOL_MaintenanceListNew_Status';
    private static final String COOKIE_LABEL_FILTERMONTH = 'JEOL_MaintenanceListNew_Month';

    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_PATH = '/apex/JEOLAsia_MaintenanceNewList';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    // 画面起動時検索フラグ（'true'の場合に検索する）
    private String initSearchFlg = '';
    // エラーフラグ
    private Boolean errFlg = false;

    public List<SelectOption> getCountryOptions(){
        List<SelectOption> options = JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_COUNTRY);
        List<SelectOption> dispOptions = new List<SelectOption>();
        for (SelectOption option: options) {
            String value = option.getValue();
            String label = option.getLabel();
            SelectOption newOption = new SelectOption(label, label);
            dispOptions.add(newOption);
        }
        return dispOptions;
    }

    public List<SelectOption> getStatusOptions(){
        List<SelectOption> options = new List<SelectOption>();        
        options.add(new SelectOption('', ''));
        for( Schema.PicklistEntry f : AsiaMaintenanceContractManagement__c.Status__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }       
        return options;
    }

    public JEOLAsia_MaintenanceNewList_ctrl() {
        orderBy= 'name';
        currentOrder = 'name';
        orderDesc = false;
        Boolean hasSearchValue = initFieldFromCookie();
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

    public void doFormClear() {
        customerCode = null;
        customerName = null;
        custCodeType = '1';
        custNameType = '1';
        salesResponsible = null;
        shipmentAddress = null;
        quotationCreated = null;
        saCreated = null;
        existLastActivityDate = null;
        lastActivityDateFrom = null;
        lastActivityDateTo = null;
        quotationSentDateFrom = null;
        quotationSentDateTo = null;
        periodFrom = null;
        periodTo = null;
        filterSerialNumber = null;
        filterModel = null;
        filterCountry = null;
        filterStatus = null;
        filterMonth = null;
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

    protected override void setStandardSetController() {
        lsIdChecked.clear();
        String soql = ' SELECT ';
        soql += ' Id, Name,CurrencyIsoCode, ';
        soql += ' ContractSentDate__c, QuotationSentDate__c, LastActivityDate, QuotationCreated__c, ';
        soql += ' ProjectMaster__c, ProjectMaster__r.ProjectNumber__c, ProjectMaster__r.Name, ProjectMaster__r.SerialNumber__c,';
        soql += ' NewOdrFlagshipProduct__c, CurrencyContractPrice__c, ContractPrice__c, NewContractStartDate__c, NewContractEndDate__c,';
        soql += ' NewOdrSalesAccount__c, NewOdrShipmentAccount__c, NewOdrShipmentAccount__r.Country__c, SACreated__c, ';
        soql += ' NewOdrSalesPipeline__c, Status__c ';
        soql += ' FROM ';
        soql += ' AsiaMaintenanceContractManagement__c ';
        List<String> whereStrElems = getWhereStrList();
        if (whereStrElems.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrElems);
        }

        soql += ' ORDER BY ' + this.orderBy;
        if (this.orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        system.debug('SOQL===' + soql);
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' LIMIT 10000 '));
        if (this.errFlg) {
            ssc = null;
        } else if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, Label.JEOLAsia_MaintList_Message_TooMuchData));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }

    }

    private List<String> getWhereStrList() {
        this.errFlg = false;  // エラーフラグ初期化
        List<String> strList = new List<String>();
        if (this.TargetSeries != null && this.TargetSeries.size() > 0) {
            lastSearchTargetSeries = String.join(this.TargetSeries, '_');
        }

        lastSearchCustomerCode = customerCode;
        lastSearchCustomerName = customerName;
        lastSearchCustCodeType = custCodeType;
        lastSearchCustNameType = custNameType;
        lastSearchSalesResponsible = salesResponsible;
        lastSearchShipmentAddress = shipmentAddress;
        lastSearchQuotationCreated = quotationCreated;
        lastSearchSaCreated = saCreated;
        lastSearchExistLastActivityDate = existLastActivityDate;
        lastSearchLastActivityDateFrom = lastActivityDateFrom;
        lastSearchLastActivityDateTo = lastActivityDateTo;
        lastSearchQuotationSentDateFrom = quotationSentDateFrom;
        lastSearchQuotationSentDateTo = quotationSentDateTo;
        lastSearchPeriodFrom = periodFrom;
        lastSearchPeriodTo = periodTo;
        lastSearchFilterSerialNumber = filterSerialNumber;
        lastSearchFilterModel = filterModel;
        lastSearchFilterCountry = filterCountry;
        lastSearchFilterStatus = filterStatus;
        lastSearchFilterMonth = filterMonth;
        
        // 系列
        if (this.targetSeries != null && this.targetSeries.size() > 0) {
            strList.add('(' + JEOLUtil.appendInText('NewOdrSeries__c', this.targetSeries) + ')');
        }

        // 販売先・出荷先コード
        if (String.isNotBlank(this.customerCode)) {
            if (custCodeType == '2') {
                // 出荷先
                strList.add(JEOLUtil.appendAfterLikeText('NewOdrShipmentAccount__r.Code__c', this.customerCode));
            } else {
                // 販売先
                strList.add(JEOLUtil.appendAfterLikeText('NewOdrSalesAccount__r.Code__c', this.customerCode));
            }
        }

        // 販売先・出荷先名称
        if (String.isNotBlank(this.customerName)) {
            if (custNameType == '2') {
                // 出荷先
                strList.add(JEOLUtil.appendLikeText('NewOdrShipmentAccount__r.Name', this.customerName));
            } else {
                // 販売先
                strList.add(JEOLUtil.appendLikeText('NewOdrSalesAccount__r.Name', this.customerName));
            }
        }

        // 更新担当者
        if (String.isNotBlank(this.salesResponsible)) {
            strList.add('((' +
                        JEOLUtil.appendAfterLikeText('NewOdrSalesStaff__r.UserCode__c', this.salesResponsible) +
                        ') OR (' +
                        JEOLUtil.appendLikeText('NewOdrSalesStaff__r.Name', this.salesResponsible) +
                        ') OR (' +
                        JEOLUtil.appendAfterLikeText('NewOdrAssistant__r.UserCode__c', this.salesResponsible) +
                        ') OR (' +
                        JEOLUtil.appendLikeText('NewOdrAssistant__r.Name', this.salesResponsible) +
                        '))' );
        }

        // 住所
        if (String.isNotBlank(this.shipmentAddress)) {
            strList.add(JEOLUtil.appendLikeText('NewOdrShipmentAccount__r.Address__c', this.shipmentAddress));
        }

        // Quotation Created
        if (String.isNotBlank(this.quotationCreated)) {
            if (quotationCreated == '1') {
                strList.add('QuotationCreated__c = true');
            } else if (quotationCreated == '2') {
                strList.add('QuotationCreated__c = false');
            }
        }

        // SA Created
        if (String.isNotBlank(this.saCreated)) {
            if (saCreated == '1') {
                strList.add('SACreated__c = true');
            } else if (saCreated == '2') {
                strList.add('SACreated__c = false');
            }
        }

        // 対応日付
        if (String.isNotBlank(String.valueOf(this.lastActivityDateFrom))) {
            Date fromDate = Date.parse(this.lastActivityDateFrom);
            String fromDateToStr = String.valueOf(fromDate);
            strList.add(JEOLUtil.appendGreaterThanEqualText('LastActivityDate', fromDateToStr, false));
        }
        if (String.isNotBlank(String.valueOf(this.lastActivityDateTo))) {
            Date toDate = Date.parse(this.lastActivityDateTo);
            String toDateToStr = String.valueOf(toDate);
            strList.add(JEOLUtil.appendLessThanEqualText('LastActivityDate', toDateToStr, false));
        }

        // 見積書有無
        if (String.isNotBlank(this.existLastActivityDate)) {
            if (existLastActivityDate == '1') {
                strList.add('LastActivityDate != null');
            } else if (existLastActivityDate == '2') {
                strList.add('LastActivityDate = null');
            }
        }

        // 見積書送付日
        if (String.isNotBlank(String.valueOf(this.quotationSentDateFrom))) {
            Date fromDate = Date.parse(this.quotationSentDateFrom);
            String fromDateToStr = String.valueOf(fromDate);
            strList.add(JEOLUtil.appendGreaterThanEqualText('QuotationSentDate__c', fromDateToStr, false));
        }
        if (String.isNotBlank(String.valueOf(this.quotationSentDateTo))) {
            Date toDate = Date.parse(this.quotationSentDateTo);
            String toDateToStr = String.valueOf(toDate);
            strList.add(JEOLUtil.appendLessThanEqualText('QuotationSentDate__c', toDateToStr, false));
        }
        // 予定開始日
        if (String.isNotBlank(String.valueOf(this.periodFrom))) {
            Date fromDate = Date.parse(this.periodFrom);
            String fromDateToStr = String.valueOf(fromDate);
            strList.add(JEOLUtil.appendGreaterThanEqualText('NewContractStartDate__c', fromDateToStr, false));
        }
        if (String.isNotBlank(String.valueOf(this.periodTo))) {
            Date toDate = Date.parse(this.periodTo);
            String toDateToStr = String.valueOf(toDate);
            strList.add(JEOLUtil.appendLessThanEqualText('NewContractStartDate__c', toDateToStr, false));
        }

        // Serial Number
        if (String.isNotBlank(this.filterSerialNumber)) {
            strList.add(JEOLUtil.appendLikeText('ProjectMaster__r.SerialNumber__c', this.filterSerialNumber));
        }

        // Model
        if (String.isNotBlank(this.filterModel)) {
            strList.add(JEOLUtil.appendLikeText('NewOdrFlagshipProduct__c', this.filterModel));
        }

        // Country
        if (String.isNotBlank(this.filterCountry)) {
            strList.add(JEOLUtil.appendLikeText('NewOdrShipmentAccount__r.Country__c', this.filterCountry));
        }

        // Status
        if (String.isNotBlank(this.filterStatus)) {
            strList.add(JEOLUtil.appendEqualText('Status__c', this.filterStatus));
        }

        // Renewal Month
        if (String.isNotBlank(this.filterMonth)) {
            strList.add('RenewalMonthFormula__c <= \'' + (String.escapeSingleQuotes(filterMonth) + '999999').substring(0, 6) + '\'');
        }

        return strList;
    }

    /*  検索結果の取得   */
    public List<rowWrapper> getMaintenanceContractManagements() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;

        if(ssc != null) {
            for (AsiaMaintenanceContractManagement__c row: (List<AsiaMaintenanceContractManagement__c>)ssc.getRecords()) {
                rowWrapper orderPlan = new rowWrapper(row, currentCount);
                rows.add(orderPlan);
                currentCount++;
            }
        }
        return rows;
    }

    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERCODE, this.customerCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMERNAME, this.customerName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTCODETYPE, this.custCodeType, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_CUSTNAMETYPE, this.custNameType, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALESRESPONSIBLE, this.salesResponsible, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SHIPMENTADDRESS, this.shipmentAddress, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONCREATED, this.quotationCreated, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SACREATED, this.saCreated, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_EXISTLASTACTIVITYDATE, this.existLastActivityDate, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_FILTERSERIALNUMBER, this.filterSerialNumber, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_FILTERMODEL, this.filterModel, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_FILTERCOUNTRY, this.filterCountry, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_FILTERSTATUS, this.filterStatus, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_FILTERMONTH, this.filterMonth, COOKIE_PATH, -1, true));

        String fromDateStr;

        if (this.lastActivityDateFrom != null) {
            fromDateStr = lastActivityDateFrom.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_LASTACTIVITYDATEFROM, fromDateStr, COOKIE_PATH, -1, true));

        if (this.lastActivityDateTo != null) {
            fromDateStr = lastActivityDateTo.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_LASTACTIVITYDATETO, fromDateStr, COOKIE_PATH, -1, true));

        if (this.quotationSentDateFrom != null) {
            fromDateStr = quotationSentDateFrom.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONSENTDATEFROM, fromDateStr, COOKIE_PATH, -1, true));

        if (this.quotationSentDateTo != null) {
            fromDateStr = quotationSentDateTo.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONSENTDATETO, fromDateStr, COOKIE_PATH, -1, true));

        if (this.periodFrom != null) {
            fromDateStr = periodFrom.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_PERIODFROM, fromDateStr, COOKIE_PATH, -1, true));

        if (this.periodTo != null) {
            fromDateStr = periodTo.replaceAll('/', '-');
        }
        cookies.add(new Cookie(COOKIE_LABEL_PERIODTO, fromDateStr, COOKIE_PATH, -1, true));

        //cookies.add(new Cookie(COOKIE_LABEL_LASTACTIVITYDATEFROM, (this.lastActivityDateFrom == null ? null : this.lastActivityDateFrom.format()), COOKIE_PATH, -1, true));
        //cookies.add(new Cookie(COOKIE_LABEL_LASTACTIVITYDATETO, (this.lastActivityDateTo == null ? null : this.lastActivityDateTo.format()), COOKIE_PATH, -1, true));
        //cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONSENTDATEFROM, (this.quotationSentDateFrom == null ? null : this.quotationSentDateFrom.format()), COOKIE_PATH, -1, true));
        //cookies.add(new Cookie(COOKIE_LABEL_QUOTATIONSENTDATETO, (this.quotationSentDateTo == null ? null : this.quotationSentDateTo.format()), COOKIE_PATH, -1, true));
        //cookies.add(new Cookie(COOKIE_LABEL_PERIODFROM, (this.periodFrom == null ? null : this.periodFrom.format()), COOKIE_PATH, -1, true));
        //cookies.add(new Cookie(COOKIE_LABEL_PERIODTO, (this.periodTo == null ? null : this.periodTo.format()), COOKIE_PATH, -1, true));

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

    public void setSizeSaveCurrentPageSize() {
        changeSize();
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

    public void firstAndSaveCurrentPageNumber() {
        first();
        setCookieCurrentPageNumber();
    }

    public void previousAndSaveCurrentPageNumber() {
        previous();
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

    public String getRedirectExportCsvURL(){
        String sParameters = '';

        final String PARAM_SERIES = 'SERIES';
        final String PARAM_CUSTOMERCODE = 'CUSTOMERCODE';
        final String PARAM_CUSTOMERNAME = 'CUSTOMERNAME';
        final String PARAM_CUSTCODETYPE = 'CUSTCODETYPE';
        final String PARAM_CUSTNAMETYPE = 'CUSTNAMETYPE';
        final String PARAM_SALESRESPONSIBLE = 'SALESRESPONSIBLE';
        final String PARAM_SHIPMENTADDRESS = 'SHIPMENTADDRESS';
        final String PARAM_QUOTATIONCREATED = 'QUOTATIONCREATED';
        final String PARAM_SACREATED = 'SACREATED';
        final String PARAM_EXISTLASTACTIVITYDATE = 'EXISTLASTACTIVITYDATE';
        final String PARAM_LASTACTIVITYDATEFROM = 'LASTACTIVITYDATEFROM';
        final String PARAM_LASTACTIVITYDATETO = 'LASTACTIVITYDATETO';
        final String PARAM_QUOTATIONSENTDATEFROM = 'QUOTATIONSENTDATEFROM';
        final String PARAM_QUOTATIONSENTDATETO = 'QUOTATIONSENTDATETO';
        final String PARAM_PERIODFROM = 'PERIODFROM';
        final String PARAM_PERIODTO = 'PERIODTO';
        final String PARAM_FILTERSERIALNUMBER = 'FILTERSERIALNUMBER';
        final String PARAM_FILTERMODEL = 'FILTERMODEL';
        final String PARAM_FILTERCOUNTRY = 'FILTERCOUNTRY';
        final String PARAM_FILTERSTATUS = 'FILTERSTATUS';
        final String PARAM_FILTERMONTH = 'FILTERMONTH';

        // 系列
        if (String.isNotBlank(this.lastSearchTargetSeries)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_SERIES + '=' + this.lastSearchTargetSeries;
        }

        if (String.isNotBlank(this.lastSearchCustomerCode)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_CUSTOMERCODE + '=' + this.lastSearchCustomerCode;
        }

        if (String.isNotBlank(this.lastSearchCustomerName)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_CUSTOMERNAME + '=' + this.lastSearchCustomerName;
        }

        if (String.isNotBlank(this.lastSearchCustCodeType)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_CUSTCODETYPE + '=' + this.lastSearchCustCodeType;
        }

        if (String.isNotBlank(this.lastSearchCustNameType)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_CUSTNAMETYPE + '=' + this.lastSearchCustNameType;
        }

        if (String.isNotBlank(this.lastSearchSalesResponsible)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_SALESRESPONSIBLE + '=' + this.lastSearchSalesResponsible;
        }

        if (String.isNotBlank(this.lastSearchShipmentAddress)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_SHIPMENTADDRESS + '=' + this.lastSearchShipmentAddress;
        }

        if (String.isNotBlank(this.lastSearchQuotationCreated)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_QUOTATIONCREATED + '=' + this.lastSearchQuotationCreated;
        }

        if (String.isNotBlank(this.lastSearchSaCreated)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_SACREATED + '=' + this.lastSearchSaCreated;
        }

        if (String.isNotBlank(this.lastSearchExistLastActivityDate)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_EXISTLASTACTIVITYDATE + '=' + this.lastSearchExistLastActivityDate;
        }

        if (String.isNotBlank(this.lastSearchLastActivityDateFrom)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_LASTACTIVITYDATEFROM + '=' + this.lastSearchLastActivityDateFrom;
        }

        if (String.isNotBlank(this.lastSearchLastActivityDateTo)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_LASTACTIVITYDATETO + '=' + this.lastSearchLastActivityDateTo;
        }

        if (String.isNotBlank(this.lastSearchQuotationSentDateFrom)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_QUOTATIONSENTDATEFROM + '=' + this.lastSearchQuotationSentDateFrom;
        }

        if (String.isNotBlank(this.lastSearchQuotationSentDateTo)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_QUOTATIONSENTDATETO + '=' + this.lastSearchQuotationSentDateTo;
        }

        if (String.isNotBlank(this.lastSearchPeriodFrom)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_PERIODFROM + '=' + this.lastSearchPeriodFrom;
        }

        if (String.isNotBlank(this.lastSearchPeriodTo)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_PERIODTO + '=' + this.lastSearchPeriodTo;
        }

        if (String.isNotBlank(this.lastSearchFilterSerialNumber)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_FILTERSERIALNUMBER + '=' + this.lastSearchFilterSerialNumber;
        }

        if (String.isNotBlank(this.lastSearchFilterModel)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_FILTERMODEL + '=' + this.lastSearchFilterModel;
        }

        if (String.isNotBlank(this.lastSearchFilterCountry)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_FILTERCOUNTRY + '=' + this.lastSearchFilterCountry;
        }

        if (String.isNotBlank(this.lastSearchFilterStatus)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_FILTERSTATUS + '=' + this.lastSearchFilterStatus;
        }

        if (String.isNotBlank(this.lastSearchFilterMonth)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_FILTERMONTH + '=' + this.lastSearchFilterMonth;
        }

        return '/apex/JEOLAsia_MaintenanceListNewCsv' + (sParameters.length() > 0 ? '?' + sParameters : '');
    }

    public List<SelectOption> getListAccountTypeCode() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'Sales'));
        options.add(new SelectOption('2', 'Shipment Code'));
        return options;
    }

    public List<SelectOption> getListAccountTypeName() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', 'Sales'));
        options.add(new SelectOption('2', 'Shipment Name'));
        return options;
    }

    public List<SelectOption> getListQuotationCreated() {
        List<SelectOption> options = options();
        return options;
    }

    public List<SelectOption> getListSACreated() {
        List<SelectOption> options = options();
        return options;
    }

    public List<SelectOption> getListExistLastActivityDate() {
        List<SelectOption> options = options();
        return options;
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

    private List<SelectOption> options(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        options.add(new SelectOption('1', 'Yes'));
        options.add(new SelectOption('2', 'No'));
        return options;
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


    private Boolean initFieldFromCookie() {
        this.custCodeType = '1';
        this.custNameType = '1';
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        if (cookies.containsKey(COOKIE_LABEL_CUSTOMERCODE)) {
            this.customerCode = cookies.get(COOKIE_LABEL_CUSTOMERCODE).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_CUSTOMERNAME)) {
            this.customerName = cookies.get(COOKIE_LABEL_CUSTOMERNAME).getValue();
        }

        if (cookies.containsKey(COOKIE_LABEL_CUSTCODETYPE)) {
            this.custCodeType = cookies.get(COOKIE_LABEL_CUSTCODETYPE).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_CUSTNAMETYPE)) {
            this.custNameType = cookies.get(COOKIE_LABEL_CUSTNAMETYPE).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_SALESRESPONSIBLE)) {
            this.salesResponsible = cookies.get(COOKIE_LABEL_SALESRESPONSIBLE).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_SHIPMENTADDRESS)) {
            this.shipmentAddress = cookies.get(COOKIE_LABEL_SHIPMENTADDRESS).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_QUOTATIONCREATED)) {
            this.quotationCreated = cookies.get(COOKIE_LABEL_QUOTATIONCREATED).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_SACREATED)) {
            this.saCreated = cookies.get(COOKIE_LABEL_SACREATED).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_EXISTLASTACTIVITYDATE)) {
            this.existLastActivityDate = cookies.get(COOKIE_LABEL_EXISTLASTACTIVITYDATE).getValue();
        }

        if (cookies.containsKey(COOKIE_LABEL_LASTACTIVITYDATEFROM)) {
            try{
                this.lastActivityDateFrom =cookies.get(COOKIE_LABEL_LASTACTIVITYDATEFROM).getValue().replaceAll('-', '/');
                //this.lastActivityDateFrom = Date.parse(cookies.get(COOKIE_LABEL_LASTACTIVITYDATEFROM).getValue());
            } catch(Exception ex){
            }
        }
        if (cookies.containsKey(COOKIE_LABEL_LASTACTIVITYDATETO)) {
            try{
                this.lastActivityDateTo =cookies.get(COOKIE_LABEL_LASTACTIVITYDATETO).getValue().replaceAll('-', '/');
                //this.lastActivityDateTo = Date.parse(cookies.get(COOKIE_LABEL_LASTACTIVITYDATETO).getValue());
            } catch(Exception ex){
            }
        }
        if (cookies.containsKey(COOKIE_LABEL_QUOTATIONSENTDATEFROM)) {
            try{
                this.quotationSentDateFrom =cookies.get(COOKIE_LABEL_QUOTATIONSENTDATEFROM).getValue().replaceAll('-', '/');
                //this.quotationSentDateFrom = Date.parse(cookies.get(COOKIE_LABEL_QUOTATIONSENTDATEFROM).getValue());
            } catch(Exception ex){
            }
        }
        if (cookies.containsKey(COOKIE_LABEL_QUOTATIONSENTDATETO)) {
            try{
                this.quotationSentDateTo =cookies.get(COOKIE_LABEL_QUOTATIONSENTDATETO).getValue().replaceAll('-', '/');
                //this.quotationSentDateTo = Date.parse(cookies.get(COOKIE_LABEL_QUOTATIONSENTDATETO).getValue());
            } catch(Exception ex){
            }
        }
        if (cookies.containsKey(COOKIE_LABEL_PERIODFROM)) {
            try{
                this.periodFrom =cookies.get(COOKIE_LABEL_PERIODFROM).getValue().replaceAll('-', '/');
                //this.periodFrom = Date.parse(cookies.get(COOKIE_LABEL_PERIODFROM).getValue());
            } catch(Exception ex){
            }
        }
        if (cookies.containsKey(COOKIE_LABEL_PERIODTO)) {
            try{
                this.periodTo =cookies.get(COOKIE_LABEL_PERIODTO).getValue().replaceAll('-', '/');
                //this.periodTo = Date.parse(cookies.get(COOKIE_LABEL_PERIODTO).getValue());
            } catch(Exception ex){
            }
        }

        if (cookies.containsKey(COOKIE_LABEL_TARGETSERIES)) {
            String targetSeriesText = cookies.get(COOKIE_LABEL_TARGETSERIES).getValue();
            if (String.isNotBlank(targetSeriesText)) {
                this.targetSeries = targetSeriesText.split('&&');
            }
        }

        if (cookies.containsKey(COOKIE_LABEL_FILTERSERIALNUMBER)) {
            this.filterSerialNumber = cookies.get(COOKIE_LABEL_FILTERSERIALNUMBER).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_FILTERMODEL)) {
            this.filterModel = cookies.get(COOKIE_LABEL_FILTERMODEL).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_FILTERCOUNTRY)) {
            this.filterCountry = cookies.get(COOKIE_LABEL_FILTERCOUNTRY).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_FILTERSTATUS)) {
            this.filterStatus = cookies.get(COOKIE_LABEL_FILTERSTATUS).getValue();
        }
        if (cookies.containsKey(COOKIE_LABEL_FILTERMONTH)) {
            this.filterMonth = cookies.get(COOKIE_LABEL_FILTERMONTH).getValue();
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
    /* 検索結果の設定 */
    public class rowWrapper{
        public AsiaMaintenanceContractManagement__c rec {get; set;}
        public Integer rowNumber {get; set;}

        public rowWrapper(AsiaMaintenanceContractManagement__c rec, Integer rowNumber) {
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
    }
}