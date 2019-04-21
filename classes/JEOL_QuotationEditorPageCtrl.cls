/*
 * Updated : 2015/06/02 by Polus (Voxer) - Add of DefaultRowsItems__c...
 * Updated : 2015/06/11 by Polus (Voxer) - UAT #32: Problem of showing units like SE instead of 式
 */
public with sharing class JEOL_QuotationEditorPageCtrl {
    
    public static final String PARAM_ID = 'id';
    public static final String SCROLL_TOP = 'top';
    public Boolean isValid{get; set;}
    public QuotationDetailManage qdm{get; set;}
    public UserSetting__c userSetting{get; set;}
    public Boolean isNew{get; set;}
    public String productDivision{get; set;}
    public Boolean isCopy{get; set;}
    public Boolean isBranch{get; set;}
    public String inputDefaultRowsItems{get; set;}
    public String inputDefaultRowsHeading{get; set;}
    public String inputDefaultRowsSubItems{get; set;}
    public Boolean isReadOnly{get; set;}
    public Boolean isCopyForbidden{get; set;}
    public double scrollTopValue{get; set;}
    public double currentScrollValue{get; set;}
    public String listRowToDel{get; set;}
    public String address{get; set;}
    public String language{get; set;}
    public Boolean ReprNameExpress1{get; set;}
    public Boolean ReprNameExpress2{get; set;}
    
    QuotationInformation__c o = new QuotationInformation__c();
    public QuotationInformation__c getProxyObject() { return o; }
    
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
    
    public static final String PRODUCT_BASE_QUERY = ' SELECT id, JapaneseName__c, Name, UnitPrice__c, Division__c, Tani__c, Model__c, modelType__c FROM ProductItem__c ';
    public static final String ACCOUNT_BASE_QUERY = ' SELECT id, name, code__c, Address__c, Abbreviation__c FROM Account ';
    public static final String CONTACT_BASE_QUERY = ' SELECT id, Account.name, Account.code__c, Account.Address__c, Account.Abbreviation__c,name, Phone, Title, Affiliation__c FROM contact ';
    public static final String QUOTATION_BASE_QUERY = ' SELECT id, Name,  QuoteNo__c, BranchNo__c, QuotationType__c, ContractName__c, ContractName1__c, ContractName2__c, ShipmentName__c, ShipmentName1__c, ShipmentName2__c, CreatedBy.Name, IssueDate__c FROM QuotationInformation__c ';
    public static final String QUOTATION_DETAIL_BASE_QUERY = ' SELECT id, Body__c,  ProductCode__c, Quantity__c, QuantityUnit__c, UnitPrice__c, TotalDiscountAmount__c, Type__c FROM QuotationDetailInformation__c ';
    public static final String PRODUCT_CATALOG_ITEMS_BASE_QUERY = 'SELECT id, SearchKeyWord__c, ProductCatalog__c, ProductNo__c, ClassificationType__c, Position__c, CatalogStructure__c, ClassificationNo__c, ProductItem__r.Name, ProductItem__r.JapaneseName__c, ProductItem__r.Tani__c, ProductItem__r.UnitPrice__c, ProductItem__r.ModelType__c FROM ProductCatalog__c';
    public static final Integer QUOTE_NO_PREFIX_LENGTH = 8;
    public static final String URL_PARAM_NAME_ISBRANCH = 'isBranch';
    public static final String URL_PARAM_NAME_ISCOPY = 'isCopy';
    
    public JEOL_QuotationEditorPageCtrl() {
        this.isValid = false;
        Boolean isCopy = false;
        Boolean isBranch = false;
        isReadOnly = false;
        isCopyForbidden = false;
        QuotationInformation__c rec = null;
        scrollTopValue = 0;
        currentScrollValue = 0;
        language = '';

        try {
            this.language = UserInfo.getLanguage();
            this.userSetting = getUserSettingRecord();
            Map<String, String> params = Apexpages.currentPage().getParameters();

            if (params.containsKey(SCROLL_TOP)) {
                scrollTopValue = double.valueof(params.get(SCROLL_TOP));
            }
            
            if (params.containsKey(PARAM_ID)) {
                String targetId = params.get(PARAM_ID);
System.debug('@@@@PARAMID: ' + targetId);
                rec = getTargetRecord(targetId);
                                
                 //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.xx)
                if(userSetting.IsDisplayDecimal__c != null)
                    rec.IsDisplayDecimal__c = userSetting.IsDisplayDecimal__c;
                //Modification-VAIB-End(2015/05/21 UAT_QA_List No.xx)
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
System.debug('@@@@PARAMID: NONE');
                rec = createNewRecord();
                List<String> wordList = new List<String>();
                String word = userSetting.Word1__c;
                if (userSetting.WordSettingDefaultDisplay1__c == '表示' && String.isNotBlank(word)) {
                    wordList.add(word);
                }
                word = userSetting.Word2__c;
                if (userSetting.WordSettingDefaultDisplay2__c == '表示' && String.isNotBlank(word)) {
                    wordList.add(word);
                }
                word = userSetting.Word3__c;
                if (userSetting.WordSettingDefaultDisplay3__c == '表示' && String.isNotBlank(word)) {
                    wordList.add(word);
                }
                if (wordList.size() > 0) {
                    rec.Note__c = String.join(wordList,'\n');
                }
                if (userSetting.QuotationNameExpress__c) {
                    rec.QuotationNameExpress__c = userSetting.QuotationNameExpress__c;
                }
                 //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.xx)
                if(userSetting.IsDisplayDecimal__c != null)
                    rec.IsDisplayDecimal__c = userSetting.IsDisplayDecimal__c;
                 //Modification-VAIB-End(2015/05/21 UAT_QA_List No.xx)
                this.isNew = true;
            }

            if (!this.isNew)
            {
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
            } else {
                // For new quotation, it is with the record type SFDC (even if it is a copy of BaaN quotation)
                rec.RecordTypeId = Schema.SObjectType.QuotationInformation__c.getRecordTypeInfosByName().get('SFDC').getRecordTypeId();
            }
            
            if (String.isNotBlank(userSetting.ProductDivision__c)) {
                productDivision = userSetting.ProductDivision__c;
            }
            if (rec.TaxRate__c == null) {
                TaxSetting__c taxSetting = TaxSetting__c.getOrgDefaults();
                rec.TaxRate__c = taxSetting.TaxationRate__c;
                if (rec.TaxRate__c == null) {
                    rec.TaxRate__c = 0;
                }
            }
            qdm = new QuotationDetailManage(rec, isCopy, isBranch); 
            //Modification-VAIB-Begin(2015/05/19 UAT_QA_List No.52)
            if(isNew && !isCopy)
            {   //If New page, creates few blank rows for inputting purchased product details
                integer iDepth = 0;
                if (userSetting.DefaultRowsItems__c > 0)
                {
                    for (Integer i = 0; i < userSetting.DefaultRowsItems__c; i++)
                    {
                        QuotationDetailInformation__c detail = qdm.createInitalizedRecord();
                        detail.Type__c = '1';
                        detail.IsTaxationTarget__c = true;
                        detail.IsShowDetailAmount__c = true;
                        detail.Depth__c = iDepth;
                        qdm.items.add(new QuotationDetailItem(detail));                        
                    }
                    iDepth++;
                }
                if (userSetting.DefaultRowsHeading__c > 0)
                {
                    for (Integer i = 0; i < userSetting.DefaultRowsHeading__c; i++)
                    {
                        QuotationDetailInformation__c detail = qdm.createInitalizedRecord();
                        detail.Type__c = '2';
                        detail.IsTaxationTarget__c = true;
                        detail.IsShowDetailAmount__c = true;
                        detail.Depth__c = iDepth;
                        qdm.items.add(new QuotationDetailItem(detail));                        
                    }
                    iDepth++;
                }
                if (userSetting.DefaultRowsSubItems__c > 0)
                {
                    for (Integer i = 0; i < userSetting.DefaultRowsSubItems__c; i++)
                    {
                        QuotationDetailInformation__c detail = qdm.createInitalizedRecord();
                        detail.Type__c = '1';
                        detail.IsTaxationTarget__c = true;
                        detail.IsShowDetailAmount__c = true;
                        detail.Depth__c = iDepth;
                        qdm.items.add(new QuotationDetailItem(detail));                        
                    }
                    iDepth++;
                }
                
                // Put the checkboxes for the summary checked
                qdm.parentRec.OutputTotalTaxAmount__c = true;
                qdm.parentRec.OutputConsumptionTaxAmount__c = true;
                qdm.parentRec.OutputTotalAmount__c = true;
                qdm.parentRec.OutputSubtitle__c = true;

            }
            //Modification-VAIB-End(2015/05/19 UAT_QA_List No.52)
            this.isCopy = isCopy;
            this.isBranch = isBranch;
            this.isValid = true;
        } catch (JEOLException e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
System.debug('@@@:' + e.getStackTraceString());
            return;
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '不正な操作が行われました。'));
            return;
        }
    }
    public List<SelectOption> getQuoteTypeOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTE_TYPE);
    }
    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }
    public List<SelectOption> getUnitOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_DEPARTMENT);
    }
    public List<SelectOption> getSalesAreaOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTATION_AREA_CODE);
    }
    public List<SelectOption> getDelivConditionOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTATION_DELIVERY_CONDITION);
    }
    public List<SelectOption> getQuantityUnitOptions() {
        return JEOLUtil.getSelectList(false, JEOLUtil.REFERENCE_NAME_QUOTATION_QUANTITY_UNIT, true);
    }
    public List<SelectOption> getDepartmentOptions() {
        List<SelectOption> options = new List<SelectOption>();
        List<Department__c> masterRecs = [SELECT Id, Name, DepartmentCode__c FROM Department__c ORDER BY SortNo__c];
        options.add(new SelectOption('', ''));
        for (Department__c rec: masterRecs) {
            options.add(new SelectOption(rec.DepartmentCode__c, rec.Name));
        }
        return options;
    }
    public List<SelectOption> getProductDivisionOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('製品', '製品'));
        options.add(new SelectOption('パーツ', 'パーツ'));
        return options;
    }
    
    public Pagereference quotationCopy() {
        Pagereference ref = Page.JEOL_QuotationEditorPage;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_ID, this.qdm.parentRec.id);
        params.put(URL_PARAM_NAME_ISCOPY, 'true');
        return ref;
    }

    public Pagereference quotationCopyAndBranch() {
        Pagereference ref = Page.JEOL_QuotationEditorPage;
        ref.setRedirect(true);
        Map<String, String> params = ref.getParameters();
        params.put(PARAM_ID, this.qdm.parentRec.id);
        params.put(URL_PARAM_NAME_ISCOPY, 'true');
        params.put(URL_PARAM_NAME_ISBRANCH, 'true');
        return ref;
    }
    
    public void acceptanceDateCalc() {
        String unitBody = this.qdm.parentRec.UnitBody__c;
        UnitBody__c targetUnitBody = null;
        if (String.isNotBlank(unitBody)) {
            List<UnitBody__c> unitBodyRecs = [SELECT id, SerialNo__c, UnitBody__c, AcceptanceDateFormula__c, Standard__c FROM UnitBody__c WHERE UnitBody__c =: unitBody];
            for (UnitBody__c rec: unitBodyRecs) {
                targetUnitBody = rec;
            }
        }
        if (targetUnitBody == null) {
            targetUnitBody = new UnitBody__c();
        }
        this.qdm.parentRec.UnitBody__c = targetUnitBody.UnitBody__c;
        Date acceptanceDate = targetUnitBody.AcceptanceDateFormula__c;
        this.qdm.parentRec.AcceptanceDate__c = acceptanceDate;
        this.qdm.parentRec.UnitBodyKikaku__c = targetUnitBody.Standard__c;
        if (acceptanceDate != null) {
            this.qdm.parentRec.KeikaNensu__c = Integer.valueOf(Math.floor(acceptanceDate.monthsBetween(Date.today())/12));
        } else {
            this.qdm.parentRec.KeikaNensu__c = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検収日に値がなかったため計算できませんでした。'));
        }
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
    public void salesAreaAttachment() {
        String searchTarget = qdm.parentRec.SalesAreaCode__c;
        SelectListManage__c masterData = getSelectListMasterValue(JEOLUtil.REFERENCE_NAME_QUOTATION_AREA_CODE, searchTarget);
        qdm.parentRec.SalesArea__c = masterData.Label__c;
        qdm.parentRec.SalesAreaCode__c = masterData.value__c;
    }
    public void salesAreaAttachmentBis() {
        String searchTarget = qdm.parentRec.OverrideDepartmentOutputText__c;
        SelectListManage__c masterData = getSelectListMasterValue(JEOLUtil.REFERENCE_NAME_QUOTATION_AREA_CODE, searchTarget);
        qdm.parentRec.OverrideDepartmentOutputText__c = masterData.Label__c;
    }
    public void quoteTypeAttachment() {
        String searchTarget = qdm.parentRec.QuotationType__c;
        SelectListManage__c masterData = getSelectListMasterValue(JEOLUtil.REFERENCE_NAME_QUOTE_TYPE, searchTarget);
        qdm.parentRec.QuotationTypeText__c = masterData.Label__c;
        qdm.parentRec.QuotationType__c = masterData.value__c;
    }
    
    public void delivConditionAttachment() {
        String searchTarget = qdm.parentRec.DeliveryCondition1__c;
        SelectListManage__c masterData = getSelectListMasterValue(JEOLUtil.REFERENCE_NAME_QUOTATION_DELIVERY_CONDITION, searchTarget);
        qdm.parentRec.DeliveryCondition2__c = masterData.Label__c;
        qdm.parentRec.DeliveryCondition1__c = masterData.value__c;
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
    
    public void departmentInfoAttachment() {
        String searchTarget = qdm.parentRec.DepartmentCode__c;
        Department__c masterData = null;
        if (String.isNotBlank(searchTarget)) {
            List<Department__c> masterRecs = [SELECT Id, Name, SupervisorPosition__c, SupervisorName__c, PostalCode__c, AddressLine1__c, AddressLine2__c, AddressLine3__c, Series__c, Phone__c, Fax__c, DepartmentCode__c FROM Department__c WHERE DepartmentCode__c =: searchTarget or Name =: searchTarget ORDER BY SortNo__c];
            for (Department__c rec: masterRecs) {
                masterData = rec;
            }
        }
        if (masterData == null) {
            masterData = new Department__c();
        }
        qdm.parentRec.DepartmentName__c = masterData.Name;
        qdm.parentRec.DepartmentCode__c = masterData.DepartmentCode__c;
        qdm.parentRec.PostalCode__c = masterData.PostalCode__c;
        qdm.parentRec.AddressLine1__c = masterData.AddressLine1__c;
        qdm.parentRec.AddressLine2__c = masterData.AddressLine2__c;
        qdm.parentRec.AddressLine3__c = masterData.AddressLine3__c;
        address = (masterData.AddressLine1__c == null ? '' : masterData.AddressLine1__c) + (masterData.AddressLine2__c == null ? '' : ' ' + masterData.AddressLine2__c) + (masterData.AddressLine3__c == null ? '' : ' ' + masterData.AddressLine3__c);
        qdm.parentRec.Phone__c = masterData.Phone__c;
        qdm.parentRec.Fax__c = masterData.Fax__c;
        qdm.parentRec.SupervisorPosition__c = masterData.SupervisorPosition__c;
        qdm.parentRec.SupervisorName__c = masterData.SupervisorName__c;
    }
    public void overDepartmentInfoAttachment() {
        String searchTarget = qdm.parentRec.OverrideDepartmentCode__c;
        Department__c masterData = null;
        if (String.isNotBlank(searchTarget)) {
            List<Department__c> masterRecs = [SELECT Id, Name, SupervisorPosition__c, SupervisorName__c, PostalCode__c, AddressLine1__c, AddressLine2__c, AddressLine3__c, Series__c, Phone__c, Fax__c, DepartmentCode__c FROM Department__c WHERE DepartmentCode__c =: searchTarget or Name =: searchTarget ORDER BY SortNo__c];
            for (Department__c rec: masterRecs) {
                masterData = rec;
            }
        }
        if (masterData == null) {
            masterData = new Department__c();
        }
        qdm.parentRec.OverrideDepartmentName__c = masterData.Name;
        qdm.parentRec.OverrideDepartmentCode__c = masterData.DepartmentCode__c;
    }
    public void ContractAttachmentFromCode() {
        String accountCode = qdm.parentRec.ContractCode__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, Fax, Phone FROM Account WHERE Code__c =: accountCode];
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
        qdm.parentRec.ContractPersonInCharge__c = null;
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;
        qdm.parentRec.ContractFax__c = targetAccount.Fax;
        qdm.parentRec.ContractPost__c = null;
        qdm.parentRec.ContractBelong__c = null;
system.debug('ContractAttachmentFromCode:' + qdm.parentRec.ContractAccount__c);

    }
    public void ShipmentAttachmentFromCode() {
        String accountCode = qdm.parentRec.ShipmentCode__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, DistanceZone__c, DistanceSection__c, Fax, Phone FROM Account WHERE Code__c =: accountCode];
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
        qdm.parentRec.ShipmentDistanceZone__c = targetAccount.DistanceZone__c;
        qdm.parentRec.ShipmentDistanceSection__c = targetAccount.DistanceSection__c;
        qdm.parentRec.ShipmentPersonInCharge__c = null;
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;
        qdm.parentRec.ShipmentFax__c = targetAccount.Fax;
        qdm.parentRec.ShipmentPost__c = null;
        qdm.parentRec.ShipmentBelong__c = null;
        qdm.parentRec.UnitBody__c = null;
        qdm.parentRec.AcceptanceDate__c = null;
        qdm.parentRec.UnitBodyKikaku__c = null;
        qdm.parentRec.KeikaNensu__c = null;
    }
    public void ContractAttachment() {
        String accountId = qdm.parentRec.ContractAccount_dummyField__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, Fax, Phone FROM Account WHERE id =: accountId];
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
        qdm.parentRec.ContractPersonInCharge__c = null;
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;
        qdm.parentRec.ContractFax__c = targetAccount.Fax;
        qdm.parentRec.ContractPost__c = null;
        qdm.parentRec.ContractBelong__c = null;
        qdm.parentRec.ContractAccount_dummyField__c = null;
    }
    public void ShipmentAttachment() {
        String accountId = qdm.parentRec.ShipmentAccount_dummyField__c;
        Account targetAccount = null;
        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, DistanceZone__c, DistanceSection__c, Fax, Phone FROM Account WHERE id =: accountId];
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
        qdm.parentRec.ShipmentDistanceZone__c = targetAccount.DistanceZone__c;
        qdm.parentRec.ShipmentDistanceSection__c = targetAccount.DistanceSection__c;
        qdm.parentRec.ShipmentPersonInCharge__c = null;
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;
        qdm.parentRec.ShipmentFax__c = targetAccount.Fax;
        qdm.parentRec.ShipmentPost__c = null;
        qdm.parentRec.ShipmentBelong__c = null;
        qdm.parentRec.UnitBody__c = null;
        qdm.parentRec.AcceptanceDate__c = null;
        qdm.parentRec.UnitBodyKikaku__c = null;
        qdm.parentRec.KeikaNensu__c = null;
        qdm.parentRec.ShipmentAccount_dummyField__c = null;
    }
    public void contractContactAttachment() {
        String contactId = qdm.parentRec.ContractContact_dummyField__c;
        Contact targetContact = null;
        List<Contact> recs = [SELECT
                                id, Name, Phone, Fax, Title, Affiliation__c, AccountId, Account.Name,
                                Account.Code__c, Account.Address__c,  Account.PostalCode__c, Account.Undergraduate__c, 
                                Account.OfficialName1__c, Account.OfficialName2__c, Account.OfficialNameRow1__c, Account.OfficialNameRow2__c
                            FROM Contact
                            WHERE id =: contactId];
        if (recs != null && recs.size() > 0) {
            targetContact = recs.get(0);
        } else {
            targetContact = new Contact();
        }
        if (targetContact.Account != null) {
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
        }
        qdm.parentRec.ContractPersonInCharge__c = targetContact.Name;
        qdm.parentRec.ContractPhone__c = targetContact.Phone;
        qdm.parentRec.ContractFax__c = targetContact.Fax;
        qdm.parentRec.ContractPost__c = targetContact.Title;
        qdm.parentRec.ContractBelong__c = targetContact.Affiliation__c;
        qdm.parentRec.ContractContact_dummyField__c = null;
        
    }
    public void shipmentContactAttachment() {
        String contactId = qdm.parentRec.ShipmentContact_dummyField__c;
        Contact targetContact = null;
        List<Contact> recs = [SELECT
                                id, Name, Phone, Fax, Title, Affiliation__c, AccountId, Account.Name,
                                Account.Code__c, Account.Address__c,  Account.PostalCode__c, Account.Undergraduate__c,
                                Account.DistanceZone__c, Account.DistanceSection__c, Account.OfficialName1__c,
                                Account.OfficialName2__c, Account.OfficialNameRow1__c, Account.OfficialNameRow2__c
                            FROM Contact
                            WHERE id =: contactId];
        if (recs != null && recs.size() > 0) {
            targetContact = recs.get(0);
        } else {
            targetContact = new Contact();
        }
        if (targetContact.Account != null) {
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
            qdm.parentRec.ShipmentDistanceZone__c = targetContact.Account.DistanceZone__c;
            qdm.parentRec.ShipmentDistanceSection__c = targetContact.Account.DistanceSection__c;
        }
        qdm.parentRec.ShipmentPersonInCharge__c = targetContact.Name;
        qdm.parentRec.ShipmentPhone__c = targetContact.Phone;
        qdm.parentRec.ShipmentFax__c = targetContact.Fax;
        qdm.parentRec.ShipmentPost__c = targetContact.Title;
        qdm.parentRec.ShipmentBelong__c = targetContact.Affiliation__c;
        qdm.parentRec.ShipmentContact_dummyField__c = null;
        qdm.parentRec.UnitBody__c = null;
        qdm.parentRec.AcceptanceDate__c = null;
        qdm.parentRec.UnitBodyKikaku__c = null;
        qdm.parentRec.KeikaNensu__c = null;
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
        qdm.parentRec.ShipmentBelong__c = qdm.parentRec.ContractBelong__c;
        qdm.parentRec.ShipmentPersonInCharge__c = qdm.parentRec.ContractPersonInCharge__c;
        qdm.parentRec.ShipmentPhone__c = qdm.parentRec.ContractPhone__c;
        qdm.parentRec.ShipmentFax__c = qdm.parentRec.ContractFax__c;
        qdm.parentRec.ShipmentPost__c = qdm.parentRec.ContractPost__c;
        qdm.parentRec.UnitBody__c = NULL;
        qdm.parentRec.AcceptanceDate__c = null;
        qdm.parentRec.UnitBodyKikaku__c = null;
        qdm.parentRec.KeikaNensu__c = null;
        
        if (String.isNotBlank(qdm.parentRec.ShipmentAccount__c)) {
            List<Account> accounts = [SELECT DistanceZone__c, DistanceSection__c FROM Account WHERE id =: qdm.parentRec.ShipmentAccount__c];
            if (accounts != null && accounts.size() > 0) {
                Account targetAccount = accounts.get(0);
                qdm.parentRec.ShipmentDistanceZone__c = targetAccount.DistanceZone__c;
                qdm.parentRec.ShipmentDistanceSection__c = targetAccount.DistanceSection__c;
            }
            
        }
    }
    
    public void includeDestinationData() {
        qdm.parentRec.DestinationAccountCode__c = qdm.parentRec.ContractCode__c;
        qdm.parentRec.DestinationAccountName__c = qdm.parentRec.ContractName__c;
        qdm.parentRec.DestinationAddress__c = qdm.parentRec.ContractAddress__c;
        qdm.parentRec.DestinationPostalCode__c = qdm.parentRec.ContractPostalCode__c;
        qdm.parentRec.DestinationUndergraduate__c = qdm.parentRec.ContractUndergraduate__c;

        qdm.parentRec.DestinationName__c = qdm.parentRec.ContractPersonInCharge__c;
        qdm.parentRec.DestinationNameTitle__c = qdm.parentRec.Addressee__c;
        qdm.parentRec.DestinationBelong__c = qdm.parentRec.ContractBelong__c;
        if (qdm.parentRec.SalesPerson__r != null) {
            qdm.parentRec.DestinationPersonInCharge__c = qdm.parentRec.SalesPerson__r.Name;
        }
    }

    private QuotationInformation__c createNewRecord() {
        QuotationInformation__c newRecord = new QuotationInformation__c();
        newRecord.GroupLeaderApproval__c = true;
        newRecord.BranchManagerApproval__c = true;
        newRecord.TotalAmount__c = 0;
        newRecord.Subtitle__c = 0;
        newRecord.ConsumptionTaxAmount__c = 0;
        newRecord.TotalTaxAmount__c = 0;
        TaxSetting__c taxSetting = TaxSetting__c.getOrgDefaults();
        newRecord.TaxRate__c = taxSetting.TaxationRate__c;
        if (newRecord.TaxRate__c == null) {
            newRecord.TaxRate__c = 0;
        }
        ////Modification-VAIB-Begin(2015/05/20 UAT_QA_List No.19)-Part1/2
        newRecord.DeliveryPeriod__c = null;
        newRecord.QuoteValidityPeriod__c = 1;
        ////Modification-VAIB-End(2015/05/20 UAT_QA_List No.19)-Part1/2
        return newRecord;
    }
    private QuotationInformation__c getTargetRecord(String targetId) {
        QuotationInformation__c targetaRecord = null;
        List<QuotationInformation__c> recs = [
            SELECT
                id, name, RecordTypeId, RecordType.Name, CurrencyIsoCode, LastModifiedDate, CreatedDateFormula__c, SalesPerson__c, SalesPerson__r.Name,
                CustomerQuotationRequestedNo__c,TotalAmount__c, ContractCode__c, ContractAddress__c, ContractBelong__c,
                ContractPersonInCharge__c, ContractPhone__c, ContractFax__c, ContractName__c, ContractName1__c, ContractName2__c, ContractShortName__c, ContractPost__c,
                Series__c, QuoteNo__c, QuotationRequestedDate__c, QuotationType__c, PostalCode__c, Phone__c,
                SalesAssistant__c, GroupLeaderApproval__c, BranchManagerApproval__c, PrintedDate__c,
                BranchNo__c, SalesArea__c, RegisterDate__c, ShipmentCode__c, ShipmentAddress__c, ShipmentBelong__c,
                ShipmentPersonInCharge__c, ShipmentPhone__c, ShipmentFax__c, ShipmentName__c, ShipmentName1__c, ShipmentName2__c, ShipmentShortName__c, ShipmentPost__c, IssueDate__c, DepartmentCode__c,
                DepartmentName__c, OverrideDepartmentCode__c, OverrideDepartmentName__c, createdById, createdBy.name, OrgName__c, Address__c, AddressLine1__c, AddressLine2__c, AddressLine3__c, Subtitle__c, Note__c, Memo__c,
                CustomReductionName1__c, CustomReductionAmount1__c, CustomReductionName2__c, Fax__c, OtherText__c, SalesAreaCode__c,
                CustomReductionAmount2__c, CustomReductionName3__c, CustomReductionAmount3__c, ConsumptionTaxAmount__c,
                TotalTaxAmount__c, TaxRate__c, CalendarExpress__c, DepartmentOutput__c, RepresentativeNameExpress__c, ReferenceExpress__c,
                CustomerExpress__c, Addressee__c, Addressee2__c, PriceExpress__c, ProductCodeExpress__c, QuotationTypeText__c, 
                DeliveryLocationSection__c, DeliveryLocationText__c, DeliveryCondition1__c, DeliveryCondition2__c, DeliveryPeriod__c,
                DeliveryDeadline__c, DeliveryDate_Arbitrarily__c, PaymentConditionSection__c, PaymentConditionText__c,
                QuoteValidityPeriod__c, QuoteExpirationDate__c, quoteExpirationDate_Arbitrarily__c, UnitBody__c, SupervisorName__c, SupervisorPosition__c,
                OverrideDepartmentOutputText__c, SubtitleLabel__c, TaxExemptionTextOutput__c, OutputTotalTaxAmount__c,
                SubtotalReductionName1__c, SubtotalReductionAmount1__c, OutputSubtotalReduction1__c,
                SubtotalReductionName2__c, SubtotalReductionAmount2__c, OutputSubtotalReduction2__c,
                TotalAmountName__c, TotalTaxAmountName__c,
                OutputConsumptionTaxAmount__c, OutputTotalAmount__c, OutputSubtitle__c, KeikaNensu__c, AcceptanceDate__c, UnitBodyKikaku__c,
                UnitbodyExpress__c, ContractAccount__c, ContractAccount_dummyField__c, ContractAccount__r.Name, ShipmentAccount__c, ShipmentAccount_dummyField__c, ShipmentAccount__r.Name, ContractContact_dummyField__c, ShipmentContact_dummyField__c,
                SalesPipeLineLkup__c, GuideSheetPrint__c, DestinationUndergraduate__c, DestinationNameTitle__c,
                DestinationGuideSubject__c, DestinationAccountCode__c, DestinationAccountName__c, DestinationName__c,
                DestinationAddress__c, DestinationBelong__c, DestinationPersonInCharge__c, DestinationGuideDate__c,
                DestinationPostalCode__c, ContractPostalCode__c, ContractUndergraduate__c, ShipmentPostalCode__c,
                ShipmentUndergraduate__c, DirectSalesExpress__c, DirectSalesSheetIssueDate__c, RegulerPriceExpress__c,
                RegulerPriceSheetIssueDate__c, RegulerPriceCommentExpress__c, QuotationNameExpress__c, ShipmentDistanceZone__c,
                ShipmentDistanceSection__c, CommissionAmount__c, CommissionRate__c, IsDisplayDecimal__c, HyomenNebikiRitsu__c,
                KeiyakuStartDate__c, KeiyakuEndDate__c, HoshuShurui__c
            FROM
                QuotationInformation__c
            WHERE
                Id =: targetId
        ]; 
        if (recs != null && recs.size() > 0) {
            targetaRecord = recs.get(0);
            address = (targetaRecord.AddressLine1__c == null ? '' : targetaRecord.AddressLine1__c) + (targetaRecord.AddressLine2__c == null ? '' : ' ' + targetaRecord.AddressLine2__c) + (targetaRecord.AddressLine3__c == null ? '' : ' ' + targetaRecord.AddressLine3__c);
            ReprNameExpress1 = targetaRecord.RepresentativeNameExpress__c;
            ReprNameExpress2 = targetaRecord.RepresentativeNameExpress__c;
        } else {
            throw new JEOLException('不正な操作が行われました。');
        }
        return targetaRecord;
    }
    
    public void ajaxSaveAction() {
        saveAction();
        qdm.baseParentRec = qdm.parentRec.clone(true);
        qdm.baseItems = qdm.items.clone();
    }
    
    public void deleteMultiRows() {
        if (listRowToDel == null || listRowToDel.length() == 0)
        {
            return;
        }
        List<String> lsRow = listRowToDel.split(',');

        For (QuotationDetailItem det : qdm.items)
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
    
        scrollTopValue = 0;
system.debug('saveAction: Start');
        Pagereference ref = null;
        Savepoint sp = Database.setSavepoint();

        try {
            if (String.isBlank(userSetting.id)) {
                insert userSetting;
            }
            qdm.refresh();
            List<String> errorFields = qdm.requireCheck(isReadOnly);
            if (errorFields.size() > 0) {
                String errorText = null;
                for (String field: errorFields) {
                    if (String.isBlank(errorText)) {
                        errorText ='未入力項目があります。';
                    } else {
                        errorText += ',';
                    }
                    errorText += '['+field+']';
                }
                throw new JEOLException(errorText);
            }
            QuotationInformation__c parentRec = qdm.parentRec;
            
            //Modification-VAIB-Begin(2015/05/25 UAT_QA_List No.64)
            if (parentRec.Id != null)
            {
                QuotationInformation__c refreshedParentRec = [SELECT Id, Name, LastModifiedDate FROM QuotationInformation__c WHERE Id=:parentRec.Id];
                if(parentRec.LastModifiedDate != refreshedParentRec.LastModifiedDate)
                    throw new JEOLException('レコードが変更されていますので、開き直してから再度操作をして下さい');
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
                        
            //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.44)
            parentRec.IsDisplayDecimal__c = userSetting.IsDisplayDecimal__c;
            //Modification-VAIB-End(2015/05/21 UAT_QA_List No.44)
            NumberingMaster__c numberingRec = null;
            if (String.isBlank(qdm.parentRec.id) && (!this.isCopy || this.isCopy && !this.isBranch)) {
                String prefix = qdm.parentRec.QuoteNo__c;
                numberingRec = JEOLUtil.getTargetMaster(JEOLUtil.NUMBERING_MASTER_KEY_QUOTE_NO, prefix , null);
                if (numberingRec != null) {
                    String targetQuoteNo = JEOLUtil.nextNumberingValue(numberingRec);
                    List<QuotationInformation__c> parentRecs = [SELECT id FROM QuotationInformation__c WHERE QuoteNo__c =: targetQuoteNo];
                    if (parentRecs.size() > 0) {
                        throw new JEOLException('採番に失敗しました。');
                    }
                    qdm.parentRec.QuoteNo__c = targetQuoteNo;
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
            parentRec.QuoteNo_BranchNo_Sync__c = qdm.parentRec.QuoteNo__c + '_' + qdm.parentRec.BranchNo__c;
            if (parentRec.Name == null) {
                parentRec.Name = parentRec.QuoteNo_BranchNo_Sync__c;
            }
            
            parentRec.ContractContact_dummyField__c = null;
            parentRec.ShipmentContact_dummyField__c = null;
            
            if (!isReadOnly) {
                // Put to NULL the fields depending on QuotationType
                if (parentRec.QuotationType__c != 'B09' && parentRec.QuotationType__c != 'B18') {
                    parentRec.KeiyakuStartDate__c = null;
                    parentRec.KeiyakuEndDate__c = null;
                    parentRec.HoshuShurui__c = null;
                }
                
                // Change the Linkage Status
                parentRec.LinkageStatus__c = '未連携';
            }
            
system.debug('Save: ' + parentRec.ContractAccount__c + ' +++ ' + parentRec);
            upsert parentRec;

            if (numberingRec != null) {
                JEOLUtil.numberingUpdate(numberingRec);
            }

            //Modification-VAIB-Begins(2015/05/29 UAT_QA_List No.64)
            qdm.parentRec = getTargetRecord(parentRec.Id);
            //Modification-VAIB-Ends(2015/05/25 UAT_QA_List No.64)

            List<QuotationDetailInformation__c> details = new List<QuotationDetailInformation__c>();
            for (QuotationDetailItem item: qdm.items) {
                QuotationDetailInformation__c rec = item.rec;
                if (rec.parent__c != parentRec.id) {
                    rec.parent__c = parentRec.id;
                }
                details.add(rec);
            }
    
            List<QuotationDetailInformation__c> deleteTargets = new List<QuotationDetailInformation__c>();
            for (QuotationDetailItem item: qdm.baseItems) {
                if (item.isDeleted) {
                    deleteTargets.add(item.rec);
                }
            }
            if (details.size() > 0) {
                upsert details;
            }
            if (deleteTargets.size() > 0) {
                delete deleteTargets;
            }
            ref = Page.JEOL_QuotationEditorPage;
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
            Database.rollback(sp);
            return null;
        }
        return ref;
    }

/*
    public void doSaveWithPrintDate() {
        qdm.parentRec.PrintedDate__c = date.today();
        ajaxSaveAction();

        Pagereference ref = this.getPrintUrl();
        Blob pdfData = ref.getContent();
        Attachment attachRec = new Attachment();
        attachRec.parentId = qdm.parentRec.id;
        attachRec.name = qdm.parentRec.name + '.pdf';
        attachRec.body = pdfData;
        insert attachRec;
    }
*/

    public void doSaveWithPrintDatePart1() {
        qdm.parentRec.PrintedDate__c = date.today();
        ajaxSaveAction();
    }

    public void doSaveWithPrintDatePart2() {
        Pagereference ref = this.getPrintUrl();
        Blob pdfData;
        if (!Test.IsRunningTest()) {
            pdfData = ref.getContent();
        } else {
            pdfData = Blob.valueOf('UNIT.TEST');
        }        
        Attachment attachRec = new Attachment();
        attachRec.parentId = qdm.parentRec.id;
        attachRec.name = qdm.parentRec.name + '.pdf';
        attachRec.body = pdfData;
        insert attachRec;
    }
/*    
    public void doSaveWithDestinationPrintDate() {
        //qdm.parentRec.PrintedDate__c = date.today();
        ajaxSaveAction();

        Pagereference ref = this.getDestinationPrintUrl();
        Blob pdfData = ref.getContent();
        Attachment attachRec = new Attachment();
        attachRec.parentId = qdm.parentRec.id;
        attachRec.name = '送付案内状.pdf';
        attachRec.body = pdfData;
        insert attachRec;
    }
*/
    public void doSaveWithDestinationPrintDatePart1() {
        //qdm.parentRec.PrintedDate__c = date.today();
        ajaxSaveAction();
    }

    public void doSaveWithDestinationPrintDatePart2() {
        Pagereference ref = this.getDestinationPrintUrl();
        Blob pdfData;
        if (!Test.IsRunningTest()) {
            pdfData = ref.getContent();
        } else {
            pdfData = Blob.valueOf('UNIT.TEST');
        }        
        Attachment attachRec = new Attachment();
        attachRec.parentId = qdm.parentRec.id;
        attachRec.name = '送付案内状.pdf';
        attachRec.body = pdfData;
        insert attachRec;
    }

/*  
    public void doSaveWithCertificationPrintDate() {
        //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.44)
        //Date d = date.today();
        //if (qdm.parentRec.DirectSalesExpress__c) {
        //    qdm.parentRec.DirectSalesSheetIssueDate__c = d;
        //}
        //if (qdm.parentRec.RegulerPriceExpress__c) {
        //    qdm.parentRec.RegulerPriceSheetIssueDate__c = d;
        //}
        //Modification-VAIB-End(2015/05/21 UAT_QA_List No.44)
        ajaxSaveAction();

        Pagereference ref = this.getCertificationPrintUrl();
        Blob pdfData = ref.getContent();
        Attachment attachRec = new Attachment();
        attachRec.parentId = qdm.parentRec.id;
        attachRec.name = '直販／定価販売証明書.pdf';
        attachRec.body = pdfData;
        insert attachRec;
    }
*/

    public void doSaveWithCertificationPrintDatePart1() {
        //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.44)
        //Date d = date.today();
        //if (qdm.parentRec.DirectSalesExpress__c) {
        //    qdm.parentRec.DirectSalesSheetIssueDate__c = d;
        //}
        //if (qdm.parentRec.RegulerPriceExpress__c) {
        //    qdm.parentRec.RegulerPriceSheetIssueDate__c = d;
        //}
        //Modification-VAIB-End(2015/05/21 UAT_QA_List No.44)
        ajaxSaveAction();
    }

    public void doSaveWithCertificationPrintDatePart2() {
        Pagereference ref = this.getCertificationPrintUrl();
        Blob pdfData;
        if (!Test.IsRunningTest()) {
            pdfData = ref.getContent();
        } else {
            pdfData = Blob.valueOf('UNIT.TEST');
        }
        Attachment attachRec = new Attachment();
        attachRec.parentId = qdm.parentRec.id;
        attachRec.name = '直販／定価販売証明書.pdf';
        attachRec.body = pdfData;
        insert attachRec;
    }

    public Pagereference deleteAction() {
        QuotationInformation__c parentRec = qdm.parentRec;
        delete parentRec;
        return Page.JEOL_QuotationListPage;
    }

    public UserSetting__c getUserSettingRecord(){
        UserSetting__c targetaRecord = null;
        String userId = UserInfo.getUserId();
        List<UserSetting__c> userSettings = [
                SELECT
                    Word1__c,
                    Word2__c,
                    Word3__c,
                    WordSettingDefaultDisplay1__c,
                    WordSettingDefaultDisplay2__c,
                    WordSettingDefaultDisplay3__c,
                    ProductDivision__c,
                    QuotationNameExpress__c,
                    IsDisplayDecimal__c,
                    DefaultRowsItems__c,
                    DefaultRowsHeading__c,
                    DefaultRowsSubItems__c
                FROM
                    UserSetting__c
                WHERE
                    OwnerId =: userId
        ];
        if (userSettings != null && userSettings.size() > 0) {
            targetaRecord = userSettings.get(0);
        }
        if(targetaRecord == null) {
            //新規レコード作成
            targetaRecord = new UserSetting__c();
            targetaRecord.WordSettingDefaultDisplay1__c = '非表示';
            targetaRecord.WordSettingDefaultDisplay2__c = '非表示';
            targetaRecord.WordSettingDefaultDisplay3__c = '非表示';
            targetaRecord.ProductDivision__c = '製品';
            targetaRecord.QuotationNameExpress__c = false;
            targetaRecord.IsDisplayDecimal__c = false;
        }
        if (targetaRecord.DefaultRowsItems__c == null) targetaRecord.DefaultRowsItems__c = 0;
        if (targetaRecord.DefaultRowsHeading__c == null) targetaRecord.DefaultRowsHeading__c = 0;
        if (targetaRecord.DefaultRowsSubItems__c == null) targetaRecord.DefaultRowsSubItems__c = 0;
        
        inputDefaultRowsItems = targetaRecord.DefaultRowsItems__c.toPlainString();
        inputDefaultRowsHeading = targetaRecord.DefaultRowsHeading__c.toPlainString();
        inputDefaultRowsSubItems = targetaRecord.DefaultRowsSubItems__c.toPlainString();
        
        return targetaRecord;
    }
    
    @RemoteAction
    public static List<ProductItem__c> getProductMaster(Map<String, String> values) {
        List<String> conditions = new List<String>();
        if (values.containsKey('JapaneseName__c') && String.isNotBlank(values.get('JapaneseName__c'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('JapaneseName__c', values.get('JapaneseName__c')));
        }
        if (values.containsKey('Name') && String.isNotBlank(values.get('Name'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('Name', values.get('Name')));
        }
        if (values.containsKey('Division__c') && String.isNotBlank(values.get('Division__c'))) {
            conditions.add(JEOLUtil.appendEqualText('Division__c', values.get('Division__c')));
        }        
        if (values.containsKey('ModelType__c') && String.isNotBlank(values.get('ModelType__c'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('ModelType__c', values.get('ModelType__c')));
        }
        conditions.add('IsDisplayed__c = true');
        
        List<ProductItem__c> productMasters = Database.query(PRODUCT_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + ' ORDER BY Name LIMIT 10000');
        return productMasters;
    }

    @RemoteAction
    public static ProductItem__c searchProductItem(String productCode) {
        ProductItem__c ret = null;
        if (String.isNotBlank(productCode))
        {
            List<ProductItem__c> recs = [SELECT id, JapaneseName__c, Name, UnitPrice__c, Division__c, Tani__c, Model__c, ModelType__c FROM ProductItem__c WHERE Name =: productCode AND IsDisplayed__c = true];
            if (recs != null && recs.size() > 0) {
                
                Map<String, String> transformValues = new Map<String, String>();
                List<SelectListManage__c> mangesRecs = JEOLUtil.getSelectListRecs(JEOLUtil.REFERENCE_NAME_QUOTATION_QUANTITY_UNIT);
                for (SelectListManage__c manageRec: mangesRecs) {
                    if (String.isNotBlank(manageRec.value__c)) {
                        transformValues.put(manageRec.value__c, manageRec.label__c);
                    }
                }            

                for (ProductItem__c rec: recs) {
                    ret = rec;

                    String quantityUnit = (String)ret.Tani__c;
                    if (String.isNotBlank(quantityUnit) && transformValues.containsKey(quantityUnit)) {
                        quantityUnit = transformValues.get(quantityUnit);
                    }
                    ret.Tani__c = quantityUnit;
                }
            }
        }
        return ret;
    }

    @RemoteAction
    public static List<QuotationInformation__c> getQuotationInfo(Map<String, String> values) {
        List<String> conditions = new List<String>();
        if (values.containsKey('Name') && String.isNotBlank(values.get('Name'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('name', values.get('Name')));
        }
        if (values.containsKey('QuoteNo__c') && String.isNotBlank(values.get('QuoteNo__c'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('QuoteNo__c', values.get('QuoteNo__c')));
        }
        if (values.containsKey('BranchNo__c') && String.isNotBlank(values.get('BranchNo__c'))) {
            conditions.add(JEOLUtil.appendEqualText('BranchNo__c', values.get('BranchNo__c')));
        }
        if (values.containsKey('CreatedDateFormula__c') && String.isNotBlank(values.get('CreatedDateFormula__c'))) {
            conditions.add('CreatedDateFormula__c=' + values.get('CreatedDateFormula__c').replace('/', '-'));
        }
        List<QuotationInformation__c> quoteRecs = Database.query(QUOTATION_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + ' LIMIT 10000');
        return quoteRecs;
    }

    @RemoteAction
    public static List<QuotationDetailInformation__c> getQuotationDetails(Map<String, String> values) {
        List<QuotationDetailInformation__c> details  = null;
        List<String> conditions = new List<String>();
        if (values.containsKey('Parent__c') && String.isNotBlank(values.get('Parent__c'))) {
            conditions.add(JEOLUtil.appendEqualText('Parent__c', values.get('Parent__c')));
    
            details = Database.query(QUOTATION_DETAIL_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY SortNo__c LIMIT 10000');
        }
        return details;
    }

    @RemoteAction
    public static List<ProductCatalog__c> getCatalogHead(Map<String, String> values) {
    
        List<ProductCatalog__c> catalogItems  = null;
        List<String> conditions = new List<String>();
        if (values.containsKey('ClassificationNo__c') && String.isNotBlank(values.get('ClassificationNo__c'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('ClassificationNo__c', values.get('ClassificationNo__c')));
        }
        if (values.containsKey('SearchKeyWord__c') && String.isNotBlank(values.get('SearchKeyWord__c'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('SearchKeyWord__c', values.get('SearchKeyWord__c')));
        }
        if (values.containsKey('ProductCatalog__c') && String.isNotBlank(values.get('ProductCatalog__c'))) {
            conditions.add(JEOLUtil.appendAfterLikeText('ProductCatalog__c', values.get('ProductCatalog__c')));
        }
        conditions.add('Position__c = 1');
        catalogItems = Database.query(PRODUCT_CATALOG_ITEMS_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY Position__c LIMIT 10000');
        return catalogItems;
    }
    
    @RemoteAction
    public static List<ProductCatalog__c> getChildStructure(String Structure, String position) {
        List<ProductCatalog__c> catalogItems  = null;
        List<String> conditions = new List<String>();
        if (String.isNotBlank(Structure)) {
            conditions.add(JEOLUtil.appendEqualText('CatalogStructure__c', Structure));
//            conditions.add('Position__c != 1');
            catalogItems = Database.query(PRODUCT_CATALOG_ITEMS_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY Position__c LIMIT 10000');
        }
        return catalogItems;
    }

    @RemoteAction
    public static List<ProductCatalog__c> getChildCatalogStructure(String ProductCatalog, String Structure, String position) {
        List<ProductCatalog__c> catalogItems  = null;
        List<String> conditions = new List<String>();
        if (String.isNotBlank(Structure)) {
            conditions.add(JEOLUtil.appendEqualText('ProductCatalog__c', ProductCatalog));
            conditions.add(JEOLUtil.appendEqualText('CatalogStructure__c', Structure));
//            conditions.add('Position__c != 1');
            catalogItems = Database.query(PRODUCT_CATALOG_ITEMS_BASE_QUERY + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY Position__c LIMIT 10000');
        }
        return catalogItems;
    }


    @RemoteAction
    public static List<string> getSuggestions(String productcode) {
        productcode = productcode + '%';
        List<ProductItem__c> recs = [SELECT Name, JapaneseName__c FROM ProductItem__c WHERE Name like :productCode AND IsDisplayed__c = true ORDER By Name LIMIT 20];
        List<string> lsReturn = new List<string>();
        for (ProductItem__c rec : recs)
        {
            lsReturn.add(rec.Name + ',' + rec.JapaneseName__c);
        }
        return lsReturn;
    }
    
    public Pagereference getPreviewUrl() {
        Pagereference ret = Page.JEOL_QuotationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('preview', 'true');
        return ret;
    }
    public Pagereference getPrintUrl() {
        Pagereference ret = Page.JEOL_QuotationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('print', 'true');
        return ret;
    }
    public Pagereference getDestinationPreviewUrl() {
        Pagereference ret = Page.JEOL_QuotationDestinationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('preview', 'true');
        return ret;
    }
    public Pagereference getDestinationPrintUrl() {
        Pagereference ret = Page.JEOL_QuotationDestinationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('print', 'true');
        return ret;
    }
    public Pagereference getCertificationPreviewUrl() {
        Pagereference ret = Page.JEOL_QuotationCertificationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('preview', 'true');
        return ret;
    }
    public Pagereference getCertificationPrintUrl() {
        Pagereference ret = Page.JEOL_QuotationCertificationPrintPage;
        Map<String, String> params = ret.getParameters();
        params.put(PARAM_ID, qdm.ParentRec.id);
        params.put('print', 'true');
        return ret;
    }
    public void UserSettingSave() {
    
        // Validation of DefaultRowsItems__c
        try
        {
            Integer iTemp = integer.valueof(inputDefaultRowsItems);
            if (iTemp < 0) {
                userSetting.DefaultRowsItems__c = 0;
            } else if (iTemp > 99) {
                userSetting.DefaultRowsItems__c = 99;
            } else {
                userSetting.DefaultRowsItems__c = iTemp;
            }
        } catch (Exception ex) {
            userSetting.DefaultRowsItems__c = 0;
        }
        inputDefaultRowsItems = userSetting.DefaultRowsItems__c.toPlainString();
    
        // Validation of DefaultRowsHeading__c
        try
        {
            Integer iTemp = integer.valueof(inputDefaultRowsHeading);
            if (iTemp < 0) {
                userSetting.DefaultRowsHeading__c = 0;
            } else if (iTemp > 99) {
                userSetting.DefaultRowsHeading__c = 99;
            } else {
                userSetting.DefaultRowsHeading__c = iTemp;
            }                
        } catch (Exception ex) {
            userSetting.DefaultRowsHeading__c = 0;
        }
        inputDefaultRowsHeading = userSetting.DefaultRowsHeading__c.toPlainString();
    
        // Validation of DefaultRowsSubItems__c
        try
        {
            Integer iTemp = integer.valueof(inputDefaultRowsSubItems);
            if (iTemp < 0) {
                userSetting.DefaultRowsSubItems__c = 0;
            } else if (iTemp > 99) {
                userSetting.DefaultRowsSubItems__c = 99;
            } else {
                userSetting.DefaultRowsSubItems__c = iTemp;
            }                
        } catch (Exception ex) {
            userSetting.DefaultRowsSubItems__c = 0;
        }
        inputDefaultRowsSubItems = userSetting.DefaultRowsSubItems__c.toPlainString();
    
        upsert userSetting;
    }
    public class QuotationDetailManage {
        private List<QuotationDetailItem> items = new List<QuotationDetailItem>();
        private List<QuotationDetailItem> baseItems = new List<QuotationDetailItem>();
        public QuotationInformation__c parentRec{get; set;}
        public QuotationInformation__c baseParentRec{get; set;}
        public String createdItemInfos{get; set;}
        public String selectedQuotationId{get; set;}
        public String targetAccountId{get; set;}
        

        public QuotationDetailManage(QuotationInformation__c parentRec) {
            this(parentRec, false);
        }
        public QuotationDetailManage(QuotationInformation__c parentRec, Boolean isCopy) {
            this(parentRec, false, false);
        }
        public QuotationDetailManage(QuotationInformation__c parentRec, Boolean isCopy, Boolean isBranch) {
            List<QuotationDetailInformation__c> recs = this.getDetailRecs(parentRec.id);
            if (recs == null) {
                recs = new List<QuotationDetailInformation__c>();
            }
            List<QuotationDetailItem> localItems = this.items;
            for (QuotationDetailInformation__c rec: recs) {
                if (isCopy) {
                    rec = rec.clone(false,true,false,false);
                }
                QuotationDetailItem item = new QuotationDetailItem(rec);
                localItems.add(item);
            }
            if (isCopy && isBranch) {
                parentRec = parentRec.clone(false,true,false,false);
                parentRec.SalesOrder__c = null;
                
                QuotationInformation__c biggestBranchNoRec = [SELECT BranchNo__c FROM QuotationInformation__c WHERE QuoteNo__c =: parentRec.QuoteNo__c ORDER BY BranchNo__c DESC LIMIT 1];
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
                parentRec.SalesOrder__c = null;
                
                if (String.isNotBlank(parentRec.QuoteNo__c) && parentRec.QuoteNo__c.length() > QUOTE_NO_PREFIX_LENGTH) {
                    parentRec.QuoteNo__c = parentRec.QuoteNo__c.left(QUOTE_NO_PREFIX_LENGTH);
                    parentRec.BranchNo__c = '01';
                }
            } else {
                this.baseItems = localItems.clone();
            }
            
            this.parentRec = parentRec;
            this.baseParentRec =  this.parentRec.clone(true);
        }
        
        public List<String> requireCheck(boolean isReadOnly) {
            QuotationInformation__c rec = this.parentRec;
            List<String> checkList = new List<String>();
            
            // Do not make the check for read only mode
            if (isReadOnly) {
                return checkList;            
            }
            if (String.isBlank(rec.QuotationType__c)) {
                checkList.add('見積種別');
            }
            if ((!(rec.DeliveryPeriod__c != null && rec.DeliveryPeriod__c > 0)) && rec.DeliveryDeadline__c == null && String.isBlank(rec.DeliveryDate_Arbitrarily__c)) {
                checkList.add('納入期日');
            }
            if ((!(rec.QuoteValidityPeriod__c != null && rec.QuoteValidityPeriod__c > 0) ) && rec.QuoteExpirationDate__c == null && String.isBlank(rec.QuoteExpirationDate_Arbitrarily__c)) {
                checkList.add('見積有効期間');
            }
            if (String.isBlank(rec.DepartmentCode__c)) {
                checkList.add('部署');
            }
            if (String.isBlank(rec.Series__c)) {
                checkList.add('系列');
            }
            if (String.isBlank(rec.SalesAreaCode__c)) {
                checkList.add('地域');
            }
            if (String.isBlank(rec.ContractCode__c)) {
                checkList.add('契約先：取引先コード');
            }
            if (String.isBlank(rec.ShipmentCode__c)) {
                checkList.add('納入先：取引先コード');
            }
            return checkList;
        }
        private List<QuotationDetailInformation__c> getDetailRecs(String parentId) {
            List<QuotationDetailInformation__c> recs = [
                    SELECT 
                        id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c,
                        Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode,
                        productCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c,
                        IsShowDetailAmount__c, DiscountRate__c, DiscountAmount__c, TotalDiscountAmount__c,
                        AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c
                    FROM 
                        QuotationDetailInformation__c 
                    WHERE 
                        Parent__c =: parentId 
                    ORDER BY
                        SortNo__c, Depth__c Asc
            ];
            return recs;
        }
        
        public List<QuotationDetailItem> getItems() {
            refresh();
            return this.items;
        }
        public List<QuotationDetailItem> getBaseItems() {
            return this.baseItems;
        }
        
        public void createQuotationDetail() {
            QuotationDetailInformation__c detail = createInitalizedRecord();
            detail.Type__c = '1';
            detail.IsTaxationTarget__c = true;
            detail.IsShowDetailAmount__c = true;
            items.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetail() {
            QuotationDetailInformation__c detail = createInitalizedRecord();
            detail.Type__c = '2';
            items.add(new QuotationDetailItem(detail));
        }
        public void createOverheadDetail() {
            QuotationDetailInformation__c detail = createInitalizedRecord();
            detail.Body__c = '諸経費';
            detail.Type__c = '3';
            detail.QuantityUnit__c = '%';
            detail.IsTaxationTarget__c = true;
            items.add(new QuotationDetailItem(detail));
        }
        public void createSubtotalDetail() {
            QuotationDetailInformation__c detail = createInitalizedRecord();
            detail.Body__c = '小計';
            detail.Type__c = '4';
            items.add(new QuotationDetailItem(detail));
        }
        public void createCommissionDetail() {
            QuotationDetailInformation__c detail = createInitalizedRecord();
            detail.Body__c = '口銭';
            detail.Type__c = '5';
            detail.QuantityUnit__c = '%';
            detail.IsTaxationTarget__c = true;
            items.add(new QuotationDetailItem(detail));
        }
        public QuotationDetailInformation__c createInitalizedRecord() {
            QuotationDetailInformation__c detail = new QuotationDetailInformation__c();
            detail.SortNo__c = items.size();
            detail.Depth__c = 0;
            detail.Amount__c = 0;
            detail.Parent__c = this.parentRec.id;
            detail.CurrencyIsoCode = this.parentRec.CurrencyIsoCode;
            detail.Quantity__c = 0;
            detail.Quantity__c = 0;
            detail.QuantityUnit__c = null;
            detail.UnitPrice__c = 0;
            detail.DiscountRate__c = 0;
            detail.DiscountAmount__c = 0;
            detail.TotalDiscountAmount__c = 0;
            detail.CertificationExpress__c = true;
            return detail;
        }
        public Integer getCurrentSize() {
            return items.size();
        }
        
        public void refreshDetailProductItem() {
            List<QuotationDetailItem> details = this.items;
            Map<String, List<QuotationDetailInformation__c>> productItemDetails = new Map<String, List<QuotationDetailInformation__c>>();
            for (QuotationDetailItem detail: details) {
                if (detail.getDetailType() == '1') {
                    String productCode = detail.rec.productCode__c;
                    if (String.isNotBlank(productCode)) {
                        if (!productItemDetails.containsKey(productCode)) {
                            productItemDetails.put(productCode, new List<QuotationDetailInformation__c>());
                        }
                        productItemDetails.get(productCode).add(detail.rec);
                    }
                }
            }
            if (productItemDetails.size() > 0) {
                Map<String, String> transformValues = new Map<String, String>();
                List<SelectListManage__c> mangesRecs = JEOLUtil.getSelectListRecs(JEOLUtil.REFERENCE_NAME_QUOTATION_QUANTITY_UNIT);
                for (SelectListManage__c manageRec: mangesRecs) {
                    if (String.isNotBlank(manageRec.value__c)) {
                        transformValues.put(manageRec.value__c, manageRec.label__c);
                    }
                }            
            
                Set<String> productCodeSet = productItemDetails.keySet();
                List<ProductItem__c> productItems = [SELECT id, JapaneseName__c, Name, UnitPrice__c, Division__c, Tani__c, Model__c, ModelType__c FROM ProductItem__c WHERE Name IN: productCodeSet AND IsDisplayed__c = true];
                for (ProductItem__c item: productItems) {
                    if (productItemDetails.containsKey(item.Name)) {
                        List<QuotationDetailInformation__c> targetDetails = productItemDetails.get(item.Name);
                        for (QuotationDetailInformation__c detailRec: targetDetails) {
                            detailRec.UnitPrice__c = item.UnitPrice__c;
                            

                            List<String> bodyTexts = new List<String>();
                            if (parentRec.QuotationType__c != null && parentRec.QuotationType__c.length() > 0 && (parentRec.QuotationType__c.left(1) == 'a' || parentRec.QuotationType__c.left(1) == 'A'))
                            {
                                String modelType = item.ModelType__c;
                                if (String.isNotBlank(modelType)) {
                                    bodyTexts.add(modelType);
                                }
                            }
                            String japaneseName = item.JapaneseName__c;
                            if (String.isNotBlank(japaneseName)) {
                                bodyTexts.add(japaneseName);
                            }
                            detailRec.Body__c = String.join(bodyTexts, ' ');                         
                            //detailRec.Body__c = item.JapaneseName__c;

                            String quantityUnit = (String)item.Tani__c;
                            if (String.isNotBlank(quantityUnit) && transformValues.containsKey(quantityUnit)) {
                                quantityUnit = transformValues.get(quantityUnit);
                            }
                            detailRec.QuantityUnit__c = quantityUnit;
                            
                            if (detailRec.Quantity__c == null || detailRec.Quantity__c == 0) {
                                detailRec.Quantity__c = 1;
                            }
                        }
                    }
                }
            }
        }
        public void importDetailFromQuotation() {
            String targetId = this.selectedQuotationId;
            List<QuotationDetailItem> localItems = this.items;
            List<QuotationDetailInformation__c> targetRecs = this.getDetailRecs(targetId);
            Integer sortNo = localItems.size();
            for (QuotationDetailInformation__c rec:targetRecs) {
                rec = rec.clone(false, true, false, false);
                rec.sortNo__c = sortNo;
                QuotationDetailItem item = new QuotationDetailItem(rec);
                localItems.add(item);
                sortNo++;
            }
            this.selectedQuotationId = null;
        }
        public void createSelectedProductItemDetails() {
            Map<String, Object> infoData = (Map<String, Object>)JSON.deserializeUntyped(this.createdItemInfos);
            this.createdItemInfos = null;
            String targetSortNo = (String)infoData.get('sortNo');
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
            Integer addNo = 0;
            if (sortNo != null) {
                List<QuotationDetailItem> details = this.items;
                List<QuotationDetailItem> newDetails = new List<QuotationDetailItem>();
                for (QuotationDetailItem detail: details) {
                    if (detail.rec.sortNo__c == sortNo) {
                        Integer detailSize = selectedItems.size();
                        List<QuotationDetailItem> targetDetails = new QuotationDetailItem[detailSize];
                        targetDetails[0] = detail;
                        for (Integer i = 0; i < detailSize; i++) {
                            QuotationDetailItem targetDetail = targetDetails[i];
                            Map<String, Object> item = (Map<String, Object>)selectedItems[i];
                            if (targetDetail == null) {
                                QuotationDetailInformation__c rec = createInitalizedRecord();
                                Integer addDepth = 0;
                                if (item.containsKey('depth')) {
                                    addDepth = (Integer)item.get('depth');
                                }
                                rec.sortNo__c = detail.rec.sortNo__c + i;
                                rec.depth__c = detail.rec.depth__c + addDepth;
                                if (rec.depth__c > 5) {
                                    rec.depth__c = 5;
                                }
                                rec.Type__c = '1';
                                rec.IsTaxationTarget__c = true;
                                rec.IsShowDetailAmount__c = true;
                                targetDetail = new QuotationDetailItem(rec);
                                targetDetails[i] = targetDetail;
                            }
                            
                            if (item.containsKey('Name')) {
                                targetDetail.rec.ProductCode__c = (String)item.get('Name');
                            }
                            if (item.containsKey('Tani__c')) {
                                String quantityUnit = (String)item.get('Tani__c');
                                if (String.isNotBlank(quantityUnit) && transformValues.containsKey(quantityUnit)) {
                                    quantityUnit = transformValues.get(quantityUnit);
                                }
                                targetDetail.rec.QuantityUnit__c = quantityUnit;
                            }
                            if (item.containsKey('JapaneseName__c') || item.containsKey('ModelType__c')) {
                                List<String> bodyTexts = new List<String>();

                                if (parentRec.QuotationType__c != null && parentRec.QuotationType__c.length() > 0 && (parentRec.QuotationType__c.left(1) == 'a' || parentRec.QuotationType__c.left(1) == 'A'))
                                {
                                    if (item.containsKey('ModelType__c')) {
                                        String modelType = (String)item.get('ModelType__c');
                                        if (String.isNotBlank(modelType)) {
                                            bodyTexts.add(modelType);
                                        }
                                    }
                                }

                                if (item.containsKey('JapaneseName__c')) {
                                    String japaneseName = (String)item.get('JapaneseName__c');
                                    if (String.isNotBlank(japaneseName)) {
                                        bodyTexts.add(japaneseName);
                                    }
                                }
                                targetDetail.rec.Body__c = String.join(bodyTexts, ' ');
                            }
                            if (item.containsKey('UnitPrice__c')) {
                                String priceText = (String)item.get('UnitPrice__c');
                                Decimal price = 0;
                                if (priceText != null && priceText.isNumeric()) {
                                    price = Decimal.valueOf(priceText);
                                }
                                targetDetail.rec.UnitPrice__c = price ;
                            }
                            if (targetDetail.rec.Quantity__c == null || targetDetail.rec.Quantity__c == 0) {
                                targetDetail.rec.Quantity__c = 1;
                            }
                        }
                        newDetails.addAll(targetDetails);
                        addNo = detailSize;
                    } else {
                        detail.rec.sortNo__c += addNo;
                        newDetails.add(detail);
                    }
                }
                this.items = newDetails;
            }
        }
        
        public void refresh() {
            List<QuotationDetailItem> localItems = this.items;
            List<QuotationDetailItem> newItems = new List<QuotationDetailItem>();

            localItems.sort();
            Decimal beforeDepth = 0;
            Integer cnt = 0;
            for (QuotationDetailItem item: localItems) {
                if (!item.isDeleted) {
                    item.rec.CurrencyIsoCode = this.parentRec.CurrencyIsoCode;
                    item.rec.SortNo__c = cnt;
                    if (newItems.size() == 0) {
                        item.rec.Depth__c = 0;
                    } else {
                        if (item.rec.Depth__c - beforeDepth > 1) {
                            item.rec.Depth__c = beforeDepth + 1;
                        }
                    }
                    beforeDepth = item.rec.Depth__c;
                    newItems.add(item);

                    if (item.isCopy) {
                        QuotationDetailInformation__c detailRec = item.detailCopy();
                        QuotationDetailItem copiedItem = new QuotationDetailItem(detailRec);
                        newItems.add(copiedItem);
                        detailRec.SortNo__c = cnt;
                        cnt++;
                    }
                    cnt++;
                }
            }

            this.items = newItems;
        }

    }


    public class QuotationDetailItem implements Comparable {
        public QuotationDetailInformation__c rec {get; set;}
        public Boolean isDeleted{get; set;}
        public Boolean isCopy{get; set;}
        public string IdxRow{get; set;}

        public QuotationDetailItem (QuotationDetailInformation__c target){
            this.rec = target;
            this.isDeleted = false;
            this.isCopy = false;
            
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
            
            //Modification-VAIB-Begins(2015/05/27 UAT_QA_List No.87)
            if((this.rec.Quantity__c == 0) && (this.rec.UnitPrice__c <0))
                this.rec.Amount__c = this.rec.UnitPrice__c * 1;
            else
                this.rec.Amount__c = this.rec.UnitPrice__c * this.rec.Quantity__c;
            //Modification-VAIB-Ends(2015/05/27 UAT_QA_List No.87)

            Decimal discountValue = 0;
            if (this.rec.IsDiscountTarget__c) {
                if (this.rec.DiscountRate__c != null && this.rec.DiscountRate__c != 0) {
                    discountValue += Math.ceil((this.rec.Amount__c * this.rec.DiscountRate__c) / 100);
                }
                if (this.rec.DiscountAmount__c != null && this.rec.DiscountAmount__c != 0) {
                    discountValue += this.rec.DiscountAmount__c;
                }
            }
            this.rec.TotalDiscountAmount__c = this.rec.Amount__c - discountValue;
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
        public QuotationDetailInformation__c detailCopy() {
            QuotationDetailInformation__c ret = null;
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
            if (rec.SortNo__c > compareTarget.rec.SortNo__c) {
                returnValue = 1;
            } else if (rec.SortNo__c < compareTarget.rec.SortNo__c) {
                returnValue = -1;
            }
            return returnValue;
        }
    }

    public void setReprNameExpress1() {
        qdm.parentRec.RepresentativeNameExpress__c = ReprNameExpress1;
        ReprNameExpress2 = ReprNameExpress1;
    }
    
    public void setReprNameExpress2() {
        qdm.parentRec.RepresentativeNameExpress__c = ReprNameExpress2;
        ReprNameExpress1 = ReprNameExpress2;
    }
    
}