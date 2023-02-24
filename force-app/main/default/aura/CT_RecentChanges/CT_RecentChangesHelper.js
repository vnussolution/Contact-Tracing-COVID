({
    fetchRecentHealthChanges : function(component, scope) {
        let method_name = ''
        if(scope === 'person'){
            method_name = 'c.getRecentPersonHealthChanges';
        } else{
            method_name = 'c.getRecentLocationHealthChanges';
        }
        let action = component.get(method_name);


        action.setCallback(this, function(response){
   
            const state = response.getState();
            if(state === 'SUCCESS'){
            
                const data = response.getReturnValue();
                component.set('v.data', data);
                console.log('===>>>>',data)

            }
        });

        $A.enqueueAction(action);
    },
    fetchSearch: function(component, scope, queryTerm) {
        let method_name = ''
        if(scope === 'person'){
            method_name = 'c.searchPeople';
        } else{
            method_name = 'c.searchLocation';
        }
        let action = component.get(method_name);
        action.setParams({searchTerm:`%${queryTerm}%`});

        action.setCallback(this, function(response){
            const state = response.getState();
            if(state === 'SUCCESS'){
                const data = response.getReturnValue();
                component.set('v.data', data);
                console.log('===>>>>',data)

            }
        });

        $A.enqueueAction(action);
    }
})