@IsTest
private class JEOLAsia_QuotationRedirect_ctrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static testMethod void test01() {
	    System.runAs (testUser) {
	        Test.startTest();
	        ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
	        JEOLAsia_QuotationRedirect_ctrl ctrl = new JEOLAsia_QuotationRedirect_ctrl(sc);

	        PageReference pageRef = Page.JEOLAsia_QuotationRedirect;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', 'test');
            ctrl.redirect();
	        Test.stopTest();
		}
	}

	private static testMethod void test02() {
	    System.runAs (testUser) {
	        Test.startTest();
	        ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
	        JEOLAsia_QuotationRedirect_ctrl ctrl = new JEOLAsia_QuotationRedirect_ctrl(sc);

	        PageReference pageRef = Page.JEOLAsia_QuotationRedirect;
            Test.setCurrentPage(pageRef);
            ctrl.redirect();
	        Test.stopTest();
		}
	}
}