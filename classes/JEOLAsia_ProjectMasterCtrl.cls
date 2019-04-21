/*
 * Created : 2016/05/06 by Kobayashi (Voxer)
 */
public with sharing class JEOLAsia_ProjectMasterCtrl {

    public static final String STATUS_UNDER_WARRANTY = 'Under warranty';
    public static final String STATUS_CONTRACTED = 'Contracted';
    public static final String STATUS_NO_CONTRACT = 'No contract';

    public static final String MCM_STATUS_CONTRACTED = '2';
    public static final String MCM_STATUS_CONTRACT_CANCELLATION = '3';


    public static final String PARAM_ID = 'id';
    public static final String SCROLL_TOP = 'top';
    public Boolean isValid{get; set;} // 有効フラグ
    public QuotationDetailManage qdm{get; set;}
    public Boolean isNew{get; set;} // 新規作成フラグ
    public String productDivision{get; set;}
    public Boolean isCopy{get; set;}
    public Boolean isReadOnly{get; set;}
    public double scrollTopValue{get; set;}
    public double currentScrollValue{get; set;}
    public String listRowToDel{get; set;}
    public String address{get; set;}
    public String language{get; set;} // ユーザーの言語

    public String userCompany{get; set;}
    public String userCompanyCode{get; set;}
    public Static String quotationCompany{get; set;}

    public List<AsiaProjectMasterDetail__c> deleteTargets = new List<AsiaProjectMasterDetail__c>();

    //0817 ZH Add
    public list<SVC_Report__c> svcList {get;set;}
    public list<AsiaProfitCalculationDetail2SP__c> spList = new list<AsiaProfitCalculationDetail2SP__c>();
    public list<AsiaMaintenanceContractManagement__c> mcmList {get;set;}
    
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

    public static final Integer ASIAPROFITCALC_NO_PREFIX_LENGTH = 2;
    public static final String URL_PARAM_NAME_ISCOPY = 'isCopy';

    //コンストラクタ
    public JEOLAsia_ProjectMasterCtrl(ApexPages.StandardController controller) {

        this.isValid = false;
        Boolean isCopy = false;
        isReadOnly = false;

        AsiaProjectMaster__c rec = null;
        
        scrollTopValue = 0;
        currentScrollValue = 0;
        language = '';

        try {
            // ユーザープロフィールの会社名から会社を取得
            userCompany = '';
            userCompanyCode = '';
            User usr = [SELECT CompanyName FROM User WHERE id = :UserInfo.getUserId()];
            String sCompanyNameProfile = usr.CompanyName;
            for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
                if (companyCustSettings.CompanyName__c == sCompanyNameProfile) {
                    userCompany = companyCustSettings.Company__c;
                    userCompanyCode = companyCustSettings.CompanyLabel__c;
                }
            }

            this.language = UserInfo.getLanguage();
            Map<String, String> params = Apexpages.currentPage().getParameters();
     System.debug('@@@@getparamsId: ' + Apexpages.currentPage());       
System.debug('@@@@getparamsId: ' + params);
System.debug('@@@@getUserId: ' + UserInfo.getUserId());

            // パラメータ取得
            if (params.containsKey(SCROLL_TOP)) {
                scrollTopValue = double.valueof(params.get(SCROLL_TOP));
            }

            if (params.containsKey(PARAM_ID)) {
                // パラメータIDが存在する場合
                String targetId = params.get(PARAM_ID);
System.debug('@@@@PARAMID: ' + targetId);

                // レコード取得
                rec = getTargetRecord(targetId);
                
                //0817 ZH Add
                svcList = getSVCRecs(targetId);
                
                mcmList = getmcmRecs(targetId);


                // 明細数量の整数表示設定
                if (params.containsKey(URL_PARAM_NAME_ISCOPY) && params.get(URL_PARAM_NAME_ISCOPY) == 'true') {
                    isCopy = true;
                    this.isNew = true;
                    this.isReadOnly = false;
                } else {
                    this.isNew = false;
//                    this.isReadOnly = !rec.UserRecordAccess.HasEditAccess;
//                    this.isReadOnly = true;
// needs to be done in an without sharing clasds in order to work

                }
            } else {
                // パラメータIDが存在しない場合(新規作成時)
System.debug('@@@@PARAMID: NONE');
                rec = createNewRecord();

                this.isNew = true;
            }

            // 見積もり詳細管理クラス生成
            qdm = new QuotationDetailManage(rec, isCopy, isNew);

            if(isNew && !isCopy)
            {
                // Set the value of the quotation company
                // 会社設定
                quotationCompany = userCompany;
                qdm.parentRec.Company__c = quotationCompany;
                qdm.parentRec.CompanyName__c = userCompanyCode;
            }

            this.isCopy = isCopy;
            this.isValid = true;

system.debug('■■■this.isCopy:' + this.isCopy );
system.debug('■■■this.isValid:' + this.isValid );
system.debug('■■■qdm:' + qdm );

        } catch (JEOLException e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
System.debug('@@@:' + e.getStackTraceString());
            return;
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '不正な操作が行われました。'));
            return;
        }
    }

    //選択リスト型の選択できる値を取得
    public List<Schema.PicklistEntry> getPicklist(String sObjName, String fieldName){

        List<Schema.PicklistEntry> pickList;
        Schema.SObjectType sObjType = (Schema.SObjectType) Schema.getGlobalDescribe().get(sObjName);

        if (sObjType != null) {
            Map<String, Schema.SObjectField> fieldmap = sObjType.getDescribe().fields.getMap();
            Schema.SObjectField f = (Schema.SObjectField) fieldmap.get(fieldName);
            if (f != null) {
                Schema.DescribeFieldResult r = f.getDescribe();
                pickList = r.getPicklistValues();
                System.debug('値' + pickList);
            }
        }

        return pickList;
    }

    // CurrencyContractPrice__c値取得
    public List<SelectOption> getCurrencyContractPriceItems() {

        List<Schema.PicklistEntry> picklist = getPicklist('AsiaProjectMaster__c', 'CurrencyContractPrice__c');
        List<SelectOption> options = new List<SelectOption>();
		
        // 選択リストより、リスト生成
        for(Schema.PicklistEntry pick : picklist){
            options.add(new SelectOption( pick.getValue(), pick.getLabel()));
        }
        return options;
    }

    // 選択リスト管理(SelectListManage__c)より、系列(Series)を取得
    public List<SelectOption> getSeriesOptions() {
        system.debug('■■■■■■■■■■■getSeriesOptions():' + JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES));
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_GLOBAL_SERIES);
    }

    // アカウント情報取得(ContractCode__c)
    public void ContractAttachmentFromCode() {
        String accountCode = qdm.parentRec.ContractCode__c;
        Account targetAccount = null;

        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, Fax, Phone FROM Account WHERE Code__c =: accountCode];
        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }

system.debug('ContractAttachmentFromCode:accountCode = ' + accountCode);
system.debug('ContractAttachmentFromCode:recs = ' + recs);
system.debug('ContractAttachmentFromCode:targetAccount = ' + targetAccount);

        qdm.parentRec.ContractAccount__c = targetAccount.Id;

        // Customer
        qdm.parentRec.ContractCode__c = targetAccount.Code__c;
        qdm.parentRec.ContractName__c = targetAccount.Name;

        // Customer Name 1, 2
        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            // 正式名称1に入力ある場合、正式名称1、2を設定
            qdm.parentRec.ContractName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            // 正式名称1に入力ない場合、正式名称(1、2行目)を設定
            qdm.parentRec.ContractName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialName2__c;
        }

        // Branch Office
        qdm.parentRec.ContractUndergraduate__c = targetAccount.Undergraduate__c;

        // Address
        qdm.parentRec.ContractAddress__c = targetAccount.Address__c;
