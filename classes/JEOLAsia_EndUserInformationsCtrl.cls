/*
 * Created : 2016/06/24 by Kobayashi (Voxer)
 */
public with sharing class JEOLAsia_EndUserInformationsCtrl{

    public static final String PARAM_ID = 'id';
    public static final String PARAM_PROFIT_CALCULATION_ID = 'pcid';
    public static final String ENDUSERINFO_OBJ = 'AsiaEndUserInformations__c';

    public Boolean isValid{get; set;} // 有効フラグ
    public Boolean isNew{get; set;}  // 新規作成
    public AsiaEndUserInformations__c rec{get; set;} //AsiaEndUserInformationsオブジェクト
    public AsiaEndUserInformations__c baseRec{get; set;} //比較用オブジェクト

    // コンストラクタ
    public JEOLAsia_EndUserInformationsCtrl(ApexPages.StandardController controller) {

    try {
            this.isNew = true;
            this.isValid = false;

            String targetId = '';
            String transitionScreen = '';

            // パラメータ取得
            Map<String, String> params = Apexpages.currentPage().getParameters();
System.debug('コンストラクタ:params = ' + params);

            if (params.containsKey(PARAM_PROFIT_CALCULATION_ID)) {
                // パラメータIDが(AsiaProfitCalculation__c.Id)または(AsiaQuotation__c.Id)の場合

                // パラメータID(AsiaProfitCalculation__c.Id)が存在する場合(JEOLAsia_ProfitCalculationEditorPageから遷移)
System.debug('コンストラクタ:AsiaProfitCalculation__c.Idがパラメータ');
                transitionScreen = PARAM_PROFIT_CALCULATION_ID;
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
            }
        }

        return pickList;
    }

    // ContractState__c値取得
    public List<String> getContractStateItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'ContractState__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // AnyOtherDocuments__c値取得
    public List<String> getAnyOtherDocumentsItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'AnyOtherDocuments__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // ProductsAndTechnology__c値取得
    public List<String> getProductsAndTechnologyItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'ProductsAndTechnology__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // FaxOrTelephone__c値取得
    public List<String> getFaxOrTelephoneItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'FaxOrTelephone__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // NuclearWeapons__c値取得
    public List<String> getNuclearWeaponsItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'NuclearWeapons__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // BiologicalWeapons__c値取得
    public List<String> getBiologicalWeaponsItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'BiologicalWeapons__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // ChemicalWeapons__c値取得
    public List<String> getChemicalWeaponsItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'ChemicalWeapons__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // Bacilluses__c値取得
    public List<String> getBacillusesItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'Bacilluses__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // BallisticMissiles__c値取得
    public List<String> getBallisticMissilesItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'BallisticMissiles__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // RemotelyPilotedVehicle__c値取得
    public List<String> getRemotelyPilotedVehicleItems() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'RemotelyPilotedVehicle__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // NuclearWeapons2__c値取得
    public List<String> getNuclearWeapons2Items() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'NuclearWeapons2__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // BiologicalWeapons2__c値取得
    public List<String> getBiologicalWeapons2Items() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'BiologicalWeapons2__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // ChemicalWeapons2__c値取得
    public List<String> getChemicalWeapons2Items() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'ChemicalWeapons2__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // Bacilluses2__c値取得
    public List<String> getBacilluses2Items() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'Bacilluses2__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // BallisticMissiles2__c値取得
    public List<String> getBallisticMissiles2Items() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'BallisticMissiles2__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // RemotelyPilotedVehicle2__c値取得
    public List<String> getRemotelyPilotedVehicle2Items() {

        List<Schema.PicklistEntry> picklist = getPicklist(ENDUSERINFO_OBJ, 'RemotelyPilotedVehicle2__c');
        List<String> str = new List<String>(); 

        // 選択リストより、ラジオボタン生成
        for(Schema.PicklistEntry pick : picklist){
            str.add(pick.getValue());
        }
        return str; 
    }

    // 新規レコード作成
    private AsiaEndUserInformations__c createNewRecord(String targetId) {
system.debug('createNewRecord:targetId = ' + targetId);

        AsiaEndUserInformations__c newRecord = new AsiaEndUserInformations__c();

        AsiaProfitCalculation__c calcRec = getCalc(targetId);
system.debug('createNewRecord:calcRec = ' + calcRec);

        // Default value set

        // Profit Calculation
        newRecord.AsiaProfitCalculation__c = targetId;

        // JEOLAddress
        String userCompany = '';
        User usr = [SELECT CompanyName FROM User WHERE id = :UserInfo.getUserId()];
system.debug('usr = ' + usr);
        String sCompanyNameProfile = usr.CompanyName;
        for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
            if (companyCustSettings.CompanyName__c == sCompanyNameProfile) {
                userCompany = companyCustSettings.Company__c;
system.debug('userCompany = ' + userCompany);
                break;
            }
        }

        List<CompanyName__c> companyNames =
            [SELECT 
                id, Company__c, CompanyLabel__c, CompanyName__c, JEOLAddress__c
             FROM CompanyName__c 
             WHERE Company__c = :userCompany
            ];
        CompanyName__c companyName = new CompanyName__c();
system.debug('companyNames = ' + companyNames);

        if (companyNames != null && companyNames.size() > 0) {
            // データあり
            companyName = companyNames.get(0);
            newRecord.JEOLAddress__c = companyName.JEOLAddress__c;
        } else {
            // データなし
            newRecord.JEOLAddress__c = null;
        }
system.debug('newRecord.JEOLAddress__c = ' + newRecord.JEOLAddress__c);

        // Order Date
        newRecord.OrderDate__c = date.today();

        if (NULL != calcRec) {
            // AsiaProfitCalculation__cのレコードあり

            // JEOLAsia_ProfitCalculationEditorPageから遷移してきた場合
system.debug('createNewRecord:PARAM_PROFIT_CALCULATION_ID');

            // EndUserInfo
            newRecord.EndUserInfo__c = calcRec.ShipmentName__c + '\n' +
                calcRec.ShipmentAddress__c + '\n' + calcRec.ShipmentAccount__r.Country__c;

            // EndUserInstallInfo
            newRecord.EndUserInstallInfo__c = 'Same as above';
            // OrganizationName
            newRecord.OrganizationName__c = calcRec.CompanyName__c;
        }

        List<Schema.PicklistEntry> picklist = new List<Schema.PicklistEntry>();

        // ContractState
        picklist = getPicklist(ENDUSERINFO_OBJ, 'ContractState__c');
        newRecord.ContractState__c = picklist[1].getValue();
        // AnyOtherDocuments
        picklist = getPicklist(ENDUSERINFO_OBJ, 'AnyOtherDocuments__c');
        newRecord.AnyOtherDocuments__c = picklist[1].getValue();
        // ProductsAndTechnology
        picklist = getPicklist(ENDUSERINFO_OBJ, 'ProductsAndTechnology__c');
        newRecord.ProductsAndTechnology__c = picklist[1].getValue();
        // FaxOrTelephone
        picklist = getPicklist(ENDUSERINFO_OBJ, 'FaxOrTelephone__c');
        newRecord.FaxOrTelephone__c = picklist[1].getValue();

        // NuclearWeapons
        picklist = getPicklist(ENDUSERINFO_OBJ, 'NuclearWeapons__c');
        newRecord.NuclearWeapons__c = picklist[1].getValue();
        // BiologicalWeapons
        picklist = getPicklist(ENDUSERINFO_OBJ, 'BiologicalWeapons__c');
        newRecord.BiologicalWeapons__c = picklist[1].getValue();
        // ChemicalWeapons
        picklist = getPicklist(ENDUSERINFO_OBJ, 'ChemicalWeapons__c');
        newRecord.ChemicalWeapons__c = picklist[1].getValue();
        // Bacilluses
        picklist = getPicklist(ENDUSERINFO_OBJ, 'Bacilluses__c');
        newRecord.Bacilluses__c = picklist[1].getValue();
        // BallisticMissiles
        picklist = getPicklist(ENDUSERINFO_OBJ, 'BallisticMissiles__c');
        newRecord.BallisticMissiles__c = picklist[1].getValue();
        // RemotelyPilotedVehicle
        picklist = getPicklist(ENDUSERINFO_OBJ, 'RemotelyPilotedVehicle__c');
        newRecord.RemotelyPilotedVehicle__c = picklist[1].getValue();

        // NuclearWeapons2
        picklist = getPicklist(ENDUSERINFO_OBJ, 'NuclearWeapons2__c');
        newRecord.NuclearWeapons2__c = picklist[1].getValue();
        // BiologicalWeapons2
        picklist = getPicklist(ENDUSERINFO_OBJ, 'BiologicalWeapons2__c');
        newRecord.BiologicalWeapons2__c = picklist[1].getValue();
        // ChemicalWeapons2
        picklist = getPicklist(ENDUSERINFO_OBJ, 'ChemicalWeapons2__c');
        newRecord.ChemicalWeapons2__c = picklist[1].getValue();
        // Bacilluses2
        picklist = getPicklist(ENDUSERINFO_OBJ, 'Bacilluses2__c');
        newRecord.Bacilluses2__c = picklist[1].getValue();
        // BallisticMissiles2
        picklist = getPicklist(ENDUSERINFO_OBJ, 'BallisticMissiles2__c');
        newRecord.BallisticMissiles2__c = picklist[1].getValue();
        // RemotelyPilotedVehicle2
        picklist = getPicklist(ENDUSERINFO_OBJ, 'RemotelyPilotedVehicle2__c');
        newRecord.RemotelyPilotedVehicle2__c = picklist[1].getValue();

system.debug('createNewRecord:newRecord = ' + newRecord);
        return newRecord;
    }

    // ResponsibleUser__cのTitle取得
    public String getResponsibleUserTitle() {
system.debug('getResponsibleUserTitle');

        String ret = getUserTitle(rec.ResponsibleUser__c);
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
system.debug('ret = ' + ret);

        return ret;
    }

    // AsiaEndUserInformations__cより、レコード取得
    private AsiaEndUserInformations__c getTargetRecord(String targetId, String transitionScreen) {

        AsiaEndUserInformations__c targetaRecord = null;
        List<AsiaEndUserInformations__c> recs = new List<AsiaEndUserInformations__c>();

system.debug('■■■getTargetRecord:start');
system.debug('getTargetRecord:targetId = ' + targetId);        

        if (transitionScreen == PARAM_ID) {
            // AsiaEndUserInformations__c.Idでデータ取得
system.debug('getTargetRecord:PARAM_ID');        

            recs = [
                SELECT
                    id, name, LastModifiedDate, AnyOtherDocuments__c, Bacilluses__c, Bacilluses2__c, BallisticMissiles__c, 
                    BallisticMissiles2__c, BiologicalWeapons__c, BiologicalWeapons2__c, ChemicalWeapons__c, ChemicalWeapons2__c, 
                    ContractState__c, DateResponsibleUser__c, DetailedInformation__c, EndUserInfo__c, EndUserInstallInfo__c, 
                    EndUserOrderNo__c, FaxOrTelephone__c, JEOLAddress__c, Nation__c, NuclearWeapons__c, NuclearWeapons2__c, 
                    OrderDate__c, OrderNo__c, OrganizationName__c, PleaseDescribe__c, ProductsAndTechnology__c, AsiaProfitCalculation__c, 
                    RemotelyPilotedVehicle__c, RemotelyPilotedVehicle2__c, ResponsibleUser__c, URL__c, 
                    AsiaProfitCalculation__r.Name, ResponsibleUser__r.Title, ScopeOfBusiness__c
                FROM
                    AsiaEndUserInformations__c
                WHERE
                    Id =: targetId
            ];

        } else if (transitionScreen == PARAM_PROFIT_CALCULATION_ID) {
            // AsiaCustomerInformations__c.Idでデータ取得
system.debug('getTargetRecord:PARAM_PROFIT_CALCULATION_ID');        

            recs = [
                SELECT
                    id, name, LastModifiedDate, AnyOtherDocuments__c, Bacilluses__c, Bacilluses2__c, BallisticMissiles__c, 
                    BallisticMissiles2__c, BiologicalWeapons__c, BiologicalWeapons2__c, ChemicalWeapons__c, ChemicalWeapons2__c, 
                    ContractState__c, DateResponsibleUser__c, DetailedInformation__c, EndUserInfo__c, EndUserInstallInfo__c, 
                    EndUserOrderNo__c, FaxOrTelephone__c, JEOLAddress__c, Nation__c, NuclearWeapons__c, NuclearWeapons2__c, 
                    OrderDate__c, OrderNo__c, OrganizationName__c, PleaseDescribe__c, ProductsAndTechnology__c, AsiaProfitCalculation__c, 
                    RemotelyPilotedVehicle__c, RemotelyPilotedVehicle2__c, ResponsibleUser__c, URL__c, 
                    AsiaProfitCalculation__r.Name, ResponsibleUser__r.Title, ScopeOfBusiness__c
                FROM
                    AsiaEndUserInformations__c
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

    // save Button
    public Pagereference saveAction() {
system.debug('■■■saveAction:start');

        Pagereference ref = null;
        Savepoint sp = Database.setSavepoint();

        try {

system.debug('saveAction:rec = ' + rec);

            if (rec.Id != null) {
                // AsiaEndUserInformations__cにデータあり

                AsiaEndUserInformations__c refreshedRec = 
                    [SELECT 
                        Id, Name, LastModifiedDate, LastModifiedBy.Name 
                    FROM 
                        AsiaEndUserInformations__c 
                    WHERE 
                        Id =: rec.Id];
system.debug('saveAction:refreshedRec = ' + refreshedRec);

                if(rec.LastModifiedDate != refreshedRec.LastModifiedDate)
                    // 最終更新日に相違有

                    throw new JEOLException('This record has been modified by ' + refreshedRec.LastModifiedBy.Name + ' at ' + refreshedRec.LastModifiedDate.format() + '. Please reload the data before making again your modifications.');
            }

            // AsiaEndUserInformations__c更新
            upsert rec;
system.debug('saveAction(save後):rec = ' + rec);

            // レコード再取得
            rec = getTargetRecord(rec.AsiaProfitCalculation__c, PARAM_PROFIT_CALCULATION_ID);
system.debug('saveAction(再取得後):rec = ' + rec);

            ref = Page.JEOLAsia_EndUserInformations;
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

        Pagereference ref = Page.JEOLAsia_EndUserInformationsPrintPage;
        ref.getParameters().put(PARAM_ID, rec.Id);
system.debug('getPreviewUrl:ref' + ref);
        return ref;
    }    
}