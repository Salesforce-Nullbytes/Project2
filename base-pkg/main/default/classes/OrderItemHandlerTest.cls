@isTest
public class OrderItemHandlerTest {

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
    public static void addSameItemTwice() {
        Boolean updateUnsuccessful = false;
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        OrderItem existingItem = [SELECT orderID, pricebookEntryID, product2ID, unitprice FROM OrderItem WHERE order.status = 'Draft' LIMIT 1]; 

        OrderItem newItem1 = new OrderItem();
        newItem1.OrderId = existingItem.orderid;
        newItem1.Product2Id = existingItem.Product2Id;
        newItem1.PricebookEntryId = existingItem.PricebookEntryId;
        newItem1.Quantity = 1;
        newItem1.UnitPrice = existingItem.UnitPrice;

        try {
            insert newItem1;
        } catch (Exception e) {
            updateUnsuccessful = true;
        }

        System.assertEquals(true, updateUnsuccessful);
    }

    @isTest 
    public static void addSameItemTwiceBulk() {
        Boolean updateUnsuccessful = false;
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        Account acct = new Account(name='Test Account');

        insert acct;
        
        Order neworder = new Order();
        newOrder.status = 'Draft';
        newOrder.AccountId = acct.id;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = pb.id;

        insert newOrder;

        OrderItem orderItem1 = [SELECT id, PricebookEntryId, Product2Id, UnitPrice FROM OrderItem LIMIT 1];

        OrderItem newItem1 = new OrderItem();
        newItem1.OrderId = neworder.id;
        newItem1.Product2Id = orderItem1.Product2Id;
        newItem1.PricebookEntryId = orderItem1.PricebookEntryId;
        newItem1.Quantity = 1;
        newItem1.UnitPrice = orderItem1.UnitPrice;

        OrderItem newItem2 = new OrderItem();
        newItem2.OrderId = neworder.id;
        newItem2.Product2Id = orderItem1.Product2Id;
        newItem2.PricebookEntryId = orderItem1.PricebookEntryId;
        newItem2.Quantity = 1;
        newItem2.UnitPrice = orderItem1.UnitPrice;

        List<OrderItem> orderItems = new List<OrderItem>{newItem1, newItem2};


        try {
            insert orderItems;
        } catch (Exception e) {
            updateUnsuccessful = true;
        }

        System.assertEquals(true, updateUnsuccessful);
    }

    @isTest 
    public static void modifyItemOnActivatedOrder() {
        Boolean updateUnsuccessful = false;

        OrderItem existingItem = [SELECT orderID, pricebookEntryID, product2ID, unitprice FROM OrderItem WHERE order.status = 'Draft' LIMIT 1]; 

        Order draftOrder = [SELECT id, status FROM Order WHERE id = :existingItem.orderID];
        draftOrder.status = 'Activated';
        update draftOrder;

        try {
            update existingItem;
        } catch (Exception e) {
            updateUnsuccessful = true;
        }

        System.assertEquals(true, updateUnsuccessful);
    }

    @isTest 
    public static void undeleteNotPossible() {
        Boolean updateUnsuccessful = false;
        Pricebook2 pb = [SELECT id FROM Pricebook2 WHERE name='Standard Price Book' LIMIT 1];

        OrderItem existingItem = [SELECT orderID, pricebookEntryID, product2ID, unitprice FROM OrderItem WHERE order.status = 'Draft' LIMIT 1]; 

        delete existingItem;

        try {
            undelete existingItem;
        } catch (Exception e) {
            updateUnsuccessful = true;
        }

        System.assertEquals(true, updateUnsuccessful);
    }
}
