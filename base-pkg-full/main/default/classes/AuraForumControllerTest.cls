@isTest
public class AuraForumControllerTest {
    // Need user to run as context
    private class Wrapper {
        public User customer;
        public Account acct;
    }

    @testSetup
    public static void SetupTests() {
        DataFactory.AccountSetup();
        DataFactory.ForumSetup();
    }
    
    @isTest
    public static void TP_NoExtraTopLevelPosts() {
        Test.startTest();

        Set<ID> actualIDs = new Set<ID>();
        for (Forum_Item__c post : [SELECT id FROM Forum_Item__c WHERE Depth__c = 0 AND isRemoved__c = false]) {
            actualIDs.add(post.id);
        }

        Wrapper info = makeCustomerAndUser('testuser');
        
        Boolean success = true;
        System.runAs(info.customer) {
            for (Forum_Item__c post : AuraForumController.GetTopLevelPosts()) {
                if (!actualIDs.contains(post.id)) {
                    success = false;
                }
            }
        }

        System.assert(success);
    }
    @isTest
    public static void TP_GetsAllTopLevelPosts() {
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');
        Set<ID> returnedIDs = new Set<ID>();

        System.runAs(info.customer) {
            for (Forum_Item__c post : AuraForumController.GetTopLevelPosts()) {
                returnedIDs.add(post.Id);
            }
        }
        
        Boolean success = true;
        for (Forum_Item__c post : [SELECT id FROM Forum_Item__c WHERE Depth__c = 0 AND isRemoved__c = false]) {
            if (!returnedIDs.contains(post.id)) {
                success = false;
            }
        }
        System.assert(success);
        Test.stopTest();
    }
    @isTest
    public static void TP_NoExtraPostsUnder() {
        Test.startTest();

        Forum_Item__c top = [SELECT id FROM Forum_Item__c WHERE Child_Comments__c > 2 AND Depth__c = 0 LIMIT 1];

        Set<ID> actualIDs = new Set<ID>();
        for (Forum_Item__c post : [SELECT id FROM Forum_Item__c 
            WHERE IsRemoved__c = false AND (Top__c = :top.id OR Id = :top.id)]) {
            actualIDs.add(post.id);
        }

        Wrapper info = makeCustomerAndUser('testuser');
        
        Boolean success = true;
        System.runAs(info.customer) {
            for (Forum_Item__c post : AuraForumController.GetPostsUnder(top.id)) {
                if (!actualIDs.contains(post.id)) {
                    success = false;
                }
            }
        }

        System.assert(success);
    }
    @isTest
    public static void TP_GetsAllPostsUnder() {
        Test.startTest();

        Forum_Item__c top = [SELECT id FROM Forum_Item__c WHERE Child_Comments__c > 2 AND Depth__c = 0 LIMIT 1];

        Wrapper info = makeCustomerAndUser('testuser');
        Set<ID> returnedIDs = new Set<ID>();

        System.runAs(info.customer) {
            for (Forum_Item__c post : AuraForumController.GetPostsUnder(top.id)) {
                returnedIDs.add(post.Id);
            }
        }
        
        Boolean success = true;
        for (Forum_Item__c post : [SELECT id FROM Forum_Item__c 
            WHERE IsRemoved__c = false AND (Top__c = :top.id OR Id = :top.id)]) {
            if (!returnedIDs.contains(post.id)) {
                success = false;
            }
        }
        System.assert(success);
        Test.stopTest();
    }
    @isTest
    public static void TP_RetriveAccount() {
        Test.startTest();
        String name1 = 'one Name';
        String name2 = 'two Name';

        Wrapper info1 = makeCustomerAndUser(name1);
        Wrapper info2 = makeCustomerAndUser(name2);

        Account a1;
        Account a2;
        System.runAs(info1.customer) {
            a1 = AuraForumController.GetMyAccount();
        }
        System.assertEquals(name1, a1.Name);

        System.runAs(info2.customer) {
            a2 = AuraForumController.GetMyAccount();
        }
        System.assertEquals(name2, a2.Name);

        Test.stopTest();
    }
    @isTest
    public static void TP_UploadCommentPost() {
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser');

        Forum_Item__c under = [SELECT id FROM Forum_Item__c WHERE IsRemoved__c = false LIMIT 1];

        Forum_Item__c made;
        System.runAs(info.customer) {
            made = AuraForumController.UploadPost(under.id, 'post title', 'hello there', new List<string>());
        }

        System.assertNotEquals(null, made.id);
        Forum_Item__c[] updated = [SELECT id, Parent__c FROM Forum_Item__c WHERE id = :made.id LIMIT 1];

        System.assertEquals(1, updated.size());
        System.assertEquals(under.id, updated[0].Parent__c);

        Test.stopTest();
    }
    @isTest
    public static void TP_UploadTopPost() {
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser');

        Forum_Item__c made;
        System.runAs(info.customer) {
            made = AuraForumController.UploadPost(null, 'post title', 'hello there', new List<string>{'topic','test'});
        }

        System.assertNotEquals(null, made.id);
        Forum_Item__c[] updated = [SELECT id, Parent__c, Depth__c FROM Forum_Item__c WHERE id = :made.id LIMIT 1];

        System.assertEquals(1, updated.size());
        System.assertEquals(null, updated[0].Parent__c);
        System.assertEquals(0, updated[0].Depth__c);

        Test.stopTest();
    }
    @isTest
    public static void TP_PostLikeCreated() {
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser');

        Forum_Item__c unliked = [SELECT id FROM Forum_Item__c LIMIT 1];
        System.runAs(info.customer) {
            AuraForumController.CreateOrDeleteLike( unliked.id, true); // true = liked, false = unliked
        }

        Post_Like__c[] after = [SELECT id FROM Post_Like__c 
            WHERE Account__c = :info.acct.id 
            AND Forum_Item__c = :unliked.id
        ];
        System.assertEquals(1, after.size());
        Test.stopTest();
    }
    @isTest
    public static void TN_PostLikeCreatedTwice() {
        // test that exception is thrown if insert same like (acct/post) twice
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser');

        boolean failed = false;
        Forum_Item__c unliked = [SELECT id FROM Forum_Item__c LIMIT 1];
        System.runAs(info.customer) {
            AuraForumController.CreateOrDeleteLike( unliked.id, true); // true = liked, false = unliked

            try {
                AuraForumController.CreateOrDeleteLike( unliked.id, true); // true = liked, false = unliked
            } catch(Exception e) {
                failed = true;
            }
        }
        System.assert(failed);

        Post_Like__c[] after = [SELECT id FROM Post_Like__c 
            WHERE Account__c = :info.acct.id 
            AND Forum_Item__c = :unliked.id
        ];
        System.assertEquals(1, after.size()); // ensure one like still remains
        Test.stopTest();
    }
    @isTest
    public static void TP_PostLikeDeleted() {
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser');

        Forum_Item__c toLike = [SELECT id FROM Forum_Item__c LIMIT 1];

        InsertAndDeleteLikeAs(info.customer.id, info.acct.id, toLike.id, 1); // delete 1 time
        Test.stopTest();
    }
    @isTest
    public static void TP_PostLikeDeletedTwice() {
        // Test no exception is thrown
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser');

        Forum_Item__c toLike = [SELECT id FROM Forum_Item__c LIMIT 1];

        InsertAndDeleteLikeAs(info.customer.id, info.acct.id, toLike.id, 1); // delete 2 times
        Test.stopTest();
    }
    @future
    private static void InsertAndDeleteLikeAs(ID customer, ID a, ID post, Integer times) {
        // Using future annotation to avoid problem with mixed DML operation
        Post_Like__c liked = new Post_Like__c();
        liked.Account__c = a;
        liked.Forum_Item__c = post;
        Insert liked;

        Post_Like__c[] before = [SELECT id FROM Post_Like__c 
            WHERE Account__c = :a 
            AND Forum_Item__c = :post
        ];
        System.assertEquals(1, before.size());

        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            for (Integer i = 0; i < times; i++) {
                AuraForumController.CreateOrDeleteLike( liked.id, false); // true = liked, false = unliked
            }
        }
        
