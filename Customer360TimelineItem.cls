public class Customer360TimelineItem
    implements Comparable {

    @AuraEnabled
    public String type;

    @AuraEnabled
    public String title;

    @AuraEnabled
    public Datetime activityDate;

    public Integer compareTo(Object obj) {

        Customer360TimelineItem other =
            (Customer360TimelineItem)obj;

        if(activityDate == other.activityDate) {
            return 0;
        }

        return activityDate > other.activityDate
            ? -1
            : 1;
    }
}