import { LightningElement, api, track } from 'lwc';
import AddToCart from "@salesforce/apex/LWCShopController.AddToCart";

export default class Shop extends LightningElement {
    // Filtered attribute inclusions
    hasFilters = false;
    @track
    filters = {
        Size__c: {
            source: "multiselect",
            settings: {
                Small: true,
                Medium: true,
                Large: true,
            },
        },
        Difficulty__c: {
            source: "multiselect",
            settings: {
                Easy: true,
                Regular: true,
                Hard: true,
            },
        },
        Light_Level__c: {
            source: "multiselect",
            settings: {
                Low: true,
                Indirect: true,
                Bright: true,
            },
        },
        HasColor__c: {
            source: "checkbox",
            settings: {
                HasColor__c: false,
            },
        },
        HasFlowers__c: {
            source: "checkbox",
            settings: {
                HasFlowers__c: false,
            },
        },
        IsPetFriendly__c: {
            source: "checkbox",
            settings: {
                IsPetFriendly__c: false,
            },
        },
    }
    getFilterValue(property, setting) {
        if (this.filters[property].source == 'multiselect')
            return this.filters[property].settings[setting];
        if (this.filters[property].source == 'checkbox')
            return setting || !this.filters[property].settings[property];
    }

    @api
    catalog;
    get filteredCatalog() {
        if (!this.catalog) {
            this.numDisplayed = 0;
            return [];
        }
        let listed = this.filterCatalog();
        this.numDisplayed = listed.length;
        return listed;
    }


    filterCatalog() {
        if (this.catalog.length == 0) return;

        let output = [];
        for (let product of this.catalog) {
            //console.log(product);
            let include = true;

            for (let param in this.filters) {
                if (!product.Product2.hasOwnProperty(param)) {
                    console.log("Product cannot be filtered by " + param + "...");
                    continue;
                }
                let productProperty = product.Product2[param];
                
                if (param == "Light_Level__c" && productProperty == "Any") {continue;}
                let shouldInclude = this.getFilterValue(param, productProperty);

                if (!shouldInclude) {
                    include = false;
                    break;
                }
            }
            if (include) {
                output.push(product);
            }
        }
        return output;
    }

    handleFilter() {
        let selections = this.template.querySelectorAll("select");
        let checkboxes = this.template.querySelectorAll("input[type=checkbox]");

        for (let selection of selections) {
            let includeAll = true;
            let property = selection.name;
            for (let parameter of selection.options) {
                this.setParameter(property, parameter.value, parameter.selected);
                if (parameter.selected) includeAll = false;
            }
            // If none in multiselect are chosen, show all (no filters set)
            if (includeAll) {
                for (let parameter of selection.options) {
                    this.setParameter(property, parameter.value, true);
                }
            }
        }
        for (let checkbox of checkboxes) {
            let property = checkbox.name;
            let parameter = checkbox.name;
            this.setParameter(property, parameter, checkbox.checked);
        }
        this.hasFilters = true;
    }
    setParameter(property, parameter, toValue) {
        if (!this.filters.hasOwnProperty(property)) {
            console.log("Unrecognized filter property: " + property);
            return;
        }
        let settings = this.filters[property].settings;
        if (!settings.hasOwnProperty(parameter)) {
            console.log("Unrecognized filter parameter: " + parameter);
            return;
        }
        this.filters[property].settings[parameter] = toValue;
    }

    handleAddToCart(event) {
        let productCode = event.detail.productCode;
        if (productCode == null) {
            console.log("No product!");
            return;
        }

        AddToCart({ productCode: productCode })
        .then((result) => {
            if (result) {
                this.informCartChange();
            } else {
                console.log("Order could not be added to cart.");
            }
        })
        .catch((error) => {
            console.log('Received an error: ' + JSON.stringify(error));
        });
    }
    
    informCartChange() {
        this.dispatchEvent(new CustomEvent('itemadd'));
    }
    handleClear() {
        this.dispatchEvent(new CustomEvent("valuechange", {
            detail: { value : "Shop" }
        }));
    }

    get hasProducts() {
        return this.numDisplayed == 0;
    }
}