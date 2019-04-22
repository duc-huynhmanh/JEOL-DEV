/*
 * Created : 2018/09/20 by Polus (Voxer)
 */
public with sharing class JEOLAsia_SVCReportCtrlOld2 {
    
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

    public String quotationRecordtypeLabelUnit{
        get {
            return QUOTATION_RECORDTYPE_UNIT;
        }
        set {
        }

    }

//    public String getQuotationRecordtypeLabelUnit() {return QUOTATION_RECORDTYPE_UNIT;}

public boolean isReadOnly {get; set;} //TO DELETE

    public Boolean isValid{get; set;}
    public QuotationDetailManage qdm{get; set;}

    public double scrollTopValue{get; set;}
    public double currentScrollValue{get; set;}
    public String language{get; set;}
    public Static String quotationCompany{get; set;}
    public Decimal defaultCoef{get; set;}

    public String RejectCommentInput{get; set;}
    public String EscalateCommentInputDirector{get; set;}
    public String EscalateCommentInputMD{get; set;}

    public Map<String, List<AsiaProfitCalculationRate__c>> rateListJprod{get; set;}
    public Map<String, List<AsiaProfitCalculationRate__c>> rateListOther{get; set;}

    public List<SelectOption> targetCostCurrencyOption{get; set;}
    public List<SelectOption> targetSalesCurrencyOption{get; set;}

    public List<SelectOption> listJProdCurrencyOption{get; set;}
    public List<SelectOption> listOtherCurrencyOption{get; set;}

    AsiaProjectMaster__c o = new AsiaProjectMaster__c();
    public AsiaProjectMaster__c getProxyObject() { return o; }
    public String dateQT{get; set;}

    private String sCompanyType = '';
    private boolean lastSaveError = false;


    
    public static final String ACCOUNT_BASE_QUERY = ' SELECT id, name, code__c, Address__c, Abbreviation__c FROM Account ';
    public static final String CONTACT_BASE_QUERY = ' SELECT id, Account.name, Account.code__c, Account.Address__c, Account.Abbreviation__c,name, Phone, Title, Affiliation__c FROM contact ';
    
    public JEOLAsia_SVCReportCtrlOld2(ApexPages.StandardController controller) {
        this.isValid = false;
        
        AsiaProjectMaster__c rec = null;
        scrollTopValue = 0;
        currentScrollValue = 0;
        language = '';

        try {

            this.language = UserInfo.getLanguage();
            Map<String, String> params = Apexpages.currentPage().getParameters();

            if (params.containsKey(SCROLL_TOP)) {
                scrollTopValue = double.valueof(params.get(SCROLL_TOP));
            }
            
            if (params.containsKey(PARAM_ID)) {

                String targetId = params.get(PARAM_ID);
                System.debug('@@@@PARAMID: ' + targetId);
                rec = getTargetRecord(targetId);

            } else {

                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'An unexpected error occurred.'));
                return;

            }
              
            qdm = new QuotationDetailManage(rec); 
            
            
            this.isValid = true;

        } catch (JEOLException e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            System.debug('@@@:' + e.getStackTraceString());
            return;
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'An unexpected error occurred.'));
            return;
        }
    }



    
    public void ContractAttachmentFromCode() {

        String accountCode = qdm.parentRec.ContractCode__c;
        Account targetAccount = null;

        List<Account> recs = [SELECT id, Name, Code__c, Address__c, Phone
                              FROM Account
                              WHERE Code__c =: accountCode];

        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }

        qdm.parentRec.ContractAccount__c = targetAccount.Id;
        qdm.parentRec.ContractCode__c = targetAccount.Code__c;
        qdm.parentRec.ContractName__c = targetAccount.Name;

        qdm.parentRec.ContractAddress__c = targetAccount.Address__c;
        qdm.parentRec.ContractPersonInCharge__c = null;
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;
        qdm.parentRec.ContractEmail__c = null;
        qdm.parentRec.ContractBelong__c = null;

    }

