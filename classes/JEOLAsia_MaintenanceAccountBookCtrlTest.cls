@isTest
private class JEOLAsia_MaintenanceAccountBookCtrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static testMethod void test01()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contManPrev = new AsiaMaintenanceContractManagement__c();
			contManPrev.NewOdrSeries__c = 'testAPP';
			contManPrev.NewOdrSalesStaff__c = testUser.Id;
			contManPrev.NewContractStartDate__c = Date.parse('2016/05/01');
			contManPrev.NewContractEndDate__c = Date.parse('2016/05/31');
			insert contManPrev;

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			contMan.NewContractStartDate__c = Date.parse('2017/05/01');
			contMan.NewContractEndDate__c = Date.parse('2017/05/31');
			contMan.PreviousYearPipeline__r = contManPrev;
			contMan.PreviousYearPipeline__c = contManPrev.Id;
			insert contMan;

			AsiaMaintenanceAccountBook__c accBk = new AsiaMaintenanceAccountBook__c();
			accBk.Name = 'testAMABName';
			accBk.PaymentAmount__c = 5000;
			accBk.BillingAmount__c = 10000;
			accBk.MaintenanceContractManagement__r = contManPrev;
			accBk.MaintenanceContractManagement__c = contManPrev.id;
			insert accBk;

			Pagereference ref = Page.JEOLAsia_MaintenanceAccountBook;
	        Test.setCurrentPage(ref);

			JEOLAsia_MaintenanceAccountBookCtrl ctrl = new JEOLAsia_MaintenanceAccountBookCtrl(new ApexPages.StandardController(contMan));

			PageReference retAddF = ctrl.addFirstRow();
			PageReference retAddL = ctrl.addLastRow();
			PageReference retRmvF = ctrl.removeFirstRow();
			PageReference retRmvL = ctrl.removeLastRow();
			PageReference retImp = ctrl.importPreviousYearData();
			PageReference retSave = ctrl.save();

			Test.stopTest();
		}
	}

	private static testMethod void test02()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contManPrev = new AsiaMaintenanceContractManagement__c();
			contManPrev.NewOdrSeries__c = 'testAPP';
			contManPrev.NewOdrSalesStaff__c = testUser.Id;
			contManPrev.NewContractStartDate__c = Date.parse('2016/05/01');
			contManPrev.NewContractEndDate__c = Date.parse('2016/05/31');
			insert contManPrev;

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			contMan.NewContractStartDate__c = Date.parse('2017/05/01');
			contMan.PreviousYearPipeline__r = contManPrev;
			contMan.PreviousYearPipeline__c = contManPrev.Id;
			insert contMan;

			Pagereference ref = Page.JEOLAsia_MaintenanceAccountBook;
	        Test.setCurrentPage(ref);

			JEOLAsia_MaintenanceAccountBookCtrl ctrl = new JEOLAsia_MaintenanceAccountBookCtrl(new ApexPages.StandardController(contMan));

			Test.stopTest();
		}
	}

	private static testMethod void test03()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contManPrev = new AsiaMaintenanceContractManagement__c();
			contManPrev.NewOdrSeries__c = 'testAPP';
			contManPrev.NewOdrSalesStaff__c = testUser.Id;
			contManPrev.NewContractStartDate__c = Date.parse('2016/05/01');
			contManPrev.NewContractEndDate__c = Date.parse('2016/05/31');
			insert contManPrev;

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			contMan.NewContractEndDate__c = Date.parse('2017/05/31');
			contMan.PreviousYearPipeline__r = contManPrev;
			contMan.PreviousYearPipeline__c = contManPrev.Id;
			insert contMan;

			Pagereference ref = Page.JEOLAsia_MaintenanceAccountBook;
	        Test.setCurrentPage(ref);

			JEOLAsia_MaintenanceAccountBookCtrl ctrl = new JEOLAsia_MaintenanceAccountBookCtrl(new ApexPages.StandardController(contMan));

			Test.stopTest();
		}
	}
	private static testMethod void test04()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaMaintenanceContractManagement__c contManPrev = new AsiaMaintenanceContractManagement__c();
			contManPrev.NewOdrSeries__c = 'testAPP';
			contManPrev.NewOdrSalesStaff__c = testUser.Id;
			contManPrev.NewContractStartDate__c = Date.parse('2016/05/01');
			contManPrev.NewContractEndDate__c = Date.parse('2016/05/31');
			insert contManPrev;

			AsiaMaintenanceContractManagement__c contMan = new AsiaMaintenanceContractManagement__c();
			contMan.NewOdrSeries__c = 'testAP';
			contMan.NewOdrSalesStaff__c = testUser.Id;
			contMan.PreviousYearPipeline__r = contManPrev;
			contMan.PreviousYearPipeline__c = contManPrev.Id;
			insert contMan;

			Pagereference ref = Page.JEOLAsia_MaintenanceAccountBook;
	        Test.setCurrentPage(ref);

			JEOLAsia_MaintenanceAccountBookCtrl ctrl = new JEOLAsia_MaintenanceAccountBookCtrl(new ApexPages.StandardController(contMan));

			Test.stopTest();
		}
	}
}