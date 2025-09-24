public class LeadTransformer {

    public Lead toLead(PaymentCallbackInbound.Payer payer) {
        return new Lead(
            FirstName = payer.name, 
            DocumentNumber__c = payer.document,
            Email = payer.email,
            Status = 'Open - Not Contacted', 
            Company = 'N/A', 
            Street = payer.billing?.street,
            City = payer.billing?.city,
            State = payer.billing?.state,
            PostalCode = payer.billing?.zipCode,
            Country = payer.billing?.country
        );
    }
}