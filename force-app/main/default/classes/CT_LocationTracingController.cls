public with sharing class CT_LocationTracingController {
    public CT_LocationTracingController() {

    }

    public static List<Location_Tracing__c> getVisitors(String locationid){
        return    [SELECT Id, Visit_Date__c, Location__c, Person__r.Name, Person__r.Token__c,Person__r.Health_Status__c, Name
                    FROM Location_Tracing__c 
                    WHERE Location__c = :locationid
                    ORDER BY Visit_Date__c DESC
                    NULLS LAST
                    LIMIT 100];
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return    [SELECT  Id, Visit_Date__c, Location__c, Person__r.Name, Person__r.Token__c,Person__r.Health_Status__c, Name
                    FROM Location_Tracing__c
                    WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10
                    ORDER BY Visit_Date__c DESC
                    NULLS LAST
                    LIMIT 100];
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return   [SELECT Id, Visit_Date__c, Location__c, Person__c
                    FROM Location_Tracing__c
                    WHERE Location__c IN :locationIds 
                    AND (Person__r.Health_Status__c = 'Green')
                    AND Visit_Date__c = LAST_N_DAYS:10
                    ORDER BY Visit_Date__c DESC
                    NULLS LAST
                    LIMIT 100];
    }


    //check if each item in newLocationTraces List exists already in the system
    //this will check before any import into the obj 
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        // Algorithm-
        // Step 1: Iterate over the new location tracing records to get all unique location ids  
        // Step 2: Query existing location tracing records using ids collected in step l
        // Step 3 : Create a Map<locationId, Set<personId>>. This will make our task easier to find duplicates
        // Step 4: Loop over new location tracing records and check for duplicates in Map (created in Step 3)
        // Step 5 : Return the list of duplicates

        Set<Id> locationIds = new Set<Id>();
        //Set<Id> personIds = new Set<Id>();

        for (Location_Tracing__c trace: newLocationTraces ) {
            locationIds.add(trace.Location__c);
            //personIds.add(trace.Person__c);
        }

        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();
        List<Location_Tracing__c> existingRecords = [SELECT Id, Location__c, Person__c, Name
                                                    FROM Location_Tracing__c
                                                    WHERE Location__c IN :locationIds
                                                    ORDER BY Visit_Date__c DESC];
        List<Location_Tracing__c>  duplicates = new List<Location_Tracing__c>();

        if (existingRecords != null && existingRecords.size() > 0) {
            for (Location_Tracing__c trace: existingRecords) {
                if (!mapOfExistingRecords.containsKey(trace.Location__c)) {
                    mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }

            for (Location_Tracing__c trace: newLocationTraces) {
                if (mapOfExistingRecords.containsKey(trace.Location__c) && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)) {
                    duplicates.add(trace);
                }
            }
        }
        return duplicates;
    }

    public static void testCheckDuplicates(){
        Location_Tracing__c trace1 = new Location_Tracing__c(Person__c='a03Dn0000025AGFIA2', Location__c='a01Dn000008h36zIAA');
        Location_Tracing__c trace2 = new Location_Tracing__c(Person__c='a03Dn0000025AGGIA2', Location__c='a01Dn000008h36yIAA');
        Location_Tracing__c trace3 = new Location_Tracing__c(Person__c='a03Dn0000025AGEIA2', Location__c='a01Dn000008h371IAA');
        Location_Tracing__c trace4 = new Location_Tracing__c(Person__c='a03Dn0000025AGEIA2', Location__c='a01Dn000008h372IAA');

        List<Location_Tracing__c>  traces = new List<Location_Tracing__c>();
        traces.add(trace1);
        traces.add(trace2);
        traces.add(trace3);
        traces.add(trace4);

        List<Location_Tracing__c>  duplicates = CT_LocationTracingController.checkDuplicates(traces);
        System.debug('Duplicate: ' + duplicates);
        System.debug('Duplicate Size: ' + duplicates.size());
        for (Location_Tracing__c dup : duplicates) {

            System.debug(' Dup : Location = ' + CT_LocationController.getLocationId(dup.Location__c).Name + ' , Person = ' + 
            CT_PersonController.getPersonById(dup.Person__c).Name);
        }
    }

    public static void cleanUp(){
        List<Location_Tracing__c> locationTracingList = [SELECT Id FROM Location_Tracing__c];
        delete locationTracingList;
        System.debug('locationTracingList Clean up' );
    }

}