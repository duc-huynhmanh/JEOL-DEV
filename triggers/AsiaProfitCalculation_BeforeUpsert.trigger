trigger AsiaProfitCalculation_BeforeUpsert on AsiaProfitCalculation__c (before insert, before update) {
    
    List<Schema.PicklistEntry> ple = AsiaProfitCalculation__c.Status__c.getDescribe().getPicklistValues();

    for (AsiaProfitCalculation__c mod : Trigger.New){
        
        mod.RejectCommentLabel__c = mod.RejectComment__c != null && mod.RejectComment__c.length() > 255 ? mod.RejectComment__c.substring(0, 252) + '...' : mod.RejectComment__c;
        mod.EscalateCommentLabel__c = mod.EscalateComment__c != null && mod.EscalateComment__c.length() > 255 ? mod.EscalateComment__c.substring(0, 252) + '...' : mod.EscalateComment__c;

        for( Schema.PicklistEntry f : ple)
        {
            if (f.getValue() == mod.Status__c) {
                mod.StatusLabel__c = f.getLabel();
                break;
            }
        }
    }
    
}