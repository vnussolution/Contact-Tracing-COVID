public with sharing class CT_HealthHeaderController {

    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCount(){
        return CT_LocationController.getHealthStatusCountByStatus();
    }

    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCount(){
        return CT_PersonController.getHealthStatusCountByStatus();
    }
}