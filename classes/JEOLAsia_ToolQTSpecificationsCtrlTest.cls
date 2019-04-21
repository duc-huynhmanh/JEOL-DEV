@IsTest
private class JEOLAsia_ToolQTSpecificationsCtrlTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static testMethod void test01() {
		System.runAs (testUser) {
			Test.startTest();

			JEOLAsia_ToolQTSpecificationsCtrl toolQTSpecObj = new JEOLAsia_ToolQTSpecificationsCtrl();
			toolQTSpecObj.textToConvert = 'testing\r\ntesting\rtesting<br/>\"\n\"';
			toolQTSpecObj.convertText();
			toolQTSpecObj.updateTextToConvertLength();

			Test.stopTest();
		}
	}


}