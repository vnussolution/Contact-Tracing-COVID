trigger CT_PeopleTracingTrigger on People_Tracing__c (before insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CT_PeopleTracingTriggerHandler.BEFORE_INSERT(Trigger.new);
        }
        when BEFORE_UPDATE {
           
        }
        when BEFORE_DELETE{

        }
        when AFTER_INSERT{
           
        }
        when AFTER_UPDATE{
        }
        when AFTER_DELETE{
        }
        when AFTER_UNDELETE{

        }

    }
}