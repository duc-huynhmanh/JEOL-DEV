@isTest
private class JEOLAsia_CustomerInformationsCtrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

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

			AsiaCustomerInformations__c baseRec = new AsiaCustomerInformations__c();

			PageReference pageRef = Page.JEOLAsia_CustomerInformations;
			Test.setCurrentPage(pageRef);
			pageRef.getParameters().put('pcid', String.valueOf(rec.Id));

            JEOLAsia_CustomerInformationsCtrl ctrl = new JEOLAsia_CustomerInformationsCtrl(new ApexPages.StandardController(rec));

			ctrl.getPicklist('AsiaCustomerInformations__c','CustomerField__c');
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
			ctrl.getPreviewUrl();
			ctrl.ajaxSaveAction();

			PageReference ret = ctrl.saveAction();

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
			insert rec;

			AsiaCustomerInformations__c baseRec = new AsiaCustomerInformations__c();

			PageReference pageRef = Page.JEOLAsia_CustomerInformations;
			Test.setCurrentPage(pageRef);
			pageRef.getParameters().put('id', String.valueOf(rec.Id));

            JEOLAsia_CustomerInformationsCtrl ctrl = new JEOLAsia_CustomerInformationsCtrl(new ApexPages.StandardController(rec));

			ctrl.getPicklist('AsiaCustomerInformations__c','CustomerField__c');
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
			ctrl.getPreviewUrl();
			ctrl.ajaxSaveAction();

			PageReference ret = ctrl.saveAction();

            Test.stopTest();
		}
	}
}