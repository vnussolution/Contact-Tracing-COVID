({
    doInit : function(component, event, helper) {
        console.log('gameResultController - doInit');
        try {
            const columns =[
                {label:'Game Number', fieldName:'Name', type:'text'},
                {label:'Mode', fieldName:'Mode__c', type:'text'},
                {label:'Played On', fieldName:'CreatedDate', type:'date'},
                {label:'Result', fieldName:'Result__c', type:'text'},
    
            ];
            component.set('v.columns', columns);
            //get previous results
            helper.fetchResult(component);
        } catch (error) {
            console.log('gameResultController - error = ',error);   
        }
    },

    onResultHandler: function(component,event,helper){
        try {
            helper.fetchResult(component);
        } catch (error) {
            console.log(' ===gameResultController onResultHandler error = ', error);
        }
       
    }
})