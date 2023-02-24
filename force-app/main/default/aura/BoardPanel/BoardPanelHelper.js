({
    addResultRecord : function(component, gameResult) {

        // create apex method call action
        const action = component.get('c.addResult'); // get apex method , on controller class
        const modeValue = component.get('v.selectedMode').toUpperCase();
        //set parameters
        action.setParams({result:gameResult, mode: modeValue});
        //define a callback
        action.setCallback(this, function(response){
            const state = response.getState();
            if(state !== 'SUCCESS'){
                console.error('Error in saving record');
            }
        });
        //call apex method
        $A.enqueueAction(action);
        console.log('//call apex method');
    },

    showToast:function(type, title, message){
        const toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({type,title,message})
        toastEvent.fire();



    }
})