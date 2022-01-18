@isTest
public class AuraMainHolderControllerTest {
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
    @isTest
    public static void TP_AllProductsRetreived() {
        Test.startTest();

        PricebookEntry[] allProducts = [SELECT Id FROM PricebookEntry WHERE IsActive = true AND ProductCode != null];
        System.assert(allProducts.size() > 0);

        Wrapper info = makeCustomerAndUser('testuser1');

        PricebookEntry[] retrieved = new PricebookEntry[]{};
        System.runAs(info.customer) {
            retrieved = AuraMainHolderController.AllProducts();
        }
        Set<ID> found = new Set<ID>();
        for (PricebookEntry entry : retrieved) {
            found.add(entry.Id);
        }
        
        Boolean notFound = false;
        for (PricebookEntry entry : allProducts) {
            if (!found.contains(entry.id)) notFound = true;
        }

        System.assertEquals(false, notFound);

        Test.stopTest();
    }
    @isTest
    public static void TN_NoExtraProductsRetreived() {
        Test.startTest();

        PricebookEntry[] allProducts = [SELECT Id FROM PricebookEntry WHERE IsActive = true AND ProductCode != null];
        System.assert(allProducts.size() > 0);

        Wrapper info = makeCustomerAndUser('testuser2');

        PricebookEntry[] retrieved = new PricebookEntry[]{};
        System.runAs(info.customer) {
            retrieved = AuraMainHolderController.AllProducts();
        }
        Set<ID> correct = new Set<ID>();
        for (PricebookEntry entry : allProducts) {
            correct.add(entry.Id);
        }
        
        Boolean extra = false;
        for (PricebookEntry entry : retrieved) {
            if (!correct.contains(entry.id)) extra = true;
        }

        System.assertEquals(false, extra);

        Test.stopTest();
    }
    @isTest
    public static void TP_AllCartItemsRetreived() {
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser3');

        async_AllCartItemsRetreived(info.customer.id, info.acct.id);
        Test.stopTest();
    }
    
    public static void TN_NoExtraCartItemsRetreived() {
        Test.startTest();
        Wrapper info = makeCustomerAndUser('testuser4');
        
        async_NoExtraCartItemsRetreived(info.customer.id, info.acct.id);
        Test.stopTest();
    }
    @future
    public static void async_AllCartItemsRetreived(ID customer, ID acct) {
        Order o = [SELECT id, Pricebook2Id FROM Order LIMIT 1];
        Order newOrder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = o.Pricebook2id;
        Insert newOrder;

        Order oCopy = [SELECT id FROM Order LIMIT 1];
        OrderItem[] cartCopy = [SELECT Product2Id, PricebookEntryId, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :oCopy.id];
        System.assert(cartCopy.size() > 1);

        OrderItem[] newItems = new OrderItem[]{};
        for (OrderItem item : cartCopy) {
            OrderItem newItem = new OrderItem();
            newItem.OrderId = newOrder.id;
            newItem.Product2Id = item.Product2Id;
            newItem.PricebookEntryId = item.PricebookEntryId;
            newItem.Quantity = item.Quantity;
            newItem.UnitPrice = item.UnitPrice;

            newItems.add(newItem);
        }
        Insert newItems;
        System.assertEquals(newItems.size(), cartCopy.size());


        OrderItem[] retrieved = new OrderItem[]{};
        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            retrieved = AuraMainHolderController.GetCartItems();
        }

        Set<ID> found = new Set<ID>();
        for (OrderItem entry : retrieved) {
            found.add(entry.Id);
        }

        Boolean notFound = false;
        for (OrderItem entry : newItems) {
            if (!found.contains(entry.id)) notFound = true;
        }

        System.assertEquals(false, notFound);
    }
    @future
    public static void async_NoExtraCartItemsRetreived(ID customer, ID acct) {
        Order o = [SELECT id, Pricebook2Id FROM Order LIMIT 1];
        Order newOrder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = o.Pricebook2id;
        Insert newOrder;

        Order oCopy = [SELECT id FROM Order LIMIT 1];
        OrderItem[] cartCopy = [SELECT Product2Id, PricebookEntryId, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :oCopy.id];
        System.assert(cartCopy.size() > 1);

        OrderItem[] newItems = new OrderItem[]{};
        for (OrderItem item : cartCopy) {
            OrderItem newItem = new OrderItem();
            newItem.OrderId = newOrder.id;
            newItem.Product2Id = item.Product2Id;
            newItem.PricebookEntryId = item.PricebookEntryId;
            newItem.Quantity = item.Quantity;
            newItem.UnitPrice = item.UnitPrice;

            newItems.add(newItem);
        }
        Insert newItems;
        System.assertEquals(newItems.size(), cartCopy.size());


        OrderItem[] retrieved = new OrderItem[]{};
        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            retrieved = AuraMainHolderController.GetCartItems();
        }


        Set<ID> correct = new Set<ID>();
        for (OrderItem entry : newItems) {
            correct.add(entry.Id);
        }
        
        Boolean extra = false;
        for (OrderItem entry : retrieved) {
            if (!correct.contains(entry.id)) extra = true;
        }

        System.assertEquals(false, extra);
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
