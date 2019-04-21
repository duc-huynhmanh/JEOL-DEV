/*
 * Created : 2016/05/30 by Kobayashi (Voxer)
 */
public with sharing class JEOLAsia_CustomerInformationsCtrl {

    public static final String PARAM_ID = 'id';
    public static final String PARAM_PROFIT_CALCULATION_ID = 'pcid';
    public static final String CUSTINFO_OBJ = 'AsiaCustomerInformations__c';

    public Boolean isValid{get; set;} // 有効フラグ
    public Boolean isNew{get; set;}  // 新規作成
    public AsiaCustomerInformations__c rec{get; set;} //CustomerInformationオブジェクト
    public AsiaCustomerInformations__c baseRec{get; set;} //比較用オブジェクト

    //コンストラクタ
    public JEOLAsia_CustomerInformationsCtrl(ApexPages.StandardController controller) {

    try {
            this.isNew = true;
            this.isValid = false;

            String targetId = '';

            // パラメータ取得
            Map<String, String> params = Apexpages.currentPage().getParameters();
System.debug('コンストラクタ:params = ' + params);

            if (params.containsKey(PARAM_PROFIT_CALCULATION_ID)) {
                // パラメータIDが(AsiaProfitCalculation__c.Id)の場合

                // パラメータID(AsiaProfitCalculation__c.Id)が存在する場合(JEOLAsia_ProfitCalculationEditorPageから遷移)
System.debug('コンストラクタ:AsiaProfitCalculation__c.Idがパラメータ');
                targetId = params.get(PARAM_PROFIT_CALCULATION_ID);

                // レコード取得(キー：AsiaProfitCalculation__c.Id)
                rec = getTargetRecord(targetId, PARAM_PROFIT_CALCULATION_ID);

                if (NULL == rec) {
                    // データが存在しない場合
                    // ⇒新規作成
                    this.isNew = true;

                    // レコード新規作成
                    rec = createNewRecord(targetId);
System.debug('コンストラクタ:rec新規作成 = ' + rec);

                } else {
                    // データが存在する場合
                    this.isNew = false;
System.debug('コンストラクタ:データあり');
                }

                // 取得したレコードのクローンを作成
                this.baseRec =  this.rec.clone(true);
                this.isValid = true;

            } else if (params.containsKey(PARAM_ID)) {
                // パラメータID(AsiaCustomerInformations__c.Id)が存在する場合(直接遷移)
System.debug('コンストラクタ:AsiaCustomerInformations__c.Idがパラメータ');
                targetId = params.get(PARAM_ID);

                // レコード取得(キー：AsiaCustomerInformations__c.Id)
                rec = getTargetRecord(targetId, PARAM_ID);

                if (NULL == rec) {
                    // データが存在しない場合
                    // ⇒不正
                    this.isValid = false;
System.debug('コンストラクタ:データなし不正');
                } else {
                    // データが存在する場合
                    this.isNew = false;

                    // 取得したレコードのクローンを作成
                    this.baseRec = this.rec.clone(true);
                    this.isValid = true;
System.debug('コンストラクタ:データあり');
                }

            } else {
                // パラメータが存在しない場合
                // ⇒不正
                this.isValid = false;

System.debug('コンストラクタ:パラメータ不正');
            }

        } catch (JEOLException e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
System.debug('@@@:' + e.getStackTraceString());
            return;
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'An unexpected error occured.'));
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
//                System.debug('値' + pickList);
            }
        }

        return pickList;
    }

    // CustomerStatus__c値取得
    public List<String> getCustomerStatusItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'CustomerStatus__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // FacilityType__c値取得
    public List<String> getFacilityTypeItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'FacilityType__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // CustomerField__c値取得
    public List<String> getCustomerFieldItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'CustomerField__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // CapitalOrExecSomeCountry__c値取得
    public List<String> getCapitalOrExecSomeCountryItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'CapitalOrExecSomeCountry__c');
        List<String> str = new List<String>(); 
        
        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // CustomerPastTransaction__c値取得
    public List<String> getCustomerPastTransactionItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'CustomerPastTransaction__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // IsResearchEntrustedMilitary__c値取得
    public List<String> getIsResearchEntrustedMilitaryItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'IsResearchEntrustedMilitary__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // ABCMWeaponRelated__c値取得
    public List<String> getABCMWeaponRelatedItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'ABCMWeaponRelated__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // ConventionalWeaponRelated__c値取得
    public List<String> getConventionalWeaponRelatedItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'ConventionalWeaponRelated__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // EndUseCertificateAvailable__c値取得
    public List<String> getEndUseCertificateAvailableItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'EndUseCertificateAvailable__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // AssuranceStatementAvailable__c値取得
    public List<String> getAssuranceStatementAvailableItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'AssuranceStatementAvailable__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // EndUseInspectionPossibility__c値取得
    public List<String> getEndUseInspectionPossibilityItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'EndUseInspectionPossibility__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // CustomerDeniedPerson__c値取得
    public List<String> getCustomerDeniedPersonItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(CUSTINFO_OBJ, 'CustomerDeniedPerson__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // 新規レコード作成
    private AsiaCustomerInformations__c createNewRecord(String targetId) {
system.debug('createNewRecord:targetId = ' + targetId);

        AsiaCustomerInformations__c newRecord = new AsiaCustomerInformations__c();

        AsiaProfitCalculation__c calcRec = getCalc(targetId);
system.debug('createNewRecord:calcRec = ' + calcRec);

        // Default value set

        // Profit Calculation
        newRecord.AsiaProfitCalculation__c = targetId;
        // Order Date
        newRecord.OrderDate__c = date.today();

        // Instrument
        newRecord.Instrument__c = '';

        List<Schema.PicklistEntry> picklist = new List<Schema.PicklistEntry>();

        if (NULL != calcRec) {
            // AsiaProfitCalculation__cのレコードあり

            List<AsiaProfitCalculationDetail__c> calcDetails = getCalcDetailRecs(targetId);
system.debug('createNewRecord:calcDetails = ' + calcDetails);

            // JEOLAsia_ProfitCalculationEditorPageから遷移してきた場合
system.debug('createNewRecord:PARAM_PROFIT_CALCULATION_ID');

            // AsiaProfitCalculationDetail__cのカテゴリAの最初のModelTypeを設定
            for (AsiaProfitCalculationDetail__c detail: calcDetails) {
                if (detail.Category__c == 'A' && 
                    detail.Type__c == '1' &&
                    detail.ModelType__c != NULL) {
                    newRecord.Instrument__c = detail.ModelType__c;
                    break;
                }
            }
            // Customer's Name
            newRecord.CustomerName__c = calcRec.ShipmentName__c;
            // Address
            newRecord.Address__c = calcRec.ShipmentAddress__c;
            // Nation
            newRecord.Nation__c = calcRec.ShipmentAccount__r.Country__c;
            // URL
            newRecord.URL__c = calcRec.ShipmentAccount__r.Website;
            // OrganizationName
            newRecord.OrganizationName__c = calcRec.CompanyName__c;
            // Customer's Status
            if (NULL != calcRec.ShipmentAccount__r.CustomerStatus__c) {

                newRecord.CustomerStatus__c = calcRec.ShipmentAccount__r.CustomerStatus__c;
            } else {
                // Account未設定の場合、初期値設定
                picklist = getPicklist(CUSTINFO_OBJ, 'CustomerStatus__c');
                newRecord.CustomerStatus__c = picklist[0].getValue();
            }
            // Type of Facility
            if (NULL != calcRec.ShipmentAccount__r.FacilityType__c) {
                newRecord.FacilityType__c = calcRec.ShipmentAccount__r.FacilityType__c;
            } else {
                // Account未設定の場合、初期値設定
                picklist = getPicklist(CUSTINFO_OBJ, 'FacilityType__c');
                newRecord.FacilityType__c = picklist[0].getValue();
            }
            // FacilityTypeOtherLabel
            newRecord.FacilityTypeOtherLabel__c = calcRec.ShipmentAccount__r.FacilityTypeOtherLabel__c;
            // Field of Customer
            if (NULL != calcRec.ShipmentAccount__r.CustomerField__c) {
                newRecord.CustomerField__c = calcRec.ShipmentAccount__r.CustomerField__c;
            } else {
                // Account未設定の場合、初期値設定
                picklist = getPicklist(CUSTINFO_OBJ, 'CustomerField__c');
                newRecord.CustomerField__c = picklist[0].getValue();
            }

            // CustomerFieldOtherLabel
            newRecord.CustomerFieldOtherLabel__c = calcRec.ShipmentAccount__r.CustomerFieldOtherLabel__c;
            // Scope of Customer's Activity (Type of products or research)
            newRecord.CustomerActivityScope__c = calcRec.ShipmentAccount__r.CustomerActivityScope__c;
            // CustomerProcMainUser
            newRecord.CustomerProcMainUser__c = calcRec.ShipmentAccount__r.CustomerProcMainUser__c;

        }

        // CapitalOrExecSomeCountry
        picklist = getPicklist(CUSTINFO_OBJ, 'CapitalOrExecSomeCountry__c');
        newRecord.CapitalOrExecSomeCountry__c = picklist[1].getValue();
        // CustomerPastTransaction
        picklist = getPicklist(CUSTINFO_OBJ, 'CustomerPastTransaction__c');
        newRecord.CustomerPastTransaction__c = picklist[0].getValue();
        // IsResearchEntrustedMilitary
        picklist = getPicklist(CUSTINFO_OBJ, 'IsResearchEntrustedMilitary__c');
        newRecord.IsResearchEntrustedMilitary__c = picklist[1].getValue();
        // ABCMWeaponRelated
        picklist = getPicklist(CUSTINFO_OBJ, 'ABCMWeaponRelated__c');
        newRecord.ABCMWeaponRelated__c = picklist[1].getValue();
        // ConventionalWeaponRelated
        picklist = getPicklist(CUSTINFO_OBJ, 'ConventionalWeaponRelated__c');
        newRecord.ConventionalWeaponRelated__c = picklist[1].getValue();
        // EndUseCertificateAvailable
        picklist = getPicklist(CUSTINFO_OBJ, 'EndUseCertificateAvailable__c');
        newRecord.EndUseCertificateAvailable__c = picklist[0].getValue();
        // AssuranceStatementAvailable
        picklist = getPicklist(CUSTINFO_OBJ, 'AssuranceStatementAvailable__c');
        newRecord.AssuranceStatementAvailable__c = picklist[0].getValue();
        // EndUseInspectionPossibility
        picklist = getPicklist(CUSTINFO_OBJ, 'EndUseInspectionPossibility__c');
        newRecord.EndUseInspectionPossibility__c = picklist[0].getValue();
        // CustomerDeniedPerson
        picklist = getPicklist(CUSTINFO_OBJ, 'CustomerDeniedPerson__c');
        newRecord.CustomerDeniedPerson__c = picklist[1].getValue();

system.debug('createNewRecord:newRecord = ' + newRecord);
        return newRecord;
    }

    // ResponsibleUser__cのTitle取得
    public String getResponsibleUserTitle() {

        String ret = getUserTitle(rec.ResponsibleUser__c);
system.debug('ret = ' + ret);

        return ret;
    }

    // ResponsibleUser2__cのTitle取得
    public String getResponsibleUser2Title() {

        String ret = getUserTitle(rec.ResponsibleUser2__c);
system.debug('ret = ' + ret);

        return ret;
    }

    // UserのTitle取得処理
    private String getUserTitle(String targetId) {

        String ret = '';
        User usr = new User();
        List<User> usrs = [
                    SELECT 
                      id, name, Title
                    FROM 
                      User 
                    WHERE 
                      id = :targetId];
        if (usrs != null && usrs.size() > 0) {
            usr = usrs.get(0);
            ret = usr.Title;
        }
        return ret;
    }

    // AsiaCustomerInformations__cより、レコード取得
    private AsiaCustomerInformations__c getTargetRecord(String targetId, String transitionScreen) {

        AsiaCustomerInformations__c targetaRecord = null;
        List<AsiaCustomerInformations__c> recs = new List<AsiaCustomerInformations__c>();

system.debug('■■■getTargetRecord:start');
system.debug('getTargetRecord:targetId = ' + targetId);        

        if (transitionScreen == PARAM_ID) {
            // AsiaCustomerInformations__c.Idでデータ取得
system.debug('getTargetRecord:PARAM_ID');        

            recs = [
                SELECT
                    id, name, LastModifiedDate, AsiaProfitCalculation__c, OrderNo__c, OrderDate__c, Revision__c,
                    Instrument__c, Configuration__c, CustomerName__c, Address__c, Nation__c, URL__c, 
                    CustomerStatus__c, FacilityType__c, FacilityTypeOtherLabel__c, CustomerField__c, 
                    CustomerFieldOtherLabel__c, CustomerActivityScope__c, CustomerProcMainUser__c, 
                    CapitalOrExecSomeCountry__c, CapitalOrExecSomeCountryLabel__c, CustomerPastTransaction__c, 
                    CustomerPastTransactionInstrument__c, InstrumentEndUseDescription__c, IsResearchEntrustedMilitary__c, 
                    IsResearchEntrustedMilitarySubject__c, ABCMWeaponRelated__c, ConventionalWeaponRelated__c, 
                    EndUseCertificateAvailable__c, AssuranceStatementAvailable__c, EndUseInspectionPossibility__c, 
                    RiskCustomerSmall__c, RiskCustomerReluctantInfo__c, RiskUnusualPayment__c, RiskAnormalPractice__c, 
                    RiskCustomerKnowledgeSmall__c, RiskInstrumentIncompatible__c, RiskInappropriateSP__c, 
                    RiskNoWishUsualService__c, RiskPOBox__c, RiskIllegalExporter__c, CustomerDeniedPerson__c, 
                    OrganizationName__c, ResponsibleUser__c, DateResponsibleUser__c, ResponsibleUser2__c, 
                    DateResponsibleUser2__c, AsiaProfitCalculation__r.Name, ResponsibleUser__r.Title, ResponsibleUser2__r.Title
                FROM
                    AsiaCustomerInformations__c
                WHERE
                    Id =: targetId
            ];

        } else if (transitionScreen == PARAM_PROFIT_CALCULATION_ID) {
            // AsiaCustomerInformations__c.Idでデータ取得
system.debug('getTargetRecord:PARAM_PROFIT_CALCULATION_ID');        

            recs = [
                SELECT
                    id, name, LastModifiedDate, AsiaProfitCalculation__c, OrderNo__c, OrderDate__c, Revision__c,
                    Instrument__c, Configuration__c, CustomerName__c, Address__c, Nation__c, URL__c, 
                    CustomerStatus__c, FacilityType__c, FacilityTypeOtherLabel__c, CustomerField__c, 
                    CustomerFieldOtherLabel__c, CustomerActivityScope__c, CustomerProcMainUser__c, 
                    CapitalOrExecSomeCountry__c, CapitalOrExecSomeCountryLabel__c, CustomerPastTransaction__c, 
                    CustomerPastTransactionInstrument__c, InstrumentEndUseDescription__c, IsResearchEntrustedMilitary__c, 
                    IsResearchEntrustedMilitarySubject__c, ABCMWeaponRelated__c, ConventionalWeaponRelated__c, 
                    EndUseCertificateAvailable__c, AssuranceStatementAvailable__c, EndUseInspectionPossibility__c, 
                    RiskCustomerSmall__c, RiskCustomerReluctantInfo__c, RiskUnusualPayment__c, RiskAnormalPractice__c, 
                    RiskCustomerKnowledgeSmall__c, RiskInstrumentIncompatible__c, RiskInappropriateSP__c, 
                    RiskNoWishUsualService__c, RiskPOBox__c, RiskIllegalExporter__c, CustomerDeniedPerson__c, 
                    OrganizationName__c, ResponsibleUser__c, DateResponsibleUser__c, ResponsibleUser2__c, 
                    DateResponsibleUser2__c, AsiaProfitCalculation__r.Name, ResponsibleUser__r.Title, ResponsibleUser2__r.Title
                FROM
                    AsiaCustomerInformations__c
                WHERE
                    AsiaProfitCalculation__c =: targetId
            ];
        }

system.debug('getTargetRecord:recs = ' + recs);
        if (recs != null && recs.size() > 0) {
            // データあり
            targetaRecord = recs.get(0);
        } else {
            // データなし
            targetaRecord = null;
        }
system.debug('getTargetRecord:targetaRecord = ' + targetaRecord);
        return targetaRecord;
    }


    // AsiaCustomerInformations__cより、レコード取得
    private AsiaProfitCalculation__c getCalc(String targetId) {

        List<AsiaProfitCalculation__c> recs = [
            SELECT
                id, name, RecordTypeId, RecordType.Name, CurrencyIsoCode, LastModifiedDate, CreatedDateFormula__c, SalesPerson__c, SalesPerson__r.Name, CompanyName__c, 
                TotalAmount__c, ContractCode__c, ContractAddress__c, ContractBelong__c,
                ContractPersonInCharge__c, ContractPhone__c, ContractFax__c, ContractName__c, ContractName1__c, ContractName2__c, ContractPost__c,
                Series__c, ProfitCalculationNo__c,
                SalesAssistant__c,
                BranchNo__c, ShipmentCode__c, ShipmentAddress__c, ShipmentBelong__c,
                ShipmentPersonInCharge__c, ShipmentPhone__c, ShipmentFax__c, ShipmentName__c, ShipmentName1__c, ShipmentName2__c, ShipmentPost__c, IssueDate__c,
                createdById, createdBy.name, OrgName__c, Subtitle__c,
                CustomReductionName1__c, CustomReductionAmount1__c, CustomReductionName2__c,
                CustomReductionAmount2__c, CustomReductionName3__c, CustomReductionAmount3__c, ConsumptionTaxAmount__c,
                TotalTaxAmount__c, TaxRate__c, DeliveryCondition1__c, DeliveryCondition2__c, DeliveryPeriod__c,
                DeliveryDeadline__c, DeliveryDate_Arbitrarily__c, PaymentConditionSection__c,
                UnitBody__c, SupervisorName__c, SupervisorPosition__c,
                SubtitleLabel__c, OutputTotalTaxAmount__c,
                SubtotalReductionName1__c, SubtotalReductionAmount1__c, OutputSubtotalReduction1__c,
                SubtotalReductionName2__c, SubtotalReductionAmount2__c, OutputSubtotalReduction2__c,
                TotalAmountName__c, TotalTaxAmountName__c, Status__c,
                OutputConsumptionTaxAmount__c, OutputTotalAmount__c, OutputSubtitle__c,
                ContractAccount__c, ContractAccount_dummyField__c, ContractAccount__r.Name, ShipmentAccount__c, ShipmentAccount_dummyField__c, ShipmentAccount__r.Name, ContractContact_dummyField__c, ShipmentContact_dummyField__c,
                SalesPipeLineLkup__c, ContractPostalCode__c, ContractUndergraduate__c, ShipmentPostalCode__c,
                ShipmentUndergraduate__c, ShipmentDistanceZone__c,
                ShipmentDistanceSection__c, SalesCurrency__c, JProdCostCurrency__c, AsiaProjectMaster__c, 
                ShipmentAccount__r.Country__c, ShipmentAccount__r.Website, 
                ShipmentAccount__r.CustomerStatus__c, ShipmentAccount__r.FacilityType__c, ShipmentAccount__r.CustomerField__c, 
                ShipmentAccount__r.CustomerActivityScope__c, ShipmentAccount__r.CustomerProcMainUser__c,
                ShipmentAccount__r.FacilityTypeOtherLabel__c, ShipmentAccount__r.CustomerFieldOtherLabel__c
            FROM
                AsiaProfitCalculation__c
            WHERE
                Id =: targetId
        ];

system.debug('getCalc:recs = ' + recs);

        AsiaProfitCalculation__c rec = null;

        if (recs != null && recs.size() > 0) {
            rec = recs.get(0);
        } else {
//            throw new JEOLException('That PC No does not exist');
            rec = null;
        }

        return rec;
    }

    // 詳細レコード取得(AsiaProfitCalculationDetail__c)
    private List<AsiaProfitCalculationDetail__c> getCalcDetailRecs(String parentId) {

        List<AsiaProfitCalculationDetail__c> recs = [
                SELECT
                    id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c,
                    Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode,
                    ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c,
                    IsShowDetailAmount__c, DiscountAmount__c,
                    AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c,
                    CostPrice__c, SalesPrice__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c,
                    Description__c, Supplier__c
                FROM
                    AsiaProfitCalculationDetail__c
                WHERE
                    Parent__c =: parentId
                ORDER BY
                    SortNo__c, Depth__c Asc
        ];
system.debug('getCalcDetailRecs:recs = ' + recs);

        return recs;
    }

    // save Button
    public Pagereference saveAction() {
system.debug('■■■saveAction:start');

        Pagereference ref = null;
        Savepoint sp = Database.setSavepoint();

        try {

system.debug('saveAction:rec = ' + rec);

            if (rec.Id != null) {
                // AsiaCustomerInformations__cにデータあり

                AsiaCustomerInformations__c refreshedRec = 
                    [SELECT 
                        Id, Name, LastModifiedDate, LastModifiedBy.Name 
                    FROM 
                        AsiaCustomerInformations__c 
                    WHERE 
                        Id =: rec.Id];
system.debug('saveAction:refreshedRec = ' + refreshedRec);

                if(rec.LastModifiedDate != refreshedRec.LastModifiedDate)
                    // 最終更新日に相違有

                    throw new JEOLException('This record has been modified by ' + refreshedRec.LastModifiedBy.Name + ' at ' + refreshedRec.LastModifiedDate.format() + '. Please reload the data before making again your modifications.');
            }

            // AsiaCustomerInformations__c更新
            upsert rec;
system.debug('saveAction(save後):rec = ' + rec);

            // レコード再取得
            rec = getTargetRecord(rec.AsiaProfitCalculation__c, PARAM_PROFIT_CALCULATION_ID);
system.debug('saveAction(再取得後):rec = ' + rec);

            ref = Page.JEOLAsia_CustomerInformations;
            ref.getParameters().put(PARAM_PROFIT_CALCULATION_ID, rec.AsiaProfitCalculation__c);
            ref.setRedirect(true);

        } catch(Exception e) {
            String message = e.getMessage();

            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
system.debug('saveAction:LastModifiedDate = ' + rec.LastModifiedDate);
            Database.rollback(sp);
system.debug('saveAction:LastModifiedDate2 = ' + rec.LastModifiedDate);
            return null;
        }

system.debug('■■■saveAction:end');
        return ref;
    }

    public void ajaxSaveAction() {
        saveAction();
        this.baseRec =  this.rec.clone(true);
    }

    // Ptint Out Button
    public Pagereference getPreviewUrl() {

        Pagereference ref = Page.JEOLAsia_CustomerInformationsPrintPage;
        ref.getParameters().put(PARAM_ID, rec.Id);
system.debug('getPreviewUrl:ref' + ref);
        return ref;
    }    
}