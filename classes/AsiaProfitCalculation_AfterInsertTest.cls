@IsTest
private class AsiaProfitCalculation_AfterInsertTest {

	private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
	private static testMethod void test01() {
		System.runAs (testUser) {
			Test.startTest();

			CompanyName__c company = new CompanyName__c(Name = 'ASIA', CompanyName__c = 'ASIA',  Company__c = 'ASIA', CompanyLabel__c = 'ASIA');
        	insert company;

			List<AsiaProfitCalculation__c> asiaProfitCalculationList = new List<AsiaProfitCalculation__c>();

			asiaProfitCalculationList.add(new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteValidityPeriodDays__c = 10, ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test'));
	        asiaProfitCalculationList.add(new AsiaProfitCalculation__c(SalesAssistant__c = testUser.Id, SalesPerson__c = testUser.Id, Company__c = 'ASIA', PaymentConditionTextarea__c = 'Testing in Payment Condition Textarea.', PrintProformaInvoice__c = true, 
	            											OutputConsumptionTaxAmount__c = true, ConsumptionTaxAmount__c = 1000, OutputTotalTaxAmount__c = true, TotalTaxAmount__c = 1000, OutputTotalAmount__c = true, 
	            											TotalAmount__c = 1000, CustomReductionAmount3__c = 1000, OutputSubtotalReduction2__c = true, SubtotalReductionName2__c = 'test', SubtotalReductionAmount2__c = 1000,
	            											CustomReductionAmount2__c = 1000, OutputSubtotalReduction1__c = true, SubtotalReductionName1__c = 'test', SubtotalReductionAmount1__c = 1000, CustomReductionAmount1__c = 1000,
	            											QuoteValidityPeriodDays__c = 10, ContractName1__c = 'test', ContractName2__c = 'test', ShipmentName1__c = 'test', ShipmentName2__c = 'test',
	            											Print2SPDetail__c = true, ContractAddress__c = 'test', PrintQuotationFirstPage__c = false, ContractEmail__c = 'test@mail.com', DeliveryCondition3__c = 'test',
	            											DeliveryDeadline__c = Date.today(), DeliveryDate_Arbitrarily__c = 'test', DeliveryDate_ArbitrarilyTitle__c = 'test'));
	        insert asiaProfitCalculationList;

			Test.stopTest();
		}
	}
}