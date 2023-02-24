public with sharing class CT_RecentChangesController {
    
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges(){
        return    CT_PersonController.getRecentHealthChanges();
    }

    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm){
        return    CT_PersonController.searchPeople(searchTerm);
    }


    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges(){
        return    CT_LocationController.getRecentStatusChanges();
    }

    @AuraEnabled
    public static List<Location__c> searchLocation(String searchTerm){
        return    CT_LocationController.searchLocations(searchTerm);
    }
}