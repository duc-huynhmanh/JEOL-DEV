trigger QuotationInformation_BeforeInsert on QuotationInformation__c (before insert, before update) {

    For (QuotationInformation__c quot : Trigger.new)
    {
        if (quot.UpdateType__c != null && quot.UpdateType__c == 1) {

            if (quot.AcceptanceDateTime__c != null) {
                quot.AcceptanceDate__c = quot.AcceptanceDateTime__c.date();
            } else {
                quot.AcceptanceDate__c = null;
            }

            if (quot.QuotationRequestedDateTime__c != null) {
                quot.QuotationRequestedDate__c = quot.QuotationRequestedDateTime__c.date();
            } else {
                quot.QuotationRequestedDate__c = null;
            }

            if (quot.QuoteExpirationDateTime__c != null) {
                quot.QuoteExpirationDate__c = quot.QuoteExpirationDateTime__c.date();
            } else {
                quot.QuoteExpirationDate__c = null;
            }    
    
            if (quot.RegisterDateTime__c != null) {
                quot.RegisterDate__c = quot.RegisterDateTime__c.date();
            } else {
                quot.RegisterDate__c = null;
            }

            if (quot.DeliveryDeadlineTime__c != null) {
                quot.DeliveryDeadline__c = quot.DeliveryDeadlineTime__c.date();
            } else {
                quot.DeliveryDeadline__c = null;
            }
            
            if (quot.IssueDateTime__c != null) {
                quot.IssueDate__c = quot.IssueDateTime__c.date();
            } else {
                quot.IssueDate__c = null;
            }

            if (quot.KeiyakuStartDateTime__c != null) {
                quot.KeiyakuStartDate__c = quot.KeiyakuStartDateTime__c.date();
            } else {
                quot.KeiyakuStartDate__c = null;
            }

            if (quot.KeiyakuEndDateTime__c != null) {
                quot.KeiyakuEndDate__c = quot.KeiyakuEndDateTime__c.date();
            } else {
                quot.KeiyakuEndDate__c = null;
            }
        }
        quot.AcceptanceDateTime__c = null;
        quot.QuotationRequestedDateTime__c = null;
        quot.QuoteExpirationDateTime__c = null;
        quot.RegisterDateTime__c = null;
        quot.DeliveryDeadlineTime__c = null;
        quot.IssueDateTime__c = null;
        quot.KeiyakuStartDateTime__c = null;
        quot.KeiyakuEndDateTime__c = null;

        quot.UpdateType__c = null;
    }

}