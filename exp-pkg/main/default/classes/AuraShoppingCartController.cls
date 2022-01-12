public without sharing class AuraShoppingCartController {

    @AuraEnabled
    public static List<orderItem> GetCartItems() {
        id acctID = getAccountID();

        system.debug(acctID);

        List<orderItem> items = [
            SELECT id, unitprice, quantity, order.accountID, order.status, order.isdeleted, product2.name, product2.productcode, product2.subvariety__c, 
            product2.size__c, product2.light_level__c, product2.ispetfriendly__c, product2.hasvarieties__c, product2.hasflowers__c, product2.hascolor__c, 
            product2.difficulty__c 
            FROM orderItem 
            WHERE Order.AccountID = :acctID AND order.status = 'Draft' AND order.isdeleted = false
        ];

        system.debug(items.size());
        return items;
    }

    private static id getAccountID() {
        return [SELECT id FROM Account WHERE name = 'Account 5']?.id;
    }

    @AuraEnabled
    public static void updateCart(Id[] ListOfRemovedIds, Id[] ListOfChangedQuantityIds, Integer[] ListOfChangedQuantityInts){
        List<orderItem> removals = [SELECT id FROM orderItem WHERE id IN : ListOfRemovedIds];
        delete removals;

        // List<orderItems> updatesId = [SELECT id FROM orderItems WHERE id IN : ListOfChangedQuantityIds];
        // List<orderItems> updatesQuantity = [SELECT quantity FROM orderItems WHERE quantity IN : ListOfChangeQuantityInts];
        // update updatesId;
        // update updatesQuantity;

        List<orderItem> updates = new List<orderItem>();
        if (ListOfChangedQuantityIds.size() != ListOfChangedQuantityInts.size()) {
            system.debug('Error');
            return;
        }

        for (integer index = 0; index < ListOfChangedQuantityIds.size(); index++) {
            orderItem change = new orderItem();
            change.id = ListOfChangedQuantityIds[index];
            change.quantity = ListOfChangedQuantityInts[index];

            updates.add(change);
        }
        update updates;
    }
    
}
