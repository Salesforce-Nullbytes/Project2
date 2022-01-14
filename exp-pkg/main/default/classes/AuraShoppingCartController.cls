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
        return [SELECT id FROM Account WHERE name = 'Account 1']?.id;
    }

    @AuraEnabled
    public static void updateCart(Id[] ListOfRemovedIds, Id[] ListOfChangedQuantityIds, Integer[] ListOfChangedQuantityInts){
        List<orderItem> removals = [SELECT id FROM orderItem WHERE id IN : ListOfRemovedIds];
        delete removals;

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

    @AuraEnabled
    public static void changeOrderStatus(String address, String city, String state, String zipcode, String cardnumber, String exp, String cvv, String billingzipcode) {
        account myAccount = [SELECT billingpostalcode, shippingstreet, shippingcity, shippingstate, shippingpostalcode FROM account WHERE id = :getAccountID() LIMIT 1];
        if (myAccount == null) {
            system.debug('No account');
            return;
        }

        myAccount.billingpostalcode = billingzipcode;
        myAccount.shippingStreet = address;
        myAccount.shippingcity = city;
        myAccount.shippingstate = state;
        myAccount.shippingpostalcode = zipcode;

        system.debug(cardnumber + exp + cvv);
        update myAccount;


        order completedOrder = [SELECT status FROM order WHERE Order.AccountID = :getAccountID() AND order.status = 'Draft' AND order.isdeleted = false LIMIT 1];
        completedOrder.status = 'Activated';
        update completedOrder;
    }
}
