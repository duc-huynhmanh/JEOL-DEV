@isTest
private class JEOLAsia_EndUserInformationsCtrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static testMethod void test01()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaEndUserInformations__c rec = new AsiaEndUserInformations__c();
			rec.Name = 'testName';
			rec.ResponsibleUser__c = testUser.Id;
			insert rec;

			AsiaEndUserInformations__c baseRec = new AsiaEndUserInformations__c();
			insert baseRec;

			PageReference pageRef = Page.JEOLAsia_CustomerInformations;
			Test.setCurrentPage(pageRef);
			pageRef.getParameters().put('pcid', String.valueOf(rec.Id));

			JEOLAsia_EndUserInformationsCtrl ctrl = new JEOLAsia_EndUserInformationsCtrl(new ApexPages.StandardController(rec));

			ctrl.getPicklist('AsiaEndUserInformations__c', 'ContractState__c');
			ctrl.getContractStateItems();
			ctrl.getAnyOtherDocumentsItems();
			ctrl.getProductsAndTechnologyItems();
			ctrl.getFaxOrTelephoneItems();
			ctrl.getNuclearWeaponsItems();
			ctrl.getBiologicalWeaponsItems();
			ctrl.getChemicalWeaponsItems();
			ctrl.getBacillusesItems();
			ctrl.getBallisticMissilesItems();
			ctrl.getRemotelyPilotedVehicleItems();
			ctrl.getNuclearWeapons2Items();
			ctrl.getBiologicalWeapons2Items();
			ctrl.getChemicalWeapons2Items();
			ctrl.getBacilluses2Items();
			ctrl.getBallisticMissiles2Items();
			ctrl.getRemotelyPilotedVehicle2Items();
			ctrl.getResponsibleUserTitle();
			ctrl.ajaxSaveAction();
			ctrl.getPreviewUrl();

			PageReference ret = ctrl.saveAction();

			Test.stopTest();
		}
	}

	private static testMethod void test02()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			AsiaEndUserInformations__c rec = new AsiaEndUserInformations__c();
			rec.Name = 'testName';
			rec.ResponsibleUser__c = testUser.Id;
			insert rec;

			AsiaEndUserInformations__c baseRec = new AsiaEndUserInformations__c();
			insert baseRec;

			PageReference pageRef = Page.JEOLAsia_CustomerInformations;
			Test.setCurrentPage(pageRef);
			pageRef.getParameters().put('id', String.valueOf(rec.Id));

			JEOLAsia_EndUserInformationsCtrl ctrl = new JEOLAsia_EndUserInformationsCtrl(new ApexPages.StandardController(rec));
			
			Test.stopTest();
		}
	}
}