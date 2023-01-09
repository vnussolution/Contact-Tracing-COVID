public with sharing class CT_PersonTriggerHandler {
    
    public static void BEFORE_INSERT(List<Person__c> newRecords){
        for (Person__c p : newRecords) {
            p.Health_Status__c = 'Green';
            p.Token__c = CT_PersonController.getToken(p.Mobile__c);
        }
    }

    public static void AFTER_INSERT_MySolution(List<Person__c> newRecords){
  
     
    }

    public static void AFTER_INSERT_UdemySolution(List<Person__c> triggeredRecords){
        // Set<Id> accountIds = new Set<Id>();

        // for (Person__c con: triggeredRecords) {
        //     if(String.isNotBlank(con.AccountId)){
        //         accountIds.add(con.AccountId);
        //     }
        // }

        // updateActiveContacts(accountIds);
    }
    public static void BEFORE_UPDATE(List<Person__c> newRecords , Map<Id,Person__c> oldRecordMap){
        for (Person__c p : newRecords) {
            System.debug('BEFORE_UPDATE -- new status = ' + p.Health_Status__c  + '  -- old status = '+  oldRecordMap.get(p.Id).Health_Status__c);
            if(p.Health_Status__c != oldRecordMap.get(p.Id).Health_Status__c){
                p.Status_Update_Date__c = Date.today();
            }
        } 
    }

    public static void AFTER_UPDATE(List<Person__c> newRecords , Map<Id,Person__c> oldRecordMap){
        System.debug(' -- AFTER_UPDATE ');
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
        Set<Id> alreadyProcessed = new Set<Id>();
        List<Person__c> personToUpdate = new List<Person__c>();

        for (Person__c p : newRecords) {
            System.debug(' -- new status = ' + p.Health_Status__c  + '  -- old status = '+  oldRecordMap.get(p.Id).Health_Status__c);
            if(p.Health_Status__c != oldRecordMap.get(p.Id).Health_Status__c){
                statusChange.add(p.Id);
                if(p.Health_Status__c == 'Red'){
                    redStatus.add(p.Id);
                    alreadyProcessed.add(p.Id);
                }
            }
        } 

        System.debug(' -- AFTER_UPDATE -orangeStatus getCohabitants redStatus=' + redStatus);
        // orange status needs to call before yellow status, because we use alreadyProcessed to track the processed records
        orangeStatus.addAll(CT_PeopleTracingController.getCohabitants(redStatus, alreadyProcessed));
        
        //
        Set<Id> primaryContacts = CT_PeopleTracingController.getPrimaryContacts(redStatus, alreadyProcessed);
        //add primary contact
        System.debug(' -- AFTER_UPDATE -orangeStatus  primaryContacts');

        orangeStatus.addAll(primaryContacts);

        System.debug(' -- AFTER_UPDATE -yellowStatus  getNeighbours');

        yellowStatus.addAll(CT_PeopleTracingController.getNeighbours(redStatus, alreadyProcessed));
    
        System.debug(' -- AFTER_UPDATE -yellowStatus  getNeighbours');

        //add secondary contact
        yellowStatus.addAll(CT_PeopleTracingController.getSecondaryContacts(primaryContacts, alreadyProcessed));


        //add red status
        //personToUpdate.addAll(redStatus);
        //add orange status
        for (Id  pid : orangeStatus) {
            personToUpdate.add(new Person__c(Id = pid, Health_Status__c = 'Orange'));
            System.debug(' -- personToUpdate orange pid:' +pid );

        }

        for (Id  pid : yellowStatus) {
            personToUpdate.add(new Person__c(Id = pid, Health_Status__c = 'Yellow'));
            System.debug(' -- personToUpdate yellow pid:' +pid );

        }

        System.debug(' -- count personToUpdate:' +personToUpdate.size() );

        if(personToUpdate.size() >0){
            update personToUpdate;

        }


        List<Location_Tracing__c> locationTracingList = CT_LocationTracingController.getLocationsByPersonIds(statusChange);
        if(locationTracingList != null && locationTracingList.size() > 0){
            Set<Id> locationIds = new Set<Id>();
            for (Location_Tracing__c trace : locationTracingList) {
                locationIds.add(trace.Location__c);
            }
            CT_LocationController.updateRecScore(locationIds);
        }
    

    }

    public static void updateActiveContacts(Set<Id> accountIds){
        // List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts 
        //                                 FROM Contact 
        //                                 WHERE Active__c = TRUE AND AccountId IN :accountIds 
        //                                 GROUP BY AccountId];

        // Map<Id,Account> accountsToUpdate = new Map<Id,Account>();
        // for (AggregateResult result : results) {
        //     String accId = String.valueOf(result.get('AccountId'));
        //     Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
        //     Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
        //     accountsToUpdate.put(accId, acc );
        // }

        // //to handle accounts with zero active contacts
        // for (Id accId : accountIds) {
        //     if(!accountsToUpdate.containsKey(accId)){
        //         accountsToUpdate.put(accId,new Account(Id = accId, Active_Contacts__c = 0));
        //     }
        // }
        // update accountsToUpdate.values();
    }


    public static void testAccountContactActiveTriggers(){

        // Contact c1 = new Contact(AccountId='001Dn00000CJzvnIAD', LastName = 'test12', FirstName='firstname', Active__c=true);
        // Contact c2 = new Contact(AccountId='001Dn00000AZalyIAD', LastName = 'test12', FirstName='firstname', Active__c=true);

        // Contact c3 = new Contact(AccountId='001Dn00000CJzvnIAD', LastName = 'test12', FirstName='firstname', Active__c=true);
        // Contact c4 = new Contact(AccountId='001Dn00000AZalyIAD', LastName = 'test12', FirstName='firstname', Active__c=true);

        // List<Contact> contactList = new List<Contact>();
        // contactList.add(c1);
        // contactList.add(c2);
        // contactList.add(c3);
        // contactList.add(c4);

        // System.debug(' debug1 ');

        // insert contactList;
        // System.debug(' debug2 ');


    }
}