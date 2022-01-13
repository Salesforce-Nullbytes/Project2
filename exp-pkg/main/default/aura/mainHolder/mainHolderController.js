({
    getHeaderValue : function(component, event, helper) {
        component.set("v.inputValue", event.getParam('value'));

        console.log(event.getParam('value'));
        console.log("{v.inputValue}");
        console.log(component.get("v.inputValue"));

        if (component.get("v.inputValue") == "Home") {
            console.log("-1");
            component.set("v.isHome", true);
            component.set("v.isShop", false);
            component.set("v.isForum", false);
            component.set("v.isCart", false);
            console.log("0");
        } else if (component.get("v.inputValue") == "Shop") {
            console.log("1");
            component.set("v.isHome", false);
            component.set("v.isShop", true);
            component.set("v.isForum", false);
            component.set("v.isCart", false);
            console.log("2");
        } else if (component.get("v.inputValue") == "Forum") {
            console.log("3");
            component.set("v.isHome", false);
            component.set("v.isShop", false);
            component.set("v.isForum", true);
            component.set("v.isCart", false);
            console.log("4");
        }else if (component.get("v.inputValue") == "Cart") {
            component.set("v.isHome", false);
            component.set("v.isShop", false);
            component.set("v.isForum", false);
            component.set("v.isCart", true);
        }
    }
})
