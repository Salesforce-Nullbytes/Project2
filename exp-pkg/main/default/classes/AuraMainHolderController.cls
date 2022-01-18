public without sharing class AuraMainHolderController {
    @AuraEnabled
    public static Account GetMyAccount(){
        return [SELECT Id, Name FROM Account WHERE Id = :getAccountId() LIMIT 1];
    }
    
    @AuraEnabled
    public static List<orderItem> GetCartItems() {
        id acctID = getAccountID();

        List<orderItem> items = [
            SELECT id, unitprice, quantity, order.accountID, order.status, order.isdeleted, product2.name, product2.productcode, product2.subvariety__c, 
            product2.size__c, product2.light_level__c, product2.ispetfriendly__c, product2.hasvarieties__c, product2.hasflowers__c, product2.hascolor__c, 
            product2.difficulty__c 
            FROM orderItem 
            WHERE Order.AccountID = :acctID AND order.status = 'Draft' AND order.isdeleted = false
        ];

        return items;
    }
        
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> AllProducts() {
        PricebookEntry[] products = [
            SELECT Id, FORMAT(UnitPrice), Product2.Name, Product2.SubVariety__c, 
                Product2.HasVarieties__c, Product2.Size__c, Product2.Difficulty__c, Product2.Light_Level__c, 
                Product2.HasColor__c, Product2.HasFlowers__c, Product2.IsPetFriendly__c, Product2.ProductCode
            FROM PricebookEntry
            WHERE IsActive = true AND IsDeleted = false AND ProductCode != null
        ];

        return products;
    }

    public static ID getAccountId() {
        ID currentUserId = UserInfo.getUserId();
        return [SELECT id, Contact.AccountId FROM User WHERE id = :currentUserId]?.Contact.AccountId;
    }
}
