@isTest
private class JEOLAsia_MaintenanceListNewCsv_ctrlTest {

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

			PageReference pageRef = Page.JEOLAsia_MaintenanceListNewCsv;
			Map<String, String> params = new Map<String, String>();
	        params.put('id', String.valueOf(contMan.id));
	        params.put('CUSTOMERCODE', 't01');
	        params.put('CUSTOMERNAME', 'testName1');
	        params.put('CUSTCODETYPE', '1');
	        params.put('CUSTNAMETYPE', '1');
	        params.put('SALESRESPONSIBLE', '0001');
	        params.put('SHIPMENTADDRESS', 'testAddress');
	        params.put('QUOTATIONCREATED', '1');
	        params.put('SACREATED', '1');
	        params.put('EXISTLASTACTIVITYDATE', '1');
	        params.put('LASTACTIVITYDATEFROM', String.valueOf(Date.parse('2017/05/01')));
	        params.put('LASTACTIVITYDATETO', String.valueOf(Date.parse('2017/05/31')));
	        params.put('QUOTATIONSENTDATEFROM', String.valueOf(Date.parse('2017/05/01')));
	        params.put('QUOTATIONSENTDATETO', String.valueOf(Date.parse('2017/05/31')));
	        params.put('PERIODFROM', String.valueOf(Date.parse('2017/05/01')));
	        params.put('PERIODTO', String.valueOf(Date.parse('2017/05/31')));
	        pageRef.getParameters().putAll(params);

	        Test.setCurrentPage(pageRef);

	        JEOLAsia_MaintenanceListNewCsv_ctrl ctrl = new JEOLAsia_MaintenanceListNewCsv_ctrl();

	        ctrl.getFileName();

			Test.stopTest();
		}
	}

	private static testMethod void test02()
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

			PageReference pageRef = Page.JEOLAsia_MaintenanceListNewCsv;
			Map<String, String> params = new Map<String, String>();
	        params.put('id', String.valueOf(contMan.id));
	        params.put('CUSTOMERCODE', 't02');
	        params.put('CUSTOMERNAME', 'testName2');
	        params.put('CUSTCODETYPE', '2');
	        params.put('CUSTNAMETYPE', '2');
	        params.put('SALESRESPONSIBLE', '0002');
	        params.put('SHIPMENTADDRESS', 'testAddress');
	        params.put('QUOTATIONCREATED', '2');
	        params.put('SACREATED', '2');
	        params.put('EXISTLASTACTIVITYDATE', '2');
	        pageRef.getParameters().putAll(params);

	        Test.setCurrentPage(pageRef);

	        JEOLAsia_MaintenanceListNewCsv_ctrl ctrl = new JEOLAsia_MaintenanceListNewCsv_ctrl();
	        
			Test.stopTest();
		}
	}
}