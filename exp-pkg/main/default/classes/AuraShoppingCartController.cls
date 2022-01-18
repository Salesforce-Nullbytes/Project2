public without sharing class AuraShoppingCartController {


    @TestVisible
    public static ID getAccountId() {
        ID currentUserId = UserInfo.getUserId();
        return [SELECT id, Contact.AccountId FROM User WHERE id = :currentUserId]?.Contact.AccountId;
    }

    @AuraEnabled
    public static void updateCart(Id[] ListOfRemovedIds, Id[] ListOfChangedQuantityIds, Integer[] ListOfChangedQuantityInts){
        List<orderItem> removals = [SELECT id FROM orderItem WHERE id IN : ListOfRemovedIds AND order.AccountID = :getAccountId()];
        delete removals;

        List<orderItem> updates = new List<orderItem>();
        if (ListOfChangedQuantityIds.size() != ListOfChangedQuantityInts.size()) {
            system.debug('Error');
            return;
        }

        List<OrderItem> existing = [SELECT order.AccountID, quantity FROM OrderItem WHERE id IN : ListOfChangedQuantityIds AND order.AccountID = :getAccountId()];

        Set<ID> existingIDs = new Set<ID>();

        for (OrderItem exists : existing) {
            existingIDs.add(exists.id);    
        }

        for (integer index = 0; index < ListOfChangedQuantityIds.size(); index++) {
            if (!existingIDs.contains(ListOfChangedQuantityIds[index])) {
                system.debug('Error: Cannot change quantity of item not in cart');
                return;
            }

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

        myAccount.Billing_Zipcode__c = billingzipcode;
        myAccount.shippingStreet = address;
        myAccount.shippingcity = city;
        myAccount.shippingstate = state;
        myAccount.Shipping_Zipcode__c = zipcode;
        myAccount.CVV__c = cvv;
        myAccount.exp__c = exp;
        myAccount.Card_Number__c = cardnumber;

        update myAccount;


        order completedOrder = [SELECT status FROM order WHERE Order.AccountID = :getAccountID() AND order.status = 'Draft' AND order.isdeleted = false LIMIT 1];
        completedOrder.status = 'Activated';
        update completedOrder;
    }
}
