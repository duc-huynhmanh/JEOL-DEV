@IsTest
private class JEOL_AccountPageCtrlTest {

    private static testMethod void test01() {

        Account acc = new account();
        
        JEOL_AccountPageCtrl ctrl = new JEOL_AccountPageCtrl(new ApexPages.StandardController(acc));
        
        List<String> ls;
        ls = JEOL_AccountPageCtrl.contactFields;
        ls = JEOL_AccountPageCtrl.salesPipeLineFields;
        ls = JEOL_AccountPageCtrl.unitBodyFields_delivery;
        ls = JEOL_AccountPageCtrl.unitBodyFields_sales;
        ls = JEOL_AccountPageCtrl.unitNoFields;
        ls = JEOL_AccountPageCtrl.competitionDeviceInfomationFields;
        
    }

}