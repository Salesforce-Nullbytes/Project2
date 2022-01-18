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

                if (currentCount > 0) {
                    O.addError('Error: There is already a draft order in progress');
                }
            }
        }

        List<Order> existingDrafts =  [SELECT AccountID, status FROM order WHERE Order.AccountID IN :newOrderAccountIDs.keyset() AND status = 'Draft'];
        if (existingDrafts.size() == 0) return;
        for (Order O : newOrders) {
            for (Order e : existingDrafts) {
                if (O.accountid == e.accountid) {
                    O.addError('Error: There is already a draft order in progress');
                }
            }
        }  
    }

    //Before Update
    public static void PreventChanges (List<Order> originalOrders, Map<ID, Order> updatedOrders)  {
        For (Order O : originalOrders) {
            if (O.status == 'Activated') {
                updatedOrders.get(O.id).addError('Error: You cannot make changes to an activated order');
            }
        } 
    }
}