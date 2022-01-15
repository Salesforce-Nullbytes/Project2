public without sharing class AuraMainHolderController {
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
        return [SELECT id FROM Account WHERE name = 'Account 3']?.id;
    }
}