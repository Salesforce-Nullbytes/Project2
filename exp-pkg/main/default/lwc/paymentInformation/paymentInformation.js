import {LightningElement,api} from 'lwc';

export default class paymentInformation extends LightningElement {
    @api
    accountName;

    // Validation
    validationError1 = false;
    validationError2 = false;

    blankInfo1= false;
    blankInfo2 = false;

    shippingZipError = false;
    cardNumberError = false;
    expError = false;
    cvvError = false;
    billingZipError = false;
    

    ccvRegex = /^[0-9]{3,4}$/;
    zipcodeRegex = /^[0-9]*$/;
    expRegex = /^(0[1-9]|1[0-2])\/?([0-9]{2})$/;
    cardRegex=/^[0-9]{16}$/;

    handleSubmitInfo() {
        let listOfCustomerInfo = this.template.querySelectorAll("input[type=text]");

        this.validationError1 = false;
        this.validationError2 = false;

        this.blankInfo1 = false;
        this.blankInfo2 = false;

        this.shippingZipError = false;
        this.cardNumberError = false;
        this.expError = false;
        this.cvvError = false;
        this.billingZipError = false;

        for (let i=0; i<listOfCustomerInfo.length; i++){
            if (listOfCustomerInfo[i].value != "") {
                listOfCustomerInfo[i].classList.remove("notSubmitted")
                listOfCustomerInfo[i].classList.add("submitted");
                
                //Shipping Zipcode Validation
                if (i == 3) {
                    if (!this.zipcodeRegex.test(listOfCustomerInfo[i].value)) {
                        this.validationError1 = true;
                        this.shippingZipError = true;
                    }
                }

                //Card Number
                if (i == 4) {
                    if (!this.cardRegex.test(listOfCustomerInfo[i].value)) {
                        this.validationError2 = true;
                        this.cardNumberError = true;
                    }
                } 

                //Exp Validation
                if (i == 5) {
                    if (!this.expRegex.test(listOfCustomerInfo[i].value)) {
                        this.validationError2 = true;
                        this.expError = true;
                    }
                } 

                //CVV Validation
                if (i == 6) {
                    if (!this.ccvRegex.test(listOfCustomerInfo[i].value)) {
                        this.validationError2 = true;
                        this.cvvError = true;
                    }
                } 
                
                //Billing Zipcode Validation
                if (i == 7) {
                    if (!this.zipcodeRegex.test(listOfCustomerInfo[i].value)) {
                        this.validationError2 = true;
                        this.billingZipError = true;
                    }
                }

            } else {
                listOfCustomerInfo[i].classList.add("notSubmitted");
                listOfCustomerInfo[i].classList.remove("submitted");

                if (i < 5) {
                    this.blankInfo1 = true;
                } else {
                    this.blankInfo2 = true;
                }
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
