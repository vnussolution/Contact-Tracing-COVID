({
    doInit : function(component, event, helper) {
        const scope = component.get('v.scope');

        if(scope === 'person'){
            component.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Health Status', fieldName: 'Health_Status__c', type: 'text'},
                {label: 'Mobile', fieldName: 'Mobile__c', type: 'text'},
                {label: 'Status Update Date ', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'Token', fieldName: 'Token__c', type: 'text'},
                {label: 'Action', type: 'button', initialWidth: 150, typeAttributes:{ label: 'View Details', name: 'view_details', title: 'Click to View Details'}},
            ]);
        } else{
            component.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Status', fieldName: 'Status__c', type: 'text'},
                {label: 'Red Score', fieldName: 'Red_Score__c', type: 'text'},
                {label: 'Status Update Date ', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'Pincode', fieldName: 'Pincode__c', type: 'text'},
                {label: 'Address', fieldName: 'Address__c', type: 'text'},
                { label: "View", type: "button", initialWidth: 135, typeAttributes: { label: "View/Update", name: "view_details", title: "Click to View Details" } }
           
            ]);
        }
       
        helper.fetchRecentHealthChanges(component, scope);
    },
    handleRowAction: function (component, event, helper) {

        const action = event.getParam("action");
        const row = event.getParam("row");
        const scope = component.get("v.scope");
        const eventScope = scope === 'person'?'e.c:CT_PersonSelectEvent':'e.c:CT_LocationSelectEvent'
        switch (action.name) {
            case 'view_details':
                const appEvent = $A.get(eventScope);
                appEvent.setParams({recordId:row.Id, status:scope === 'person'?row.Health_Status__c:row.Status__c});
                appEvent.fire();
                break;
           
        }
    },
    handleKeyUp: function (component, event,helper) {
      
        const scope = component.get('v.scope');
        var isEnterKey = event.keyCode === 13;
        var queryTerm = component.find('enter-search').get('v.value');
        if (isEnterKey) {
            component.set('v.isSearching', true);
            setTimeout(function() {
                helper.fetchSearch(component, scope, queryTerm);
                component.set('v.isSearching', false);
            }, 2000);
        }
    }
})