public class Lists {

    public static Boolean isEmpty(List<SObject> records) {
        return records == null || records.isEmpty();
    }

    public static Boolean isEmpty(List<Object> records) {
        return records == null || records.isEmpty();
    }

    public static Boolean isNotEmpty(List<Object> records) {
        return !isEmpty(records);
    }

    public static List<Object> removeDuplicateLines(List<Object> records) {
        Set<Object> recordsSet = new Set<Object>(records);
        return new List<Object>(recordsSet);
    }

    public static List<Object> removeEmptyLines(List<Object> records) {
        Set<Object> recordsSet = new Set<Object>(records);
        recordsSet.remove('');
        recordsSet.remove(null);
        return new List<Object>(recordsSet);
    }

    public static SObject getFirstOrNull(List<SObject> records) {
        return isNotEmpty(records) ? records.get(0) : null;
    }
}