public without sharing class LWCShopController {
    
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
}
