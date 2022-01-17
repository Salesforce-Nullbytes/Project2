@isTest
public class AuraShoppingCartControllerTest {
    // Need user to run as context
    private class Wrapper {
        public User customer;
        public Account acct;
    }

    @testSetup
    public static void SetupTests() {
        ID stdId = Test.getStandardPricebookId();
        Pricebook2 std = new Pricebook2(name = 'Standard Price Book' , id = stdId);
        Update std;
        DataFactory.ProductSetup();
        DataFactory.AccountSetup();
    }

    @isTest
    //pass
    public static void deleteRemovals() {
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');
        asyncDeleteRemovals(info.customer.id, info.acct.id);

        Test.stopTest();
    }
    @future
    public static void asyncDeleteRemovals(ID customer, ID acct) {
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        Order neworder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = pb.id;
        Insert newOrder;


        OrderItem orderItem1 = [SELECT id, PricebookEntryId, Product2Id, Quantity, UnitPrice FROM OrderItem LIMIT 1];
        OrderItem orderItem2 = [SELECT id, PricebookEntryId, Product2Id, Quantity, UnitPrice FROM OrderItem
            WHERE PricebookEntryId != :orderItem1.PricebookEntryId AND Product2Id != :orderItem1.Product2Id
            LIMIT 1
        ];

        OrderItem newItem1 = new OrderItem();
        newItem1.OrderId = newOrder.id;
        newItem1.Product2Id = orderItem1.Product2Id;
        newItem1.PricebookEntryId = orderItem1.PricebookEntryId;
        newItem1.Quantity = orderItem1.Quantity;
        newItem1.UnitPrice = orderItem1.UnitPrice;

        OrderItem newItem2 = new OrderItem();
        newItem2.OrderId = newOrder.id;
        newItem2.Product2Id = orderItem2.Product2Id;
        newItem2.PricebookEntryId = orderItem2.PricebookEntryId;
        newItem2.Quantity = orderItem2.Quantity;
        newItem2.UnitPrice = orderItem2.UnitPrice;

        Insert newItem1;
        Insert newItem2;
        List<ID> orderItemIDs = new List<ID>{newItem1.id, newItem2.id};

        List<OrderItem> before = [SELECT id FROM OrderItem WHERE OrderID = :newOrder.id];
        System.assertEquals(2, before.size());

        List<ID> emptyIDList = new List<ID>();
        List<Integer> emptyIntList = new List<Integer>();

        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            AuraShoppingCartController.updateCart(orderItemIDs, emptyIDList, emptyIntList);
        }

