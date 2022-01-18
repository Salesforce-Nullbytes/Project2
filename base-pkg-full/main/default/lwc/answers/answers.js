import {LightningElement, api} from 'lwc';

export default class answers extends LightningElement {

    @api
    option={text:"Water",result: true};

    @api
    isSelected = false;

    get selectedStyle() {
        return this.isSelected ? 'info selected' : 'info';
    }
    // // when an answer is selected on the quiz
    // handleAnswerSelect(event) {
    //     let selectedAnswer = event.currentTarget;
    //     let allAnswers = this.template.querySelectorAll(".info");
    //     let selectedIndex = event.target.dataset.index;

    //     // if more than one answer can be selected
    //     if (Multiselect == true) {
    //         if (selectedAnswer.classList.contains("selected")) {
    //                 selectedAnswer.classList.remove("selected");
    //         } else {
    //             selectedAnswer.classList.add("selected");
    //         }
    //     }

    //     // if only one answer can be selected
    //     else {
    //         for (let i = 0; i < allAnswers.length; i++) {
    //             allAnswers[i].classList.remove("selected");
    //         }

    //         selectedAnswer.classList.add("selected");
    //     } 

    //     // return value of answer selected
    //     this.answerValue = this.option[selectedIndex].value;
    //     return this.answerValue;

    // }

    // pass the value of the answer to the parent
    handleSelect() {
        const event = new CustomEvent('choose', {
            detail: this.option.result,
        });

        this.dispatchEvent(event);
    }
        
}