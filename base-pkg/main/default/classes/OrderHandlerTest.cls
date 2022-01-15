@isTest
public class OrderHandlerTest {

    @testSetup
    public static void SetupTests() {
        ID stdId = Test.getStandardPricebookId();
        Pricebook2 std = new Pricebook2(name = 'Standard Price Book' , id = stdId);
        //std.isstandard = true;
        Update std;
        DataFactory.ProductSetup();
        DataFactory.AccountSetup();
    }

    // @isTest
    // public static void insertNewOrder() {
    //     //Test SetEffectiveDate Trigger
    //     Test.startTest();
    //     Account acct = new Account();
    //     acct.name='Test Account';

    //     insert acct;

    //     Order newOrder = new Order();
    //     newOrder.status = 'Draft';
    //     newOrder.accountid = acct.id;
    //     //newOrder.EffectiveDate = System.today();

    //     insert newOrder;

    //     System.assertEquals(System.today(), newOrder.EffectiveDate, newOrder);
    //     Test.stopTest();
    // }



    @isTest
    public static void updateActivatedOrder() {
        //Test PreventChanges Trigger
        Test.startTest();
        Boolean updateUnsuccessful = false;

        List<OrderItem> activatedOrders = [SELECT order.id, order.status, order.accountId FROM OrderItem WHERE order.status = 'Activated'];
        System.assertNotEquals(0, activatedOrders.size());

        Order orderActivated = new Order(id = activatedOrders[0].order.id);

        try {
            update orderActivated;

        } catch (Exception e) {
            updateUnsuccessful = true;
        }
        System.assertEquals(true, updateUnsuccessful);
        Test.stopTest();
    }



    @isTest
    public static void createTwoDraftOrders() {
        //Test PreventMultipleDrafts Trigger
        Test.startTest();
        Boolean insertUnsuccessful = false;

        Account acct = new Account();
        acct.name='Test Account';

        insert acct;

        Order draftOrder1 = new Order();
        draftOrder1.accountid = acct.id;
        draftOrder1.status = 'Draft';

        insert draftOrder1;

        Order draftOrder2 = new Order();
        draftOrder2.accountid = acct.id;
        draftOrder2.status = 'Draft';

        try {
            insert draftOrder2;
        } catch (Exception e) {
            insertUnsuccessful = true;
        }
        System.assertEquals(true, insertUnsuccessful);
        Test.stopTest();
    }  
}
