({
    fetchUserInformation : function(component) {
        const recordId = component.get('v.recordId');
        const action = component.get('c.getPersonDetails');
        action.setParams({recordId})

        action.setCallback(this, function(response){
            const state = response.getState();
            if(state === "SUCCESS"){
                const resp = response.getReturnValue();
                if(!resp || !resp.name){
                    component.set('v.userFound',false);
                    this.showToast('ERROR','Please enter valid user id','error')

                } else {
                    component.set('v.userFound',true);
                    component.set('v.userInfo', resp);
                }
            } else{
                component.set('v.userFound',false);
                this.showToast('ERROR','Please enter valid user id','error');
            }

        });

        $A.enqueueAction(action);

    },
    fetchAllUsers : function(component) {
        const action = component.get('c.getAllUsers');

        action.setCallback(this, function(response){
            const state = response.getState();
            if(state === "SUCCESS"){
                const resp = response.getReturnValue();
                const ids = [];
                console.log('---> ', resp);
                resp.forEach(e => {
                    ids.push({label:e.name, id:e.id});
                });

                ids[0]['selected'] = true;
                component.set('v.options',ids);
                component.set('v.recordId',ids[0].id);

            } else{
                component.set('v.userFound',false);
                this.showToast('ERROR','Please enter valid user id','error');
            }

        });

        $A.enqueueAction(action);

    },
    showToast:function(title, message, type){
        const toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({title,message,type});
        toastEvent.fire();

    }
})