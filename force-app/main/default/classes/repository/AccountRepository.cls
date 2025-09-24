public class AccountRepository extends AbstractRepository {
    public List<Account> findByDocument(String document) {
        return [SELECT Id, Name FROM Account WHERE DocumentNumber__c = :document];
    }
}