trigger JEOL_SalesPipelineTrigger on SalesPipeline__c (After Insert, After Update) {

    List<id> lsSalesPipeline = new List<id>(); // List of Sales Pipeline which have to be shared

    if (Trigger.isInsert) {
        // The Sales Pipeline should be added if there is some Region Name specified
        For (SalesPipeline__c pip : Trigger.new)
        {
            if (pip.RegionName__c != null)
            {
                lsSalesPipeline.add(pip.id);
            }
        }
    } 

    if (Trigger.isUpdate) { 
        // The Sales Pipeline should be added if the Region Name has changed
        For (SalesPipeline__c pip : Trigger.new)
        {
            if (pip.RegionName__c != Trigger.oldMap.get(pip.Id).RegionName__c) { 
                lsSalesPipeline.add(pip.id);
            }
        }
    }
    
    if (lsSalesPipeline != null && lsSalesPipeline.size() > 0)
    {
        // Delete the already shared
        if (Trigger.isUpdate) {
            List<SalesPipeline__share> lsShar = [SELECT id FROM SalesPipeline__share WHERE RowCause = 'Geographic__c' and ParentId in :lsSalesPipeline];
            delete lsShar;
        }

        // Get the list of the public groups
        Map<String, id> mpGroups = new Map<String, id>();
        For(Group grp : [Select Id, Name, DeveloperName, Type From Group WHERE Type = 'Regular' and DeveloperName LIKE 'SalesArea_%'])
        {
            mpGroups.put(grp.DeveloperName.right(3), grp.id);
        }

        // Get the list of Group Member to be added
        List<SalesPipeline__share> lsToShare = new List<SalesPipeline__share>();
        For (SalesPipeline__c pip : Trigger.new)
        {
            if (pip.RegionName__c != null && pip.RegionName__c.length() > 0) { 
                If (mpGroups.containsKey(pip.RegionName__c)) {
                    lsToShare.add(new SalesPipeline__share(UserOrGroupId = mpGroups.get(pip.RegionName__c), ParentId = pip.id, RowCause = 'Geographic__c', AccessLevel = 'Edit'));
                   }
            }
        }
        
        If (lsToShare != null && lsToShare.size() > 0) {
            insert lsToShare;
        }
    }

}