({
    doInit : function(component, event, helper) {

        const column = helper.getColumn(component);
        const blockSize = 12/column;

        const words = helper.getWords(column*column);
        component.set('v.words',words);
        component.set('v.winWord',helper.getWinWord(words))
        component.set('v.blockSize', blockSize)
        console.log(' >>>>>>>>>>>>>>>>>>>>>>>words: ' + helper.getWords(6))
        console.log(' WIN word: ' + helper.getWinWord(words));

        helper.resetBoard(component)
    },

    blockClickHandler:function(component,event,helper){
        const value = event.getParam("value");
        const clickCount = component.get('v.clickCount') + 1;
        const winWord = component.get('v.winWord');

        if(value === winWord){
            component.set('v.result','YOU WIN');
            console.log('You win', value, component.get('v.winWord'));
            helper.disableBoard(component);
            helper.fireApplicationEventResult('WIN');
        } else if(clickCount === 3){
            component.set('v.result','YOU LOSE');
            console.log('You lose');

            helper.disableBoard(component);
            helper.fireApplicationEventResult('LOSE');


        }
        component.set('v.clickCount',clickCount);
        const clickedWords = component.get('v.shownwords');
        clickedWords.push(value);
    },

    handleComponentEvent : function(cmp, event) {
        var message = event.getParam("message");

        // set the handler attributes based on event data
        cmp.set("v.messageFromEvent", message);
        var numEventsHandled = parseInt(cmp.get("v.numEvents")) + 1;
        cmp.set("v.numEvents", numEventsHandled);
        console.log('handleComponentEvent +++', message)
    },

    reshuffleBoard:function(component,event,helper){
        console.log('board controller reshuffle +++')
        const column = helper.getColumn(component);
        const words = helper.getWords(column * column); // component.get('v.words');
        const randomizedWords = helper.randomizeArray(words);
        component.set('v.words', randomizedWords);
        helper.resetBoard(component);
    }
})