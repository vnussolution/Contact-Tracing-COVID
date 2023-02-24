({
    fireViewChangeEvent : function(component, viewName) {
        var cmpEvent = component.getEvent("componentChangeLabelEvent");

        cmpEvent.setParams({"view" : viewName });
        try {
            cmpEvent.fire();    
            
        } catch (error) {
            console.log('ffireViewChangeEvent error =',error)
        }
        console.log('CT_HealthAdminHelper fireViewChangeEvent')
    }
})