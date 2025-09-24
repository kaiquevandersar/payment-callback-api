public class OpportunityRepository extends AbstractRepository {
    public void save(Opportunity opportunity) {
        upsert opportunity;
    }
}