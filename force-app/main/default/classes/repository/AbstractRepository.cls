public inherited sharing abstract class AbstractRepository {

    private Boolean allOrNone;

    public AbstractRepository() {
        allOrNone = false;
    }

    public AbstractRepository withAllOrNoneEnabled() {
        this.allOrNone = true;
        return this;
    }

    virtual public SObject save(SObject record) {
        if (record == null) return record;
        save(new List<SObject>{record});
        return record;
    }

    virtual public List<SObject> save(List<SObject> records) {
        if (Lists.isEmpty(records)) return new List<SObject>();
        List<Database.UpsertResult> results = upsertRecords(records);
        return addErrors(records, results);
    }

    virtual public SObject save(SObject record, Schema.SObjectField field) {
        if (record == null) return record;
        save(new List<SObject>{record}, field);
        return record;
    }

    virtual public List<SObject> save(List<SObject> records, Schema.SObjectField field) {
        if (Lists.isEmpty(records)) return new List<SObject>();
        List<Database.UpsertResult> results = upsertRecords(records, field);
        return addErrors(records, results);
    }

    virtual public List<SObject> saveRelated(
        SObject masterRecord,
        String lookupFieldName,
        List<SObject> records
    ) {
        SObjectMapper.applyMasterRecord(masterRecord, lookupFieldName, records);
        return save(records);
    }

    virtual public List<SObject> saveRelated(
        SObject masterRecord,
        String lookupFieldName,
        List<SObject> records,
        Schema.SObjectField field
    ) {
        if (Lists.isEmpty(records)) return new List<SObject>();
        SObjectMapper.applyMasterRecord(masterRecord, lookupFieldName, records);
        return save(records, field);
    }

    virtual public void remove(SObject record) {
        if (record == null) return;
        remove(new List<SObject> {record});
    }

    virtual public void remove(List<SObject> records) {
        if (records == null || records.isEmpty()) return;
        delete records;
    }

    virtual protected List<Database.UpsertResult> upsertRecords(List<SObject> records) {
        List<Database.UpsertResult> results = Database.upsert(records, allOrNone);
        System.debug(JSON.serialize(results));
        return results;
    }

    virtual protected List<Database.UpsertResult> upsertRecords(
        List<SObject> records,
        Schema.SObjectField field
    ) {
        List<Database.UpsertResult> results = Database.upsert(records, field, allOrNone);
        System.debug(JSON.serialize(results));
        return results;
    }

    private List<SObject> addErrors(
        List<SObject> storedRecords,
        List<Database.UpsertResult> results
    ) {
        Integer i = 0;
        System.debug(JSON.serialize(results));
        for (Database.UpsertResult result : results) {
            if (!result.isSuccess()) {
                storedRecords[i].addError(getErrorMessage(result.getErrors()));
            }
            i++;
        }
        return storedRecords;
    }

    private String getErrorMessage(List<Database.Error> errors) {
        List<String> errorMessages = new List<String>();
        for (Database.Error err : errors) {
            errorMessages.add(err.getMessage());
        }
        return String.join(errorMessages, ', ');
    }
}