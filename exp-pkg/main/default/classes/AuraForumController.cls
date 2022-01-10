public with sharing class AuraForumController {
    @AuraEnabled
    public static ID GetAccount(String acctName) {
        return [SELECT id FROM Account WHERE name= :acctName]?.id;
    }
}
