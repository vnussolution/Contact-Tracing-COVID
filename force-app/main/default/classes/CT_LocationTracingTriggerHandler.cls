public with sharing class CT_LocationTracingTriggerHandler {
     
    public static void BEFORE_INSERT(List<Location_Tracing__c> newRecords){
        List<Location_Tracing__c> duplicates = CT_LocationTracingController.checkDuplicates(newRecords);

        for (Location_Tracing__c lt : duplicates) {
            lt.addError(' Duplicate found!!');
        }
    }
}