@IsTest
private class User_afterupsertTest {

    private static testMethod void test01() {

        Profile pf = [Select id,name from Profile where name IN ('System Administrator', 'システム管理者')  limit 1];
            
        User usr = new user();
        usr.username = 'testuserdummy@dummy.com';
        usr.firstname = 'dummy';
        usr.lastname = 'dummy';
        usr.email = 'testuserdummy@dummy.com';
        usr.communityNickname = 'dummy';
        usr.alias = 'dummy';
        usr.profileid = pf.Id;
        usr.emailencodingkey = 'UTF-8';
        usr.languagelocalekey='ja';
        usr.localesidkey = 'ja_JP';
        usr.timezonesidkey = 'Asia/Tokyo';
        insert usr;
        
        User usr2 = new user();
        usr2.username = 'testuserdummy2@dummy.com';
        usr2.firstname = 'dummy';
        usr2.lastname = 'dummy';
        usr2.email = 'testuserdummy@dummy.com';
        usr2.communityNickname = 'dummy2';
        usr2.alias = 'dummy';
        usr2.profileid = pf.Id;
        usr2.emailencodingkey = 'UTF-8';
        usr2.languagelocalekey='ja';
        usr2.localesidkey = 'ja_JP';
        usr2.timezonesidkey = 'Asia/Tokyo';
        usr2.SalesArea__c = '010';
        insert usr2;
        
        usr2.SalesArea__c = '020';
        update usr2;

    }
    
}