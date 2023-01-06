public with sharing class LeadTriggerHandler {
    public static Boolean alreadyExecuted = false;
    
    public static void BEFORE_INSERT(List<Lead> newRecords){
        for(Lead leadRecord : newRecords){
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';
            }
    
            if(String.isBlank(leadRecord.Industry)){
                leadRecord.addError('The industry field cannot be blank');
            }
        }
        System.debug('Lead trigger BEFORE_INSERT');
    }
    public static void BEFORE_UPDATE(List<Lead> newRecords, Map<Id,Lead> oldRecordMap){
        for(Lead leadRecord : newRecords){
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Other';
            }
    
            if( ( leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted') 
                && oldRecordMap.get(leadRecord.Id).Status == 'Open - Not Contacted'){
                    leadRecord.Status.addError('You cannot directly close an open lead record');
                }
    
            if(String.isBlank(leadRecord.Industry)){
                leadRecord.addError('The industry field cannot be blank');
            }
        }
        System.debug('Lead trigger BEFORE_UPDATE');
    }
    public static void BEFORE_DELETE(){}
    public static void AFTER_INSERT(List<Lead> newRecords){
        List<Task> leadTasks = new List<Task>();
        // create a leadd
        for(Lead leadRecord : newRecords){
            Task leadTask = new Task(Subject='Follow up on lead status', WhoId=leadRecord.Id);
            leadTasks.add(leadTask);
        }
        insert leadTasks;

        // insert a new Lead , this will cause deadlock issue
        // use a flag alreadyExecuted to stop deadlock
        if(alreadyExecuted == false){
            Lead anotherLead = new Lead(LastName='Test lead single', Status='Open - Not Contacted',Company='Home', Industry='Finance');
            alreadyExecuted = true;
            insert anotherLead;

        }
        System.debug('Lead trigger BEFORE_UPDATE');
    }
    public static void AFTER_UPDATE(){}
    public static void AFTER_DELETE(){}
}