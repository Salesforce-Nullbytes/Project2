import {LightningElement} from 'lwc';

export default class paymentInformation extends LightningElement {
    handleSubmitInfo() {
        let listOfCustomerInfo = this.template.querySelectorAll("input[type=text]");

        let customerName = listOfCustomerInfo[0].value;
        let customerAddress = listOfCustomerInfo[1].value;
        let customerCity = listOfCustomerInfo[2].value;
        let customerState = listOfCustomerInfo[3].value;
        let customerZipCode = listOfCustomerInfo[4].value;
        let customerCardNumber = listOfCustomerInfo[5].value;
        let customerExp = listOfCustomerInfo[6].value;
        let customerCVV = listOfCustomerInfo[7].value;
        let customerBillingZipCode = listOfCustomerInfo[8].value;

        for (let i=0; i<listOfCustomerInfo.length; i++){
            if (listOfCustomerInfo[i].value != "") {
                listOfCustomerInfo[i].classList.remove("notSubmitted")
                listOfCustomerInfo[i].classList.add("submitted");
            } else {
                listOfCustomerInfo[i].classList.add("notSubmitted");
                listOfCustomerInfo[i].classList.remove("submitted");
            }
        }
    }   
}
