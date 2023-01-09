trigger CT_LocationTracing_Trigger on Location_Tracing__c (before insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CT_LocationTracingTriggerHandler.BEFORE_INSERT(Trigger.new);
        }
        when BEFORE_UPDATE {
            // CT_LocationTriggerHandler.BEFORE_UPDATE(Trigger.new,Trigger.oldMap);
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