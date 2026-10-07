CLASS zcl_devops_so_test DEFINITION
  PUBLIC
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  CREATE PUBLIC.

  PUBLIC SECTION.

  PRIVATE SECTION.

    METHODS create_sales_order FOR TESTING
      RAISING cx_static_check.

ENDCLASS.


CLASS zcl_devops_so_test IMPLEMENTATION.

  METHOD create_sales_order.

    DATA sales_order_id TYPE sysuuid_x16.

    sales_order_id = cl_system_uuid=>create_uuid_x16_static( ).

    MODIFY ENTITIES OF zi_devops_so
      ENTITY zi_devops_so
      CREATE FIELDS (
        customer_name
        order_date
        status
        amount
        currency_code
      )
      WITH VALUE #(
        (
          %cid          = 'SO1'
          customer_name = 'ABAP Unit Test'
          order_date    = sy-datum
          status        = 'Open'
          amount        = '100.00'
          currency_code = 'EUR'
        )
      )
      MAPPED DATA(mapped)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial(
      act = failed-zi_devops_so
      msg = 'Create failed' ).

    cl_abap_unit_assert=>assert_not_initial(
      act = mapped-zi_devops_so
      msg = 'No Sales Order was created' ).

  ENDMETHOD.

ENDCLASS.
