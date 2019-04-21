@isTest
private class VoxerEventLogMonitorPlusSettingsCtrlTest {

    static testMethod void myUnitTest() {
    	generateTestData();
    	PageReference pageRef = Page.VoxerEventLogMonitorPlusSettingsPage;
    	Test.setCurrentPage(pageRef);
        VoxerEventLogMonitorPlusSettingsCtrl ctrl = new VoxerEventLogMonitorPlusSettingsCtrl();
        
        ctrl.userid = 'testuser';
        ctrl.passwd = 'testpass';
        ctrl.voxerURL = 'https://voxer.local/';
        ctrl.accessType = '';
        
        ctrl.generateKey();
        ctrl.saveAuth();
        ctrl.saveURL();
    }
    
    private static void generateTestData() {
    	String uid = 'testuser';
		String psw = 'testpass'; 
		CryptoUtility.generateCryptoKey();
		CryptoUtility.generateEncryptedConnectionInfo(uid, psw);
		String decryptedValue = CryptoUtility.getDecryptedConnectionInfo();
		//AuthenticationSettings__c setting = CryptoUtility.getIns();
    	
    }
}