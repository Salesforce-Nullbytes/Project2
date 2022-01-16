trigger OrderItemTrigger on OrderItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    // switch on trigger.operationType {
    //     when BEFORE_INSERT {
    //         // ensure this product is not already in cart
    //         OrderItemHandler.PreventAddingSameOrderItem(trigger.new);

    //         // ensure the unit price = standard unit price
    //         OrderItemHandler.CheckUnitPrice(trigger.new);
    //     }
    //     when BEFORE_UPDATE {
    //         //prevent changes to order items if parent order is activated
    //         OrderItemHandler.PreventChanges(trigger.old, trigger.newMap);
    //     }
    //     when BEFORE_DELETE {} //already not possible to delete items from activated order 
    //     when AFTER_INSERT {} 
    //     when AFTER_UPDATE {}
    //     when AFTER_DELETE {}
    //     when AFTER_UNDELETE {
    //         // ensure this product is not already in cart (same as before_insert)
    //         OrderItemHandler.PreventAddingSameOrderItem(trigger.new);

    //         // set the unit price = standard unit price
    //         OrderItemHandler.SetUnitPrice(trigger.new);
    //     }
    // }
}