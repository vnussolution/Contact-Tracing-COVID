({
    fetchResult : function(component) {
        console.log('gameResultHelper - fetchResult');
        const action = component.get('c.getResults'); //get apex method
        action.setCallback(this, function(response){
            const state = response.getState();
            if(state=== 'SUCCESS'){
                const resp = response.getReturnValue();
                component.set('v.data', resp);
            }

            

        });

        $A.enqueueAction(action);
    }
})
