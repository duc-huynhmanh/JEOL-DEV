public with sharing class JEOL_GenericHistoryComponent_Ctrl {

    // External variables
    public SObject myObject {get; set;}
    public Integer recordLimit {get; set;}
    public Integer updatedRecordLimit {get; set;}
    public Integer tableSize {get; set;}
    public static String historyTitle {get;}

    public Id myObjectId {get;set;}
    public Integer rowCount {get;set;}
    // Internal Variables
    public objectHistoryLine[] objectHistory; 

    public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe();
    public static Map<String, Schema.SObjectField> myObjectFieldMap;
    public static List<Schema.PicklistEntry> historyFieldPicklistValues;
    
    public List<objectHistoryLine> getObjectHistory(){
        if(updatedRecordLimit != null){
            recordLimit = updatedRecordLimit;
        }else{
            updatedRecordLimit = recordLimit;
        }
        
        // if no object passed in, return empty list
        if (myObject == null) {
            return new List<objectHistoryLine>();
        }

        myObjectId = String.valueOf(myObject.get('Id'));
        Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe();

        myObjectFieldMap = objectDescription.fields.getMap();
        String objectLabel = String.valueOf(objectDescription.getLabel());
        historyTitle = String.format(Label.JEOL_History_Title, new String[]{objectLabel});

        //Get the name of the history table
        String objectHistoryTableName = objectDescription.getName();
        
        //ID field name         
        string ObjectIdName;
        
        //if we have a custom object we need to drop the 'c' off the end before adding 'History' to get the history tables name        
        if (objectDescription.isCustom()){            
            objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
            ObjectIdName = 'ParentId';        
        }        
        else{
            ObjectIdName = objectHistoryTableName+ 'Id';
        }
        
        if(objectHistoryTableName == 'Opportunity') {
            objectHistoryTableName = objectHistoryTableName + 'FieldHistory';
        } else {
            objectHistoryTableName = objectHistoryTableName + 'History';
        }

        // The following row is probably to use when using it inside a package
        // objectHistoryTableName = objectHistoryTableName.replace('NAMEPACKAGE__','');

        Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
        historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();
                    
        list<objectHistoryLine> objectHistory = new list<objectHistoryLine>();
        
        String prevDate = '';
                
        if (recordLimit== null){
            recordLimit = 100;
        }

        list<sObject> historyList = Database.query( 'SELECT CreatedDate,'+
                                                    'CreatedById,'+
                                                    'Field,'+
                                                    'NewValue,'+
                                                    'OldValue ' +
                                                    'FROM ' + objectHistoryTableName + ' ' +
                                                    'WHERE ' + ObjectIdName + ' =\'' + myObjectId + '\' ' +
                                                    'ORDER BY CreatedDate DESC');
        
        
        Integer tempTableSize = historyList.size();
        tableSize = 0;
        rowCount = 0;
                 
        for(Integer i = 0; i < tempTableSize; i++){
            sObject historyLine = historyList.get(i);
            
            Boolean isId = false;
            
            try{

                if (historyLine.get('oldValue') != null || historyLine.get('newValue') != null) {
                    if (historyLine.get('oldValue') != null) {
                        SObjectType testIdOld = Id.valueOf(String.valueOf(historyLine.get('oldValue'))).getSObjectType();                    
                    }

                    if (historyLine.get('newValue') != null) {
                        SObjectType testIdNew = Id.valueOf(String.valueOf(historyLine.get('newValue'))).getSObjectType();
                    }

                    isId = true;
                }
            } catch (Exception e) {}
            
            if(!isId && rowCount < recordLimit){
                
                objectHistoryLine tempHistory = new objectHistoryLine();
                // Set the Date and who performed the action
                if (String.valueOf(historyLine.get('CreatedDate')) != prevDate){
                    tempHistory.theDate = datetime.valueof(historyLine.get('CreatedDate')).format();
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                    tempHistory.who = String.valueOf(historyLine.get('CreatedById'));
                }
                else{
                    tempHistory.theDate = '';
                    tempHistory.who = '';
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                }
                prevDate = String.valueOf(historyLine.get('CreatedDate'));
                
                // Get the field label
                String fieldLabel = JEOL_GenericHistoryComponent_Ctrl.returnFieldLabel(String.valueOf(historyLine.get('Field')));
                
                // Set the Action value
                   if (String.valueOf(historyLine.get('Field')) == 'created') {    // on Creation
                       tempHistory.action = Label.JEOL_History_Action_Created;
                  }
                  else if (historyLine.get('oldValue') != null && historyLine.get('newValue') == null){ // when deleting a value from a field
                      // Format the Date and if there's an error, catch it and re
                      try {
                         tempHistory.action = String.format(Label.JEOL_History_Action_Deleted, new String[]{fieldLabel.escapeHtml4(), Date.valueOf(historyLine.get('oldValue')).format().escapeHtml4()}); //'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
                    } catch (Exception e){
                         tempHistory.action = String.format(Label.JEOL_History_Action_Deleted, new String[]{fieldLabel.escapeHtml4(), String.valueOf(historyLine.get('oldValue')).escapeHtml4()}); //'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
                    }
                  }
                  else{  // all other scenarios
                    String fromText = '';
                    if (historyLine.get('oldValue') != null) {
                         try {
                              fromText = Date.valueOf(historyLine.get('oldValue')).format();
                         } catch (Exception e) {
                              fromText = String.valueOf(historyLine.get('oldValue'));
                         }
                    }
                    
                    SObjectType fromsObjectType;
                    
                    String toText = '';
                    if (historyLine.get('newValue') != null) {
                        try {
                             toText = Date.valueOf(historyLine.get('newValue')).format();
                        } catch (Exception e) {
                             toText = String.valueOf(historyLine.get('newValue'));
                        }
                    }
                    if (toText != ''){

                        if (fromText != ''){
                            tempHistory.action = String.format(Label.JEOL_History_Action_ChangedFromTo, new String[]{fieldLabel.escapeHtml4(), fromText.escapeHtml4(), toText.escapeHtml4()}); //tempHistory.action = 'Changed <b>' + fieldLabel + '</b> from ' + fromText + ' to <b>' + toText + '</b>.';
                        } else {
                            tempHistory.action = String.format(Label.JEOL_History_Action_ChangedTo, new String[]{fieldLabel.escapeHtml4(), toText.escapeHtml4()});
                        }

                    } else {
                        tempHistory.action = String.format(Label.JEOL_History_Action_Changed, new String[]{fieldLabel.escapeHtml4()}); //'Changed <b>' + fieldLabel + '</b>.';
                    }
                   }
                   rowCount++;
                   // Add to the list
                   objectHistory.add(tempHistory);

             }
        }
         
         List<Id> userIdList = new List<Id>();
         for (objectHistoryLine myHistory : objectHistory){
             userIdList.add(myHistory.userId);
         }
         Map<Id, User> userIdMap = new Map<ID, User>([SELECT Name FROM User WHERE Id IN : userIdList]);
         
         for (objectHistoryLine myHistory : objectHistory){
             if (userIdMap.containsKey(myHistory.userId) & (myHistory.who != '') ){
                 myHistory.who = userIdMap.get(myHistory.who).Name;
             }
         }
         
         return objectHistory;
    }    
    
//    public PageReference refreshObjectHistory(){
//        updatedRecordLimit = updatedRecordLimit + recordLimit;
//        getObjectHistory();
//        return null;
//    }
    
    // Function to return Field Label of a object field given a Field API name
    public Static String returnFieldLabel(String fieldName){

        // The following row is probably to use when using it inside a package
        // fieldName = fieldName.replace('NAMEPACKAGE__','');
        if (JEOL_GenericHistoryComponent_Ctrl.myObjectFieldMap.containsKey(fieldName)){
            return JEOL_GenericHistoryComponent_Ctrl.myObjectFieldMap.get(fieldName).getDescribe().getLabel();
        }
        else {
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues){
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                        return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
    
    // Inner Class to store the detail of the object history lines    
    public class objectHistoryLine {

        public String theDate {get; set;}
        public String who {get; set;}
        public Id userId {get; set;} 
        public String action {get; set;}
    }

}