trigger OrderTrigger on Order (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on trigger.operationType {
        when BEFORE_INSERT {
            //prevent multiple draft orders on an account
            OrderHandler.PreventMultipleDrafts(trigger.new);

            //if pricebook == null, set to standard DO IT WITH A FLOW
        }
        when BEFORE_UPDATE {
            //prevent changes to an already activated order
            OrderHandler.PreventChanges(trigger.old, trigger.newMap);
        }
        when BEFORE_DELETE {} 
        when AFTER_INSERT {}
        when AFTER_UPDATE {}
        when AFTER_DELETE {}
        when AFTER_UNDELETE {
            //prevent multiple draft orders on an account
            OrderHandler.PreventMultipleDrafts(trigger.new);

            //if pricebook == null, set to standard DO IT WITH A FLOW
        }
    }
}