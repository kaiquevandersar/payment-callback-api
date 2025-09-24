public class PaymentCallbackInboundService {
    private AccountRepository accountRepository = new AccountRepository();
    private LeadRepository leadRepository = new LeadRepository();
    private OpportunityRepository opportunityRepository = new OpportunityRepository();
    private PaymentCallbackTransformer transformer = new PaymentCallbackTransformer();
    private LeadTransformer leadTransformer = new LeadTransformer();

    public PaymentCallbackResponse processPayment(PaymentCallbackInbound payment) {
        if (payment == null || payment.payer == null) {
            throw new IllegalArgumentException('Invalid payment data');
        }

        Account account = findOrCreateAccount(payment);

        Pricebook2 pricebook = PricebookRepository.findActiveByName('Campanha DevBuilder');
        if (pricebook == null) {
            throw new NoSuchElementException('Pricebook not found');
        }
        
        Opportunity opportunity = transformer.toOpportunity(account, payment, pricebook);
        opportunityRepository.save(opportunity);

        return new PaymentCallbackResponse(opportunity.Id);
    }

    private Account findOrCreateAccount(PaymentCallbackInbound payment) {
        PaymentCallbackInbound.Payer payer = payment.payer;

        List<Account> accounts = accountRepository.findByDocument(payer.document);
        if (!accounts.isEmpty()) {
            return accounts.get(0);
        }

        List<Lead> leads = leadRepository.findByDocument(payer.document);
        if (!leads.isEmpty()) {
            Lead lead = leads.get(0);
            return convertLeadToAccount(lead);
        }

        Lead newLead = leadTransformer.toLead(payer);
        leadRepository.save(newLead);
        return convertLeadToAccount(newLead);
    }

    private Account convertLeadToAccount(Lead lead) {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead.Id);
        leadConvert.setConvertedStatus('Closed - Converted');
        leadConvert.setDoNotCreateOpportunity(true);

        Database.LeadConvertResult result = Database.convertLead(leadConvert);
        if (!result.isSuccess()) {
            throw new TypeException('Lead conversion failed');
        }

        return new Account(Id = result.getAccountId());
    }
}