/*
    public void ShipmentAttachmentFromCode() {

        String accountCode = qdm.parentRec.ShipmentCode__c;
        Account targetAccount = null;

        List<Account> recs = [SELECT id, Name, Code__c, Address__c, Phone
                              FROM Account
                              WHERE Code__c =: accountCode];

        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }

        qdm.parentRec.ShipmentAccount__c = targetAccount.id;
        qdm.parentRec.ShipmentCode__c = targetAccount.Code__c;
        qdm.parentRec.ShipmentName__c = targetAccount.Name;
        
        qdm.parentRec.ShipmentAddress__c = targetAccount.Address__c;
        qdm.parentRec.ShipmentPersonInCharge__c = null;
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;
        qdm.parentRec.ShipmentEmail__c = null;
        qdm.parentRec.ShipmentBelong__c = null;
    }
*/

    public void ContractAttachment() {

        String accountId = qdm.parentRec.ContractAccount_dummyField__c;
        Account targetAccount = null;

        List<Account> recs = [SELECT id, Name, Code__c, Address__c, Phone
                              FROM Account
                              WHERE id =: accountId];

        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }

        qdm.parentRec.ContractAccount__c = targetAccount.id;
        qdm.parentRec.ContractCode__c = targetAccount.Code__c;
        qdm.parentRec.ContractName__c = targetAccount.Name;

        qdm.parentRec.ContractAddress__c = targetAccount.Address__c;
        qdm.parentRec.ContractPersonInCharge__c = null;
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;
        qdm.parentRec.ContractEmail__c = null;
        qdm.parentRec.ContractBelong__c = null;

        qdm.parentRec.ContractAccount_dummyField__c = null;
    }

