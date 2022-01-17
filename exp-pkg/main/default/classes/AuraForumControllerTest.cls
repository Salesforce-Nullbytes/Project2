@isTest
public class AuraForumControllerTest {
    // Need user to run as context
    private class Wrapper {
        public User customer;
        public Account acct;
    }

    @testSetup
    public static void SetupTests() {
        //Pricebook2 std = new Pricebook2(name = 'Standard Price Book');
        //Insert std;
        //DataFactory.ProductSetup();
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

        Boolean success = true;
        for (Forum_Item__c post : AuraForumController.GetTopLevelPosts()) {
            if (!actualIDs.contains(post.id)) {
                success = false;
            }
        }
        System.assert(success);
    }
    @isTest
    public static void TP_GetsAllTopLevelPosts() {
        Test.startTest();
        Set<ID> returnedIDs = new Set<ID>();
        for (Forum_Item__c post : AuraForumController.GetTopLevelPosts()) {
            returnedIDs.add(post.Id);
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
    public static void TP_PostLikeCreated() {
        Test.startTest();
        Wrapper info = makeCustomerAndUser();

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
        Wrapper info = makeCustomerAndUser();

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
        Wrapper info = makeCustomerAndUser();

        Forum_Item__c toLike = [SELECT id FROM Forum_Item__c LIMIT 1];

        InsertAndDeleteLikeAs(info.customer.id, info.acct.id, toLike.id, 1); // delete 1 time
        Test.stopTest();
    }
    @isTest
    public static void TP_PostLikeDeletedTwice() {
        // Test no exception is thrown
        Test.startTest();
        Wrapper info = makeCustomerAndUser();

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
    
    private static Wrapper makeCustomerAndUser() {
        // Process learned from Salesforce documentations
        // and Lee Campbell at https://developer.salesforce.com/forums/?id=906F00000009266IAA
        String someName = 'sdfsdfsdg';

        UserRole role = new UserRole(name='test role', PortalType = 'None' );
        Insert role;

        Profile pInternal = [SELECT id, name FROM Profile WHERE name = 'System Administrator' LIMIT 1];
        Profile pExternal = [SELECT id, name FROM Profile WHERE name = 'Customer Community Login User' LIMIT 1];
       
        String usernameInternal = someName + DateTime.now().getTime() + '@testinternal.com';
        String usernameExternal = someName + DateTime.now().getTime() + '@testexternal.com';

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
                Name = 'TestAccount',
                OwnerId = creator.Id
            );
            Database.insert(customerAcct);
            
            Contact c = new Contact(lastName='testname');
            c.email = 'contact'+usernameExternal;
            c.AccountId = customerAcct.Id;
            Insert c;

            User customer = new User(
                ProfileId = pExternal.Id,
                Username = usernameExternal, 
                Alias = 'cstmr', 
                Email='externaluser@test.com',
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', 
                TimeZoneSidKey='America/Los_Angeles',
                CommunityNickname='test12345',
                ContactId = c.id
            );
            Insert customer;

            result.customer = customer;
            result.acct = customerAcct;
        }

        return result;
    }
}