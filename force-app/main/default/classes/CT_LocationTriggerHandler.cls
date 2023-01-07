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

    public static void AFTER_UPDATE(List<Location__c> newRecords, Map<Id,Location__c> oldRecordMap){
        Set<Id> personIdList = new Set<Id>();
        Set<Id> redLocationList = new Set<Id>();
        List<Person__c> personToUpdateList = new List<Person__c>();

        for (Location__c loc : newRecords) {
            if(loc.Status__c == 'Red'){
                redLocationList.add(loc.Id);
            }
        }

        List<Location_Tracing__c>  locationTracingList =  [SELECT Id, Visit_Date__c, Location__c, Person__c
                                                            FROM Location_Tracing__c
                                                            WHERE Location__c IN :redLocationList 
                                                            AND (Person__r.Health_Status__c = 'Green')
                                                            AND Visit_Date__c = LAST_N_DAYS:10
                                                            ORDER BY Visit_Date__c DESC
                                                            NULLS LAST
                                                            LIMIT 100];
        for (Location_Tracing__c lt : locationTracingList) {
            personIdList.add(lt.Person__c);

        }
                                                            
        for (Id pid : personIdList) {
            personToUpdateList.add(new Person__c(Id=pid, Health_Status__c='Yellow'));
        }

        update personToUpdateList;




    }
}