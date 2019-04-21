@isTest
public class JEOLAsia_ProfitCalculationEditorPageTest {
    // User(ユーザ)
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
    public static final String SCROLL_TOP = 'top';
    public static final String PARAM_ID = 'id';
    public static final String URL_PARAM_NAME_ISBRANCH = 'isBranch';
    public static final String URL_PARAM_NAME_ISCOPY = 'isCopy';
    private static final String QUOTATION_COMPANY_ASIA = 'ASIA';
    /*
* Description: Test Constructor
* MethodName : Test01
*/
    private static testMethod void test00() {
        system.debug('★★★★★★★★★★★★ test00 Start ★★★★★★★★★★★★');
        // Preparation(None)
        System.runAs (testUser) {
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            Test.startTest();
            PageReference testPage = Page.JEOLAsia_ProfitCalculationEditorPage;
            Map<String, String> params = new Map<String, String>();
            AsiaProfitCalculation__c entity= createAsiaProfitCalculation();            
            createAsiaProfitCalculationRateDefault();
            createAsiaProfitCalculationRate(entity.Id);
            params.put(SCROLL_TOP, '0');
            params.put(PARAM_ID, entity.Id);
            params.put(URL_PARAM_NAME_ISBRANCH, 'true');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl= new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            Test.stopTest();            
        }
        system.debug('★★★★★★★★★★★★ test00 END ★★★★★★★★★★★★');
        
    }
    private static testMethod void test01() {
        system.debug('★★★★★★★★★★★★ test01 Start ★★★★★★★★★★★★');
        // Preparation(None)
        System.runAs (testUser) {
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            Test.startTest();
            PageReference testPage = Page.JEOLAsia_ProfitCalculationEditorPage;
            Map<String, String> params = new Map<String, String>();
            AsiaProfitCalculation__c entity= createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail2SP(entity.Id);
            createAsiaProfitCalculationRateDefault();
            createAsiaProfitCalculationRate(entity.Id);
            params.put(SCROLL_TOP, '0');
            params.put(PARAM_ID, entity.Id);
            params.put(URL_PARAM_NAME_ISBRANCH, 'true');
            params.put(URL_PARAM_NAME_ISCOPY, 'true');
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl= new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            Test.stopTest();            
        }
        system.debug('★★★★★★★★★★★★ test01 END ★★★★★★★★★★★★');
        
    }
    private static testMethod void test02() {
        system.debug('-------------- test02 Start copy = true -------------');
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProfitCalculationEditorPage;
            Map<String, String> params = new Map<String, String>();
            AsiaProfitCalculation__c entity= createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail2SP(entity.Id);
            createAsiaProfitCalculationRateDefault();
            
            params.put(SCROLL_TOP, '0');
            params.put(PARAM_ID, entity.Id);
            params.put(URL_PARAM_NAME_ISBRANCH, 'true');
            params.put(URL_PARAM_NAME_ISCOPY, 'true');
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl= new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            Test.stopTest();          
        }
        system.debug('---------------- test02 END -----------------');
        
    }
    private static testMethod void test03() {
        system.debug('------------ test03 Start copy = false --------------');
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProfitCalculationEditorPage;
            Map<String, String> params = new Map<String, String>();
            AsiaProfitCalculation__c entity= createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail2SP(entity.Id);
            createAsiaProfitCalculationRateDefault();
            
            params.put(SCROLL_TOP, '0');
            params.put(PARAM_ID, entity.Id);
            params.put(URL_PARAM_NAME_ISBRANCH, 'true');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl= new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            Test.stopTest();            
        }
        system.debug('--------------- test03 END -------------------');
        
    }
    private static testMethod void test04() {
        system.debug('★★★★★★★★★★★★ test04 Start ★★★★★★★★★★★★');
        // Preparation(None)
        System.runAs (testUser) {
            
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            PageReference testPage = Page.JEOLAsia_ProfitCalculationEditorPage;
            Map<String, String> params = new Map<String, String>();
            params.put(SCROLL_TOP, '0');
            
            params.put(URL_PARAM_NAME_ISBRANCH, 'true');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);    
            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl= new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            Test.stopTest();            
        }
        system.debug('★★★★★★★★★★★★ test04 END ★★★★★★★★★★★★');
    }
    private static testMethod void test05() {
        system.debug('★★★★★★★★★★★★ test05 Start ★★★★★★★★★★★★');
        // Preparation(None)
        System.runAs (testUser) {
            
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser('Not Asia Company');
            PageReference testPage = Page.JEOLAsia_ProfitCalculationEditorPage;
            Map<String, String> params = new Map<String, String>();
            params.put(SCROLL_TOP, '0');
            
            params.put(URL_PARAM_NAME_ISBRANCH, 'true');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);    
            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl= new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            Test.stopTest();            
        }
        system.debug('★★★★★★★★★★★★ test05 END ★★★★★★★★★★★★');
    }
    private static testMethod void test06() {
        system.debug('★★★★★★★★★★★★ test06 Start ★★★★★★★★★★★★');
        // Preparation(None)
        System.runAs (testUser) {
            
            Test.startTest();
            createAsiaCompanyData();
            
            updateTestUser(QUOTATION_COMPANY_ASIA);
            PageReference testPage = Page.JEOLAsia_ProfitCalculationEditorPage;
            Map<String, String> params = new Map<String, String>();
            AsiaProfitCalculation__c entity= createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail2SP(entity.Id);
            createAsiaProfitCalculationRateDefault();
            createAsiaProfitCalculationRate(entity.Id);
            params.put(SCROLL_TOP, '0');
            params.put(PARAM_ID, entity.Id);
            params.put(URL_PARAM_NAME_ISBRANCH, 'true');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);    
            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl= new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            Test.stopTest();            
        }
        system.debug('★★★★★★★★★★★★ test06 END ★★★★★★★★★★★★');
    }

    private static testMethod void test07() {
        System.runAs (testUser) {
            
            Test.startTest();

                        testUser.Phone = '123456789';
                testUser.Email = 'test@mail.com';
                update testUser;

                Contact contact = new Contact(Email = 'test@mail.com', LastName = 'test');
                insert contact;

                AsiaTermsAndConditons__c asiaTermAndCondObj = new AsiaTermsAndConditons__c(Company__c = 'ASIA', SortNo__c = 1, TermsAndConditions__c = 'Rich Text Area for Term and Condition Testing');
                insert asiaTermAndCondObj;

                

                AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, ShipmentContact_dummyField__c = contact.Id, ContractContact_dummyField__c = contact.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
                                                            OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
                                                            TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
                                                            CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
                                                            QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
                                                            Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
                                                            DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
                insert asiaProfitCalcObj;

                List<AsiaProfitCalculationDetail__c> asiaProfitCalcDetailList = new List<AsiaProfitCalculationDetail__c>();
                asiaProfitCalcDetailList.add(new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'A', Body__c = '品名B', Name = 'test', SortNo__c = 1, Depth__c = 0));
                asiaProfitCalcDetailList.add(new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'G', Body__c = '品名B', Name = 'test', SortNo__c = 1, Depth__c = 0));
                insert asiaProfitCalcDetailList;

                AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
                insert conditionObj;

                List<AsiaQuotationDescription__c>asiaQuotationDescList = new List<AsiaQuotationDescription__c>();
                asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailList[0].Id, CurrencyIsoCode = 'JPY'));
                asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailList[0].Id, CurrencyIsoCode = 'JPY', ProductSpecification__c = 'test <br/><br>This is Testing. \r\n Testing again. \n <br/><table><tr><td>testing</td></tr><tr><td>testing</td></tr></table><br>Testing<br/><br/><br>This is Testing. \r\n Testing again. \n <br/>'));
                asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailList[1].Id, CurrencyIsoCode = 'JPY'));
                asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailList[1].Id, CurrencyIsoCode = 'JPY', ProductSpecification__c = 'test <br/><br>This is Testing. \r\n Testing again. \n <br/><table><tr><td>testing</td></tr><tr><td>testing</td></tr></table><br>Testing<br/><br/><br>This is Testing. \r\n Testing again. \n <br/>'));
                insert asiaQuotationDescList;

            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl = new JEOLAsia_ProfitCalculationEditorPageCtrl();
            


            Test.stopTest();
        }
    }

    private static testMethod void test08() {
        System.runAs (testUser) {            
            Test.startTest();

            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl = new JEOLAsia_ProfitCalculationEditorPageCtrl();
            String s = ctrl.QuotationRecordtypeLabelUnit;
            s = ctrl.inputDefaultRowsItems;
            s = ctrl.inputDefaultRowsHeading;
            s = ctrl.inputDefaultRowsSubItems;
            s = ctrl.listRowToDel;
            s = ctrl.RejectCommentInput;
            s = ctrl.EscalateCommentInputDirector;
            s = ctrl.EscalateCommentInputMD;

            AsiaProfitCalculation__c obj = ctrl.getProxyObject();

            ctrl.qdm.ParentRec.IssueDate__c = Date.today();
            ctrl.refreshDateQT();

            ctrl.qdm.ParentRec.RecordTypeId = Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().values().get(0).RecordTypeId;
            Boolean b = ctrl.getIsSVC();
            b = ctrl.getIsUnit();

            s = ctrl.getDetailType();
            ctrl.setDetailType('');

            s = ctrl.getIsFixedPC();

            List<SelectOption> so = ctrl.getReductionOptions();
            so = ctrl.getModelTypeScreenOptions();
//            b = ctrl.getHasMultipleModelTypeScreenOptions();
            so = ctrl.getProfitCalculationTypeOptions();
            so = ctrl.getSeriesOptions();
            so = ctrl.getUnitOptions();
            so = ctrl.getIncotermsOptions();
            so = ctrl.getIncotermsDestinationOptions();
            so = ctrl.getDelivConditionOptions();
            so = ctrl.getQuantityUnitOptions();

            Pagereference pr = ctrl.profitCalculationCopy();
            pr = ctrl.goToCustomerInformation();
            pr = ctrl.goToEndUserInformation();
            pr = ctrl.goToTermsAndConditions();
            pr = ctrl.goToEditSpecifications();
            pr = ctrl.profitCalculationCopyAndBranch();

            so = ctrl.getCandidateUnitBody();
            ctrl.delivConditionAttachment();
            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();
            ctrl.shipmentContactAttachment();
            ctrl.requestApproval();
            ctrl.requestApprovalSVCAssistant1();
            ctrl.requestApprovalSVCAssistant2();
            ctrl.requestApprovalSVCDirector();
            ctrl.recallApprovalRequest();
            ctrl.approveRequest();
            ctrl.rejectRequest();
            ctrl.escalateRequestDirector();
            ctrl.escalateRequestMD();
            ctrl.dummyAction();
            ctrl.contractAccountInputCopy();
            ctrl.deleteMultiRows();
            ctrl.listRowToDel = '(\'aaa\',\'bbb\')';
            ctrl.deleteMultiRows();
            ctrl.doSaveWithPrintDatePart1();            
            //ctrl.doSaveWithPrintDatePart2();
            //ctrl.deleteAction();

            Map<String, String> values = new Map<String, String>();
            values.put('EnglishName__c', 'dummy');
            values.put('Name', 'dummy');
            values.put('Division__c', 'dummy');
            values.put('ModelType__c', 'dummy');
            values.put('Supplier__c', 'dummy');
            values.put('CurrencySearch__c', 'dummy');
            JEOLAsia_ProfitCalculationEditorPageCtrl.getProductMaster(values, 'ccc', 'ASIA', '2017-01-01', '\'aaa\',\'bbb\'', Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().values().get(0).RecordTypeId);   
             
            ProductItemPrice__c pip = JEOLAsia_ProfitCalculationEditorPageCtrl.searchProductItemAsia('aaa', 'bbb', 'ccc', 'ddd', '2017-01-01', '\'aaa\',\'bbb\'', 
                                      Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().values().get(0).RecordTypeId, 
                                      'eee', 'fff', 'ggg', 
                                      Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().values().get(0).RecordTypeId); 

            values.put('Name', 'dummy');
            values.put('ProfitCalculationNo__c', 'dummy');
            values.put('BranchNo__c', 'dummy');
            values.put('CreatedDateFormula__c', '2017/01/01');
            List<AsiaProfitCalculation__c> apc = JEOLAsia_ProfitCalculationEditorPageCtrl.getQuotationInfo(values);

            List<AsiaProfitCalculationDetail__c> apcd = JEOLAsia_ProfitCalculationEditorPageCtrl.getQuotationDetails(values);

            values.put('ClassificationNo__c', 'dummy');
            values.put('SearchKeyWord__c', 'dummy');
            values.put('ProductCatalog__c', 'dummy');
            List<AsiaProductCatalog__c> apcat = JEOLAsia_ProfitCalculationEditorPageCtrl.getCatalogHead(values, 'aaa');

            apcat = JEOLAsia_ProfitCalculationEditorPageCtrl.getChildCatalogStructure('aaa', 'bbb', 'ccc', 'ddd');

            List<String> ls = JEOLAsia_ProfitCalculationEditorPageCtrl.getSuggestions('aaa', Schema.SObjectType.AsiaProfitCalculation__c.getRecordTypeInfosById().values().get(0).RecordTypeId);

            pr = ctrl.getPreviewUrl();
            pr = ctrl.getPrintUrl();
          
            s = ctrl.qdm.createdItemInfos;
            s = ctrl.qdm.currencyForCatalogAdd;
            s = ctrl.qdm.dateQuotation;
            s = ctrl.qdm.listPriceBooksCode;
            s = ctrl.qdm.selectedQuotationId;
            s = ctrl.qdm.targetAccountId;

            List<JEOLAsia_ProfitCalculationEditorPageCtrl.QuotationDetailItem> qdi = ctrl.qdm.getItemsAll();
            qdi = ctrl.qdm.getBaseItemsAll();
            qdi = ctrl.qdm.getItemsAllNotDeleted();
            qdi = ctrl.qdm.getItemsA2SP();
            qdi = ctrl.qdm.getBaseItemsA2SP();
            qdi = ctrl.qdm.getBaseItemsA();
            qdi = ctrl.qdm.getBaseItemsB();
            qdi = ctrl.qdm.getItemsC();
            qdi = ctrl.qdm.getBaseItemsC();
            qdi = ctrl.qdm.getItemsD();
            qdi = ctrl.qdm.getBaseItemsD();
            qdi = ctrl.qdm.getItemsE();
            qdi = ctrl.qdm.getBaseItemsE();
            qdi = ctrl.qdm.getItemsF();
            qdi = ctrl.qdm.getBaseItemsF();
            qdi = ctrl.qdm.getItemsG();
            qdi = ctrl.qdm.getBaseItemsG();
            ctrl.qdm.createQuotationDetailAx5();
            ctrl.qdm.createQuotationDetailBx5();
            ctrl.qdm.createQuotationDetailCx5();
            ctrl.qdm.createQuotationDetailDx5();
            ctrl.qdm.createQuotationDetailEx5();
            ctrl.qdm.createQuotationDetailFx5();
            ctrl.qdm.createQuotationDetailGx5();
            qdi = ctrl.qdm.getItemsA2SP();
            ctrl.qdm.createHeadingDetailA();
            ctrl.qdm.createHeadingDetailB();
            ctrl.qdm.createHeadingDetailC();
            ctrl.qdm.createHeadingDetailD();
            ctrl.qdm.createHeadingDetailE();
            ctrl.qdm.createHeadingDetailF();
            ctrl.qdm.createHeadingDetailG();
            Integer i = ctrl.qdm.getCurrentSize();
            i = ctrl.qdm.getCurrentSize();
            i = ctrl.qdm.getCurrentSizeA();
            i = ctrl.qdm.getCurrentSizeA2SP();
            i = ctrl.qdm.getCurrentSizeB();
            i = ctrl.qdm.getCurrentSizeC();
            i = ctrl.qdm.getCurrentSizeD();
            i = ctrl.qdm.getCurrentSizeE();
            i = ctrl.qdm.getCurrentSizeF();
            i = ctrl.qdm.getCurrentSizeG();

            ctrl.qdm.refreshDetailProductItem();
            ctrl.qdm.importDetailFromQuotation();

//            ctrl.qdm.createdItemInfos = '"SortAs": "SGML", "GlossTerm": "Standard Generalized Markup Language"';
//            ctrl.qdm.createSelectedProductItemDetails();
//            ctrl.qdm.createSelectedProductItemDetailsA();
//            ctrl.qdm.createSelectedProductItemDetailsB();
//            ctrl.qdm.createSelectedProductItemDetailsC();
//            ctrl.qdm.createSelectedProductItemDetailsD();
//            ctrl.qdm.createSelectedProductItemDetailsE();
//            ctrl.qdm.createSelectedProductItemDetailsF();
//            ctrl.qdm.createSelectedProductItemDetailsG();

            JEOLAsia_ProfitCalculationEditorPageCtrl.QuotationDetailItem qditm = new JEOLAsia_ProfitCalculationEditorPageCtrl.QuotationDetailItem(new AsiaProfitCalculationDetail__c());
            qditm.executeAmountCalc();
            Decimal d = qditm.getAmount();
            qditm.deleteAction();
            qditm.copyAction();
            qditm.detailCopy();

            JEOLAsia_ProfitCalculationEditorPageCtrl.QuotationDetailItem2SP qditm2sp = new JEOLAsia_ProfitCalculationEditorPageCtrl.QuotationDetailItem2SP(new AsiaProfitCalculationDetail2SP__c(), '0');
            qditm2sp.deleteAction();
            qditm2sp.copyAction();
            i = qditm2sp.compareTo(qditm2sp);

            ctrl.refreshListRate();
            s = ctrl.selectedModelType;
            s = ctrl.selectedRow;

            JEOLAsia_ProfitCalculationEditorPageCtrl.Obj2SPItem sp = new JEOLAsia_ProfitCalculationEditorPageCtrl.Obj2SPItem(0, false, 0, '', 0, '', 0, 0, 0, 0, 0);
           
            ctrl.refreshCurrent2SP();
            ctrl.saveCurrent2SPInFullSP();
            ctrl.deleteCurrent2SPInFullSP();
            so = ctrl.getQuotationTypeOptions();
            s = ctrl.getRedirectExportCsvURL();
            
            Test.stopTest();
        }
    }

    private static AsiaProfitCalculation__c createAsiaProfitCalculation(){

        AsiaProfitCalculation__c entity = new AsiaProfitCalculation__c();
        entity.Company__c=QUOTATION_COMPANY_ASIA;
        entity.TotalAmount__c = 0;
        entity.Subtitle__c = 0;
        entity.ConsumptionTaxAmount__c = 0;
        entity.TotalTaxAmount__c = 0;
        entity.TaxRate__c = 0;
        entity.DeliveryPeriod__c = null;
        entity.Name='QT00000034_01';
        entity.ProfitCalculation_BranchNo_Sync__c='QT00000034_01';

        
        try{
            insert entity;
            
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculation Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculation Insert Error  end ★★★★★★★★');
        }
        return entity;
    }
    private static List<AsiaProfitCalculationDetail__c> createAsiaProfitCalculationDetail(Id asiaProfitCalculationId){
        List<AsiaProfitCalculationDetail__c> entityList = new List<AsiaProfitCalculationDetail__c>();
        AsiaProfitCalculationDetail__c  entity= new AsiaProfitCalculationDetail__c ();
        entity.Depth__c=0;
        entity.SortNo__c=0;
        entity.Parent__c=asiaProfitCalculationId;
        entity.ModelType__c = 'JSM-6010';
        entity.Type__c = '1';
        entityList.add(entity);
        
        entity= new AsiaProfitCalculationDetail__c ();
        entity.Depth__c=1;
        entity.SortNo__c=1;
        entity.Parent__c=asiaProfitCalculationId;
        entity.ModelType__c = 'JSM-6010';
        entity.Type__c = '1';
        entityList.add(entity);
        
        try{
            insert entityList;
            
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail Insert Error  end ★★★★★★★★');
        }
        return entityList;
    }
    private static void createAsiaProfitCalculationDetail2SP(Id asiaProfitCalculationId){
        List<AsiaProfitCalculationDetail2SP__c> entityDetail2SPList = new List<AsiaProfitCalculationDetail2SP__c>();
        List<AsiaProfitCalculationDetail__c> entityDetailList  = createAsiaProfitCalculationDetail(asiaProfitCalculationId);
        AsiaProfitCalculationDetail2SP__c  entity;
        for(AsiaProfitCalculationDetail__c detail : entityDetailList){
            entity= new AsiaProfitCalculationDetail2SP__c ();
            entity.Description__c='OIL';
            entity.PartNumber__c=780001389;
            entity.IsSelected__c=true;
            entity.Quantity__c=1;
            entity.SalesPrice__c=1500;
            entity.SalesPriceCalculated__c=27.84;
            entity.SortNo__c=1;
            entity.Specification__c='MR-100 1L (SMR-100)';
            entity.UnitPrice__c=1450;
            entity.CostPrice__c=1450;
            entity.CostPriceJPY__c=1450;
            entity.ProfitCalculationDetail__c=detail.Id;
            entityDetail2SPList.add(entity);
            
            entity= new AsiaProfitCalculationDetail2SP__c ();
            entity.Description__c='OIL MIST TRAP';
            entity.PartNumber__c=780006291;
            entity.IsSelected__c=false;
            entity.Quantity__c=1;
            entity.SalesPrice__c=17000;
            entity.SalesPriceCalculated__c=326.4;
            entity.SortNo__c=2;
            entity.Specification__c='OMT-100A';
            entity.UnitPrice__c=17000;
            entity.CostPrice__c=17000;
            entity.CostPriceJPY__c=17000;
            entity.ProfitCalculationDetail__c=detail.Id;
            entityDetail2SPList.add(entity);
        }       
        
        try{
            insert entityDetail2SPList;
            
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail2SP Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail2SP Insert Error  end ★★★★★★★★');
        }
    }
    private static void createAsiaProfitCalculationRate(Id profitCalculationId){
        List<AsiaProfitCalculationRate__c> rateList = new List<AsiaProfitCalculationRate__c>();
        AsiaProfitCalculationRate__c rate= new AsiaProfitCalculationRate__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='JPY';
        rate.CurrencyToConvert__c='USD';
        rate.Rate__c=115;
        rate.ReadOnly__c=false;
        rate.Profit_Calculation__c=profitCalculationId;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRate__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='JPY';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rate.Profit_Calculation__c=profitCalculationId;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRate__c();
        rate.Type__c='2';
        rate.CurrencyBase__c='JPY';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rate.Profit_Calculation__c=profitCalculationId;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRate__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=0.01;
        rate.ReadOnly__c=false;
        rate.Profit_Calculation__c=profitCalculationId;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRate__c();
        rate.Type__c='2';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=0.01;
        rate.ReadOnly__c=false;
        rate.Profit_Calculation__c=profitCalculationId;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRate__c();
        rate.Type__c='2';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='USD';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rate.Profit_Calculation__c=profitCalculationId;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRate__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='USD';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rate.Profit_Calculation__c=profitCalculationId;
        rateList.add(rate);
        
        try{
            insert rateList;
            
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationRateDefault Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationRateDefault Insert Error  end ★★★★★★★★');
        }
        
    }
    private static void createAsiaProfitCalculationRateDefault(){
        List<AsiaProfitCalculationRateDefault__c> rateList = new List<AsiaProfitCalculationRateDefault__c>();
        AsiaProfitCalculationRateDefault__c rate= new AsiaProfitCalculationRateDefault__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='JPY';
        rate.CurrencyToConvert__c='USD';
        rate.Rate__c=115;
        rate.ReadOnly__c=false;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRateDefault__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='JPY';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRateDefault__c();
        rate.Type__c='2';
        rate.CurrencyBase__c='JPY';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRateDefault__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=0.01;
        rate.ReadOnly__c=false;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRateDefault__c();
        rate.Type__c='2';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='JPY';
        rate.Rate__c=0.01;
        rate.ReadOnly__c=false;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRateDefault__c();
        rate.Type__c='1';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='USD';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rateList.add(rate);
        
        rate= new AsiaProfitCalculationRateDefault__c();
        rate.Type__c='2';
        rate.CurrencyBase__c='USD';
        rate.CurrencyToConvert__c='USD';
        rate.Rate__c=1;
        rate.ReadOnly__c=true;
        rateList.add(rate);
        try{
            insert rateList;
            
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationRateDefault Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationRateDefault Insert Error  end ★★★★★★★★');
        }
        
    }
    private static void updateTestUser(String companyName){
        testUser.CompanyName=companyName;
        update testUser;       
    }
    private static void createAsiaCompanyData(){
        CompanyName__c company=new CompanyName__c();
        company.Name=QUOTATION_COMPANY_ASIA;
        company.CompanyName__c=QUOTATION_COMPANY_ASIA;
        company.Company__c=QUOTATION_COMPANY_ASIA;
        company.CompanyLabel__c=QUOTATION_COMPANY_ASIA;
        company.OrgAddress__c=QUOTATION_COMPANY_ASIA;
        company.OrgPhone__c=QUOTATION_COMPANY_ASIA;
        insert company;
    }

    private static testMethod void test09() {
        Profile profile = [select id from profile where name='System Administrator' or name='システム管理者'];
        User testUser5 = new User(profileId = profile.Id, Username = 'tUser5@mail.com', LastName = 'tUser5', Alias = 'tUser5', CommunityNickname = 'tUser5', TimeZoneSidKey = 'Asia/Singapore', LocaleSidKey = 'en_SG', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Phone = '123456789', Email = 'tUser5@mail.com', CompanyName = 'ASIA', UserSign__c = '<img alt="User-added image" src="https://c.cs31.content.force.com/servlet/rtaImage?eid=00510000003siEt&amp;feoid=00Np0000000pQS3&amp;refid=0EMp00000008hnj"></img>');
        insert testUser5;
        System.runAs (testUser) {
            
            Test.startTest();
            testUser.Phone = '123456789';
            testUser.Email = 'test@mail.com';
            testUser.UserSign__c = '<img alt="User-added image" src="https://c.cs31.content.force.com/servlet/rtaImage?eid=00510000003siEt&amp;feoid=00Np0000000pQS3&amp;refid=0EMp00000008hnj"></img>';
            testUser.CompanyName = 'ASIA';
            update testUser;
            
            Account account = new Account(Name = 'TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = 'TURBINE OVERHAUL SERVICES', OfficialName2__c = 'PTE LTD.', OfficialNameRow1__c = 'TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '(PHILIPPINES),INC.', Code__c = 'T007000', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9989', Country__c = 'Singapore');
            insert account;
            Account account2 = new Account(Name = '2TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = '2TURBINE OVERHAUL SERVICES', OfficialName2__c = '2PTE LTD.', OfficialNameRow1__c = '2TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '2(PHILIPPINES),INC.', Code__c = 'T007001', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9999', Country__c = 'Singapore');
            insert account2;

            Account account3 = new Account(Name = '2TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = '2TURBINE OVERHAUL SERVICES', OfficialName2__c = '2PTE LTD.', OfficialNameRow1__c = '2TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '2(PHILIPPINES),INC.', Code__c = 'T007002', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9999', Country__c = 'Singapore');
            insert account3;

            Contact contact = new Contact(Email = 'test@mail.com', LastName = 'test', account = account);
            insert contact;

            Contact contact2 = new Contact(Email = 'test@mail.com', LastName = 'test', account = account2);
            insert contact2;

            CompanyName__c company=new CompanyName__c(Name= 'ASIA', CompanyName__c = 'ASIA', Company__c = 'ASIA', CompanyLabel__c = 'ASIA',
                                        OrgAddress__c = 'ASIA', QuotationPrintSignUserID__c = testUser.Id);
            insert company;
            AsiaTermsAndConditons__c asiaTermAndCondObj = new AsiaTermsAndConditons__c(Company__c = 'ASIA', SortNo__c = 1, TermsAndConditions__c = 'Rich Text Area for Term and Condition Testing');
            insert asiaTermAndCondObj;
            RecordType record = [select Id, DeveloperName from RecordType where DeveloperName = 'SVC' limit 1];
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(ShipmentAccount__c = account3.Id, ContractAccount__c = account2.Id, BranchNo__c = '1', JProdCostCurrency__c = 'JPY', salesCurrency__c = 'JPY', ContractAccount_dummyField__c = account2.Id, Status__c = '2', SalesAssistant__c = testUser5.Id, SalesPerson__c = testUser5.Id, ShipmentContact_dummyField__c = contact.Id, ContractContact_dummyField__c = contact2.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
                                                                                      OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
                                                                                      TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
                                                                                      CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
                                                                                      QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
                                                                                      Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
                                                                                      DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test', TitleRow1__c = 'test', TitleRow2__c = 'test', TitleRow3__c = 'test', TitleRow4__c = 'test', TitleRow5__c = 'test',
                                                                                      RecordTypeId = record.Id, ShipmentCode__c = 'T007000');
            insert asiaProfitCalcObj;
            
            UnitBody__c unitBodyObj = new UnitBody__c(SerialNo__c = 'test', DeliveryAccount__c = account.Id);

            List<String> categoryList = new List<String>{'A', 'B', 'C', 'D', 'E', 'F', 'G'};
            List<String> modelType = new List<String>{'test \r\n test \r \'\" test \r\n test \n test \r\n test', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010'};
            List<AsiaProfitCalculationDetail__c> asiaProfitCalculationDetailList = new List<AsiaProfitCalculationDetail__c>();
            for(Integer i = 0; i<7; i++)
            {
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = categoryList[i], Body__c = '品名B', ModelType__c = modelType[i], Name = 'test', SortNo__c = 1, Depth__c = 0, SalesPrice__c = 1000, SalesPriceCalculated__c = 1000, Quantity__c = 1000, QuantityUnit__c = 'kg', SalesPriceSalesCur2SP__c = 1000);
            asiaProfitCalculationDetailList.add(asiaProfitCalcDetailObj);
            }
            
            insert asiaProfitCalculationDetailList;

            List<AsiaProfitCalculationRateDefault__c> asiaProfitCalcRateDefList = new List<AsiaProfitCalculationRateDefault__c>();
            asiaProfitCalcRateDefList.add(new AsiaProfitCalculationRateDefault__c(Type__c = '1', Company__c = 'ASIA', CurrencyBase__c = 'JPY', CurrencyToConvert__c = 'USD', Rate__c = 115, ReadOnly__c = false));
            asiaProfitCalcRateDefList.add(new AsiaProfitCalculationRateDefault__c(Type__c = '2', Company__c = 'ASIA', CurrencyBase__c = 'USD', CurrencyToConvert__c = 'JPY', Rate__c = 0.0087, ReadOnly__c = false));
            insert asiaProfitCalcRateDefList;

            List<AsiaProfitCalculationRate__c> asiaProfitCalcRateList = new List<AsiaProfitCalculationRate__c>();
            asiaProfitCalcRateList.add(new AsiaProfitCalculationRate__c(Type__c = '1', CurrencyBase__c = 'JPY', CurrencyToConvert__c = 'USD', Rate__c = 115, ReadOnly__c = false, Profit_Calculation__c = asiaProfitCalcObj.id));
            asiaProfitCalcRateList.add(new AsiaProfitCalculationRate__c(Type__c = '2', CurrencyBase__c = 'USD', CurrencyToConvert__c = 'JPY', Rate__c = 0.0087, ReadOnly__c = false, Profit_Calculation__c = asiaProfitCalcObj.id));
            insert asiaProfitCalcRateList;

            List<AsiaProductItem2SP__c> asiaProductItem2SPList = new List<AsiaProductItem2SP__c>();
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            insert asiaProductItem2SPList;

            List<ProductItem__c> productItemList = new List<ProductItem__c>();
            productItemList.add(new ProductItem__c(Name = '780001389', EnglishName__c = 'NARROW AREA SCANNER', Kikaku__c = 'ｷｮｳｲｷｽｷｬﾅ', ProductItemType__c = '1'));
            insert productItemList;

            List<ProductItemPrice__c> productItemPriceList = new List<ProductItemPrice__c>();
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'USD', PriceBookCode__c = 'A14', PriceBookOrigin__c = '2', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'USD', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            insert productItemPriceList;

            List<AsiaJProdSalesCoefficient__c> asiaJProdSalesCoefficientList = new List<AsiaJProdSalesCoefficient__c>();
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 0, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = false, Agency__c = 0, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.8, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            insert asiaJProdSalesCoefficientList;

            PageReference pageRef = Page.JEOLAsia_ProfitCalculationEditorPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            pageRef.getParameters().put(SCROLL_TOP, '0');
            pageRef.getParameters().put(URL_PARAM_NAME_ISBRANCH, 'true');
            pageRef.getParameters().put(URL_PARAM_NAME_ISCOPY, 'false');

            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl = new JEOLAsia_ProfitCalculationEditorPageCtrl();
            
            ctrl.refreshDateQT();
            ctrl.getIsSVC();
            ctrl.getIsUnit();
            ctrl.getIsAsia();
            ctrl.getDetailType();
            ctrl.getIsFixedPC();
            ctrl.getReductionOptions();
            ctrl.getModelTypeScreenOptions();
            ctrl.getHasMultipleModelTypeScreenOptions();
            ctrl.getProfitCalculationTypeOptions();
            ctrl.getSeriesOptions();
            ctrl.getUnitOptions();
            ctrl.getIncotermsOptions();
            ctrl.getIncotermsDestinationOptions();
            ctrl.getDelivConditionOptions();
            ctrl.getQuantityUnitOptions();
            ctrl.profitCalculationCopy();
            ctrl.goToCustomerInformation();
            ctrl.goToEndUserInformation();
            ctrl.goToTermsAndConditions();
            ctrl.goToEditSpecifications();
            ctrl.profitCalculationCopyAndBranch();
            ctrl.getCandidateUnitBody();
            ctrl.delivConditionAttachment();

            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();

            ctrl.shipmentContactAttachment();
            ctrl.contractAccountInputCopy();
            ctrl.requestApproval();
            ctrl.requestApprovalSVCAssistant1();
            ctrl.requestApprovalSVCAssistant2();
            ctrl.requestApprovalSVCDirector();
            ctrl.recallApprovalRequest();
            ctrl.approveRequest();
            ctrl.rejectRequest();
            ctrl.escalateRequestDirector();
            ctrl.escalateRequestMD();
            ctrl.dummyAction();

            ctrl.ajaxSaveAction();
            ctrl.deleteMultiRows();
            ctrl.isReadOnly = true;
            ctrl.saveAction();

            ctrl.doSaveWithPrintDatePart1();
            ctrl.doSaveWithPrintDatePart2();
            

            ctrl.getPreviewUrl();
            ctrl.getPrintUrl();
            ctrl.refreshListRate();
            ctrl.refreshCurrent2SP();
            ctrl.saveCurrent2SPInFullSP();
            
            ctrl.getListRecordTypeID();
            ctrl.getQuotationTypeOptions();
            ctrl.getRedirectExportCsvURL();

            ctrl.deleteCurrent2SPInFullSP();
            //ctrl.deleteAction();


            Test.stopTest();
        }
    }

    private static testMethod void test10() {
        Profile profile = [select id from profile where name='System Administrator' or name='システム管理者'];
        User testUser3 = new User(profileId = profile.Id, Username = 'tUser3@mail.com', LastName = 'tUser3', Alias = 'tUser3', CommunityNickname = 'tUser3', TimeZoneSidKey = 'Asia/Singapore', LocaleSidKey = 'en_SG', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Phone = '123456789', Email = 'tUser3@mail.com', CompanyName = 'ASIA', UserSign__c = '<img alt="User-added image" src="https://c.cs31.content.force.com/servlet/rtaImage?eid=00510000003siEt&amp;feoid=00Np0000000pQS3&amp;refid=0EMp00000008hnj"></img>');
        insert testUser3;
        System.runAs (testUser) {
            
            Test.startTest();
            testUser.Phone = '123456789';
            testUser.Email = 'test@mail.com';
            testUser.UserSign__c = '<img alt="User-added image" src="https://c.cs31.content.force.com/servlet/rtaImage?eid=00510000003siEt&amp;feoid=00Np0000000pQS3&amp;refid=0EMp00000008hnj"></img>';
            update testUser;
            
            Account account = new Account(Name = 'TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = 'TURBINE OVERHAUL SERVICES', OfficialName2__c = 'PTE LTD.', OfficialNameRow1__c = 'TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '(PHILIPPINES),INC.', Code__c = 'T007000', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9989', Country__c = 'Singapore');
            insert account;
            Account account2 = new Account(Name = '2TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = '2TURBINE OVERHAUL SERVICES', OfficialName2__c = '2PTE LTD.', OfficialNameRow1__c = '2TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '2(PHILIPPINES),INC.', Code__c = 'T007001', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9999', Country__c = 'Singapore');
            insert account2;

            Account account3 = new Account(Name = '2TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = '2TURBINE OVERHAUL SERVICES', OfficialName2__c = '2PTE LTD.', OfficialNameRow1__c = '2TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '2(PHILIPPINES),INC.', Code__c = 'T007002', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9999', Country__c = 'Singapore');
            insert account3;

            Contact contact = new Contact(Email = 'test@mail.com', LastName = 'test', account = account);
            insert contact;

            Contact contact2 = new Contact(Email = 'test@mail.com', LastName = 'test', account = account2);
            insert contact2;

            CompanyName__c company=new CompanyName__c(Name= 'ASIA', CompanyName__c = 'ASIA', Company__c = 'ASIA', CompanyLabel__c = 'ASIA',
                                        OrgAddress__c = 'ASIA', QuotationPrintSignUserID__c = testUser.Id);
            insert company;
            AsiaTermsAndConditons__c asiaTermAndCondObj = new AsiaTermsAndConditons__c(Company__c = 'ASIA', SortNo__c = 1, TermsAndConditions__c = 'Rich Text Area for Term and Condition Testing');
            insert asiaTermAndCondObj;
            RecordType record = [select Id, DeveloperName from RecordType where DeveloperName = 'Unit' limit 1];
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(ShipmentAccount__c = account2.Id, ContractAccount__c = account3.Id, BranchNo__c = '1', JProdCostCurrency__c = 'JPY', salesCurrency__c = 'JPY', ContractAccount_dummyField__c = account2.Id, Status__c = '2', SalesAssistant__c = testUser3.Id, SalesPerson__c = testUser3.Id, ShipmentContact_dummyField__c = contact.Id, ContractContact_dummyField__c = contact2.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
                                                                                      OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
                                                                                      TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
                                                                                      CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
                                                                                      QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
                                                                                      Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
                                                                                      DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test', TitleRow1__c = 'test', TitleRow2__c = 'test', TitleRow3__c = 'test', TitleRow4__c = 'test', TitleRow5__c = 'test',
                                                                                      RecordTypeId = record.Id, ShipmentCode__c = 'T007000');
            insert asiaProfitCalcObj;
            UnitBody__c unitBodyObj = new UnitBody__c(SerialNo__c = 'test', DeliveryAccount__c = account.Id);

            List<String> categoryList = new List<String>{'A', 'B', 'C', 'D', 'E', 'F', 'G'};
            List<String> modelType = new List<String>{'test \r\n test \r \'\" test \r\n test \n test \r\n test', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010'};
            List<AsiaProfitCalculationDetail__c> asiaProfitCalculationDetailList = new List<AsiaProfitCalculationDetail__c>();
            for(Integer i = 0; i<7; i++)
            {
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = categoryList[i], Body__c = '品名B', ModelType__c = modelType[i], Name = 'test', SortNo__c = 1, Depth__c = 0, SalesPrice__c = 1000, SalesPriceCalculated__c = 1000, Quantity__c = 1000, QuantityUnit__c = 'kg', SalesPriceSalesCur2SP__c = 1000);
            asiaProfitCalculationDetailList.add(asiaProfitCalcDetailObj);
            }
            
            insert asiaProfitCalculationDetailList;

            List<AsiaProfitCalculationRateDefault__c> asiaProfitCalcRateDefList = new List<AsiaProfitCalculationRateDefault__c>();
            asiaProfitCalcRateDefList.add(new AsiaProfitCalculationRateDefault__c(Type__c = '1', Company__c = 'ASIA', CurrencyBase__c = 'JPY', CurrencyToConvert__c = 'USD', Rate__c = 115, ReadOnly__c = false));
            asiaProfitCalcRateDefList.add(new AsiaProfitCalculationRateDefault__c(Type__c = '2', Company__c = 'ASIA', CurrencyBase__c = 'USD', CurrencyToConvert__c = 'JPY', Rate__c = 0.0087, ReadOnly__c = false));
            insert asiaProfitCalcRateDefList;

            List<AsiaProfitCalculationRate__c> asiaProfitCalcRateList = new List<AsiaProfitCalculationRate__c>();
            asiaProfitCalcRateList.add(new AsiaProfitCalculationRate__c(Type__c = '1', CurrencyBase__c = 'JPY', CurrencyToConvert__c = 'USD', Rate__c = 115, ReadOnly__c = false, Profit_Calculation__c = asiaProfitCalcObj.id));
            asiaProfitCalcRateList.add(new AsiaProfitCalculationRate__c(Type__c = '2', CurrencyBase__c = 'USD', CurrencyToConvert__c = 'JPY', Rate__c = 0.0087, ReadOnly__c = false, Profit_Calculation__c = asiaProfitCalcObj.id));
            insert asiaProfitCalcRateList;

            List<AsiaProductItem2SP__c> asiaProductItem2SPList = new List<AsiaProductItem2SP__c>();
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            insert asiaProductItem2SPList;

            List<ProductItem__c> productItemList = new List<ProductItem__c>();
            productItemList.add(new ProductItem__c(Name = '780001389', EnglishName__c = 'NARROW AREA SCANNER', Kikaku__c = 'ｷｮｳｲｷｽｷｬﾅ', ProductItemType__c = '1'));
            insert productItemList;

            List<ProductItemPrice__c> productItemPriceList = new List<ProductItemPrice__c>();
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'USD', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'USD', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            insert productItemPriceList;

            List<AsiaJProdSalesCoefficient__c> asiaJProdSalesCoefficientList = new List<AsiaJProdSalesCoefficient__c>();
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 0, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = false, Agency__c = 0, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.8, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            insert asiaJProdSalesCoefficientList;

            PageReference pageRef = Page.JEOLAsia_ProfitCalculationEditorPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            pageRef.getParameters().put(SCROLL_TOP, '0');
            pageRef.getParameters().put(URL_PARAM_NAME_ISBRANCH, 'false');
            pageRef.getParameters().put(URL_PARAM_NAME_ISCOPY, 'true');

            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl = new JEOLAsia_ProfitCalculationEditorPageCtrl();
            

            ctrl.refreshDateQT();
            ctrl.getIsSVC();
            ctrl.getIsUnit();
            ctrl.getIsAsia();
            ctrl.getDetailType();
            ctrl.getIsFixedPC();
            ctrl.getReductionOptions();
            ctrl.getModelTypeScreenOptions();
            ctrl.getHasMultipleModelTypeScreenOptions();
            ctrl.getProfitCalculationTypeOptions();
            ctrl.getSeriesOptions();
            ctrl.getUnitOptions();
            ctrl.getIncotermsOptions();
            ctrl.getIncotermsDestinationOptions();
            ctrl.getDelivConditionOptions();
            ctrl.getQuantityUnitOptions();
            ctrl.profitCalculationCopy();
            ctrl.goToCustomerInformation();
            ctrl.goToEndUserInformation();
            ctrl.goToTermsAndConditions();
            ctrl.goToEditSpecifications();
            ctrl.profitCalculationCopyAndBranch();
            ctrl.getCandidateUnitBody();
            ctrl.delivConditionAttachment();

            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();

            ctrl.shipmentContactAttachment();
            ctrl.contractAccountInputCopy();
            ctrl.requestApproval();
            ctrl.requestApprovalSVCAssistant1();
            ctrl.requestApprovalSVCAssistant2();
            ctrl.requestApprovalSVCDirector();
            ctrl.recallApprovalRequest();
            ctrl.approveRequest();
            ctrl.rejectRequest();
            ctrl.escalateRequestDirector();
            ctrl.escalateRequestMD();
            ctrl.dummyAction();

            ctrl.ajaxSaveAction();
            ctrl.deleteMultiRows();
            ctrl.isReadOnly = true;
            ctrl.saveAction();

            ctrl.doSaveWithPrintDatePart1();
            //ctrl.doSaveWithPrintDatePart2();
            

            ctrl.getPreviewUrl();
            ctrl.getPrintUrl();
            ctrl.refreshListRate();
            ctrl.refreshCurrent2SP();
            ctrl.saveCurrent2SPInFullSP();
            
            ctrl.getListRecordTypeID();
            ctrl.getQuotationTypeOptions();
            ctrl.getRedirectExportCsvURL();

            ctrl.deleteCurrent2SPInFullSP();

            Test.stopTest();
        }
    }

    private static testMethod void test11() {
        Profile profile = [select id from profile where name='System Administrator' or name='システム管理者'];
        User testUser4 = new User(profileId = profile.Id, Username = 'tUser4@mail.com', LastName = 'tUser4', Alias = 'tUser4', CommunityNickname = 'tUser4', TimeZoneSidKey = 'Asia/Singapore', LocaleSidKey = 'en_SG', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Phone = '123456789', Email = 'tUser4@mail.com', CompanyName = 'ASIA', UserSign__c = '<img alt="User-added image" src="https://c.cs31.content.force.com/servlet/rtaImage?eid=00510000003siEt&amp;feoid=00Np0000000pQS3&amp;refid=0EMp00000008hnj"></img>');
        insert testUser4;
        System.runAs (testUser) {
            
            Test.startTest();
            testUser.Phone = '123456789';
            testUser.Email = 'test@mail.com';
            testUser.UserSign__c = '<img alt="User-added image" src="https://c.cs31.content.force.com/servlet/rtaImage?eid=00510000003siEt&amp;feoid=00Np0000000pQS3&amp;refid=0EMp00000008hnj"></img>';
            update testUser;            
            
            Account account = new Account(Name = 'TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = 'TURBINE OVERHAUL SERVICES', OfficialName2__c = 'PTE LTD.', OfficialNameRow1__c = 'TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '(PHILIPPINES),INC.', Code__c = 'T007000', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9989', Country__c = 'Singapore');
            insert account;
            Account account2 = new Account(Name = '2TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = '2TURBINE OVERHAUL SERVICES', OfficialName2__c = '2PTE LTD.', OfficialNameRow1__c = '2TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '2(PHILIPPINES),INC.', Code__c = 'T007001', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9999', Country__c = 'Singapore');
            insert account2;
            Account account3 = new Account(Name = '2TURBINE OVERHAUL SERVICES PTE LTD.', OfficialName1__c = '2TURBINE OVERHAUL SERVICES', OfficialName2__c = '2PTE LTD.', OfficialNameRow1__c = '2TEMASEK LIFE SCIENCES LABORATORY',
                                    OfficialNameRow2__c = '2(PHILIPPINES),INC.', Code__c = 'T007002', Address__c = 'NO.5 TUAS DRIVE 2 SINGAPORE 638363', PostalCode__c = '1234556', Fax = '+65 6565 2233',
                                    Phone = '+65 6565 9999', Country__c = 'Singapore');
            insert account3;

            Contact contact = new Contact(Email = 'test@mail.com', LastName = 'test', account = account);
            insert contact;

            Contact contact2 = new Contact(Email = 'test@mail.com', LastName = 'test', account = account2);
            insert contact2;

            CompanyName__c company=new CompanyName__c(Name= 'ASIA', CompanyName__c = 'ASIA', Company__c = 'ASIA', CompanyLabel__c = 'ASIA',
                                        OrgAddress__c = 'ASIA', QuotationPrintSignUserID__c = testUser.Id);
            insert company;
            AsiaTermsAndConditons__c asiaTermAndCondObj = new AsiaTermsAndConditons__c(Company__c = 'ASIA', SortNo__c = 1, TermsAndConditions__c = 'Rich Text Area for Term and Condition Testing');
            insert asiaTermAndCondObj;
            RecordType record = [select Id, DeveloperName from RecordType where DeveloperName = 'Unit' limit 1];
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(ShipmentAccount__c = account2.Id, ContractAccount__c = account3.Id, BranchNo__c = '1', JProdCostCurrency__c = 'JPY', salesCurrency__c = 'JPY', ContractAccount_dummyField__c = account2.Id, Status__c = '2', SalesAssistant__c = testUser4.Id, SalesPerson__c = testUser4.Id, ShipmentContact_dummyField__c = contact.Id, ContractContact_dummyField__c = contact2.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
                                                                                      OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
                                                                                      TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
                                                                                      CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
                                                                                      QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
                                                                                      Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
                                                                                      DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test', TitleRow1__c = 'test', TitleRow2__c = 'test', TitleRow3__c = 'test', TitleRow4__c = 'test', TitleRow5__c = 'test',
                                                                                      RecordTypeId = record.Id, ShipmentCode__c = 'T007000');
            insert asiaProfitCalcObj;
            UnitBody__c unitBodyObj = new UnitBody__c(SerialNo__c = 'test', DeliveryAccount__c = account.Id);

            List<String> categoryList = new List<String>{'A', 'B', 'C', 'D', 'E', 'F', 'G'};
            List<String> modelType = new List<String>{'test \r\n test \r \'\" test \r\n test \n test \r\n test', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010', 'JSM-6010'};
            List<AsiaProfitCalculationDetail__c> asiaProfitCalculationDetailList = new List<AsiaProfitCalculationDetail__c>();
            for(Integer i = 0; i<7; i++)
            {
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Type__c = '1', Parent__c = asiaProfitCalcObj.id, Category__c = categoryList[i], Body__c = '品名B', ModelType__c = modelType[i], Name = 'test', SortNo__c = 1, Depth__c = 0, SalesPrice__c = 1000, SalesPriceCalculated__c = 1000, Quantity__c = 1000, QuantityUnit__c = 'kg', SalesPriceSalesCur2SP__c = 1000);
            asiaProfitCalculationDetailList.add(asiaProfitCalcDetailObj);
            }
            
            insert asiaProfitCalculationDetailList;

            List<AsiaProfitCalculationRateDefault__c> asiaProfitCalcRateDefList = new List<AsiaProfitCalculationRateDefault__c>();
            asiaProfitCalcRateDefList.add(new AsiaProfitCalculationRateDefault__c(Type__c = '1', Company__c = 'ASIA', CurrencyBase__c = 'JPY', CurrencyToConvert__c = 'USD', Rate__c = 115, ReadOnly__c = false));
            asiaProfitCalcRateDefList.add(new AsiaProfitCalculationRateDefault__c(Type__c = '2', Company__c = 'ASIA', CurrencyBase__c = 'USD', CurrencyToConvert__c = 'JPY', Rate__c = 0.0087, ReadOnly__c = false));
            insert asiaProfitCalcRateDefList;

            List<AsiaProfitCalculationRate__c> asiaProfitCalcRateList = new List<AsiaProfitCalculationRate__c>();
            asiaProfitCalcRateList.add(new AsiaProfitCalculationRate__c(Type__c = '1', CurrencyBase__c = 'JPY', CurrencyToConvert__c = 'USD', Rate__c = 115, ReadOnly__c = false, Profit_Calculation__c = asiaProfitCalcObj.id));
            asiaProfitCalcRateList.add(new AsiaProfitCalculationRate__c(Type__c = '2', CurrencyBase__c = 'USD', CurrencyToConvert__c = 'JPY', Rate__c = 0.0087, ReadOnly__c = false, Profit_Calculation__c = asiaProfitCalcObj.id));
            insert asiaProfitCalcRateList;

            List<AsiaProductItem2SP__c> asiaProductItem2SPList = new List<AsiaProductItem2SP__c>();
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            asiaProductItem2SPList.add(new AsiaProductItem2SP__c(Description__c = 'O-RING', ModelType__c = 'JSM-6010', PartNumber__c = 780001389, IsSelectedDefault__c = true, QuantityDefault__c = 1, SortNo__c = 891, Specification__c = 'MR-100 1L (SMR-100)', UnitPrice__c = 1450));
            insert asiaProductItem2SPList;

            List<ProductItem__c> productItemList = new List<ProductItem__c>();
            productItemList.add(new ProductItem__c(Name = '780001389', EnglishName__c = 'NARROW AREA SCANNER', Kikaku__c = 'ｷｮｳｲｷｽｷｬﾅ', ProductItemType__c = '1'));
            insert productItemList;

            List<ProductItemPrice__c> productItemPriceList = new List<ProductItemPrice__c>();
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'USD', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'USD', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            productItemPriceList.add(new ProductItemPrice__c(Price__c = 100, CostCurrency__c = 'JPY', PriceBookCode__c = 'A14', PriceBookOrigin__c = '1', ProductItem__c = productItemList[0].Id, TechnicalAlways1__c = 1, StartDate__c = Date.today()-10, QuantityUnit__c = 'PC', PriceUnit__c = 'PC'));           
            insert productItemPriceList;

            List<AsiaJProdSalesCoefficient__c> asiaJProdSalesCoefficientList = new List<AsiaJProdSalesCoefficient__c>();
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 0, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.0, IsSVC__c = false, Agency__c = 0, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.5, IsSVC__c = false, Agency__c = 1, Area__c = 'Singapore'));
            asiaJProdSalesCoefficientList.add(new AsiaJProdSalesCoefficient__c(ModelType__c = 'JSM-6010', Coefficient__c = 2.8, IsSVC__c = true, Agency__c = 1, Area__c = 'Singapore'));
            insert asiaJProdSalesCoefficientList;

            PageReference pageRef = Page.JEOLAsia_ProfitCalculationEditorPage;
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put(URL_PARAM_NAME_ISCOPY, 'false');

            JEOLAsia_ProfitCalculationEditorPageCtrl ctrl = new JEOLAsia_ProfitCalculationEditorPageCtrl();

            ctrl.refreshDateQT();
            //ctrl.getIsSVC();
            //ctrl.getIsUnit();
            ctrl.getIsAsia();
            ctrl.getDetailType();
            ctrl.getIsFixedPC();
            ctrl.getReductionOptions();
            ctrl.getModelTypeScreenOptions();
            //ctrl.getHasMultipleModelTypeScreenOptions();
            ctrl.getProfitCalculationTypeOptions();
            ctrl.getSeriesOptions();
            ctrl.getUnitOptions();
            ctrl.getIncotermsOptions();
            ctrl.getIncotermsDestinationOptions();
            ctrl.getDelivConditionOptions();
            ctrl.getQuantityUnitOptions();
            ctrl.profitCalculationCopy();
            ctrl.goToCustomerInformation();
            ctrl.goToEndUserInformation();
            ctrl.goToTermsAndConditions();
            ctrl.goToEditSpecifications();
            ctrl.profitCalculationCopyAndBranch();
            ctrl.getCandidateUnitBody();
            ctrl.delivConditionAttachment();

            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();

            ctrl.shipmentContactAttachment();
            ctrl.contractAccountInputCopy();
            ctrl.requestApproval();
            ctrl.requestApprovalSVCAssistant1();
            ctrl.requestApprovalSVCAssistant2();
            ctrl.requestApprovalSVCDirector();
            ctrl.recallApprovalRequest();
            ctrl.approveRequest();
            ctrl.rejectRequest();
            ctrl.escalateRequestDirector();
            ctrl.escalateRequestMD();
            ctrl.dummyAction();

            ctrl.ajaxSaveAction();
            ctrl.deleteMultiRows();
            ctrl.isReadOnly = true;
            ctrl.saveAction();

            ctrl.doSaveWithPrintDatePart1();
            //ctrl.doSaveWithPrintDatePart2();
            

            ctrl.getPreviewUrl();
            ctrl.getPrintUrl();
            ctrl.refreshListRate();
            ctrl.refreshCurrent2SP();
            ctrl.saveCurrent2SPInFullSP();
            
            ctrl.getListRecordTypeID();
            ctrl.getQuotationTypeOptions();
            ctrl.getRedirectExportCsvURL();

            ctrl.deleteCurrent2SPInFullSP();

            Test.stopTest();
        }
    }
}