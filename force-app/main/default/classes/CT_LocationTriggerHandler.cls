public with sharing class CT_LocationTriggerHandler {
    public static void BEFORE_INSERT(List<Location__c> newRecords){
        for (Location__c loc : newRecords) {
            loc.Status__c = 'Green';
        }
    }

    public static void BEFORE_UPDATE(List<Location__c> newRecords, Map<Id,Location__c> oldRecordMap){
        
        for (Location__c loc : newRecords) {
            if(oldRecordMap.get(loc.Id).Status__c != loc.Status__c){
                loc.Status_Update_Date__c = Date.today();
            }
        }
    }

    public static void AFTER_UPDATE(List<Location__c> newRecords, Map<Id,Location__c> oldRecordMap){
        Set<Id> personIdList = new Set<Id>();
        Set<Id> redLocationList = new Set<Id>();
        List<Person__c> personToUpdateList = new List<Person__c>();

        for (Location__c loc : newRecords) {
            if(loc.Status__c == 'Red' && oldRecordMap.get(loc.Id).Status__c !='Red'){
                redLocationList.add(loc.Id);
            }
        }

        List<Location_Tracing__c>  locationTracingList =  CT_LocationTracingController.getLocationsByLocationIds(redLocationList);
        for (Location_Tracing__c lt : locationTracingList) {
            personIdList.add(lt.Person__c);

        }
                                                            
        for (Id pid : personIdList) {
            personToUpdateList.add(new Person__c(Id=pid, Health_Status__c='Yellow'));
        }

        if(personToUpdateList.size() > 0){
            update personToUpdateList;

        }
    }
}