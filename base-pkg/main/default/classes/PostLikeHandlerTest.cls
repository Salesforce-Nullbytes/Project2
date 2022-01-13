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
    public static void TP_RetrieveAllLikesFromAccounts() {
        Test.startTest();
        
        List<Post_Like__c> allLikes = [SELECT id, Account__c, Forum_Item__c FROM Post_Like__c];
        System.assert(allLikes.size() > 0);

        Set<ID> acctIds = new Set<ID>();
        Set<ID> postIds = new Set<ID>();
        for (Post_Like__c post : allLikes) {
            acctIds.add(post.Account__c);
            postIds.add(post.Forum_Item__c);
        }
        System.assert(acctIds.size() > 0);
        System.assert(postIds.size() > 0);

        Integer numLikes = 0;
        Map<ID, List<ID>> likesByAccount = PostLikeHandler.getPostsLikedByAccount(acctIds, postIds);
        for (List<ID> likeSet : likesByAccount.values()) {
            numLikes += likeSet.size();
        }

        System.assertEquals(allLikes.size(), numLikes);
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

        System.assertEquals(true, failed);
        Test.stopTest();
    }
    @isTest
    public static void TS_IncrementLike() {
        Test.startTest();
        Account a = new Account(name='test account');
        Insert a;

        Forum_Item__c post = [SELECT id, Likes__c FROM Forum_Item__c LIMIT 1];
        System.assertNotEquals(null, post);

        Post_Like__c liked = new Post_Like__c();
        liked.Account__c = a.id;
        liked.Forum_Item__c = post.id;

        Insert liked;
        Forum_Item__c updated = [SELECT id, Likes__c FROM Forum_Item__c WHERE id = :post.id];
        System.assertNotEquals(null, updated);

        System.assertEquals(post.Likes__c + 1, updated.Likes__c);
        Test.stopTest();
    }
    @isTest
    public static void TB_IncrementLike() {
        Test.startTest();
        Account a = new Account(name='test account1');
        Account b = new Account(name='test account2');
        Account c = new Account(name='test account3');
        List<Account> accts = new Account[]{a,b,c};
        Insert accts;

        List<Forum_Item__c> posts = [SELECT id, Likes__c FROM Forum_Item__c];
        System.assertNotEquals(null, posts[0]);
        System.assertNotEquals(null, posts[1]);
        System.assertNotEquals(null, posts[2]);

        // Have three accounts[a,b,c], three posts[0,1,2]
        // Likes to generate are:
        //    a0, b0, c1, c2
        // Ensure that posts0[+2], posts1[+1], posts2[+1]

        Post_Like__c[] liked = new Post_Like__c[]{};
        liked.add(
            new Post_Like__c(Account__c = a.id, Forum_Item__c = posts[0].id)
        );
        liked.add(
            new Post_Like__c(Account__c = b.id, Forum_Item__c = posts[0].id)
        );
        liked.add(
            new Post_Like__c(Account__c = c.id, Forum_Item__c = posts[1].id)
        );
        liked.add(
            new Post_Like__c(Account__c = c.id, Forum_Item__c = posts[2].id)
        );
        Insert liked;

        Forum_Item__c[] updated = [
            SELECT id, Likes__c FROM Forum_Item__c 
            WHERE id = :posts[0].id OR id = :posts[1].id OR id = :posts[2].id
        ];
        System.assertEquals(3, updated.size());

        Integer new0 = 0;
        Integer new1 = 0;
        Integer new2 = 0;
        for (Integer i = 0; i < 3; i++) {
            if (updated[i].id == posts[0].id) new0 = (Integer)updated[i].Likes__c;
            if (updated[i].id == posts[1].id) new1 = (Integer)updated[i].Likes__c;
            if (updated[i].id == posts[2].id) new2 = (Integer)updated[i].Likes__c;
        }

        System.assertEquals(posts[0].Likes__c + 2, new0);
        System.assertEquals(posts[1].Likes__c + 1, new1);
        System.assertEquals(posts[2].Likes__c + 1, new2);
        Test.stopTest();
    }
    @isTest
    public static void TS_DecrementLike() {
        Test.startTest();
        Forum_Item__c[] posts = [
            SELECT id, Likes__c, 
                (SELECT id FROM Post_Likes__r) 
            FROM Forum_Item__c WHERE Likes__c > 0
        ];
        System.assertNotEquals(0, posts.size());

        Forum_Item__c post = posts[0];
        Post_Like__c[] likes = post.Post_Likes__r;
        System.assertNotEquals(0, likes.size());

        ID deleteLike = likes[0].id;
        Delete [SELECT id FROM Post_Like__c WHERE id = :deleteLike];

        Forum_Item__c updated = [
            SELECT id, Likes__c, 
                (SELECT id FROM Post_Likes__r) 
            FROM Forum_Item__c WHERE id = :post.id
            LIMIT 1
        ];

        System.assertNotEquals(null, updated);
        System.assertEquals(post.Likes__c - 1, updated.Likes__c);
        System.assertEquals(post.Post_Likes__r.size() - 1, updated.Post_Likes__r.size());
        Test.stopTest();
    }
    @isTest
    public static void TB_DecrementLike() {
        Test.startTest();
        Forum_Item__c[] posts = [
            SELECT id, Likes__c, 
                (SELECT id FROM Post_Likes__r) 
            FROM Forum_Item__c WHERE Likes__c > 0
        ];
        System.assertNotEquals(0, posts.size());

        Forum_Item__c post = posts[0];
        Post_Like__c[] likes = post.Post_Likes__r;
        System.assertNotEquals(0, likes.size());

        ID deleteLike = likes[0].id;
        Delete [SELECT id FROM Post_Like__c WHERE id = :deleteLike];

        Forum_Item__c updated = [
            SELECT id, Likes__c, 
                (SELECT id FROM Post_Likes__r) 
            FROM Forum_Item__c WHERE id = :post.id
            LIMIT 1
        ];

        System.assertNotEquals(null, updated);
        System.assertEquals(post.Likes__c - 1, updated.Likes__c);
        System.assertEquals(post.Post_Likes__r.size() - 1, updated.Post_Likes__r.size());
        Test.stopTest();
    }
    @isTest
    public static void TN_FailUndelete() {
        Test.startTest();
        Forum_Item__c[] posts = [
            SELECT id, Likes__c, 
                (SELECT id FROM Post_Likes__r) 
            FROM Forum_Item__c WHERE Likes__c > 0
        ];
        System.assertNotEquals(0, posts.size());

        Forum_Item__c post = posts[0];
        Post_Like__c[] likes = post.Post_Likes__r;
        System.assertNotEquals(0, likes.size());

        ID deleteLike = likes[0].id;
        Delete [SELECT id FROM Post_Like__c WHERE id = :deleteLike];

        Post_Like__c undeleted = new Post_Like__c(id = deletelike);

        Boolean failed = false;
        try{
            Undelete undeleted;
        } catch (Exception e){
            failed = true;
        }

        System.assertEquals(true, failed);
        Test.stopTest();
    }
    @isTest
    public static void TN_FailUpdate() {
        Test.startTest();
        Post_Like__c liked = [SELECT id FROM Post_Like__c LIMIT 1];
        System.assertNotEquals(null, liked);

        Boolean failed = false;
        try{
            Update liked;
        } catch (Exception e){
            failed = true;
        }

        System.assertEquals(true, failed);
        Test.stopTest();
    }
}