@RestResource(urlMapping='/api/payment-callback')
global class PaymentCallbackController {
    public static PaymentCallbackInboundService service = new PaymentCallbackInboundService();

    @HttpPost
    global static void processPayment() {
        try {
            String requestBody = RestContext.request.requestBody.toString();

            PaymentCallbackInbound payment = (PaymentCallbackInbound) JSON.deserialize(requestBody, PaymentCallbackInbound.class);

            PaymentCallbackResponse response = service.processPayment(payment);

            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(
                JSON.serialize(response)
            );
        } catch (Exception ex) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(
                JSON.serialize(new Map<String, Object>{
                    'error' => ex.getMessage()
                })
            );
        }
    }
}