//        qdm.parentRec.ContractPostalCode__c = targetAccount.PostalCode__c;

        // Department
        qdm.parentRec.ContractBelong__c = null;

        // Designation
        qdm.parentRec.ContractPost__c = null;

        // Responsible
        qdm.parentRec.ContractPersonInCharge__c = null;

        // Phone
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;

        // Email
        qdm.parentRec.ContractEmail__c = null;

        // Fax
        qdm.parentRec.ContractFax__c = targetAccount.Fax;
        //0828 ZH Add
        //qdm.parentRec.CustomerPONumber__c =
        // 
    }

    // アカウント情報取得(ShipmentCode__c)
    public void ShipmentAttachmentFromCode() {
        String accountCode = qdm.parentRec.ShipmentCode__c;
        Account targetAccount = null;

        List<Account> recs = [SELECT id, Name, OfficialName1__c, OfficialName2__c, OfficialNameRow1__c, OfficialNameRow2__c, Code__c, Address__c, PostalCode__c, Undergraduate__c, DistanceZone__c, DistanceSection__c, Fax, Phone FROM Account WHERE Code__c =: accountCode];
        if (recs != null && recs.size() > 0) {
            targetAccount = recs.get(0);
        } else {
            targetAccount = new Account();
        }

        qdm.parentRec.ShipmentAccount__c = targetAccount.Id;

        // Customer
        qdm.parentRec.ShipmentCode__c = targetAccount.Code__c;
        //qdm.parentRec.ShipmentName__c = targetAccount.Name;

        // Customer Name 1, 2
        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            // 正式名称1に入力ある場合、正式名称1、2を設定
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            // 正式名称1に入力ない場合、正式名称(1、2行目)を設定
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialName2__c;
        }

        // Branch Office
        qdm.parentRec.ShipmentUndergraduate__c = targetAccount.Undergraduate__c;

        // Address
        //qdm.parentRec.ShipmentAddress__c = targetAccount.Address__c;

        // Department
        qdm.parentRec.ShipmentBelong__c = null;

        // Designation
        qdm.parentRec.ShipmentPost__c = null;

        // Responsible
        qdm.parentRec.ShipmentPersonInCharge__c = null;

        // Phone
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;

        // Email
        qdm.parentRec.ShipmentEmail__c = null;

        // Fax
        qdm.parentRec.ShipmentFax__c = targetAccount.Fax;
//        qdm.parentRec.UnitBody__c = null;
    }

    // アカウント情報取得(ContractAccount_dummyField__c)
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

        // Customer
        qdm.parentRec.ContractCode__c = targetAccount.Code__c;
        qdm.parentRec.ContractName__c = targetAccount.Name;

        // Customer Name 1, 2
        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            // 正式名称1に入力ある場合、正式名称1、2を設定
            qdm.parentRec.ContractName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            // 正式名称1に入力ない場合、正式名称(1、2行目)を設定
            qdm.parentRec.ContractName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ContractName2__c = targetAccount.OfficialName2__c;
        }

        // Branch Office
        qdm.parentRec.ContractUndergraduate__c = targetAccount.Undergraduate__c;

        // Address
        qdm.parentRec.ContractAddress__c = targetAccount.Address__c;
//        qdm.parentRec.ContractPostalCode__c = targetAccount.PostalCode__c;

        // Department
        qdm.parentRec.ContractBelong__c = null;

        // Designation
        qdm.parentRec.ContractPost__c = null;

        // Responsible
        qdm.parentRec.ContractPersonInCharge__c = null;

        // Phone
        qdm.parentRec.ContractPhone__c = targetAccount.Phone;

        // Email
        qdm.parentRec.ContractEmail__c = null;

        // Fax
        qdm.parentRec.ContractFax__c = targetAccount.Fax;

        qdm.parentRec.ContractAccount_dummyField__c = null;
    }

    // アカウント情報取得(ShipmentAccount_dummyField__c)
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

        // Customer
        qdm.parentRec.ShipmentCode__c = targetAccount.Code__c;
        //qdm.parentRec.ShipmentName__c = targetAccount.Name;

        // Customer Name 1, 2
        if (targetAccount.OfficialNameRow1__c != null && targetAccount.OfficialNameRow1__c.length() > 0) {
            // 正式名称1に入力ある場合、正式名称1、2を設定
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialNameRow1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialNameRow2__c;
        } else {
            // 正式名称1に入力ない場合、正式名称(1、2行目)を設定
            qdm.parentRec.ShipmentName1__c = targetAccount.OfficialName1__c;
            qdm.parentRec.ShipmentName2__c = targetAccount.OfficialName2__c;
        }

        // Branch Office
        qdm.parentRec.ShipmentUndergraduate__c = targetAccount.Undergraduate__c;

        // Address
        //qdm.parentRec.ShipmentAddress__c = targetAccount.Address__c;

        // Department
        qdm.parentRec.ShipmentBelong__c = null;

        // Designation
        qdm.parentRec.ShipmentPost__c = null;

        // Responsible
        qdm.parentRec.ShipmentPersonInCharge__c = null;

        // Phone
        qdm.parentRec.ShipmentPhone__c = targetAccount.Phone;

        // Email
        qdm.parentRec.ShipmentEmail__c = null;

        // Fax
        qdm.parentRec.ShipmentFax__c = targetAccount.Fax;

