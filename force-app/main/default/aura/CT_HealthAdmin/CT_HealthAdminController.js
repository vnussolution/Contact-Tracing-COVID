({
    handleSelect: function (component, event, helper) {
        const tabId = event.getParam('id')
        switch (tabId) {
            case 'person_view' :
                component.set('v.headerTitle','Person View');
                component.set('v.scope','person');
                //helper.fireViewChangeEvent(component,'person')
                break;
            case 'location_view' :
                component.set('v.headerTitle','Location View');
                component.set('v.scope','location');
                //helper.fireViewChangeEvent(component,'location')
                break;
        };

        const healthHeaderComp = component.find('health-header');
        healthHeaderComp.fetchCount();

    }

})