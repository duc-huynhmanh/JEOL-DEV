/*
 * Created : 2016/06/28 by Kobayashi (Voxer)
 */
public with sharing class JEOLAsia_EndUserInfoPrintPageCtrl{

    public static final String PARAM_ID = 'id';
    public static final String ENDUSERINFO_OBJ = 'AsiaEndUserInformations__c';
    public static final String EORR_MESSAGE = 'An unexpected error occured.';
    public AsiaEndUserInformations__c rec{get; set;} //AsiaEndUserInformationsオブジェクト

    public JEOLAsia_EndUserInfoPrintPageCtrl() {

        try {
            // パラメータ取得
            Map<String, String> params = Apexpages.currentPage().getParameters();
System.debug('コンストラクタ:params = ' + params);

            if (params.containsKey(PARAM_ID)) {
                // パラメータIDが存在する場合
                String targetId = params.get(PARAM_ID);

                // レコード取得
                this.rec = getTargetRecord(targetId);
System.debug('コンストラクタ:rec = ' + rec);

                if (NULL == this.rec) {
                    // データが存在しない場合

System.debug('コンストラクタ:データ不正');
                    throw new JEOLException(EORR_MESSAGE);
                } 

            } else {
                System.debug('コンストラクタ:パラメータ不正');
            }

        } catch (JEOLException e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
System.debug('@@@:' + e.getStackTraceString());
            return;
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, EORR_MESSAGE));
            return;
        }
    }

    // AsiaEndUserInformations__cより、レコード取得
    private AsiaEndUserInformations__c getTargetRecord(String targetId) {

        AsiaEndUserInformations__c targetaRecord = null;

system.debug('getTargetRecord:targetId = ' + targetId);

        List<AsiaEndUserInformations__c> recs = [
            SELECT
                id, name, LastModifiedDate, AnyOtherDocuments__c, Bacilluses__c, Bacilluses2__c, BallisticMissiles__c, 
                BallisticMissiles2__c, BiologicalWeapons__c, BiologicalWeapons2__c, ChemicalWeapons__c, ChemicalWeapons2__c, 
                ContractState__c, DateResponsibleUser__c, DetailedInformation__c, EndUserInfo__c, EndUserInstallInfo__c, 
                EndUserOrderNo__c, FaxOrTelephone__c, JEOLAddress__c, Nation__c, NuclearWeapons__c, NuclearWeapons2__c, 
                OrderDate__c, OrderNo__c, OrganizationName__c, PleaseDescribe__c, ProductsAndTechnology__c, AsiaProfitCalculation__c, 
                RemotelyPilotedVehicle__c, RemotelyPilotedVehicle2__c, ResponsibleUser__c, URL__c, 
                AsiaProfitCalculation__r.Name, ResponsibleUser__r.Title, ResponsibleUser__r.Name, ScopeOfBusiness__c
            FROM
                AsiaEndUserInformations__c
            WHERE
                Id =: targetId
        ];

        if (recs != null && recs.size() > 0) {
            // データあり
            targetaRecord = recs.get(0);
        } else {
            // データなし
            targetaRecord = null;
        }

        return targetaRecord;
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

    // ResponsibleUser__cのTitle取得
    public String getResponsibleUserTitle() {

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
        return ret;
    }    
}