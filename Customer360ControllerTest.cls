@isTest
private class Customer360ControllerTest {

    @isTest
    static void testGetHealthScore() {

        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        Decimal score =
            Customer360Controller.getHealthScore(acc.Id);

        System.assertEquals(100, score);
    }
}