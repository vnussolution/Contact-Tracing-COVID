trigger CaseTrigger on Case (before insert, before update, after undelete, after delete, after insert, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            System.debug('BEFORE_INSERT');
            List<Case> caseList = Trigger.new;
            caseList[0].Type = 'Other';
            caseList[0].ContactId = '003Dn000008AskFIAS';
            System.debug('Type = Other');
        }

        when AFTER_INSERT{
            System.debug('AFTER_INSERT');
            List<Case> caseList = Trigger.new;
            //caseList[0].Type = 'Other';
          //  caseList[0].ContactId = '003Dn000008AskFIAS';
            System.debug(' -- c.Type = ' + caseList[0].Type);
            //caseList[0].Type = 'Structural';
            System.debug('Type = Structural');
        }
        
        when BEFORE_UPDATE {
            System.debug('BEFORE_UPDATE');
            List<Case> caseList = Trigger.new;
            caseList[0].Type = 'Other';
            caseList[0].ContactId = '003Dn000008AskFIAS';
            System.debug('Type = Other');
        }
        when BEFORE_DELETE{

        }
        when AFTER_UPDATE{
           
        }
        when AFTER_DELETE{
           
        }
        when AFTER_UNDELETE{
           

        }

    }
}