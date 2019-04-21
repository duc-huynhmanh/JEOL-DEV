public with sharing class JEOL_AddSupportLayout_ctrl{

    public Support__c rec {get; set;}

    /**
    * コンストラクタ
    */
    public JEOL_AddSupportLayout_ctrl(ApexPages.StandardController stdController){

        // 顧客対応票の使用項目リストを作成
        List<String> fields = new List<String>();
        fields.add('UnitBodyLink__c');
        fields.add('MaintenanceSituation__c');

        // 使用項目リストをStandardControllerに指定（テストクラスの場合は回避）
        if(!Test.isRunningTest()) {
            stdController.addFields(fields);
        }

        // レコード取得
        this.rec = (Support__c)stdController.getRecord();
    }

    /**
    * 保守契約製番取得
    */
    public String getProductNumber(){
    
        date today = System.Today();
        List<SalesOrder__c> ordList;
        ordList = [select ProductNumber__c
                    from SalesOrder__c 
                    where UnitBodyLink__c =: this.rec.UnitBodyLink__c
                    and MaintenanceStartDateFormula__c <=: today
                    and MaintenanceEndDateFormula__c >=: today
                    and RecordTypeId IN 
                        (select Id from RecordType 
                            where SobjectType = 'SalesOrder__c' 
                            and developerName = 'HosyuKeiyaku')
                    order by MaintenanceEndDateFormula__c desc
                    , Name desc
                    nulls last
                    Limit 1 ];

        String resultStr = '';
        if (ordList != null && ordList.size() != 0) {
            resultStr = ordList[0].ProductNumber__c;
        }
        return resultStr;
    }

}