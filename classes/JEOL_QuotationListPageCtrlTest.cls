@IsTest
private class JEOL_QuotationListPageCtrlTest {

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

        Pagereference ref = Page.JEOL_QuotationListPage;
        Map<String, String> params = new Map<String, String>();
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationListPageCtrl ctrl = new JEOL_QuotationListPageCtrl();
        
        List<SelectOption> ret1 = ctrl.getSalesAreaOptions();
        List<SelectOption> ret2 = ctrl.getQuoteTypeOptions();
        List<SelectOption> ret3 = ctrl.getRecordTypeOptions();
        List<SelectOption> ret4 = ctrl.getSeriesOptions();
        ctrl.searchItemClear();
        ctrl.recordSearch();
        ctrl.targetRecords = '1';
        ctrl.getUrlParamFromEditorCopy();
        ctrl.getUrlParamFromEditorBranch();
        
        ctrl.targetQuoteNo = 'dummy';
        ctrl.targetName = 'dummy';
        ctrl.targetCustomerQuotationRequestedNo = 'dummy';
        ctrl.targetSalesPersonCode = 'dummy';
        ctrl.targetSalesPerson = 'dummy';
        ctrl.targetContractCode = 'dummy';
        ctrl.targetContractName = 'dummy';
        ctrl.targetShipmentCode = 'dummy';
        ctrl.targetShipmentName = 'dummy';
        ctrl.targetSeries = 'dummy';
        ctrl.targetCustomerQuotationRequestedNo = 'dummy';
        ctrl.targetQuotationType = 'dummy';
        ctrl.targetRecordType = 'dummy';
        ctrl.targetSalesArea = 'dummy';
        ctrl.RegisteredDateFrom = '2015-08-16';
        ctrl.RegisteredDateTo = '2015-08-16';
        
        ctrl.recordSearch();
        
        ctrl.switchingOrder();
        List<QuotationInformation__c> ret5 = ctrl.getRecords();
        
        QuotationInformation__c ret6 = ctrl.rec;
    }
    
}