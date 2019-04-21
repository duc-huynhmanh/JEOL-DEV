@isTest(SeeAllData=true)
private class JEOL_GenericHistoryComponent_CtrlTest {

    private static testMethod void test01() {
    
        // ***Instructions MUST READ***
        // We cannot generate History from a unit test, and unable to manually insert records into the History tables from code.
        // This seems to be a limitation of Salesforce unit testing.
        // Created for Winter 12 org testing, updated to work with v24 API (SeeAllData=true)
        // Steps:
        //   1. Enable History Tracking for Account.
        //   2. You will need to declaratively make changes to an existing Account.  
        //   3. Create history in Sandbox and Production.
        //   4. Then run this test/deploy.
        // This test will look at the existing history in your org, and operate off of it.  

        //create controller
        JEOL_GenericHistoryComponent_Ctrl controller = new JEOL_GenericHistoryComponent_Ctrl();
        //null myObject
        system.assert(controller.getObjectHistory().size() == 0);
        
        //Account allows for history in related lists in visualforce, 
        // this is simply a standard object being used to get code coverage so you can use the component for other custom and standard objects.
        AggregateResult[] aggResList = [select AccountId, Count(ID) from AccountHistory Group By AccountId Having Count(ID) > 1 Limit 1];
        System.assert(aggResList.size() > 0,'Test requires at least 1 Account with 2+ Account Field History rows');
        
        //Set myObject
        controller.myObject = [select id from Account where id=: (ID)aggResList[0].get('accountId')];               
        system.assert(controller.getObjectHistory().size() > 0);  
        
    }
}