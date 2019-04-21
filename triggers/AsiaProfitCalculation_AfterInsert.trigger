trigger AsiaProfitCalculation_AfterInsert on AsiaProfitCalculation__c (after insert) {
    
    List<AsiaQuotationTermsConditions__c> lsTerms = new List<AsiaQuotationTermsConditions__c>();
    
    for (AsiaProfitCalculation__c mod : Trigger.New){
        
        AsiaQuotationTermsConditions__c newTerm = new AsiaQuotationTermsConditions__c(ProfitCalculation__c = mod.id);

        for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
            if (companyCustSettings.Company__c == mod.Company__c) {
                newTerm.BankDetail__c = companyCustSettings.BankDetail__c;
            }
        }

        lsTerms.add(newTerm);        
    }
    
    insert lsTerms;
    
}