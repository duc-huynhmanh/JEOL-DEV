/*
 * Created : 2016/03/02 by Polus (Voxer)
 */
public with sharing class JEOLAsia_ProfitCalculationEditorPageCtrl {
    
    public static final String PARAM_ID = 'id';
    public static final String PARAM_QUOTATION_ID = 'quotid';
    public static final String PARAM_PROFIT_CALCULATION_ID = 'pcid';
    public static final String SCROLL_TOP = 'top';
    
    private static final String APPROVAL_STATUS_PENDING = '1';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED = '2';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 = '21';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 = '22';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR = '23';
    private static final String APPROVAL_STATUS_APPROVED = '3';
    private static final String APPROVAL_STATUS_REJECTED = '4';
    private static final String APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR = '5';
    private static final String APPROVAL_STATUS_APPROVAL_ESCALATED_MD = '51';

    private static final String PRODUCT_ITEM_DIVISION_PARTS = 'パーツ';

    private static final String QUOTATION_RECORDTYPE_UNIT = 'Unit';
    private static final String QUOTATION_RECORDTYPE_SVC = 'SVC';

    private static final String QUOTATION_COMPANY_ASIA = 'ASIA';

    private Boolean isViewAllUser;
    //private static final String QUOTATION_COMPANY_ASIA1 = 'ASIA';
    //private static final String QUOTATION_COMPANY_ASIA2 = 'THAILAND';

    public String quotationRecordtypeLabelUnit{
        get {
            return QUOTATION_RECORDTYPE_UNIT;
        }
        set {
        }

    }

//    public String getQuotationRecordtypeLabelUnit() {return QUOTATION_RECORDTYPE_UNIT;}

    public Boolean isValid{get; set;}
    // DUC added 0: Thailand; 1: ASIA
    public QuotationDetailManage qdm{get; set;}
    public Boolean isNew{get; set;}
    public Boolean isCopy{get; set;}
    public Boolean isBranch{get; set;}
    public String inputDefaultRowsItems{get; set;}
    public String inputDefaultRowsHeading{get; set;}
    public String inputDefaultRowsSubItems{get; set;}
    public Boolean isReadOnly{get; set;}
    public Boolean isQTRestricted{get; set;}
    public Boolean hasDeletePermission{get; set;}
    public Boolean isCopyForbidden{get; set;}
    public double scrollTopValue{get; set;}
    public double currentScrollValue{get; set;}
    public String listRowToDel{get; set;}
    public String language{get; set;}
    public String userCompany{get; set;}
    public String userCompanyCode{get; set;}
    //public Static String quotationCompany{get; set;}
    public Decimal defaultCoef{get; set;}

    public Boolean isApproverSales{get; set;}
    public Boolean isApproverSalesEscalatedDirector{get; set;}
    public Boolean isApproverSalesEscalatedMD{get; set;}
    public Boolean isApproverSVCAssistant1{get; set;}
    public Boolean isApproverSVCAssistant2{get; set;}
    public Boolean isApproverSVCManager{get; set;}
    public Boolean isApproverSVCDirector{get; set;}

    public String RejectCommentInput{get; set;}
    public String EscalateCommentInputDirector{get; set;}
    public String EscalateCommentInputMD{get; set;}

    public Map<String, List<AsiaProfitCalculationRate__c>> rateListJprod{get; set;}
    public Map<String, List<AsiaProfitCalculationRate__c>> rateListOther{get; set;}

    private Map<String, Set<String>> seriesCountryMap;

    private List<SelectOption> modelTypeScreenOpt;
/*
    public List<AsiaProfitCalculationRate__c> rateJprodSGD{get; set;}
    public List<AsiaProfitCalculationRate__c> rateJprodUSD{get; set;}
    public List<AsiaProfitCalculationRate__c> rateOtherSGD{get; set;}
    public List<AsiaProfitCalculationRate__c> rateOtherUSD{get; set;}
    public List<AsiaProfitCalculationRate__c> rateOtherAUD{get; set;}
*/

    public List<SelectOption> targetCostCurrencyOption{get; set;}
    public List<SelectOption> targetSalesCurrencyOption{get; set;}

    public List<SelectOption> listJProdCurrencyOption{get; set;}
    public List<SelectOption> listOtherCurrencyOption{get; set;}

    AsiaProfitCalculation__c o = new AsiaProfitCalculation__c();
    public AsiaProfitCalculation__c getProxyObject() { return o; }
    public String dateQT{get; set;}
    public String listPriceBooks{get; set;}

    private String sCompanyType = '';
    private boolean lastSaveError = false;

    private static String getListPriceBooks(String sCompanyName, Date dDate) {

        String sReturn = '\'DUMMY\'';

        // GET THE AREA CODE FOR THE COMPANY
        String sAreaCode = '';

system.debug('sCompanyName:' + sCompanyName);
        for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
            if (companyCustSettings.Company__c == sCompanyName) {
                sAreaCode = companyCustSettings.AreaCode__c;
            }
        }
system.debug('AreaCode:' + sAreaCode);

        List<PriceBookMatrix__c> lsPBM = [SELECT PriceBookCode__c
                                          FROM PriceBookMatrix__c
                                          WHERE Area__c = :sAreaCode
                                          AND StartDateFormula__c <= :dDate
                                          AND (EndDateFormula__c = NULL OR EndDateFormula__c > :dDate)
                                         ];

        if (lsPBM != NULL && lsPBM.size() > 0) {
            for (PriceBookMatrix__c pbm : lsPBM) {
                sReturn += ', \'' + pbm.PriceBookCode__c + '\'';
system.debug('PriceBookCode:' + pbm.PriceBookCode__c);
            }
        }                                           

        return sReturn;

    }

    public void refreshDateQT() {

        if (qdm.parentRec.IssueDate__c == NULL) {
            dateQT = '';
            listPriceBooks = '';
        } else {
            dateQT = Datetime.newInstance(qdm.parentRec.IssueDate__c.year(), qdm.parentRec.IssueDate__c.month(), qdm.parentRec.IssueDate__c.day()).format('yyyy-MM-dd');
            listPriceBooks = getListPriceBooks(qdm.parentRec.Company__c, qdm.parentRec.IssueDate__c);
        }
    }    

    public boolean getIsSVC() {

        return (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(qdm.parentRec.RecordTypeId).getName() == QUOTATION_RECORDTYPE_SVC);

    }

    public boolean getIsUnit() {

        return (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(qdm.parentRec.RecordTypeId).getName() == QUOTATION_RECORDTYPE_UNIT);

    }

    public boolean getIsAsia() {
        return qdm.parentRec.Company__c == QUOTATION_COMPANY_ASIA;
        //return qdm.parentRec.Company__c == QUOTATION_COMPANY_ASIA1 || qdm.parentRec.Company__c == QUOTATION_COMPANY_ASIA2;
    }

    public String getDetailType() {
        List<CurrencyType> lstCur = [SELECT ToLabel(IsoCode) from CurrencyType where IsoCode = :qdm.parentRec.CurrencyIsoCode];
        if (lstCur != NULL && lstCur.size() > 0 && lstCur[0].IsoCode != NULL && lstCur[0].IsoCode.length() > 6)
        {
            return lstCur[0].IsoCode.substring(6);
        } else {
            return qdm.parentRec.CurrencyIsoCode;
        }
    }    
    Public Void setDetailType(String val) {}


    public String getIsFixedPC() {

        return qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED ||
               qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 || 
               qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 || 
               qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR || 
               qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR || 
               qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_MD || 
               qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVED ? '1' : '0';

    }    


    public List<SelectOption> getReductionOptions(){

        List<selectOption> options = new List<selectOption>();

        for(Schema.PicklistEntry f : AsiaProfitCalculation__c.SubtotalReduction1PlusMinus__c.getDescribe().getPicklistValues()) {
            options.add(new selectOption(f.getLabel(), f.getValue()));
        }

        return options;
    }

    public List<SelectOption> getModelTypeScreenOptions(){

        return modelTypeScreenOpt;

    }

    public boolean getHasMultipleModelTypeScreenOptions(){
        if (modelTypeScreenOpt != NULL) {
            return modelTypeScreenOpt.size() > 1;
        } else {
            return false;
        }
    }

    private void getModelTypeScreenOptionsPrivate(){

        modelTypeScreenOpt = new List<selectOption>();

        // Reinitialize the modeltype for screen
        String sModelType = '';
        if (qdm.getitemsA().size() > 0) {
            sModelType = qdm.getitemsA()[0].rec.ModelType__c;
        } else if (qdm.getitemsB().size() > 0) {
            sModelType = qdm.getitemsB()[0].rec.ModelType__c;
        }
        if (sModelType == NULL) sModelType = '';
        sModelType = sModelType.trim();


        boolean fModelTypeOK = false;
        if (sModelType != NULL && sModelType.length() > 0) {
            List<AsiaProductItemSpecification__c> lsSpecs = Database.query(' SELECT Id, ModelType__c, Product_Img__c ' +
                                                                           ' FROM AsiaProductItemSpecification__c ' +
                                                                           ' WHERE ModelType__c LIKE \'' +  String.escapeSingleQuotes(sModelType) + '%\'');

            for (AsiaProductItemSpecification__c spec : lsSpecs) {
                if (spec.Product_Img__c != NULL && spec.Product_Img__c.length() > 0) {
                    modelTypeScreenOpt.add(new selectOption(spec.ModelType__c, spec.ModelType__c));                    
                    if (modelTypeScreenOpt.size() >= 10) {
                        break;
                    }
                }
            }                
        }

        if (modelTypeScreenOpt.size() == 0) {
            modelTypeScreenOpt.add(new selectOption(sModelType, sModelType));                                
        } else if (modelTypeScreenOpt.size() == 1) {
            qdm.parentRec.ModelTypeScreen__c = modelTypeScreenOpt.get(0).getValue();                     
        }

    }


    private User currentUser = [SELECT CompanyName, AvailableMarket__c FROM User WHERE id = :UserInfo.getUserId()];


    
    public static final String ACCOUNT_BASE_QUERY = ' SELECT id, name, code__c, Address__c, Abbreviation__c FROM Account ';
    public static final String CONTACT_BASE_QUERY = ' SELECT id, Account.name, Account.code__c, Account.Address__c, Account.Abbreviation__c,name, Phone, Title, Affiliation__c FROM contact ';
    public static final String QUOTATION_BASE_QUERY = ' SELECT id, Name,  ProfitCalculationNo__c, BranchNo__c, RecordTypeId, RecordType.Name, ContractName__c, ContractName1__c, ContractName2__c, ShipmentName__c, ShipmentName1__c, ShipmentName2__c, CreatedBy.Name, IssueDate__c, CustomerPurchaseOrder__c FROM AsiaProfitCalculation__c ';
    public static final String QUOTATION_DETAIL_BASE_QUERY = ' SELECT id, Body__c,  ModelType__c, Quantity__c, QuantityUnit__c, UnitPrice__c, Type__c, Category__c FROM AsiaProfitCalculationDetail__c ';
    public static final Integer ASIAPROFITCALC_NO_PREFIX_LENGTH = 2;
    public static final String URL_PARAM_NAME_ISBRANCH = 'isBranch';
    public static final String URL_PARAM_NAME_ISCOPY = 'isCopy';

    private Boolean checkPermissionViewAll(){
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() ];
        for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
            System.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
            if ( psa.PermissionSet.Name.equals('JEOL_Asia_Quotation') ) {
                return true;
            }
        }
        return false;
    }
    
    public JEOLAsia_ProfitCalculationEditorPageCtrl() {
        this.isValid = false;
        Boolean isCopy = false;
        Boolean isBranch = false;
        isReadOnly = false;
        isQTRestricted = false;
        hasDeletePermission = false;
        isCopyForbidden = false;
        AsiaProfitCalculation__c rec = null;
        scrollTopValue = 0;
        currentScrollValue = 0;
        language = '';
        isViewAllUser = checkPermissionViewAll();
        if(isViewAllUser){
            seriesCountryMap = new Map<String, Set<String>>();
            seriesCountryMap.put('ALL', new Set<String>{'ALL'});
        } else {
            seriesCountryMap = getMapSeriesCountry();
        }
        system.debug('seriesCountryMap: ' + seriesCountryMap);
        try {

            current2SPItems = new List<Obj2SPItem>();

            // Get the company type from the CompanyName of the profile of the user using the custom settings CompanyName__c
            userCompany = '';
            userCompanyCode = '';
            String userCompanyAddress = '';
            String userPhone = '';
            String userFax = '';
            String orgName = '';
            
            String sCompanyNameProfile = currentUser.CompanyName;
            for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
                if (companyCustSettings.CompanyName__c == sCompanyNameProfile) {
                    userCompany = companyCustSettings.Company__c;
                    userCompanyCode = companyCustSettings.CompanyLabel__c;
                    userCompanyAddress = companyCustSettings.OrgAddress__c;
                    userPhone = companyCustSettings.OrgPhone__c;
                    userFax = companyCustSettings.OrgFax__c;
                    orgName = companyCustSettings.CompanyName__c;
                    break;
                }
            }
            if (userCompany == '') {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'The Company indicated in the user profile is not in the list of the companies authorized. Please configure the "Company" custom settings adequately.'));
            }

            this.language = UserInfo.getLanguage();
            Map<String, String> params = Apexpages.currentPage().getParameters();

            if (params.containsKey(SCROLL_TOP)) {
                scrollTopValue = double.valueof(params.get(SCROLL_TOP));
            }
            
            if (params.containsKey(PARAM_ID)) {
                String targetId = params.get(PARAM_ID);
System.debug('@@@@PARAMID: ' + targetId);
                rec = getTargetRecord(targetId);

                                
                if (params.containsKey(URL_PARAM_NAME_ISCOPY) && params.get(URL_PARAM_NAME_ISCOPY) == 'true') {
                    isCopy = true;
                    this.isNew = true;
                    if (params.containsKey(URL_PARAM_NAME_ISBRANCH) && params.get(URL_PARAM_NAME_ISBRANCH) == 'true') {
                        isBranch = true;
                    }
                } else {
                    this.isNew = false;
                }
            } else {
                
                rec = createNewRecord();
                rec.IssueDate__c = system.today();

                this.isNew = true;
            }

            if (!this.isNew)
            {
                /*
                // The form is read only for PCS and BaaN record type
                if (rec != null && rec.RecordType.Name != null && (rec.RecordType.Name == 'PCS' || rec.RecordType.Name == 'BaaN'))
                {
                    isReadOnly = true;
                }
                // The copy is forbidden only for PCS record type
                if (rec != null && rec.RecordType.Name != null && rec.RecordType.Name == 'PCS')
                {
                    isCopyForbidden = true;
                }
                */
            } else {
//                rec.RecordTypeId = Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosByName().get('SFDC').getRecordTypeId();
                rec.SubtotalReduction1PlusMinus__c = '-';
                rec.SubtotalReduction2PlusMinus__c = '-';
                rec.SubtotalReduction3PlusMinus__c = '-';
            }
                        
            // Set the tax after getting the company (from new custom settings)
            // if (rec.TaxRate__c == null) {
            //     TaxSetting__c taxSetting = TaxSetting__c.getOrgDefaults();
            //     rec.TaxRate__c = taxSetting.TaxationRate__c;
            //     if (rec.TaxRate__c == null) {
            //         rec.TaxRate__c = 0;
            //     }
            // }

            qdm = new QuotationDetailManage(rec, isCopy, isBranch, isNew); 
            
            //Modification-VAIB-Begin(2015/05/19 UAT_QA_List No.52)
            if(isNew && !isCopy)
            {   
                // Put the checkboxes for the summary checked
                qdm.parentRec.OutputTotalTaxAmount__c = true;
                qdm.parentRec.OutputConsumptionTaxAmount__c = true;
                qdm.parentRec.OutputTotalAmount__c = true;
                qdm.parentRec.OutputSubtitle__c = true;

                
                //if quotation is for ASIA
                if(userCompany == 'ASIA'){
                    //if quotation is for Thailand market thgen update company information
                    if(qdm.parentRec.TargetMarket__c == '1'){
                        CompanyName__c company = CompanyName__c.getValues('ASIA-THAILAND');
                        userCompanyCode = company.CompanyLabel__c;
                        userCompanyAddress = company.OrgAddress__c;
                        userPhone = company.OrgPhone__c;
                        userFax = company.OrgFax__c;
                        orgName = company.CompanyName__c;
                    }
                    //TODO: handle for other countries here
                }
                
                // Set the value of the quotation company
                //quotationCompany = userCompany;
                qdm.parentRec.Company__c = userCompany;
                qdm.parentRec.CompanyName__c = userCompanyCode;
                qdm.parentRec.OrgName__c = orgName;
                qdm.parentRec.OrgAddress__c = userCompanyAddress;
                qdm.parentRec.OrgPhone__c = userPhone;
                qdm.parentRec.OrgFax__c = userFax;

                // Set the current user as the Assistant
                if (getIsAsia()) {
                    qdm.parentRec.SalesAssistantAsia__c = UserInfo.getUserId();
                } else {
                    qdm.parentRec.SalesAssistantUS__c = UserInfo.getUserId();
                }
            }

            if (qdm.parentRec.TaxRate__c == null) {

                for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
                    if (companyCustSettings.Company__c == qdm.parentRec.Company__c) {
                        qdm.parentRec.TaxRate__c = companyCustSettings.TaxationRate__c;
                        break;
                    }
                }

                if (qdm.parentRec.TaxRate__c == null) {
                    qdm.parentRec.TaxRate__c = 0;
                }

            }

            InitializeListRate(isCopy);
            refreshDefaultCoef();

            // Initialize the rate units if null (1st time when creating)
            if (qdm.parentRec.JProdCostCurrency__c == NULL && targetCostCurrencyOption.size() > 0) {
                qdm.parentRec.JProdCostCurrency__c = targetCostCurrencyOption.get(0).getValue();
            }
            if (qdm.parentRec.SalesCurrency__c == NULL && targetSalesCurrencyOption.size() > 0) {
                qdm.parentRec.SalesCurrency__c = targetSalesCurrencyOption.get(0).getValue();
            }
            
            CheckIfApprover();

            //Modification-VAIB-End(2015/05/19 UAT_QA_List No.52)
            this.isCopy = isCopy;
            this.isBranch = isBranch;
            this.isValid = true;
            this.isQTRestricted = qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED ||
                                  qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 || 
                                  qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 || 
                                  qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR || 
                                  qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR || 
                                  qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_MD || 
                                  qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVED;
            this.hasDeletePermission = (qdm.parentRec.SalesPerson__c == UserInfo.getUserId() ||
                                        qdm.parentRec.SalesAssistant__c == UserInfo.getUserId());


            refreshDateQT();

            getModelTypeScreenOptionsPrivate();

        } catch (JEOLException e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
System.debug('@@@:' + e.getStackTraceString());
            return;
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'An unexpected error occurred.'));
            return;
        }
    }

    private void CheckIfApprover() {

        try {

            String sCompany = qdm.parentRec.Company__c;

            isApproverSales = false;
            isApproverSalesEscalatedDirector = false;
            isApproverSalesEscalatedMD = false;
            isApproverSVCAssistant1 = false;
            isApproverSVCAssistant2 = false;
            isApproverSVCManager = false;
            isApproverSVCDirector = false;

            List<GroupMember> lsGM = [SELECT Id, group.id, group.name, group.DeveloperName, UserOrGroupId FROM GroupMember where UserOrGroupId = :UserInfo.getUserId()];
            for (GroupMember gm : lsGM) {
                if (gm.group.DeveloperName == 'AsiaQT_Approv_' + sCompany + '_Sales') {
                    isApproverSales = true;
                } else if (gm.group.DeveloperName == 'AsiaQT_Approv_' + sCompany + '_SalesEscalDirector') {
                    isApproverSalesEscalatedDirector = true;
                } else if (gm.group.DeveloperName == 'AsiaQT_Approv_' + sCompany + '_SalesEscalMD') {
                    isApproverSalesEscalatedMD = true;
                } else if (gm.group.DeveloperName == 'AsiaQT_Approv_' + sCompany + '_SVCAssistant1') {
                    isApproverSVCAssistant1 = true;
                } else if (gm.group.DeveloperName == 'AsiaQT_Approv_' + sCompany + '_SVCAssistant2') {
                    isApproverSVCAssistant2 = true;
                } else if (gm.group.DeveloperName == 'AsiaQT_Approv_' + sCompany + '_SVCMGR') {
                    isApproverSVCManager = true;
                } else if (gm.group.DeveloperName == 'AsiaQT_Approv_' + sCompany + '_SVCDirector') {
                    isApproverSVCDirector = true;
                }
            }

        } catch (Exception ex) {

        }

    }

    public List<SelectOption> getProfitCalculationTypeOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_PROFIT_CALCULATION_TYPE);
    }

    private String convertNullToEmptyString(String item){
        if (item == null) {
            return '';
        }
        return item;
    }


    //create map between series and country based on Sharing Rule table
    private Map<String, Set<String>> getMapSeriesCountry(){
        Map<String, Set<String>> mapResult = new Map<String, Set<String>>();

        List<Sharing_Rule__c> rules = [SELECT Series__c, Series_Group__r.Series__c, Country__c, Country_Group__r.Countries__c FROM Sharing_Rule__c WHERE User__c = :UserInfo.getUserId()];
        if(rules != null && rules.size() > 0){
            for (Sharing_Rule__c rule : rules) {
                String series = String.isBlank(rule.Series_Group__r.Series__c) ? convertNullToEmptyString(rule.Series__c) : (rule.Series_Group__r.Series__c + ',' + convertNullToEmptyString(rule.Series__c));
                String countries = String.isBlank(rule.Country_Group__r.Countries__c) ? convertNullToEmptyString(rule.Country__c) : (rule.Country_Group__r.Countries__c + ',' + convertNullToEmptyString(rule.Country__c));

                List<String> seriesList = series.split(',');
                Set<String> seriesSet = new Set<String>(seriesList);

                List<String> countryList = countries.split(',');
                Set<String> countrySet = new Set<String>(countryList);

                //browse each of series
                for (String se : seriesSet){
                    se = se.trim();
                    if(String.isBlank(se)){
                        continue;
                    }
                    //if map not contain series
                    if(!mapResult.containsKey(se)){
                        //then add set of country
                        mapResult.put(se, countrySet);
                    } else { //if map already contained series
                        Set<String> existingSet = mapResult.get(se);
                        existingSet.addAll(countrySet);
                        //then add set countries into existing set
                        mapResult.put(se, existingSet);
                    }
                }
            }
            
            system.debug('mapResult: ' + mapResult);
        }

        return mapResult;
    }

    public List<SelectOption> getSeriesOptions() {
        List<SelectOption> returnValues = JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);
        Integer index = 0;
        system.debug('returnValues: ' + returnValues);
        if(seriesCountryMap.containsKey('ALL')){
            return returnValues;
        }
        while (index < returnValues.size()){
            if(seriesCountryMap.containsKey(returnValues[index].getValue())){
                index++;
            } else {
                returnValues.remove(index);
            }
        }
        return returnValues;
    }
    public List<SelectOption> getUnitOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_DEPARTMENT);
    }
    public List<SelectOption> getIncotermsOptions() {
        return JEOLUtil.getSelectList(qdm.parentRec.Company__c + '_' + JEOLUtil.REFERENCE_NAME_INCOTERMS);
    }
    public List<SelectOption> getIncotermsDestinationOptions() {
        return JEOLUtil.getSelectList(qdm.parentRec.Company__c + '_' + JEOLUtil.REFERENCE_NAME_INCOTERMS_DESTINATION);
    }
    public List<SelectOption> getDelivConditionOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTATION_DELIVERY_CONDITION);
    }
    public List<SelectOption> getQuantityUnitOptions() {
        return JEOLUtil.getSelectList(false, JEOLUtil.REFERENCE_NAME_QUOTATION_QUANTITY_UNIT, true);
    }
    
    public Pagereference profitCalculationCopy() {
        Pagereference ref = Page.JEOLAsia_ProfitCalculationEditorPage;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_ID, this.qdm.parentRec.id);
        params.put(URL_PARAM_NAME_ISCOPY, 'true');
        return ref;
    }    

    public Pagereference goToCustomerInformation() {

        if (isNew) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'You need to save the quotation once before been able to enter the customer informations.'));
            return null;
        }

        Pagereference ref = Page.JEOLAsia_CustomerInformations;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_PROFIT_CALCULATION_ID, this.qdm.parentRec.id);
        return ref;
    }

    public Pagereference goToEndUserInformation() {

        if (isNew) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'You need to save the quotation once before been able to enter the end user informations.'));
            return null;
        }

        Pagereference ref = Page.JEOLAsia_EndUserInformations;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_PROFIT_CALCULATION_ID, this.qdm.parentRec.id);
        return ref;
    }

    public Pagereference goToTermsAndConditions() {

        if (isNew) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'You need to save the quotation once before been able to enter the Terms & Conditions screen.'));
            return null;
        }

        Pagereference ref = Page.JEOLAsia_QuotationTermsConditionsPage;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_PROFIT_CALCULATION_ID, this.qdm.parentRec.id);
        return ref;
    }

    public Pagereference goToEditSpecifications() {

        if (isNew) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'You need to save the quotation once before been able to enter the Edit Specifications screen.'));
            return null;
        }

        Pagereference ref = Page.JEOLAsia_QuotationSpecificationPage;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_PROFIT_CALCULATION_ID, this.qdm.parentRec.id);
        return ref;
    }

    public Pagereference profitCalculationCopyAndBranch() {
        Pagereference ref = Page.JEOLAsia_ProfitCalculationEditorPage;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_ID, this.qdm.parentRec.id);
        params.put(URL_PARAM_NAME_ISCOPY, 'true');
        params.put(URL_PARAM_NAME_ISBRANCH, 'true');
        return ref;
    }
    
    public List<SelectOption> getCandidateUnitBody() {
        List<SelectOption> options = new List<SelectOption>();
        String conditionValue = this.qdm.parentRec.ShipmentCode__c;
        if (String.isNotBlank(conditionValue)) {
            List<UnitBody__c> unitBodies = [SELECT Id, SerialNo__c, UnitBody__c FROM UnitBody__c WHERE DeliveryAccount__r.code__c =: conditionValue AND DeliveryAccount__c != null LIMIT 1000];
            for (UnitBody__c rec: unitBodies) {
                String model = rec.UnitBody__c;
                String name = rec.SerialNo__c;
                if (model == null) {
                    model = '';
                }
                if (name == null) {
                    name = '';
                }
                
                options.add(new SelectOption(model, name + ':' + model));
            }
        }
        return options;
    }
    
    public void delivConditionAttachment() {
        qdm.parentRec.DeliveryCondition3__c = qdm.parentRec.DeliveryCondition1__c;
        if (qdm.parentRec.DeliveryCondition1__c != NULL && qdm.parentRec.DeliveryCondition1__c.length() > 0 && qdm.parentRec.DeliveryCondition2__c != NULL && qdm.parentRec.DeliveryCondition2__c.length() > 0) {
            qdm.parentRec.DeliveryCondition3__c += ': ';
        }
        if (qdm.parentRec.DeliveryCondition2__c != NULL && qdm.parentRec.DeliveryCondition2__c.length() > 0) {
            qdm.parentRec.DeliveryCondition3__c += qdm.parentRec.DeliveryCondition2__c;
        }
    }

    private SelectListManage__c getSelectListMasterValue(String referenceName, String searchTarget) {
        SelectListManage__c masterData = null;
        if (String.isNotBlank(searchTarget)) {
            List<SelectListManage__c> recs = [
                    SELECT
                        Name, value__c, Label__c
                    FROM
                        SelectListManage__c 
                    WHERE
                        Hidden__c = false AND Disabled__c = false AND ReferenceName__c =: referenceName AND (Value__c =: searchTarget OR Label__c =: searchTarget)
            ];
            for (SelectListManage__c rec: recs) {
                masterData = rec;
            }
        }
        if (masterData == null) {
            masterData = new SelectListManage__c();
        }
        return masterData;
    }
    
    public void ContractAttachmentFromCode() {
        String accountCode = qdm.parentRec.ContractCode__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, Fax, Phone, Country__c, Agency__c FROM Account WHERE Code__c =: accountCode];
        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }
        qdm.parentRec.ContractAccount__c = targetAccount.Id;
