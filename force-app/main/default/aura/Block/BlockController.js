({
    handleClick : function(component, event, helper) {
        let open = component.get('v.open');

        if(!open){
            component.set('v.open',!open);

            // Get the component event by using the
           // name value from aura:registerEvent
           var cmpEvent = component.getEvent("cmpEventBlock");
           const label = component.get('v.label');
           //setParams if more than 1 param, because it has 2 attributes
           console.log('blockController label =',label)
           cmpEvent.setParams({
               "value" : label, "message": 'test123' });
           try {
               cmpEvent.fire();
   
           } catch (error) {
               console.log('blockController ERROR =',error)
               
           }
           console.log('firing  ceNotifier from Block')
        }
       
    }
})