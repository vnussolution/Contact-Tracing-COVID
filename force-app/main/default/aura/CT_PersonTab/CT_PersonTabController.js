({
    userSearchHandler : function(component, event, helper) {
        helper.fetchUserInformation(component)
    },
    doInit: function(component,event,helper){
        const columns = [
            {label:'Token', fieldName:'token', type:'text'},
            {label:'Contact Status', fieldName:'status', type:'text'},
            {label:'Contact Date', fieldName:'contactDate', type:'date'},
        ];
        component.set('v.columns',columns);
        helper.fetchAllUsers(component);
    },
    onChange: function (component, event, helper) {
        const value = component.find('personId').get('v.value');
        component.set('v.recordId',value);

    }
})