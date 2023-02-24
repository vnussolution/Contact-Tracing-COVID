({
    updateStatus : function(component) {
        const recordId = component.get('v.recordId');

        // get apex controller
        const action = component.get('c.updateHealthStatus');
        action.setParams({personId:recordId});

        $A.enqueueAction(action)
    },

    showToast:function(title, message, type){
        const toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams(title,message,type);
        toastEvent.fire();
    }

})