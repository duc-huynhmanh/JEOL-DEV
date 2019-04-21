@isTest
private class JEOLAsia_MaintenanceDetailCtrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static testMethod void test01()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			Account acc = new account();
			acc.Name = 'testAcc1';
			acc.Code__c = '01';
			insert acc;

			Account acc2 = new account();
			acc2.Name = 'testAcc2';
			acc2.Code__c = '02';
			insert acc2;

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			contMan.NewOdrSalesAccount__c = acc.Id;
			contMan.NewOdrShipmentAccount__c = acc2.Id; 
			insert contMan;

			AsiaMaintenanceAccountBook__c accBk = new AsiaMaintenanceAccountBook__c();
			accBk.Name = 'testAMABName';
			accBk.MaintenanceContractManagement__r = contMan;
			accBk.MaintenanceContractManagement__c = contMan.id;
			insert accBk;

			PageReference pageRef = Page.JEOLAsia_MaintenanceDetail;
			Map<String, String> params = new Map<String, String>();
	        params.put('id', String.valueOf(contMan.id));
	        pageRef.getParameters().putAll(params);

	        Test.setCurrentPage(pageRef);
	        
	        JEOLAsia_MaintenanceDetailCtrl ctrl = new JEOLAsia_MaintenanceDetailCtrl(new ApexPages.StandardController(contMan));

	        ctrl.getSeriesOptions();

	        PageReference retSave = ctrl.save();
	        PageReference retImportSale = ctrl.ImportDataFromSalesAccount();
			PageReference retImportShip = ctrl.ImportDataFromShipmentAccount();
			PageReference retRed = ctrl.redirectList();
			
			Test.stopTest();
		}
	}

	private static testMethod void test02()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			
	        JEOLAsia_MaintenanceDetailCtrl ctrl = new JEOLAsia_MaintenanceDetailCtrl(new ApexPages.StandardController(contMan));
			
			Test.stopTest();
		}
	}

	private static testMethod void test03()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			insert contMan;

			PageReference pageRef = Page.JEOLAsia_MaintenanceDetailView;
			Map<String, String> params = new Map<String, String>();
	        params.put('id', String.valueOf(contMan.id));
	        pageRef.getParameters().putAll(params);

	        Test.setCurrentPage(pageRef);
	        
	        JEOLAsia_MaintenanceDetailCtrl ctrl = new JEOLAsia_MaintenanceDetailCtrl(new ApexPages.StandardController(contMan));

			Test.stopTest();
		}
	}
}