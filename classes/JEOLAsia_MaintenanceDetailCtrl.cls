public with sharing class JEOLAsia_MaintenanceDetailCtrl {

    public static final String PARAM_ID = 'id';
    public static final String URL_PARAM_NAME_ISCOPY = 'isCopy';
    public AsiaMaintenanceContractManagement__c so {get; set;}
    public List<AsiaMaintenanceAccountBook__c> acountBookList {get; set;}
    public String inspectionDoneOfInspection {get; set;}
    public String inspectionDoneOfInspectionLabel {get; set;}

    public JEOLAsia_MaintenanceDetailCtrl(ApexPages.StandardController ctrl) {
        try {
            List<String> fields = new List<String>();
            fields.add('Name');
            fields.add('ProjectMaster__c');
            fields.add('CompanyName__c');
            fields.add('NewOdrFlagshipProduct__c');
            fields.add('OrgName__c');
            fields.add('NewOdrSeries__c');
            fields.add('NewOdrSalesStaff__c');
            fields.add('NewOdrAssistant__c');
            fields.add('NewOdrSalesAccount__c');
            fields.add('NewOdrShipmentAccount__c');
            fields.add('NewOdrSalesAccount__r.Undergraduate__c');
            fields.add('NewOdrShipmentAccount__r.Undergraduate__c');
            fields.add('NewOdrShipmentAccount__r.Address__C');
            fields.add('NewOdrSalesAccount__r.Address__c');
            fields.add('NewOdrSalesContactPosition__c');
            fields.add('NewOdrShipmentContactPosition__c');
            fields.add('NewOdrSalesContactPost__c');
            fields.add('NewOdrShipmentContactPost__c');
            fields.add('NewOdrSalesTantoshya__c');
            fields.add('NewOdrShipmentTantosha__c');
            fields.add('NewOdrSalesContactTel__c');
            fields.add('NewOdrShipmentContact_Tel__c');
            fields.add('NewOdrSalesContactFax__c');
            fields.add('NewOdrShipmentContact_Fax__c');
            fields.add('NewOdrSalesContactEmail__c');
            fields.add('NewOdrShipmentContact_Email__c');
            fields.add('PreviousYearPipeline__c');
            fields.add('PreviousYearPipeline__r.Id');
            fields.add('PreviousYearPipeline__r.Name');
            fields.add('PreviousYearPipeline__r.NewContractStartDate__c');
            fields.add('PreviousYearPipeline__r.NewContractEndDate__c');
            fields.add('PreviousYearPipeline__r.CustomerPONumber__c');
            fields.add('PreviousYearPipeline__r.NextYearNotes__c');
            fields.add('PreviousYearPipeline__r.Memo__c');
            fields.add('PreviousYearPipeline__r.Status__c');
            fields.add('PreviousYearPipeline__r.ContractPrice__c');
            fields.add('PreviousYearPipeline__r.CurrencyContractPrice__c');
            fields.add('NewOdrSalesPipeline__c');
            fields.add('Status__c');
            fields.add('StatusMemo__c');
            fields.add('QuotationCreated__c');
            fields.add('QuotationSentDate__c');
            fields.add('NewOdrProfitCalculation__c');
            fields.add('SACreated__c');
            fields.add('ContractSentDate__c');
            fields.add('NextYearNotes__c');
            fields.add('Memo__c');
            fields.add('NewContractStartDate__c');
            fields.add('NewContractEndDate__c');
            fields.add('ContractStopDate__c');
            fields.add('Percentage__c');
            fields.add('CustomerPONumber__c');
            fields.add('Company__c');
            fields.add('CurrencyContractPrice__c');
            fields.add('ContractPrice__c');
            fields.add('AccountBookTotalBillingAmount__c');
            fields.add('AccountBookTotalPaymentAmount__c');
            fields.add('AccountBookRemainingAmount__c');
            if (!Test.isRunningTest()) {
                ctrl.addFields(fields);
            }
            this.so = (AsiaMaintenanceContractManagement__c) ctrl.getRecord();
            if(this.so != null){
                acountBookList = getAccountBook(this.so.Id);
            }

            // new : Set Company and Company Name
            if(this.so.Id == null){
                User loginUser = [SELECT
                                        CompanyName
                                  FROM User
                                  WHERE Id = :UserInfo.getUserId()
                                  ];
                for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
                    if (companyCustSettings.CompanyName__c == loginUser.CompanyName) {
                        so.Company__c = companyCustSettings.Company__c;
                        so.CompanyName__c = companyCustSettings.CompanyLabel__c;
                    }
                }
                inspectionDoneOfInspection = '0 / 0';
            }
            // create lable
            inspectionDoneOfInspectionLabel = String.valueOf(AsiaMaintenanceAccountBook__c.InspectionDone__c.getDescribe().getLabel())
                                            + ' / '
                                            + String.valueOf(AsiaMaintenanceAccountBook__c.Inspection__c.getDescribe().getLabel());
            if(this.so.Id != null){
                inspectionDoneOfInspection = countInspection(this.so.Id);
            }
            if (this.so == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Address not correct.'));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Address not correct.'));
            this.so = null;
        }
    }

    // 選択リスト管理(SelectListManage__c)より、系列(Series)を取得
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);
    }

    public Pagereference save() {
        boolean fProblem = false;

        if (so.NewOdrSeries__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.JEOLAsia_MaintDetail_Message_SeriesMissing));
            fProblem = true;
        }

        if (so.ProjectMaster__c != null) {
             //renewal
        } else {
            // new
            if (so.NewOdrSalesAccount__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.JEOLAsia_MaintDetail_Message_SalesAccountMissing));
                fProblem = true;
            }
            if (so.NewOdrShipmentAccount__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.JEOLAsia_MaintDetail_Message_ShipmentAccountMissing));
                fProblem = true;
            }
            if (so.NewOdrSalesStaff__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.JEOLAsia_MaintDetail_Message_SalesPersonMissing));
                fProblem = true;
            }
        }
        if (fProblem) {
            return null;
        }

        try {
            upsert so;
        } catch (exception ex) {
            return null;
        }
        Pagereference ret = Page.JEOLAsia_MaintenanceDetailView;
        ret.setRedirect(true);
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, so.id);
        return ret;
    }

    /**
     * [getAccountBook : get account book list]
     * @param  mcmId [maintenance contract management id]
     * @return       [account book list]
     */
    private List<AsiaMaintenanceAccountBook__c> getAccountBook(String mcmId){
        List<AsiaMaintenanceAccountBook__c> mabList = [
                                                        SELECT
                                                            Id,
                                                            Name,
                                                            Month__c,
                                                            Inspection__c,
                                                            InspectionDone__c,
                                                            BillingDone__c,
                                                            InvoiceNumber__c,
                                                            PaymentAmountFormula__c,
                                                            CurrencyIsoCode,
                                                            Percentage__c
                                                        FROM AsiaMaintenanceAccountBook__c
                                                        WHERE MaintenanceContractManagement__c = : mcmId
                                                        ORDER By Month__c ASC
                                                      ];
        return mabList;
    }

    /**
     * [countInspection: count account book inspection and insectionDone]
     * @param  soId [maintenance contract management id]
     * @return      [insectionDone qty / insection qty]
     */
    private String countInspection(String soId){
        Integer countInspection = 0;
        Integer countInspectionDone = 0;
        for(AsiaMaintenanceAccountBook__c mab :[SELECT
                                                     Inspection__c,
                                                     InspectionDone__c
                                                FROM AsiaMaintenanceAccountBook__c
                                                WHERE MaintenanceContractManagement__c =:soId]){
            if(mab.Inspection__c){
                countInspection ++;
            }
            if(mab.InspectionDone__c){
                countInspectionDone ++;
            }
        }
        return String.valueOf(countInspectionDone) + ' / ' + String.valueOf(countInspection);
    }

    private String convertHalfwidth(String stringToConvert) {

        if (stringToConvert == null) {
            return null;
        }

        String sReturn = stringToConvert;
        sReturn = sReturn.replaceAll('[Ａ]', 'A').replaceAll('[ａ]', 'a').replaceAll('[Ｂ]', 'B').replaceAll('[ｂ]', 'b').replaceAll('[Ｃ]', 'C').replaceAll('[ｃ]', 'c').replaceAll('[Ｄ]', 'D').replaceAll('[ｄ]', 'd').replaceAll('[Ｅ]', 'E').replaceAll('[ｅ]', 'e');
        sReturn = sReturn.replaceAll('[Ｆ]', 'F').replaceAll('[ｆ]', 'f').replaceAll('[Ｇ]', 'G').replaceAll('[ｇ]', 'g').replaceAll('[Ｈ]', 'H').replaceAll('[ｈ]', 'h').replaceAll('[Ｉ]', 'I').replaceAll('[ｉ]', 'i').replaceAll('[Ｊ]', 'J').replaceAll('[ｊ]', 'j');
        sReturn = sReturn.replaceAll('[Ｋ]', 'K').replaceAll('[ｋ]', 'k').replaceAll('[Ｌ]', 'L').replaceAll('[ｌ]', 'l').replaceAll('[Ｍ]', 'M').replaceAll('[ｍ]', 'm').replaceAll('[Ｎ]', 'N').replaceAll('[ｎ]', 'n').replaceAll('[Ｏ]', 'O').replaceAll('[ｏ]', 'o');
        sReturn = sReturn.replaceAll('[Ｐ]', 'P').replaceAll('[ｐ]', 'p').replaceAll('[Ｑ]', 'Q').replaceAll('[ｑ]', 'q').replaceAll('[Ｒ]', 'R').replaceAll('[ｒ]', 'r').replaceAll('[Ｓ]', 'S').replaceAll('[ｓ]', 's').replaceAll('[Ｔ]', 'T').replaceAll('[ｔ]', 't');
        sReturn = sReturn.replaceAll('[Ｕ]', 'U').replaceAll('[ｕ]', 'u').replaceAll('[Ｖ]', 'V').replaceAll('[ｖ]', 'v').replaceAll('[Ｗ]', 'W').replaceAll('[ｗ]', 'w').replaceAll('[Ｘ]', 'X').replaceAll('[ｘ]', 'x').replaceAll('[Ｙ]', 'Y').replaceAll('[ｙ]', 'y');
        sReturn = sReturn.replaceAll('[Ｚ]', 'Z').replaceAll('[ｚ]', 'z');
        sReturn = sReturn.replaceAll('[０]', '0').replaceAll('[１]', '1').replaceAll('[２]', '2').replaceAll('[３]', '3').replaceAll('[４]', '4').replaceAll('[５]', '5').replaceAll('[６]', '6').replaceAll('[７]', '7').replaceAll('[８]', '8').replaceAll('[９]', '9');

        Return sReturn;
    }

    private String getLabelPicklist(String ReferenceName, String Value) {
        String sReturn = '';

        For(SelectListManage__c listopt : [ SELECT
                                                Label__c
                                            FROM SelectListManage__c
                                            WHERE ReferenceName__c = :ReferenceName
                                            AND Value__c = :Value
                                          ]) {
            sReturn = listopt.Label__c;
        }

        return sReturn;
    }

  

    public PageReference ImportDataFromSalesAccount(){

        List<Account> lsAcc = [SELECT
                                    Id,
                                    Phone,
                                    Fax
                               FROM Account
                               WHERE Id = :so.NewOdrSalesAccount__c
                              ];

        so.NewOdrSalesContactPosition__c = null;
        so.NewOdrSalesContactPost__c = null;
        so.NewOdrSalesTantoshya__c = null;
        so.NewOdrSalesContactTel__c = null;
        so.NewOdrSalesContactFax__c = null;

        for (Account rowAcc : lsAcc) {
            so.NewOdrSalesContactTel__c = rowAcc.phone;
            so.NewOdrSalesContactFax__c = rowAcc.fax;
        }

        return null;
    }

    public PageReference ImportDataFromShipmentAccount(){

        List<Account> lsAcc = [SELECT
                                    Id,
                                    Phone,
                                    Fax
                               FROM Account
                               WHERE Id = :so.NewOdrShipmentAccount__c
                              ];

        so.NewOdrShipmentContactPosition__c = null;
        so.NewOdrShipmentContactPost__c = null;
        so.NewOdrShipmentTantosha__c = null;
        so.NewOdrShipmentContact_Tel__c = null;
        so.NewOdrShipmentContact_Fax__c = null;

        for (Account rowAcc : lsAcc) {
            so.NewOdrShipmentContact_Tel__c = rowAcc.phone;
            so.NewOdrShipmentContact_Fax__c = rowAcc.fax;
        }

        return null;
    }


    public PageReference redirectList(){

        PageReference pr;
        pr = new PageReference('/apex/JEOLAsia_MaintenanceNewList');
        pr.setRedirect(true);
        return pr;

    }

}