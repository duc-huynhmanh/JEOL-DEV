trigger JEOL_SalesPipeline_BeforeUpsertTrigger on SalesPipeline__c (Before Insert, Before Update) {

    for (SalesPipeline__c salesPL : Trigger.new) {

        if (salesPL.JuchuYoteiTsuki__c == '0') {
            salesPL.JuchuYoteiTsuki__c = null;
        }
        if (salesPL.UriageYoteiTsuki__c == '0') {
            salesPL.UriageYoteiTsuki__c = null;
        }
        if (salesPL.ReceiveMonthHonbu__c == '0') {
            salesPL.ReceiveMonthHonbu__c = null;
        }
        if (salesPL.ReceiveMonthGroupTop__c == '0') {
            salesPL.ReceiveMonthGroupTop__c = null;
        }
        if (salesPL.ShukkaYokyuTsuki__c == '0') {
            salesPL.ShukkaYokyuTsuki__c = null;
        }

    }
    
}