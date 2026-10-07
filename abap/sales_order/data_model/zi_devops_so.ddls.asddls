@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DevOps Demo - Sales Orders'

define root view entity ZI_DEVOPS_SO
  as select from zdevops_so
{
  key sales_order_id,

      customer_name,
      order_date,
      status,
      amount,
      currency_code,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at
}
