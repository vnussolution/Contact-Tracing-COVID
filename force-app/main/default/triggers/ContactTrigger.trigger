trigger ContactTrigger on Contact (after undelete, after delete, after insert, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
         

        }
        when BEFORE_UPDATE {
            //LeadTriggerHandler.BEFORE_UPDATE(Trigger.new,Trigger.oldMap);
            
        }
        when BEFORE_DELETE{

        }
        when AFTER_INSERT{
            ContactTriggerHandler.AFTER_INSERT_UdemySolution(Trigger.new);
           
        }
        when AFTER_UPDATE{
            ContactTriggerHandler.AFTER_UPDATE_UdemySolution(Trigger.new,Trigger.oldMap);
        }
        when AFTER_DELETE{
            ContactTriggerHandler.AFTER_INSERT_UdemySolution(Trigger.old);
        }
        when AFTER_UNDELETE{
            ContactTriggerHandler.AFTER_INSERT_UdemySolution(Trigger.new);

        }

    }
    
}