//        qdm.parentRec.ContractAccount__r = targetAccount;
        qdm.parentRec.ContractCode__c = targetAccount.Code__c;
        qdm.parentRec.ContractName__c = targetAccount.Name;

        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            qdm.parentRec.ContractName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            qdm.parentRec.ContractName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialName2__c;
        }

        qdm.parentRec.ContractAddress__c = targetAccount.Address__c;
        qdm.parentRec.ContractPostalCode__c = targetAccount.PostalCode__c;
        qdm.parentRec.ContractUndergraduate__c = targetAccount.Undergraduate__c;
        qdm.parentRec.ContractCountry__c = targetAccount.Country__c;
        qdm.parentRec.ContractAgency__c = (targetAccount.Agency__c != null);
        qdm.parentRec.ContractPersonInCharge__c = null;
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;
        qdm.parentRec.ContractEmail__c = null;
        qdm.parentRec.ContractFax__c = targetAccount.Fax;
        qdm.parentRec.ContractPost__c = null;
        qdm.parentRec.ContractBelong__c = null;
system.debug('ContractAttachmentFromCode:' + qdm.parentRec.ContractAccount__c);

    }
    public void ShipmentAttachmentFromCode() {
        String accountCode = qdm.parentRec.ShipmentCode__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, DistanceZone__c, DistanceSection__c, Fax, Phone, Country__c, Agency__c FROM Account WHERE Code__c =: accountCode];
        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }
        qdm.parentRec.ShipmentAccount__c = targetAccount.id;
//        qdm.parentRec.ShipmentAccount__r = targetAccount;
        qdm.parentRec.ShipmentCode__c = targetAccount.Code__c;
        qdm.parentRec.ShipmentName__c = targetAccount.Name;
        
        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialName2__c;
        }
        
        qdm.parentRec.ShipmentAddress__c = targetAccount.Address__c;
        qdm.parentRec.ShipmentPostalCode__c = targetAccount.PostalCode__c;
        qdm.parentRec.ShipmentUndergraduate__c = targetAccount.Undergraduate__c;
        qdm.parentRec.ShipmentCountry__c = targetAccount.Country__c;
        qdm.parentRec.ShipmentAgency__c = (targetAccount.Agency__c != null);
        qdm.parentRec.ShipmentDistanceZone__c = targetAccount.DistanceZone__c;
        qdm.parentRec.ShipmentDistanceSection__c = targetAccount.DistanceSection__c;
        qdm.parentRec.ShipmentPersonInCharge__c = null;
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;
        qdm.parentRec.ShipmentEmail__c = null;
        qdm.parentRec.ShipmentFax__c = targetAccount.Fax;
        qdm.parentRec.ShipmentPost__c = null;
        qdm.parentRec.ShipmentBelong__c = null;
        qdm.parentRec.UnitBody__c = null;
    }
    public void ContractAttachment() {
        String accountId = qdm.parentRec.ContractAccount_dummyField__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, Fax, Phone, Country__c, Agency__c FROM Account WHERE id =: accountId];
        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }
        qdm.parentRec.ContractAccount__c = targetAccount.id;
//        qdm.parentRec.ContractAccount__r = targetAccount;
        qdm.parentRec.ContractCode__c = targetAccount.Code__c;
        qdm.parentRec.ContractName__c = targetAccount.Name;

        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            qdm.parentRec.ContractName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            qdm.parentRec.ContractName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialName2__c;
        }

        qdm.parentRec.ContractAddress__c = targetAccount.Address__c;
        qdm.parentRec.ContractPostalCode__c = targetAccount.PostalCode__c;
        qdm.parentRec.ContractUndergraduate__c = targetAccount.Undergraduate__c;
        qdm.parentRec.ContractCountry__c = targetAccount.Country__c;
        qdm.parentRec.ContractAgency__c = (targetAccount.Agency__c != null);
        qdm.parentRec.ContractPersonInCharge__c = null;
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;
        qdm.parentRec.ContractEmail__c = null;
        qdm.parentRec.ContractFax__c = targetAccount.Fax;
        qdm.parentRec.ContractPost__c = null;
        qdm.parentRec.ContractBelong__c = null;
        qdm.parentRec.ContractAccount_dummyField__c = null;
    }
    public void ShipmentAttachment() {
        String accountId = qdm.parentRec.ShipmentAccount_dummyField__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, DistanceZone__c, DistanceSection__c, Fax, Phone, Country__c, Agency__c FROM Account WHERE id =: accountId];
        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }
        qdm.parentRec.ShipmentAccount__c = targetAccount.id;
