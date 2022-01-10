import {LightningElement} from 'lwc';

export default class answers extends LightningElement {
    answerValue = 0;

    myAnswers= [
        { name: "a. Ut enim ad minim veniam, quis nostrud exercitation.", value: 1},
        { name: "b. Duis aute irure dolor in reprehenderit in voluptate.", value: 2},
        { name: "c. Excepteur sint occaecat cupidatat non proident.", value: 3},
        { name: "d. Sunt in culpa qui officia deserunt mollit anim id.", value: 4}
    ];

    // when an answer is selected on the quiz
    handleAnswerSelect(event) {
        let Multiselect = false;
        let selectedAnswer = event.currentTarget;
        let allAnswers = this.template.querySelectorAll(".info");
        let selectedIndex = event.target.dataset.index;

        // if more than one answer can be selected
        if (Multiselect == true) {
            if (selectedAnswer.classList.contains("selected")) {
                    selectedAnswer.classList.remove("selected");
            } else {
                selectedAnswer.classList.add("selected");
            }
        }

        // if only one answer can be selected
        else {
            for (let i = 0; i < allAnswers.length; i++) {
                allAnswers[i].classList.remove("selected");
            }

            selectedAnswer.classList.add("selected");
        } 

        // return value of answer selected
        this.answerValue = this.myAnswers[selectedIndex].value;
        return this.answerValue;

    }


    // pass the value of the answer to the parent
    passToParent() {
        const event = new CustomEvent('child', {
            detail: this.answerValue
        });

        this.dispatchEvent(event);
    }
        
}