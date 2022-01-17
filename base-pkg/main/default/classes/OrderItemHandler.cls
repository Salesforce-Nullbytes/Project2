public without sharing class OrderItemHandler {
    //Before Insert & After Undelete
    public static void PreventAddingExistingItem (List<OrderItem> newOrderItems)  {   

        for (OrderItem newO : newOrderItems) {
            ID myOrderID = newO.OrderID;
            for (OrderItem item : [SELECT id, product2id FROM OrderItem WHERE Order.id = :myOrderID]) {
                if (item.product2id == newO.product2id) {
                    newO.addError('Error: This item is already in the cart');
                }
            }
        }
    }

    public static void PreventAddingSameItemTwice (List<OrderItem> newOrderItems)  {   

        Set<string> newProductIDs = new Set<string>();
        for (OrderItem O : newOrderItems) {
            if (newProductIDs.contains(O.product2id)) {
                O.addError('Error: This item is already in the cart');
            }
            newProductIDs.add(O.product2id);
        }
    }

    public static void SetUnitPrice (List<OrderItem> newOrderItems)  {

        Set<ID> pricebookEntryIDs = new Set<ID>();
        Map<ID, Decimal> unitPriceForProduct = new Map<ID, Decimal>();

        for (OrderItem O : newOrderItems) {
            pricebookEntryIDs.add(O.pricebookEntryID);
        }

        for (PricebookEntry pbEntry : [SELECT unitprice FROM PricebookEntry WHERE id IN : pricebookEntryIDs]) {
            unitPriceForProduct.put(pbEntry.id, pbEntry.unitprice);
        }

        for (OrderItem O : newOrderItems) {
            O.unitprice = unitPriceForProduct.get(O.pricebookEntryID);
        }
    }

    //Before Update
    public static void PreventChanges (List<OrderItem> updatedOrderItems)  {

        Map<ID, Boolean> orderActivated = new Map<ID, Boolean>();

        for (OrderItem O : updatedOrderItems) {
            orderActivated.put(O.OrderID, false);
        } 

        for (Order O : [SELECT status FROM order WHERE id IN : orderActivated.keySet() AND status = 'Activated']) {
            orderActivated.put(O.id, true);
        }

        for (OrderItem O : updatedOrderItems) {
            if (orderActivated.get(O.orderID)) {
                O.addError('Error: You cannot make changes to an activated order');
            }
        } 
    }
}
