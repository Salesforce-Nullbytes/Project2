import {LightningElement} from 'lwc';
import quizIconBackground1 from '@salesforce/resourceUrl/quizIconBackground1';

export default class homepageQuizIcons extends LightningElement {
    quizIconBackground1 = quizIconBackground1;

    backgroundRendered = false;

    renderedCallback() {
        if (this.backgroundRendered) {
            return;
        } 

        let container = this.template.querySelectorAll(".container");
        console.log(container.length);
        container[0].style.backgroundImage = `url(${quizIconBackground1})`;

        this.backgroundRendered = true;
    }
}
