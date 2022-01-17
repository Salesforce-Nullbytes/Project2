@isTest
public class LWCShopControllerTest {
    // Need user to run as context
    private class Wrapper {
        public User customer;
        public Account acct;
    }

    @testSetup
    public static void SetupTests() {
        ID stdId = Test.getStandardPricebookId();
        Pricebook2 std = new Pricebook2(name = 'Standard Price Book' , id = stdId);
        //std.isstandard = true;
        Update std;
        DataFactory.ProductSetup();
        DataFactory.AccountSetup();
    }

    @istest
    public static void TS_CreateCartItemNewCart(){
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');

        Product2[] products = [SELECT ProductCode FROM Product2 WHERE ProductCode != null];
        System.assert(products.size() > 0);
        String productCode = products[0].ProductCode;

        Order[] beforeCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(0, beforeCarts.size());

        Boolean added = false;
        System.runAs(info.customer) {
            added = LWCShopController.AddToCart(productCode);
        }
        System.assert(added);

        Order[] afterCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(1, afterCarts.size());

        OrderItem[] inCart = [SELECT id FROM OrderItem 
            WHERE OrderId = :afterCarts[0].id AND Product2.ProductCode = :productCode];
        System.assertEquals(1, inCart.size());

        Test.stopTest();
    }

    @istest
    public static void TN_InvalidProductCode(){
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');

        String fake = 'not a real product code';

        Order[] beforeCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(0, beforeCarts.size());

        Boolean added = false;
        System.runAs(info.customer) {
            added = LWCShopController.AddToCart(fake);
        }
        System.assertNotEquals(true, added);

        Order[] afterCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(0, afterCarts.size());

        Test.stopTest();
    }

    @istest
    public static void TN_CreateCartItemTwice(){
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');

        Product2[] products = [SELECT ProductCode FROM Product2 WHERE ProductCode != null];
        System.assert(products.size() > 0);
        String productCode = products[0].ProductCode;

        Order[] beforeCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(0, beforeCarts.size());

        Boolean added = false;
        System.runAs(info.customer) {
            added = LWCShopController.AddToCart(productCode);
        }
        System.assert(added);

        Boolean addedAgain = false;
        System.runAs(info.customer) {
            addedAgain = LWCShopController.AddToCart(productCode);
        }
        System.assertNotEquals(true, addedAgain);

        Order[] afterCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(1, afterCarts.size());

        OrderItem[] inCart = [SELECT id FROM OrderItem 
            WHERE OrderId = :afterCarts[0].id AND Product2.ProductCode = :productCode];
        System.assertEquals(1, inCart.size());

        Test.stopTest();
    }

    @istest
    public static void TP_AddManyToSameCart(){
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');

        Product2[] products = [SELECT ProductCode FROM Product2 WHERE ProductCode != null];
        System.assert(products.size() > 1);
        String productCode1 = products[0].ProductCode;
        String productCode2 = products[1].ProductCode;

        Boolean added = false;
        System.runAs(info.customer) {
            added = LWCShopController.AddToCart(productCode1);
        }
        System.assert(added);
        
        Order[] beforeCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(1, beforeCarts.size());

        Boolean addedAnother = false;
        System.runAs(info.customer) {
            addedAnother = LWCShopController.AddToCart(productCode2);
        }
        System.assert(addedAnother);

        Order[] afterCarts = [SELECT id FROM Order WHERE AccountId = :info.acct.id AND Status = 'Draft'];
        System.assertEquals(1, afterCarts.size());

        Boolean have1 = false;
        Boolean have2 = false;
        OrderItem[] inCart = [SELECT Product2.ProductCode FROM OrderItem WHERE OrderId = :afterCarts[0].id];
        for (OrderItem item : inCart) {
            if (item.Product2.ProductCode == productCode1) have1 = true;
            if (item.Product2.ProductCode == productCode2) have2 = true;
        }

        System.assert(have1);
        System.assert(have2);

        Test.stopTest();
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
