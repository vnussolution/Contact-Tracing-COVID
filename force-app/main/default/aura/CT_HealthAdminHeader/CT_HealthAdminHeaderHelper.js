({
    fetchStatusCount : function(component) {
        const scope = component.get('v.scope');
        const personCount = component.get('c.getPersonHealthStatusCount')
        const locationCount = component.get('c.getLocationHealthStatusCount')
        let action = scope ==='person'?personCount:locationCount;

        action.setCallback(this, function(response){
            const state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.count', response.getReturnValue());
            }
        })

        $A.enqueueAction(action);
    }
})