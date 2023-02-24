public with sharing class CT_LocationTabController {
    @AuraEnabled
    public static LocationInformation getLocationDetails(string recordId){

        LocationInformation info = new LocationInformation();
        try {

            Location__c location = CT_LocationController.getLocationId(recordId);
            if(location != null){
                info.name = location.Name;
                info.address = location.Address__c;
                info.statusUpdateOn = location.Status_Update_Date__c;
                info.score = location.Red_Score__c;
                info.status = location.Status__c;
                info.pincode = location.Pincode__c;
            }
            List<Location_Tracing__c> traces = CT_LocationTracingController.getVisitors(recordId);


            if(traces != null && traces.size() > 0){
                List<LocationContacts> locationContacts = new List<LocationContacts>();

                for(Location_Tracing__c trace : traces){
                    LocationContacts lc = new LocationContacts();

                    lc.id = trace.Id;
                    lc.location = trace.Name;
                    lc.contactPerson = trace.Person__r.Name;
                    lc.contactStatus = trace.Person__r.Health_Status__c;
                    lc.contactToken = trace.Person__r.Token__c;
                    lc.visitDate = trace.Visit_Date__c;

                    locationContacts.add(lc);
                }
                info.contacts = locationContacts;
                info.locationCount = locationContacts.size();
                

            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return info;
    }

    @AuraEnabled
    public static List<LocationInformation>  getAllLocations(){

        List<Location__c> locationList = new List<Location__c>();
        List<LocationInformation> locations = new List<LocationInformation>();
        try {
            locationList = CT_LocationController.searchLocations('');
            for (Location__c item : locationList) {
                LocationInformation loc = new LocationInformation();
                loc.id = item.Id;
                loc.name = item.Name;
                locations.add(loc);
            }
          

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return locations;
    }


    public class LocationInformation{
        @AuraEnabled public string name;
        @AuraEnabled public string id;
        @AuraEnabled public date statusUpdateOn;
        @AuraEnabled public string address;
        @AuraEnabled public string pincode;
        @AuraEnabled public string status;
        @AuraEnabled public Decimal score;
        @AuraEnabled public Integer locationCount = 0;
        @AuraEnabled public List<LocationContacts> contacts;
    }

    public class LocationContacts {
        @AuraEnabled public string id;
        @AuraEnabled public string location;
        @AuraEnabled public string contactStatus;
        @AuraEnabled public string contactToken;
        @AuraEnabled public date visitDate;
        @AuraEnabled public string contactPerson;
    }
}