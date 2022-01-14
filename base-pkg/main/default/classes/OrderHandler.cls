public without sharing class OrderHandler {
    //Before Insert & After Undelete
    public static void PreventMultipleDrafts (List<Order> newOrders)  {

        Map<ID, Integer> newOrderAccountIDs = new Map<ID, Integer>();

        for (Order O : newOrders) {
            ID Acct = O.AccountID;

            if (!newOrderAccountIDs.containskey(Acct)) {
                newOrderAccountIDS.put(Acct, 0);
            }

            if (O.status == 'Draft') {
                Integer currentCount = newOrderAccountIDs.get(Acct);
                newOrderAccountIDs.put(Acct, currentCount+1);

                if (currentCount > 1) {
                    O.addError('Error: There is already a draft order in progress');
                }
            }
        }

        List<Order> existingDrafts =  [SELECT AccountID, status FROM order WHERE Order.AccountID = :newOrderAccountIDs.keyset() AND status = 'Draft'];

        For (Order O : existingDrafts) {
            O.addError('Error: There is already a draft order in progress');
        }  
    }

    public static void SetEffectiveDate (List<Order> newOrders)  {
        for(Order O : newOrders) {
            O.EffectiveDate = date.today();
        }
    }


    //Before Update
    public static void PreventChanges (List<Order> updatedOrders)  {
        For (Order O : updatedOrders) {
            if (O.status == 'Activated') {
                O.addError('Error: You cannot make changes to an activated order');
            }
        } 
    }


    //Before Delete
    // public static void PreventDelete (List<Order> deletedOrders)  {
    //     For (Order O : deletedOrders) {
    //         if (O.status == 'Activated') {
    //             O.addError('Error: You cannot delete an activated order');
    //         }
    //     } 
    // }
}
