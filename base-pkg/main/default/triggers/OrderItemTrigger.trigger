trigger OrderItemTrigger on OrderItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on trigger.operationType {
        when BEFORE_INSERT {
            // ensure this product is not already in cart
            OrderItemHandler.PreventAddingExistingItem(trigger.new);

            // ensure two identical items aren't added at the same time
            OrderItemHandler.PreventAddingSameItemTwice(trigger.new);

            // set the unit price = standard unit price
            OrderItemHandler.SetUnitPrice(trigger.new);
        }
        when BEFORE_UPDATE {
            //prevent changes to order items if parent order is activated
            OrderItemHandler.PreventChanges(trigger.new);
        }
        when BEFORE_DELETE {} //already not possible to delete items from activated order 
        when AFTER_INSERT {} 
        when AFTER_UPDATE {}
        when AFTER_DELETE {}
        when AFTER_UNDELETE {} //Order Item undeletes are not possible
    }
}