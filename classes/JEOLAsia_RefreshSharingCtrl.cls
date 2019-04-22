public with sharing class JEOLAsia_RefreshSharingCtrl {
	public String errorMessage{get;set;}
	public Integer sharingStatus{get;set;} //null: not done yet; 0: done with error; 1: done without error
	
	public JEOLAsia_RefreshSharingCtrl() {
	}

	private void removeExistingShareRecords(){
		List<AsiaProfitCalculation__share> removingShareRecords = [SELECT Id FROM AsiaProfitCalculation__share WHERE RowCause = :Schema.AsiaProfitCalculation__share.RowCause.Manually_Sharing__c];
		if(removingShareRecords != null && removingShareRecords.size() > 0){
			delete removingShareRecords;
		}
	}

	private void clearApexJob(){
		//TODO: check if jobs are running then prevent users to continue running batch
		List<ApexClass> apList = [Select Id from ApexClass where Name = 'JEOLAsia_SharingRecordsToUser'];
		List<AsyncApexJob> jobs = [SELECT Status FROM AsyncApexJob 
                                    WHERE JobType = 'BatchApex' AND Status NOT IN ('Aborted', 'Completed')
                                    AND ApexClassID =: apList[0].Id];
        for (AsyncApexJob job : jobs) {
        	system.abortJob(job.Id);
        }
	}

	public void getBatchResult(){
		system.debug('into getBatchResult');
		List<ApexClass> apList = [Select Id from ApexClass where Name = 'JEOLAsia_SharingRecordsToUser'];
		system.debug('apList: ' + apList);
		List<AsyncApexJob> jobs = [SELECT Status FROM AsyncApexJob 
                                    WHERE JobType = 'BatchApex' AND Status != 'Aborted' 
                                    AND ApexClassID =: apList[0].Id];
        system.debug('jobs: ' + jobs);
        sharingStatus = 1; //finished without error
        for(AsyncApexJob job : jobs){
        	if(job.Status == 'Failed') {
        		system.debug('FAILED');
        		//some batches finished with error
        		sharingStatus = 0;
        		errorMessage = 'Batch was running failed';
        		break;
        	} else if(job.Status == 'Queued' || job.Status == 'Preparing' || job.Status == 'Processing' || job.Status == 'Holding'){
        		//Batch is still running
        		sharingStatus = null;
        		system.debug('RUNNING');
        		break;
        	}
        }
        system.debug('sharingStatus: ' + sharingStatus);
	}

	public void sharingRecords(){
		try{
			removeExistingShareRecords();
			clearApexJob();
			Set<Id> uIds = new Set<Id>();
			for(Sharing_Rule__c rule : [SELECT User__c FROM Sharing_Rule__c]){
				//run batch for each of user
				if(uIds.contains(rule.User__c)){
					continue;
				}
				uIds.add(rule.User__c);
				JEOLAsia_SharingRecordsToUser b = new JEOLAsia_SharingRecordsToUser(rule.User__c);
        		database.executebatch(b, 200);	
			}
		} catch(Exception ex){
			errorMessage = ex.getMessage();
			sharingStatus = 0; //error happened
		}
    }
}