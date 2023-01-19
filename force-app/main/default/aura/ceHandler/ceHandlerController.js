/* ceHandlerController.js */
({
    handleComponentEvent : function(cmp, event) {
        var message = event.getParam("message");

        // set the handler attributes based on event data
        cmp.set("v.messageFromEvent", message);
        var numEventsHandled = parseInt(cmp.get("v.numEvents")) + 1;
        cmp.set("v.numEvents", numEventsHandled);
    },
    handleComponentEventBlock1 : function(cmp, event) {
        const value = event.getParams('value');

        console.log('handleComponentEventBlockClick', value, component.get('v.winWord'))
    },
})