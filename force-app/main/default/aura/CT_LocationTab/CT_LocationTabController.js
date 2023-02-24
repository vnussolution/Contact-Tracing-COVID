({
    locationSearchHandler : function(component, event, helper) {
        helper.fetchLocationInformation(component)
    },
    doInit: function(component,event,helper){
        const columns = [
            {label:'Name', fieldName:'location', type:'text'},
            {label:'Person', fieldName:'contactPerson', type:'text'},
            {label:'Token', fieldName:'contactToken', type:'text'},
            {label:'Status', fieldName:'contactStatus', type:'text'},
            {label:'Date', fieldName:'visitDate', type:'date'},
        ];
        component.set('v.columns',columns);
        helper.fetchAllLocations(component);
    },
    onChange: function (component, event, helper) {
        const value = component.find('locationId').get('v.value');
        component.set('v.recordId',value);

    }
})