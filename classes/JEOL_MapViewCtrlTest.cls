@IsTest
private class JEOL_MapViewCtrlTest {

    private static testMethod void test01() {
        
        Account acc = new account();
        acc.Name = 'dummy';
        acc.Code__c = '12345';
        acc.Address__c = 'AAA市BBB区CCC町DDD村';
        insert acc;
       
        JEOL_MapViewCtrl ctrl = new JEOL_MapViewCtrl(new ApexPages.StandardController(acc));
      
        List<Account> lsAcc = ctrl.getNearAccounts();
        
        acc.Address__c = '';
        List<Account> lsAcc2 = ctrl.getNearAccounts();
        
    }

}