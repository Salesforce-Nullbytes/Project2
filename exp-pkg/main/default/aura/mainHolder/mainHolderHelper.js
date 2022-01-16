({
    ApexCartItems : function(component, helper) {
        let apexMethod = component.get("c.GetCartItems");

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let itemList = helper.SetItems(response.getReturnValue());  
                console.log('Item list is');
                console.log(itemList);
                component.set("v.cartItems", itemList);
            } else {
                console.log("callback not set");
            }
        });

        $A.enqueueAction(apexMethod);
    },
    parseItem(queryResult) {
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
    SetHeaderFields(component, event) {
        component.set("v.inputValue", event.getParam('value'));

        component.set("v.isHome", true);
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
