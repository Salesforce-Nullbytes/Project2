({
    Initialize : function(component, event, helper) {
        console.log("initialize is good");

        helper.refreshCart(component, helper);
    }, 

    TestPrint : function(component, event, helper) {
        console.log("hello we are here");
        let items = component.get("v.items");

        for (let item of items) {
            console.log(item);
        }
    },

    HandleRemove : function(component, event, helper) {
        let removeIndex = event.getParam('id');
        let items = component.get("v.items");

        items[removeIndex].remove = true; 
        component.set("v.items", items);
        component.set("v.pending", true);
    },
    
    HandleChangeQuantity : function(component, event, helper) {
        let changeIndex = event.getParam('id');
        let changeQuantity = event.getParam('quantity');
        let items = component.get("v.items");
        
        if (!items[changeIndex].originalQuantity) {
            items[changeIndex].originalQuantity = items[changeIndex].Quantity;
        }

        items[changeIndex].Quantity = changeQuantity;
        component.set("v.items", items);
        component.set("v.pending", true);
    }, 
    
    UpdateCart : function(component, event, helper) {
        if (!component.get("v.pending")) {
            return;
        }

        let items = component.get("v.items");

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
        helper.refreshCart(component, helper);
    },

    CheckOut : function(component, event, helper) {
        component.set("v.checkOutUnclicked", false);
    },

    PlaceOrder : function(component, event, helper) {
        component.set("v.placeOrderUnclicked", false);
        helper.UpdateOrderStatus(component, helper);
    },
})

