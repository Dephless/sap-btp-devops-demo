CLASS zcl_devops_testdata DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_devops_testdata IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_sales_orders TYPE STANDARD TABLE OF zdevops_so.

    TRY.

        APPEND VALUE #(
          client         = sy-mandt
          sales_order_id = cl_system_uuid=>create_uuid_x16_static( )
          customer_name  = 'ACME GmbH'
          order_date     = '20261001'
          status         = 'Open'
          amount         = '1250.00'
          currency_code  = 'EUR'
        ) TO lt_sales_orders.

        APPEND VALUE #(
          client         = sy-mandt
          sales_order_id = cl_system_uuid=>create_uuid_x16_static( )
          customer_name  = 'SAP Demo Customer'
          order_date     = '20261003'
          status         = 'Completed'
          amount         = '4800.00'
          currency_code  = 'EUR'
        ) TO lt_sales_orders.

        APPEND VALUE #(
          client         = sy-mandt
          sales_order_id = cl_system_uuid=>create_uuid_x16_static( )
          customer_name  = 'Example Corp'
          order_date     = '20261005'
          status         = 'Open'
          amount         = '750.50'
          currency_code  = 'EUR'
        ) TO lt_sales_orders.

        APPEND VALUE #(
        client = sy-mandt
        sales_order_id = cl_system_uuid=>create_uuid_x16_static( )
        customer_name  = 'Example Corp2'
          order_date     = '20261007'
          status         = 'Open'
          amount         = '990.50'
          currency_code  = 'EUR'

        ) TO lt_sales_orders.

        INSERT zdevops_so FROM TABLE @lt_sales_orders.

        IF sy-subrc = 0.
          out->write( |{ lines( lt_sales_orders ) } Sales Orders angelegt.| ).
        ELSE.
          out->write( 'Fehler beim Anlegen der Testdaten.' ).
        ENDIF.

      CATCH cx_uuid_error INTO DATA(lx_uuid).
        out->write( |UUID-Fehler: { lx_uuid->get_text( ) }| ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
