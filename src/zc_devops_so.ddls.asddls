@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DevOps Demo - Sales Orders Projection'

define root view entity ZC_DEVOPS_SO
  provider contract transactional_query
  as projection on ZI_DEVOPS_SO
{
  key sales_order_id,
      customer_name,
      order_date,
      status,
      amount,
      currency_code

      
      
}
