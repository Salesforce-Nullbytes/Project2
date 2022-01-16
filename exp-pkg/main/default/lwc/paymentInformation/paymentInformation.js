import {LightningElement,api} from 'lwc';

export default class paymentInformation extends LightningElement {
    @api
    accountName;

    handleSubmitInfo() {
        let listOfCustomerInfo = this.template.querySelectorAll("input[type=text]");

        for (let i=0; i<listOfCustomerInfo.length; i++){
            if (listOfCustomerInfo[i].value != "") {
                listOfCustomerInfo[i].classList.remove("notSubmitted")
                listOfCustomerInfo[i].classList.add("submitted");
            } else {
                listOfCustomerInfo[i].classList.add("notSubmitted");
                listOfCustomerInfo[i].classList.remove("submitted");
            }
        }

        let params = {};
        for (let element of listOfCustomerInfo) {
            if (element.value == "") {
                return;
            }

            let field = element.name;
            params[field] = element.value;
        }

        this.dispatchEvent(new CustomEvent('submitInfo', { detail: {data: params} }));
    }   
}
