public class LeadRepository extends AbstractRepository {
    public List<Lead> findByDocument(String document) {
        return [SELECT Id FROM Lead WHERE DocumentNumber__c = :document];
    }
}