@isTest
public class AuraShoppingCartControllerTest {

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
        Order order = [SELECT id FROM Order WHERE status = 'Draft' LIMIT 1];
        List<OrderItem> orderItems = [SELECT id FROM OrderItem WHERE OrderID = :order.id];

        System.assertNotEquals(0, orderItems.size());

        List<ID> orderItemIDs = new List<ID>();

        for (Integer i = 0; i < orderItems.size(); i++) {
            orderItemIDs.add(orderItems[i].id);
        }

        List<ID> emptyIDList = new List<ID>();
        List<Integer> emptyIntList = new List<Integer>();

        AuraShoppingCartController.updateCart(orderItemIDs, emptyIDList, emptyIntList);

        List<OrderItem> recheckOrderItems = [SELECT id FROM OrderItem WHERE OrderID = :order.id];

        System.assertEquals(0, recheckOrderItems.size());
        Test.stopTest();
    }


    @isTest
    //pass
    public static void updateChanges() {
        Test.startTest();
        Order order = [SELECT id FROM Order WHERE status = 'Draft' LIMIT 1];
        List<OrderItem> orderItems = [SELECT id, quantity FROM OrderItem WHERE OrderID = :order.id];

        orderItems[0].quantity = 3;
        update orderItems;

        System.assertEquals(3, orderItems[0].quantity);

        List<ID> orderItemIDs = new List<ID>();
        orderItemIDs.add(orderItems[0].id);

        List<ID> emptyIDList = new List<ID>();

        List<Integer> newQuantity = new List<Integer>();
        Integer quantity = 5;
        newQuantity.add(quantity);

        AuraShoppingCartController.updateCart(emptyIDList, orderItemIDs, newQuantity);

        List<OrderItem> recheckOrderItems = [SELECT id, quantity FROM OrderItem WHERE OrderID = :order.id];

        System.assertEquals(5, recheckOrderItems[0].quantity);
        Test.stopTest();
    }

    
    @isTest
    //pass
    public static void listsWrongSize() {
        Test.startTest();
        Order order = [SELECT id FROM Order WHERE status = 'Draft' LIMIT 1];
        List<OrderItem> orderItems = [SELECT id, quantity FROM OrderItem WHERE OrderID = :order.id];

        orderItems[0].quantity = 3;
        update orderItems;

        System.assertEquals(3, orderItems[0].quantity);

        List<ID> orderItemIDs = new List<ID>();
        orderItemIDs.add(orderItems[0].id);

        List<ID> emptyIDList = new List<ID>();

        List<Integer> newQuantity = new List<Integer>();
        Integer quantity = 5;
        Integer quantity2 = 2;
        newQuantity.add(quantity);
        newQuantity.add(quantity2);

        AuraShoppingCartController.updateCart(emptyIDList, orderItemIDs, newQuantity);

        System.assertEquals(3, orderItems[0].quantity);
        Test.stopTest(); 
    }

    @isTest
    //pass
    public static void activateOrder() {
        Test.startTest();
        ID myAccount = AuraShoppingCartController.getAccountID();
        System.assertNotEquals(null, myAccount);

        String newAddress = 'address';
        String newCity = 'city';
        String newState = 'state';
        String newZipcode = 'zipcode';
        String newCardnumber = 'cardnumber';
        String newExp = 'exp';
        String newCvv = 'cvv';
        String newBillingzipcode = 'billingzipcode';

        Order order = [SELECT status FROM order WHERE Order.AccountID = :AuraShoppingCartController.getAccountID() AND order.status = 'Draft' AND order.isdeleted = false LIMIT 1];
        List<OrderItem> orderItems = [SELECT id, quantity FROM OrderItem WHERE OrderID = :order.id];
        System.assertNotEquals(0, orderItems.size());

        AuraShoppingCartController.changeOrderStatus(newAddress, newCity, newState, newZipcode, newCardnumber, newExp, newCvv, newBillingzipcode);

        Order recheckOrder = [SELECT status FROM order WHERE Order.AccountID = :AuraShoppingCartController.getAccountID() AND order.isdeleted = false LIMIT 1];
        System.assertEquals('Activated', recheckOrder.status);
        Test.stopTest();
    }

    @isTest
    //pass
    public static void nullAccount() {
        Test.startTest();
        ID newAccountID = AuraShoppingCartController.getAccountID();
        System.assertNotEquals(null, newAccountID);

        Account nullAccount;
        System.assertEquals(null, nullAccount);
        Test.stopTest();
    }

}
