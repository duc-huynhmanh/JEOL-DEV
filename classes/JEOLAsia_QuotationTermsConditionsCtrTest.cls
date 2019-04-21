@IsTest
private class JEOLAsia_QuotationTermsConditionsCtrTest {
	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
	private static testMethod void test01() {
		System.runAs (testUser) {
			Test.startTest();

			AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
	        insert asiaProfitCalcObj;

			AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	        insert conditionObj;

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;            

            pageRef.getParameters().put('pcid', String.valueOf(asiaProfitCalcObj.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);
	        ctrl.saveAction();
	        ctrl.getValidityPeriod();

			Test.stopTest();
		}
	}

	private static testMethod void test02() {
		System.runAs (testUser) {
			Test.startTest();

			AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteValidityPeriodDays__c = 10, ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
	        insert asiaProfitCalcObj;

			AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	        insert conditionObj;

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;
            

            pageRef.getParameters().put('pcid', 'test');
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);

			Test.stopTest();
		}
	}

	private static testMethod void test03() {
		System.runAs (testUser) {
			Test.startTest();

			AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteValidityPeriod__c = 10, ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
	        insert asiaProfitCalcObj;

			AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	        insert conditionObj;

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;
            
            pageRef.getParameters().put('id', String.valueOf(conditionObj.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);

			Test.stopTest();
		}
	}

	private static testMethod void test04() {
		System.runAs (testUser) {
			Test.startTest();

			AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
	        insert asiaProfitCalcObj;

			AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	        insert conditionObj;

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;
            
            pageRef.getParameters().put('id', 'test');
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);

			Test.stopTest();
		}
	}

	private static testMethod void test05() {
		System.runAs (testUser) {
			Test.startTest();

			AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteValidityPeriodDays__c = 10, ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
	        insert asiaProfitCalcObj;

			AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	        insert conditionObj;

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;            

            pageRef.getParameters().put('pcid', String.valueOf(asiaProfitCalcObj.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);
	        ctrl.saveAction();
	        ctrl.getValidityPeriod();

			Test.stopTest();
		}
	}

	private static testMethod void test06() {
		System.runAs (testUser) {
			Test.startTest();

			AsiaProfitCalculation__c asiaProfitCalcObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteValidityPeriod__c = 10, ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
	        insert asiaProfitCalcObj;

			AsiaQuotationTermsConditions__c conditionObj = new AsiaQuotationTermsConditions__c(CurrencyIsoCode = 'JPY', Price__c = 'This quotation is based on DDP customer', ProfitCalculation__c = asiaProfitCalcObj.id);
	        insert conditionObj;

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;            

            pageRef.getParameters().put('pcid', String.valueOf(asiaProfitCalcObj.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);
	        ctrl.saveAction();
	        ctrl.getValidityPeriod();

			Test.stopTest();
		}
	}

	private static testMethod void test07() {
		System.runAs (testUser) {
			Test.startTest();

			AsiaProfitCalculation__c AsiaProfitCalculationObj = new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteExpirationDate__c = Date.today(), ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test');
	        insert AsiaProfitCalculationObj;


			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;            

            pageRef.getParameters().put('pcid', String.valueOf(AsiaProfitCalculationObj.Id));
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);
	        ctrl.saveAction();
	        ctrl.getValidityPeriod();

			Test.stopTest();
		}
	}

	private static testMethod void test08() {
		System.runAs (testUser) {
			Test.startTest();

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;
            pageRef.getParameters().put('id', Null);
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);

			Test.stopTest();
		}
	}

	private static testMethod void test09() {
		System.runAs (testUser) {
			Test.startTest();

			ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
			PageReference pageRef = Page.JEOLAsia_QuotationTermsConditionsPage;
            Test.setCurrentPage(pageRef);
	        JEOLAsia_QuotationTermsConditionsCtrl ctrl = new JEOLAsia_QuotationTermsConditionsCtrl(sc);

			Test.stopTest();
		}
	}
}