public with sharing class Customer360HealthService {

  public static Decimal calculateHealthScore(Id accountId) {

    Integer totalCases = [
        SELECT Count()
        FROM Case
        WHERE AccountId = :accountId
    ];

    Decimal caseScore = 100;

    if(totalCases > 0){

        Integer closedCases = [
            SELECT Count()
            FROM Case
            WHERE AccountId = :accountId
            AND Status = 'Closed'
        ];

        caseScore =
            ((Decimal)closedCases / totalCases) * 100;
    }

    Integer opportunityCount = [
        SELECT Count()
        FROM Opportunity
        WHERE AccountId = :accountId
    ];

    Decimal pipelineScore =
        opportunityCount > 0 ? 100 : 0;

    Integer taskCount = [
        SELECT Count()
        FROM Task
        WHERE WhatId = :accountId
    ];

    Decimal activityScore =
        taskCount > 0 ? 100 : 0;

    Decimal contractScore = 50;

    List<Contract> contracts = [
        SELECT EndDate
        FROM Contract
        WHERE AccountId = :accountId
        ORDER BY EndDate ASC
        LIMIT 1
    ];

    if(!contracts.isEmpty()) {

        Integer daysLeft =
            Date.today().daysBetween(contracts[0].EndDate);

        if(daysLeft > 30) {
            contractScore = 100;
        }
        else if(daysLeft <= 0) {
            contractScore = 0;
        }
        else {
            contractScore = 50;
        }
    }

    Decimal finalScore =
        (caseScore * 0.60) +
        (pipelineScore * 0.20) +
        (activityScore * 0.10) +
        (contractScore * 0.10);

    return finalScore;
}
}