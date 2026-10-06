CLASS lhc_ZI_DEVOPS_SO DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zi_devops_so RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zi_devops_so RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_devops_so.

    METHODS validate_amount FOR VALIDATE ON SAVE
      keys FOR zi_devops_so~validate_amount.

ENDCLASS.


CLASS lhc_ZI_DEVOPS_SO IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD earlynumbering_create.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      IF <entity>-sales_order_id IS INITIAL.

        <entity>-sales_order_id =
          cl_system_uuid=>create_uuid_x16_static( ).

      ENDIF.

    ENDLOOP.

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
