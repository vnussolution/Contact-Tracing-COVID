public without sharing class CT_PersonController {

    public static String getToken(String mobile){
        //
        Blob mobileBlob = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', mobileBlob);
        String token = EncodingUtil.base64Encode(hash);
        return token;
    }

    public static List<Person__c> getRecentHealthChanges(){
        return    [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                        FROM Person__c
                                        ORDER BY Status_Update_Date__c DESC
                                        NULLS LAST
                                        LIMIT 100];
    }

    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm =  '%' + searchTerm + '%';
        return [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                        FROM Person__c
                                        WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm
                                        ORDER BY Status_Update_Date__c DESC
                                        LIMIT 100];
    }

    public static Person__c getPersonById(String PersonId){
        Person__c person = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                        FROM Person__c
                                        WHERE Id = :PersonId
                                        ORDER BY Status_Update_Date__c DESC
                                        LIMIT 1];
        if(person != null) return person;
        return null;
    }


    public static void seeding(){
        List<Person__c> personList= new List<Person__c>();

        for(Integer i =0; i < 10 ; i++){
            Person__c p = new Person__c(Name='Frank_' + i , Mobile__c='123434546'+ i ,Health_Status__c='Green',Status_Update_Date__c= Date.today().addDays(-9 - i));
            personList.add(p);
        }

        try {
            insert personList;
        } catch (Exception e) {
            System.debug(' Error' + e.getMessage());
        } finally {
            System.debug(' finally...' );
        }
    }


    public static Map<String,Integer> getHealthStatusCount(){

        Map<String,Integer> mapResult = new Map<String,Integer> ();

        AggregateResult[] resultList = [SELECT Name, Health_Status__c, COUNT(Id) CountPerson  FROM Person__c GROUP BY Name, Health_Status__c ];

        for (AggregateResult result : resultList) {
            mapResult.put(String.valueOf(result.get('Name')) , Integer.valueOf(result.get('CountPerson')));
        }
        System.debug(' -- ' + mapResult);

        return mapResult;

    }

    public static void cleanUp(){
        List<Person__c> personList = [SELECT Id FROM Person__c];
        delete personList;
        System.debug('CT_PersonController Clean up' );
    }

    public static void resetToGreen(){
        List<Person__c> personList = [SELECT Id FROM Person__c];
        System.debug('CT_PersonController  personList --'+personList );

        List<Person__c> personListToUpdate = new List<Person__c>();
        for (Person__c p : personList) {
            personListToUpdate.add(new Person__c(Id = p.Id, Health_Status__c = 'Green'));
        }
        update personListToUpdate;
        System.debug('CT_PersonController.resetToGreen() --' );
    }

    public static Map<String, Integer> getHealthStatusCountByStatus(){
        AggregateResult[] healthCountMap = [SELECT Health_Status__c, Count(Id) total FROM Person__c GROUP BY Health_Status__c];

        if(healthCountMap != null && healthCountMap.size() > 0){
            Map<String, Integer> result = new Map<String,Integer>();
            for (AggregateResult ar : healthCountMap) {
                result.put(String.valueOf(ar.get('Health_Status__c')), Integer.valueOf(ar.get('total')));
            }
            return result;
        }
        return null;
    }
}