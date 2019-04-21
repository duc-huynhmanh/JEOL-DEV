@IsTest
private class JEOL_OperationHistoryTriggerTest {

    private static testMethod void test01() {

        // 顧客対応票作成
        Support__c spt = new Support__c();
        spt.Name = 'testSPTname';
        insert spt;

        // Task作成（メモ：260文字、件名：一次）
        OperationHistory__c rec = new OperationHistory__c();
        rec.Description__c = '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
        rec.CallCenterReceptionNo__c = 'testSPTname';
        rec.StartDatetime__c = datetime.now().addMonths(-6);
        rec.EndDatetime__c = datetime.now().addMonths(6);
        rec.CorrespondenceNumber__c = 1;
        rec.Name = '一次';
        insert rec;

        // Task更新（件名：二次）
        rec.Name = '二次';
        rec.Status__c = 'Completed';
        update rec;
    }

}