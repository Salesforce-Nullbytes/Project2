import {LightningElement,api} from 'lwc';

export default class paymentInformation extends LightningElement {
    @api
    accountName;

    handleSubmitInfo() {
        let listOfCustomerInfo = this.template.querySelectorAll("input[type=text]");

        // let customerAddress = listOfCustomerInfo[0].value;
        // let customerCity = listOfCustomerInfo[1].value;
        // let customerState = listOfCustomerInfo[2].value;
        // let customerZipCode = listOfCustomerInfo[3].value;
        // let customerCardNumber = listOfCustomerInfo[4].value;
        // let customerExp = listOfCustomerInfo[5].value;
        // let customerCVV = listOfCustomerInfo[6].value;
        // let customerBillingZipCode = listOfCustomerInfo[7].value;

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
            if (element.value == null) {
                return;
            }

            let field = element.name;
            params[field] = element.value;
        }

        this.dispatchEvent(new CustomEvent('submitInfo', { detail: {data: params} }));
    }   
}
