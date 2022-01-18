import {LightningElement, api} from 'lwc';
import quizIconBackground1 from '@salesforce/resourceUrl/quizIconBackground1';
import quizIconBackground2 from '@salesforce/resourceUrl/quizIconBackground2';
import quizIconBackground3 from '@salesforce/resourceUrl/quizIconBackground3';

export default class homepageQuizIcons extends LightningElement {

    backgroundRendered = false;

    @api
    quizTitle = "Find your plant match";

    @api
    quizNumber;

    quizOdd = true;

    get isQuizOdd() {
        if (this.quizNumber % 2 != 0) {
            return true;
        } else {
            return false;
        }
    }

    renderedCallback() {
        if (this.backgroundRendered) {
            return;
        } 

        let container = this.template.querySelectorAll(".container");

        if (this.quizNumber == 1){
            container[0].style.backgroundImage = `url(${quizIconBackground1})`;
        } else if (this.quizNumber == 2) {
            container[0].style.backgroundImage = `url(${quizIconBackground2})`;
        } else {
            container[0].style.backgroundImage = `url(${quizIconBackground3})`;
        }

        this.backgroundRendered = true;
    }

    clickTakeQuiz() {
        const event = new CustomEvent('chooseQuiz', {
            detail: this.quizNumber,
        });

        this.dispatchEvent(event);
    }
}