        Post_Like__c[] after = [SELECT id FROM Post_Like__c 
            WHERE Account__c = :a 
            AND Forum_Item__c = :liked.id
        ];
        System.assertEquals(0, after.size());
    }
    
    private static Wrapper makeCustomerAndUser(String someName) {
        // Process learned from Salesforce documentations
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_tools_runas.htm
        // and Lee Campbell at https://developer.salesforce.com/forums/?id=906F00000009266IAA
        // Process was modified from each source and customized for use here

        UserRole role = new UserRole(name='test role', PortalType = 'None' );
        Insert role;

        Profile pInternal = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1];
        Profile pExternal = [SELECT id, name FROM Profile WHERE name = 'Customer Community Login User' LIMIT 1];
       
        String usernameInternal = DateTime.now().getTime() + '@testinternal.com';
        String usernameExternal = DateTime.now().getTime() + '@testexternal.com';

        User creator = new User(
            UserRoleId = role.Id,
            ProfileId = pInternal.Id,
            Username = usernameInternal,
            Alias = 'creator',
            Email='internaluser@test.com',
            EmailEncodingKey='UTF-8',
            Lastname='Testname',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles'
        );
        Insert creator;

        Wrapper result = new Wrapper();
        System.runAs (creator) {
            Account customerAcct = new Account(
                Name = someName,
                OwnerId = creator.Id
            );
            Database.insert(customerAcct);
            
            Contact c = new Contact(lastName=someName);
            c.email = 'contact'+usernameExternal;
            c.AccountId = customerAcct.Id;
            Insert c;

            User customer = new User(
                ProfileId = pExternal.Id,
                Username = usernameExternal, 
                Alias = 'cstmr', 
                Email='externaluser@test.com',
                EmailEncodingKey='UTF-8', 
                LastName=someName, 
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', 
                TimeZoneSidKey='America/Los_Angeles',
                CommunityNickname= someName.replaceAll( '\\s+', ''),
                ContactId = c.id
            );
            Insert customer;

            result.customer = customer;
            result.acct = customerAcct;
        }

        return result;
    }
}