({
    ApexCatalogData : function(component, helper) {
        let apexMethod = component.get("c.AllProducts");

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                component.set("v.productList", response.getReturnValue());
            } else {
                console.log("Error retrieving product catalog!");
            }
        });

        $A.enqueueAction(apexMethod);
    },
    ApexCartItems : function(component, helper) {
        let apexMethod = component.get("c.GetCartItems");

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let itemList = helper.SetItems(response.getReturnValue());  
                component.set("v.cartItems", itemList);

                //determine if cart is empty
                console.log(itemList.length);
                if (itemList.length == 0) {
                    component.set("v.cartEmpty1", true);
                } else {
                    component.set("v.cartEmpty1", false);
                }

                console.log(component.get("v.cartEmpty1"));

                helper.SetShopCatalog(component, itemList);
            } else {
                console.log("callback not set");
            }
        });

        $A.enqueueAction(apexMethod);
    },
    parseItem: function(queryResult) {
        let item = {};
        
        // Standard OrderItem fields
        item.UnitPrice = queryResult.UnitPrice;
        item.Quantity = queryResult.Quantity;
        item.Id = queryResult.Id;
        item.remove = false;
        
        //Parent Product2 fields
        let product = {};
        for (let key in queryResult.Product2) {
            product[key] = queryResult.Product2[key];
        }
        item.Product2 = product;

        return item;
    },
    SetItems : function(query) {
        let itemList = [];
        for (let result of query) {
            let item = this.parseItem(result);
            itemList.push(item);
        }

        return itemList;
    },
    SetShopCatalog: function(component, cartList) {
        let cartKey = {};
        for (let item of cartList) {
            cartKey[item.Product2.ProductCode] = true;
        }

        let catalog = this.SetItems(component.get("v.productList"));
        for (let item of catalog) {
            let code = item.Product2.ProductCode;
            if (cartKey.hasOwnProperty(code)) {
                item.inCart = cartKey[code];
            }
        }
        component.set("v.shopCatalog", catalog);
    },
    SetHeaderFields: function(component, event) {
        component.set("v.inputValue", event.getParam('value'));

        component.set("v.isHome", false);
        component.set("v.isShop", false);
        component.set("v.isForum", false);
        component.set("v.isCart", false);

        switch (component.get("v.inputValue")) {
            case "Home":
                component.set("v.isHome", true);
                break;
            case "Shop":
                component.set("v.isShop", true);
                break;
            case "Forum":
                component.set("v.isForum", true);
                break;
            case "Cart":
                component.set("v.isCart", true);
                break;
            default:
                console.log("Error: Unrecognized navigation target!");
        }
    }
})
