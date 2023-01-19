public with sharing class BoardPanelController {
    
    @AuraEnabled
    public static string addResult(string result , string mode){
        try {
            Word_Shuffle__c gameResult = new Word_Shuffle__c(Result__c = result, Mode__c = mode);
            insert gameResult;
            return 'Success';

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }
}