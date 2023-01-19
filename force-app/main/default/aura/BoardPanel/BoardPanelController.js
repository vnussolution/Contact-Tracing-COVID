({

    startGame: function(component, event, helper){
        console.log(' start game.');

        const gameModeCombobox = component.find('gameMode');
        const selectedValue = gameModeCombobox.get('v.value')

        component.set('v.selectedMode', selectedValue);

        const selectedMode = component.get('v.selectedMode')
        component.set('v.selectedMode', selectedValue);
        if(selectedMode){
            const boardComp = component.find('boardComp')
            boardComp.startGameMethod();
            console.log(' call startGameMethod.');

        }

    },

    reshuffleBoard: function(component, event, helper){
        console.log(' reshuffle board.');
        const boardComp = component.find('boardComp')
        boardComp.reshuffleBoard();
        component.set('v.reshuffleDisabled', true);
        
    },

    onResultHandler: function(component,event,helper){
        try {
            const result = event.getParam('applicationEventResult');
            if(result ==='WIN'){
                component.set('v.reshuffleDisabled', true);
                helper.showToast('success','YOU WIN!','ONE MORE ROUND ?')
            }else {
                component.set('v.reshuffleDisabled', false);
                helper.showToast('error','YOU LOSE!','YOU MAY WIN NEXT ROUND :)')
            }
            console.log(' === applicationEventResult  = ', result);
            helper.addResultRecord(component,result)
        } catch (error) {
            console.log(' === onResultHandler error = ', error);
        }
       
    }
})
