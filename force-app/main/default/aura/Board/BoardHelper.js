({
    getWords : function(count) {
        if(count > 100) return;
        const wordArray = ['VAR','MINING','DEMO','REFLECTS','SINGLES','OK','PHRASE','MOTORCYCLES','NAILS','INSPIRED','LOADS','MEMBER','CAMP','DERBY','ESTABLISHING','MILWAUKEE','UNEXPECTED','PROPOSITION','CITIZENSHIP','LEAVES','MASTURBATING','CA','PRECISELY','INCLUDES','LLOYD','REGIONAL','ALLIANCE','PAYPAL','BILLY','HIV','UPDATED','MOLDOVA','ASSIGN','BARCELONA','ADMIT','PROFILE','LOLITA','ANALYSTS','AMANDA','EAU','COOL','EARNING','ELECTRICITY','DER','DRIVE','WORSHIP','WAV','SHIPMENTS','RIGHT','SUBMIT','NEWER','TP','WEBSITE','PARAGRAPH','CONSISTENTLY','COMPATIBILITY','ACM','TANZANIA','REASON','HONORS','TABS','HOMETOWN','GREETINGS','INDONESIAN','LEBANON','FIG','PERTH','ELEPHANT','READS','ANGELES','PMC','BP','HIGHS','ADVOCACY','MAGNET','IX','SALT','PLAYER','ORIENTATION','SLOW','QUALIFICATION','FORMATS','REGISTRATION','LEMON','PH','GROUP','KERRY','DOWNLOADING','DEPTH','DAVID','ORIGIN','COLLECTED','SUBJECTS','LARGE','LABELED','RAM','TEEN','PIN','ADAPTER','REVISED'];

        const randomArray = this.randomizeArray(wordArray.slice(0,count));

        const arrayWords = randomArray.map( w => { return {word:w , open : false}});
        return arrayWords;
    },

    getColumn: function(component){
        const gameMode = component.get('v.mode');
        let column = 0;
        if(gameMode && gameMode === 'hard'){
            column = 6
        } else if(gameMode === 'medium'){
            column = 4;
        } else {
            column = 3;
        }

        return column;
    },

    randomizeArray:function(arr){
        const randomArr = arr;

        for (let i = randomArr.length - 1; i >0; i--) {
            const j = Math.floor(Math.random()*i);
            const temp = randomArr[i];
            randomArr[i] = randomArr[j];
            randomArr[j] = temp;
        }
        return randomArr;
    },

    getWinWord:function (arr) {

        const index =Math.floor(arr.length * Math.random());
        return arr[index].word;
    },

    disableBoard:function(component){
        component.set('v.boardDisabled', true);
    },
    enbleBoard:function(component){
        component.set('v.boardDisabled', false);
    },

    resetBoard: function(component){
        this.enbleBoard(component);
        component.set('v.clickCount',0);
        component.set('v.result','');
        //this.resetWords(component);
        console.log('board helper -resetBoard- reshuffle +++')
       
    },

    resetWords:function(component){
        try {
            const words = component.get('v.shownwords');
            if(words !== undefined)
                words.forEach(w => {
                    const blockCompList = component.find('wordid');
                    blockCompList.forEach(eachComp =>{
                        const label = eachComp.get('v.label');
                        if(label === w){
                            eachComp.set('v.open',false);
                        }
                    })
                   
                });
            component.set('v.shownwords',[]);
        } catch (error) {
                console.log('error = ',error)
        }
    },

    fireApplicationEventResult: function(resultValue){
        console.log('BoardHelper fireApplicationEventResult - resultValue = ',resultValue)
        const appEvent = $A.get('e.c:ResultApplicationEvent');
        appEvent.setParams({"applicationEventResult":resultValue}); // setParams is correct
        appEvent.fire();

    }

})