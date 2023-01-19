public with sharing class GameResultController {
  
    @AuraEnabled
    public static List<Word_Shuffle__c> getResults(){
        try {
             string userId = UserInfo.getUserId();
            List<Word_Shuffle__c> results = [
                SELECT Id, Name, Result__c, Mode__c , CreatedDate
                FROM Word_Shuffle__c
                WHERE CreatedById =:userId AND CreatedDate = LAST_N_DAYS:1
                ORDER BY CreatedDate DESC
            ] ;

            return results;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}