        List<OrderItem> recheckOrderItems = [SELECT id FROM OrderItem WHERE OrderID = :newOrder.id];
        System.assertEquals(0, recheckOrderItems.size());
    }


    @isTest
    //pass
    public static void updateChanges() {
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');
        asyncUpdateChanges(info.customer.id, info.acct.id);

        Test.stopTest();
    }

    @future
    public static void asyncUpdateChanges(ID customer, ID acct) {

        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        Order neworder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = pb.id;
        Insert newOrder;

        OrderItem orderItem = [SELECT id, PricebookEntryId, Product2Id, Quantity, UnitPrice FROM OrderItem LIMIT 1];

        OrderItem newItem = new OrderItem();
        newItem.OrderId = newOrder.id;
        newItem.Product2Id = orderItem.Product2Id;
        newItem.PricebookEntryId = orderItem.PricebookEntryId;
        newItem.Quantity = orderItem.Quantity;
        newItem.UnitPrice = orderItem.UnitPrice;

        Insert newItem;

        System.assertNotEquals(5, newItem.quantity);

        List<OrderItem> before = [SELECT id FROM OrderItem WHERE OrderID = :newOrder.id];
        System.assertEquals(1, before.size());

        List<ID> emptyIDList = new List<ID>();

        List<ID> orderItemIDs = new List<ID>();
        orderItemIDs.add(before[0].id);
        
        List<Integer> newQuantity = new List<Integer>();
        Integer quantity = 5;
        newQuantity.add(quantity);

        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            AuraShoppingCartController.updateCart(emptyIDList, orderItemIDs, newQuantity);
        }

        List<OrderItem> recheckOrderItems = [SELECT id, quantity FROM OrderItem WHERE OrderID = :newOrder.id];

        System.assertEquals(5, recheckOrderItems[0].quantity);
    }

    
    @isTest
    //pass
    public static void listsWrongSize() {
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');
        asyncListsWrongSize(info.customer.id, info.acct.id);

        Test.stopTest();
    }

    @future
    public static void asyncListsWrongSize(ID customer, ID acct) {

        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        Order neworder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = pb.id;
        Insert newOrder;

        OrderItem orderItem = [SELECT id, PricebookEntryId, Product2Id, Quantity, UnitPrice FROM OrderItem LIMIT 1];

        OrderItem newItem = new OrderItem();
        newItem.OrderId = newOrder.id;
        newItem.Product2Id = orderItem.Product2Id;
        newItem.PricebookEntryId = orderItem.PricebookEntryId;
        newItem.Quantity = orderItem.Quantity;
        newItem.UnitPrice = orderItem.UnitPrice;

        Insert newItem;

        System.assertNotEquals(5, newItem.quantity);

        List<OrderItem> before = [SELECT id FROM OrderItem WHERE OrderID = :newOrder.id];
        System.assertEquals(1, before.size());

        List<ID> emptyIDList = new List<ID>();

        List<ID> orderItemIDs = new List<ID>();
        orderItemIDs.add(before[0].id);
        
        List<Integer> newQuantity = new List<Integer>();
        Integer quantity = 5;
        Integer quantity2 = 5;
        newQuantity.add(quantity);
        newQuantity.add(quantity2);

        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            AuraShoppingCartController.updateCart(emptyIDList, orderItemIDs, newQuantity);
        }

        List<OrderItem> recheckOrderItems = [SELECT id, quantity FROM OrderItem WHERE OrderID = :newOrder.id];

        System.assertNotEquals(5, recheckOrderItems[0].quantity);
    }

    @isTest
    //pass
    public static void activateOrder() {
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');
        asyncActivateOrder(info.customer.id, info.acct.id, info.acct.Billing_Zipcode__c, info.acct.shippingStreet, info.acct.shippingcity, 
                            info.acct.shippingstate, info.acct.Shipping_Zipcode__c, info.acct.CVV__c, info.acct.exp__c, info.acct.Card_Number__c);

        Test.stopTest();
    }

    @future
    public static void asyncActivateOrder(ID customer, ID acct, String address, String city, String state, String zipcode, String cardnumber, String exp, String cvv, String billingzipcode ) {

        String newAddress = address;
        String newCity = city;
        String newState = state;
        String newZipcode = zipcode;
        String newCardnumber = cardnumber;
        String newExp = exp;
        String newCvv = cvv;
        String newBillingzipcode = billingzipcode;

        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        Order neworder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = pb.id;
        Insert newOrder;

        OrderItem orderItem = [SELECT id, PricebookEntryId, Product2Id, Quantity, UnitPrice FROM OrderItem LIMIT 1];

        OrderItem newItem = new OrderItem();
        newItem.OrderId = newOrder.id;
        newItem.Product2Id = orderItem.Product2Id;
        newItem.PricebookEntryId = orderItem.PricebookEntryId;
        newItem.Quantity = orderItem.Quantity;
        newItem.UnitPrice = orderItem.UnitPrice;

        Insert newItem;

        System.assertEquals('Draft', newOrder.status);

        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            AuraShoppingCartController.changeOrderStatus(newAddress, newCity, newState, newZipcode, newCardnumber, newExp, newCvv, newBillingzipcode);
        }

        Order recheckOrder = [SELECT status FROM Order WHERE id = :newOrder.id];
        System.assertEquals('Activated', recheckOrder.status);
    }

    @isTest
    //pass
    public static void changeQuantityInWrongAccount() {
        Test.startTest();

        Wrapper info = makeCustomerAndUser('testuser');
        asyncChangeQuantityInWrongAccount(info.customer.id, info.acct.id);

        Test.stopTest();
    }

    @future
    public static void asyncChangeQuantityInWrongAccount(ID customer, ID acct) {

        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        Order neworder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = pb.id;
        Insert newOrder;

        List<OrderItem> orderItems = [SELECT id, PricebookEntryId, Product2Id, Quantity, UnitPrice FROM OrderItem LIMIT 2];
        System.assertEquals(2, orderItems.size());

        OrderItem orderItem = orderItems[0];
        OrderItem notMyOrderItem = orderItems[1]; 


        OrderItem newItem = new OrderItem();
        newItem.OrderId = newOrder.id;
        newItem.Product2Id = orderItem.Product2Id;
        newItem.PricebookEntryId = orderItem.PricebookEntryId;
        newItem.Quantity = orderItem.Quantity;
        newItem.UnitPrice = orderItem.UnitPrice;

        Insert newItem;

        List<OrderItem> before = [SELECT id, quantity FROM OrderItem WHERE id = :newItem.id OR id = :notMyOrderItem.id];
        System.assertEquals(2, before.size());

        List<ID> emptyIDList = new List<ID>();

        List<ID> orderItemIDs = new List<ID>();
        orderItemIDs.add(before[0].id);
        orderItemIDs.add(before[1].id);

        List<Integer> newQuantity = new List<Integer>();
        Integer quantity = (Integer)before[0].quantity;
        Integer quantity2 = (Integer)before[1].quantity;
        newQuantity.add(quantity + 2);
        newQuantity.add(quantity2 + 2);

        User u = [SELECT id FROM User WHERE id = :customer];
        System.runAs(u) {
            AuraShoppingCartController.updateCart(emptyIDList, orderItemIDs, newQuantity);
        }

        List<OrderItem> recheckOrderItems = [SELECT id, quantity FROM OrderItem WHERE id = :newItem.id OR id = :notMyOrderItem.id];

        List<Integer> after = new List<Integer>();
        for (OrderItem order : recheckOrderItems) {
            if (order.id == before[0].id) {
                after.add((Integer)order.quantity);
            }
            if (order.id == before[1].id) {
                after.add((Integer)order.quantity);
            }
        }

        System.assert(after.size() == 2);

        //All or nothing transaction
        System.assertEquals(quantity, after[0]);
        System.assertEquals(quantity2, after[1]);
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
