import {LightningElement} from 'lwc';

export default class questions extends LightningElement {

    Question1 = "Posuere lorem ipsum dolor sit amet consectetur adipiscing elit?"
    QuestionNumber = "1";

    // receive anwser value from answers component
    handleChild(event) {
        console.log(event.detail);
    }
}

