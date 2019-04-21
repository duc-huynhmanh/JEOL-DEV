/*
 * Created : 2016/06/20 by Kobayashi (Voxer)
 */
public with sharing class JEOLAsia_CustomerInfoPrintPageCtrl{
    public static final String PARAM_ID = 'id';
    public static final String CUSTINFO_OBJ = 'AsiaCustomerInformations__c';
    public static final String EORR_MESSAGE = 'An unexpected error occured.';
    public AsiaCustomerInformations__c rec{get; set;} //CustomerInformationオブジェクト
    public static final Double PDF_WIDTH = 500; // PDFに出力幅設定(px)
    // PDFに各文字の幅定義(px)
    private Map<String, Double> mapCharWidth = new Map<String, Double>{
        '™'  => 13.05,
        '©'  => 10.26,
        ' '  => 3.36,
        ' '  => 3.36,
        'a'  => 6.66,
        'A'  => 8,
        'b'  => 6.66,
        'B'  => 8,
        'c'  => 5.90,
        'C'  => 8.8,
        'd'  => 6.66,
        'D'  => 8.7,
        'e'  => 5.90,
        'E'  => 8,
        'f'  => 3.33,
        'F'  => 7.36,
        'g'  => 6.66,
        'G'  => 9.2,
        'h'  => 6.66,
        'H'  => 8.6,
        'i'  => 2.7,
        'I'  => 3.33,
        'j'  => 2.7,
        'J'  => 6,
        'k'  => 6,
        'K'  => 8,
        'l'  => 2.7,
        'L'  => 6.7,
        'm'  => 10.2,
        'M'  => 10,
        'n'  => 6.66,
        'N'  => 8.5,
        'o'  => 6.8,
        'O'  => 9.2,
        'p'  => 7.36,
        'P'  => 8,
        'q'  => 6.66,
        'Q'  => 9.2,
        'r'  => 4,
        'R'  => 8.5,
        's'  => 6,
        'S'  => 8,
        't'  => 3.33,
        'T'  => 7.3,
        'u'  => 6.66,
        'U'  => 8.5,
        'v'  => 6,
        'V'  => 8,
        'w'  => 8.7,
        'W'  => 11.3,
        'x'  => 6,
        'X'  => 8,
        'y'  => 6,
        'Y'  => 8,
        'z'  => 5.90,
        'Z'  => 7.2,
        '1'  => 6.66,
        '2'  => 6.66,
        '3'  => 6.66,
        '4'  => 6.66,
        '5'  => 6.66,
        '6'  => 6.66,
        '7'  => 6.8,
        '8'  => 6.66,
        '9'  => 6.66,
        '0'  => 6.66,
        '!'  => 3.4,
        '"'  => 4.3,
        '#'  => 6.8,
        '$'  => 6.8,
        '%'  => 10.8,
        '&'  => 8.1,
        '('  => 4,
        '-'  => 4,
        '='  => 7,
        '^'  => 5.7,
        '~'  => 7.1,
        '\\'  => 3.4,
        '|'  => 3.1,
        '@'  => 12.28,
        '`'  => 4,
        '['  => 3.3,
        '{'  => 4,
        ';'  => 3.3,
        '+'  => 7.1,
        ':'  => 3.3,
        '*'  => 4.7,
        ']'  => 3.3,
        '}'  => 4,
        ','  => 3.32,
        '<'  => 7,
        '.'  => 3.32,
        '>'  => 7,
        '/'  => 3.70,
        '?'  => 6.66,
        '_'  => 6,
        'default' => 12 };
    public String dispUrl { //URLの改行表示
        get {
            if (String.isBlank(this.rec.URL__C)) {
                return '';
            }
            String ret = '';
            Double totalWidth = 0;
            for(Integer i = 0; i < this.rec.URL__C.length(); i++){
                String strChar = this.rec.URL__C.substring(i, (i+1));
                Double charWidth = 0;
                if (mapCharWidth.containsKey(strChar)){
                    charWidth = mapCharWidth.get(strChar);
                } else {
                    charWidth = mapCharWidth.get('default');
                }
                
                if (totalWidth + charWidth > PDF_WIDTH) {
                    ret = ret + '<br/>';
                    totalWidth = 0;
                }
                ret = ret + strChar;
                totalWidth = totalWidth + charWidth;
            }
            ret = ret.replace(' ', '&nbsp;');
            return ret;
        }
    }

    public JEOLAsia_CustomerInfoPrintPageCtrl() {

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

    // AsiaCustomerInformations__cより、レコード取得
    private AsiaCustomerInformations__c getTargetRecord(String targetId) {

        AsiaCustomerInformations__c targetaRecord = null;

system.debug('getTargetRecord:targetId = ' + targetId);        

        List<AsiaCustomerInformations__c> recs = [
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
                DateResponsibleUser2__c, AsiaProfitCalculation__r.Name, ResponsibleUser__r.Title, ResponsibleUser2__r.Title, 
                ResponsibleUser__r.Name, ResponsibleUser2__r.Name
            FROM
                AsiaCustomerInformations__c
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
                System.debug('値' + pickList);
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
}