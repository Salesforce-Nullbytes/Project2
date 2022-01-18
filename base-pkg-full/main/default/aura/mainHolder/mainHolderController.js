({
    Initialize : function(component, event, helper) {
        helper.ApexCatalogData(component, helper);
        helper.ApexCartItems(component, helper);
    }, 
    getHeaderValue : function(component, event, helper) {
        helper.SetHeaderFields(component, event);
    }, 
    HandleCartEvent: function (component, event, helper) {
        helper.ApexCartItems(component, helper);
    }, 
    HandleCartPendingEvent: function (component, event, helper) {
        let newStatus = event.getParam('changePending');
        component.set("v.cartPending", newStatus);
    }

})
