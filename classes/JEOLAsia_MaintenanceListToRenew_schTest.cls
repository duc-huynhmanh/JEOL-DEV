@isTest
private class JEOLAsia_MaintenanceListToRenew_schTest{

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

	private static String CRON_EXP = '0 0 0 15 3 ? 2022';

	private static testMethod void test01()
	{
		System.runAs (testUser)
		{
			Test.startTest();

			String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new JEOLAsia_MaintenanceListToRenewAdd_sch());


			Test.stopTest();
		}
	}
}