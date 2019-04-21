trigger JEOL_AsiaProjectMasterTriger on AsiaProjectMasterDetail__c (before insert) {
    
    //Obsolete Trigger - To Delete
    if (Trigger.isBefore && Trigger.isInsert) {
        for (AsiaProjectMasterDetail__c data : Trigger.new) {
            if (data.Category__c == 'C') {
                data.QuantityUpdatedDatetime__c = Datetime.Now();
            }
        }    
    }

}