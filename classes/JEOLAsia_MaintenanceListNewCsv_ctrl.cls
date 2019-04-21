public with sharing class JEOLAsia_MaintenanceListNewCsv_ctrl extends JEOL_SearchBase_ctrl{

    public String customerCode{get; set;}
    public String customerName{get; set;}
    public String custCodeType{get; set;}
    public String custNameType{get; set;}
    public String salesResponsible{get; set;}
    public String shipmentAddress{get; set;}
    public String quotationCreated{get; set;}
    public String saCreated{get; set;}
    public String existLastActivityDate{get; set;}
    public Date lastActivityDateFrom{get; set;}
    public Date lastActivityDateTo{get; set;}
    public Date quotationSentDateFrom{get; set;}
    public Date quotationSentDateTo{get; set;}
    public Date periodFrom{get; set;}
    public Date periodTo{get; set;}
    public String orderProbabilityFrom{get; set;}
    public String orderProbabilityTo{get; set;}
    private List<String> targetSeries;

    public List<List<String>> lslsstrRowMCM{get;set;}

    public String sTitle{get;set;}

    public String getFileName() {
        return 'NewList_' + date.today().format() + '.csv';
    }

    public JEOLAsia_MaintenanceListNewCsv_ctrl() {
		initFieldFromCookie();
        String soql = ' SELECT ' +
                            ' Id, Name, ' +
                            ' ContractSentDate__c, QuotationSentDate__c, LastActivityDate, QuotationCreated__c, SACreated__c,' +
                            ' CurrencyContractPrice__c, ContractPrice__c, ' +
                            ' NewOdrSalesAccount__r.Name, NewOdrSalesAccount__r.Code__c, NewOdrShipmentAccount__r.Name, NewOdrShipmentAccount__r.Code__c, NewOdrFlagshipProduct__c,' +
                            ' JuchuKakudoValue__c, NewOdrSalesPipeline__r.Name' +
                      ' FROM ' +
                          ' AsiaMaintenanceContractManagement__c ';
	   List<String> whereStrElems = getWhereStrList();
        if (whereStrElems.size() > 0) {
            soql += JEOLUtil.joinWhereConditions(whereStrElems);
        }

        lslsstrRowMCM = new List<List<String>>();

        sTitle = '';

        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.Name.getDescribe().getLabel(), true);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.NewOdrSalesPipeline__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.NewOdrFlagshipProduct__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, 'Sales Account Code', false);
        sTitle = ConcatenateField(sTitle, 'Sales Account Name', false);
        sTitle = ConcatenateField(sTitle, 'Shipment Account Code', false);
        sTitle = ConcatenateField(sTitle, 'Shipment Account Name', false);
        sTitle = ConcatenateField(sTitle, 'Last Activity', false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.CurrencyContractPrice__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.ContractPrice__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.JuchuKakudoValue__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.QuotationCreated__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.QuotationSentDate__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.SACreated__c.getDescribe().getLabel(), false);
        sTitle = ConcatenateField(sTitle, Schema.AsiaMaintenanceContractManagement__c.fields.ContractSentDate__c.getDescribe().getLabel(), false);


        List<String> lsstrRowMCM = new List<String>();
        integer iSize = 0;
        for (AsiaMaintenanceContractManagement__c mcm : Database.Query(soql + ' ORDER BY NAME LIMIT 10000 ')) {

            if (iSize == 1000) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            String sRow = '';

            sRow = ConcatenateField(sRow, mcm.Name, true);
            sRow = ConcatenateField(sRow, mcm.NewOdrSalesPipeline__r.Name, false);
            sRow = ConcatenateField(sRow, mcm.NewOdrFlagshipProduct__c, false);
            sRow = ConcatenateField(sRow, mcm.NewOdrSalesAccount__r.Code__c, false);
            sRow = ConcatenateField(sRow, mcm.NewOdrSalesAccount__r.Name, false);
            sRow = ConcatenateField(sRow, mcm.NewOdrShipmentAccount__r.Code__c, false);
            sRow = ConcatenateField(sRow, mcm.NewOdrShipmentAccount__r.Name, false);
            sRow = ConcatenateField(sRow, mcm.LastActivityDate, false);
            sRow = ConcatenateField(sRow, mcm.CurrencyContractPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.ContractPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.JuchuKakudoValue__c, false);
            sRow = ConcatenateField(sRow, mcm.QuotationCreated__c, false);
            sRow = ConcatenateField(sRow, mcm.QuotationSentDate__c, false);
            sRow = ConcatenateField(sRow, mcm.SACreated__c, false);
            sRow = ConcatenateField(sRow, mcm.ContractSentDate__c, false);

            lsstrRowMCM.add(sRow);

            iSize += 1;
        }
        lslsstrRowMCM.add(lsstrRowMCM);
    }

    private String ConcatenateField(String strConcat, object field, boolean fFirstField) {
        String sReturn = strConcat;
        if (!fFirstField) {
            sReturn += ',';
        }
        if (field != null) {
            if (field instanceOf boolean ||
                field instanceOf Decimal ||
                field instanceOf Date) {
                sReturn += field;
            } else {
                String sField = (String)field;
                sField = sField.replaceAll('[\n\r]', ' ');
                sReturn += '"' + sField.replace('"', '""') + '"';
            }
        }
        return sReturn;
    }

    private List<String> getWhereStrList() {
        List<String> strList = new List<String>();

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
        if (this.lastActivityDateFrom != null) {
            strList.add('LastActivityDate >= ' + String.valueOf(this.lastActivityDateFrom));
        }
        if (this.lastActivityDateTo != null) {
            strList.add('LastActivityDate <= ' + String.valueOf(this.lastActivityDateTo));
        }

        // 見積書有無
        if (String.isNotBlank(this.existLastActivityDate)) {
            if (existLastActivityDate == '1') {
                strList.add('LastActivityDate != null');
            } else if (existLastActivityDate == '2') {
                strList.add('LastActivityDate = null');
            }
        }

        // 受注確度
        if (String.isNotBlank(this.orderProbabilityFrom)) {
            strList.add('NewOdrSalesPipeline__r.JuchuKakudoValue__c >= ' + orderProbabilityFrom);
        }
        if (String.isNotBlank(this.orderProbabilityTo)) {
            strList.add('NewOdrSalesPipeline__r.JuchuKakudoValue__c <= ' + orderProbabilityTo);
        }

        // 見積書送付日
        if (this.quotationSentDateFrom != null) {
            strList.add('QuotationSentDate__c >= ' + String.valueOf(this.quotationSentDateFrom));
        }
        if (this.quotationSentDateTo != null) {
            strList.add('QuotationSentDate__c <= ' + String.valueOf(this.quotationSentDateTo));
        }

        // 予定開始日
        if (this.periodFrom != null) {
            strList.add('NewContractStartDate__c >= ' + String.valueOf(this.periodFrom));
        }
        if (this.periodTo != null) {
            strList.add('NewContractStartDate__c <= ' + String.valueOf(this.periodTo));
        }
        return strList;
    }

    private void initFieldFromCookie() {

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
        final String PARAM_ORDERPROBABILITYFROM = 'ORDERPROBABILITYFROM';
        final String PARAM_ORDERPROBABILITYTO = 'ORDERPROBABILITYTO';


        if (Apexpages.currentpage().getparameters().containsKey(PARAM_CUSTOMERCODE)) {
            this.customerCode = Apexpages.currentpage().getparameters().get(PARAM_CUSTOMERCODE);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_CUSTOMERNAME)) {
            this.customerName = Apexpages.currentpage().getparameters().get(PARAM_CUSTOMERNAME);
        }

        if (Apexpages.currentpage().getparameters().containsKey(PARAM_CUSTCODETYPE)) {
            this.custCodeType = Apexpages.currentpage().getparameters().get(PARAM_CUSTCODETYPE);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_CUSTNAMETYPE)) {
            this.custNameType = Apexpages.currentpage().getparameters().get(PARAM_CUSTNAMETYPE);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_SALESRESPONSIBLE)) {
            this.salesResponsible = Apexpages.currentpage().getparameters().get(PARAM_SALESRESPONSIBLE);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_SHIPMENTADDRESS)) {
            this.shipmentAddress = Apexpages.currentpage().getparameters().get(PARAM_SHIPMENTADDRESS);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_QUOTATIONCREATED)) {
            this.quotationCreated = Apexpages.currentpage().getparameters().get(PARAM_QUOTATIONCREATED);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_SACREATED)) {
            this.saCreated = Apexpages.currentpage().getparameters().get(PARAM_SACREATED);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_EXISTLASTACTIVITYDATE)) {
            this.existLastActivityDate = Apexpages.currentpage().getparameters().get(PARAM_EXISTLASTACTIVITYDATE);
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_LASTACTIVITYDATEFROM)) {
            try{
                this.lastActivityDateFrom = Date.parse(Apexpages.currentpage().getparameters().get(PARAM_LASTACTIVITYDATEFROM));
            } catch(Exception ex){
            }
        }
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_LASTACTIVITYDATETO)) {
            try{
                this.lastActivityDateTo = Date.parse(Apexpages.currentpage().getparameters().get(PARAM_LASTACTIVITYDATETO));
            } catch(Exception ex){
            }
        }
        if (apexpages.currentpage().getparameters().containsKey(PARAM_QUOTATIONSENTDATEFROM)) {
            try{
                this.quotationSentDateFrom = Date.parse(apexpages.currentpage().getparameters().get(PARAM_QUOTATIONSENTDATEFROM));
            } catch(Exception ex){
            }
        }
        if (apexpages.currentpage().getparameters().containsKey(PARAM_QUOTATIONSENTDATETO)) {
            try{
                this.quotationSentDateTo = Date.parse(apexpages.currentpage().getparameters().get(PARAM_QUOTATIONSENTDATETO));
            } catch(Exception ex){
            }
        }
        if (apexpages.currentpage().getparameters().containsKey(PARAM_PERIODFROM)) {
            try{
                this.periodFrom = Date.parse(apexpages.currentpage().getparameters().get(PARAM_PERIODFROM));
            } catch(Exception ex){
            }
        }
        if (apexpages.currentpage().getparameters().containsKey(PARAM_PERIODTO)) {
            try{
                this.periodTo = Date.parse(apexpages.currentpage().getparameters().get(PARAM_PERIODTO));
            } catch(Exception ex){
            }
        }
        if (apexpages.currentpage().getparameters().containsKey(PARAM_ORDERPROBABILITYFROM)) {
            this.orderProbabilityFrom = apexpages.currentpage().getparameters().get(PARAM_ORDERPROBABILITYFROM);
        }
        if (apexpages.currentpage().getparameters().containsKey(PARAM_ORDERPROBABILITYTO)) {
            this.orderProbabilityTo = apexpages.currentpage().getparameters().get(PARAM_ORDERPROBABILITYTO);
        }

        if (apexpages.currentpage().getparameters().containsKey(PARAM_SERIES)) {
            String targetSeriesText = apexpages.currentpage().getparameters().get(PARAM_SERIES);
            if (String.isNotBlank(targetSeriesText)) {
                this.targetSeries = targetSeriesText.split('_');
            }
        }
    }
}