@isTest
public class JEOLAsia_TestDataFactory {

    /*
     * Description:Create SelectListManage TestData(選択リスト管理テストデータ作成)
     * MethodName :createSelectListManageData
     * @ return SelectListManage(選択リスト管理リスト)
     */
    public static List<SelectListManage__c> createSelectListManageData(String selectName, String label, String referenceName, String value, Integer recordQuantity){
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'testuser@globalway.test'];
        if(testUser == null){
            testUser = createTestUser();
        }
        List<SelectListManage__c> selectListManageList = new List<SelectListManage__c>();
        for(Integer i = 0; i < recordQuantity; i++){
            SelectListManage__c selectListManage = new SelectListManage__c();
            selectListManage.Name = selectName;
            selectListManage.Label__c = label;
            selectListManage.ReferenceName__c = referenceName;
            selectListManage.Value__c = value;
            selectListManage.SortNo__c = String.valueOf(i + 1);
            selectListManageList.add(selectListManage);
        }
        System.runAs (testUser) {
            insert selectListManageList;
        }
        //insert selectListManageList;
        return selectListManageList;
    }

    /**
     * [createAccountTestObject description]
     * @param  accountName              [account Name]
     * @param  accountCode              [account Code]
     * @param  salesAccountFlag         [salesAccountFlag]
     * @param  salessituation           [salessituation]
     * @param  shipmentAccountFlag      [shipmentAccountFlag]
     * @param  shipmentAccountSituation [shipmentAccountSituation]
     * @return                          [account record]
     */
    public static Account createAccountTestObject(String accountName, String accountCode, Boolean salesAccountFlag, String salessituation,Boolean shipmentAccountFlag, String shipmentAccountSituation){
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'testuser@globalway.test'];
        if(testUser == null){
            testUser = createTestUser();
        }
        RecordType accountRecType = getRecordType('Account');
        Account a = new Account(Name=accountName,
                                Code__c = accountCode,
                                RecordTypeId = accountRecType.Id,
                                SalesAccountFlag__c = salesAccountFlag,
                                SalesAccountSituation__c = salessituation,
                                ShipmentAccountFlag__c = shipmentAccountFlag,
                                ShipmentAccountSituation__c = shipmentAccountSituation
                                );
        System.runAs (testUser) {
            insert a;
        }
        return a;
    }

    /**
     * [getRecordType get record type]
     * @param  targetOBJ [targer object]
     * @return           [record type]
     */
    public static RecordType getRecordType(String targetOBJ){
        List<RecordType> resultRec = [select Id from RecordType where SobjectType = :targetOBJ];
        if (resultRec == null || resultRec.size() <= 0) {
            resultRec = new List<RecordType>();
        }
        return resultRec[0];
    }

    /*
     * Create Test User
     */
    public static User createTestUser() {
        //get Profile(プロファイル取得)
        Profile profile = [Select Id,Name from Profile where name IN ('System Administrator', 'システム管理者') limit 1];
        // ユーザ
        User user = new User();
        // 姓
        user.LastName = 'testuser';
        // 別名
        user.Alias = 'user';
        // メール
        user.Email = 'testuser@globalway.test';
        // ユーザ名
        user.UserName = 'testuser@globalway.test';
        // コミュニティのニックネーム
        user.CommunityNickname = 'testuser';
        // メールの文字コード
        user.EmailEncodingKey = 'ISO-2022-JP';
        // タイムゾーン
        user.TimeZoneSidKey = 'Asia/Tokyo';
        // 地域
        user.LocaleSidKey = 'ja_JP';
        // 言語
        user.LanguageLocaleKey = 'ja';
        // ユーザコード
        user.UserCode__c = '001';
        // プロファイル
        user.ProfileId = profile.Id;
        insert user;
        return user;
    }
}