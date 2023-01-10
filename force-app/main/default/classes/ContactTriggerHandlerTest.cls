@isTest
public with sharing class ContactTriggerHandlerTest {

    ////////
    /// get test coverage sfdx force:apex:test:run --tests ContactTriggerHandlerTest --resultformat human -c

    //////


    // makeData method is setup to populate the data for all test methods, so you don't need to populate each time
    @TestSetup
    public static void makeData(){
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name='Test 1'));
        testAccounts.add(new Account(Name='Test 2'));

        insert testAccounts;
        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName='Test Contact 1', AccountId = testAccounts[0].Id, Active__c = true));
        testContacts.add(new Contact(LastName='Test Contact 2', AccountId = testAccounts[0].Id, Active__c = true));
        testContacts.add(new Contact(LastName='Test Contact 3', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 4', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 5', AccountId = testAccounts[1].Id));

        insert testContacts;
    }

    @isTest
    public static void afterInsertHandlerTest2(){

        // SOQL is local, within @isTest it only returns accounts which have been setup.
        List<Account> accountList = [SELECT Id,Name , Active_Contacts__c FROM Account];
        System.assertEquals(2, accountList.size());
        for (Account acc : accountList) {
            if(acc.Name =='Test 1'){
                System.assertEquals(2, accountList[0].Active_Contacts__c);

            }
            if(acc.Name =='Test 2'){
                System.assertEquals(0, accountList[1].Active_Contacts__c);
            }
        }

        List<Contact> allContacts = [SELECT Id FROM Contact];
        System.assertEquals(5, allContacts.size());
    }

    @isTest
    public static void afterInsertHandlerTestBulk(){
        Account testAccount1 = [SELECT Id FROM Account WHERE Name='Test 1'];
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0 ; i < 10 ; i++) {
            testContacts.add(new Contact(LastName = 'Test Contact' + i, AccountId= testAccount1.Id , Active__c= true));
        }
        insert testContacts;

        List<Account> accountList = [SELECT Id,Name , Active_Contacts__c FROM Account];
        System.assertEquals(2, accountList.size());
        for (Account acc : accountList) {
            if(acc.Name =='Test 1'){
                System.assertEquals(12, accountList[0].Active_Contacts__c);

            }
            if(acc.Name =='Test 2'){
                System.assertEquals(0, accountList[1].Active_Contacts__c);
            }
        }

        List<Contact> contactList = [SELECT Id FROM Contact];

        System.assertEquals(15, contactList.size());

    }

    @isTest
    public static void afterUpdateHandlerTest3(){
        List<Contact> allContacts = [SELECT Id,LastName FROM Contact];

        for (Contact c : allContacts) {
            if (c.LastName == 'Test Contact 1' || c.LastName == 'Test Contact 3' || c.LastName == 'Test Contact 4') {
                c.Active__c = true;   
            }
        }
        
        //allocate new set of governor limits by using Test.startTest()
        Test.startTest();
        update allContacts;
        Test.stopTest();

        List<Account> accountList = [SELECT Id,Name , Active_Contacts__c FROM Account];
        System.assertEquals(2, accountList.size());
        for (Account acc : accountList) {
            if(acc.Name =='Test 1'){
                System.assertEquals(4, accountList[0].Active_Contacts__c);

            }
            if(acc.Name =='Test 2'){
                System.assertEquals(0, accountList[1].Active_Contacts__c);

            }
         
        }
        System.assertEquals(5,allContacts.size());
    }

    @isTest
    public static void afterUpdateHandlerTest4(){
        Account testAccount2 = [SELECT Id FROM Account WHERE Name = 'Test 2'];

        List<Contact> allContacts = [SELECT Id,LastName FROM Contact];

        for (Contact c : allContacts) {
            if (c.LastName == 'Test Contact 4' ) {
                c.Active__c = true;
                c.AccountId = testAccount2.Id;   
            }
        }
        
        //allocate new set of governor limits by using Test.startTest()
        Test.startTest();
        update allContacts;
        Test.stopTest();

        List<Account> accountList = [SELECT Id,Name , Active_Contacts__c FROM Account];
        System.assertEquals(2, accountList.size());
        for (Account acc : accountList) {
            if(acc.Name =='Test 1'){
                System.assertEquals(2, accountList[0].Active_Contacts__c);
            }
            if(acc.Name =='Test 2'){
                System.assertEquals(1, accountList[1].Active_Contacts__c);
            }
        }
        System.assertEquals(5,allContacts.size());
    }

     
}
