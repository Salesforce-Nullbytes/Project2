public with sharing class AuraForumController {
    @AuraEnabled
    public static List<Forum_Item__c> GetTopLevelPosts() {
        List<Forum_Item__c> top = [
            SELECT Title__c, Content__c, Parent__r.name, Likes__c, Child_Comments__c 
            FROM Forum_Item__c WHERE Depth__c = 0 AND IsRemoved__c = false
        ];
        return top;
    }
    public static ID GetAccount(String acctName) {
        return [SELECT id FROM Account WHERE name= :acctName]?.id;
    }
}
