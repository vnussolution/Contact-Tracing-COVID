trigger CT_LocationTrigger on Location__c (before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CT_LocationTriggerHandler.BEFORE_INSERT(Trigger.new);

        }
        when BEFORE_UPDATE {
            CT_LocationTriggerHandler.BEFORE_UPDATE(Trigger.new,Trigger.oldMap);
            
        }
        when BEFORE_DELETE{

        }
        when AFTER_INSERT{
           
        }
        when AFTER_UPDATE{
        }
        when AFTER_DELETE{
          //  ContactTriggerHandler.AFTER_INSERT_UdemySolution(Trigger.old);
        }
        when AFTER_UNDELETE{
           // ContactTriggerHandler.AFTER_INSERT_UdemySolution(Trigger.new);

        }

    }
}