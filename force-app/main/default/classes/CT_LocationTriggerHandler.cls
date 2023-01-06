public with sharing class CT_LocationTriggerHandler {
    public static void BEFORE_INSERT(List<Location__c> newRecords){
        for (Location__c p : newRecords) {
            p.Status__c = 'Green';
        }
    }

    public static void BEFORE_UPDATE(List<Location__c> newRecords, Map<Id,Location__c> oldRecordMap){
        
        for (Location__c p : newRecords) {
            if(oldRecordMap.get(p.Id).Status__c != p.Status__c){
                p.Status_Update_Date__c = Date.today();
            }
        }
    }
}