//        qdm.parentRec.ShipmentAccount__r = targetAccount;
        qdm.parentRec.ShipmentCode__c = targetAccount.Code__c;
        qdm.parentRec.ShipmentName__c = targetAccount.Name;

        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialName2__c;
        }

        qdm.parentRec.ShipmentAddress__c = targetAccount.Address__c;
        qdm.parentRec.ShipmentPostalCode__c = targetAccount.PostalCode__c;
        qdm.parentRec.ShipmentUndergraduate__c = targetAccount.Undergraduate__c;
        qdm.parentRec.ShipmentCountry__c = targetAccount.Country__c;
        qdm.parentRec.ShipmentAgency__c = (targetAccount.Agency__c != null);
        qdm.parentRec.ShipmentDistanceZone__c = targetAccount.DistanceZone__c;
        qdm.parentRec.ShipmentDistanceSection__c = targetAccount.DistanceSection__c;
        qdm.parentRec.ShipmentPersonInCharge__c = null;
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;
        qdm.parentRec.ShipmentEmail__c = null;
        qdm.parentRec.ShipmentFax__c = targetAccount.Fax;
        qdm.parentRec.ShipmentPost__c = null;
        qdm.parentRec.ShipmentBelong__c = null;
        qdm.parentRec.UnitBody__c = null;
        qdm.parentRec.ShipmentAccount_dummyField__c = null;
    }
    public void contractContactAttachment() {
        String contactId = qdm.parentRec.ContractContact_dummyField__c;
        Contact targetContact = null;
        List<Contact> recs = [SELECT
                                id, Name, Phone, Email, Fax, Title, Affiliation__c, AccountId, Account.Name,
                                Account.Code__c, Account.Address__c,  Account.PostalCode__c, Account.Undergraduate__c, Account.Country__c, Account.Agency__c, 
                                Account.OfficialName1__c, Account.OfficialName2__c, Account.OfficialNameRow1__c, Account.OfficialNameRow2__c
                            FROM Contact
                            WHERE id =: contactId];
        if (recs != null && recs.size() > 0) {
            targetContact = recs.get(0);
        } else {
            targetContact = new Contact();
        }

        if (targetContact.Account != null && qdm.parentRec.ContractAccount__c != targetContact.AccountId) {

            if (qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_MD || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVED) {

                // Do not update the account data if the approval has been requested

            } else {

                qdm.parentRec.ContractAccount__c = targetContact.AccountId;
    //            qdm.parentRec.ContractAccount__r = targetContact.Account;
                qdm.parentRec.ContractCode__c = targetContact.Account.Code__c;
                qdm.parentRec.ContractName__c = targetContact.Account.Name;

                if (targetContact.Account.OfficialNameRow1__c != null && targetContact.Account.OfficialNameRow1__c.length() > 0) {
                    qdm.parentRec.ContractName1__c = targetContact.Account.OfficialNameRow1__c;
                    qdm.parentRec.ContractName2__c = targetContact.Account.OfficialNameRow2__c;
                } else {
                    qdm.parentRec.ContractName1__c = targetContact.Account.OfficialName1__c;
                    qdm.parentRec.ContractName2__c = targetContact.Account.OfficialName2__c;
                }
                
                qdm.parentRec.ContractAddress__c = targetContact.Account.Address__c;
                qdm.parentRec.ContractPostalCode__c = targetContact.Account.PostalCode__c;
                qdm.parentRec.ContractUndergraduate__c = targetContact.Account.Undergraduate__c;
                qdm.parentRec.ContractCountry__c = targetContact.Account.Country__c;
                qdm.parentRec.ContractAgency__c = (targetContact.Account.Agency__c != null);
            }
        }
        qdm.parentRec.ContractPersonInCharge__c = targetContact.Name;
        qdm.parentRec.ContractPhone__c = targetContact.Phone;
        qdm.parentRec.ContractEmail__c = targetContact.Email;
        qdm.parentRec.ContractFax__c = targetContact.Fax;
        qdm.parentRec.ContractPost__c = targetContact.Title;
        qdm.parentRec.ContractBelong__c = targetContact.Affiliation__c;
        qdm.parentRec.ContractContact_dummyField__c = null;
        
    }
    public void shipmentContactAttachment() {
        String contactId = qdm.parentRec.ShipmentContact_dummyField__c;
        Contact targetContact = null;
        List<Contact> recs = [SELECT
                                id, Name, Phone, Email, Fax, Title, Affiliation__c, AccountId, Account.Name,
                                Account.Code__c, Account.Address__c,  Account.PostalCode__c, Account.Undergraduate__c, Account.Country__c, Account.Agency__c,
                                Account.DistanceZone__c, Account.DistanceSection__c, Account.OfficialName1__c,
                                Account.OfficialName2__c, Account.OfficialNameRow1__c, Account.OfficialNameRow2__c
                            FROM Contact
                            WHERE id =: contactId];
        if (recs != null && recs.size() > 0) {
            targetContact = recs.get(0);
        } else {
            targetContact = new Contact();
        }

        if (targetContact.Account != null && qdm.parentRec.ShipmentAccount__c != targetContact.AccountId) {

            if (qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_MD || 
                qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVED) {

                // Do not update the account data if the approval has been requested

            } else {

                qdm.parentRec.ShipmentAccount__c = targetContact.AccountId;
    //            qdm.parentRec.ShipmentAccount__r = targetContact.Account;
                qdm.parentRec.ShipmentCode__c = targetContact.Account.Code__c;
                qdm.parentRec.ShipmentName__c = targetContact.Account.Name;

                if (targetContact.Account.OfficialNameRow1__c != null && targetContact.Account.OfficialNameRow1__c.length() > 0) {
                    qdm.parentRec.ShipmentName1__c = targetContact.Account.OfficialNameRow1__c;
                    qdm.parentRec.ShipmentName2__c = targetContact.Account.OfficialNameRow2__c;
                } else {
                    qdm.parentRec.ShipmentName1__c = targetContact.Account.OfficialName1__c;
                    qdm.parentRec.ShipmentName2__c = targetContact.Account.OfficialName2__c;
                }
        
                qdm.parentRec.ShipmentAddress__c = targetContact.Account.Address__c;
                qdm.parentRec.ShipmentPostalCode__c = targetContact.Account.PostalCode__c;
                qdm.parentRec.ShipmentUndergraduate__c = targetContact.Account.Undergraduate__c;
                qdm.parentRec.ShipmentCountry__c = targetContact.Account.Country__c;
                qdm.parentRec.ShipmentAgency__c = (targetContact.Account.Agency__c != null);
                qdm.parentRec.ShipmentDistanceZone__c = targetContact.Account.DistanceZone__c;
                qdm.parentRec.ShipmentDistanceSection__c = targetContact.Account.DistanceSection__c;
            }
        }
        qdm.parentRec.ShipmentPersonInCharge__c = targetContact.Name;
        qdm.parentRec.ShipmentPhone__c = targetContact.Phone;
        qdm.parentRec.ShipmentEmail__c = targetContact.Email;
        qdm.parentRec.ShipmentFax__c = targetContact.Fax;
        qdm.parentRec.ShipmentPost__c = targetContact.Title;
        qdm.parentRec.ShipmentBelong__c = targetContact.Affiliation__c;
        qdm.parentRec.ShipmentContact_dummyField__c = null;
        qdm.parentRec.UnitBody__c = null;
    }
    public void contractAccountInputCopy() {
        qdm.parentRec.ShipmentAccount__c = qdm.parentRec.ContractAccount__c;
//        qdm.parentRec.ShipmentAccount__r = qdm.parentRec.ContractAccount__r;
        qdm.parentRec.ShipmentCode__c = qdm.parentRec.ContractCode__c;
        qdm.parentRec.ShipmentName__c = qdm.parentRec.ContractName__c;
        qdm.parentRec.ShipmentName1__c = qdm.parentRec.ContractName1__c;
        qdm.parentRec.ShipmentName2__c = qdm.parentRec.ContractName2__c;
        qdm.parentRec.ShipmentAddress__c= qdm.parentRec.ContractAddress__c;
        qdm.parentRec.ShipmentPostalCode__c = qdm.parentRec.ContractPostalCode__c;
        qdm.parentRec.ShipmentUndergraduate__c = qdm.parentRec.ContractUndergraduate__c;
        qdm.parentRec.ShipmentCountry__c = qdm.parentRec.ContractCountry__c;
        qdm.parentRec.ShipmentAgency__c = qdm.parentRec.ContractAgency__c;
        qdm.parentRec.ShipmentBelong__c = qdm.parentRec.ContractBelong__c;
        qdm.parentRec.ShipmentPersonInCharge__c = qdm.parentRec.ContractPersonInCharge__c;
        qdm.parentRec.ShipmentPhone__c = qdm.parentRec.ContractPhone__c;
        qdm.parentRec.ShipmentEmail__c = qdm.parentRec.ContractEmail__c;
        qdm.parentRec.ShipmentFax__c = qdm.parentRec.ContractFax__c;
        qdm.parentRec.ShipmentPost__c = qdm.parentRec.ContractPost__c;
        qdm.parentRec.UnitBody__c = NULL;
        
        if (String.isNotBlank(qdm.parentRec.ShipmentAccount__c)) {
            List<Account> accounts = [SELECT DistanceZone__c, DistanceSection__c FROM Account WHERE id =: qdm.parentRec.ShipmentAccount__c];
            if (accounts != null && accounts.size() > 0) {
                Account targetAccount = accounts.get(0);
                qdm.parentRec.ShipmentDistanceZone__c = targetAccount.DistanceZone__c;
                qdm.parentRec.ShipmentDistanceSection__c = targetAccount.DistanceSection__c;
            }
            
        }
    }

    private AsiaProfitCalculation__c createNewRecord() {
        system.debug('into createNewRecord');
        AsiaProfitCalculation__c newRecord = new AsiaProfitCalculation__c();
        //default market: ASIA
        //Thailand: 1
        //ASIA: 0
        newRecord.TargetMarket__c = '0';
        newRecord.TotalAmount__c = 0;
        newRecord.Subtitle__c = 0;
        newRecord.ConsumptionTaxAmount__c = 0;
        newRecord.TotalTaxAmount__c = 0;
        // Done outside this method
        //TaxSetting__c taxSetting = TaxSetting__c.getOrgDefaults();
        //newRecord.TaxRate__c = taxSetting.TaxationRate__c;
        //if (newRecord.TaxRate__c == null) {
        //    newRecord.TaxRate__c = 0;
        //}
        newRecord.DeliveryPeriod__c = null;
        return newRecord;
    }
    private AsiaProfitCalculation__c getTargetRecord(String targetId) {
        AsiaProfitCalculation__c targetaRecord = null;
        List<AsiaProfitCalculation__c> recs = [
            SELECT
                id, name, RecordTypeId, RecordType.Name, CurrencyIsoCode, LastModifiedDate, CreatedDateFormula__c, SalesPerson__c, SalesPerson__r.Name,  SalesPersonAsia__c, SalesPersonAsia__r.Name, SalesPersonUS__c, SalesPersonUS__r.Name,
                TotalAmount__c, ContractCode__c, ContractAddress__c, ContractBelong__c,
                ContractPersonInCharge__c, ContractPhone__c, ContractEmail__c, ContractFax__c, ContractName__c, ContractName1__c, ContractName2__c, ContractPost__c,
                Series__c, ProfitCalculationNo__c, TargetMarket__c, 
                SalesAssistant__c, SalesAssistantAsia__c, SalesAssistantUS__c, 
                BranchNo__c, ShipmentCode__c, ShipmentAddress__c, ShipmentBelong__c,
                ShipmentPersonInCharge__c, ShipmentPhone__c, ShipmentEmail__c, ShipmentFax__c, ShipmentName__c, ShipmentName1__c, ShipmentName2__c, ShipmentPost__c, IssueDate__c, CustomerPurchaseOrder__c,
                createdById, createdBy.name, OrgName__c, OrgAddress__c, OrgPhone__c, OrgFax__c, Subtitle__c,
                CustomReductionName1__c, CustomReductionAmount1__c, CustomReductionName2__c, OtherText__c,
                CustomReductionAmount2__c, CustomReductionName3__c, CustomReductionAmount3__c, ConsumptionTaxAmount__c,
                TotalTaxAmount__c, TaxRate__c, DeliveryCondition1__c, DeliveryCondition2__c, DeliveryCondition3__c, DeliveryPeriod__c,
                DeliveryDeadline__c, DeliveryDate_Arbitrarily__c, DeliveryDate_ArbitrarilyTitle__c, PaymentConditionSection__c, PaymentConditionTextarea__c,
                UnitBody__c, SupervisorName__c, SupervisorPosition__c,
                SubtitleLabel__c, OutputTotalTaxAmount__c,
                SubtotalReductionName1__c, SubtotalReductionAmount1__c, OutputSubtotalReduction1__c,
                SubtotalReductionName2__c, SubtotalReductionAmount2__c, OutputSubtotalReduction2__c,
                TotalAmountName__c, TotalTaxAmountName__c, Status__c, Approver__c, RejectComment__c, IsRequesterApprover__c, Requester__c, EscalateComment__c,
                OutputConsumptionTaxAmount__c, OutputTotalAmount__c, OutputSubtitle__c,
                ContractAccount__c, ContractAccount_dummyField__c, ContractAccount__r.Name, ShipmentAccount__c, ShipmentAccount_dummyField__c, ShipmentAccount__r.Name, ContractContact_dummyField__c, ShipmentContact_dummyField__c,
                SalesPipeLineLkup__c, ContractAccount__r.Code__c, ShipmentAccount__r.Code__c, 
                ContractPostalCode__c, ContractUndergraduate__c, ContractCountry__c, ContractAgency__c, ShipmentPostalCode__c,
                ShipmentUndergraduate__c, ShipmentCountry__c, ShipmentAgency__c,
                ShipmentDistanceZone__c,
                ShipmentDistanceSection__c, SalesCurrency__c, JProdCostCurrency__c, CompanyName__c, Company__c, SubtotalADiscountType__c, SubtotalADiscount__c, SubtotalADiscountRate__c,
                GrandTotal__c, StandardOfferAmount__c, OfferAmount__c, TotalProfitRate__c, TotalProfitValue__c, PrintQuotationFirstPage__c, Print2SPDetail__c, PrintQuotationSpecificationsPage__c, PrintNotDetailAmounts__c, PrintQuantityUnit__c, PrintUnitPrice__c, PrintNotPhoneSalespeople__c, PrintQuotationBudgetPurpose__c, PrintProformaInvoice__c, PrintJeolTerms__c,
                AsiaProjectMaster__c, SubtotalA__c, SubtotalACostUnit__c, SubtotalASalesUnit__c, SubtotalB__c, SubtotalC__c, SubtotalD__c, SubtotalE__c, SubtotalF__c, QuoteValidityPeriod__c, QuoteValidityPeriodDays__c, QuoteExpirationDate__c, SubtotalReduction1PlusMinus__c, SubtotalReduction2PlusMinus__c, SubtotalReduction3PlusMinus__c,
                TitleRow1__c, TitleRow2__c, TitleRow3__c, TitleRow4__c, TitleRow5__c, ModelTypeScreen__c
            FROM
                AsiaProfitCalculation__c
            WHERE
                Id =: targetId
            AND
                RecordTypeID in :getListRecordTypeID()
        ];
        if (recs != null && recs.size() > 0) {
            targetaRecord = recs.get(0);
            if (targetaRecord.ContractAccount__c != NULL) {
                targetaRecord.ContractCode__c = targetaRecord.ContractAccount__r.Code__c;
                targetaRecord.ContractName__c = targetaRecord.ContractAccount__r.Name;                
            }
            if (targetaRecord.ShipmentAccount__c != NULL) {
                targetaRecord.ShipmentCode__c = targetaRecord.ShipmentAccount__r.Code__c;
                targetaRecord.ShipmentName__c = targetaRecord.ShipmentAccount__r.Name;
            }
        } else {
            throw new JEOLException('An unexpected error occured.');
        }
        return targetaRecord;
    }


    private boolean checkDataForApproval() {

        if (qdm.parentRec.OfferAmount__c == NULL) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'You need to enter the Offer Amount before requesting the approval.'));
            return false;
        }
        if (qdm.parentRec.TotalAmount__c < qdm.parentRec.OfferAmount__c) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING, 'You can not request the approval while the Total Amount is inferior to the Offer Amount.'));
            return false;
        }

        return true;
    }

    public void requestApproval() {

        if (!checkDataForApproval()) {
            return;
        }
        changeStatusApproval(APPROVAL_STATUS_APPROVAL_REQUESTED, NULL, NULL);

    }

    public void requestApprovalSVCAssistant1() {

        if (!checkDataForApproval()) {
            return;
        }
        changeStatusApproval(APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1, NULL, NULL);

    }

    public void requestApprovalSVCAssistant2() {

        if (!checkDataForApproval()) {
            return;
        }
        changeStatusApproval(APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2, NULL, NULL);

    }

    public void requestApprovalSVCDirector() {

        if (!checkDataForApproval()) {
            return;
        }
        changeStatusApproval(APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR, NULL, NULL);

    }

    public void recallApprovalRequest() {
        changeStatusApproval(APPROVAL_STATUS_PENDING, NULL, NULL);
    }

    public void approveRequest() {
        changeStatusApproval(APPROVAL_STATUS_APPROVED, NULL, NULL);
    }

    public void rejectRequest() {
        changeStatusApproval(APPROVAL_STATUS_REJECTED, this.RejectCommentInput, NULL);
    }

    public void escalateRequestDirector() {
        changeStatusApproval(APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR, NULL, this.EscalateCommentInputDirector);
    }

    public void escalateRequestMD() {
        changeStatusApproval(APPROVAL_STATUS_APPROVAL_ESCALATED_MD, NULL, this.EscalateCommentInputMD);
    }

    public void dummyAction() {
system.debug('dummyAction');
    }

    private void changeStatusApproval(String sNewStatus, String sNewRejectComment, String sNewEscalateComment) {

        String sStatusMemo = qdm.parentRec.Status__c;
        id idApproverMemo = qdm.parentRec.Approver__c;
        String sRejectCommentMemo = qdm.parentRec.RejectComment__c;
        boolean fIsRequesterApproverMemo = qdm.parentRec.IsRequesterApprover__c;
        id idRequesterMemo = qdm.parentRec.Requester__c;
        String sEscalateCommentMemo = qdm.parentRec.EscalateComment__c;

        qdm.parentRec.Status__c = sNewStatus;
        qdm.parentRec.Approver__c = (sNewStatus == APPROVAL_STATUS_APPROVED || sNewStatus == APPROVAL_STATUS_REJECTED ? UserInfo.getUserId() : NULL);
        qdm.parentRec.RejectComment__c = sNewRejectComment;       
        if (sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED ||
            sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 ||
            sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 ||
            sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR) {

            if (sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED) {
                qdm.parentRec.IsRequesterApprover__c = getIsUnit() ? isApproverSales : isApproverSVCManager;                
            } else if (sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1) {
                qdm.parentRec.IsRequesterApprover__c = isApproverSVCAssistant1;                
            } else if (sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2) {
                qdm.parentRec.IsRequesterApprover__c = isApproverSVCAssistant2;                
            } else if (sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR) {
                qdm.parentRec.IsRequesterApprover__c = isApproverSVCDirector;                
            }

            qdm.parentRec.Requester__c = UserInfo.getUserId();
            qdm.parentRec.IsApprovalRequestEscalated__c = false;
            qdm.parentRec.EscalateComment__c = NULL;
        }
        if (sNewStatus == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR ||
            sNewStatus == APPROVAL_STATUS_APPROVAL_ESCALATED_MD) {
            qdm.parentRec.IsApprovalRequestEscalated__c = true;     
            qdm.parentRec.EscalateComment__c = sNewEscalateComment;
        }
        if (sNewStatus == APPROVAL_STATUS_PENDING) {
            qdm.parentRec.IsApprovalRequestEscalated__c = false;
            qdm.parentRec.EscalateComment__c = NULL;
        }

        if (sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED || 
            sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 || 
            sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 || 
            sNewStatus == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR) {
            // Reinitialize the 5 rows of QT Title
            qdm.parentRec.TitleRow1__c = '';
            qdm.parentRec.TitleRow2__c = '';
            qdm.parentRec.TitleRow3__c = '';
            qdm.parentRec.TitleRow4__c = '';
            qdm.parentRec.TitleRow5__c = '';

            String sBody = '';
            if (qdm.getitemsA().size() > 0) {
                sBody = qdm.getitemsA()[0].rec.Body__c;
            } else if (qdm.getitemsB().size() > 0) {
                sBody = qdm.getitemsB()[0].rec.Body__c;
            }
            if (sBody == NULL) sBody = '';
            sBody = sBody.trim();

            if (sBody.length() > 0) {                
                if (sBody.length() <= 24) {
                    qdm.parentRec.TitleRow1__c = sBody;
                    sBody = '';
                } else {
                    qdm.parentRec.TitleRow1__c = sBody.substring(0, 24);
                    sBody = sBody.substring(24);

                    if (sBody.substring(0, 1) == ' ') {
                        sBody = sBody.trim();
                    } else if (qdm.parentRec.TitleRow1__c.substring(23) == ' ') {
                        qdm.parentRec.TitleRow1__c = qdm.parentRec.TitleRow1__c.trim();
                    } else {
                        // The word has been cut
                        Integer idx = qdm.parentRec.TitleRow1__c.lastIndexOf(' ');
                        if (idx > 0) {
                            sBody = qdm.parentRec.TitleRow1__c.SubString(idx + 1) + sBody;
                            qdm.parentRec.TitleRow1__c = qdm.parentRec.TitleRow1__c.SubString(0, idx);
                        }
                    }
                }
            }

            if (sBody.length() > 0) {                
                if (sBody.length() <= 24) {
                    qdm.parentRec.TitleRow2__c = sBody;
                    sBody = '';
                } else {
                    qdm.parentRec.TitleRow2__c = sBody.substring(0, 24);
                    sBody = sBody.substring(24);

                    if (sBody.substring(0, 1) == ' ') {
                        sBody = sBody.trim();
                    } else if (qdm.parentRec.TitleRow2__c.substring(23) == ' ') {
                        qdm.parentRec.TitleRow2__c = qdm.parentRec.TitleRow2__c.trim();
                    } else {
                        // The word has been cut
                        Integer idx = qdm.parentRec.TitleRow2__c.lastIndexOf(' ');
                        if (idx > 0) {
                            sBody = qdm.parentRec.TitleRow2__c.SubString(idx + 1) + sBody;
                            qdm.parentRec.TitleRow2__c = qdm.parentRec.TitleRow2__c.SubString(0, idx);
                        }
                    }
                }
            }

            if (sBody.length() > 0) {                
                if (sBody.length() <= 24) {
                    qdm.parentRec.TitleRow3__c = sBody;
                    sBody = '';
                } else {
                    qdm.parentRec.TitleRow3__c = sBody.substring(0, 24);
                    sBody = sBody.substring(24);

                    if (sBody.substring(0, 1) == ' ') {
                        sBody = sBody.trim();
                    } else if (qdm.parentRec.TitleRow3__c.substring(23) == ' ') {
                        qdm.parentRec.TitleRow3__c = qdm.parentRec.TitleRow3__c.trim();
                    } else {
                        // The word has been cut
                        Integer idx = qdm.parentRec.TitleRow3__c.lastIndexOf(' ');
                        if (idx > 0) {
                            sBody = qdm.parentRec.TitleRow3__c.SubString(idx + 1) + sBody;
                            qdm.parentRec.TitleRow3__c = qdm.parentRec.TitleRow3__c.SubString(0, idx);
                        }
                    }
                }
            }

            if (sBody.length() > 0) {                
                if (sBody.length() <= 24) {
                    qdm.parentRec.TitleRow4__c = sBody;
                    sBody = '';
                } else {
                    qdm.parentRec.TitleRow4__c = sBody.substring(0, 24);
                    sBody = sBody.substring(24);

                    if (sBody.substring(0, 1) == ' ') {
                        sBody = sBody.trim();
                    } else if (qdm.parentRec.TitleRow4__c.substring(23) == ' ') {
                        qdm.parentRec.TitleRow4__c = qdm.parentRec.TitleRow4__c.trim();
                    } else {
                        // The word has been cut
                        Integer idx = qdm.parentRec.TitleRow4__c.lastIndexOf(' ');
                        if (idx > 0) {
                            sBody = qdm.parentRec.TitleRow4__c.SubString(idx + 1) + sBody;
                            qdm.parentRec.TitleRow4__c = qdm.parentRec.TitleRow4__c.SubString(0, idx);
                        }
                    }
                }
            }

            if (sBody.length() > 0) {                
                if (sBody.length() <= 24) {
                    qdm.parentRec.TitleRow5__c = sBody;
                    sBody = '';
                } else {
                    qdm.parentRec.TitleRow5__c = sBody.substring(0, 24);
                    sBody = sBody.substring(24);
                }
            }

            // Reinitialize the modeltype for screen
            String sModelType = '';
            if (qdm.getitemsA().size() > 0) {
                sModelType = qdm.getitemsA()[0].rec.ModelType__c;
            } else if (qdm.getitemsB().size() > 0) {
                sModelType = qdm.getitemsB()[0].rec.ModelType__c;
            }
            if (sModelType == NULL) sModelType = '';
            sModelType = sModelType.trim();                

            boolean fModelTypeOK = false;
            if (sModelType != NULL && sModelType.length() > 0 && qdm.parentRec.ModelTypeScreen__c != NULL && qdm.parentRec.ModelTypeScreen__c.length() > 0) {
                List<AsiaProductItemSpecification__c> lsSpecs = Database.query(' SELECT Id, ModelType__c, Product_Img__c ' +
                                                                               ' FROM AsiaProductItemSpecification__c ' +
                                                                               ' WHERE ModelType__c LIKE \'' + String.escapeSingleQuotes(sModelType) + '%\'' +
                                                                               ' AND ModelType__c = \'' + String.escapeSingleQuotes(qdm.parentRec.ModelTypeScreen__c) + '\'');
                for (AsiaProductItemSpecification__c spec : lsSpecs) {
                    if (spec.Product_Img__c != NULL && spec.Product_Img__c.length() > 0) {
                        fModelTypeOK = true;
                    }
                }                
            }

            if (!fModelTypeOK) {
                qdm.parentRec.ModelTypeScreen__c = sModelType;
            }

        }
        
        ajaxSaveAction();

        if (lastSaveError) {
            qdm.parentRec.Status__c = sStatusMemo;            
            qdm.parentRec.Approver__c = idApproverMemo;
            qdm.parentRec.RejectComment__c = sRejectCommentMemo;
            qdm.parentRec.IsRequesterApprover__c = fIsRequesterApproverMemo;
            qdm.parentRec.Requester__c = idRequesterMemo;
            qdm.parentRec.EscalateComment__c = sEscalateCommentMemo;
        }

        this.isQTRestricted = qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED || 
                              qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 || 
                              qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 || 
                              qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR || 
                              qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR || 
                              qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_MD || 
                              qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVED;

        this.hasDeletePermission = (qdm.parentRec.SalesPerson__c == UserInfo.getUserId() ||
                                    qdm.parentRec.SalesAssistant__c == UserInfo.getUserId());

    }



    
    public void ajaxSaveAction() {
        saveAction();
        qdm.baseParentRec = qdm.parentRec.clone(true);
        qdm.baseItemsAll = qdm.itemsAll.clone();
    }
    
    public void deleteMultiRows() {
        if (listRowToDel == null || listRowToDel.length() == 0)
        {
            return;
        }
        List<String> lsRow = listRowToDel.split(',');

        For (QuotationDetailItem det : qdm.itemsAll)
        {
            For (String oneRow : lsRow)
            {
                If (det.idxrow == oneRow)
                {
                    det.isDeleted = true;
                    break;
                }
            }
        }
    }
    
    public Pagereference saveAction() {
    
        lastSaveError = false;
        scrollTopValue = 0;
system.debug('saveAction: Start');
system.debug('1:' + qdm.parentRec.LastModifiedDate);
        Pagereference ref = null;
        Savepoint sp = Database.setSavepoint();

        try {

            qdm.refresh();
            List<String> errorFields = qdm.requireCheck(isReadOnly);
            if (errorFields.size() > 0) {
                String errorText = null;
                for (String field: errorFields) {
                    if (String.isBlank(errorText)) {
                        errorText ='There are some fields not entered. ';
                    } else {
                        errorText += ', ';
                    }
                    errorText += '['+field+']';
                }
                throw new JEOLException(errorText);
            }


            AsiaProfitCalculation__c parentRec = qdm.parentRec;

            // Check if some items are forbidden
            List<String> lsModelType = new List<String>();
            Set<String> setModelTypeForbidden = new Set<String>();

            for (QuotationDetailItem item : qdm.getItemsA()) {
                if (!item.isDeleted && item.rec.ModelType__c != NULL) {
                    lsModelType.add(item.rec.ModelType__c);
system.debug('ModelType:' + item.rec.ModelType__c);                                        
                }
            }
            List<ProductItem__c> lsItems = [SELECT Id, ModelTypeDisplay__c
                                            FROM ProductItem__c
                                            WHERE ModelTypeDisplay__c in :lsModelType
                                            AND IsDisplayedAsiaSignal__c = false];
            for (ProductItem__c itm : lsItems) {
                setModelTypeForbidden.add(itm.ModelTypeDisplay__c);
system.debug('ModelTypeForbidden:' + itm.ModelTypeDisplay__c);                                        
            }

            boolean isForbidden = false;
            for (QuotationDetailItem item : qdm.getItemsA()) {
                if (setModelTypeForbidden.contains(item.rec.ModelType__c)) {
                    isForbidden = true;
                    item.rec.IsForbiddenTarget__c = True;
                } else {
                    item.rec.IsForbiddenTarget__c = False;
                }
            }

            if (isForbidden) {
                throw new JEOLException('This quotation can not be saved because some items selected are not available for sale. Please remove these items and save again.');
            }

            // Check if the Accounts selected are existing
            List<Account> recs = [SELECT id, Code__c FROM Account WHERE Code__c in (:parentRec.ContractCode__c, :parentRec.ShipmentCode__c)];
            boolean fContractAccountOK = false;
            boolean fShipmentAccountOK = false;

            for (Account acc : recs) {
                if (acc.Code__c == parentRec.ContractCode__c && acc.id == parentRec.ContractAccount__c) fContractAccountOK = true;
                if (acc.Code__c == parentRec.ShipmentCode__c && acc.id == parentRec.ShipmentAccount__c) fShipmentAccountOK = true;
            }
            if (!fContractAccountOK && !fShipmentAccountOK) {
                String errorText = 'The selected Sold To account and Ship To account does not correspond to the entered account code. Please refresh the selected account by pushing the button near the account code.';
                throw new JEOLException(errorText);                
            } else if (!fContractAccountOK) {
                String errorText = 'The selected Sold To account does not correspond to the entered account code. Please refresh the selected account by pushing the button near the account code.';
                throw new JEOLException(errorText);
            } else if (!fShipmentAccountOK) {
                String errorText = 'The selected Ship To account does not correspond to the entered account code. Please refresh the selected account by pushing the button near the account code.';
                throw new JEOLException(errorText);
            }


            if ((qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED || 
                 qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 || 
                 qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 || 
                 qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR || 
                 qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR || 
                 qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_MD || 
                 qdm.parentRec.Status__c == APPROVAL_STATUS_APPROVED) && 
                qdm.parentRec.TotalAmount__c < qdm.parentRec.OfferAmount__c) {

                String errorText = 'The Total Amount can not be inferior to the Offer Amount.';
                throw new JEOLException(errorText);
   
            }
           
            
            //Modification-VAIB-Begin(2015/05/25 UAT_QA_List No.64)
            if (parentRec.Id != null)
            {
                AsiaProfitCalculation__c refreshedParentRec = [SELECT Id, Name, LastModifiedDate, LastModifiedBy.Name FROM AsiaProfitCalculation__c WHERE Id=:parentRec.Id];
                if(parentRec.LastModifiedDate != refreshedParentRec.LastModifiedDate)
                    throw new JEOLException('This record has been modified by ' + refreshedParentRec.LastModifiedBy.Name + ' at ' + refreshedParentRec.LastModifiedDate.format() + '. Please reload the data before making again your modifications.');
            }
            //Modification-VAIB-Ends(2015/05/25 UAT_QA_List No.64)

            if (parentRec.Name != null && parentRec.Name.length() > 50) {
                throw new JEOLException(Label.JEOL_Quotation_Message_TitleTooLong);
            }
            if ((qdm.parentRec.ContractName2__c != null) && (JEOLUtil.getSizeInBytes(qdm.parentRec.ContractName2__c) <> qdm.parentRec.ContractName2__c.length()) && (qdm.parentRec.ContractName2__c.length() > 20) ) {
                throw new JEOLException('契約先名称2の文字数が、最大文字数を超えています。全角20文字、半角50文字以内に変更してください。');            
            }
            if ((qdm.parentRec.ShipmentName2__c != null) && (JEOLUtil.getSizeInBytes(qdm.parentRec.ShipmentName2__c) <> qdm.parentRec.ShipmentName2__c.length()) && (qdm.parentRec.ShipmentName2__c.length() > 20) ) {
                throw new JEOLException('納入先名称2の文字数が、最大文字数を超えています。全角20文字、半角50文字以内に変更してください。');            
            }

            // Update SalesPerson / Assistant fields
            if (getIsAsia()) {
                parentRec.SalesPerson__c = parentRec.SalesPersonAsia__c;
                parentRec.SalesAssistant__c = parentRec.SalesAssistantAsia__c;
            } else {
                parentRec.SalesPerson__c = parentRec.SalesPersonUS__c;                
                parentRec.SalesAssistant__c = parentRec.SalesAssistantUS__c;
            }
                        
            NumberingMaster__c numberingRec = null;
            if (String.isBlank(qdm.parentRec.id) && (!this.isCopy || this.isCopy && !this.isBranch)) {
                String prefix = qdm.parentRec.ProfitCalculationNo__c;
                numberingRec = JEOLUtil.getTargetMaster(JEOLUtil.NUMBERING_MASTER_KEY_ASIAQUOTATION_NO, prefix , null);
                if (numberingRec != null) {
                    String targetQuoteNo = JEOLUtil.nextNumberingValue(numberingRec);
                    List<AsiaProfitCalculation__c> parentRecs = [SELECT id FROM AsiaProfitCalculation__c WHERE ProfitCalculationNo__c =: targetQuoteNo];
                    if (parentRecs.size() > 0) {
                        throw new JEOLException('採番に失敗しました。');
                    }
                    qdm.parentRec.ProfitCalculationNo__c = targetQuoteNo;
                    qdm.parentRec.BranchNo__c = '01';
                } else {
                    throw new JEOLException('採番に失敗しました。正しい値を入力してください。');
                }
            } else {
                String branchNo = qdm.parentRec.BranchNo__c;
                if (branchNo != null && branchNo.isNumeric()) {
                    if(branchNo.length() < 2) {
                        qdm.parentRec.BranchNo__c = '0' + branchNo;
                    }
                } else {
                    throw new JEOLException('枝番には数字を指定してください。');
                }
                
            }
            parentRec.ProfitCalculation_BranchNo_Sync__c = qdm.parentRec.ProfitCalculationNo__c + '_' + qdm.parentRec.BranchNo__c;
            //if (parentRec.Name == null) {
                parentRec.Name = parentRec.ProfitCalculation_BranchNo_Sync__c;
            //}
            
            parentRec.ContractContact_dummyField__c = null;
            parentRec.ShipmentContact_dummyField__c = null;

            if (this.isNew && !this.isCopy) {
                id idRecordTypeUnit = Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosByName().get(QUOTATION_RECORDTYPE_UNIT).getRecordTypeId();
                parentRec.PrintQuantityUnit__c = !(parentRec.RecordTypeId == idRecordTypeUnit);
            }

            //check series matches with country
            Set<String> countrySet = new Set<String>();
            if(seriesCountryMap.containsKey('ALL')){
                countrySet.addAll(seriesCountryMap.get('ALL'));
            }
            if(seriesCountryMap.containsKey(parentRec.Series__c)){
                countrySet.addAll(seriesCountryMap.get(parentRec.Series__c));
            }
            if(!countrySet.contains('ALL') && !countrySet.contains(parentRec.ShipmentCountry__c)){
                throw new JEOLException('Please select other company for End User, you can not create Quotation for country ' + parentRec.ShipmentCountry__c);
            }
                        
system.debug('Save: ' + parentRec.ContractAccount__c + ' +++ ' + parentRec);
            upsert parentRec;

            if (numberingRec != null) {
                JEOLUtil.numberingUpdate(numberingRec);
            }

            List<AsiaProfitCalculationDetail__c> details = new List<AsiaProfitCalculationDetail__c>();
            for (QuotationDetailItem item: qdm.itemsAll) {
                AsiaProfitCalculationDetail__c rec = item.rec;
                if (rec.parent__c != parentRec.id) {
                    rec.parent__c = parentRec.id;
                }
                details.add(rec);
            }
    
            List<AsiaProfitCalculationDetail__c> deleteTargets = new List<AsiaProfitCalculationDetail__c>();
            for (QuotationDetailItem item: qdm.baseItemsAll) {
                if (item.isDeleted) {
                    deleteTargets.add(item.rec);
                }
            }

            if (details.size() > 0) {
                upsert details;
            }
            


            // Update the parent ID on 2SP rows
            for (QuotationDetailItem item : qdm.itemsAll) {
                for (QuotationDetailItem2SP item2SP : qdm.items2SPAll) {
                    if (item2SP.rec.ProfitCalculationDetail__c == null && !item2SP.isDeleted && item2SP.IdxRowParent == item.IdxRow) {
                        item2SP.rec.ProfitCalculationDetail__c = item.rec.id;
                    }
                }
            }

            

            List<AsiaProfitCalculationDetail2SP__c> details2SP = new List<AsiaProfitCalculationDetail2SP__c>();
            for (QuotationDetailItem2SP item: qdm.items2SPAll) {
                if (!item.isDeleted) {
                    details2SP.add(item.rec);
                }
            }
    
            List<AsiaProfitCalculationDetail2SP__c> deleteTargets2SP = new List<AsiaProfitCalculationDetail2SP__c>();
            for (QuotationDetailItem2SP item: qdm.items2SPAll) {
                if (item.isDeleted && item.rec.id != null) {
                    deleteTargets2SP.add(item.rec);
                }
            }

            if (details2SP.size() > 0) {
                upsert details2SP;
            }
            if (deleteTargets2SP.size() > 0) {
                delete deleteTargets2SP;
            }
            
            // Delete the parent rows after the child one (orelse errors occured)
            if (deleteTargets.size() > 0) {
                delete deleteTargets;
            }

            //Update the rates
            List<AsiaProfitCalculationRate__c> lsRate = new List<AsiaProfitCalculationRate__c>();

            for (List<AsiaProfitCalculationRate__c> val : rateListJprod.values()) {
                for (AsiaProfitCalculationRate__c rate : val) {
                    if (rate.CurrencyBase__c != null) {
                        lsRate.add(Rate);
                    }
                }
            }

            for (List<AsiaProfitCalculationRate__c> val : rateListOther.values()) {
                for (AsiaProfitCalculationRate__c rate : val) {
                    if (rate.CurrencyBase__c != null) {
                        lsRate.add(Rate);
                    }
                }
            }

            /*for (AsiaProfitCalculationRate__c rate : lsRate) {
                if (rate.Profit_Calculation__c == null) {
                    rate.Profit_Calculation__c = parentRec.id;
                }
            }
            upsert lsRate;*/

            // DUC check whether remove all existing rate records for this quotation
            // all new rate -> need to insert
            if(lsRate != null && lsRate[0].Id == null){
                for (AsiaProfitCalculationRate__c rate : lsRate) {
                    if (rate.Profit_Calculation__c == null) {
                        rate.Profit_Calculation__c = parentRec.id;
                    }
                }
                List<AsiaProfitCalculationRate__c> deleteList = [SELECT Id FROM AsiaProfitCalculationRate__c WHERE Profit_Calculation__c = :parentRec.id];
                delete deleteList;
                insert lsRate;
            } else if (lsRate != null){
                upsert lsRate;
            }

            //Modification-VAIB-Begins(2015/05/29 UAT_QA_List No.64)
            qdm.parentRec = getTargetRecord(parentRec.id);
            //Modification-VAIB-Ends(2015/05/25 UAT_QA_List No.64)

            ref = Page.JEOLAsia_ProfitCalculationEditorPage;
            ref.getParameters().put(PARAM_ID, parentRec.id);
            ref.getParameters().put(SCROLL_TOP, String.valueOf(currentScrollValue));
            
            ref.setRedirect(true);
        } catch(Exception e) {
            String message = e.getMessage();
            if (message == 'SB001' || message == 'SB002') {
                message = '採番に失敗しました。正しい値を入力してください。';
            }
            else if (message == 'SB003') {
                message= JEOLUtil.MSG_NUMBERING_ERROR;
            }
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
system.debug('2:' + qdm.parentRec.LastModifiedDate);
            lastSaveError = true;
            Database.rollback(sp);
system.debug('3:' + qdm.parentRec.LastModifiedDate);
            return null;
        }
        return ref;
    }


    public void doSaveWithPrintDatePart1() {
        ajaxSaveAction();
    }

    public void doSaveWithPrintDatePart2() {
        Pagereference ref = this.getPrintUrl();
        Blob pdfData;
        system.debug('CheckPoint 1');
        if (!Test.IsRunningTest()) {
        system.debug('CheckPoint 2 : ' + this.getPrintUrl());
            pdfData = ref.getContent();
        } else {
        system.debug('CheckPoint 3');
            pdfData = Blob.valueOf('UNIT.TEST');
        }
        system.debug('CheckPoint 4');        
        Attachment attachRec = new Attachment();
        attachRec.parentId = qdm.parentRec.id;
        attachRec.name = qdm.parentRec.name + '.pdf';
        system.debug('CheckPoint 5');
        attachRec.body = pdfData;
        system.debug('CheckPoint 6');
        insert attachRec;
    }

    public Pagereference deleteAction() {
        return JEOLAsia_ProfitCalcEditorPageCtrlNoShare.deleteActionWithoutSharing(qdm.parentRec);
    }

    
    @RemoteAction
    public static List<Object> getProductMaster(Map<String, String> values, String catalogCurrency, String quotCompany, String quotDateQT, String quotListPriceBooks, String quotTypeID) {

system.debug('quotCompany: ' + quotCompany);
system.debug('quotDateQT: ' + quotDateQT);
system.debug('quotListPriceBooks: ' + quotListPriceBooks);

        boolean isUnit = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(quotTypeID).getName() == QUOTATION_RECORDTYPE_UNIT);

        List<String> conditions = new List<String>();
        if (values.containsKey('EnglishName__c') && String.isNotBlank(values.get('EnglishName__c'))) {
            conditions.add(JEOLUtil.appendLikeText('ProductItem__r.EnglishName__c', values.get('EnglishName__c')));
        }
        if (values.containsKey('Name') && String.isNotBlank(values.get('Name'))) {
            conditions.add(JEOLUtil.appendLikeText('ProductItem__r.Name', values.get('Name')));
        }
        if (values.containsKey('Division__c') && String.isNotBlank(values.get('Division__c'))) {
//            conditions.add(JEOLUtil.appendEqualText('Division__c', values.get('Division__c')));
        }        
        if (values.containsKey('ModelType__c') && String.isNotBlank(values.get('ModelType__c'))) {
            conditions.add(JEOLUtil.appendLikeText('ProductItem__r.ModelTypeDisplay__c', values.get('ModelType__c')));
        }
        if (values.containsKey('Supplier__c') && String.isNotBlank(values.get('Supplier__c'))) {
            conditions.add(JEOLUtil.appendLikeText('ProductItem__r.Supplier__c', values.get('Supplier__c')));
        }
        if (values.containsKey('CurrencySearch__c') && String.isNotBlank(values.get('CurrencySearch__c'))) {
//            conditions.add(JEOLUtil.appendEqualText('CostCurrency__c', values.get('CurrencySearch__c')));
        }

        if (String.isNotBlank(quotDateQT)) {
            conditions.add('StartDateFormula__c <= ' + quotDateQT);  
            conditions.add('(EndDateFormula__c = NULL OR EndDateFormula__c > ' + quotDateQT + ')');  
        } else {
            // Should not happen, an error message should be displayed in the page before calling this method
            conditions.add('TechnicalAlways1__c = 0');            
        }

        if (String.isNotBlank(quotListPriceBooks)) {
            conditions.add('PriceBookCode__c in (' + quotListPriceBooks + ')');
        } else {
            conditions.add('TechnicalAlways1__c = 0');            
        }

        conditions.add('PriceBookOrigin__c = \'1\'');

        
        List<ProductItemPrice__c> productMasters;

        if (values.get('sectionItem') == 'A' || values.get('sectionItem') == 'G1') {

            if (!isUnit) {
                conditions.add('ProductItem__r.Division__c = \'' + PRODUCT_ITEM_DIVISION_PARTS + '\'');
            }

            conditions.add('ProductItem__r.IsDisplayedAsia__c = true');
            conditions.add('ProductItem__r.IsDisplayedAsiaSignal__c = true');

            productMasters = Database.query(' SELECT id, ProductItem__r.Name, ProductItem__r.Kikaku__c, ParentModelType__c, ParentEnglishName__c, Price__c, CostCurrency__c, QuantityUnit__c, TechnicalAlways1__c ' +
                                            ' FROM ProductItemPrice__c ' +
                                            JEOLUtil.joinWhereConditions(conditions) +
                                            ' AND (ProductItem__r.ProductItemType__c = NULL OR ProductItem__r.ProductItemType__c = \'1\')' +
                                            ' ORDER BY ParentEnglishName__c ' +
                                            ' LIMIT 10000');

//                                            ' WHERE Company__c = \'' + quotCompany + '\'' +

        } else {            

            conditions.add('ProductItem__r.IsDisplayedLocalSupply__c = true');

            productMasters = Database.query(' SELECT id, ProductItem__r.Name, ProductItem__r.Kikaku__c, ParentModelType__c, ParentEnglishName__c, Price__c, CostCurrency__c, QuantityUnit__c, ProductItem__r.Supplier__c ' +
                                            ' FROM ProductItemPrice__c ' +
                                            JEOLUtil.joinWhereConditions(conditions) +
                                            ' AND ProductItem__r.ProductItemType__c = \'2\'' +
                                            ' ORDER BY ParentEnglishName__c ' +
                                            ' LIMIT 10000');

        }
        return productMasters;
    }



    @RemoteAction
    public static ProductItemPrice__c searchProductItemAsia(String modelType, String itemType, String catalogCurrency, String quotCompany, String quotDateQT, String quotListPriceBooks, String quotTypeID, String series, String country, String agency, String recordTypeID) {

        ProductItemPrice__c ret = null;
        if (String.isNotBlank(modelType)) {

            boolean isUnit = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(quotTypeID).getName() == QUOTATION_RECORDTYPE_UNIT);

            List<ProductItemPrice__c> recs = new List<ProductItemPrice__c>();

            if (String.isNotBlank(quotDateQT) && String.isNotBlank(modelType)) {

                recs = Database.query(' SELECT id, ParentEnglishName__c, Price__c, TechnicalAlways1__c, ProductItem__r.Name, ProductItem__r.Kikaku__c, ParentModelType__c, CostCurrency__c, QuantityUnit__c, ParentIsDisplayedAsiaSignal__c ' +
                                      ' FROM   ProductItemPrice__c ' +
                                      ' WHERE  ProductItem__r.ModelTypeDisplay__c = :modelType' +
                                      ' AND    StartDateFormula__c <= ' + quotDateQT +
                                      ' AND    (EndDateFormula__c = NULL OR EndDateFormula__c > ' + quotDateQT + ')' +
                                      ' AND    PriceBookCode__c in (' + quotListPriceBooks + ')' +
                                      ' AND    PriceBookOrigin__c = \'1\'' +
                                      ' AND    ProductItem__r.IsDisplayedAsia__c = true' +
                                      (isUnit ? '' : ' AND ProductItem__r.Division__c = \'' + PRODUCT_ITEM_DIVISION_PARTS + '\'') +
                                      ' ORDER BY StartDateFormula__c ASC, id ASC' +
                                      ' LIMIT  1');
            }

            if (recs != null && recs.size() > 0) {

                // Check if recordTypeID represents the SVC record type
                boolean isSVC = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(recordTypeID).getName() == QUOTATION_RECORDTYPE_SVC);
                integer isAgency = (agency == 'false' ? 0 : 1);

                for (ProductItemPrice__c rec: recs) {
                    ret = rec;
                    ret.TechnicalAlways1__c = NULL;

                    List<AsiaJProdSalesCoefficient__c> lsCoef;

                    if (ret.Price__c != NULL) {

                        lsCoef = [SELECT ModelType__c, Coefficient__c
                                  FROM   AsiaJProdSalesCoefficient__c
                                  WHERE  IsSVC__c = :isSVC
                                  AND    Agency__c in (NULL, :isAgency)
                                  AND    Area__c = :country
                                  AND    Series__c in (NULL, :series)
                                  AND    (UnitPriceFrom__c = NULL OR UnitPriceFrom__c <= :ret.Price__c)
                                  AND    (UnitPriceTo__c = NULL OR UnitPriceTo__c > :ret.Price__c)
                                  AND    ModelType__c in (NULL, :rec.ParentModelType__c)
                                  ORDER BY ModelType__c ASC NULLS LAST
                                  LIMIT 1
                                 ];

                    } else {

                        lsCoef = [SELECT ModelType__c, Coefficient__c
                                  FROM   AsiaJProdSalesCoefficient__c
                                  WHERE  IsSVC__c = :isSVC
                                  AND    Agency__c in (NULL, :isAgency)
                                  AND    Area__c = :country
                                  AND    Series__c in (NULL, :series)
                                  AND    UnitPriceFrom__c = NULL
                                  AND    UnitPriceTo__c = NULL
                                  AND    ModelType__c in (NULL, :rec.ParentModelType__c)
                                  ORDER BY ModelType__c ASC NULLS LAST
                                  LIMIT 1
                                 ];

                    }

                    for (AsiaJProdSalesCoefficient__c coef : lsCoef) {
                        ret.TechnicalAlways1__c = coef.Coefficient__c;
                    }
                }
            }
        }
        return ret;
    }

    @RemoteAction
    public static List<AsiaProfitCalculation__c> getQuotationInfo(Map<String, String> values) {
        List<String> conditions = new List<String>();
        if (values.containsKey('Name') && String.isNotBlank(values.get('Name'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('name', values.get('Name')));
        }
        if (values.containsKey('ProfitCalculationNo__c') && String.isNotBlank(values.get('ProfitCalculationNo__c'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('ProfitCalculationNo__c', values.get('ProfitCalculationNo__c')));
        }
        if (values.containsKey('BranchNo__c') && String.isNotBlank(values.get('BranchNo__c'))) {
            conditions.add(JEOLUtil.appendEqualText('BranchNo__c', values.get('BranchNo__c')));
        }
        if (values.containsKey('CreatedDateFormula__c') && String.isNotBlank(values.get('CreatedDateFormula__c'))) {
            conditions.add('CreatedDateFormula__c=' + values.get('CreatedDateFormula__c').replace('/', '-'));
        }
        List<AsiaProfitCalculation__c> quoteRecs = Database.query(QUOTATION_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + ' LIMIT 10000');
        return quoteRecs;
    }

    @RemoteAction
    public static List<AsiaProfitCalculationDetail__c> getQuotationDetails(Map<String, String> values) {
        List<AsiaProfitCalculationDetail__c> details  = null;
        List<String> conditions = new List<String>();
        if (values.containsKey('Parent__c') && String.isNotBlank(values.get('Parent__c'))) {
            conditions.add(JEOLUtil.appendEqualText('Parent__c', values.get('Parent__c')));
    
            details = Database.query(QUOTATION_DETAIL_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY SortNo__c LIMIT 10000');
        }
        return details;
    }

    @RemoteAction
    public static List<AsiaProductCatalog__c> getCatalogHead(Map<String, String> values, String quotCompany) {
    
        List<AsiaProductCatalog__c> catalogItems  = null;
        List<String> conditions = new List<String>();
        if (values.containsKey('ClassificationNo__c') && String.isNotBlank(values.get('ClassificationNo__c'))) {
            conditions.add(JEOLUtil.appendLikeText('ClassificationNo__c', values.get('ClassificationNo__c')));
        }
        if (values.containsKey('SearchKeyWord__c') && String.isNotBlank(values.get('SearchKeyWord__c'))) {
            conditions.add(JEOLUtil.appendLikeText('SearchKeyWord__c', values.get('SearchKeyWord__c')));
        }
        if (values.containsKey('ProductCatalog__c') && String.isNotBlank(values.get('ProductCatalog__c'))) {
            conditions.add(JEOLUtil.appendLikeText('ProductCatalog__c', values.get('ProductCatalog__c')));
        }
        conditions.add('Position__c = 1');
        conditions.add('Company__c = \'' + quotCompany + '\'');

        catalogItems = Database.query('SELECT id, SearchKeyWord__c, ProductCatalog__c, AdditionalInformation__c, NumberOfMounting__c, LocalSupplyFlag__c, ProductNo__c, ClassificationType__c, Position__c, CatalogStructure__c, ClassificationNo__c, ProductItem__c, ProductItem__r.Name, ProductItem__r.Kikaku__c, ProductItem__r.EnglishName__c, ProductItem__r.ModelTypeDisplay__c, EnglishText__c FROM AsiaProductCatalog__c' + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY Position__c LIMIT 10000');
        return catalogItems;
    }

    @RemoteAction
    public static List<AsiaProductCatalog__c> getChildCatalogStructure(String ProductCatalog, String Structure, String position, String quotCompany) {
        List<AsiaProductCatalog__c> catalogItems  = null;
        List<String> conditions = new List<String>();
        if (String.isNotBlank(Structure)) {
            conditions.add(JEOLUtil.appendEqualText('ProductCatalog__c', ProductCatalog));
            conditions.add(JEOLUtil.appendEqualText('CatalogStructure__c', Structure));
            conditions.add('Company__c = \'' + quotCompany + '\'');
            catalogItems = Database.query('SELECT id, SearchKeyWord__c, ProductCatalog__c, AdditionalInformation__c, NumberOfMounting__c, LocalSupplyFlag__c, ProductNo__c, ClassificationType__c, Position__c, CatalogStructure__c, ClassificationNo__c, ProductItem__c, ProductItem__r.Name, ProductItem__r.Kikaku__c, ProductItem__r.EnglishName__c, ProductItem__r.ModelTypeDisplay__c, EnglishText__c FROM AsiaProductCatalog__c' + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY Position__c LIMIT 10000');
        }
        return catalogItems;
    }




    @RemoteAction
    public static List<string> getSuggestions(String modelType, String quotTypeID) {

        boolean isUnit = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(quotTypeID).getName() == QUOTATION_RECORDTYPE_UNIT);

        modelType = modelType + '%';
        List<ProductItem__c> recs;
        if (isUnit) {
            recs = [SELECT ModelTypeDisplay__c, EnglishName__c FROM ProductItem__c WHERE ModelTypeDisplay__c like :modelType AND IsDisplayedAsia__c = true AND IsDisplayedAsiaSignal__c = true ORDER By ModelTypeDisplay__c LIMIT 20];
        } else {
            recs = [SELECT ModelTypeDisplay__c, EnglishName__c FROM ProductItem__c WHERE ModelTypeDisplay__c like :modelType AND IsDisplayedAsia__c = true AND IsDisplayedAsiaSignal__c = true AND Division__c = :PRODUCT_ITEM_DIVISION_PARTS ORDER By ModelTypeDisplay__c LIMIT 20];
        }
        List<string> lsReturn = new List<string>();
        for (ProductItem__c rec : recs)
        {
            lsReturn.add(rec.ModelTypeDisplay__c + ',' + rec.EnglishName__c);
        }
        return lsReturn;
    }
    
    public Pagereference getPreviewUrl() {
        Pagereference ret = Page.JEOLAsia_QuotationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('preview', 'true');
        return ret;
    }
    public Pagereference getPrintUrl() {
        Pagereference ret = Page.JEOLAsia_QuotationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('print', 'true');
        return ret;
    }

    public class QuotationDetailManage {

        private List<QuotationDetailItem> itemsAll = new List<QuotationDetailItem>();
        private List<QuotationDetailItem> baseItemsAll = new List<QuotationDetailItem>();
        private List<QuotationDetailItem2SP> items2SPAll = new List<QuotationDetailItem2SP>();
        private List<QuotationDetailItem2SP> baseItems2SPAll = new List<QuotationDetailItem2SP>();
        public AsiaProfitCalculation__c parentRec{get; set;}
        public AsiaProfitCalculation__c baseParentRec{get; set;}
        public String createdItemInfos{get; set;}
        public String currencyForCatalogAdd{get; set;}
        public String dateQuotation{get; set;}
        public String listPriceBooksCode{get; set;}
        public String selectedQuotationId{get; set;}
        public String targetAccountId{get; set;}


        public QuotationDetailManage(AsiaProfitCalculation__c parentRec, Boolean isCopy, Boolean isBranch, Boolean isNew) {
            List<AsiaProfitCalculationDetail__c> recs = this.getDetailRecs(parentRec.id);
            if (recs == null) {
                recs = new List<AsiaProfitCalculationDetail__c>();
            }

            List<AsiaProfitCalculationDetail2SP__c> recs2SP = this.get2SPRecs(parentRec.id);
            if (recs2SP == null) {
                recs2SP = new List<AsiaProfitCalculationDetail2SP__c>();
            }

            List<QuotationDetailItem> localItemsAll = this.itemsAll;
            for (AsiaProfitCalculationDetail__c rec: recs) {
                if (isCopy) {
                    rec.IdTechnical__c = rec.Id;
                    rec = rec.clone(false,true,false,false);
                }
                QuotationDetailItem item = new QuotationDetailItem(rec);
                localItemsAll.add(item);
            }
            List<QuotationDetailItem2SP> localItems2SPAll = this.items2SPAll;
            for (AsiaProfitCalculationDetail2SP__c rec2SP: recs2SP) {
                if (isCopy) {
                    rec2SP.IdTechnical__c = rec2SP.ProfitCalculationDetail__c;
                    rec2SP = rec2SP.clone(false,true,false,false);
                }
                String sIdxRowParent = '';
                for (QuotationDetailItem itm : localItemsAll) {
                    if ((!isCopy && rec2SP.ProfitCalculationDetail__c == itm.rec.id) ||
                        (isCopy && rec2SP.IdTechnical__c == itm.rec.IdTechnical__c)) {
                        sIdxRowParent = itm.IdxRow;
                    }
                }          
                QuotationDetailItem2SP item2SP = new QuotationDetailItem2SP(rec2SP, sIdxRowParent);
                localItems2SPAll.add(item2SP);
            }



            if (isCopy && isBranch) {
                parentRec = parentRec.clone(false,true,false,false);

                parentRec.Status__c = APPROVAL_STATUS_PENDING;            
                parentRec.Approver__c = NULL;
                parentRec.RejectComment__c = NULL;
                parentRec.IsRequesterApprover__c = false;
                parentRec.Requester__c = NULL;
                parentRec.EscalateComment__c = NULL;

                if (parentRec.Name == parentRec.ProfitCalculation_BranchNo_Sync__c) {
                    parentRec.Name = NULL;
                }
                
                AsiaProfitCalculation__c biggestBranchNoRec = [SELECT BranchNo__c FROM AsiaProfitCalculation__c WHERE ProfitCalculationNo__c =: parentRec.ProfitCalculationNo__c ORDER BY BranchNo__c DESC LIMIT 1];
                if (biggestBranchNoRec != null && biggestBranchNoRec.BranchNo__c.isNumeric()) {
                    Integer num = Integer.valueOf(biggestBranchNoRec.BranchNo__c);
                    String branchNo = String.valueOf(++num);
                    if (branchNo.length() < 2) {
                        branchNo = '0' + branchNo;
                    }
                    parentRec.BranchNo__c = branchNo;
                }
            } else if (isCopy) {

                parentRec = parentRec.clone(false,true,false,false);

                parentRec.Status__c = APPROVAL_STATUS_PENDING;            
                parentRec.Approver__c = NULL;
                parentRec.RejectComment__c = NULL;
                parentRec.IsRequesterApprover__c = false;
                parentRec.Requester__c = NULL;
                parentRec.EscalateComment__c = NULL;

                if (parentRec.Name == parentRec.ProfitCalculation_BranchNo_Sync__c) {
                    parentRec.Name = NULL;
                }
                
                if (String.isNotBlank(parentRec.ProfitCalculationNo__c) && parentRec.ProfitCalculationNo__c.length() > ASIAPROFITCALC_NO_PREFIX_LENGTH) {
                    parentRec.ProfitCalculationNo__c = parentRec.ProfitCalculationNo__c.left(ASIAPROFITCALC_NO_PREFIX_LENGTH);
                    parentRec.BranchNo__c = '01';
                }
            } else {
                if (isNew) {
                    parentRec.ProfitCalculationNo__c = 'QT';                    
                }
                this.baseItemsAll = localItemsAll.clone();
            }
            
            this.parentRec = parentRec;

            this.baseParentRec =  this.parentRec.clone(true);

        }
        
        public List<String> requireCheck(boolean isReadOnly) {
            AsiaProfitCalculation__c rec = this.parentRec;
            List<String> checkList = new List<String>();
            
            // Do not make the check for read only mode
            if (isReadOnly) {
                return checkList;            
            }
            if (String.isBlank(rec.RecordTypeID)) {
               checkList.add('Quotation Type');
            }
            if (rec.IssueDate__c == null) {
               checkList.add('Created Date');
            }
            if (rec.DeliveryDeadline__c == null && String.isBlank(rec.DeliveryDate_Arbitrarily__c) && String.isBlank(rec.DeliveryDate_ArbitrarilyTitle__c)) {
                checkList.add('Shipment Date');
            }
            if ((!(rec.QuoteValidityPeriod__c != null && rec.QuoteValidityPeriod__c > 0)) && (!(rec.QuoteValidityPeriodDays__c != null && rec.QuoteValidityPeriodDays__c > 0)) && rec.QuoteExpirationDate__c == null) {
                checkList.add('Period Validity');
            }
            if (String.isBlank(rec.CompanyName__c)) {
                checkList.add('Company');
            }
            if (String.isBlank(rec.Series__c)) {
                checkList.add('Series');
            }
            if (String.isBlank(rec.ContractCode__c)) {
                checkList.add('Sold To Customer Code');
            }
            if (String.isBlank(rec.ShipmentCode__c)) {
                checkList.add('Ship To Customer Code');
            }
            return checkList;
        }
        private List<AsiaProfitCalculationDetail__c> getDetailRecs(String parentId) {
            List<AsiaProfitCalculationDetail__c> recs = [
                    SELECT 
                        id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c,
                        Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode,
                        ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c, IsJProdTarget__c, IsForbiddenTarget__c,
                        IsShowDetailAmount__c, DiscountAmount__c,
                        AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c,
                        CostPrice__c, SalesPrice__c, SalesPriceCalculated__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c, CostPriceJProdUnit__c,
                        Description__c, Remarks__c, Supplier__c, SalesPriceCoefficient__c, CommissionCostPct__c, CostPriceJPY2SP__c, CostPriceSalesCur2SP__c, SalesPriceSalesCur2SP__c, CostPriceJProdUnit2SP__c
                    FROM 
                        AsiaProfitCalculationDetail__c 
                    WHERE 
                        Parent__c =: parentId 
                    ORDER BY
                        SortNo__c, Depth__c Asc
            ];
            return recs;
        }

        private List<AsiaProfitCalculationDetail2SP__c> get2SPRecs(String parentId) {
            List<AsiaProfitCalculationDetail2SP__c> recs = [
                    SELECT 
                        id, name, Description__c, PartNumber__c, ProfitCalculationDetail__c, IsSelected__c, Quantity__c,
                        SalesPrice__c, SalesPriceCalculated__c, SortNo__c, Specification__c, UnitPrice__c, CostPrice__c, CostPriceJPY__c
                    FROM 
                        AsiaProfitCalculationDetail2SP__c 
                    WHERE 
                        ProfitCalculationDetail__r.Parent__c =: parentId 
                    ORDER BY
                        SortNo__c
            ];
            return recs;
        }
        
        public List<QuotationDetailItem> getItemsAll() {
            refresh();
            return this.itemsAll;
        }
        public List<QuotationDetailItem> getBaseItemsAll() {
            return this.baseItemsAll;
        }
        public List<QuotationDetailItem> getItemsAllNotDeleted() {

            List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
            for (QuotationDetailItem item : itemsAll) {
                if (!item.isDeleted) {
                    sReturn.add(item);
                }
            }
            return sReturn;

        }


        private List<QuotationDetailItem> getitemsCategory(String sCategory) {
            refresh();
            List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
            for (QuotationDetailItem item : itemsAll) {
                if (item.rec.Category__c == sCategory && !item.isDeleted) {
                    sReturn.add(item);
                }
            }
            return sReturn;
        }
        private List<QuotationDetailItem> getbaseItemsCategory(String sCategory) {
            List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
            for (QuotationDetailItem item : baseItemsAll) {
                if (item.rec.Category__c == sCategory) {
                    sReturn.add(item);
                }
            }
            return sReturn;
        }
        

        public List<QuotationDetailItem> getItemsA2SP() {

            UpdateHas2SPFlag(itemsAll);

            List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
            for (QuotationDetailItem item : itemsAll) {
                if (item.rec.Category__c == 'A' && item.has2SPParts && !item.isDeleted) {
                    sReturn.add(item);
                }
            }
            return sReturn;
        }


        private void UpdateHas2SPFlag(List<QuotationDetailItem> lsItms) {

                List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
                for (QuotationDetailItem item : lsItms) {

                    item.has2SPParts = false;
//                    item.d2SPCostPriceJPY = 0;
                    item.rec.CostPriceJPY2SP__c = 0;
                    item.d2SPSalesPriceSalesUnit = 0;
                    item.d2SPCostPriceJPYWithoutSales = 0;

                    for (QuotationDetailItem2SP item2SP : items2SPAll) {
                        if (!item2SP.isDeleted && item2SP.IdxRowParent == item.IdxRow) {
                            item.has2SPParts = true;

                            if (item2SP.rec.IsSelected__c) {
                                if (item2SP.rec.CostPriceJPY__c != NULL) {
    //                                item.d2SPCostPriceJPY += item2SP.rec.CostPriceJPY__c;
                                    item.rec.CostPriceJPY2SP__c += item2SP.rec.CostPriceJPY__c;
                                }
                                if (item2SP.rec.SalesPrice__c != NULL) {
                                    item.d2SPSalesPriceSalesUnit += item2SP.rec.SalesPrice__c;
                                } else {
                                    item.d2SPCostPriceJPYWithoutSales += item2SP.rec.CostPriceJPY__c;
                                }                            
                            }
                        }
                    }
                }

        }




        public List<QuotationDetailItem> getBaseItemsA2SP() {
            List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
            for (QuotationDetailItem item : baseItemsAll) {
                if (item.rec.Category__c == 'A' && item.has2SPParts) {
                    sReturn.add(item);
                }
            }
            return sReturn;
        }

        public List<QuotationDetailItem> getItemsA() {
            return getitemsCategory('A');
        }
        public List<QuotationDetailItem> getBaseItemsA() {
            return getbaseItemsCategory('A');
        }
        public List<QuotationDetailItem> getItemsB() {
            return getitemsCategory('B');
        }
        public List<QuotationDetailItem> getBaseItemsB() {
            return getbaseItemsCategory('B');
        }
        public List<QuotationDetailItem> getItemsC() {
            return getitemsCategory('C');
        }
        public List<QuotationDetailItem> getBaseItemsC() {
            return getbaseItemsCategory('C');
        }
        public List<QuotationDetailItem> getItemsD() {
            return getitemsCategory('D');
        }
        public List<QuotationDetailItem> getBaseItemsD() {
            return getbaseItemsCategory('D');
        }
        public List<QuotationDetailItem> getItemsE() {
            return getitemsCategory('E');
        }
        public List<QuotationDetailItem> getBaseItemsE() {
            return getbaseItemsCategory('E');
        }
        public List<QuotationDetailItem> getItemsF() {
            return getitemsCategory('F');
        }
        public List<QuotationDetailItem> getBaseItemsF() {
            return getbaseItemsCategory('F');
        }
        public List<QuotationDetailItem> getItemsG() {
            return getitemsCategory('G');
        }
        public List<QuotationDetailItem> getBaseItemsG() {
            return getbaseItemsCategory('G');
        }
        

        public void createQuotationDetailAx5() {
            for (Integer i = 0; i < 5; i++) {
                createQuotationDetailA();
            }
        }
        public void createQuotationDetailBx5() {
            for (Integer i = 0; i < 5; i++) {
                createQuotationDetailB();
            }
        }
        public void createQuotationDetailCx5() {
            for (Integer i = 0; i < 5; i++) {
                createQuotationDetailC();
            }
        }
        public void createQuotationDetailDx5() {
            for (Integer i = 0; i < 5; i++) {
                createQuotationDetailD();
            }
        }
        public void createQuotationDetailEx5() {
            for (Integer i = 0; i < 5; i++) {
                createQuotationDetailE();
            }
        }
        public void createQuotationDetailFx5() {
            for (Integer i = 0; i < 5; i++) {
                createQuotationDetailF();
            }
        }
        public void createQuotationDetailGx5() {
            for (Integer i = 0; i < 5; i++) {
                createQuotationDetailG();
            }
        }

        public void createQuotationDetailA() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('A');
            detail.Category__c = 'A';
            detail.Type__c = '1';
            detail.CatalogCurrency__c = parentRec.JProdCostCurrency__c;
            detail.CostPriceUnit__c = parentRec.JProdCostCurrency__c;
            detail.IsDiscountTarget__c = true;
            detail.IsForbiddenTarget__c = false;
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailA() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('A');
            detail.Category__c = 'A';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailB() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('B');
            detail.Category__c = 'B';
            detail.Type__c = '1';
            detail.IsDiscountTarget__c = true;
            detail.IsForbiddenTarget__c = false;
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailB() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('B');
            detail.Category__c = 'B';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailC() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('C');
            detail.Category__c = 'C';
            detail.Type__c = '1';
            detail.IsDiscountTarget__c = true;
            detail.IsForbiddenTarget__c = false;
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailC() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('C');
            detail.Category__c = 'C';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailD() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('D');
            detail.Category__c = 'D';
            detail.Type__c = '1';
            detail.IsDiscountTarget__c = true;
            detail.IsForbiddenTarget__c = false;
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailD() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('D');
            detail.Category__c = 'D';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailE() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('E');
            detail.Category__c = 'E';
            detail.Type__c = '1';
            detail.IsDiscountTarget__c = true;
            detail.IsForbiddenTarget__c = false;
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailE() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('E');
            detail.Category__c = 'E';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailF() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('F');
            detail.Category__c = 'F';
            detail.Type__c = '1';
            detail.IsDiscountTarget__c = true;
            detail.IsForbiddenTarget__c = false;
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailF() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('F');
            detail.Category__c = 'F';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailG() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('G');
            detail.Category__c = 'G';
            detail.Type__c = '1';
            detail.IsDiscountTarget__c = true;
            detail.IsForbiddenTarget__c = false;
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailG() {
            AsiaProfitCalculationDetail__c detail = createInitalizedRecord('G');
            detail.Category__c = 'G';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }



        public AsiaProfitCalculationDetail__c createInitalizedRecord(String sCategory) {
            AsiaProfitCalculationDetail__c detail = new AsiaProfitCalculationDetail__c();
            if (sCategory == 'A') {
                detail.SortNo__c = getItemsA().size();
            } else if (sCategory == 'B') {
                detail.SortNo__c = getItemsB().size();
            } else if (sCategory == 'C') {
                detail.SortNo__c = getItemsC().size();
            } else if (sCategory == 'D') {
                detail.SortNo__c = getItemsD().size();
            } else if (sCategory == 'E') {
                detail.SortNo__c = getItemsE().size();
            } else if (sCategory == 'F') {
                detail.SortNo__c = getItemsF().size();
            } else if (sCategory == 'G') {
                detail.SortNo__c = getItemsG().size();
            }

            detail.Depth__c = 0;
            detail.Amount__c = 0;
            detail.Parent__c = this.parentRec.id;
            detail.CurrencyIsoCode = this.parentRec.CurrencyIsoCode;
            detail.Quantity__c = 0;
            detail.Quantity__c = 0;
            detail.QuantityUnit__c = null;
            detail.UnitPrice__c = 0;
            detail.DiscountAmount__c = 0;
            detail.CertificationExpress__c = true;
            return detail;
        }

        public Integer getCurrentSize() {
            return itemsAll.size();
        }
        public Integer getCurrentSizeA() {
            return getitemsA().size();
        }
        public Integer getCurrentSizeA2SP() {
            return getitemsA2SP().size();
        }
        public Integer getCurrentSizeB() {
            return getitemsB().size();
        }
        public Integer getCurrentSizeC() {
            return getitemsC().size();
        }
        public Integer getCurrentSizeD() {
            return getitemsD().size();
        }
        public Integer getCurrentSizeE() {
            return getitemsE().size();
        }
        public Integer getCurrentSizeF() {
            return getitemsF().size();
        }
        public Integer getCurrentSizeG() {
            return getitemsG().size();
        }
        
        public void refreshDetailProductItem() {

            List<String> lsModelType = new List<String>();
            List<String> lsCurrency = new List<String>();

            Map<String, ProductItem__c> mpItem = new Map<String, ProductItem__c>();
            Map<String, ProductItemPrice__c> mpPrice = new Map<String, ProductItemPrice__c>();
            Map<String, AsiaJProdSalesCoefficient__c> mpCoef = new Map<String, AsiaJProdSalesCoefficient__c>();

            boolean isSVC = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(this.parentRec.recordTypeID).getName() == QUOTATION_RECORDTYPE_SVC);
            boolean isUnit = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(this.parentRec.recordTypeID).getName() == QUOTATION_RECORDTYPE_UNIT);
            integer isAgency = (this.parentRec.ContractAgency__c ? 1 : 0);

            for (QuotationDetailItem detail: this.getitemsA()) {
                if (detail.getDetailType() == '1' && !detail.isDeleted && detail.rec.ModelType__c != NULL) {
                    lsModelType.add(detail.rec.ModelType__c);
                    lsCurrency.add(detail.rec.CatalogCurrency__c);                    
                }
            }

            if (lsModelType.size() > 0) {

                List<ProductItemPrice__c> recs = new List<ProductItemPrice__c>();

                if (this.parentRec.IssueDate__c != NULL) {

                    String dateQT = Datetime.newInstance(this.parentRec.IssueDate__c.year(), this.parentRec.IssueDate__c.month(), this.parentRec.IssueDate__c.day()).format('yyyy-MM-dd');
                    String listPriceBooks = getListPriceBooks(this.parentRec.Company__c, this.parentRec.IssueDate__c);

                    recs = Database.query(' SELECT id, ParentEnglishName__c, Price__c, TechnicalAlways1__c, ProductItem__r.Name, ProductItem__r.Kikaku__c, ParentModelType__c, CostCurrency__c, QuantityUnit__c' +
                                          ' FROM   ProductItemPrice__c' +
                                          ' WHERE  ProductItem__r.ModelTypeDisplay__c in :lsModelType' +
                                          ' AND    StartDateFormula__c <= ' + dateQT +
                                          ' AND    (EndDateFormula__c = NULL OR EndDateFormula__c > ' + dateQT + ')' +
                                          ' AND    PriceBookCode__c in (' + listPriceBooks + ')' +
                                          ' AND    PriceBookOrigin__c = \'1\'' +
                                          (isUnit ? '' : ' AND ProductItem__r.Division__c = \'' + PRODUCT_ITEM_DIVISION_PARTS + '\'') + 
                                          ' AND    ProductItem__r.IsDisplayedAsia__c = true' +
                                          ' AND    ProductItem__r.IsDisplayedAsiaSignal__c = true' +
                                          ' ORDER BY StartDateFormula__c desc, id desc');
                }

                if (recs != null && recs.size() > 0) {                
                    for (ProductItemPrice__c rec: recs) {
                        mpPrice.put(rec.ParentModelType__c, rec);
                    }
                }


                List<ProductItem__c> lsProdItems = [SELECT id, ModelTypeDisplay__c, IsDisplayedAsiaSignal__c
                                                    FROM ProductItem__c
                                                    WHERE IsDisplayedAsia__c = true
                                                    AND   ModelTypeDisplay__c in :lsModelType
                                                   ];
                if (lsProdItems != null && lsProdItems.size() > 0) {                
                    for (ProductItem__c prodItem : lsProdItems) {
                        mpItem.put(prodItem.ModelTypeDisplay__c, prodItem);
                    }
                }

            }

            lsModelType.add(NULL);
            List<AsiaJProdSalesCoefficient__c> lsCoefNoModelType = new List<AsiaJProdSalesCoefficient__c>();

            List<AsiaJProdSalesCoefficient__c> lsCoef = [SELECT ModelType__c, Coefficient__c, UnitPriceFrom__c, UnitPriceTo__c
                                                         FROM   AsiaJProdSalesCoefficient__c
                                                         WHERE  IsSVC__c = :isSVC
                                                         AND    Agency__c in (NULL, :isAgency)
                                                         AND    Area__c = :parentRec.ShipmentCountry__c
                                                         AND    Series__c in (NULL, :parentRec.Series__c)
                                                         AND    ModelType__c in :lsModelType
                                                        ];
            for (AsiaJProdSalesCoefficient__c coef : lsCoef) {
                if (coef.ModelType__c != null) {
                    mpCoef.put(coef.ModelType__c, coef);
                } else {
                    lsCoefNoModelType.add(coef);
                }
            }


            for (QuotationDetailItem detail: this.getitemsA()) {
                if (detail.getDetailType() == '1' && !detail.isDeleted) {
                    if (detail.rec.ModelType__c != NULL) {

                        if (mpItem.containsKey(detail.rec.ModelType__c) && !mpItem.get(detail.rec.ModelType__c).IsDisplayedAsiaSignal__c) {
                            detail.rec.IsForbiddenTarget__c = True;
                        } else {
                            detail.rec.IsForbiddenTarget__c = False;
                            if (mpPrice.containsKey(detail.rec.ModelType__c)) {
                                detail.rec.Body__c = mpPrice.get(detail.rec.ModelType__c).ParentEnglishName__c;
                                detail.rec.UnitPrice__c = mpPrice.get(detail.rec.ModelType__c).Price__c;
                                detail.rec.CatalogCurrency__c = mpPrice.get(detail.rec.ModelType__c).CostCurrency__c;
                                detail.rec.QuantityUnit__c = mpPrice.get(detail.rec.ModelType__c).QuantityUnit__c;

                                if (mpCoef.containsKey(detail.rec.ModelType__c)) {
                                    detail.rec.SalesPriceCoefficient__c = mpCoef.get(detail.rec.ModelType__c).Coefficient__c;
                                } else {
                                    detail.rec.SalesPriceCoefficient__c = NULL;

                                    // Get the value for the UnitPrice
                                    for (AsiaJProdSalesCoefficient__c coef : lsCoefNoModelType) {
                                        if ( (coef.UnitPriceFrom__c == null || (detail.rec.UnitPrice__c != NULL && detail.rec.UnitPrice__c >= coef.UnitPriceFrom__c)) && 
                                             (coef.UnitPriceTo__c == null || (detail.rec.UnitPrice__c != NULL && detail.rec.UnitPrice__c < coef.UnitPriceTo__c)) ) {
                                            detail.rec.SalesPriceCoefficient__c = coef.Coefficient__c;
                                            break;
                                        }
                                    } 
                                }                            
                            } else{
                                detail.rec.SalesPriceCoefficient__c = NULL;
                            }                               
                        }
        
                    } else {
                        detail.rec.SalesPriceCoefficient__c = NULL;                        
                    }
                }
            }
        }


        public void importDetailFromQuotation() {
            String targetId = this.selectedQuotationId;

            List<AsiaProfitCalculationDetail__c> targetRecs = this.getDetailRecs(targetId);
            Integer sortNoA = this.getitemsA().size();
            Integer sortNoB = this.getitemsB().size();
            Integer sortNoC = this.getitemsC().size();
            Integer sortNoD = this.getitemsD().size();
            Integer sortNoE = this.getitemsE().size();
            Integer sortNoF = this.getitemsF().size();
            Integer sortNoG = this.getitemsG().size();
            for (AsiaProfitCalculationDetail__c rec:targetRecs) {
                rec = rec.clone(false, true, false, false);
                if (rec.Category__c == 'A') {
                    rec.sortNo__c = sortNoA;
                    sortNoA++;
                } else if (rec.Category__c == 'B') {
                    rec.sortNo__c = sortNoB;
                    sortNoB++;
                } else if (rec.Category__c == 'C') {
                    rec.sortNo__c = sortNoC;
                    sortNoC++;
                } else if (rec.Category__c == 'D') {
                    rec.sortNo__c = sortNoD;
                    sortNoD++;
                } else if (rec.Category__c == 'E') {
                    rec.sortNo__c = sortNoE;
                    sortNoE++;
                } else if (rec.Category__c == 'F') {
                    rec.sortNo__c = sortNoF;
                    sortNoF++;
                } else if (rec.Category__c == 'G') {
                    rec.sortNo__c = sortNoG;
                    sortNoG++;
                }
                QuotationDetailItem item = new QuotationDetailItem(rec);
                this.itemsAll.add(item);
            }
            this.selectedQuotationId = null;
        }



        public void createSelectedProductItemDetails() { //todobp delete
            createSelectedProductItemDetailsCat('A');
        }
        public void createSelectedProductItemDetailsA() {
            createSelectedProductItemDetailsCat('A');
        }
        public void createSelectedProductItemDetailsB() {
            currencyForCatalogAdd = '';
            createSelectedProductItemDetailsCat('B');
        }
        public void createSelectedProductItemDetailsC() {
            currencyForCatalogAdd = '';
            createSelectedProductItemDetailsCat('C');
        }
        public void createSelectedProductItemDetailsD() {
            currencyForCatalogAdd = '';
            createSelectedProductItemDetailsCat('D');
        }
        public void createSelectedProductItemDetailsE() {
            currencyForCatalogAdd = '';
            createSelectedProductItemDetailsCat('E');
        }
        public void createSelectedProductItemDetailsF() {
            currencyForCatalogAdd = '';
            createSelectedProductItemDetailsCat('F');
        }
        public void createSelectedProductItemDetailsG() {
            createSelectedProductItemDetailsCat('G');
        }



        private void createSelectedProductItemDetailsCat(String sCategory) {            
            Map<String, Object> infoData = (Map<String, Object>)JSON.deserializeUntyped(this.createdItemInfos);
system.debug(this.createdItemInfos);
            this.createdItemInfos = null;
            String targetSortNo = (String)infoData.get('sortNo');
            String targetJProd = (String)infoData.get('JProd');
            List<Object> selectedItems = (List<Object>)infoData.get('items');
            
            Integer sortNo = null;
            if (targetSortNo.isNumeric()) {
                sortNo = Integer.valueOf(targetSortNo);
            }
            Map<String, String> transformValues = new Map<String, String>();
            List<SelectListManage__c> mangesRecs = JEOLUtil.getSelectListRecs(JEOLUtil.REFERENCE_NAME_QUOTATION_QUANTITY_UNIT);
            for (SelectListManage__c manageRec: mangesRecs) {
                if (String.isNotBlank(manageRec.value__c)) {
                    transformValues.put(manageRec.value__c, manageRec.label__c);
                }
            }

            // Get the list of the ModelTypes and get the sales coefficient corresponding
            List<String> lsModelType = new List<String>();
            List<id> lsProdItem = new List<id>();

            Map<String, Double> mpSalesPriceCoefficients = new Map<String, Double>();
            Map<id, ProductItemPrice__c> mpPriceItem = new Map<id, ProductItemPrice__c>();
            List<AsiaJProdSalesCoefficient__c> lsCoefNoModelType = new List<AsiaJProdSalesCoefficient__c>();

            boolean isSVC = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(parentRec.recordTypeID).getName() == QUOTATION_RECORDTYPE_SVC);
            boolean isUnit = (Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().get(parentRec.recordTypeID).getName() == QUOTATION_RECORDTYPE_UNIT);
            integer isAgency = (parentRec.ContractAgency__c ? 1 : 0);

            if (sCategory.equals('A') || sCategory.equals('G')) {

                Integer detailSize = selectedItems.size();
                for (Integer i = 0; i < detailSize; i++) {
                     Map<String, Object> item = (Map<String, Object>)selectedItems[i];
                    if (item.containsKey('ParentModelType__c')) {
                        lsModelType.add((String)item.get('ParentModelType__c'));
                    }
                    if (item.containsKey('ProductItem__c')) {
                        lsProdItem.add((id)item.get('ProductItem__c'));
                    }
                }

                List<ProductItemPrice__c> lsPrice;

                lsPrice = Database.query(' SELECT ProductItem__c, Price__c, QuantityUnit__c, CostCurrency__c' +
                                         ' FROM ProductItemPrice__c' +
                                         ' WHERE ProductItem__c in :lsProdItem' +
                                         ' AND StartDateFormula__c <= ' + (dateQuotation != null && dateQuotation.length() > 0 ? dateQuotation : '1970-01-01') +
                                         ' AND (EndDateFormula__c = NULL OR EndDateFormula__c > ' + (dateQuotation != null && dateQuotation.length() > 0 ? dateQuotation : '1970-01-01') + ')' +
                                         ' AND PriceBookCode__c in (' + (listPriceBooksCode != null && listPriceBooksCode.length() > 0 ? listPriceBooksCode : '\'DUMMY\'') + ')' +
                                         ' AND PriceBookOrigin__c = \'1\'' +
                                         (isUnit ? '' : ' AND ProductItem__r.Division__c = \'' + PRODUCT_ITEM_DIVISION_PARTS + '\'') + 
                                         ' ORDER BY StartDateFormula__c desc, id desc');
                for (ProductItemPrice__c prc : lsPrice) {
                    mpPriceItem.put(prc.ProductItem__c, prc);
                }



                lsModelType.add(NULL);
                List<AsiaJProdSalesCoefficient__c> lsCoef = [SELECT ModelType__c, Coefficient__c, UnitPriceFrom__c, UnitPriceTo__c
                                                             FROM   AsiaJProdSalesCoefficient__c
                                                             WHERE  IsSVC__c = :isSVC
                                                             AND    Agency__c in (NULL, :isAgency)
                                                             AND    Area__c = :parentRec.ShipmentCountry__c
                                                             AND    Series__c in (NULL, :parentRec.Series__c)
                                                             AND    ModelType__c in :lsModelType
                                                            ];
                for (AsiaJProdSalesCoefficient__c coef : lsCoef) {
                    if (coef.ModelType__c != null) {
                        mpSalesPriceCoefficients.put(coef.ModelType__c, coef.Coefficient__c);
                    } else {
                        lsCoefNoModelType.add(coef);
                    }
                }

            }

            Integer addNo = 0;
            if (sortNo != null) {

                // Get the max SortNo for items of category B
                Decimal iMaxSortNoCatB = -1;
                Integer iNbCatBInserted = 0;
                for (QuotationDetailItem detail: this.getItemsB()) {
                    if (!detail.isDeleted && detail.rec.sortNo__c > iMaxSortNoCatB) {
                        iMaxSortNoCatB = detail.rec.sortNo__c;
                    }
                }

//                List<QuotationDetailItem> details = this.itemsAll;
                List<QuotationDetailItem> newDetails = new List<QuotationDetailItem>();
                for (QuotationDetailItem detail: this.itemsAll.clone()) {
                    if (detail.rec.Category__c == sCategory && detail.rec.sortNo__c == sortNo && !detail.isDeleted) {
                        Integer detailSize = selectedItems.size();
                        List<QuotationDetailItem> targetDetails = new QuotationDetailItem[detailSize];
                        targetDetails[0] = detail;


                        for (Integer i = 0; i < detailSize; i++) {

                            QuotationDetailItem targetDetail = targetDetails[i];
                            Map<String, Object> item = (Map<String, Object>)selectedItems[i];
                            boolean fIsLocalSupplyFromCatalog = false;

                            if (item.containsKey('LocalSupplyFlag__c') && ((String)item.get('LocalSupplyFlag__c')).toUpperCase() == 'TRUE') {
                                fIsLocalSupplyFromCatalog = true;
                            }

                            if (fIsLocalSupplyFromCatalog && sCategory == 'A') {
                                iNbCatBInserted++;

                                AsiaProfitCalculationDetail__c rec = createInitalizedRecord('B');

                                rec.sortNo__c = iMaxSortNoCatB + 1;
                                iMaxSortNoCatB++;
                                rec.depth__c = 0;
                                rec.Type__c = '1';
                                rec.Category__c = 'B';
                                rec.IsDiscountTarget__c = true;
                                rec.IsForbiddenTarget__c = false;
                                rec.IsTaxationTarget__c = true;
                                rec.IsShowDetailAmount__c = true;
                                targetDetail = new QuotationDetailItem(rec);
                                targetDetails[i] = targetDetail;                                

                            } else if (targetDetail == null) {
                                AsiaProfitCalculationDetail__c rec = createInitalizedRecord(sCategory);
                                Integer addDepth = 0;
                                if (item.containsKey('depth')) {
                                    addDepth = (Integer)item.get('depth');
                                }
                                rec.sortNo__c = detail.rec.sortNo__c + i - iNbCatBInserted;
                                rec.depth__c = detail.rec.depth__c + addDepth;
                                if (rec.depth__c > 5) {
                                    rec.depth__c = 5;
                                }
                                rec.Type__c = '1';
                                rec.Category__c = sCategory;
                                rec.IsDiscountTarget__c = true;
                                rec.IsForbiddenTarget__c = false;
                                rec.IsTaxationTarget__c = true;
                                rec.IsShowDetailAmount__c = true;
                                targetDetail = new QuotationDetailItem(rec);
                                targetDetails[i] = targetDetail;
                            }

                            targetDetail.rec.IsJProdTarget__c = (sCategory == 'G' && targetJProd == '1') ||
                                                                (sCategory == 'G' && targetJProd == NULL && !fIsLocalSupplyFromCatalog);

                            if (item.containsKey('ParentEnglishName__c')) {
                                targetDetail.rec.Body__c = (String)item.get('ParentEnglishName__c');
                            }
                            
                            if (item.containsKey('ProductItem__r.Supplier__c')) {
                                targetDetail.rec.Supplier__c = (String)item.get('ProductItem__r.Supplier__c');
                            }

                            if (this.currencyForCatalogAdd != null && this.currencyForCatalogAdd.length() > 0) {

                                if (item.containsKey('ProductItem__c') 
                                        && mpPriceItem != null
                                        && mpPriceItem.containsKey((id)item.get('ProductItem__c'))) {
                                    if (!fIsLocalSupplyFromCatalog) {
                                        targetDetail.rec.UnitPrice__c = mpPriceItem.get((id)item.get('ProductItem__c')).Price__c;
                                    }
                                    targetDetail.rec.QuantityUnit__c = mpPriceItem.get((id)item.get('ProductItem__c')).QuantityUnit__c;
                                    targetDetail.rec.CatalogCurrency__c = mpPriceItem.get((id)item.get('ProductItem__c')).CostCurrency__c;

                                } else {
                                    targetDetail.rec.UnitPrice__c = 0 ;                                    
                                }

                            } else {

                                if (item.containsKey('CostCurrency__c')) {
                                    targetDetail.rec.CatalogCurrency__c = (String)item.get('CostCurrency__c');
                                }                                                            
                                if (item.containsKey('QuantityUnit__c')) {
                                    targetDetail.rec.QuantityUnit__c = (String)item.get('QuantityUnit__c');
                                }                                                            

                                if (item.containsKey('Price__c')) {
                                    String priceText = (String)item.get('Price__c');
                                    Decimal price = 0;
                                    try {
                                        price = Decimal.valueOf(priceText);
                                    } catch (TypeException e) {
                                        price = 0;
                                    }
                                    targetDetail.rec.UnitPrice__c = price ;
                                }

                            }

                            targetDetail.rec.SalesPriceCoefficient__c = null;
                            if (item.containsKey('ParentModelType__c')) {
                                if (sCategory == 'A' && !fIsLocalSupplyFromCatalog) {
                                    targetDetail.rec.ModelType__c = (String)item.get('ParentModelType__c');
                                    if (mpSalesPriceCoefficients.containsKey(targetDetail.rec.ModelType__c)) {
                                        targetDetail.rec.SalesPriceCoefficient__c = mpSalesPriceCoefficients.get(targetDetail.rec.ModelType__c);                                    
                                    } else {

                                        // Get the value for the UnitPrice
                                        for (AsiaJProdSalesCoefficient__c coef : lsCoefNoModelType) {
                                            if ( (coef.UnitPriceFrom__c == null || (targetDetail.rec.UnitPrice__c != NULL && targetDetail.rec.UnitPrice__c >= coef.UnitPriceFrom__c)) && 
                                                 (coef.UnitPriceTo__c == null || (targetDetail.rec.UnitPrice__c != NULL && targetDetail.rec.UnitPrice__c < coef.UnitPriceTo__c)) ) {
                                                targetDetail.rec.SalesPriceCoefficient__c = coef.Coefficient__c;
                                                break;
                                            }
                                        } 
                                    }
                                } else {
                                    if (sCategory == 'G') {
                                        targetDetail.rec.ModelType__c = (String)item.get('ParentModelType__c');
                                    } else {
                                        targetDetail.rec.Description__c = (String)item.get('ParentModelType__c');                                    
                                    }
                                }
                            }

                            if (item.containsKey('NumberOfMounting__c')) {
system.debug('NumberOfMounting__c exists');                                
                                try {
system.debug('NumberOfMounting__c value:' + (String)item.get('NumberOfMounting__c'));                                
                                    targetDetail.rec.Quantity__c = Decimal.ValueOf((String)item.get('NumberOfMounting__c'));
                                } catch (Exception e) {                                    
                                }
                            }

                            if (targetDetail.rec.Quantity__c == null || targetDetail.rec.Quantity__c == 0) {
                                targetDetail.rec.Quantity__c = 1;
                            }

                        }

                        newDetails.addAll(targetDetails);
                        addNo = detailSize - iNbCatBInserted;
system.debug('AddNo:' + addNo);
                    } else if (detail.rec.Category__c == sCategory && !detail.isDeleted) {
                        detail.rec.sortNo__c += addNo;
                        newDetails.add(detail);
                    } else  {
                        newDetails.add(detail);
                    }
                }
                this.itemsAll = newDetails;
            }
        }
        
        public void refresh() {
            List<QuotationDetailItem> localItems = this.itemsAll;
            List<QuotationDetailItem> newItems = new List<QuotationDetailItem>();

            localItems.sort();
            Decimal beforeDepth = 0;
            Integer cntA = 0;
            Integer cntB = 0;
            Integer cntC = 0;
            Integer cntD = 0;
            Integer cntE = 0;
            Integer cntF = 0;
            Integer cntG = 0;

            for (QuotationDetailItem item: localItems) {
                if (!item.isDeleted) {
                    integer cnt = 0;
                    if (item.rec.Category__c == 'A') {
                        cnt = cntA;
                    } else if (item.rec.Category__c == 'B') {
                        cnt = cntB;
                    } else if (item.rec.Category__c == 'C') {
                        cnt = cntC;
                    } else if (item.rec.Category__c == 'D') {
                        cnt = cntD;
                    } else if (item.rec.Category__c == 'E') {
                        cnt = cntE;
                    } else if (item.rec.Category__c == 'F') {
                        cnt = cntF;
                    } else if (item.rec.Category__c == 'G') {
                        cnt = cntG;
                    }

                    item.rec.CurrencyIsoCode = this.parentRec.CurrencyIsoCode;
                    item.rec.SortNo__c = cnt;
                    if (cnt == 0) {
                        item.rec.Depth__c = 0;
                    } else {
                        if (item.rec.Depth__c - beforeDepth > 1) {
                            item.rec.Depth__c = beforeDepth + 1;
                        }
                    }
                    beforeDepth = item.rec.Depth__c;
                    newItems.add(item);

                    if (item.isCopy) {
                        AsiaProfitCalculationDetail__c detailRec = item.detailCopy();
                        QuotationDetailItem copiedItem = new QuotationDetailItem(detailRec);
                        newItems.add(copiedItem);
                        detailRec.SortNo__c = cnt;
                        cnt++;
                    }
                    cnt++;
                    if (item.rec.Category__c == 'A') {
                        cntA = cnt;
                    } else if (item.rec.Category__c == 'B') {
                        cntB = cnt;
                    } else if (item.rec.Category__c == 'C') {
                        cntC = cnt;
                    } else if (item.rec.Category__c == 'D') {
                        cntD = cnt;
                    } else if (item.rec.Category__c == 'E') {
                        cntE = cnt;
                    } else if (item.rec.Category__c == 'F') {
                        cntF = cnt;
                    } else if (item.rec.Category__c == 'G') {
                        cntG = cnt;
                    }

                }
            }

            this.itemsAll = newItems;
        }

    }


    public class QuotationDetailItem implements Comparable {
        public AsiaProfitCalculationDetail__c rec {get; set;}
        public Boolean isDeleted{get; set;}
        public Boolean isCopy{get; set;}
        public string IdxRow{get; set;}
        public Boolean has2SPParts{get; set;}
//        public Decimal d2SPCostPriceJPY{get; set;} // Sum of cost price in JPY
        public Decimal d2SPSalesPriceSalesUnit{get; set;} // Sum of Sales price set by the user
        public Decimal d2SPCostPriceJPYWithoutSales{get; set;} // Sum of cost price in JPY where no Salesprice has been set (should be calculated on live)

        public QuotationDetailItem (AsiaProfitCalculationDetail__c target){
            this.rec = target;
            this.isDeleted = false;
            this.isCopy = false;
            this.has2SPParts = false;
//            this.d2SPCostPriceJPY = 0;
            this.d2SPSalesPriceSalesUnit = 0;
            this.d2SPCostPriceJPYWithoutSales = 0;
            
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.ConvertTohex(b);
            this.IdxRow = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        }

        public void executeAmountCalc() {
            if (this.rec.UnitPrice__c == null) {
                this.rec.UnitPrice__c = 0;
            }
            if (this.rec.Quantity__c == null) {
                this.rec.Quantity__c = 0;
            }
            
            if((this.rec.Quantity__c == 0) && (this.rec.UnitPrice__c <0)) {
                this.rec.Amount__c = this.rec.UnitPrice__c * 1;
            } else {
                this.rec.Amount__c = this.rec.UnitPrice__c * this.rec.Quantity__c;
            }
        }
        public Decimal getAmount() {
            return this.rec.Amount__c;
        }
        public void deleteAction() {
            this.isDeleted = true;
        }
        public void copyAction() {
            this.isCopy = true;
        }
        public AsiaProfitCalculationDetail__c detailCopy() {
            AsiaProfitCalculationDetail__c ret = null;
            if (this.rec != null) {
                ret = this.rec.clone(false,true,false,false);
            }
            this.isCopy = false;
            return ret;
        }
        public String getDetailType() {
            return this.rec.Type__c;
        }
        
        public Integer compareTo(Object compareTo) {
            QuotationDetailItem compareTarget = (QuotationDetailItem)compareTo;
            Integer returnValue = 0;

            if (rec.Category__c > compareTarget.rec.Category__c) {
                returnValue = 1;
            } else if (rec.Category__c < compareTarget.rec.Category__c) {
                returnValue = -1;
            } else {
                if (rec.SortNo__c > compareTarget.rec.SortNo__c) {
                    returnValue = 1;
                } else if (rec.SortNo__c < compareTarget.rec.SortNo__c) {
                    returnValue = -1;
                }                
            }

            return returnValue;
        }
    }


    public class QuotationDetailItem2SP implements Comparable {

        public AsiaProfitCalculationDetail2SP__c rec {get; set;}
        public Boolean isDeleted{get; set;}
        public Boolean isCopy{get; set;}
        public string IdxRow{get; set;}
        public string IdxRowParent{get; set;}

        public QuotationDetailItem2SP (AsiaProfitCalculationDetail2SP__c target, string IdxRowParentParam){
            this.rec = target;
            this.isDeleted = false;
            this.isCopy = false;
            this.IdxRowParent = IdxRowParentParam;
            
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.ConvertTohex(b);
            this.IdxRow = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        }

        public void deleteAction() {
            this.isDeleted = true;
        }
        public void copyAction() {
            this.isCopy = true;
        }
        
        public Integer compareTo(Object compareTo) {
            QuotationDetailItem2SP compareTarget = (QuotationDetailItem2SP)compareTo;
            Integer returnValue = 0;

            if (rec.SortNo__c > compareTarget.rec.SortNo__c) {
                returnValue = 1;
            } else if (rec.SortNo__c < compareTarget.rec.SortNo__c) {
                returnValue = -1;
            }                

            return returnValue;
        }
    }

    private void bindingRateData(List<AsiaProfitCalculationRate__c> lsRate) {
        system.debug('lsRate: ' + lsRate.size());
        if (lsRate != null && lsRate.size() > 0) {
            // Get the list of units available for the quotation company
            for(Schema.PicklistEntry f : AsiaProfitCalculation__c.SalesCurrency__c.getDescribe().getPicklistValues()) {
                //THB && PHO Is only for Thailand market
                if(f.getValue() == 'THB' || f.getValue() == 'PHO'){
                    //if Quotation is for Thailand market
                    if(qdm.parentRec.TargetMarket__c == '1'){
                       rateListOther.put(f.getValue(), new List<AsiaProfitCalculationRate__c>());   
                    }
                } else {
                    rateListOther.put(f.getValue(), new List<AsiaProfitCalculationRate__c>());  
                }
            }
            for(Schema.PicklistEntry f : AsiaProfitCalculation__c.JProdCostCurrency__c.getDescribe().getPicklistValues()) {
                //THB && PHO Is only for Thailand market
                if(f.getValue() == 'THB' || f.getValue() == 'PHO'){
                    //if Quotation is for Thailand market
                    if(qdm.parentRec.TargetMarket__c == '1'){
                       rateListJprod.put(f.getValue(), new List<AsiaProfitCalculationRate__c>());   
                    }
                } else {
                    rateListJprod.put(f.getValue(), new List<AsiaProfitCalculationRate__c>());  
                }
            }

            for (AsiaProfitCalculationRate__c row : lsRate) {
                // Firstly, only add the rows that have the same currency (1st row)
                if (row.CurrencyBase__c == row.CurrencyToConvert__c) {

                    if (row.Type__c == '1') {
                        if (rateListOther.containsKey(row.CurrencyBase__c)) {
                            rateListOther.get(row.CurrencyBase__c).add(row);
                        }
                    } else if (row.Type__c == '2') {
                        if (rateListJprod.containsKey(row.CurrencyBase__c)) {
                            rateListJprod.get(row.CurrencyBase__c).add(row);
                        }
                    }
                }
            }

            // Remove the rows which have no data
            targetSalesCurrencyOption = new List<SelectOption>();
            for (String sKey : rateListOther.keySet()) {
                //if there is no record CurrencyBase__c = CurrencyToConvert__c
                if (rateListOther.get(sKey).size() == 0) {
                    rateListOther.remove(sKey);
                } else {
                    targetSalesCurrencyOption.add(new SelectOption(sKey, sKey));
                }
            }

            targetCostCurrencyOption = new List<SelectOption>();
            for (String sKey : rateListJprod.keySet()) {
                //if there is no record CurrencyBase__c = CurrencyToConvert__c
                if (rateListJprod.get(sKey).size() == 0) {
                    rateListJprod.remove(sKey);
                } else {
                    targetCostCurrencyOption.add(new SelectOption(sKey, sKey));
                }
            }

            listJProdCurrencyOption = new List<SelectOption>();
            listOtherCurrencyOption = new List<SelectOption>();

            // Secondly, add the rows order like the values of the corresponding picklist
            for(Schema.PicklistEntry f : AsiaProfitCalculationRate__c.CurrencyToConvert__c.getDescribe().getPicklistValues()) {
                Boolean otherIncluded = false;
                Boolean japanIncluded = false;
                for (AsiaProfitCalculationRate__c row : lsRate) {
                    if((row.CurrencyToConvert__c == 'THB' || row.CurrencyToConvert__c == 'PHO') && qdm.parentRec.TargetMarket__c != '1' && row.Type__c == '2'){
                        continue;
                    }
                    if (row.CurrencyToConvert__c == f.getValue() && row.CurrencyToConvert__c != row.CurrencyBase__c) {
                        if (row.Type__c == '1') {
                            if (rateListOther.containsKey(row.CurrencyBase__c)) {
                                rateListOther.get(row.CurrencyBase__c).add(row);

                                if(!otherIncluded){
                                    listOtherCurrencyOption.add(new SelectOption(row.CurrencyToConvert__c, row.CurrencyToConvert__c));
                                    otherIncluded = true;
                                }
                            }
                        } else if (row.Type__c == '2') {
                            if (rateListJprod.containsKey(row.CurrencyBase__c)) {
                                rateListJprod.get(row.CurrencyBase__c).add(row);

                                if (!japanIncluded){
                                    listJProdCurrencyOption.add(new SelectOption(row.CurrencyToConvert__c, row.CurrencyToConvert__c));
                                    japanIncluded = true;
                                }
                            }
                        }
                    }
                }       
            }
        }

        // Make the list of the same size
        integer iSize = 0;

        for (List<AsiaProfitCalculationRate__c> lsls : rateListJprod.values()) {
            if (lsls != null && lsls.size() > iSize) {
                iSize = lsls.size();
            }
        }
        for (List<AsiaProfitCalculationRate__c> lsls : rateListJprod.values()) {
            if (iSize > lsls.size()) {
                for (integer i = lsls.size(); i < iSize; i++) {
                    lsls.add(new AsiaProfitCalculationRate__c(ReadOnly__c = true));
                }
            }
        }

        iSize = 0;
        for (List<AsiaProfitCalculationRate__c> lsls : rateListOther.values()) {
            if (lsls != null && lsls.size() > iSize) {
                iSize = lsls.size();
            }
        }
        for (List<AsiaProfitCalculationRate__c> lsls : rateListOther.values()) {
            if (iSize > lsls.size()) {
                for (integer i = lsls.size(); i < iSize; i++) {
                    lsls.add(new AsiaProfitCalculationRate__c(ReadOnly__c = true));
                }
            }
        }

    }
    private void InitializeListRate(boolean isCopy) {

        system.debug('into InitializeListRate');        
        
        rateListJprod = new Map<String, List<AsiaProfitCalculationRate__c>>();
        rateListOther = new Map<String, List<AsiaProfitCalculationRate__c>>();

        system.debug('InitializeListRate id:' + qdm.parentRec.id);        

        List<AsiaProfitCalculationRate__c> lsRate = [SELECT id, Type__c, CurrencyBase__c, CurrencyToConvert__c, Rate__c, ReadOnly__c, Profit_Calculation__c FROM AsiaProfitCalculationRate__c Where Profit_Calculation__c = :qdm.parentRec.id];

        if (lsRate == null || lsRate.size() == 0) {
            system.debug('InitializeListRate isCopy:' + isCopy);        

            // Create the rate
            lsRate = new List<AsiaProfitCalculationRate__c>();
            system.debug('userCompany: ' + userCompany);

            if (!isCopy) {                
                List<AsiaProfitCalculationRateDefault__c> lsRateDefault = [SELECT id, Type__c, CurrencyBase__c, CurrencyToConvert__c, Rate__c, ReadOnly__c FROM AsiaProfitCalculationRateDefault__c WHERE Company__c = :userCompany];
                if (lsRateDefault != null && lsRateDefault.size() > 0) {
                    for (AsiaProfitCalculationRateDefault__c row : lsRateDefault) {
                        lsRate.add(new AsiaProfitCalculationRate__c(Type__c = row.Type__c, CurrencyBase__c = row.CurrencyBase__c, CurrencyToConvert__c = row.CurrencyToConvert__c, Rate__c = row.Rate__c, ReadOnly__c = row.ReadOnly__c));
                    }
                }
            } else {
                if (Apexpages.currentPage().getParameters().containsKey(PARAM_ID)) {
                    String targetId = Apexpages.currentPage().getParameters().get(PARAM_ID);

                    system.debug('InitializeListRate targetId:' + targetId);        

                    List<AsiaProfitCalculationRate__c> lsRateDefault = [SELECT id, Type__c, CurrencyBase__c, CurrencyToConvert__c, Rate__c, ReadOnly__c, Profit_Calculation__c FROM AsiaProfitCalculationRate__c Where Profit_Calculation__c = :targetId];
                    if (lsRateDefault != null && lsRateDefault.size() > 0) {
                        for (AsiaProfitCalculationRate__c row : lsRateDefault) {
                            lsRate.add(new AsiaProfitCalculationRate__c(Type__c = row.Type__c, CurrencyBase__c = row.CurrencyBase__c, CurrencyToConvert__c = row.CurrencyToConvert__c, Rate__c = row.Rate__c, ReadOnly__c = row.ReadOnly__c));
                        }
                    }
                }
            }           
        }
        bindingRateData(lsRate);
        system.debug('InitializeListRate end');        
    }


    public void refreshListRate() {
        system.debug('into refreshListRate');        
        rateListJprod = new Map<String, List<AsiaProfitCalculationRate__c>>();
        rateListOther = new Map<String, List<AsiaProfitCalculationRate__c>>();
        system.debug('qdm.parentRec.id: ' + qdm.parentRec.id);
        system.debug('qdm.parentRec.Company__c: ' + qdm.parentRec.Company__c);        

        // Create the rate
        List<AsiaProfitCalculationRate__c> lsRate = new List<AsiaProfitCalculationRate__c>();

        List<AsiaProfitCalculationRateDefault__c> lsRateDefault = [SELECT id, Type__c, CurrencyBase__c, CurrencyToConvert__c, Rate__c, ReadOnly__c FROM AsiaProfitCalculationRateDefault__c WHERE Company__c = :qdm.parentRec.Company__c];
        system.debug('lsRateDefault: ' + lsRateDefault.size());

        if (lsRateDefault != null && lsRateDefault.size() > 0) {
            for (AsiaProfitCalculationRateDefault__c row : lsRateDefault) {
                lsRate.add(new AsiaProfitCalculationRate__c(Type__c = row.Type__c, CurrencyBase__c = row.CurrencyBase__c, CurrencyToConvert__c = row.CurrencyToConvert__c, Rate__c = row.Rate__c, ReadOnly__c = row.ReadOnly__c));
            }
        }
        bindingRateData(lsRate);
        system.debug('refreshListRate end');
    }

    public List<Obj2SPItem> current2SPItems{get; set;}
    public String selectedModelType{get; set;}
    public String selectedRow{get; set;}
    public class Obj2SPItem {

        public Decimal sortNo {get; set;}
        public Boolean isSel {get; set;}
        public Decimal qty {get; set;}
        public String qtyFormatted {get; set;}
        public String description {get; set;}
        public Decimal partNumber {get; set;}
        public String specification {get; set;}
        public Decimal unitPrice {get; set;}
        public Decimal costPrice {get; set;}
        public Decimal costPriceJPY {get; set;}
        public Decimal salesPrice {get; set;}
        public String salesPriceFormatted {get; set;}
        public Decimal salesPriceCalcul {get; set;}
        public String salesPriceCalculFormatted {get; set;}

        public string IdxRow{get; set;}

        public Obj2SPItem (Decimal sortNoParam, Boolean isSelParam, Decimal qtyParam, String descriptionParam, Decimal partNumberParam, 
                                       String specificationParam, Decimal unitPriceParam, Decimal costPriceParam, Decimal costPriceJPYParam, Decimal salesPriceParam, Decimal salesPriceCalculParam) {
            this.sortNo = sortNoParam;
            this.isSel = isSelParam;
            this.qty = (qtyParam == null ? -1 : qtyParam);
            this.qtyFormatted = formatQty(qtyParam);
            this.description = descriptionParam;
            this.partNumber = partNumberParam;
            this.specification = specificationParam;
            this.unitPrice = unitPriceParam;
            this.costPrice = costPriceParam;
            this.costPriceJPY = costPriceJPYParam;
            this.salesPrice = (salesPriceParam == null ? -1 : salesPriceParam);
            this.salesPriceFormatted = formatCurrency(salesPriceParam);
            this.salesPriceCalcul = (salesPriceCalculParam == null ? -1 : salesPriceCalculParam);
            this.salesPriceCalculFormatted = formatCurrency(salesPriceCalculParam);
            
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.ConvertTohex(b);
            this.IdxRow = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        }

    }

    private static String formatQty(Decimal input){

        if (input == null) {return null;}
        String sInput = '' + input;
        if(sInput.indexOf('.') == -1) {sInput = sInput + '.0';}
        sInput = String.valueOf(Decimal.valueOf(sInput).setScale(1));

        return sInput;

    }

    private static String formatCurrency(Decimal input){

        if (input == null) {return null;}

        String sInput = '' + input;

        if(sInput.indexOf('.') == -1){sInput = sInput+'.00';}

        String newValue = sInput.substring(sInput.indexOf('.'));
        newValue = String.valueOf(Decimal.valueOf(newValue).setScale(2));
        newValue = newValue.substring(newValue.indexOf('.'));
        sInput = sInput.substring(0,sInput.indexOf('.'));
        Integer sz = sInput.length();
        Integer n=0;
        for(Integer i = sz - 1;i > -1;i--){
            if(n!= 0 && math.mod(n,3) == 0)
                newValue = sInput.substring(i,i+1)+','+newValue;
            else
                newValue = sInput.substring(i,i+1)+newValue;
            n++; 
        }
        return newValue;

    }

    private void refreshDefaultCoef() {

        List<AsiaJProdSalesCoefficient__c> lsCoef = [SELECT ModelType__c, Coefficient__c
                                                     FROM   AsiaJProdSalesCoefficient__c
                                                     WHERE  IsSvc__c = false
                                                     AND    Series__c in (null, :qdm.parentRec.Series__c)
                                                     AND    Area__c = :qdm.parentRec.ShipmentCountry__c
                                                     AND    ModelType__c = NULL
                                                    ];
        defaultCoef = null;
        for (AsiaJProdSalesCoefficient__c coef : lsCoef) {
            defaultCoef = coef.Coefficient__c;
        }

    }

    public void refreshCurrent2SP() {

        List<Obj2SPItem> current2SPItemsTmp = new List<Obj2SPItem>();

        current2SPItems.clear();

        refreshDefaultCoef();

        boolean fRowFound = false;
        for(QuotationDetailItem2SP row2SP : qdm.items2SPAll) {
            if (!row2SP.isDeleted && row2SP.idxRowParent == selectedRow) {
                fRowFound = true;
                current2SPItemsTmp.add(new Obj2SPItem(row2SP.rec.SortNo__c, row2SP.rec.IsSelected__c, row2SP.rec.Quantity__c, row2SP.rec.Description__c, row2SP.rec.PartNumber__c, row2SP.rec.Specification__c, row2SP.rec.UnitPrice__c, row2SP.rec.CostPrice__c, row2SP.rec.CostPriceJPY__c, row2SP.rec.SalesPrice__c, -1));
            }
        }

    
        if (!fRowFound) {

            system.debug('ModelTypeParam : ' + selectedModelType);
            for (QuotationDetailItem det : qdm.itemsAll) {
                if (det.IdxRow == selectedRow) {
                    selectedModelType = det.rec.ModelType__c;
                    system.debug('ModelTypeRow : ' + det.rec.ModelType__c);
                }
            }

    
            List<AsiaProductItem2SP__c> ls2SP = [SELECT id, Description__c, ModelType__c, PartNumber__c, IsSelectedDefault__c, QuantityDefault__c, SortNo__c, Specification__c, UnitPrice__c
                                                 FROM   AsiaProductItem2SP__c
                                                 WHERE  ModelType__c = :selectedModelType
                                                 ORDER BY SortNo__c NULLS LAST];

            if (ls2SP != NULL && ls2SP.size() > 0) {

                String sPartNumberQuotes = '';
                for (AsiaProductItem2SP__c row2SP : ls2SP) {
                    String id_in_quotes = '\'' + row2SP.PartNumber__c + '\'';
                    if (sPartNumberQuotes != '') { sPartNumberQuotes += ','; }  //  add a comma if this isn't the first one
                    sPartNumberQuotes += id_in_quotes;
                }

                List<String> conditions = new List<String>();
                conditions.add('Name in (' + sPartNumberQuotes + ')');

                List<ProductItem__c> lsItems;
                lsItems = Database.query(' SELECT id, Name, EnglishName__c, Kikaku__c ' +
                                         ' FROM ProductItem__c ' +
                                          JEOLUtil.joinWhereConditions(conditions) +
                                         ' AND (ProductItemType__c = NULL OR ProductItemType__c = \'1\')' +
                                         ' ORDER BY EnglishName__c ' +
                                         ' LIMIT 10000');

                Map<String, ProductItem__c> mpItems = new Map<String, ProductItem__c>();
                for (ProductItem__c itm : lsItems) {
                    mpItems.put(itm.Name, itm);
                }


                conditions = new List<String>();
                conditions.add(JEOLUtil.appendEqualText('CostCurrency__c', 'JPY'));
                conditions.add(JEOLUtil.appendEqualText('PriceBookCode__c', 'FOB'));
                conditions.add('PriceBookOrigin__c = \'1\'');
                conditions.add('ProductItem__r.Name in (' + sPartNumberQuotes + ')');
        
                if (String.isNotBlank(dateQT)) {
                    conditions.add('StartDateFormula__c <= ' + dateQT);  
                    conditions.add('(EndDateFormula__c = NULL OR EndDateFormula__c > ' + dateQT + ')');  
                } else {
                    // Should not happen, an error message should be displayed in the page before calling this method
                    conditions.add('TechnicalAlways1__c = 0');            
                }


                List<ProductItemPrice__c> lsPrices;
                lsPrices = Database.query(' SELECT id, ProductItem__r.Name, Price__c ' +
                                          ' FROM ProductItemPrice__c ' +
                                          JEOLUtil.joinWhereConditions(conditions) +
                                          ' AND (ProductItem__r.ProductItemType__c = NULL OR ProductItem__r.ProductItemType__c = \'1\')' +
                                          ' ORDER BY ParentEnglishName__c ' +
                                          ' LIMIT 10000');

                Map<String, Decimal> mpPrices = new Map<String, Decimal>();
                for (ProductItemPrice__c pric : lsPrices) {
                    mpPrices.put(pric.ProductItem__r.Name, pric.Price__c);
                }



                for (AsiaProductItem2SP__c row2SP : ls2SP) {
                    current2SPItemsTmp.add(new Obj2SPItem(row2SP.SortNo__c,
                                                          row2SP.IsSelectedDefault__c,
                                                          row2SP.QuantityDefault__c,
                                                          mpItems.containsKey('' + row2SP.PartNumber__c) ? mpItems.get('' + row2SP.PartNumber__c).EnglishName__c : row2SP.Description__c,
                                                          row2SP.PartNumber__c,
                                                          mpItems.containsKey('' + row2SP.PartNumber__c) ? mpItems.get('' + row2SP.PartNumber__c).Kikaku__c : row2SP.Specification__c,
                                                          mpPrices.containsKey('' + row2SP.PartNumber__c) ? mpPrices.get('' + row2SP.PartNumber__c) : 0, 
                                                          NULL, NULL, NULL, defaultCoef == null || row2SP.QuantityDefault__c  == null || !mpPrices.containsKey('' + row2SP.PartNumber__c) ? null : defaultCoef * row2SP.QuantityDefault__c * mpPrices.get('' + row2SP.PartNumber__c)));
                }

            }




        }

        if (current2SPItemsTmp != null && current2SPItemsTmp.size() > 0) {
            for (Obj2SPItem curRow : current2SPItemsTmp) {
                if (curRow.isSel) {
                    current2SPItems.add(curRow);
                }
            }
            for (Obj2SPItem curRow : current2SPItemsTmp) {
                if (!curRow.isSel) {
                    current2SPItems.add(curRow);
                }
            }
        }

    }


    public void saveCurrent2SPInFullSP() {

        for(QuotationDetailItem2SP row2SP : qdm.items2SPAll) {
            if (!row2SP.isDeleted && row2SP.idxRowParent == selectedRow) {
                row2SP.rec.SortNo__c = -1 ;
            }
        }

        for (Obj2SPItem curRow2SP : current2SPItems) {

            boolean fRowFound = false;

            // Search if the row already exists and update it in that case
            for(QuotationDetailItem2SP row2SP : qdm.items2SPAll) {
                if (row2SP.idxRowParent == selectedRow && row2SP.rec.PartNumber__c == curRow2SP.partNumber) {
                    fRowFound = true;
                    row2SP.isDeleted = false;
                    row2SP.rec.SortNo__c = curRow2SP.sortNo;
                    row2SP.rec.IsSelected__c = curRow2SP.isSel;
                    row2SP.rec.Quantity__c = (curRow2SP.qty < 0 ? NULL : curRow2SP.qty);
                    row2SP.rec.Description__c = curRow2SP.description;
                    row2SP.rec.PartNumber__c = curRow2SP.partNumber;
                    row2SP.rec.Specification__c = curRow2SP.specification;
                    row2SP.rec.UnitPrice__c = curRow2SP.unitPrice;
                    row2SP.rec.CostPrice__c = curRow2SP.costPrice;
                    row2SP.rec.CostPriceJPY__c = curRow2SP.costPriceJPY;
                    row2SP.rec.SalesPrice__c = (curRow2SP.salesPrice < 0 ? NULL : curRow2SP.salesPrice);
                    row2SP.rec.SalesPriceCalculated__c = (curRow2SP.salesPriceCalcul < 0 ? NULL : curRow2SP.salesPriceCalcul);
system.debug('1.Quantity__c:'+row2SP.rec.Quantity__c + '|' + curRow2SP.qty);

                    break;
                }
            }

            // If the row does not exist, create it
            if (!fRowFound) {
                AsiaProfitCalculationDetail2SP__c rec = new AsiaProfitCalculationDetail2SP__c();

//                rec.ProfitCalculationDetail__c = selectedRow;
                rec.PartNumber__c = curRow2SP.partNumber;
                rec.SortNo__c = curRow2SP.sortNo;
                rec.IsSelected__c = curRow2SP.isSel;
                rec.Quantity__c = (curRow2SP.qty < 0 ? NULL : curRow2SP.qty);
                rec.Description__c = curRow2SP.description;
                rec.PartNumber__c = curRow2SP.partNumber;
                rec.Specification__c = curRow2SP.specification;
                rec.UnitPrice__c = curRow2SP.unitPrice;
                rec.CostPrice__c = curRow2SP.costPrice;
                rec.CostPriceJPY__c = curRow2SP.costPriceJPY;
                rec.SalesPrice__c = (curRow2SP.salesPrice < 0 ? NULL : curRow2SP.salesPrice);
                rec.SalesPriceCalculated__c = (curRow2SP.salesPriceCalcul < 0 ? NULL : curRow2SP.salesPriceCalcul);

system.debug('2.Quantity__c:'+rec.Quantity__c + '|' + curRow2SP.qty);

                qdm.items2SPAll.add(new QuotationDetailItem2SP(rec, selectedRow));

            }        
        }

        // Put to delete the rows no more existing
        for(QuotationDetailItem2SP row2SP : qdm.items2SPAll) {
            if (!row2SP.isDeleted && row2SP.rec.SortNo__c == -1) {
                row2SP.isDeleted = true;
            }
        }

        current2SPItems.clear();

    }
    


    public void deleteCurrent2SPInFullSP() {

        for(QuotationDetailItem2SP row2SP : qdm.items2SPAll) {
            if (!row2SP.isDeleted && row2SP.idxRowParent == selectedRow) {
                row2SP.rec.SortNo__c = -1 ;
                row2SP.isDeleted = true ;
            }
        }

        current2SPItems.clear();

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
    // DUC added

    private void updateCompanyInfo(){
        system.debug('into updateCompanyInfo');
        
        String sCompanyNameProfile = currentUser.CompanyName;

        for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
            //if company matched
            if(companyCustSettings.CompanyName__c == sCompanyNameProfile){
                //if company is ASIA
                if(companyCustSettings.Company__c == 'ASIA'){
                    //if martket is for THAILAND
                    if(qdm.parentRec.TargetMarket__c == '1'){
                        companyCustSettings = CompanyName__c.getValues('ASIA-THAILAND');
                    }
                    //TODO: handle for other countries
                }
                qdm.parentRec.Company__c = companyCustSettings.Company__c;
                qdm.parentRec.CompanyName__c = companyCustSettings.CompanyLabel__c;
                qdm.parentRec.OrgAddress__c = companyCustSettings.OrgAddress__c;
                qdm.parentRec.OrgPhone__c = companyCustSettings.OrgPhone__c;
                qdm.parentRec.OrgFax__c = companyCustSettings.OrgFax__c;
                qdm.parentRec.OrgName__c = companyCustSettings.CompanyName__c;
                qdm.parentRec.TaxRate__c = companyCustSettings.TaxationRate__c == null ? 0 : companyCustSettings.TaxationRate__c;
                break;
            }
        }
    }

    public void reloadDataSourceAccordingMarket(){
        //update target market in record when user change the select list
        system.debug('after change: ' + qdm.parentRec.TargetMarket__c);
        //if target is changed to Thai and term payment was in ASIA then change it to Thai
        if (qdm.parentRec.TargetMarket__c == '1' && qdm.parentRec.PaymentConditionSection__c == '0'){
            qdm.parentRec.PaymentConditionSection__c = '1';
        }
        //if target is changed to ASIA and term payment was in Thai then change it to ASIA
        if (qdm.parentRec.TargetMarket__c == '0' && qdm.parentRec.PaymentConditionSection__c == '1'){
            qdm.parentRec.PaymentConditionSection__c = '0';
        }

        InitializeListRate(isCopy);

        //if target is changed to ASIA and J-Prod cost currency was in THB or PHO then change it to USD
        if (qdm.parentRec.TargetMarket__c == '0' && (qdm.parentRec.JProdCostCurrency__c == 'THB' || qdm.parentRec.JProdCostCurrency__c == 'PHO')){
            qdm.parentRec.JProdCostCurrency__c = 'USD';
        }
        //if target is changed to ASIA and Sales Currency was in THB or PHO then change it to USD
        if (qdm.parentRec.TargetMarket__c == '0' && (qdm.parentRec.SalesCurrency__c == 'THB' || qdm.parentRec.SalesCurrency__c == 'PHO')){
            qdm.parentRec.SalesCurrency__c = 'USD';
        }

        updateCompanyInfo();
    }

    public List<SelectOption> getPaymentTermOptions(){
        list<SelectOption> options = new list<SelectOption>();
        for (Schema.PicklistEntry f : AsiaProfitCalculation__c.PaymentConditionSection__c.getDescribe().getPicklistValues()) {
            //if target is Thailand then remove Asia payment method from the list
            if(qdm.parentRec.TargetMarket__c == '1' && f.getValue() == '0') {
                continue;
            }
            //if target is ASIA then remove Thai payment method from the list
            if(qdm.parentRec.TargetMarket__c == '0' && f.getValue() == '1') {
                continue;
            }
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }       
        return options;
    }
    
    public List<SelectOption> getTargetMarketOptions(){
        list<SelectOption> options = new list<SelectOption>();
        for (Schema.PicklistEntry f : AsiaProfitCalculation__c.TargetMarket__c.getDescribe().getPicklistValues()) {
            if(currentUser.AvailableMarket__c.indexOf(f.getValue()) >= 0){
                options.add(new SelectOption(f.getValue(), f.getLabel()));
            }
        }       
        return options;
    }


    public List<SelectOption> getQuotationTypeOptions(){

        List<selectOption> options = new List<selectOption>();

        List<RecordTypeInfo> infos = AsiaProfitCalculation__c.SObjectType.getDescribe().getRecordTypeInfos();
            
        for (Schema.PicklistEntry f : AsiaProfitCalculation__c.ProfitCalculationType__c.getDescribe().getPicklistValues()) {
            for (RecordTypeInfo i : infos) {
               if (i.isAvailable() 
               // Ignore the Master Record Type, whose Id always ends with 'AAA'.
               // We check the Id because Name can change depending on the user's language.
                && !String.valueOf(i.getRecordTypeId()).endsWith('AAA')
                && i.getName() == f.getValue()) {
                    options.add(new selectOption(i.getRecordTypeId(), i.getName()));
                }
            }
        }

        return options;
    }


    public String getRedirectExportCsvURL(){
        String sParameters = '';

        final String PARAM_CSV_ID = 'ID';

        // 系列
        if (String.isNotBlank(qdm.parentRec.Id)) {
            if (sParameters.length() > 0) {
                sParameters += '&';
            }
            sParameters += PARAM_CSV_ID + '=' + qdm.parentRec.Id;
        }

        return '/apex/JEOLAsia_QuotationExportCSV' + (sParameters.length() > 0 ? '?' + sParameters : '');
    }


}