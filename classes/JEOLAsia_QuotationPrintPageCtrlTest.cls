@IsTest
private class JEOLAsia_QuotationPrintPageCtrlTest {
    
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
    private static final String QUOTATION_COMPANY_ASIA = 'ASIA';
    
    private static testMethod void test01() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(Company__c = QUOTATION_COMPANY_ASIA);
            insert asiaProfitCalcObj;
            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
            insert conditionObj;
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            String url = ctrl.userSignURL;
            Test.stopTest();
        }
    }
    private static testMethod void test02() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            
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
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            
            
            Test.stopTest();
        }
    }
    
    private static testMethod void test03() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(Company__c = 'ASIA', QuoteValidityPeriodDays__c = 10, PaymentConditionSection__c = 'test', PrintQuantityUnit__c = true, PrintUnitPrice__c = true, PrintNotDetailAmounts__c = true,
                                                                                      TitleRow1__c = 'test', ModelTypeScreen__c = 't');
            insert asiaProfitCalcObj;
            
            
            
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'A', SortNo__c = 1, Depth__c = 1);
            insert asiaProfitCalcDetailObj;
            
            AsiaProductItemSpecification__c asiaProdItemSpecObj = new AsiaProductItemSpecification__c(Product_Img__c = '<img alt="User-added image" src="https://test.com" style="height: 236px; width: 500px;"></img>', ModelType__c = 't');
            insert asiaProdItemSpecObj;
            
            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
            insert conditionObj;
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            
            
            Test.stopTest();
        }
    }
    
    private static testMethod void test04() {
        
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            
            testUser.Phone = '123456789';
            testUser.Email = 'test@mail.com';
            update testUser;
            
            Contact contact = new Contact(Email = 'test@mail.com', LastName = 'test');
            insert contact;
            
            AsiaTermsAndConditons__c asiaTermAndCondObj = new AsiaTermsAndConditons__c(Company__c = 'ASIA', SortNo__c = 1, TermsAndConditions__c = 'Rich Text Area for Term and Condition Testing');
            insert asiaTermAndCondObj;
            RecordType recordType = [select Id, DeveloperName from RecordType where DeveloperName = 'SVC' limit 1];
            
            
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, ShipmentContact_dummyField__c = contact.Id, ContractContact_dummyField__c = contact.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
                                                                                      OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
                                                                                      TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
                                                                                      CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
                                                                                      QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
                                                                                      Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
                                                                                      DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test', RecordType = recordType, TitleRow1__c = 'test', TitleRow2__c = 'test');
            insert asiaProfitCalcObj;
            
            
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'A', Body__c = '品名B', ModelType__c = 'test', Name = 'test', SortNo__c = 1, Depth__c = 0, SalesPrice__c = 1000, SalesPriceCalculated__c = 1000, Quantity__c = 1000, QuantityUnit__c = 'kg', SalesPriceSalesCur2SP__c = 1000);
            insert asiaProfitCalcDetailObj;
            
            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
            insert conditionObj;
            
            List<AsiaQuotationDescription__c>asiaQuotationDescList = new List<AsiaQuotationDescription__c>();
            asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailObj.Id, CurrencyIsoCode = 'JPY'));
            asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailObj.Id, CurrencyIsoCode = 'JPY', ProductSpecification__c = 'test <br>this is  one'));
            insert asiaQuotationDescList;
            
            AsiaQuotationTermsConditions__c asiaQuoTermConditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', Warranty__c = 'The instrument(s) supplied in accordance with the specifications mentioned in the catalogues submitted shall be warranted to be free from defects under ordinary use for a period of twelve (12) months from the date of completion of the installation or eighteen (18) months from the date of Bill of Lading (B/L), whichever occurs first. However, JEOL shall not be responsible for any damages to the instrument(s) caused by faculty operation or rough use, power and water failures, fire, flood, earthquake or any Force Majeure.', 
                                                                                                          Installation__c = 'Installation will be done by JEOL or JEOL authorized engineer', Packing__c = 'Wooden case of export standard.', Training__c = 'On‐site brief training is included, for all systems.',
                                                                                                          Export__c = 'Export is subject to receipt of an export license from the proper governmental authorities. Thus, JEOL reserves the right to be free from the contract without penalty should the license not be granted.', Validity__c = 'This quotation stands valid for 90 days.', ProfitCalculation__c = asiaProfitCalcObj.Id,
                                                                                                          Remarks__c = '* Please indicate JEOL ASIA Quotation No. on your purchase order.* This PM parts list based on estimation to prepare advance. Actual billing will be exactly followed whatever used by service report.* If any parts were found defective or need replacement during performance not in above list, those will be charged separately with this quotation.We look forward to your valued order soon. Thank You.', 
                                                                                                          Manufacturer__c = 'JEOL Ltd.', BankDetail__c  = 'The Bank of Tokyo Mitsubishi UFJ Limited.9, Raffles Place 01-01, Republic Plaza, Singapore 048619Name of Account Owner JEOL ASIA PTE Ltd.________ Account Number ________Swift Code BOTKSGSX');
            insert asiaQuoTermConditionObj;
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void test05() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(Company__c = 'ASIA', QuoteValidityPeriodDays__c = 10, PaymentConditionSection__c = '', PrintQuantityUnit__c = false, PrintUnitPrice__c = true, PrintNotDetailAmounts__c = false,
                                                                                      TitleRow1__c = 'test', TitleRow2__c = 'test', TitleRow3__c = 'test', ModelTypeScreen__c = 't');
            insert asiaProfitCalcObj;
            
            
            
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'A', SortNo__c = 1, Depth__c = 1);
            insert asiaProfitCalcDetailObj;
            
            AsiaProductItemSpecification__c asiaProdItemSpecObj = new AsiaProductItemSpecification__c(Product_Img__c = '<img alt="User-added image" src="https://test.com" style="height: 236px; width: 500px;"></img>', ModelType__c = 't');
            insert asiaProdItemSpecObj;
            
            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
            insert conditionObj;
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.termsAndConditions = new AsiaTermsAndConditons__c(); 
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            
            
            Test.stopTest();
        }
    }
    
    private static testMethod void test06() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            
            Test.stopTest();
        }
    }

    private static testMethod void test08() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(Company__c = QUOTATION_COMPANY_ASIA,QuoteExpirationDate__c = Date.today());
            insert asiaProfitCalcObj;
            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
            insert conditionObj;
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            String url = ctrl.userSignURL;
            Test.stopTest();
        }
    }

    private static testMethod void test09() {
        
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            
            testUser.Phone = '123456789';
            testUser.Email = 'test@mail.com';
            update testUser;
            
            Contact contact = new Contact(Email = 'test@mail.com', LastName = 'test');
            insert contact;
            
            AsiaTermsAndConditons__c asiaTermAndCondObj = new AsiaTermsAndConditons__c(Company__c = 'ASIA', SortNo__c = 1, TermsAndConditions__c = 'Rich Text Area for Term and Condition Testing');
            insert asiaTermAndCondObj;
            RecordType recordType = [select Id, DeveloperName from RecordType where DeveloperName = 'SVC' limit 1];
            
            
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, ShipmentContact_dummyField__c = contact.Id, ContractContact_dummyField__c = contact.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
                                                                                      OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
                                                                                      TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
                                                                                      CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
                                                                                      QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
                                                                                      Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
                                                                                      DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test', RecordType = recordType, TitleRow1__c = 'test', TitleRow2__c = 'test',
                                                                                      TitleRow3__c = 'test', TitleRow4__c = 'test');
            insert asiaProfitCalcObj;
            
            
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'A', Body__c = '品名B', ModelType__c = 'test', Name = 'test', SortNo__c = 1, Depth__c = 0, SalesPrice__c = 1000, SalesPriceCalculated__c = 1000, Quantity__c = 1000, QuantityUnit__c = 'kg', SalesPriceSalesCur2SP__c = 1000);
            insert asiaProfitCalcDetailObj;
            
            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
            insert conditionObj;
            
            List<AsiaQuotationDescription__c>asiaQuotationDescList = new List<AsiaQuotationDescription__c>();
            asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailObj.Id, CurrencyIsoCode = 'JPY'));
            asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailObj.Id, CurrencyIsoCode = 'JPY', ProductSpecification__c = 'test <br>this is  one'));
            insert asiaQuotationDescList;
            
            AsiaQuotationTermsConditions__c asiaQuoTermConditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', Warranty__c = 'The instrument(s) supplied in accordance with the specifications mentioned in the catalogues submitted shall be warranted to be free from defects under ordinary use for a period of twelve (12) months from the date of completion of the installation or eighteen (18) months from the date of Bill of Lading (B/L), whichever occurs first. However, JEOL shall not be responsible for any damages to the instrument(s) caused by faculty operation or rough use, power and water failures, fire, flood, earthquake or any Force Majeure.', 
                                                                                                          Installation__c = 'Installation will be done by JEOL or JEOL authorized engineer', Packing__c = 'Wooden case of export standard.', Training__c = 'On‐site brief training is included, for all systems.',
                                                                                                          Export__c = 'Export is subject to receipt of an export license from the proper governmental authorities. Thus, JEOL reserves the right to be free from the contract without penalty should the license not be granted.', Validity__c = 'This quotation stands valid for 90 days.', ProfitCalculation__c = asiaProfitCalcObj.Id,
                                                                                                          Remarks__c = '* Please indicate JEOL ASIA Quotation No. on your purchase order.* This PM parts list based on estimation to prepare advance. Actual billing will be exactly followed whatever used by service report.* If any parts were found defective or need replacement during performance not in above list, those will be charged separately with this quotation.We look forward to your valued order soon. Thank You.', 
                                                                                                          Manufacturer__c = 'JEOL Ltd.', BankDetail__c  = 'The Bank of Tokyo Mitsubishi UFJ Limited.9, Raffles Place 01-01, Republic Plaza, Singapore 048619Name of Account Owner JEOL ASIA PTE Ltd.________ Account Number ________Swift Code BOTKSGSX');
            insert asiaQuoTermConditionObj;
            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            
            Test.stopTest();
        }
    }

    private static testMethod void test10() {
        
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData(testUser.Id);
            
            testUser.Phone = '123456789';
            testUser.Email = 'test@mail.com';
            testUser.UserSign__c = '<img alt="User-added image" src="https://c.cs31.content.force.com/servlet/rtaImage?eid=00510000003siEt&amp;feoid=00Np0000000pQS3&amp;refid=0EMp00000008hnj"></img>';
            update testUser;
            
            Contact contact = new Contact(Email = 'test@mail.com', LastName = 'test');
            insert contact;
            
            AsiaTermsAndConditons__c asiaTermAndCondObj = new AsiaTermsAndConditons__c(Company__c = 'ASIA', SortNo__c = 1, TermsAndConditions__c = 'Rich Text Area for Term and Condition Testing');
            insert asiaTermAndCondObj;
            RecordType record = [select Id, DeveloperName from RecordType where DeveloperName = 'SVC' limit 1];
            
            List<AsiaProfitCalculationDetail__c> asiaProfitCalculationDetailList = new List<AsiaProfitCalculationDetail__c>();
            List<AsiaQuotationDescription__c>asiaQuotationDescList = new List<AsiaQuotationDescription__c>();
            List<AsiaQuotationTermsConditions__c> asiaQuotationTermsConditionsList = new List<AsiaQuotationTermsConditions__c>();
            AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, ShipmentContact_dummyField__c = contact.Id, ContractContact_dummyField__c = contact.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
                                                                                      OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
                                                                                      TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
                                                                                      CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
                                                                                      QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
                                                                                      Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
                                                                                      DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test', TitleRow1__c = 'test', TitleRow2__c = 'test', TitleRow3__c = 'test', TitleRow4__c = 'test', TitleRow5__c = 'test',
                                                                                      RecordTypeId = record.Id);
            insert asiaProfitCalcObj;

            for(Integer i = 0; i<50; i++)
            {
            AsiaProfitCalculationDetail__c asiaProfitCalcDetailObj = new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'A', Body__c = '品名B', ModelType__c = 'test \r\n test \r \'\" test \r\n test \n test \r\n test', Name = 'test', SortNo__c = 1, Depth__c = 0, SalesPrice__c = 1000, SalesPriceCalculated__c = 1000, Quantity__c = 1000, QuantityUnit__c = 'kg', SalesPriceSalesCur2SP__c = 1000);
            asiaProfitCalculationDetailList.add(asiaProfitCalcDetailObj);
            }
            insert asiaProfitCalculationDetailList;
            
            for(Integer i = 0; i<50; i++)
            {
            asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalculationDetailList[i].Id, CurrencyIsoCode = 'JPY', ProductSpecification__c = 'test <br>this is  one'));
            
            
            AsiaQuotationTermsConditions__c asiaQuoTermConditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', Warranty__c = 'The instrument(s) supplied in accordance with the specifications mentioned in the catalogues submitted shall be warranted to be free from defects under ordinary use for a period of twelve (12) months from the date of completion of the installation or eighteen (18) months from the date of Bill of Lading (B/L), whichever occurs first. However, JEOL shall not be responsible for any damages to the instrument(s) caused by faculty operation or rough use, power and water failures, fire, flood, earthquake or any Force Majeure.', 
                                                                                                          Installation__c = 'Installation will be done by JEOL or JEOL authorized engineer', Packing__c = 'Wooden case of export standard.', Training__c = 'On‐site brief training is included, for all systems.',
                                                                                                          Export__c = 'Export is subject to receipt of an export license from the proper governmental authorities. Thus, JEOL reserves the right to be free from the contract without penalty should the license not be granted.', Validity__c = 'This quotation stands valid for 90 days.', ProfitCalculation__c = asiaProfitCalcObj.Id,
                                                                                                          Remarks__c = '* Please indicate JEOL ASIA Quotation No. on your purchase order.* This PM parts list based on estimation to prepare advance. Actual billing will be exactly followed whatever used by service report.* If any parts were found defective or need replacement during performance not in above list, those will be charged separately with this quotation.We look forward to your valued order soon. Thank You.', 
                                                                                                          Manufacturer__c = 'JEOL Ltd.', BankDetail__c  = 'The Bank of Tokyo Mitsubishi UFJ Limited.9, Raffles Place 01-01, Republic Plaza, Singapore 048619Name of Account Owner JEOL ASIA PTE Ltd.________ Account Number ________Swift Code BOTKSGSX');
            asiaQuotationTermsConditionsList.add(asiaQuoTermConditionObj);

            }
            
            insert asiaQuotationDescList;
            insert asiaQuotationTermsConditionsList;

            
            PageReference pageRef = Page.JEOLAsia_ProjectMaster;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', String.valueOf(asiaProfitCalcObj.Id));
            
            JEOLAsia_QuotationPrintPageCtrl ctrl = new JEOLAsia_QuotationPrintPageCtrl();
            ctrl.getPaymentTermsLabel();
            ctrl.getCospanCol1();
            ctrl.getCospanCol2();
            ctrl.getCospanCol3();
            ctrl.getCospanCol4();
            ctrl.getContractName();
            ctrl.getShipmentNameDispFlg();
            ctrl.getShipmentName();
            
            Test.stopTest();
        }
    }

    private static void createAsiaCompanyData(Id userId){
        CompanyName__c company=new CompanyName__c();
        company.Name=QUOTATION_COMPANY_ASIA;
        company.CompanyName__c=QUOTATION_COMPANY_ASIA;
        company.Company__c=QUOTATION_COMPANY_ASIA;
        company.CompanyLabel__c=QUOTATION_COMPANY_ASIA;
        company.OrgAddress__c=QUOTATION_COMPANY_ASIA;
        company.OrgPhone__c=QUOTATION_COMPANY_ASIA;
        company.QuotationPrintSignUserID__c=userId;
        insert company;
    }
}