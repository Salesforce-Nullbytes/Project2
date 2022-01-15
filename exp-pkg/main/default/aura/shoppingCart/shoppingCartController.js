({
    HandleRemove : function(component, event, helper) {
        let removeIndex = event.getParam('id');
        let items = component.get("v.cartData");

        items[removeIndex].remove = true; 
        component.set("v.cartData", items);
        component.set("v.flipPending", true);
    },
    
    HandleChangeQuantity : function(component, event, helper) {
        let changeIndex = event.getParam('id');
        let changeQuantity = event.getParam('quantity');
        let items = component.get("v.cartData");

        if (changeQuantity < 1) { changeQuantity = 1; }
        
        if (!items[changeIndex].originalQuantity) {
            items[changeIndex].originalQuantity = items[changeIndex].Quantity;
        }

        items[changeIndex].Quantity = changeQuantity;

        if (items[changeIndex].originalQuantity == changeQuantity) {
            items[changeIndex].originalQuantity = null;
        }

        component.set("v.cartData", items);
        component.set("v.flipPending", true);
    }, 
    
    UpdateCart : function(component, event, helper) {
        if (!component.get("v.flipPending")) {
            return;
        }

        let items = component.get("v.cartData");

        let toBeRemoved = [];
        let toBeUpdated = [];
        let newQuantity = [];
        

        for (let item of items) {
            if (item.remove) { 
                 toBeRemoved.push(item.Id);
            }

            if (item.hasOwnProperty("originalQuantity")) { 
                toBeUpdated.push(item.Id);
                newQuantity.push(item.Quantity);
            }
        }

        helper.SendCartToServer(component, toBeRemoved, toBeUpdated, newQuantity, helper);
    },

    CancelChanges : function(component, event, helper) {
        helper.refreshCart(component, false);
    },

    CheckOut : function(component, event, helper) {
        component.set("v.checkOutUnclicked", false);
    },

    PlaceOrder : function(component, event, helper) {
        helper.ServerActivateOrder(component, event);
    },
})

