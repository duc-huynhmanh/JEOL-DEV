@isTest
private class JEOLAsia_CustomerInfoPrintPageCtrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
	public static final String PARAM_ID = 'id';
    public static final String CUSTINFO_OBJ = 'AsiaCustomerInformations__c';
    public static final String EORR_MESSAGE = 'An unexpected error occured.';

    private static testMethod void test01()
    {
    	System.runAs (testUser)
    	{
    		Test.startTest();

    		AsiaCustomerInformations__c rec = new AsiaCustomerInformations__c();
    		rec.Name = 'testName';
			rec.ResponsibleUser__c = testUser.Id;
			rec.ResponsibleUser2__c = testUser.Id;
			insert rec;

			PageReference pageRef = Page.JEOLAsia_CustomerInformationsPrintPage;
			Test.setCurrentPage(pageRef);
			pageRef.getParameters().put('id', String.valueOf(rec.Id));

	        JEOLAsia_CustomerInfoPrintPageCtrl ctrl = new JEOLAsia_CustomerInfoPrintPageCtrl();
	        ctrl.getPicklist('AsiaCustomerInformations__c', 'CustomerStatus__c');
	        ctrl.getCustomerStatusItems();
	        ctrl.getFacilityTypeItems();
	        ctrl.getCustomerFieldItems();
	        ctrl.getCapitalOrExecSomeCountryItems();
	        ctrl.getCustomerPastTransactionItems();
			ctrl.getIsResearchEntrustedMilitaryItems();
			ctrl.getABCMWeaponRelatedItems();
			ctrl.getConventionalWeaponRelatedItems();
			ctrl.getEndUseCertificateAvailableItems();
			ctrl.getAssuranceStatementAvailableItems();
			ctrl.getEndUseInspectionPossibilityItems();
			ctrl.getCustomerDeniedPersonItems();
			ctrl.getResponsibleUserTitle();
		    ctrl.getResponsibleUser2Title();
            String ret = ctrl.dispUrl;
        	Test.stopTest();
    	}
    }

    private static testMethod void test02()
    {
        System.runAs (testUser)
        {
            Test.startTest();

            AsiaCustomerInformations__c rec = new AsiaCustomerInformations__c();
            rec.Name = 'testName';
            rec.ResponsibleUser__c = testUser.Id;
            rec.ResponsibleUser2__c = testUser.Id;
            rec.URL__C = '™©  aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ1234567890!"#$%&(-=^~\\\'|@`[{;+:*]},<.>/?_';
            insert rec;

            PageReference pageRef = Page.JEOLAsia_CustomerInformationsPrintPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(rec.Id));

            JEOLAsia_CustomerInfoPrintPageCtrl ctrl = new JEOLAsia_CustomerInfoPrintPageCtrl();
            String ret2 = ctrl.dispUrl;

            Test.stopTest();
        }
    }
}