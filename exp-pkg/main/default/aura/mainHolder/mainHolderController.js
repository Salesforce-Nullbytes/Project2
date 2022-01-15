({
    Initialize : function(component, event, helper) {
        helper.ApexCartItems(component, helper);
    }, 
    getHeaderValue : function(component, event, helper) {
        component.set("v.inputValue", event.getParam('value'));

        if (component.get("v.inputValue") == "Home") {
            component.set("v.isHome", true);
            component.set("v.isShop", false);
            component.set("v.isForum", false);
            component.set("v.isCart", false);
        } else if (component.get("v.inputValue") == "Shop") {
            component.set("v.isHome", false);
            component.set("v.isShop", true);
            component.set("v.isForum", false);
            component.set("v.isCart", false);
        } else if (component.get("v.inputValue") == "Forum") {
            component.set("v.isHome", false);
            component.set("v.isShop", false);
            component.set("v.isForum", true);
            component.set("v.isCart", false);
        }else if (component.get("v.inputValue") == "Cart") {
            component.set("v.isHome", false);
            component.set("v.isShop", false);
            component.set("v.isForum", false);
            component.set("v.isCart", true);
        }
    }, 
    HandleCartEvent: function (component, event, helper) {
        helper.ApexCartItems(component, helper);
    }, 

    HandleCartPendingEvent: function (component, event, helper) {
        let newStatus = event.getParam('changePending');
        component.set("v.cartPending", newStatus);
    }

})
