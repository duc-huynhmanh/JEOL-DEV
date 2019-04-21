public with sharing class JEOL_AccessTriggerHandler {
    
    public static void createServiceOrderShares(List<ServiceOrder__c> recs) {
        Map<String, String> idAndSeriesMap = new Map<String, String>();
        List<ServiceOrder__c> shareUseRecs = [SELECT id, Customer__r.SeriesPI__c FROM ServiceOrder__c WHERE id IN: recs];
        for (ServiceOrder__c rec: shareUseRecs) {
            idAndSeriesMap.put(rec.id, rec.Customer__r.SeriesPI__c);
        }
        JEOLUtil.setSameRoleSharing(ServiceOrder__c.SObjectType.getDescribe().getName(), idAndSeriesMap);
    }
    
    public static void createOrderPlanShares(List<OrderPlan__c> recs) {
        Map<String, String> idAndSeriesMap = new Map<String, String>();
        List<OrderPlan__c> shareUseRecs = [SELECT id, Series__c FROM OrderPlan__c WHERE id IN: recs];
        for (OrderPlan__c rec: shareUseRecs) {
            idAndSeriesMap.put(rec.id, rec.Series__c);
        }
        JEOLUtil.setSameRoleSharing(OrderPlan__c.SObjectType.getDescribe().getName(), idAndSeriesMap);
    }
    
    public static void createSalesResultShares(List<SalesResult__c> recs) {
        Map<String, String> idAndSeriesMap = new Map<String, String>();
        for (SalesResult__c rec: recs) {
            idAndSeriesMap.put(rec.id, rec.keiretsu__c);
        }
        JEOLUtil.setSameRoleSharing(SalesResult__c.SObjectType.getDescribe().getName(), idAndSeriesMap);
    }
    
    public static void createQuoteShares(List<Quote__c> recs) {
        Map<String, String> idAndSeriesMap = new Map<String, String>();
        for (Quote__c rec: recs) {
            idAndSeriesMap.put(rec.id, rec.Series__c);
        }
        JEOLUtil.setSameRoleSharing(Quote__c.SObjectType.getDescribe().getName(), idAndSeriesMap);
    }
    
    public static void createSalesOrderShares(List<SalesOrder__c> recs) {
        Map<String, String> idAndSeriesMap = new Map<String, String>();
        for (SalesOrder__c rec: recs) {
            idAndSeriesMap.put(rec.id, rec.Series__c);
        }
        JEOLUtil.setSameRoleSharing(SalesOrder__c.SObjectType.getDescribe().getName(), idAndSeriesMap);
    }
    
    public static void createSupportShares(List<Support__c> recs) {
        Map<String, String> idAndSeriesMap = new Map<String, String>();
        for (Support__c rec: recs) {
            idAndSeriesMap.put(rec.id, rec.SeriesPI__c);
        }
        JEOLUtil.setSameRoleSharing(Support__c.SObjectType.getDescribe().getName(), idAndSeriesMap);
    }
}