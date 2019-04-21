@isTest
private class JEOLAsia_MaintenanceAnnaiPrintPageTest {

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

			PageReference testPage = Page.JEOL_QuotationPrintPage;
	        Map<String, String> params = testPage.getParameters();
	        params.put('id', contMan.Id);
	        params.put('preview', 'true');
	        params.put('print', 'true');
	        Test.setCurrentPage(testPage);

			JEOLAsia_MaintenanceAnnaiPrintPageCtrl ctrl = new JEOLAsia_MaintenanceAnnaiPrintPageCtrl();
			ctrl.rec = new AsiaMaintenanceContractManagement__c();
			ctrl.prevSalesOrder = new SalesOrder__c();
			ctrl.renewalAccount = new Account();
			ctrl.blankDate = 'testDate';

			JEOLAsia_MaintenanceAnnaiPrintPageCtrl.PageBlock pb = new JEOLAsia_MaintenanceAnnaiPrintPageCtrl.PageBlock();
			ctrl.pdfPages = new List<JEOLAsia_MaintenanceAnnaiPrintPageCtrl.PageBlock>();

			JEOLAsia_MaintenanceAnnaiPrintPageCtrl.QuotationHeader qh = new JEOLAsia_MaintenanceAnnaiPrintPageCtrl.QuotationHeader(new AsiaMaintenanceContractManagement__c());

			qh.quotatinNameLines.add('testNL01');
			qh.quotatinNameLines.add('testNL02');

			pb.setHead(qh);
			pb.getQuotatinNameLinesSize();
			pb.getHasNoteText();

        	Test.stopTest();
    	}
    }
}