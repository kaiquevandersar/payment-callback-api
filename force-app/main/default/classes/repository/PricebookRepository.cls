public class PricebookRepository {
    public static Pricebook2 findActiveByName(String name) {
        return [SELECT Id FROM Pricebook2 WHERE Name = :name AND IsActive = true LIMIT 1];
    }
}