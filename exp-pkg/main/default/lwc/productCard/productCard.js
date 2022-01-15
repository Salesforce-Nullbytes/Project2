import { LightningElement, api } from 'lwc';
import productImage from '@salesforce/resourceUrl/productimage';
import ShopImages from '@salesforce/resourceUrl/ShopImages';

export default class ProductCard extends LightningElement {
    showDetails = false;
    qtyHolder = 0;

    available() {
        return (this.dataParser('UnitPrice') != null);
    }
    needUpdate() {
        let origQuantity = this.dataParser('originalQuantity');
        return !(origQuantity == null) && (this.dataParser('Quantity') != origQuantity)
    }
    isInCart() {
        return this.dataParser('inCart');;
    }

    @api
    accessId = -1;
    @api
    isCartItem = false;
    
    
    get setImage() {
        let img = { link: productImage, alt:'Generic Product Image'};
        if (this.dataParser('ProductCode')) {
            img.link = ShopImages + '/shopPlantImages/' + this.dataParser('ProductCode') + '.png';
            img.alt = 'Image of ' + this.dataParser('Name');
        }
        return img;
    }
    
    @api
    itemData = {
        Product2: {
            Name: 'Ficus',
            ProductCode: 'P000MRB',
            HasVarieties__c: true,
            SubVariety__c: 'Burgundy and dark Green',
            Size__c: 'Medium',
            Difficulty__c: 'Regular',
            Light_Level__c: 'Bright',
            IsPetFriendly__c: false,
            HasColor__c: true,
            HasFlowers__c: false,
        },
        //UnitPrice: 25.03,
        Quantity: 7,
        inCart: true
    };
    dataParser(property) {
        if (!this.itemData) { return null; }

        if (property === "UnitPrice" 
            || property === "Quantity" 
            || property === "originalQuantity" 
            || property === 'inCart') {
            if (!this.itemData.hasOwnProperty(property)) { return null; }
            return this.itemData[property];
        }

        if (!this.itemData.hasOwnProperty("Product2")) { return null; }
        if (!this.itemData.Product2.hasOwnProperty(property)) { return null; }
        return this.itemData.Product2[property];
    }

    // Data Bindings
    get fullName() {
        let name = this.dataParser('Name') || 'Basic Product';
        if (this.dataParser('HasVarieties__c')) {
            name += ': ' + this.dataParser('SubVariety__c');
        }
        return name;
    }
    get itemName() {
        return this.dataParser('Name') || 'Basic Product';
    }
    get variantName() {
        return this.dataParser('SubVariety__c') || '';
    }
    get unitPrice() {
        let price = 'Not Available';
        if (this.dataParser('UnitPrice')) {
            price = '$' + this.dataParser('UnitPrice');
            if (this.isCartItem) {
                price += ' each';
            }
        }
        return price;
    }
    get cartQuantity() {
        return this.dataParser('Quantity') || 0;
    }
    get cartTotal() {
        let q = this.dataParser('Quantity');
        let p = this.dataParser('UnitPrice');
        if (p && q) {
            return 'Subtotal: $' + (p*q);
        }
        return 'No Charge';
    }
    get productCode() {
        return this.dataParser('ProductCode') || 'Unknown';
    }
    get hasVarieties() {
        return this.dataParser('HasVarieties__c') || 'Unknown';
    }
    get hasColor() {
        return this.dataParser('HasColor__c') || 'Unknown';
    }
    get hasFlowers() {
        return this.dataParser('HasFlowers__c') || 'Unknown';
    }
    get isPetFriendly() {
        return this.dataParser('IsPetFriendly__c') || 'Unknown';
    }
    get lightLevel() {
        return this.dataParser('Light_Level__c') || 'Unknown';
    }
    get difficulty() {
        return this.dataParser('Difficulty__c') || 'Unknown';
    }
    get plantSize() {
        return this.dataParser('Size__c') || 'Unknown';
    }

    // Interactivity
    handleDetails() {
        this.showDetails = !this.showDetails;
    }

    // Events
    changeQuantity(event) {
        this.dispatchEvent(new CustomEvent('changequantity', {
            detail: { id: this.accessId,
                quantity: event.target.value,
            },
        }));
    }
    clickRemove(event) {
        this.dispatchEvent(new CustomEvent('remove', {
            detail: { id: this.accessId, },
        }));
    }
    clickAdd(event) {
        if (this.isInCart()) return;
        this.dispatchEvent(new CustomEvent('additem', {
            detail: { 
                id: this.accessId, 
                productCode: this.dataParser('ProductCode'),
            },
        }));
    }

    // Class and render fields
    get cssClass() {
        return this.isCartItem ? 'product cart' : 'product shop';
    }
    get changeClass() {
        return this.needUpdate() ? 'must-update' : 'in-sync';
    }
    get priceClass() {
        return this.available() ? 'shop-price' : 'shop-price unavailable';
    }
    get btnDetails() {
        return this.showDetails ? 'Less' : 'Details';
    }
    get addButtonLabel() {
        return this.isInCart() ? '✔' : 'Add';
    }
    get addButtonStyle() {
        return this.isInCart() ? 'add-inactive' : 'add-active';
    }
}