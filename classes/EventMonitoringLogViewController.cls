public with sharing class EventMonitoringLogViewController {

    public String authInfo {get; set;}
    
    public String searchUserText {get; set;}
    public String searchedResult {get; set;}
    
    public EventMonitoringLogViewController() {
        try{
        authInfo = CryptoUtility.getDecryptedConnectionInfo();
        }
        catch(Exception e)
        {
            system.debug('e: ' + e);
        }
    }

    public PageReference fetchForUserText()//Converts Username->Id and vice-versa
    {
        system.debug('searchUserText: ' + searchUserText);
        if(searchUserText != null)
        {
            //clear previous result
            searchedResult = '';
            //identify if userText is Username or Id
            String[] searchTextArray = searchUserText.split('');
            system.debug('searchTextArray: ' + searchTextArray);
            system.debug('searchTextArray.size(): ' + searchTextArray.size());
            if(searchTextArray.size() >=3)
            {
                if((searchTextArray[1] == '0') && (searchTextArray[2] == '0') && ((searchTextArray.size() == 16)||(searchTextArray.size() == 19)))
                   {//Search for Id
                       List<User> queryResult = [SELECT Id,Username FROM User WHERE Id =:searchUserText];
                       system.debug('queryResult: ' + queryResult);
                       if(queryResult.size() == 1)
                       {
                           searchedResult = queryResult[0].Username;
                           return null;
                       }
                   }
                   else
                   {//Search for Username
                       List<User> queryResult = [SELECT Id,Username  FROM User WHERE Username =:searchUserText];
                       if(queryResult.size() == 1)
                       {
                           searchedResult = queryResult[0].Id;
                           return null;
                       }
                   }
            }
        }
       
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.ERR_UserNotFoundOrNull));
        return null;
    }
}