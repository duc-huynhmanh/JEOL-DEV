@IsTest
private class JEOL_QuotationDestinationPrintPageTest {

    private static testMethod void test01() {
        
        QuotationInformation__c quot = new QuotationInformation__c();
        quot.AddressLine1__c = 'dummy';
        quot.AddressLine2__c = 'dummy';
        quot.AddressLine3__c = 'dummy';
        quot.DirectSalesExpress__c = true;
        quot.DirectSalesSheetIssueDate__c = Date.Today();
        quot.RegulerPriceExpress__c = true;
        quot.RegulerPriceSheetIssueDate__c = Date.Today();
        quot.CalendarExpress__c = '和暦';
        quot.DestinationAddress__c = 'dummy';
        quot.DestinationGuideDate__c = Date.Today();
        
        insert quot;

        Pagereference ref = Page.JEOL_QuotationDestinationPrintPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', quot.id);
        params.put('preview', '1');
        params.put('print', '1');
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationDestinationPrintPageCtrl ctrl = new JEOL_QuotationDestinationPrintPageCtrl();
        
        List<String> ret1 = ctrl.pdfData.getBodyLines();
        String ret2 = ctrl.pdfData.getDestinationGuideDate();
        
    }
    
}