@IsTest
private class JEOL_QuotationInformationTriggerTest {

    private static testMethod void test01() {
        
        QuotationInformation__c quot = new QuotationInformation__c();
        quot.SalesAreaCode__c = '010';
        insert quot;

        quot.SalesAreaCode__c = '020';
        update quot;
    }
    
}