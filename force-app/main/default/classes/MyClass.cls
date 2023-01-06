public with sharing class MyClass {
    public MyClass() {

    }

    public static void updateProfile(List<Id> oppIds){
        List<Opportunity> listOpps = [SELECT Id, Amount, Profile__c FROM Opportunity WHERE Id IN: oppIds];
        for(Opportunity opp : listOpps){
            if(opp.Amount == null){
                opp.Profile__c = 'Low';
            }else if(opp.Amount < 10000){
                opp.Profile__c = 'Low';
            } else if(opp.Amount >50000){
                opp.Profile__c = 'High';
            } else { 
                opp.Profile__c = 'Medium';
            }
        }
        update listOpps;
    }
    
    public static void setupTestRecords(){
        List<Opportunity> listOpps = new List<Opportunity>();
        for(Integer i=0; i<200; i++){
            listOpps.add(new Opportunity(Name='Test Opp' + i , CloseDate=Date.today(), StageName='Qualification'));
        }
        insert listOpps;
    }
    
    public static void runProgram(){
        List<Opportunity> listOpps = [SELECT Id FROM Opportunity ];
        List<Id> oppIds = new List<Id>();
        for(Opportunity opp : listOpps){
            oppIds.add(opp.Id);
            oppIds.add(opp.Id);
            oppIds.add(opp.Id);
        }
       // OpportunityController.updateProfile(oppIds);
    }
    
    public static void limits(){
        List<Account> accounts = [SELECT Id, Name FROM Account];
        while(1==1){
            if(Limits.getHeapSize()*2 >= Limits.getLimitHeapSize()){
                break;
            }
        	List<Account> dupAccounts = accounts;
            accounts.addAll(dupAccounts);
        }
        
        System.debug('List size : '+ accounts.size() + ' - Heap : '+ Limits.getHeapSize());
    }
    
    public static void SOQLonLoop(){
        // query all accounts in DB, it could return more than 1000000 records, this would fail if there are many records
        List<Account> accounts = [SELECT Id, Name FROM Account]; 
        
		accounts = null ;  //	        
        for(Account acc: [SELECT Id, Name FROM Account]){ // SOQL on the loop will fetch on 200 records each time, then it will fetch the next batch 200, this way is more efficient 
            if(Limits.getHeapSize()*2 >= Limits.getLimitHeapSize()){
                break;
            }
        	List<Account> dupAccounts = accounts;
            accounts.addAll(dupAccounts);
        }
    }
    
    // turn this method to accept a list to bulkify to update multiple accounts at once
    public static void challengeUpdateAvgCaseResolutionDays(Id accountId){
        Integer totalDays = 0, totalCases =0;
        for(Case c : [SELECT Id, CreatedDate, ClosedDate FROM Case WHERE IsClosed=true AND AccountId =: accountId]){
            totalCases++;
            totalDays += c.CreatedDate.date().daysBetween(c.ClosedDate.date());            
            
        }
        Decimal resolutionDays = totalDays/totalCases;
        Account acc = new Account(Id=accountId, avg_case_resolution_days__c = resolutionDays);
        update acc;
    }
    
    // solution to bulkify
    public static void solutionUpdateAvgCaseResolutionDays(List<Id> accIds){
		List<Account> accountList = new List<Account>();
        for(Account ac : [SELECT Id FROM Account WHERE Id IN: accIds]){
            Integer totalDays = 0, totalCases =0;
            for(Case c : [SELECT Id, CreatedDate, ClosedDate FROM Case WHERE IsClosed=true AND AccountId =: ac.Id]){
                totalCases++;
                totalDays += c.CreatedDate.date().daysBetween(c.ClosedDate.date());            
                
            }
            if(totalCases > 0){
                Decimal resolutionDays = totalDays/totalCases;
                ac.avg_case_resolution_days__c = resolutionDays;   
                accountList.add(ac);
            }
            
        }
        
        update accountList;
    }
    
    public static void solution2UpdateAvgCaseResolutionDays(List<Id> accIds){
        Map<Id, Integer> accountTotalCaseMap = new Map<Id, Integer>();
        Map<Id, Integer> accountTotalCaseDaysMap = new Map<Id, Integer>();

        for(Case c : [SELECT Id, CreatedDate, ClosedDate, AccountId FROM Case WHERE IsClosed=true AND AccountId IN: accIds]){
            //if map does not have current account id, then add it
            if(!accountTotalCaseMap.containsKey(c.AccountId)){
                accountTotalCaseMap.put(c.AccountId,0);
                accountTotalCaseDaysMap.put(c.AccountId,0);
            }
            Integer totalCases = accountTotalCaseMap.get(c.AccountId);
            Integer totalDays = accountTotalCaseDaysMap.get(c.AccountId);
            totalCases++;
            accountTotalCaseMap.put(c.AccountId,totalCases);
            totalDays += c.CreatedDate.date().daysBetween(c.ClosedDate.date());            
            accountTotalCaseDaysMap.put(c.AccountId,totalDays);
        }
        
        //list of account to update
        List<Account> accountListToUpdate = new List<Account>();
        for(Id accountId : accountTotalCaseMap.keySet()){
            Decimal resolutionDays = accountTotalCaseDaysMap.get(accountId)/accountTotalCaseMap.get(accountId) +300;
            accountListToUpdate.add(new Account(Id=accountId,avg_case_resolution_days__c=resolutionDays));
        }

        update accountListToUpdate;
    }
    
    public static void runSolutionUpdateAvgCaseResolutionDays(){
        
        List<Id> resultIds = new List<Id>((new Map<Id,SObject>([SELECT Id FROM Account LIMIT 222])).keySet());
        //OpportunityController.solution2UpdateAvgCaseResolutionDays(resultIds);
   
    }


    //clean up data for Contact Tracing app
    public static void cleanUpContactTracingData(){
        CT_LocationTracingController.cleanup();
        CT_PeopleTracingController.cleanup();
        CT_PersonController.cleanup();
        CT_LocationController.cleanup();
    }

    public static void testContactTracingApp(){

        CT_PersonController.resetToGreen();
        CT_LocationController.resetToGreen();
        Person__c p1 = new Person__c(Id='a03Dn0000025RmqIAE', Health_Status__c='Red');
        update p1;

        system.debug('--- *----');
    }

 

}
