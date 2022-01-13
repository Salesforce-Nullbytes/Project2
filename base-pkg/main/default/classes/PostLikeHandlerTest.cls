@isTest
public class PostLikeHandlerTest {
    @testSetup
    public static void SetupTests() {
        //Pricebook2 std = new Pricebook2(name = 'Standard Price Book');
        //Insert std;
        //DataFactory.ProductSetup();
        DataFactory.AccountSetup();
        DataFactory.ForumSetup();
    }
    
    @isTest
    public static void TP_RetrieveAllPostsFromAccounts() {
        Test.startTest();
        
        List<Post_Like__c> allPosts = [SELECT id, Account__c, Forum_Item__c FROM Post_Like__c];
        System.assert(allPosts.size() > 0);

        Integer numLikes = 0;
        Set<ID> acctIds = new Set<ID>();
        Set<ID> postIds = new Set<ID>();
        for (Post_Like__c post : allPosts) {
            numLikes += 1;
            acctIds.add(post.Forum_Item__c);
            postIds.add(post.Forum_Item__c);
        }
        System.assert(acctIds.size() > 0);
        System.assert(postIds.size() > 0);

        Map<ID, List<ID>> likesByAccount = PostLikeHandler.getPostsLikedByAccount(acctIds, postIds);
        for (List<ID> likeSet : likesByAccount.values()) {
            numLikes += likeSet.size();
        }

        System.assertEquals(allPosts.size(), numLikes);
        Test.stopTest();        
    }
    @isTest
    public static void TN_NoUpdates() {
        Test.startTest();
        Post_Like__c ref = [SELECT id FROM Post_Like__c LIMIT 1];
        System.assertNotEquals(null, ref);

        Boolean failed = false;
        try{
            Update ref;
        } catch (Exception e){
            failed = true;
        }
        System.assertEquals(true, failed);
        Test.stopTest();        
    }
    @isTest
    public static void TN_InsertExisting() {
        Test.startTest();
        Post_Like__c ref = [SELECT id, Account__c, Forum_Item__c FROM Post_Like__c LIMIT 1];
        System.assertNotEquals(null, ref);

        Post_Like__c dup = new Post_Like__c();
        dup.Account__c = ref.Account__c;
        dup.Forum_Item__c = ref.Forum_Item__c;

        Boolean failed = false;
        try{
            Insert dup;
        } catch (Exception e){
            failed = true;
        }
        System.assertEquals(true, failed);
        Test.stopTest();        
    }
    @isTest
    public static void TN_InsertDuplicate() {
        Test.startTest();
        Account a = [SELECT id FROM Account LIMIT 1];
        System.assertNotEquals(null, a);

        Forum_Item__c unliked = DataFactory.MakePost(a.id, 0, 'Test Title', 'Some content...', '');
        Insert unliked;
        System.assertNotEquals(null, unliked);

        Post_Like__c[] dups = new Post_Like__c[]{};
        dups.add(
            new Post_Like__c(Account__c = a.Id, Forum_Item__c = unliked.Id)
        );
        dups.add(
            new Post_Like__c(Account__c = a.Id, Forum_Item__c = unliked.Id)
        );

        Boolean failed = false;
        try{
            Insert dups;
        } catch (Exception e){
            failed = true;
        }
        String message = '';
        message += dups[0].Account__c + ', ';
        message += dups[1].Account__c + ', ';
        message += dups[0].Forum_Item__c + ', ';
        message += dups[1].Forum_Item__c + ', ';
        System.assertEquals(true, failed, message);
        Test.stopTest();        
    }
}