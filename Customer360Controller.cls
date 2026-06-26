public with sharing class Customer360Controller {

    @AuraEnabled(cacheable=true)
    public static Decimal getHealthScore(Id accountId) {
        return Customer360HealthService.calculateHealthScore(accountId);
    }
    @AuraEnabled(cacheable=true)
public static Account getAccountDetails(Id accountId) {

    return [
        SELECT
            Id,
            Name,
            Industry,
            Phone,
            Health_Score__c
        FROM Account
        WHERE Id = :accountId
        LIMIT 1
    ];
}
@AuraEnabled(cacheable=true)
public static Map<String, Integer> getKpiData(Id accountId) {

    Map<String, Integer> result =
        new Map<String, Integer>();

    Integer openCases = [
        SELECT Count()
        FROM Case
        WHERE AccountId = :accountId
        AND Status != 'Closed'
    ];

    Integer opportunityCount = [
        SELECT Count()
        FROM Opportunity
        WHERE AccountId = :accountId
    ];

    result.put('openCases', openCases);
    result.put('opportunityCount', opportunityCount);

    return result;
}
@AuraEnabled(cacheable=true)
public static List<Case> getCases(Id accountId) {

    return [
        SELECT
            Id,
            CaseNumber,
            Subject,
            Status,
            Priority
        FROM Case
        WHERE AccountId = :accountId
        ORDER BY CreatedDate DESC
        LIMIT 10
    ];
}
@AuraEnabled(cacheable=true)
public static List<Opportunity> getOpportunities(Id accountId) {

    return [
        SELECT
            Id,
            Name,
            StageName,
            Amount,
            CloseDate
        FROM Opportunity
        WHERE AccountId = :accountId
        ORDER BY CloseDate DESC
        LIMIT 10
    ];
}
@AuraEnabled(cacheable=true)
public static List<Task> getActivities(Id accountId) {

    return [
        SELECT
            Id,
            Subject,
            Status,
            ActivityDate
        FROM Task
        WHERE WhatId = :accountId
        ORDER BY ActivityDate DESC
        LIMIT 10
    ];
}
@AuraEnabled(cacheable=true)
public static List<Customer360TimelineItem> getTimeline(Id accountId) {

    List<Customer360TimelineItem> timeline =
        new List<Customer360TimelineItem>();

    for (Case c : [
        SELECT Subject, CreatedDate
        FROM Case
        WHERE AccountId = :accountId
    ]) {

        Customer360TimelineItem item =
            new Customer360TimelineItem();

        item.type = 'Case';
        item.title = c.Subject;
        item.activityDate = c.CreatedDate;

        timeline.add(item);
    }

    for (Opportunity opp : [
        SELECT Name, CreatedDate
        FROM Opportunity
        WHERE AccountId = :accountId
    ]) {

        Customer360TimelineItem item =
            new Customer360TimelineItem();

        item.type = 'Opportunity';
        item.title = opp.Name;
        item.activityDate = opp.CreatedDate;

        timeline.add(item);
    }

    for (Task t : [
        SELECT Subject, CreatedDate
        FROM Task
        WHERE WhatId = :accountId
    ]) {

        Customer360TimelineItem item =
            new Customer360TimelineItem();

        item.type = 'Task';
        item.title = t.Subject;
        item.activityDate = t.CreatedDate;

        timeline.add(item);
    }

    timeline.sort();

return timeline;
}
@AuraEnabled(cacheable=true)
public static List<Contract> getContracts(Id accountId) {

    return [
        SELECT
            Id,
            ContractNumber,
            Status,
            StartDate,
            EndDate
        FROM Contract
        WHERE AccountId = :accountId
        ORDER BY EndDate ASC
        LIMIT 10
    ];
}
@AuraEnabled(cacheable=true)
public static List<Account> searchAccounts(String searchText) {

    return [
        SELECT Id, Name
        FROM Account
        WHERE Name LIKE :('%' + searchText + '%')
        ORDER BY Name
        LIMIT 10
    ];
}
@AuraEnabled(cacheable=true)
public static Id getAccountIdFromCase(Id caseId) {

    Case c = [
        SELECT AccountId
        FROM Case
        WHERE Id = :caseId
        LIMIT 1
    ];

    return c.AccountId;
}
@AuraEnabled
public static void publishUpdateEvent(
    Id accountId,
    String updateType
) {

    Customer360_Update__e eventObj =
        new Customer360_Update__e();

    eventObj.Account_Id__c =
        String.valueOf(accountId);

    eventObj.Update_Type__c =
        updateType;

    EventBus.publish(eventObj);
}
}