@isTest
private class Customer360AccountServiceTest {

    @isTest
    static void testResolveAccountFromAccount() {

        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        Id result =
            Customer360AccountService.resolveAccountId(acc.Id);

        System.assertEquals(acc.Id, result);
    }

    @isTest
    static void testResolveAccountFromCase() {

        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        Case caseRecord = new Case(
            Subject = 'Test Case',
            Status = 'New',
            AccountId = acc.Id
        );
        insert caseRecord;

        Id result =
            Customer360AccountService.resolveAccountId(caseRecord.Id);

        System.assertEquals(acc.Id, result);
    }
}