/*
    public void ShipmentAttachment() {

        String accountId = qdm.parentRec.ShipmentAccount_dummyField__c;
        Account targetAccount = null;
        
        List<Account> recs = [SELECT id, Name, Code__c, Address__c, Phone
                              FROM Account
                              WHERE id =: accountId];

        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }

        qdm.parentRec.ShipmentAccount__c = targetAccount.id;
        qdm.parentRec.ShipmentCode__c = targetAccount.Code__c;
        qdm.parentRec.ShipmentName__c = targetAccount.Name;

        qdm.parentRec.ShipmentAddress__c = targetAccount.Address__c;
        qdm.parentRec.ShipmentPersonInCharge__c = null;
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;
        qdm.parentRec.ShipmentEmail__c = null;
        qdm.parentRec.ShipmentBelong__c = null;

        qdm.parentRec.ShipmentAccount_dummyField__c = null;
    }
*/

    public void contractContactAttachment() {

        String contactId = qdm.parentRec.ContractContact_dummyField__c;
        Contact targetContact = null;

        List<Contact> recs = [SELECT id, Name, Phone, Email, Affiliation__c, AccountId, Account.Name, Account.Code__c, Account.Address__c
                              FROM Contact
                              WHERE id =: contactId];

        if (recs != null && recs.size() > 0) {
            targetContact = recs.get(0);
        } else {
            targetContact = new Contact();
        }

        if (targetContact.Account != null && qdm.parentRec.ContractAccount__c != targetContact.AccountId) {

            qdm.parentRec.ContractAccount__c = targetContact.AccountId;
            qdm.parentRec.ContractCode__c = targetContact.Account.Code__c;
            qdm.parentRec.ContractName__c = targetContact.Account.Name;
            
            qdm.parentRec.ContractAddress__c = targetContact.Account.Address__c;

        }

        qdm.parentRec.ContractPersonInCharge__c = targetContact.Name;
        qdm.parentRec.ContractPhone__c = targetContact.Phone;
        qdm.parentRec.ContractEmail__c = targetContact.Email;
        qdm.parentRec.ContractBelong__c = targetContact.Affiliation__c;

        qdm.parentRec.ContractContact_dummyField__c = null;        
    }

    public void shipmentContactAttachment() {

        String contactId = qdm.parentRec.ShipmentContact_dummyField__c;
        Contact targetContact = null;

        List<Contact> recs = [SELECT id, Name, Phone, Email, Affiliation__c, AccountId, Account.Name, Account.Code__c, Account.Address__c
                              FROM Contact
                              WHERE id =: contactId];
    
        if (recs != null && recs.size() > 0) {
            targetContact = recs.get(0);
        } else {
            targetContact = new Contact();
        }

/*
        // DO NOT OVERWRITE THE ACCOUNT INFORMATION COMING FROM THE INTERFACE
        if (targetContact.Account != null && qdm.parentRec.ShipmentAccount__c != targetContact.AccountId) {

            qdm.parentRec.ShipmentAccount__c = targetContact.AccountId;
            qdm.parentRec.ShipmentCode__c = targetContact.Account.Code__c;
            qdm.parentRec.ShipmentName__c = targetContact.Account.Name;

            qdm.parentRec.ShipmentAddress__c = targetContact.Account.Address__c;

        }
*/

        qdm.parentRec.ShipmentPersonInCharge__c = targetContact.Name;
        qdm.parentRec.ShipmentPhone__c = targetContact.Phone;
        qdm.parentRec.ShipmentEmail__c = targetContact.Email;
        qdm.parentRec.ShipmentBelong__c = targetContact.Affiliation__c;

        qdm.parentRec.ShipmentContact_dummyField__c = null;
    }

    private AsiaProjectMaster__c getTargetRecord(String targetId) {

        AsiaProjectMaster__c targetaRecord = null;

        List<AsiaProjectMaster__c> recs = [
            SELECT
                id, name, LastModifiedDate, ContractAccount__c, ContractAccount__r.Code__c, ContractAccount__r.Name, ShipmentAccount__c, ShipmentAccount__r.Code__c,
                ShipmentAccount__r.Name, Status__c, CustomerPONumber__c, ProjectNumber__c, ShipmentCountry__c, Model__c, SerialNumber__c, Series__c,
                ShippingDate__c, SalesPerson__c, SalesAssistant__c, CertificationDate__c, ProductStatus__c, ContractCode__c, ContractName__c, ContractBelong__c,
                ContractAddress__c, ContractPersonInCharge__c, ContractContact_dummyField__c, ContractPhone__c, ContractEmail__c, ShipmentCode__c, 
                ShipmentName__c, ShipmentBelong__c, ShipmentAddress__c, ShipmentPersonInCharge__c, ShipmentContact_dummyField__c, ShipmentPhone__c,
                ShipmentEmail__c, ContractAccount_dummyField__c, ShipmentAccount_dummyField__c, ProfitCalculation__c, ContractStartDate__c, ContractEndDate__c,
                WarrantyStartDateDisplayed__c, WarrantyEndDateDisplayed__c, WarrantyDescription__c, ProductsInformationsDescription__c
            FROM
                AsiaProjectMaster__c
            WHERE
                Id = :targetId
        ];
        if (recs != null && recs.size() > 0) {
            targetaRecord = recs.get(0);
            if (targetaRecord.ContractAccount__c != NULL) {
                targetaRecord.ContractCode__c = targetaRecord.ContractAccount__r.Code__c;
                targetaRecord.ContractName__c = targetaRecord.ContractAccount__r.Name;                
            }
            if (targetaRecord.ShipmentAccount__c != NULL) {
                targetaRecord.ShipmentCode__c = targetaRecord.ShipmentAccount__r.Code__c;
//                targetaRecord.ShipmentName__c = targetaRecord.ShipmentAccount__r.Name;
            }
            if (targetaRecord.ContractStartDate__c == NULL && targetaRecord.ContractEndDate__c == NULL) {
                targetaRecord.ContractStartDate__c = targetaRecord.WarrantyStartDateDisplayed__c;
                targetaRecord.ContractEndDate__c = targetaRecord.WarrantyEndDateDisplayed__c;
            }

        } else {
            throw new JEOLException('An unexpected error occured.');
        }
        return targetaRecord;
    }


    public void dummyAction() {
        system.debug('dummyAction');
    }



    
    public void ajaxSaveAction() {
        saveAction();
        qdm.baseParentRec = qdm.parentRec.clone(true);
        qdm.baseItemsAll = qdm.itemsAll.clone();
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
            List<String> errorFields = qdm.requireCheck();
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


            AsiaProjectMaster__c parentRec = qdm.parentRec;

            // Check if the Accounts selected are existing
            List<Account> recs = [SELECT id, Code__c FROM Account WHERE Code__c in (:parentRec.ContractCode__c, :parentRec.ShipmentCode__c)];
            boolean fContractAccountOK = (parentRec.ContractCode__c == NULL);
            boolean fShipmentAccountOK = (parentRec.ShipmentCode__c == NULL);

            for (Account acc : recs) {
                if (acc.Code__c == parentRec.ContractCode__c && acc.id == parentRec.ContractAccount__c) fContractAccountOK = true;
                if (acc.Code__c == parentRec.ShipmentCode__c && acc.id == parentRec.ShipmentAccount__c) fShipmentAccountOK = true;
            }
            if (!fContractAccountOK && !fShipmentAccountOK) {
                String errorText = 'The selected Buyer account and End User account does not correspond to the entered account code. Please refresh the selected account by pushing the button near the account code.';
                throw new JEOLException(errorText);                
            } else if (!fContractAccountOK) {
                String errorText = 'The selected Buyer account does not correspond to the entered account code. Please refresh the selected account by pushing the button near the account code.';
                throw new JEOLException(errorText);
            } else if (!fShipmentAccountOK) {
                String errorText = 'The selected End User account does not correspond to the entered account code. Please refresh the selected account by pushing the button near the account code.';
                throw new JEOLException(errorText);
            }

            // Check if the data has not been modified by another user
            if (parentRec.Id != null) {
                AsiaProjectMaster__c refreshedParentRec = [SELECT Id, Name, LastModifiedDate, LastModifiedBy.Name FROM AsiaProjectMaster__c WHERE Id=:parentRec.Id];
                if(parentRec.LastModifiedDate != refreshedParentRec.LastModifiedDate)
                    throw new JEOLException('This record has been modified by ' + refreshedParentRec.LastModifiedBy.Name + ' at ' + refreshedParentRec.LastModifiedDate.format() + '. Please reload the data before making again your modifications.');
            }
            
            parentRec.ContractContact_dummyField__c = null;
            parentRec.ShipmentContact_dummyField__c = null;

                        
system.debug('Save: ' + parentRec.ContractAccount__c + ' +++ ' + parentRec);
            upsert parentRec;

            List<AsiaProjectMasterDetail__c> details = new List<AsiaProjectMasterDetail__c>();
            for (QuotationDetailItem item: qdm.itemsAll) {
                AsiaProjectMasterDetail__c rec = item.rec;
                if (rec.parent__c != parentRec.id) {
                    rec.parent__c = parentRec.id;
                }
                details.add(rec);
            }
    
            List<AsiaProjectMasterDetail__c> deleteTargets = new List<AsiaProjectMasterDetail__c>();
            for (QuotationDetailItem item: qdm.baseItemsAll) {
                if (item.isDeleted) {
                    deleteTargets.add(item.rec);
                }
            }

            if (details.size() > 0) {
                upsert details;
            }
            


            
            // Delete the parent rows after the child one (orelse errors occured)
            if (deleteTargets.size() > 0) {
                delete deleteTargets;
            }






            qdm.parentRec = getTargetRecord(parentRec.id);

            ref = Page.JEOLAsia_ProjectMasterEditorPage;
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

    @RemoteAction
    public static List<Object> getProductMaster(Map<String, String> values) {

        List<String> conditions = new List<String>();

        if (values.containsKey('EnglishName__c') && String.isNotBlank(values.get('EnglishName__c'))) {
            conditions.add(JEOLUtil.appendLikeText('EnglishName__c', values.get('EnglishName__c')));
        }

        if (values.containsKey('Name') && String.isNotBlank(values.get('Name'))) {
            conditions.add(JEOLUtil.appendLikeText('Name', values.get('Name')));
        }

        if (values.containsKey('ModelType__c') && String.isNotBlank(values.get('ModelType__c'))) {
            conditions.add(JEOLUtil.appendLikeText('ModelTypeDisplay__c', values.get('ModelType__c')));
        }

        if (values.containsKey('Supplier__c') && String.isNotBlank(values.get('Supplier__c'))) {
            conditions.add(JEOLUtil.appendLikeText('Supplier__c', values.get('Supplier__c')));
        }
        
        List<ProductItem__c> productMasters;

        conditions.add('IsDisplayedLocalSupply__c = true');

system.debug(' SELECT id, Name, Kikaku__c, ModelType__c, EnglishName__c, Supplier__c ' +
                                        ' FROM ProductItem__c ' +
                                        JEOLUtil.joinWhereConditions(conditions) +
                                        ' AND ProductItemType__c = \'2\'' +
                                        ' ORDER BY EnglishName__c ' +
                                        ' LIMIT 10000');

        productMasters = Database.query(' SELECT id, Name, Kikaku__c, ModelType__c, EnglishName__c, Supplier__c ' +
                                        ' FROM ProductItem__c ' +
                                        JEOLUtil.joinWhereConditions(conditions) +
                                        ' AND ProductItemType__c = \'2\'' +
                                        ' ORDER BY EnglishName__c ' +
                                        ' LIMIT 10000');


        return productMasters;
    }


    @RemoteAction
    public static List<AsiaProductCatalog__c> getCatalogHead(Map<String, String> values) {
    
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

        catalogItems = Database.query('SELECT id, SearchKeyWord__c, ProductCatalog__c, AdditionalInformation__c, NumberOfMounting__c, LocalSupplyFlag__c, ProductNo__c, ClassificationType__c, Position__c, CatalogStructure__c, ClassificationNo__c, ProductItem__c, ProductItem__r.Name, ProductItem__r.Kikaku__c, ProductItem__r.EnglishName__c, ProductItem__r.ModelTypeDisplay__c, EnglishText__c FROM AsiaProductCatalog__c' + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY Position__c LIMIT 10000');
        return catalogItems;
    }

    @RemoteAction
    public static List<AsiaProductCatalog__c> getChildCatalogStructure(String ProductCatalog, String Structure, String position) {
        List<AsiaProductCatalog__c> catalogItems  = null;
        List<String> conditions = new List<String>();
        if (String.isNotBlank(Structure)) {
            conditions.add(JEOLUtil.appendEqualText('ProductCatalog__c', ProductCatalog));
            conditions.add(JEOLUtil.appendEqualText('CatalogStructure__c', Structure));
            catalogItems = Database.query('SELECT id, SearchKeyWord__c, ProductCatalog__c, AdditionalInformation__c, NumberOfMounting__c, LocalSupplyFlag__c, ProductNo__c, ClassificationType__c, Position__c, CatalogStructure__c, ClassificationNo__c, ProductItem__c, ProductItem__r.Name, ProductItem__r.Kikaku__c, ProductItem__r.EnglishName__c, ProductItem__r.ModelTypeDisplay__c, EnglishText__c FROM AsiaProductCatalog__c' + JEOLUtil.joinWhereConditions(conditions) + 'ORDER BY Position__c LIMIT 10000');
        }
        return catalogItems;
    }




    @RemoteAction
    public static List<string> getSuggestions(String modelType) {

        modelType = modelType + '%';
        List<ProductItem__c> recs;
        recs = [SELECT ModelTypeDisplay__c, EnglishName__c FROM ProductItem__c WHERE ModelTypeDisplay__c like :modelType AND IsDisplayedAsia__c = true AND IsDisplayedAsiaSignal__c = true ORDER By ModelTypeDisplay__c LIMIT 20];
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
        public AsiaProjectMaster__c parentRec{get; set;}
        public AsiaProjectMaster__c baseParentRec{get; set;}
        public String createdItemInfos{get; set;}
        public String dateQuotation{get; set;}
        public String selectedQuotationId{get; set;}
        public String targetAccountId{get; set;}
        public List<AsiaMaintenanceContractManagement__c> detailMaintenance{get; set;}
        public List<AsiaMaintenanceContractManagement__c> detailSvcReports{get; set;}

        public QuotationDetailManage(AsiaProjectMaster__c parentRec) {

            detailMaintenance = this.getDetailMaintenance(parentRec.id);
            detailSvcReports = NULL; // TODO

            List<AsiaProjectMasterDetail__c> recs = this.getDetailRecs(parentRec.id);
            if (recs == null) {
                recs = new List<AsiaProjectMasterDetail__c>();
            }

            List<QuotationDetailItem> localItemsAll = this.itemsAll;
            for (AsiaProjectMasterDetail__c rec: recs) {
                QuotationDetailItem item = new QuotationDetailItem(rec);
                localItemsAll.add(item);
            }


            this.baseItemsAll = localItemsAll.clone();
            
            this.parentRec = parentRec;

            this.baseParentRec =  this.parentRec.clone(true);

        }

        /**
         * コピーボタン押下時action
         * 親レコードに紐づく2SPパーツを取得し、値をコピーしてQDItem作成
         */
        public void copyLSInfoFromQuotation() {

            for (AsiaProfitCalculationDetail__c det : [SELECT Id, Body__c, Supplier__c, Quantity__c
                                                       FROM AsiaProfitCalculationDetail__c
                                                       WHERE Parent__c = :this.parentRec.ProfitCalculation__c
                                                       AND Category__c = 'B'
                                                       AND Type__c = '1'
                                                       ORDER BY SortNo__c]) {

                AsiaProjectMasterDetail__c detail = createInitalizedRecord('B');
                detail.Category__c = 'B';
                detail.Type__c = '1';
                detail.Body__c = det.Body__c;
                detail.Supplier__c = det.Supplier__c;
                detail.Quantity__c = det.Quantity__c;
                itemsAll.add(new QuotationDetailItem(detail));
            }
            
        }
        
        public List<String> requireCheck() {
            AsiaProjectMaster__c rec = this.parentRec;
            List<String> checkList = new List<String>();
            
            /*
            if (String.isBlank(rec.ContractCode__c)) {
                checkList.add('Sold To Customer Code');
            }
            */
            return checkList;
        }


        private List<AsiaProjectMasterDetail__c> getDetailRecs(String parentId) {
            List<AsiaProjectMasterDetail__c> recs = [
                    SELECT 
                        id, name, Depth__c, SortNo__c, Type__c, Category__c, Parent__c, Quantity__c,
                        Body__c, ModelType__c, SerialNumber__c, ShippingDate__c, PartNumber__c, Specification__c, QuantityUpdatedDate__c,
                        Description__c, Supplier__c
                    FROM 
                        AsiaProjectMasterDetail__c 
                    WHERE 
                        Parent__c =: parentId 
                    ORDER BY
                        SortNo__c, Depth__c Asc
            ];
            return recs;
        }



        private List<AsiaMaintenanceContractManagement__c> getDetailMaintenance(String parentId) {
            List<AsiaMaintenanceContractManagement__c> recs = [
                    SELECT 
                        id, Name, Type__c, Description__c, NewContractStartDate__c, NewContractEndDate__c, Status__c
                    FROM 
                        AsiaMaintenanceContractManagement__c 
                    WHERE 
                        ProjectMaster__c =: parentId 
                    ORDER BY
                        NewContractStartDate__c, NewContractEndDate__c, Type__c
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
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('A');
            detail.Category__c = 'A';
            detail.Type__c = '1';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailA() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('A');
            detail.Category__c = 'A';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailB() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('B');
            detail.Category__c = 'B';
            detail.Type__c = '1';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailB() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('B');
            detail.Category__c = 'B';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailC() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('C');
            detail.Category__c = 'C';
            detail.Type__c = '1';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailC() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('C');
            detail.Category__c = 'C';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailD() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('D');
            detail.Category__c = 'D';
            detail.Type__c = '1';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailD() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('D');
            detail.Category__c = 'D';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailE() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('E');
            detail.Category__c = 'E';
            detail.Type__c = '1';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailE() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('E');
            detail.Category__c = 'E';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailF() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('F');
            detail.Category__c = 'F';
            detail.Type__c = '1';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailF() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('F');
            detail.Category__c = 'F';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createQuotationDetailG() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('G');
            detail.Category__c = 'G';
            detail.Type__c = '1';
            itemsAll.add(new QuotationDetailItem(detail));
        }
        public void createHeadingDetailG() {
            AsiaProjectMasterDetail__c detail = createInitalizedRecord('G');
            detail.Category__c = 'G';
            detail.Type__c = '2';
            itemsAll.add(new QuotationDetailItem(detail));
        }



        public AsiaProjectMasterDetail__c createInitalizedRecord(String sCategory) {
            AsiaProjectMasterDetail__c detail = new AsiaProjectMasterDetail__c();
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
            detail.Parent__c = this.parentRec.id;
            detail.Quantity__c = 0;
            system.debug( '  *** SortNo : ' + detail.sortNo__c );
            return detail;
        }

        public Integer getCurrentSize() {
            return itemsAll.size();
        }
        public Integer getCurrentSizeA() {
            return getitemsA().size();
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
        
    


        public void createSelectedProductItemDetails() { //todobp delete
            createSelectedProductItemDetailsCat('A');
        }
        public void createSelectedProductItemDetailsA() {
            createSelectedProductItemDetailsCat('A');
        }
        public void createSelectedProductItemDetailsB() {
            createSelectedProductItemDetailsCat('B');
        }
        public void createSelectedProductItemDetailsC() {
            createSelectedProductItemDetailsCat('C');
        }
        public void createSelectedProductItemDetailsD() {
            createSelectedProductItemDetailsCat('D');
        }
        public void createSelectedProductItemDetailsE() {
            createSelectedProductItemDetailsCat('E');
        }
        public void createSelectedProductItemDetailsF() {
            createSelectedProductItemDetailsCat('F');
        }
        public void createSelectedProductItemDetailsG() {
            createSelectedProductItemDetailsCat('G');
        }


        /**
         * モーダルでアイテムをD＆Dし、OKボタンを押下した際に呼ばれるaction 
         * 
         */
        private void createSelectedProductItemDetailsCat(String sCategory) {
            system.debug(this.createdItemInfos);

            //JSONデータをMapにデシリアライズ
            Map<String, Object> infoData = (Map<String, Object>)JSON.deserializeUntyped(this.createdItemInfos);
            this.createdItemInfos = null;
            System.debug( infoData );
            
            //ソートNoと選択された部品リスト取得
            String targetSortNo = (String)infoData.get('sortNo');
            List<Object> selectedItems = (List<Object>)infoData.get('items');

            //+ボタンを押された行のソートNOを取得
            Integer sortNo = null;
            if (targetSortNo != null && targetSortNo.isNumeric()) {
                sortNo = Integer.valueOf(targetSortNo);
            }
            
            //変換値をMapに設定
            //value__c -> label__c
            Map<String, String> transformValues = new Map<String, String>();
            List<SelectListManage__c> mangesRecs = JEOLUtil.getSelectListRecs(JEOLUtil.REFERENCE_NAME_QUOTATION_QUANTITY_UNIT);
            for (SelectListManage__c manageRec: mangesRecs) {
                if (String.isNotBlank(manageRec.value__c)) {
                    transformValues.put(manageRec.value__c, manageRec.label__c);
                }
            }

            List<id> lsProdItem = new List<id>();
            Map<id, ProductItemPrice__c> mpPriceItem = new Map<id, ProductItemPrice__c>();

            system.debug('***SortNo = ' +  sortNo);

            Integer addNo = 0;
            //※旧仕様 sortNo必須
            if (sortNo != null) {
                List<QuotationDetailItem> newDetails = new List<QuotationDetailItem>();
                //itemsAllリストのQDIをループして、カテゴリとソートNoが一致するデータに対して処理を実施
                for (QuotationDetailItem detail: this.itemsAll.clone()) {
                    // if (detail.rec.Category__c == sCategory && detail.rec.sortNo__c == sortNo && !detail.isDeleted) {
                    if (detail.rec.Category__c == sCategory && detail.rec.sortNo__c == sortNo && !detail.isDeleted) {
                        //選択したアイテム数分だけQDIを作成
                        Integer detailSize = selectedItems.size();
                        List<QuotationDetailItem> targetDetails = new QuotationDetailItem[detailSize];
                        targetDetails[0] = detail;

                        //選択したアイテム分ループ
                        for (Integer i = 0; i < detailSize; i++) {
                            QuotationDetailItem targetDetail = targetDetails[i];
                            Map<String, Object> item = (Map<String, Object>)selectedItems[i];
                            boolean fIsLocalSupplyFromCatalog = false;
                            system.debug( '**** ' + item );
                            
                            if (item.containsKey('LocalSupplyFlag__c') && ((String)item.get('LocalSupplyFlag__c')).toUpperCase() == 'TRUE') {
                                fIsLocalSupplyFromCatalog = true;
                            }

                            if (targetDetail == null) {
                                AsiaProjectMasterDetail__c rec = createInitalizedRecord(sCategory);
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
                                rec.Category__c = sCategory;
                                targetDetail = new QuotationDetailItem(rec);
                                targetDetails[i] = targetDetail;
                            }

                            if (item.containsKey('EnglishName__c')) {
                               targetDetail.rec.Body__c = (String)item.get('EnglishName__c');
                            }
                            
                            if (item.containsKey('Supplier__c')) {
                                targetDetail.rec.Supplier__c = (String)item.get('Supplier__c');
                            }

                            if (targetDetail.rec.Quantity__c == null || targetDetail.rec.Quantity__c == 0) {
                                targetDetail.rec.Quantity__c = 1;
                            }

                        }

                        newDetails.addAll(targetDetails);
                        addNo = detailSize;

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
                        AsiaProjectMasterDetail__c detailRec = item.detailCopy();
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
        public AsiaProjectMasterDetail__c rec {get; set;}
        public String productName {get; set;}
        public Boolean isDeleted{get; set;}
        public Boolean isCopy{get; set;}
        public string IdxRow{get; set;}

        public QuotationDetailItem (AsiaProjectMasterDetail__c target){
            this.rec = target;
            this.isDeleted = false;
            this.isCopy = false;
            
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
        public AsiaProjectMasterDetail__c detailCopy() {
            AsiaProjectMasterDetail__c ret = null;
            if (this.rec != null) {
                ret = this.rec.clone(false,true,false,false);
            }
            this.isCopy = false;
            return ret;
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


}