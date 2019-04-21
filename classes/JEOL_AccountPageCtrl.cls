public with sharing class JEOL_AccountPageCtrl {

    public Account targetRec{get; set;}
    public Boolean isShowRelatedList{get; private set;}
    public static List<String> contactFields{
        get {return new List<String>{'name', 'TantoshaCode__c', 'Gakubu__c', 'Department', 'Title', 'Email', 'Phone', 'Fax', 'OtherPhone'};}
    }
    public static List<String> salesPipeLineFields{
        get {return new List<String>{'name','Destination__c','Order_number__c','Field7__c','niban_juchu__c','Closing_date__c','Field22__c','Field24__c'};}
    }
    public static List<String> unitBodyFields_delivery{
        get {return new List<String>{'name','ModelAbbreviation__c','SalesAccount__c','SerialNo__c','ModelName__c','Series__c','ShippingDateFormula__c','AcceptanceDateFormula__c','WasteSituation__c'};}
    }
    public static List<String> unitBodyFields_sales{
        get {return new List<String>{'name','ModelAbbreviation__c','DeliveryAccount__c','SerialNo__c','ModelName__c','Series__c','ShippingDateFormula__c','AcceptanceDateFormula__c','WasteSituation__c'};}
    }
    public static List<String> unitNoFields{
        get {return new List<String>{'name'};}
    }
    public static List<String> competitionDeviceInfomationFields{
        get {return new List<String>{'name', 'Field1__c', 'Field2__c', 'Field5_del__c'};}
    }
    
    public JEOL_AccountPageCtrl(ApexPages.StandardController ctrl) {
        Account rec = (Account) ctrl.getRecord();
        if (rec != null) {
            this.isShowRelatedList = isJriRecordType(rec.recordTypeId);
        }
        this.targetRec = rec;
    }
    
    //レコードタイプがJRIだったTRUEをかえす
    private Boolean isJriRecordType(String recordTypeId) {
        Boolean ret = false;
        List<RecordType> recTypes = [SELECT id, developerName FROM RecordType WHERE id =: recordTypeId];
        if (recTypes != null && recTypes.size() > 0) {
            RecordType targetRecordType = recTypes.get(0);
            ret = (targetRecordType.developerName == 'JRI_ACCOUNT');
        }
        
        return ret;
    }
}