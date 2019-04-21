@IsTest
private class JEOL_QuotationCertificationPrintPageTest {

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
        insert quot;
       
        List<QuotationDetailInformation__c> lsquotdet = new List<QuotationDetailInformation__c>();
        for (integer i = 0 ; i < 100 ; i++) {
            QuotationDetailInformation__c quotdet = new QuotationDetailInformation__c();
            quotdet.Parent__r = quot;
            quotdet.Parent__c = quot.id;
            quotdet.Depth__c = 1;
            quotdet.SortNo__c = 0;
            quotdet.IsDiscountTarget__c = true;
            quotdet.DiscountRate__c = 10;
            quotdet.DiscountAmount__c = 10;
            quotdet.CertificationExpress__c = true;
            quotdet.Quantity__c = 1;
            lsquotdet.add(quotdet);
        }
        insert lsquotdet;

        Pagereference ref = Page.JEOL_QuotationCertificationPrintPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', quot.id);
        params.put('preview', '1');
        params.put('print', '1');
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationCertificationPrintPageCtrl ctrl = new JEOL_QuotationCertificationPrintPageCtrl();
        
        Boolean ret01 = ctrl.isShowPriceExpress;
        Integer ret1 = ctrl.getPageSize();
        List<JEOL_QuotationCertificationPrintPageCtrl.PageBlockDetail> ret2 = ctrl.pdfPages[0].getDetails();
        Integer ret3 = ctrl.pdfPages[0].detailSize();
        String ret4 = ctrl.pdfPages[0].getCustomerName();
        String ret5 = ctrl.pdfPages[0].getDirectSalesIssueDate();
        String ret6 = ctrl.pdfPages[0].getRegulerPriceIssueDate();
        String ret7 = ret2[0].getQuantityFormat();
        
        
    }
    
}