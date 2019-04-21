@IsTest
private class JEOL_QuotationEditorPageCtrlTest {

    private static testMethod void test01() {
        
        QuotationInformation__c quot = new QuotationInformation__c();
        insert quot;
       
        QuotationDetailInformation__c quotdet = new QuotationDetailInformation__c();
        quotdet.Parent__r = quot;
        quotdet.Parent__c = quot.id;
        quotdet.Depth__c = 1;
        quotdet.SortNo__c = 0;
        quotdet.IsDiscountTarget__c = true;
        quotdet.DiscountRate__c = 10;
        quotdet.DiscountAmount__c = 10;
        insert quotdet;

        Pagereference ref = Page.JEOL_QuotationEditorPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', quot.id);
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationEditorPageCtrl ctrl = new JEOL_QuotationEditorPageCtrl();
        
        QuotationInformation__c ret01 = ctrl.getProxyObject();
        String ret02 = ctrl.getDetailType();
        ctrl.setDetailType('dummy');
        
        List<SelectOption> ret1 = ctrl.getQuoteTypeOptions();
        List<SelectOption> ret2 = ctrl.getSeriesOptions();
        List<SelectOption> ret3 = ctrl.getUnitOptions();
        List<SelectOption> ret4 = ctrl.getSalesAreaOptions();
        List<SelectOption> ret5 = ctrl.getDelivConditionOptions();
        List<SelectOption> ret6 = ctrl.getQuantityUnitOptions();
        List<SelectOption> ret7 = ctrl.getDepartmentOptions();
        List<SelectOption> ret8 = ctrl.getProductDivisionOptions();
        Pagereference ret9 = ctrl.quotationCopy();
        Pagereference ret10 = ctrl.quotationCopyAndBranch();
        ctrl.acceptanceDateCalc();
        List<SelectOption> ret11 = ctrl.getCandidateUnitBody();
        ctrl.salesAreaAttachment();
        ctrl.salesAreaAttachmentBis();
        ctrl.quoteTypeAttachment();
        ctrl.delivConditionAttachment();
        ctrl.departmentInfoAttachment();
        ctrl.overDepartmentInfoAttachment();
        ctrl.ContractAttachmentFromCode();
        ctrl.ShipmentAttachmentFromCode();
        ctrl.ContractAttachment();
        ctrl.ShipmentAttachment();
        ctrl.contractContactAttachment();
        ctrl.shipmentContactAttachment();
        ctrl.contractAccountInputCopy();
        ctrl.includeDestinationData();
        ctrl.ajaxSaveAction();
        ctrl.deleteMultiRows();
        ctrl.doSaveWithPrintDatePart1();
        ctrl.doSaveWithPrintDatePart2();
        ctrl.doSaveWithDestinationPrintDatePart1();
        ctrl.doSaveWithDestinationPrintDatePart2();
        ctrl.doSaveWithCertificationPrintDatePart1();
        ctrl.doSaveWithCertificationPrintDatePart2();
        PageReference ret12 = ctrl.deleteAction();
        
        Map<String, String> mapss = new Map<String, String>();
        mapss.put('JapaneseName__c', 'dummy');
        mapss.put('Name', 'dummy');
        mapss.put('Division__c', 'dummy');
        mapss.put('ModelType__c', 'dummy');
        List<ProductItem__c> ret13 = JEOL_QuotationEditorPageCtrl.getProductMaster(mapss);
        
        ProductItem__c ret14 = JEOL_QuotationEditorPageCtrl.searchProductItem('dummy');

        Map<String, String> mapss2 = new Map<String, String>();
        mapss2.put('Name', 'dummy');
        mapss2.put('QuoteNo__c', 'dummy');
        mapss2.put('BranchNo__c', 'dummy');
        mapss2.put('CreatedDateFormula__c', '2015/08/16');
        List<QuotationInformation__c> ret15 = JEOL_QuotationEditorPageCtrl.getQuotationInfo(mapss2);
     
        Map<String, String> mapss3 = new Map<String, String>();
        mapss3.put('Parent__c', quot.id);
        List<QuotationDetailInformation__c> ret16 = JEOL_QuotationEditorPageCtrl.getQuotationDetails(mapss3);

        Map<String, String> mapss4 = new Map<String, String>();
        mapss4.put('ClassificationNo__c', 'dummy');
        mapss4.put('SearchKeyWord__c', 'dummy');
        mapss4.put('ProductCatalog__c', 'dummy');
        List<ProductCatalog__c> ret17 = JEOL_QuotationEditorPageCtrl.getCatalogHead(mapss4);
        
        List<ProductCatalog__c> ret18 = JEOL_QuotationEditorPageCtrl.getChildStructure('dummy', 'dummy');
        
        List<JEOL_QuotationEditorPageCtrl.QuotationDetailItem> ret19 = ctrl.qdm.getItems();
        List<JEOL_QuotationEditorPageCtrl.QuotationDetailItem> ret20 = ctrl.qdm.getBaseItems();
        ctrl.qdm.createQuotationDetail();
        ctrl.qdm.createHeadingDetail();
        ctrl.qdm.createOverheadDetail();
        ctrl.qdm.createSubtotalDetail();
        ctrl.qdm.createCommissionDetail();
        QuotationDetailInformation__c ret21 = ctrl.qdm.createInitalizedRecord();
        integer ret22 = ctrl.qdm.getCurrentSize();
        ctrl.qdm.refreshDetailProductItem();
        ctrl.qdm.importDetailFromQuotation();
        
        ctrl.qdm.createdItemInfos = '{"sortNo":"18","items":[{"Name":"331465","JapaneseName__c":"ＦＴ　ＮＭＲ装置","UnitPrice__c":"75000000","Tani__c":"PC","ModelType__c":"JNM-ECX400(A)"},{"Name":"307645","JapaneseName__c":"ＦＴ　ＮＭＲ装置","UnitPrice__c":"460000000","Tani__c":"PC","ModelType__c":"JNM-ECA800"}]}';
        ctrl.qdm.createSelectedProductItemDetails();
        
        JEOL_QuotationEditorPageCtrl.QuotationDetailItem qdi = new JEOL_QuotationEditorPageCtrl.QuotationDetailItem(quotdet);
        qdi.executeAmountCalc();
        Decimal ret23 = qdi.getAmount();
        qdi.deleteAction();
        qdi.copyAction();
        QuotationDetailInformation__c ret24 = qdi.detailCopy();
        Integer ret25 = qdi.compareTo(qdi);
        
    }

