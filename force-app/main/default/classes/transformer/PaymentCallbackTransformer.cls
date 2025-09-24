public class PaymentCallbackTransformer {
    
    public Account toAccount(PaymentCallbackInbound.Payer payer) {
        return new Account(
            Name = payer.name,
            DocumentNumber__c = payer.document,
            AccountSource = 'Campanha DevBuilder',
            BillingStreet = payer.billing?.street,
            BillingCity = payer.billing?.city,
            BillingState = payer.billing?.state,
            BillingPostalCode = payer.billing?.zipCode,
            BillingCountry = payer.billing?.country
        );
    }

    public Opportunity toOpportunity(Account account, PaymentCallbackInbound payment, Pricebook2 pricebook) {
        return new Opportunity(
            Name = payment.payer.name,
            AccountId = account.Id,
            Pricebook2Id = pricebook.Id,
            CloseDate = Date.today(),
            StageName = 'Closed Won',
            LeadSource = 'Campanha DevBuilder',
            Amount = payment.amount
        );
    }
}