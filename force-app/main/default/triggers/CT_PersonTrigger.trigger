trigger CT_PersonTrigger on Person__c (before insert, before update, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CT_PersonTriggerHandler.BEFORE_INSERT(Trigger.new);

        }
        when BEFORE_UPDATE {
            CT_PersonTriggerHandler.BEFORE_UPDATE(Trigger.new,Trigger.oldMap);
            
        }
        when BEFORE_DELETE{

        }
        when AFTER_INSERT{
           
        }
        when AFTER_UPDATE{
            CT_PersonTriggerHandler.AFTER_UPDATE(Trigger.new,Trigger.oldMap);
        }
        when AFTER_DELETE{
          //  ContactTriggerHandler.AFTER_INSERT_UdemySolution(Trigger.old);
        }
        when AFTER_UNDELETE{
           // ContactTriggerHandler.AFTER_INSERT_UdemySolution(Trigger.new);

        }

    }
}