@isTest
private class Customer360HealthServiceTest {

    @isTest
    static void testCalculateHealthScore() {

        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        Decimal score =
            Customer360HealthService.calculateHealthScore(acc.Id);

        System.assertEquals(100, score);
    }
}