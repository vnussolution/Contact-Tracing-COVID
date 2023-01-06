public with sharing class CT_LocationController {
    public CT_LocationController() {

    }

    public static List<Location__c> getRecentStatusChanges(){
        return [SELECT Id, Name, CreatedDate, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c
                ORDER BY Status_Update_Date__c DESC
                LIMIT 100];
    }

    public static List<Location__c> searchLocations(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, CreatedDate, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c
                WHERE Name LIKE :searchTerm OR Address__c LIKE :searchTerm
                ORDER BY Status_Update_Date__c DESC
                LIMIT 100];
    }

    public static Location__c getLocationId(String locationId){
        return [SELECT Id, Name, CreatedDate, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c
                WHERE Id = :locationId
                ORDER BY Status_Update_Date__c DESC
                LIMIT 100];
    }


    public static void seeding(){
        List<Location__c> getAllLocations = [SELECT Id FROM Location__c];

        Integer counter = getAllLocations.size();

        if(counter > 5) return ;
        
        List<Location__c> locationList= new List<Location__c>();

        for(Integer i =0; i < 5 ; i++){
            Location__c p = new Location__c(Name='Location-' + i , Address__c='Address-'+ i ,Red_Score__c=0,Pincode__c='123');
            locationList.add(p);
        }

        try {
            insert locationList;
        } catch (Exception e) {
            System.debug(' Error' + e.getMessage());
        } finally {
            System.debug('populateLocationData finally...' );
        }
    }

    public static void test_getRecentStatusChanges(){
        List<Location__c> ll = CT_LocationController.getRecentStatusChanges();

        String message = '';

        for (Location__c location : ll) {
            message += location.Name + ' - ';
        }

        System.debug(message);

    }


    public static Map<String,Integer> getStatusCount(){

        Map<String,Integer> mapResult = new Map<String,Integer> ();

        AggregateResult[] resultList = [SELECT Status__c, COUNT(Id) CountLocation  FROM Location__c GROUP BY  Status__c ];

        for (AggregateResult result : resultList) {
            mapResult.put(String.valueOf(result.get('Status__c')) , Integer.valueOf(result.get('CountLocation')));
        }
        System.debug(' -- ' + mapResult);

        return mapResult;

    }

    public static void updateRecScore(Set<Id> locationIds){
        List<Location__c> locationList = new List<Location__c>();

        AggregateResult[] redPeoplePerLocation = [SELECT Location__c, COUNT(Id) total
                                FROM Location_Tracing__c 
                                WHERE Person__r.Health_Status__c = 'Red' 
                                AND Visit_Date__c = LAST_N_DAYS:10 
                                AND Location__c IN :locationIds
                                GROUP BY Location__c
                                ];
        for (AggregateResult result : redPeoplePerLocation) {
            String locationId = String.valueOf(result.get('Location__c'));
            Integer redScore = Integer.valueOf(result.get('total'));
            String status= getStatus(redScore);
            locationList.add(new Location__c(Id=locationId, Red_Score__c=redScore, Status__c=status));

        }
        if(locationList != null && locationList.size() >0){
            update locationList;
        }
    }

    public static String getStatus(Integer redScore){
        if(redScore == 0){
            return 'Green';
        } else if(redScore <= 5){
            return 'Yellow';
        } else if(redScore <= 10){
            return 'Orange';
        } else return 'Red';
    }
    

    public static void cleanUp(){
        List<Location__c> locationList = [SELECT Id FROM Location__c];
        delete locationList;
        System.debug('locationList Clean up' );
    }

    public static void resetToGreen(){
        List<Location__c> locationList = [SELECT Id FROM Location__c];
        System.debug('CT_LocationController  locationList --'+locationList );

        List<Location__c> locationListToUpdate = new List<Location__c>();
        for (Location__c p : locationList) {
            locationListToUpdate.add(new Location__c(Id = p.Id, Status__c = 'Green', Red_Score__c=0));
        }
        update locationListToUpdate;
        System.debug('CT_LocationController.resetToGreen() --' );
    }
}
