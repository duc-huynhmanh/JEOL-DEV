@isTest
private class JEOLAsia_MaintenanceAccountBookRedTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static testMethod void test01()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			insert contMan;

			AsiaMaintenanceAccountBook__c accBk = new AsiaMaintenanceAccountBook__c();
			accBk.Name = 'testAMABName';
			accBk.MaintenanceContractManagement__r = contMan;
			accBk.MaintenanceContractManagement__c = contMan.id;
			insert accBk;

	        Pagereference ref = Page.JEOLAsia_MaintenanceAccountBookRedirect;
	        Map<String, String> params = new Map<String, String>();
	        params.put('id', contMan.id);
	        ref.getParameters().putAll(params);
	                               
	        Test.setCurrentPage(ref);

			JEOLAsia_MaintenanceAccountBookRed_ctrl ctrl = new JEOLAsia_MaintenanceAccountBookRed_ctrl(new ApexPages.StandardController(accBk));

			PageReference ret = ctrl.redirect();

			Test.stopTest();
		}
	}
}