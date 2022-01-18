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

    @isTest
    public static void updateActivatedOrder() {
        //Test PreventChanges Trigger
        Test.startTest();
        Boolean updateUnsuccessful = false;

        List<Order> activatedOrders = [SELECT id, status, accountId FROM Order WHERE status = 'Activated'];
        if(activatedOrders.size() == 0) {
            List<Order> draftOrders = [SELECT id, status, accountId FROM Order WHERE status = 'Draft'];
            System.assertNotEquals(0, draftOrders.size());
            Order toActivate = draftOrders[0];
            toActivate.status = 'Activated';
            update toActivate;
            activatedOrders.add(toActivate);
        }
        System.assertNotEquals(0, activatedOrders.size());

        try {
            update activatedOrders[0];

        } catch (Exception e) {
            updateUnsuccessful = true;
        }
        System.assertEquals(true, updateUnsuccessful);
        Test.stopTest();
    }

    @isTest
    public static void insertTwoNewDraftOrdersWithSameAccount() {
        //Test PreventMultipleDrafts Trigger
        Test.startTest();
        Boolean updateUnsuccessful = false;

        Account acct = new Account(name='Test Account');

        List<Order> newOrders = new List<Order>();
        Order o1 = new Order();
        o1.accountid = acct.id;
        o1.status = 'Draft';
        o1.EffectiveDate = System.today();

        Order o2 = new Order();
        o2.accountid = acct.id;
        o2.status = 'Draft';
        o2.EffectiveDate = System.today();

        newOrders.add(o1);
        newOrders.add(o2);

        try {
            insert newOrders;

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
        draftOrder1.EffectiveDate = System.today();

        insert draftOrder1;

        Order draftOrder2 = new Order();
        draftOrder2.accountid = acct.id;
        draftOrder2.status = 'Draft';
        draftOrder2.EffectiveDate = System.today();

        try {
            insert draftOrder2;
        } catch (Exception e) {
            insertUnsuccessful = true;
        }
        System.assertEquals(true, insertUnsuccessful);
        Test.stopTest();
    } 
    
    @isTest
    public static void undeleteDraftWithExistingDraft() {
        //Test PreventMultipleDrafts Trigger
        Test.startTest();
        Boolean insertUnsuccessful = false;

        Account acct = new Account();
        acct.name='Test Account';

        insert acct;

        Order draftOrder1 = new Order();
        draftOrder1.accountid = acct.id;
        draftOrder1.status = 'Draft';
        draftOrder1.EffectiveDate = System.today();

        insert draftOrder1;
    
        //ID toUndelete = draftOrder1.id;

        delete draftOrder1;

        try {
            undelete draftOrder1;
        } catch (Exception e) {
            insertUnsuccessful = true;
        }
        System.assertEquals(true, insertUnsuccessful);
        Test.stopTest();
    } 
}