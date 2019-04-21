@IsTest
private class JEOLAsia_QuotationSpecificationCtrlTest {
	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
	private static testMethod void test01() {
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

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;
            
            pageRef.getParameters().put('id', String.valueOf(asiaQuotationDescList[1].Id));
            pageRef.getParameters().put('pcid', String.valueOf(testUser.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

	        ctrl.getCategoryASize();
	        ctrl.getCategoryBSize();
	        ctrl.getCategoryGSize();
	        ctrl.saveActionxxe();

			Test.stopTest();
		}
	}

	private static testMethod void test02() {
		System.runAs (testUser) {
			Test.startTest();

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;
            
            pageRef.getParameters().put('retURL', String.valueOf(testUser.Id));
            pageRef.getParameters().put('save_new', String.valueOf(testUser.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

			Test.stopTest();
		}
	}

	private static testMethod void test03() {
		System.runAs (testUser) {
			Test.startTest();

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

			Test.stopTest();
		}
	}

	private static testMethod void test04() {
		System.runAs (testUser) {
			Test.startTest();

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;
            
            pageRef.getParameters().put('id', '');
            pageRef.getParameters().put('pcid', String.valueOf(testUser.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

			Test.stopTest();
		}
	}

	private static testMethod void test05() {
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
	            insert asiaProfitCalcDetailList;

	            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	            insert conditionObj;


			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;

            pageRef.getParameters().put('pcid', String.valueOf(testUser.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

	        ctrl.getCategoryASize();
	        ctrl.getCategoryBSize();
	        ctrl.getCategoryGSize();
	        ctrl.saveActionxxe();

			Test.stopTest();
		}
	}

	private static testMethod void test06() {
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
	            asiaProfitCalcDetailList.add(new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'B', Body__c = '品名B', Name = 'test', SortNo__c = 1, Depth__c = 0));
	            insert asiaProfitCalcDetailList;

	            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	            insert conditionObj;

	            List<AsiaQuotationDescription__c>asiaQuotationDescList = new List<AsiaQuotationDescription__c>();
	            asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailList[0].Id, CurrencyIsoCode = 'JPY'));
	            asiaQuotationDescList.add(new AsiaQuotationDescription__c(ProfitCalculationDetail__c = asiaProfitCalcDetailList[0].Id, CurrencyIsoCode = 'JPY', ProductSpecification__c = 'test <br/><br>This is Testing. \r\n Testing again. \n <br/><table><tr><td>testing</td></tr><tr><td>testing</td></tr></table><br>Testing<br/><br/><br>This is Testing. \r\n Testing again. \n <br/>'));
	            insert asiaQuotationDescList;

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;
            
            pageRef.getParameters().put('id', String.valueOf(asiaQuotationDescList[1].Id));
            pageRef.getParameters().put('pcid', String.valueOf(testUser.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

	        ctrl.getCategoryASize();
	        ctrl.getCategoryBSize();
	        ctrl.getCategoryGSize();
	        ctrl.saveActionxxe();

			Test.stopTest();
		}
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
	            asiaProfitCalcDetailList.add(new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'B', Body__c = '品名B', Name = 'test', SortNo__c = 1, Depth__c = 0));
	            insert asiaProfitCalcDetailList;

	            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	            insert conditionObj;


			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;            
            pageRef.getParameters().put('pcid', String.valueOf(testUser.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

	        ctrl.getCategoryASize();
	        ctrl.getCategoryBSize();
	        ctrl.getCategoryGSize();
	        ctrl.saveActionxxe();

			Test.stopTest();
		}
	}

	private static testMethod void test08() {
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
	            asiaProfitCalcDetailList.add(new AsiaProfitCalculationDetail__c(Parent__c = asiaProfitCalcObj.id, Category__c = 'G', Body__c = '品名B', Name = 'test', SortNo__c = 1, Depth__c = 0));
	            insert asiaProfitCalcDetailList;

	            AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	            insert conditionObj;


			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationSpecificationPage;
            pageRef.getParameters().put('pcid', String.valueOf(testUser.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationSpecificationCtrl ctrl = new JEOLAsia_QuotationSpecificationCtrl(sc);

	        ctrl.getCategoryASize();
	        ctrl.getCategoryBSize();
	        ctrl.getCategoryGSize();
	        ctrl.saveActionxxe();

			Test.stopTest();
		}
	}
}