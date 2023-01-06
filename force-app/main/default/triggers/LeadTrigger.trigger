trigger LeadTrigger on Lead (before insert, after insert, before update, after update) {

    System.debug('Trigger size:'    + Trigger.size ); // number
    System.debug('Trigger is:'      + Trigger.isExecuting ); // boolean
    System.debug('Trigger type:'    + Trigger.operationType ); // BEFORE_INSERT, BEFORE_UPDATE, AFTER_INSERT ....
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            LeadTriggerHandler.BEFORE_INSERT(Trigger.new);

        }
        when BEFORE_UPDATE {
            LeadTriggerHandler.BEFORE_UPDATE(Trigger.new,Trigger.oldMap);
            
        }
        when BEFORE_DELETE{

        }
        when AFTER_INSERT{
            LeadTriggerHandler.AFTER_INSERT(Trigger.new);
           
        }
        when AFTER_UPDATE{

        }
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}

    }
    
}