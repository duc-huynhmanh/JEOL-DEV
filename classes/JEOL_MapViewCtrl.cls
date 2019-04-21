public with sharing class JEOL_MapViewCtrl {
	
	public Account rec;
	
	public JEOL_MapViewCtrl(Apexpages.StandardController ctrl) {
		this.rec = (Account) ctrl.getRecord();
	}
	
	public List<Account> getNearAccounts() {
		List<Account> targets;
		String targetAddress = rec.Address__c;
		if (String.isNotBlank(targetAddress)) {
			List<String> addressParts = targetAddress.split('[市区町村]', 0);
			if (addressParts != null && addressParts.size() > 1) {
				String state = addressParts.get(0) + '%';
				targets = [SELECT id, name, address__c, Phone FROM Account WHERE Address__c like: state AND Address__c !=: rec.Address__c AND id !=: rec.id LIMIT 10];
			}
		}
		if (targets == null) {
			targets = new List<Account>();
		}
		return targets;
	}
}