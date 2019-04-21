@isTest
private class EventMonitoringLogViewControllerTest {
	
     /*@isTest static void getUserIdTest_One() {
        generateTestData();
        EventMonitoringLogViewController ctrl = new EventMonitoringLogViewController();
        User donaldDuck = getTestUser();
        ctrl.model.UserToSearch__c = donaldDuck.Id;
        ctrl.fetchUserId();
        System.debug('donaldDuck: ' + donaldDuck);
        System.debug('model: ' + ctrl.model);
        System.assertEquals(ctrl.searchedUserId,donaldDuck.Id);
    }*/
    
    @isTest static void fetchUserIdTest_one() //for Id->Username conversion
    {
        //generateTestData();
        EventMonitoringLogViewController ctrl = new EventMonitoringLogViewController();
        User donaldDuck = getTestUser();
        System.debug('donaldDuck: ' + donaldDuck);
        ctrl.searchUserText = donaldDuck.Id;
        ctrl.fetchForUserText();
        System.debug('ctrl.searchedResult: '+ ctrl.searchedResult + ' donaldDuck.Username: ' + donaldDuck.Username);
        System.assertEquals(ctrl.searchedResult, donaldDuck.Username);
    }
    
    @isTest static void fetchUserIdTest_two() //for User's Name->Id conversion
    {
        EventMonitoringLogViewController ctrl = new EventMonitoringLogViewController();
        User donaldDuck = getTestUser();
        ctrl.searchUserText = donaldDuck.Username;
        ctrl.fetchForUserText();
         System.debug('ctrl.searchedResult: '+ ctrl.searchedResult + ' donaldDuck.Id: ' + donaldDuck.Id);
        System.assertEquals(ctrl.searchedResult, donaldDuck.Id);
    }
    
     @isTest static void fetchUserIdTest_three() //for conversion's failed case
    {
        EventMonitoringLogViewController ctrl = new EventMonitoringLogViewController();
        User donaldDuck = getTestUser();
        ctrl.searchUserText = '';
        ctrl.fetchForUserText();
        System.assertEquals(ctrl.searchedResult, '');
    }
    
    static testMethod void constructor_test() {
    	generateTestData();
        EventMonitoringLogViewController ctrl = new EventMonitoringLogViewController();
    }
    
    private static void generateTestData() {
    	String uid = 'testuser';
		String psw = 'testpass'; 
		CryptoUtility.generateCryptoKey();
		CryptoUtility.generateEncryptedConnectionInfo(uid, psw);
		String decryptedValue = CryptoUtility.getDecryptedConnectionInfo();
		//AuthenticationSettings__c setting = CryptoUtility.getIns();    	
    }

    private static User getTestUser()
    {
         // For instance, if you want to create a user 
        // with the Salesforce Platform License,
        // you could grab the "Standard Platform User" Profile
        //  and use this to create a test user
        Profile platformUser = [select id from Profile where Name In ('System Administrator', 'システム管理者') Limit 1];
        User testUser = createTestUser('Donal','Duck','donal@duck.com.' + UserInfo.getOrganizationId(),'donal@duck.com' + UserInfo.getOrganizationId(),platformUser.Id);
        insert testUser;
        return testUser;
    }

        // Some of the fields necessary to create a User account
    // should be populated based on whichever User is running tests.    
    private static User DummyUser {
        get {
            if (DummyUser==null) {
                DummyUser = [select id, TimeZoneSidKey, LocaleSidKey, 
                    EmailEncodingKey, ProfileId, LanguageLocaleKey
                    from User limit 1];
            }
            return DummyUser ;
        } set ;
    }

    // Creates a Test User with a given Profile
    private static User createTestUser(String firstName,String lastName,String email,String userName,Id profileId) {
        return new User(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Username = userName.toLowerCase(),
            ProfileId = profileId,
            Alias = lastName,
            CommunityNickname = lastName,
            TimeZoneSidKey=DummyUser.TimeZoneSidKey,
            LocaleSidKey=DummyUser.LocaleSidKey,
            EmailEncodingKey=DummyUser.EmailEncodingKey,
            LanguageLocaleKey=DummyUser.LanguageLocaleKey
        );
    }

    // Create a Test User with the Profile 
    // of whoever is running the tests
    private static User createTestUser(String firstName, String lastName, String email, String userName) {
        return createTestUser(firstName,lastName,email,userName,DummyUser.ProfileId);
    }
}