    private static testMethod void test02() {
        
        QuotationInformation__c quot = new QuotationInformation__c();
        quot.UnitBody__c = '1234';
        insert quot;
               
        QuotationDetailInformation__c quotdet = new QuotationDetailInformation__c();
        quotdet.Parent__r = quot;
        quotdet.Parent__c = quot.id;
        quotdet.Depth__c = 1;
        quotdet.SortNo__c = 0;
        quotdet.IsDiscountTarget__c = true;
        quotdet.DiscountRate__c = 10;
        quotdet.DiscountAmount__c = 10;
        insert quotdet;

        Pagereference ref = Page.JEOL_QuotationEditorPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', quot.id);
        params.put(JEOL_QuotationEditorPageCtrl.URL_PARAM_NAME_ISCOPY, 'true');
        params.put(JEOL_QuotationEditorPageCtrl.URL_PARAM_NAME_ISBRANCH, 'true');
        params.put(JEOL_QuotationEditorPageCtrl.SCROLL_TOP, '1');
        
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationEditorPageCtrl ctrl = new JEOL_QuotationEditorPageCtrl();
        
    }
    
    private static testMethod void test03() {
        
        UserSetting__c usrSet = new UserSetting__c();
        usrSet.WordSettingDefaultDisplay1__c = '表示';
        usrSet.WordSettingDefaultDisplay2__c = '表示';
        usrSet.WordSettingDefaultDisplay3__c = '表示';
        usrSet.Word1__c = 'dummy';
        usrSet.Word2__c = 'dummy';
        usrSet.Word3__c = 'dummy';
        usrSet.ProductDivision__c = '製品';
        usrSet.QuotationNameExpress__c = true;
        usrSet.IsDisplayDecimal__c = true;
        usrSet.DefaultRowsItems__c = 1;
        usrSet.DefaultRowsHeading__c = 1;
        usrSet.DefaultRowsSubItems__c = 1;
        insert usrSet;
                              
                            
        
        Pagereference ref = Page.JEOL_QuotationEditorPage;
        Map<String, String> params = new Map<String, String>();

        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationEditorPageCtrl ctrl = new JEOL_QuotationEditorPageCtrl();
        
    }

    private static testMethod void test04() {
        
        Account acc = new Account();
        acc.Name = 'acc';
        acc.Code__c = '12345';
        insert acc;
        
        Contact con = new contact();
        con.account = acc;
        con.accountid = acc.id;
        con.LastName = 'dummy';
        insert con;
        
        QuotationInformation__c quot = new QuotationInformation__c();
        quot.UnitBody__c = '1234';
        quot.ShipmentCode__c = '12345';
        quot.SalesAreaCode__c = '01';
        quot.DepartmentCode__c = '01';
        quot.OverrideDepartmentCode__c = '01';
        quot.ContractContact_dummyField__c = con.id;
        quot.ShipmentContact_dummyField__c = con.id;
        quot.ContractAccount__c = acc.id;
        quot.ShipmentAccount__c = acc.id;
        insert quot;

        ProductItem__c pi = new ProductItem__c();
        insert pi;
        
        UnitBody__c ub = new UnitBody__c();
        ub.UnitBody__c = '1234';
        ub.AcceptanceDate__c = Datetime.Now();
        ub.ItemLink__c = pi.id;
        ub.DeliveryAccount__c = acc.id;
        insert ub;
               
        QuotationDetailInformation__c quotdet = new QuotationDetailInformation__c();
        quotdet.Parent__r = quot;
        quotdet.Parent__c = quot.id;
        quotdet.Depth__c = 1;
        quotdet.SortNo__c = 0;
        quotdet.IsDiscountTarget__c = true;
        quotdet.DiscountRate__c = 10;
        quotdet.DiscountAmount__c = 10;
        insert quotdet;

        Pagereference ref = Page.JEOL_QuotationEditorPage;
        Map<String, String> params = new Map<String, String>();
        params.put('id', quot.id);
        
        ref.getParameters().putAll(params);
                               
        Test.setCurrentPage(ref);
               
        JEOL_QuotationEditorPageCtrl ctrl = new JEOL_QuotationEditorPageCtrl();
        
        ctrl.acceptanceDateCalc();

        List<SelectOption> ret1 = ctrl.getCandidateUnitBody();
        
        ctrl.salesAreaAttachment();
        ctrl.departmentInfoAttachment();
        ctrl.overDepartmentInfoAttachment();
        ctrl.contractContactAttachment();
        ctrl.shipmentContactAttachment();
        
        ctrl.listRowToDel = '123,456';
        ctrl.deleteMultiRows();

        List<String> ret2 = JEOL_QuotationEditorPageCtrl.getSuggestions('dummy');
        Pagereference ret3 = ctrl.getPreviewUrl();
        Pagereference ret4 = ctrl.getDestinationPreviewUrl();
        Pagereference ret5 = ctrl.getCertificationPreviewUrl();
        ctrl.UserSettingSave();
    }
    
}