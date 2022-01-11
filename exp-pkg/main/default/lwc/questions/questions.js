import {LightningElement, api, track} from 'lwc';

export default class questions extends LightningElement {
    @api
    questionNumber = 1;
    
    @api
    question = {
        prompt: "Which is not a plant?",
        type: "Single",
        options: [
            {text:"Tree",result: false},
            {text:"Cactus",result: false},
            {text:"Mushroom",result: true},
            {text:"Grass",result: false},
        ],
    };

    @track
    selections = [];
    connectedCallback() {
        for (let i = 0; i < this.question.options.length; i++) {
            this.selections.push(false);
        }
    }

    handleSelectEvent(event) {
        let index = event.target.dataset.index;
        this.selectToggle(this.isMultipleChoice(), index);
    }
    isMultipleChoice() {
        if (this.question && this.question.hasOwnProperty("type")) {
            let type = this.question.type;
            return (type == "MC");
        }
    }

    selectToggle(isMultipleChoice, optionIndex) {
        if (isMultipleChoice) {
            this.selections[optionIndex] = !this.selections[optionIndex];
        } else {
            this.clearSelections();
            this.selections[optionIndex] = optionIndex;
        }
    }
    clearSelections() {
        for (let index in this.selections) {
            this.selections[index] = false;
        }   
    }
    
    passToParent() {
        console.log(this.selections);
    }

    get optionList() {
        for (let i = 0; i < this.question.options.length; i++) {
            this.question.options[i].selected = this.selections[i];
        }
        console.log(this.question.options);
        return this.question.options;
    }

    // Question1 = "Posuere lorem ipsum dolor sit amet consectetur adipiscing elit?"
    // QuestionNumber = "1";

    // // receive anwser value from answers component
    // handleChild(event) {
    //     console.log(event.detail);
    // }
}

