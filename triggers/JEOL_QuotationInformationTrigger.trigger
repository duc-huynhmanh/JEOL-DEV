trigger JEOL_QuotationInformationTrigger on QuotationInformation__c (After Insert, After Update) {

    List<id> lsQuotation = new List<id>(); // List of quotations which have to be shared

    if (Trigger.isInsert) {
        // The user should be added if there is some SalesArea specified
        For (QuotationInformation__c quot : Trigger.new)
        {
            if (quot.SalesAreaCode__c != null)
            {
                lsQuotation.add(quot.id);
            }
        }
    } 

    if (Trigger.isUpdate) { 
        // The quotation should be added if the SalesAreaCode has changed
        For (QuotationInformation__c quot : Trigger.new)
        {
            if (quot.SalesAreaCode__c != Trigger.oldMap.get(quot.Id).SalesAreaCode__c) { 
                lsQuotation.add(quot.id);
            }
        }
    }
    
    if (lsQuotation != null && lsQuotation.size() > 0)
    {
        // Delete the already shared
        if (Trigger.isUpdate) {
            List<QuotationInformation__share> lsShar = [SELECT id FROM QuotationInformation__share WHERE RowCause = 'Geographic__c' and ParentId in :lsQuotation];
            delete lsShar;
        }

        // Get the list of the public groups
        Map<String, id> mpGroups = new Map<String, id>();
        For(Group grp : [Select Id, Name, DeveloperName, Type From Group WHERE Type = 'Regular' and DeveloperName LIKE 'SalesArea_%'])
        {
            mpGroups.put(grp.DeveloperName.right(3), grp.id);
        }

        // Get the list of Group Member to be added
        List<QuotationInformation__share> lsToShare = new List<QuotationInformation__share>();
        For (QuotationInformation__c quot : Trigger.new)
        {
            if (quot.SalesAreaCode__c != null && quot.SalesAreaCode__c.length() > 0) { 
                If (mpGroups.containsKey(quot.SalesAreaCode__c)) {
                    lsToShare.add(new QuotationInformation__share(UserOrGroupId = mpGroups.get(quot.SalesAreaCode__c), ParentId = quot.id, RowCause = 'Geographic__c', AccessLevel = 'Edit'));
                   }
            }
        }
        
        If (lsToShare != null && lsToShare.size() > 0) {
            insert lsToShare;
        }
    }

}