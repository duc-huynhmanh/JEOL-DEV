trigger JEOL_ProductItemPrice_BeforeUpsertTrigger on ProductItemPrice__c (Before Insert, Before Update) {

    List<Id> lsID = new List<Id>();
    
    for (ProductItemPrice__c pip : Trigger.new) {
        lsID.add(pip.ProductItem__c);    
    }

    Map<Id, ProductItem__c> mpPI = new Map<Id, ProductItem__c>(); 
    for (ProductItem__c pi : [SELECT Id, ProductItemType__c, GaibuID__c FROM ProductItem__c WHERE Id IN :lsID]) {
        mpPI.put(pi.Id, pi);
    }
    
    for (ProductItemPrice__c pip : Trigger.new) {
        if (mpPI.get(pip.ProductItem__c).ProductItemType__c ==  '2') {
            pip.GaibuID__c = mpPI.get(pip.ProductItem__c).GaibuID__c;
        }
    }
               
}