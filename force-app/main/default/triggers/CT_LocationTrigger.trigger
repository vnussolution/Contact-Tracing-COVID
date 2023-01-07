trigger CT_LocationTrigger on Location__c (before insert, before update, after update) {
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
            CT_LocationTriggerHandler.AFTER_UPDATE(Trigger.new,Trigger.oldMap);
        }
        when AFTER_DELETE{
        }
        when AFTER_UNDELETE{

        }

    }
}