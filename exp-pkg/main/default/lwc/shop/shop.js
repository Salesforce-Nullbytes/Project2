import { LightningElement, track, wire } from 'lwc';
import AllProducts from "@salesforce/apex/LWCShopController.AllProducts";
import AddToCart from "@salesforce/apex/LWCShopController.AddToCart";
import OrderedProducts from "@salesforce/apex/LWCShopController.OrderedProducts";

export default class Shop extends LightningElement {
    @wire(AllProducts)
    catalog;
    @wire(OrderedProducts)
    cartItems;

    displayData;

    get hasProducts() {
        if (!this.catalog.data || !this.catalog.data) { return false; }
        return true;
    }
    get cartData() {
        if (!this.catalog.data) { return null; }
        if (!this.cartItems.data) { return this.catalog.data; }

        this.displayData = [];
        for (let product of this.catalog.data) {
            let obj = {};
            for (let prop in product) {
                obj[prop] = product[prop];
            }

            let code = obj.Product2.ProductCode;
            if (!code) { continue; }
            for (let item of this.cartItems.data) {
                obj.inCart = (item.Product2.ProductCode == code);
            }
            this.displayData.push(obj);
        }
        console.log(this.displayData);
        return this.displayData;
    }

    handleAddToCart(event) {
        let productCode = event.detail.productCode;
        if (productCode == null) {
            console.log("No product!");
            return;
        }

        AddToCart({ productCode: productCode })
        .then((result) => {
            console.log("Have changes occurred? " + result);
            for (let item of this.catalog.data) {
                if (item.Product2.ProductCode == productCode) {
                    item.inCart = true;
                }
            }
        })
        .catch((error) => {
            console.log('Received an error: ' + JSON.stringify(error));
        });
    }

}