public with sharing class CT_PeopleTracingController {
    public CT_PeopleTracingController() {

    }

    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alreadyProcessed){
        List<String> healthStatuses = new List<String>{'Green','Yellow'};
        List<People_Tracing__c> peopleTraces =    [SELECT Id, Contact_Type__c,  Person_1__c, Person_2__c
                                                    FROM People_Tracing__c
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
                                                    AND Contact_Type__c = 'Cohabitant'
                                                    ORDER BY Contact_Date__c DESC
                                                    NULLS LAST
                                                    LIMIT 100];
        System.debug(' -- AFTER_UPDATE getCohabitants  peopleTraces count = ' + peopleTraces.size());
        System.debug(' -- AFTER_UPDATE getCohabitants  peopleTraces = ' + peopleTraces);

        Set<Id> cohabitants = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            if(!alreadyProcessed.contains(pt.Person_1__c) ){
                cohabitants.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c) ){
                cohabitants.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }

        return cohabitants;
    }

    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed){

        List<People_Tracing__c> peopleTraces =    [SELECT Id, Contact_Type__c,  Person_1__c, Person_2__c
                                                    FROM People_Tracing__c
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
                                                    AND Contact_Type__c = 'Neighbour'
                                                    ORDER BY Contact_Date__c DESC
                                                    NULLS LAST
                                                    LIMIT 100];

        Set<Id> neighbours = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            if(!alreadyProcessed.contains(pt.Person_1__c) ){
                neighbours.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c) ){
                neighbours.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }

        return neighbours;
    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed){
        List<String> healthStatuses = new List<String>{'Green','Yellow'};
        List<People_Tracing__c> peopleTraces =    [SELECT Id, Contact_Type__c,  Person_1__c, Person_2__c
                                                    FROM People_Tracing__c
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
                                                    AND Contact_Type__c = 'Other'
                                                    AND Contact_Date__c = LAST_N_DAYS:10
                                                    ORDER BY Contact_Date__c DESC
                                                    NULLS LAST
                                                    LIMIT 100];

        Set<Id> primaryContacts = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            if(!alreadyProcessed.contains(pt.Person_1__c) ){
                primaryContacts.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c) ){
                primaryContacts.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }

        return primaryContacts;
    }

    public static Set<Id> getSecondaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed){

        Set<Id> primaryContacts = getPrimaryContacts(personIds, alreadyProcessed);
        Set<Id> secondaryContacts = getPrimaryContacts(primaryContacts, alreadyProcessed);
        return secondaryContacts;
    }

    public static List<People_Tracing__c> getTraces(String recordId){
        return    [SELECT Contact_Type__c, Contact_Date__c, Id, Name, Person_1__c,Person_1__r.Name,Person_1__r.Health_Status__c
                            ,Person_1__r.Token__c, Person_2__c,Person_2__r.Name, Person_2__r.Health_Status__c,Person_2__r.Token__c
                    FROM People_Tracing__c
                    WHERE (Person_1__c = :recordId OR Person_2__c = :recordId)
                    //AND Contact_Date__c = LAST_N_DAYS:30
                    ORDER BY Contact_Date__c DESC
                    NULLS LAST
                    LIMIT 100];
    }


    //// this is the trickiest logic ///
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces){
        //unique personIds , need to handle situation: Person1 meets person2 = person2 meets person1 
        Set<Id> peopleSet = new Set<Id>();
        for(People_Tracing__c trace : newPeopleTraces){
            peopleSet.add(trace.Person_1__c);
            peopleSet.add(trace.Person_2__c);
        }

        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

        List<People_Tracing__c> existingRecords = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_2__c, Person_1__c 
                                                    FROM People_Tracing__c
                                                    WHERE Person_1__c IN :peopleSet OR Person_2__c IN :peopleSet];

        List<People_Tracing__c>  duplicates = new List<People_Tracing__c>();                                            

        if (existingRecords != null && existingRecords.size() > 0) {
            for (People_Tracing__c trace : existingRecords) {
                ///// handle person1
                if (!mapOfExistingRecords.containsKey(trace.Person_1__c)) {
                    mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                ///// handle person2
                if (!mapOfExistingRecords.containsKey(trace.Person_2__c)) {
                    mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);

            }

            for (People_Tracing__c trace : newPeopleTraces) {
                if (
                    trace.Person_1__c == trace.Person_2__c
                    ||
                    (mapOfExistingRecords.containsKey(trace.Person_1__c) && mapOfExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c))
                    ||
                    (mapOfExistingRecords.containsKey(trace.Person_2__c) && mapOfExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c))
                    ) {
                    duplicates.add(trace);
                }
                
            }
        }
        return duplicates;
    }

    public static void testCheckDuplicates(){
       
        People_Tracing__c pt1 = new People_Tracing__c(Person_1__c='a03Dn0000025AGDIA2',Person_2__c='a03Dn0000025AGFIA2');
        People_Tracing__c pt2 = new People_Tracing__c(Person_1__c='a03Dn0000025AGFIA2',Person_2__c='a03Dn0000025AGDIA2');
        People_Tracing__c pt3 = new People_Tracing__c(Person_1__c='a03Dn0000025AGFIA2',Person_2__c='a03Dn0000025AF2IAM');
        People_Tracing__c pt4 = new People_Tracing__c(Person_1__c='a03Dn0000025AGFIA2',Person_2__c='a03Dn0000025AGFIA2');
        People_Tracing__c pt5 = new People_Tracing__c(Person_1__c='a03Dn0000025AGFIA2',Person_2__c='a03Dn0000025AGFIA2');
        People_Tracing__c pt6 = new People_Tracing__c(Person_1__c='a03Dn0000025AGDIA2',Person_2__c='a03Dn0000025AGFIA2');

        List<People_Tracing__c>  traces = new List<People_Tracing__c>();
        traces.add(pt1);
        traces.add(pt2);
        traces.add(pt3);
        traces.add(pt4);
        traces.add(pt5);
        traces.add(pt6);

        List<People_Tracing__c>  duplicates = CT_PeopleTracingController.checkDuplicates(traces);

        System.debug('Duplicate Size: ' + duplicates.size());
        for (People_Tracing__c dup : duplicates) {

            System.debug(' Dup : Person1= ' + CT_PersonController.getPersonById(dup.Person_1__c).Name + ' , Person2 = ' + CT_PersonController.getPersonById(dup.Person_2__c).Name);
        }

    }

    public static void cleanUp(){
        List<People_Tracing__c> peopleTracingList = [SELECT Id FROM People_Tracing__c];
        delete peopleTracingList;
        System.debug('peopleTracingList Clean up' );
    }


}