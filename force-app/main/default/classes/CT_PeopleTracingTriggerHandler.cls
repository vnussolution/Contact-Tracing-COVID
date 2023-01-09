public with sharing class CT_PeopleTracingTriggerHandler {

    
    public static void BEFORE_INSERT(List<People_Tracing__c> newRecords){
        List<People_Tracing__c> duplicates = CT_PeopleTracingController.checkDuplicates(newRecords);
        for (People_Tracing__c pt : duplicates) {
                pt.addError(' Duplicate found! - ');
        }

    }
}