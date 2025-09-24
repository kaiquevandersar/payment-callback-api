# Payment Callback API

Este projeto implementa um endpoint para receber callbacks de pagamentos, integrando sistemas de terceiros (ex: gateways de pagamento) com sua aplicação. O objetivo é processar notificações de eventos de pagamento e atualizar o status das transações no seu sistema.


## Visão Geral

A API de Payment Callback expõe um endpoint HTTP para receber notificações de pagamento. Ao receber um callback, a API processa os dados e responde ao sistema de origem, garantindo a integridade e rastreabilidade das operações.

## Funcionalidades

- Receber notificações de pagamento via HTTP POST.
- Validar e processar o payload recebido.
- Atualizar o status da transação no sistema.
- Retornar resposta adequada ao sistema de origem.



## Como Executar

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/payment-callback-api.git
   cd payment-callback-api
   ```
2. Conecte-se à sua org Salesforce:

Faça login na sua org (exemplo para uma org de desenvolvimento):

```bash
sfdx force:auth:web:login -a minha-org
```

3. Faça o deploy do código para sua org Salesforce:

```bash
sfdx force:source:deploy -p force-app -u minha-org
```
4. Acesse o endpoint:

O endpoint estará disponível em:

```bash
https://<sua-instance>.my.salesforce.com/services/apexrest/api/payment-callback
```
Substitua <sua-instance> pelo domínio da sua org Salesforce.

5. Exemplo de chamada (usando cURL):

```bash
curl -X POST \
  -H "Authorization: Bearer <seu-access-token>" \
  -H "Content-Type: application/json" \
  -d '{"operationId":"1234567890","status":"CONFIRMED","amount":100.00,"paymentMethod":"CREDIT_CARD"}' \
  https://<sua-instance>.my.salesforce.com/services/apexrest/api/payment-callback
  ```
Substitua <seu-access-token> pelo token de acesso OAuth válido.


## Exemplo de Payload

```json
{
  "operationId": "1234567890",
  "status": "CONFIRMED",
  "amount": 100.00,
  "paymentMethod": "CREDIT_CARD"
}
