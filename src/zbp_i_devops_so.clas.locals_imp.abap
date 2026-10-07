CLASS lhc_ZI_DEVOPS_SO DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zi_devops_so RESULT result.



    METHODS validate_amount FOR VALIDATE ON SAVE
      keys FOR zi_devops_so~validate_amount.

ENDCLASS.


CLASS lhc_ZI_DEVOPS_SO IMPLEMENTATION.




  METHOD get_global_authorizations.

  IF requested_authorizations-%create = if_abap_behv=>mk-on.
    result-%create = if_abap_behv=>auth-allowed.
  ENDIF.

  IF requested_authorizations-%update = if_abap_behv=>mk-on.
    result-%update = if_abap_behv=>auth-allowed.
  ENDIF.

  IF requested_authorizations-%delete = if_abap_behv=>mk-on.
    result-%delete = if_abap_behv=>auth-allowed.
  ENDIF.

ENDMETHOD.





  METHOD validate_amount.

    READ ENTITIES OF zi_devops_so IN LOCAL MODE
      ENTITY zi_devops_so
      FIELDS ( amount )
      WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders INTO DATA(order).

      IF order-amount <= 0.

        APPEND VALUE #(
          %tky = order-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Amount must be greater than zero'
          )
        ) TO reported-zi_devops_so.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
