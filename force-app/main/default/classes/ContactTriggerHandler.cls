public with sharing class ContactTriggerHandler {
    
    
    public static void BEFORE_INSERT(List<Contact> newRecords){

    }

    public static void AFTER_INSERT_MySolution(List<Contact> newRecords){
       
        Map<Id, Integer> accountCounterMap = new Map<Id,Integer>();
        List<Account> accountList = new List<Account>();

        for(Contact c : newRecords){
            if (c.Active__c == true  &&  String.isNotBlank(c.AccountId)) {
                if(!accountCounterMap.containsKey(c.AccountId)){
                    accountCounterMap.put(c.AccountId, 1);
                } else{
                    Integer counter = accountCounterMap.get(c.AccountId);
                    accountCounterMap.put(c.AccountId, ++counter);
                }
            }
        }

        List<Account> accounts = [SELECT Id , Active_Contacts__c FROM Account WHERE Id IN :accountCounterMap.keySet()];

        System.debug('111');
        for (Account ac : accounts) {
            Decimal counter         =   ac.Active_Contacts__c == null ? 0: ac.Active_Contacts__c;
            System.debug('accountCounterMap.get(ac.Id) = ' + accountCounterMap.get(ac.Id));
            System.debug('counter' + counter);
            ac.Active_Contacts__c   =   counter + accountCounterMap.get(ac.Id);
            accountList.add(ac);
        }

        update accountList;
        System.debug('Contact trigger AFTER_INSERT');
    }

    public static void AFTER_INSERT_UdemySolution(List<Contact> triggeredRecords){
        Set<Id> accountIds = new Set<Id>();

        for (Contact con: triggeredRecords) {
            if(String.isNotBlank(con.AccountId)){
                accountIds.add(con.AccountId);
            }
        }

        updateActiveContacts(accountIds);
    }

    public static void AFTER_UPDATE_UdemySolution(List<Contact> newRecords , Map<Id,Contact> oldRecordMap){
        Set<Id> accountIds = new Set<Id>();

        for (Contact con: newRecords) {
            if(String.isNotBlank(con.AccountId)  && oldRecordMap.get(con.Id).Active__c != con.Active__c){
                accountIds.add(con.AccountId);
            } else if(oldRecordMap.get(con.Id).AccountId != con.AccountId){
                accountIds.add(con.AccountId);
                accountIds.add(oldRecordMap.get(con.Id).AccountId);
            }
        }

        updateActiveContacts(accountIds);
    }

    public static void updateActiveContacts(Set<Id> accountIds){
        List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts 
                                        FROM Contact 
                                        WHERE Active__c = TRUE AND AccountId IN :accountIds 
                                        GROUP BY AccountId];

        Map<Id,Account> accountsToUpdate = new Map<Id,Account>();
        for (AggregateResult result : results) {
            String accId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
            Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
            accountsToUpdate.put(accId, acc );
        }

        //to handle accounts with zero active contacts
        for (Id accId : accountIds) {
            if(!accountsToUpdate.containsKey(accId)){
                accountsToUpdate.put(accId,new Account(Id = accId, Active_Contacts__c = 0));
            }
        }
        update accountsToUpdate.values();
    }


    public static void testAccountContactActiveTriggers(){

        Contact c1 = new Contact(AccountId='001Dn00000CJzvnIAD', LastName = 'test12', FirstName='firstname', Active__c=true);
        Contact c2 = new Contact(AccountId='001Dn00000AZalyIAD', LastName = 'test12', FirstName='firstname', Active__c=true);

        Contact c3 = new Contact(AccountId='001Dn00000CJzvnIAD', LastName = 'test12', FirstName='firstname', Active__c=true);
        Contact c4 = new Contact(AccountId='001Dn00000AZalyIAD', LastName = 'test12', FirstName='firstname', Active__c=true);

        List<Contact> contactList = new List<Contact>();
        contactList.add(c1);
        contactList.add(c2);
        contactList.add(c3);
        contactList.add(c4);

        System.debug(' debug1 ');

        insert contactList;
        System.debug(' debug2 ');


    }
}
