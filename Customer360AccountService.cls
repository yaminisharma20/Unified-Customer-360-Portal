public with sharing class Customer360AccountService {

    public static Id resolveAccountId(Id recordId) {

        if (recordId == null) {
            return null;
        }

        String objectName =
            recordId.getSObjectType().getDescribe().getName();

        if (objectName == 'Account') {
            return recordId;
        }

        if (objectName == 'Case') {

            Case caseRecord = [
                SELECT AccountId
                FROM Case
                WHERE Id = :recordId
                LIMIT 1
            ];

            return caseRecord.AccountId;
        }

        return null;
    }
}