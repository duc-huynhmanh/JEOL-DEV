trigger AsiaProfitCalculation_BeforeDelete on AsiaProfitCalculation__c (Before delete) {

    private static final String APPROVAL_STATUS_PENDING = '1';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED = '2';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 = '21';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 = '22';
    private static final String APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR = '23';
    private static final String APPROVAL_STATUS_APPROVED = '3';
    private static final String APPROVAL_STATUS_REJECTED = '4';
    private static final String APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR = '5';
    private static final String APPROVAL_STATUS_APPROVAL_ESCALATED_MD = '51';
    
    // Forbid the deletion if an approval has been requested
    for (AsiaProfitCalculation__c qt : Trigger.Old){
        if (qt.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED || 
            qt.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_1 ||
            qt.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_ASSISTANT_2 ||
            qt.Status__c == APPROVAL_STATUS_APPROVAL_REQUESTED_SVC_DIRECTOR ||
            qt.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_DIRECTOR ||
            qt.Status__c == APPROVAL_STATUS_APPROVAL_ESCALATED_MD ||
            qt.Status__c == APPROVAL_STATUS_APPROVED) {            
            qt.adderror('You can not delete this quotation.');
        }
    }    
    
}