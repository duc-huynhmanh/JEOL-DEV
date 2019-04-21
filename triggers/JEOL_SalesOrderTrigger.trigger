trigger JEOL_SalesOrderTrigger on SalesOrder__c (after insert, after update) {
    List<SalesOrder__c> salesOrders = Trigger.new;
    Map<Id, SalesOrder__c> oldSalesOrders = Trigger.oldMap;
    if (oldSalesOrders == null) {
        oldSalesOrders = new Map<Id, SalesOrder__c>();
    }
    
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        List<SalesOrder__c> changeAccountTargets = new List<SalesOrder__c>();
        List<SalesOrder__c> changeShareTargets = new List<SalesOrder__c>();
        for (SalesOrder__c rec: salesOrders) {
            SalesOrder__c oldRec = null;
            if (oldSalesOrders.containsKey(rec.id)) {
                oldRec = oldSalesOrders.get(rec.id);
            }
            if (oldRec == null || (rec.ShipmentAccount__c != oldRec.ShipmentAccount__c || rec.seikyusakiAccount__c != oldRec.seikyusakiAccount__c || rec.SalesAccount__c != oldRec.SalesAccount__c)) {
                changeAccountTargets.add(rec);
            }
            if (oldRec == null || rec.Series__c != null) {
                changeShareTargets.add(rec);
            }
        }
        if (changeAccountTargets.size() > 0) {
            JEOL_ObjectTriggerHadler.salesOrder_AccountReferenceToSalesResult(changeAccountTargets);
        }
        if (changeShareTargets.size() > 0) {
            JEOL_AccessTriggerHandler.createSalesOrderShares(changeShareTargets);
        }
    }
    
}