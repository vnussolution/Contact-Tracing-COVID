public with sharing class CT_PersonTabController {

    @AuraEnabled
    public static UserInformation getPersonDetails(string recordId){

        UserInformation info = new UserInformation();
        try {

            Person__c person = CT_PersonController.getPersonById(recordId);
            if(person != null){
                info.name = person.Name;
                info.token = person.Token__c;
                info.statusUpdateOn = person.Status_Update_Date__c;
                info.phone = person.Mobile__c;
                info.status = person.Health_Status__c;
            }
            List<People_Tracing__c> traces = CT_PeopleTracingController.getTraces(recordId);


            if(traces != null && traces.size() > 0){
                List<CloseContacts> closeContacts = new List<closeContacts>();
                Set<Id> ids = new Set<Id>();

                for(People_Tracing__c trace : traces){
                    CloseContacts cc = new CloseContacts();

                    if(recordId != trace.Person_1__c){
                        cc.id = trace.Person_1__c;
                        cc.status = trace.Person_1__r.Health_Status__c;
                        cc.token = trace.Person_1__r.Token__c;
                        cc.contactDate = trace.Contact_Date__c;
                    }

                    if(recordId != trace.Person_2__c){
                        cc.id = trace.Person_2__c;
                        cc.status = trace.Person_2__r.Health_Status__c;
                        cc.token = trace.Person_2__r.Token__c;
                        cc.contactDate = trace.Contact_Date__c;
                    }
                    closeContacts.add(cc);
                }
                info.contacts = closeContacts;
                info.contactsCount = closeContacts.size();
                

            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return info;
    }

    @AuraEnabled
    public static List<UserInformation>  getAllUsers(){

        List<Person__c> people = new List<Person__c>();
        List<UserInformation> users = new List<UserInformation>();
        try {
            people = CT_PersonController.searchPeople('');
            for (Person__c p : people) {
                UserInformation user = new UserInformation();
                user.id = p.Id;
                user.name = p.Name;
                users.add(user);
            }
            Integer s = people.size();
            String ss = '123';

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return users;
    }


    public class UserInformation{
        @AuraEnabled public string name;
        @AuraEnabled public string id;
        @AuraEnabled public date statusUpdateOn;
        @AuraEnabled public string token;
        @AuraEnabled public string phone;
        @AuraEnabled public string status;
        @AuraEnabled public Integer contactsCount = 0;
        @AuraEnabled public List<CloseContacts> contacts;
    }

    public class CloseContacts {
        @AuraEnabled public string id;
        @AuraEnabled public string token;
        @AuraEnabled public date contactDate;
        @AuraEnabled public string status;
    }
}