//        qdm.parentRec.UnitBody__c = null;
        qdm.parentRec.ShipmentAccount_dummyField__c = null;
    }

    // アカウント情報取得(ContractContact_dummyField__c)
    public void contractContactAttachment() {

        String contactId = qdm.parentRec.ContractContact_dummyField__c;
        Contact targetContact = null;
        List<Contact> recs = [SELECT
                                id, Name, Phone, Email, Fax, Title, Affiliation__c, AccountId, Account.Name,
                                Account.Code__c, Account.Address__c,  Account.PostalCode__c, Account.Undergraduate__c,
                                Account.OfficialName1__c, Account.OfficialName2__c, Account.OfficialNameRow1__c, Account.OfficialNameRow2__c
                            FROM Contact
                            WHERE id =: contactId];
        if (recs != null && recs.size() > 0) {
            targetContact = recs.get(0);
        } else {
            targetContact = new Contact();
        }

system.debug('contractContactAttachment:targetContact = ' + targetContact);

        if (targetContact.Account != null) {

            // 取引先アカウント設定
            qdm.parentRec.ContractAccount__c = targetContact.AccountId;

            // Customer
            qdm.parentRec.ContractCode__c = targetContact.Account.Code__c;
            qdm.parentRec.ContractName__c = targetContact.Account.Name;

            // Customer Name 1, 2
            if (targetContact.Account.OfficialNameRow1__c != null && targetContact.Account.OfficialNameRow1__c.length() > 0) {
                // 正式名称1に入力ある場合、正式名称1、2を設定
                qdm.parentRec.ContractName1__c = targetContact.Account.OfficialNameRow1__c;
                qdm.parentRec.ContractName2__c = targetContact.Account.OfficialNameRow2__c;
            } else {
                // 正式名称1に入力ない場合、正式名称(1、2行目)を設定
                qdm.parentRec.ContractName1__c = targetContact.Account.OfficialName1__c;
                qdm.parentRec.ContractName2__c = targetContact.Account.OfficialName2__c;
            }

            // Branch Office
            qdm.parentRec.ContractUndergraduate__c = targetContact.Account.Undergraduate__c;

            // Address
            qdm.parentRec.ContractAddress__c = targetContact.Account.Address__c;
//            qdm.parentRec.ContractPostalCode__c = targetContact.Account.PostalCode__c;
        }

        // Department
        qdm.parentRec.ContractBelong__c = targetContact.Affiliation__c;

        // Designation
        qdm.parentRec.ContractPost__c = targetContact.Title;

        // Responsible
        qdm.parentRec.ContractPersonInCharge__c = targetContact.Name;

        // Phone
        qdm.parentRec.ContractPhone__c = targetContact.Phone;

        // Email
        qdm.parentRec.ContractEmail__c = targetContact.Email;

        // Fax
        qdm.parentRec.ContractFax__c = targetContact.Fax;

        qdm.parentRec.ContractContact_dummyField__c = null;
    }

    // アカウント情報取得(ShipmentContact_dummyField__c)
    public void shipmentContactAttachment() {

        String contactId = qdm.parentRec.ShipmentContact_dummyField__c;
        Contact targetContact = null;
        List<Contact> recs = [SELECT
                                id, Name, Phone, Email, Fax, Title, Affiliation__c, AccountId, Account.Name,
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

system.debug('shipmentContactAttachment:targetContact = ' + targetContact);

        if (targetContact.Account != null) {

            // 取引先アカウント設定
            qdm.parentRec.ShipmentAccount__c = targetContact.AccountId;

            // Customer
            qdm.parentRec.ShipmentCode__c = targetContact.Account.Code__c;
            //qdm.parentRec.ShipmentName__c = targetContact.Account.Name;

            // Customer Name 1, 2
            if (targetContact.Account.OfficialNameRow1__c != null && targetContact.Account.OfficialNameRow1__c.length() > 0) {
                // 正式名称1に入力ある場合、正式名称1、2を設定
                qdm.parentRec.ShipmentName1__c = targetContact.Account.OfficialNameRow1__c;
                qdm.parentRec.ShipmentName2__c = targetContact.Account.OfficialNameRow2__c;
            } else {
                // 正式名称1に入力ない場合、正式名称(1、2行目)を設定
                qdm.parentRec.ShipmentName1__c = targetContact.Account.OfficialName1__c;
                qdm.parentRec.ShipmentName2__c = targetContact.Account.OfficialName2__c;
            }

            // Branch Office
            qdm.parentRec.ShipmentUndergraduate__c = targetContact.Account.Undergraduate__c;

            // Address
            //qdm.parentRec.ShipmentAddress__c = targetContact.Account.Address__c;
        }

        // Department
        qdm.parentRec.ShipmentBelong__c = targetContact.Affiliation__c;

        // Designation
        qdm.parentRec.ShipmentPost__c = targetContact.Title;

        // Responsible
        qdm.parentRec.ShipmentPersonInCharge__c = targetContact.Name;

        // Phone
        qdm.parentRec.ShipmentPhone__c = targetContact.Phone;

        // Email
        qdm.parentRec.ShipmentEmail__c = targetContact.Email;

        // Fax
        qdm.parentRec.ShipmentFax__c = targetContact.Fax;

        qdm.parentRec.ShipmentContact_dummyField__c = null;
//        qdm.parentRec.UnitBody__c = null;
    }

    // データコピー(CopyfromPC)
    public void copyFromPC_onclick() {

system.debug('copyFromPC:qdm.parentRec.ProfitCalculation__c = ' + qdm.parentRec.ProfitCalculation__c);

        try {
            // AsiaProfitCalculation__c取得処理
            AsiaProfitCalculation__c rec = null;
            rec = copyFromPC_getCalc(qdm.parentRec);

            // ■Profit Calculation Informations
            copyFromPC_PCI(qdm.parentRec, rec);

            // ■Sold To Informations
            copyFromPC_SoldTI(qdm.parentRec, rec);

            // ■Ship To Informations
            copyFromPC_ShipTI(qdm.parentRec, rec);

            // ■Products Informations
            copyFromPC_PI(qdm.parentRec, rec);

system.debug('copyFromPC:qdm.parentRec = ' + qdm.parentRec);
system.debug('copyFromPC:qdm.itemsAll = ' + qdm.itemsAll);

        } catch(Exception e) {
            String message = e.getMessage();
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
system.debug('copyFromPC:message = ' + message);
        }
    }

    // データコピー(CopyfromPC_PI section)
    public void copyFromPC_PI_onclick() {

system.debug('copyFromPC_PI_onclick:qdm.parentRec.ProfitCalculation__c = ' + qdm.parentRec.ProfitCalculation__c);

        try {
            // AsiaProfitCalculation__c取得処理
            AsiaProfitCalculation__c rec = null;
            rec = copyFromPC_getCalc(qdm.parentRec);

            // ■Products Informations
            copyFromPC_PI(qdm.parentRec, rec);

system.debug('copyFromPC_PI_onclick:qdm = ' + qdm);
system.debug('copyFromPC_PI_onclick:qdm.parentRec = ' + qdm.parentRec);
system.debug('copyFromPC_PI_onclick:qdm.itemsAll = ' + qdm.itemsAll);

        } catch(Exception e) {
            String message = e.getMessage();
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
system.debug('copyFromPC_PI_onclick:message = ' + message);
        }
    }

    // データコピー(CopyfromPC_AsiaProfitCalculation__c取得処理)
    public AsiaProfitCalculation__c copyFromPC_getCalc(AsiaProjectMaster__c asiaRec) {

        // 必須チェック
        List<String> errorFields = new List<String>();

        // PC No.
        if (String.isBlank(asiaRec.ProfitCalculation__c)) {
            errorFields.add('PC No.');
        }

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

        String targetId = asiaRec.ProfitCalculation__c;

        List<AsiaProfitCalculation__c> recs = [
            SELECT
                id, name, RecordTypeId, RecordType.Name, CurrencyIsoCode, LastModifiedDate, CreatedDateFormula__c, SalesPerson__c, SalesPerson__r.Name, CompanyName__c,
                TotalAmount__c, ContractCode__c, ContractAddress__c, ContractBelong__c,
                ContractPersonInCharge__c, ContractPhone__c, ContractFax__c, ContractName__c, ContractName1__c, ContractName2__c, ContractPost__c,
                /*Series__c,*/ ProfitCalculationNo__c,
                SalesAssistant__c,
                BranchNo__c, /*ShipmentCode__c, ShipmentAddress__c,*/ ShipmentBelong__c,
                ShipmentPersonInCharge__c, ShipmentPhone__c, ShipmentFax__c, /*ShipmentName__c,*/ ShipmentName1__c, ShipmentName2__c, ShipmentPost__c, IssueDate__c, 
                createdById, createdBy.name, OrgName__c, Subtitle__c,
                CustomReductionName1__c, CustomReductionAmount1__c, CustomReductionName2__c,
                CustomReductionAmount2__c, CustomReductionName3__c, CustomReductionAmount3__c, ConsumptionTaxAmount__c,
                TotalTaxAmount__c, TaxRate__c, DeliveryCondition1__c, DeliveryCondition2__c, DeliveryPeriod__c,
                DeliveryDeadline__c, DeliveryDate_Arbitrarily__c, PaymentConditionSection__c,
                UnitBody__c, SupervisorName__c, SupervisorPosition__c,
                SubtitleLabel__c, OutputTotalTaxAmount__c,
                SubtotalReductionName1__c, SubtotalReductionAmount1__c, OutputSubtotalReduction1__c,
                SubtotalReductionName2__c, SubtotalReductionAmount2__c, OutputSubtotalReduction2__c,
                TotalAmountName__c, TotalTaxAmountName__c, /*Status__c,*/
                OutputConsumptionTaxAmount__c, OutputTotalAmount__c, OutputSubtitle__c,
                ContractAccount__c, ContractAccount_dummyField__c, ContractAccount__r.Name, ShipmentAccount__c, ShipmentAccount_dummyField__c, ShipmentAccount__r.Name, ContractContact_dummyField__c, ShipmentContact_dummyField__c,
                SalesPipeLineLkup__c, ContractPostalCode__c, ContractUndergraduate__c, ShipmentPostalCode__c,
                ShipmentUndergraduate__c, SalesCurrency__c, JProdCostCurrency__c, AsiaProjectMaster__c
            FROM
                AsiaProfitCalculation__c
            WHERE
                Id =: targetId
        ];

system.debug('copyFromPC:recs = ' + recs);

        AsiaProfitCalculation__c rec = null;

        if (recs != null && recs.size() > 0) {
            rec = recs.get(0);
        } else {
            throw new JEOLException('That PC No does not exist');
        }

        return rec;
    }

    // データコピー(CopyfromPC_Profit Calculation Informations)
    public void copyFromPC_PCI(AsiaProjectMaster__c asiaRec, AsiaProfitCalculation__c calcRec) {

        // ■Profit Calculation Informations

        // Company
        asiaRec.CompanyName__c = calcRec.CompanyName__c;

        // Company Name
        asiaRec.OrgName__c = calcRec.OrgName__c;

        // Series
        //asiaRec.Series__c = calcRec.Series__c;

        // Salesperson
        asiaRec.SalesPerson__c = calcRec.SalesPerson__c;

        // Assistant
        asiaRec.SalesAssistant__c = calcRec.SalesAssistant__c;
    }

    // データコピー(CopyfromPC_Sold To Informations)
    public void copyFromPC_SoldTI(AsiaProjectMaster__c asiaRec, AsiaProfitCalculation__c calcRec) {

        // ■Sold To Informations

        // Customer
        asiaRec.ContractAccount__c = calcRec.ContractAccount__c;
        asiaRec.ContractCode__c = calcRec.ContractCode__c;
        asiaRec.ContractName__c = calcRec.ContractName__c;
        asiaRec.ContractAccount_dummyField__c = calcRec.ContractAccount_dummyField__c;

        // Customer Name 1
        asiaRec.ContractName1__c = calcRec.ContractName1__c;

        // Customer Name 2
        asiaRec.ContractName2__c = calcRec.ContractName2__c;

        // Branch Office
        asiaRec.ContractUndergraduate__c = calcRec.ContractUndergraduate__c;

        // Address
        asiaRec.ContractAddress__c = calcRec.ContractAddress__c;

        // Department
        asiaRec.ContractBelong__c = calcRec.ContractBelong__c;

        // Designation
        asiaRec.ContractPost__c = calcRec.ContractPost__c;

        // Responsible
        asiaRec.ContractPersonInCharge__c = calcRec.ContractPersonInCharge__c;

        // Phone
        asiaRec.ContractPhone__c = calcRec.ContractPhone__c;

        // Email
//        asiaRec.ContractEmail__c = ?

        // Fax
        asiaRec.ContractFax__c = calcRec.ContractFax__c;
    }

    // データコピー(CopyfromPC_Ship To Informations)
    public void copyFromPC_ShipTI(AsiaProjectMaster__c asiaRec, AsiaProfitCalculation__c calcRec) {

        // ■Ship To Informations

        // Customer
        asiaRec.ShipmentAccount__c = calcRec.ShipmentAccount__c;
        asiaRec.ShipmentCode__c = calcRec.ShipmentCode__c;
        //asiaRec.ShipmentName__c = calcRec.ShipmentName__c;
        asiaRec.ShipmentAccount_dummyField__c = calcRec.ShipmentAccount_dummyField__c;

        // Customer Name 1
        asiaRec.ShipmentName1__c = calcRec.ShipmentName1__c;

        // Customer Name 2
        asiaRec.ShipmentName2__c = calcRec.ShipmentName2__c;

        // Branch Office
        asiaRec.ShipmentUndergraduate__c = calcRec.ShipmentUndergraduate__c;

        // Address
        //asiaRec.ShipmentAddress__c = calcRec.ShipmentAddress__c;

        // Department
        asiaRec.ShipmentBelong__c = calcRec.ShipmentBelong__c;

        // Designation
        asiaRec.ShipmentPost__c = calcRec.ShipmentPost__c;

        // Responsible
        asiaRec.ShipmentPersonInCharge__c = calcRec.ShipmentPersonInCharge__c;

        // Phone
        asiaRec.ShipmentPhone__c = calcRec.ShipmentPhone__c;

        // Email
//        asiaRec.ShipmentEmail__c = ?

        // Fax
        asiaRec.ShipmentFax__c = calcRec.ShipmentFax__c;
    }

    // データコピー(CopyfromPC_Products Informations from PC)
    public void copyFromPC_PI(AsiaProjectMaster__c asiaRec, AsiaProfitCalculation__c calcRec) {

        // ■Products Informations

system.debug('copyFromPC:calcRec.id = ' + calcRec.id);

        // 詳細データ削除準備
        this.deleteTargets = new List<AsiaProjectMasterDetail__c>();

        // 親のIDより、詳細データを取得
        this.deleteTargets = this.qdm.getDetailRecs(asiaRec.id);
system.debug('copyFromPC:deleteTargets = ' + this.deleteTargets);


        // 親のIDより、詳細データを取得(AsiaProfitCalculationDetail__c)
        List<AsiaProfitCalculationDetail__c> calcDetails = qdm.getCalcDetailRecs(calcRec.id);

system.debug('copyFromPC:calcDetails = ' + calcDetails);

        AsiaProjectMasterDetail__c masterDetail = new AsiaProjectMasterDetail__c();
        qdm.itemsAll = new List<QuotationDetailItem>();

        // SalesCurrency__c
        asiaRec.SalesCurrency__c = calcRec.SalesCurrency__c;
system.debug('copyFromPC:SalesCurrency__c = ' + asiaRec.SalesCurrency__c);

        for (AsiaProfitCalculationDetail__c calcDetail: calcDetails) {

            if (calcDetail.Category__c == 'A' || calcDetail.Category__c == 'B' ) {
                // AsiaProfitCalculationDetail__c詳細データから
                // カテゴリAまたはBのデータをコピー
                masterDetail = new AsiaProjectMasterDetail__c();
                // Category
                masterDetail.Category__c = calcDetail.Category__c;
                // ソート順
                //masterDetail.SortNo__c = calcDetail.SortNo__c;
                // 階層
                masterDetail.Depth__c = calcDetail.Depth__c;
                // Type
                masterDetail.Type__c = calcDetail.Type__c;
                // Product Name
                //masterDetail.Body__c = calcDetail.Body__c;
                // Model Type
                //masterDetail.ModelType__c = calcDetail.ModelType__c;
                // Qty
                masterDetail.Quantity__c = calcDetail.Quantity__c;
                // Unit Price
                masterDetail.UnitPrice__c = calcDetail.UnitPrice__c;
                // Cur
                masterDetail.CatalogCurrency__c = calcDetail.CatalogCurrency__c;
                // Cost Price
                masterDetail.CostPrice__c = calcDetail.CostPrice__c;
                // Cur
                masterDetail.CostPriceUnit__c = calcDetail.CostPriceUnit__c;
                // Sales Price
                masterDetail.SalesPrice__c = calcDetail.SalesPrice__c;
                // Description
                masterDetail.Description__c = calcDetail.Description__c;
                // Supplier
                masterDetail.Supplier__c = calcDetail.Supplier__c;
                // 課税対象
                masterDetail.IsTaxationTarget__c = calcDetail.IsTaxationTarget__c;
                // 諸経費対象
                masterDetail.IsOverheadTarget__c = calcDetail.IsOverheadTarget__c;
                // 明細金額表示
                masterDetail.IsShowDetailAmount__c = calcDetail.IsShowDetailAmount__c;
                // 別紙出力
                masterDetail.AccompanyingPaperOutput__c = calcDetail.AccompanyingPaperOutput__c;

                qdm.itemsAll.add(new QuotationDetailItem(masterDetail));
            }
        }
system.debug('copyFromPC:qdm.itemsAll.rec = ' + qdm.itemsAll);
    }

    // データコピー(契約先⇒納入先)
    public void contractAccountInputCopy() {
        qdm.parentRec.ShipmentAccount__c = qdm.parentRec.ContractAccount__c;
        // Customer
        qdm.parentRec.ShipmentCode__c = qdm.parentRec.ContractCode__c;
        //qdm.parentRec.ShipmentName__c = qdm.parentRec.ContractName__c;
        // Customer Name1
        qdm.parentRec.ShipmentName1__c = qdm.parentRec.ContractName1__c;
        // Customer Name2
        qdm.parentRec.ShipmentName2__c = qdm.parentRec.ContractName2__c;
        // Branch Office
        qdm.parentRec.ShipmentUndergraduate__c = qdm.parentRec.ContractUndergraduate__c;
        // Address
        //qdm.parentRec.ShipmentAddress__c= qdm.parentRec.ContractAddress__c;
//        qdm.parentRec.ShipmentPostalCode__c = qdm.parentRec.ContractPostalCode__c;
        // Department
        qdm.parentRec.ShipmentBelong__c = qdm.parentRec.ContractBelong__c;
        // Designation
        qdm.parentRec.ShipmentPost__c = qdm.parentRec.ContractPost__c;
        // Responsible
        qdm.parentRec.ShipmentPersonInCharge__c = qdm.parentRec.ContractPersonInCharge__c;
        // Phone
        qdm.parentRec.ShipmentPhone__c = qdm.parentRec.ContractPhone__c;
        // Email
        qdm.parentRec.ShipmentEmail__c = qdm.parentRec.ContractEmail__c;
        // Fax
        qdm.parentRec.ShipmentFax__c = qdm.parentRec.ContractFax__c;

system.debug('contractAccountInputCopy:' + qdm.parentRec);
    }

    // 新規レコード作成
    private AsiaProjectMaster__c createNewRecord() {

        AsiaProjectMaster__c newRecord = new AsiaProjectMaster__c();

        return newRecord;
    }

    // AsiaProjectMaster__cより、レコード取得
    private AsiaProjectMaster__c getTargetRecord(String targetId) {

        AsiaProjectMaster__c targetaRecord = null;

system.debug('■■■getTargetRecord:start');
system.debug('getTargetRecord:targetId = ' + targetId);

        List<AsiaProjectMaster__c> recs = [
            SELECT
                id, name, LastModifiedDate, ProjectNumber__c, /*Series__c,*/ SalesPerson__c, SalesAssistant__c, ContractName__c, Model__c, /*Status__c,*/
                ContractPrice__c, CurrencyContractPrice__c, ContractCode__c, CreatedDateFormula__c, SerialNumber__c,
                ContractNumber__c, CustomerPONumber__c, DepartmentName__c, Company__c, CompanyName__c, OrgName__c, ProfitCalculation__c, ContractName1__c,
                ContractName2__c, ContractUndergraduate__c, ContractAddress__c, ContractBelong__c, ContractPost__c,
                ContractPersonInCharge__c, ContractPhone__c, ContractEmail__c, ContractFax__c, ShipmentCode__c,
                /*ShipmentName__c,*/ ShipmentName1__c, ShipmentName2__c, ShipmentUndergraduate__c, /*ShipmentAddress__c,*/
                ShipmentBelong__c, ShipmentPost__c, ShipmentPersonInCharge__c, ShipmentPhone__c, ShipmentEmail__c,
                ShipmentFax__c, ContractStartDate__c, ContractEndDate__c, ExpirationMonth__c,
                ContractAccount_dummyField__c, ContractContact_dummyField__c, ShipmentAccount_dummyField__c,
                ShipmentContact_dummyField__c, ContractAccount__c, ShipmentAccount__c, SalesCurrency__c, OrganizationDescription__c,
                UserRecordAccess.HasEditAccess,
                //0813 ZH Add
                Shipping_Date__c,Instalation_Date__C,CertificatdDate__c,ContractPerson__c,ShipmentPerson__c,ContractAccount__r.CountryCode__c,
                //0813 ZH Add End
                (SELECT Id, NewContractStartDate__c, NewContractEndDate__c, ContractStopDate__c, /*Status__c,*/type__c,Description__c FROM MaintenanceContractManagement_ProjMaster__r)
            FROM
                AsiaProjectMaster__c
            WHERE
                Id =: targetId
        ];

        if (recs != null && recs.size() > 0) {
            targetaRecord = recs.get(0);

            if (targetaRecord.ContractStartDate__c != NULL && targetaRecord.ContractStartDate__c <= System.today() && 
                targetaRecord.ContractEndDate__c != NULL && targetaRecord.ContractEndDate__c >= System.today()) {
                //targetaRecord.Status__c = STATUS_UNDER_WARRANTY;
            } else {
                boolean fIsContracted = false;
                if (targetaRecord.MaintenanceContractManagement_ProjMaster__r != NULL && targetaRecord.MaintenanceContractManagement_ProjMaster__r.size() > 0) {
                    for (AsiaMaintenanceContractManagement__c mcm : targetaRecord.MaintenanceContractManagement_ProjMaster__r) {
                        if (mcm.NewContractStartDate__c != NULL && mcm.NewContractStartDate__c <= System.today() && 
                            mcm.NewContractEndDate__c != NULL && mcm.NewContractEndDate__c >= System.today() //&& 
                            //mcm.Status__c == MCM_STATUS_CONTRACTED
                            ) {
                            fIsContracted = true;
                        }
                        if (mcm.NewContractStartDate__c != NULL && mcm.NewContractStartDate__c <= System.today() && 
                            mcm.ContractStopDate__c != NULL && mcm.ContractStopDate__c >= System.today() //&& 
                            //mcm.Status__c == MCM_STATUS_CONTRACT_CANCELLATION
                            ) {
                            fIsContracted = true;
                        }
                        if (mcm.NewContractStartDate__c != NULL && mcm.NewContractStartDate__c <= System.today() && 
                            mcm.ContractStopDate__c == NULL && mcm.NewContractEndDate__c != NULL && mcm.NewContractEndDate__c >= System.today() //&& 
                            //mcm.Status__c == MCM_STATUS_CONTRACT_CANCELLATION
                            ) {
                            fIsContracted = true;
                        }
                    }
                }
                //targetaRecord.Status__c = fIsContracted ? STATUS_CONTRACTED : STATUS_NO_CONTRACT;
            }

        } else {
            throw new JEOLException('不正な操作が行われました。');
        }

system.debug('■■■getTargetRecord:end');
        return targetaRecord;
    }
    
    //0817 ZH Add
    // 詳細レコード取得(AsiaProjectMasterDetail__c)
    private List<SVC_Report__c> getSVCRecs(String parentId) {
        
        List<SVC_Report__c> recs = [
            SELECT
            id, name //, SVCTitle__c,Update_Date__c,Service_Type__c,Service_Form__c,Status__c
            //0816 ZH Add End
            FROM
            SVC_Report__c
            WHERE
            ProjectMaster__c =: parentId
        ];
        system.debug('getDetailRecs:recs = ' + recs);
        
        return recs;
    }
    //0817 ZH Add
    
    //0829 ZH Add
    // 詳細レコード取得(AsiaProjectMasterDetail__c)
    private List<AsiaMaintenanceContractManagement__c> getmcmRecs(String parentId) {
        
        List<AsiaMaintenanceContractManagement__c> recs = [
            SELECT
            Id, NewContractStartDate__c, NewContractEndDate__c, ContractStopDate__c/*, Status__c*/,type__c,Description__c
            FROM
            AsiaMaintenanceContractManagement__c
            WHERE
            ProjectMaster__c =: parentId
        ];
        system.debug('getDetailRecs:recs = ' + recs);
        
        return recs;
    }
    //0829 ZH Add
    
    //0828 ZH Add
    // 詳細レコード取得(AsiaProfitCalculationDetail2SP__c)
    /*private List<AsiaProfitCalculationDetail2SP__c> getSPRecs(String parentId) {
        
        List<AsiaProfitCalculationDetail2SP__c> recs = [
            SELECT
            id, name, Amount__c,Description__c,Update_Date__c,Parts_Name__c
            //0816 ZH Add End
            FROM
            AsiaProfitCalculationDetail2SP__c
            WHERE
            ProfitCalculationDetail__r.AsiaProfitCalculationDetail__c =: parentId
        ];
        system.debug('getDetailRecs:recs = ' + recs);
        
        return recs;
    }*/
    //0817 ZH Add

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

    // Save処理
    public Pagereference saveAction() {
system.debug('■■■saveAction:start');

        scrollTopValue = 0;

        Pagereference ref = null;
        Savepoint sp = Database.setSavepoint();

        try {
            qdm.refresh();

            // エラーチェック
            List<String> errorFields = qdm.requireCheck(isReadOnly);

system.debug('saveAction:errorFields = ' + errorFields);

            if (errorFields.size() > 0) {
                // エラー項目あり

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

            // Sold／Ship To Informations Customer 取引先存在チェック

            errorFields = null;
            errorFields = qdm.accountCheck();

system.debug('saveAction:account errorFields = ' + errorFields);

            if (errorFields.size() > 0) {
                String errorText = null;
                for (String field: errorFields) {
                    if (String.isBlank(errorText)) {
                        errorText ='The Customer does not exist. ';
                    } else {
                        errorText += ', ';
                    }
                    errorText += '['+field+']';
                }
                throw new JEOLException(errorText);
            }

            AsiaProjectMaster__c parentRec = qdm.parentRec;
system.debug('saveAction:qdm.parentRec = ' + qdm.parentRec);

            if (parentRec.Id != null)
            {
                // AsiaProjectMaster__cにデータあり
                AsiaProjectMaster__c refreshedParentRec = [SELECT Id, Name, LastModifiedDate, LastModifiedBy.Name FROM AsiaProjectMaster__c WHERE Id=:parentRec.Id];

system.debug('saveAction:refreshedParentRec = ' + refreshedParentRec);

                if(parentRec.LastModifiedDate != refreshedParentRec.LastModifiedDate)
                    // 最終更新日に相違有

                    throw new JEOLException('This record has been modified by ' + refreshedParentRec.LastModifiedBy.Name + ' at ' + refreshedParentRec.LastModifiedDate.format() + '. Please reload the data before making again your modifications.');
            }

            if (parentRec.Name != null && parentRec.Name.length() > 50) {
                throw new JEOLException(Label.JEOL_Quotation_Message_TitleTooLong);
            }
            if ((qdm.parentRec.ContractName2__c != null) && (JEOLUtil.getSizeInBytes(qdm.parentRec.ContractName2__c) <> qdm.parentRec.ContractName2__c.length()) && (qdm.parentRec.ContractName2__c.length() > 20) ) {
                throw new JEOLException('契約先名称2の文字数が、最大文字数を超えています。全角20文字、半角50文字以内に変更してください。');
            }
            if ((qdm.parentRec.ShipmentName2__c != null) && (JEOLUtil.getSizeInBytes(qdm.parentRec.ShipmentName2__c) <> qdm.parentRec.ShipmentName2__c.length()) && (qdm.parentRec.ShipmentName2__c.length() > 20) ) {
                throw new JEOLException('納入先名称2の文字数が、最大文字数を超えています。全角20文字、半角50文字以内に変更してください。');
            }

            parentRec.ContractContact_dummyField__c = null;
            parentRec.ShipmentContact_dummyField__c = null;

            // NameにProjectNumber__cを設定
            //qdm.parentRec.Name = qdm.parentRec.ProjectNumber__c;

            // AsiaProjectMaster__c更新
            upsert parentRec;

            // 不要な詳細データ削除
            if (this.deleteTargets.size() > 0) {
system.debug('delete :size = ' + this.deleteTargets.size());
                delete this.deleteTargets;
            }

system.debug('saveAction:qdm.parentRec.ProjectNumber__c = ' + qdm.parentRec.ProjectNumber__c);
system.debug('saveAction:qdm.parentRec.ProfitCalculation__c = ' + qdm.parentRec.ProfitCalculation__c);

            // ProfitCalculation__cのProjectNumber__c更新
            if (qdm.parentRec.ProfitCalculation__c != NULL) {
                List<AsiaProfitCalculation__c> calcs = [SELECT
                                                            Id, AsiaProjectMaster__c
                                                        FROM
                                                            AsiaProfitCalculation__c
                                                        WHERE
                                                            Id =:qdm.parentRec.ProfitCalculation__c];
system.debug('saveAction:calcs = ' + calcs);

                For (AsiaProfitCalculation__c calc : calcs) {
system.debug('saveAction:calc.Id = ' + calc.Id);
                    calc.AsiaProjectMaster__c = qdm.parentRec.Id;
                }

                // AsiaProfitCalculation__cのAsiaProjectMaster__cを更新
                upsert calcs;
            }

            // 詳細データ保存設定
            List<AsiaProjectMasterDetail__c> details = new List<AsiaProjectMasterDetail__c>();

system.debug('saveAction:qdm.itemsAll = ' + qdm.itemsAll);
            for (QuotationDetailItem item: qdm.itemsAll) {

                AsiaProjectMasterDetail__c rec = item.rec;

                if (rec.parent__c != parentRec.id) {
                    rec.parent__c = parentRec.id;
                }

                details.add(rec);
            }
system.debug('saveAction:details = ' + details);

            // 詳細データ削除処理
            List<AsiaProjectMasterDetail__c> deleteTargets = new List<AsiaProjectMasterDetail__c>();
            for (QuotationDetailItem item: qdm.baseItemsAll) {
                if (item.isDeleted) {
                    deleteTargets.add(item.rec);
                }
            }

            if (details.size() > 0) {
                // 詳細データが存在する場合、データ更新
system.debug('saveAction:details upsert = ' + details);

                upsert details;
            }

            if (deleteTargets.size() > 0) {
                // 削除データが存在する場合、データ削除
system.debug('saveAction:details delete = ' + deleteTargets);
                delete deleteTargets;
            }

            qdm.parentRec = getTargetRecord(parentRec.id);

            ref = Page.JEOLAsia_ProjectMaster;
            ref.getParameters().put(PARAM_ID, parentRec.id);
            ref.getParameters().put(SCROLL_TOP, String.valueOf(currentScrollValue));
            ref.setRedirect(true);

system.debug('saveAction:qdm.parentRec = ' + qdm.parentRec);
system.debug('saveAction:parentRec.id = ' + parentRec.id);
system.debug('saveAction:currentScrollValue = ' + currentScrollValue);

        } catch(Exception e) {
            String message = e.getMessage();
            if (message == 'SB001' || message == 'SB002') {
                message = '採番に失敗しました。正しい値を入力してください。';
            }
            else if (message == 'SB003') {
                message= JEOLUtil.MSG_NUMBERING_ERROR;
            }
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
system.debug('saveAction:LastModifiedDate = ' + qdm.parentRec.LastModifiedDate);
            Database.rollback(sp);
system.debug('saveAction:LastModifiedDate2 = ' + qdm.parentRec.LastModifiedDate);
            return null;
        }
system.debug('saveAction:ref = ' + ref);
system.debug('■■■saveAction:end');

        return ref;
    }

    // 削除ボタン
    public Pagereference deleteAction() {

        AsiaProjectMaster__c parentRec = qdm.parentRec;
        delete parentRec;

        return Page.JEOLAsia_ProjectMasterList;
    }

    // 見積もり詳細管理クラス
    public class QuotationDetailManage {

        private List<QuotationDetailItem> itemsAll = new List<QuotationDetailItem>();
        private List<QuotationDetailItem> baseItemsAll = new List<QuotationDetailItem>();

        public AsiaProjectMaster__c parentRec{get; set;}     // 親レコード(AsiaProjectMaster__c)
        public AsiaProjectMaster__c baseParentRec{get; set;} // 親基本レコード(AsiaProjectMaster__c)
        public String createdItemInfos{get; set;}
        public String selectedQuotationId{get; set;}
        public String targetAccountId{get; set;}


        public QuotationDetailManage(AsiaProjectMaster__c parentRec, Boolean isCopy, Boolean isNew) {

system.debug('■■■QuotationDetailManage:start');
system.debug('QuotationDetailManage:parentRec.id = ' + parentRec.id);

            // 親のIDより、詳細データを取得
            List<AsiaProjectMasterDetail__c> recs = this.getDetailRecs(parentRec.id);
            if (recs == null) {
                // 詳細データが存在しない場合(新規作成)
                recs = new List<AsiaProjectMasterDetail__c>();
            }

            List<QuotationDetailItem> localItemsAll = this.itemsAll;

            for (AsiaProjectMasterDetail__c rec: recs) {
                if (isCopy) {
                    rec = rec.clone(false, true, false, false);
                }
                QuotationDetailItem item = new QuotationDetailItem(rec);
                //itemsAll.add(item);
                localItemsAll.add(item);
            }
            
            if (isCopy) {
                parentRec = parentRec.clone(false, true, false, false);

            } else {
                if (isNew) {
                    // 新規作成時
//                    parentRec.ProfitCalculationNo__c = 'PC';
                    parentRec.ProjectNumber__c = '';
                }
                this.baseItemsAll = localItemsAll.clone();
            }

            this.parentRec = parentRec;

            this.baseParentRec =  this.parentRec.clone(true);

system.debug('■■■QuotationDetailManage:end');
        }

        // エラーチェック
        public List<String> requireCheck(boolean isReadOnly) {

            AsiaProjectMaster__c rec = this.parentRec;
            List<String> checkList = new List<String>();

system.debug('■■■requireCheck:start');
            // Do not make the check for read only mode
            if (isReadOnly) {
                return checkList;
            }

            // 必須チェック

            // Project No
            //if (String.isBlank(rec.ProjectNumber__c)) {
            //    checkList.add('Project No');
            //}
            //if (String.isBlank(rec.Name)) {
            //    checkList.add('Project No');
            //}
            // Series
            //if (String.isBlank(rec.Series__c)) {
            //    checkList.add('Series');
            //}
            // SalesPerson
            if (String.isBlank(rec.SalesPerson__c)) {
                checkList.add('SalesPerson');
            }
            // Sold To Informations Customer
            if (String.isBlank(rec.ContractCode__c)) {
                checkList.add('Sold To Informations Customer');
            }
            // Ship To Informations Customer
            if (String.isBlank(rec.ShipmentCode__c)) {
                checkList.add('Ship To Informations Customer');
            }

            return checkList;
        }

        // 取引先存在チェック
        public List<String> accountCheck() {

            AsiaProjectMaster__c rec = this.parentRec;
            List<String> checkList = new List<String>();

            // Sold To Informations Customer
            List<Account> recs = [SELECT id, Name FROM Account WHERE Code__c =: rec.ContractCode__c];
system.debug('accountCheck:contract recs = ' + recs);

            if (recs == null || recs.size() <= 0) {
                // 取引先が存在しない場合
                checkList.add('Sold To Informations Customer');
            }

            // Ship To Informations Customer
            recs = null;
            recs = [SELECT id, Name FROM Account WHERE Code__c =: rec.ShipmentCode__c];
system.debug('accountCheck:shipment recs = ' + recs);

            if (recs == null || recs.size() <= 0) {
                // 取引先が存在しない場合
                checkList.add('Ship To Informations Customer');
            }

            return checkList;
        }

        // 詳細レコード取得(AsiaProjectMasterDetail__c)
        private List<AsiaProjectMasterDetail__c> getDetailRecs(String parentId) {

            List<AsiaProjectMasterDetail__c> recs = [
                    SELECT
                        id, name, Depth__c, /*SortNo__c,*/ Type__c, Amount__c, Parent__c,
                        Quantity__c, /*Body__c,*/ Category__c, IsTaxationTarget__c, IsOverheadTarget__c,
                        IsShowDetailAmount__c, AccompanyingPaperOutput__c,
                        CostPrice__c, SalesPrice__c, /*ModelType__c,*/ UnitPrice__c, CatalogCurrency__c, CostPriceUnit__c,
                        Description__c, Supplier__c
                        //0816 ZH Add
                        /*,Parent__r.SerialNumber__c*/,Parent__r.Shipping_Date__c
                        //0816 ZH Add End
                    FROM
                        AsiaProjectMasterDetail__c
                    WHERE
                        Parent__c =: parentId
                    ORDER BY
                        /*SortNo__c,*/ Depth__c Asc
            ];
system.debug('getDetailRecs:recs = ' + recs);

            return recs;
        }
        

        // 詳細レコード取得(AsiaProfitCalculationDetail__c)
        private List<AsiaProfitCalculationDetail__c> getCalcDetailRecs(String parentId) {

            List<AsiaProfitCalculationDetail__c> recs = [
                    SELECT
                        id, name, Depth__c, /*SortNo__c,*/ Type__c, Amount__c, Parent__c,
                        Quantity__c, QuantityUnit__c, UnitPrice__c, /*Body__c,*/ CurrencyIsoCode,
                        ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c,
                        IsShowDetailAmount__c, DiscountAmount__c,
                        AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c,
                        CostPrice__c, SalesPrice__c, /*ModelType__c,*/ CatalogCurrency__c, CostPriceUnit__c,
                        Description__c, Supplier__c
                    FROM
                        AsiaProfitCalculationDetail__c
                    WHERE
                        Parent__c =: parentId
                    ORDER BY
                        /*SortNo__c,*/ Depth__c Asc
            ];
system.debug('getCalcDetailRecs:recs = ' + recs);

            return recs;
        }

        // 詳細データ全取得
        public List<QuotationDetailItem> getItemsAll() {
            refresh();
            return this.itemsAll;
        }
        // 詳細基本データ全取得
        public List<QuotationDetailItem> getBaseItemsAll() {
            return this.baseItemsAll;
        }

        // カテゴリ取得
        private List<QuotationDetailItem> getitemsCategory(String sCategory) {
            List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
system.debug('getitemsCategory:itemsAll = ' + itemsAll);
            for (QuotationDetailItem item : itemsAll) {
                if (item.rec.Category__c == sCategory) {
                    sReturn.add(item);
                }
            }
system.debug('getitemsCategory:sReturn = ' + sReturn);
            return sReturn;
        }

        // 基本カテゴリ取得
        private List<QuotationDetailItem> getbaseItemsCategory(String sCategory) {
            List<QuotationDetailItem> sReturn = new List<QuotationDetailItem>();
            for (QuotationDetailItem item : baseItemsAll) {
                if (item.rec.Category__c == sCategory) {
                    sReturn.add(item);
                }
            }
system.debug('getbaseItemsCategory:sReturn = ' + sReturn);
            return sReturn;
        }

        // カテゴリA取得
        public List<QuotationDetailItem> getItemsA() {
system.debug('getItemsA:start');
            refresh();
            return getitemsCategory('A');
        }
        // カテゴリB取得
        public List<QuotationDetailItem> getItemsB() {
system.debug('getItemsB:start');
            refresh();
            return getitemsCategory('B');
            
        }


        // 詳細データサイズ取得
        public Integer getCurrentSize() {
system.debug('■■■getCurrentSize:' + itemsAll.size());
            return itemsAll.size();
        }

        // カテゴリAの詳細データサイズ取得
        public Integer getCurrentSizeA() {

system.debug('■■■getCurrentSizeA:' + getitemsA());
            return getitemsA().size();
        }
        // カテゴリBの詳細データサイズ取得
        public Integer getCurrentSizeB() {

system.debug('■■■getCurrentSizeB:' + getitemsB());
            return getitemsB().size();
        }

        // 詳細データリフレッシュ
        public void refresh() {
system.debug('■■■refresh:start ');
            List<QuotationDetailItem> localItems = this.itemsAll;
            List<QuotationDetailItem> newItems = new List<QuotationDetailItem>();
system.debug('refresh:localItems = ' + localItems);

            localItems.sort();
            Decimal beforeDepth = 0;
            Integer cntA = 0;
            Integer cntB = 0;

            for (QuotationDetailItem item: localItems) {

                if (!item.isDeleted) {
                    integer cnt = 0;

                    if (item.rec.Category__c == 'A') {
                        cnt = cntA;
                    } else if (item.rec.Category__c == 'B') {
                        cnt = cntB;
                    }

                    //item.rec.SortNo__c = cnt;

                    if (cnt == 0) {
                        item.rec.Depth__c = 0;
                    } else {
                        if (item.rec.Depth__c == NULL) {
                            item.rec.Depth__c = 0;
                        } else {
                            if (item.rec.Depth__c - beforeDepth > 1) {
                                item.rec.Depth__c = beforeDepth + 1;
                            }
                        }
                    }

                    beforeDepth = item.rec.Depth__c;
                    newItems.add(item);

                    if (item.isCopy) {
                        AsiaProjectMasterDetail__c detailRec = item.detailCopy();
                        QuotationDetailItem copiedItem = new QuotationDetailItem(detailRec);
                        newItems.add(copiedItem);
                        //detailRec.SortNo__c = cnt;
                        cnt++;
                    }
                    cnt++;

                    if (item.rec.Category__c == 'A') {
                        cntA = cnt;
                    } else if (item.rec.Category__c == 'B') {
                        cntB = cnt;
                    }
                }
            }

            this.itemsAll = newItems;
system.debug('refresh:this.itemsAll = ' + this.itemsAll);
        }
    }

    // 見積もり詳細項目クラス
    public class QuotationDetailItem implements Comparable {

        public AsiaProjectMasterDetail__c rec {get; set;}
        public Boolean isDeleted{get; set;}
        public Boolean isCopy{get; set;}
        public string IdxRow{get; set;}
        
        // コンストラクタ
        public QuotationDetailItem (AsiaProjectMasterDetail__c target){
            this.rec = target;
            this.isDeleted = false;
            this.isCopy = false;

            Blob b = Crypto.GenerateAESKey(128);
            system.debug('※※※※※※※※'+b);
            String h = EncodingUtil.ConvertTohex(b);
            system.debug('※※※※※※※※'+h);
            this.IdxRow = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
            
        }

        // 削除実行フラグ設定
        public void deleteAction() {
            this.isDeleted = true;
        }

/*
        // コピー実行フラグ設定
        public void copyAction() {
            this.isCopy = true;
        }
*/
        // 詳細コピー
        public AsiaProjectMasterDetail__c detailCopy() {
            AsiaProjectMasterDetail__c ret = null;
            if (this.rec != null) {
                ret = this.rec.clone(false,true,false,false);
            }
            this.isCopy = false;
            return ret;
        }

        // 詳細タイプ取得
        public String getDetailType() {
            return this.rec.Type__c;
        }

        // カテゴリ比較
        public Integer compareTo(Object compareTo) {
            QuotationDetailItem compareTarget = (QuotationDetailItem)compareTo;
            Integer returnValue = 0;

            if (rec.Category__c > compareTarget.rec.Category__c) {
                returnValue = 1;
            } else if (rec.Category__c < compareTarget.rec.Category__c) {
                returnValue = -1;
            } else {
                /*if (rec.SortNo__c > compareTarget.rec.SortNo__c) {
                    returnValue = 1;
                } else if (rec.SortNo__c < compareTarget.rec.SortNo__c) {
                    returnValue = -1;
                }*/
            }
            return returnValue;
        }
    }

    // Activity取得(AsiaProjectMaster)
    public AsiaProjectMaster__c getAsiaProjectMaster() {

        AsiaProjectMaster__c rec = new AsiaProjectMaster__c();
        String targetId = '';

        Map<String, String> params = Apexpages.currentPage().getParameters();
        if (params.containsKey(PARAM_ID)) {
            targetId = params.get(PARAM_ID);
            rec = getTargetRecord(targetId);
        }

system.debug('▼▼▼AsiaProjectMaster : rec = ' + rec);

        return rec;
    }
}