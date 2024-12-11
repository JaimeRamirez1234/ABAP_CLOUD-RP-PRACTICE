CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS createTravelByTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Travel~createTravelByTemplate RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateStatus.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.

        READ ENTITIES OF zcd_i_travel_alfa02
             ENTITY Travel
             FIELDS ( TravelId OverallStatus )
             WITH VALUE #( FOR key_row in keys ( %key = key_row-%key ) )
             RESULT DATA(lt_travel_status).

        result = VALUE #( for ls_travel in lt_travel_status (
                        %key = ls_travel-%key
                        %field-TravelId = if_abap_behv=>fc-f-read_only
                        %field-OverallStatus = if_abap_behv=>fc-f-read_only
                        %assoc-_Booking      = if_abap_behv=>fc-o-enabled
                        %action-acceptTravel = cond #( WHEN ls_travel-OverallStatus = 'A'
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled
                                                       )
                        %action-rejectTravel = cond #( WHEN ls_travel-OverallStatus = 'X'
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled
                                                       )
                         ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.

        DATA(lv_auth) = cond #( WHEN cl_abap_context_info=>get_user_technical_name(  ) eq 'CB9980006569'
                                THEN if_abap_behv=>auth-allowed
                                ELSE if_abap_behv=>auth-unauthorized ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).

        APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).
        <ls_result> = VALUE #( %key = <ls_keys>-%key
                               %op-%update = lv_auth
                               %delete     = lv_auth
                               %action-acceptTravel = lv_auth
                               %action-rejectTravel = lv_auth
                               %action-createTravelByTemplate = lv_auth
                               %assoc-_Booking = lv_auth ).
         ENDLOOP.
  ENDMETHOD.

  METHOD acceptTravel.

        MODIFY ENTITIES OF zcd_i_travel_alfa02 IN LOCAL MODE
               ENTITY Travel
               UPDATE FIELDS ( OverallStatus )
               WITH VALUE #( FOR key_row in keys ( TravelId = key_row-TravelId
                                                   OverallStatus = 'A' ) )
               FAILED failed
               REPORTED reported.

        READ ENTITIES OF zcd_i_travel_alfa02 IN LOCAL MODE
             ENTITY Travel
             FIELDS (   TravelId
                        AgencyId
                        CustomerId
                        BeginDate
                        EndDate
                        BookingFee
                        TotalPrice
                        CurrencyCode
                        Description
                        OverallStatus
                        CreatedBy
                        CreatedAt
                        LastChangedBy
                        LastChangedAt )
              WITH VALUE #( FOR key_row1 in keys ( TravelId = key_row1-TravelId ) )
              RESULT DATA(lt_travel).

         result = VALUE #( FOR ls_travel in lt_travel ( TravelId = ls_travel-TravelId
                                                        %param   = ls_travel ) ).

         LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

            DATA(lv_travel_msg) = <ls_travel>-TravelId.

            SHIFT lv_travel_msg LEFT DELETING LEADING '0'.

            APPEND VALUE #( TravelId = <ls_travel>-TravelId
                            %msg = new_message( id = 'Z_MC_TRAVEL_A223'
                                                number = '001'
                                                v1     = lv_travel_msg
                                                severity = if_abap_behv_message=>severity-success )
                           %element-CustomerId = if_abap_behv=>mk-on
                                                ) to reported-travel.

         ENDLOOP.



  ENDMETHOD.

  METHOD createTravelByTemplate.

         READ ENTITIES OF zcd_i_travel_alfa02
         ENTITY Travel
         FIELDS ( TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode )
         WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
         RESULT DATA(lt_read_entity_travel)
         FAILED failed
         REPORTED reported.

  DATA lt_create_travel TYPE TABLE FOR CREATE zcd_i_travel_alfa02\\Travel.

  SELECT max( travel_id ) from ztb_travel_alfa2
       INTO @DATA(lv_travel_id).



DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

lt_create_travel = VALUE #( FOR create_row in lt_read_entity_travel INDEX INTO idx
                          ( TravelId = lv_travel_id + idx
                            AgencyId = create_row-AgencyId
                            CustomerId = create_row-CustomerId
                            BeginDate = lv_today
                            EndDate = lv_today + 30
                            BookingFee = create_row-BookingFee
                            TotalPrice = create_row-TotalPrice
                            CurrencyCode = create_row-CurrencyCode
                            Description = 'Add Comments'
                            OverallStatus = 'O' ) ).

    MODIFY ENTITIES OF zcd_i_travel_alfa02
           in LOCAL MODE ENTITY travel
           CREATE FIELDS ( TravelId
                           AgencyId
                           CustomerId
                           BeginDate
                           EndDate
                           BookingFee
                           TotalPrice
                           CurrencyCode
                           Description
                           OverallStatus )
           WITH lt_create_travel
           MAPPED mapped
           FAILED failed
           REPORTED reported.

    RESULT = VALUE #( FOR result_row in lt_create_travel INDEX INTO idx
                    ( %cid_ref = keys[ idx ]-%cid_ref
                      %key     = keys[ idx ]-%key
                      %param   = CORRESPONDING #( result_row ) ) ).

  ENDMETHOD.

  METHOD rejectTravel.

      MODIFY ENTITIES OF zcd_i_travel_alfa02 IN LOCAL MODE
               ENTITY Travel
               UPDATE FIELDS ( OverallStatus )
               WITH VALUE #( FOR key_row in keys ( TravelId = key_row-TravelId
                                                   OverallStatus = 'X' ) )
               FAILED failed
               REPORTED reported.

        READ ENTITIES OF zcd_i_travel_alfa02 IN LOCAL MODE
             ENTITY Travel
             FIELDS (   TravelId
                        AgencyId
                        CustomerId
                        BeginDate
                        EndDate
                        BookingFee
                        TotalPrice
                        CurrencyCode
                        Description
                        OverallStatus
                        CreatedBy
                        CreatedAt
                        LastChangedBy
                        LastChangedAt )
              WITH VALUE #( FOR key_row1 in keys ( TravelId = key_row1-TravelId ) )
              RESULT DATA(lt_travel).

         result = VALUE #( FOR ls_travel in lt_travel ( TravelId = ls_travel-TravelId
                                                        %param   = ls_travel ) ).

         LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

            DATA(lv_travel_msg) = <ls_travel>-TravelId.

            SHIFT lv_travel_msg LEFT DELETING LEADING '0'.

            APPEND VALUE #( TravelId = <ls_travel>-TravelId
                            %msg = new_message( id = 'Z_MC_TRAVEL_A223'
                                                number = '002'
                                                v1     = lv_travel_msg
                                                severity = if_abap_behv_message=>severity-success )
                           %element-CustomerId = if_abap_behv=>mk-on
                                                ) to reported-travel.

         ENDLOOP.


  ENDMETHOD.

  METHOD validateCustomer.

         READ ENTITIES OF zcd_i_travel_alfa02 IN LOCAL MODE
         ENTITY Travel
         FIELDS ( CustomerId )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_travel).

         DATA lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

         lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId EXCEPT * ).

         DELETE lt_customer WHERE customer_id IS INITIAL.

         SELECT FROM /dmo/customer FIELDS customer_id
                FOR ALL ENTRIES IN @lt_customer
                WHERE customer_id eq @lt_customer-customer_id
                INTO TABLE @DATA(lt_customer_db).


         LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
            IF <ls_travel>-CustomerId is INITIAL
               or not line_exists( lt_customer_db[ customer_id = <ls_travel>-CustomerId ] ).

            APPEND VALUE #( TravelId = <ls_travel>-TravelId ) to failed-travel.

            APPEND VALUE #( TravelId = <ls_travel>-TravelId
                            %msg = new_message( id = 'Z_MC_TRAVEL_A223'
                                                number = '003'
                                                v1     = <ls_travel>-TravelId
                                                severity = if_abap_behv_message=>severity-error )
                           %element-CustomerId = if_abap_behv=>mk-on
                                                ) to reported-travel.


            ENDIF.
         ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.

        READ ENTITIES OF zcd_i_travel_alfa02 IN LOCAL MODE
         ENTITY Travel
         FIELDS ( BeginDate EndDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_travel_dates).

     LOOP AT lt_travel_dates INTO DATA(ls_travel_result).
        IF ls_travel_result-EndDate LT ls_travel_result-BeginDate.

            APPEND VALUE #( %key = ls_travel_result-%key
                            TravelId = ls_travel_result-TravelId ) to failed-travel.

            APPEND VALUE #( %key = ls_travel_result-%key
                            %msg = new_message( id = 'Z_MC_TRAVEL_A223'
                                               number = '005'
                                               v1  = ls_travel_result-BeginDate
                                               v2  = ls_travel_result-EndDate
                                               v3  = ls_travel_result-TravelId
                                               severity = if_abap_behv_message=>severity-error )
                           %element-BeginDate = if_abap_behv=>mk-on
                           %element-EndDate   = if_abap_behv=>mk-on ) TO reported-travel.


        ELSEIF ls_travel_result-BeginDate < cl_abap_context_info=>get_system_date(  ).

            APPEND VALUE #( %key = ls_travel_result-%key
                            TravelId = ls_travel_result-TravelId ) TO failed-travel.

            APPEND VALUE #( %key = ls_travel_result-%key
                            %msg = new_message( id = 'Z_MC_TRAVEL_A223'
                                               number = '004'
                                               severity = if_abap_behv_message=>severity-error )
                            %element-BeginDate = if_abap_behv=>mk-on
                            %element-EndDate   = if_abap_behv=>mk-on ) TO reported-travel.
        ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateStatus.

        READ ENTITY zcd_i_travel_alfa02
        fields ( OverallStatus )
        WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
         result DATA(lt_travel_result).

        LOOP AT lt_travel_result INTO DATA(ls_travel_result).

            CASE ls_travel_result-OverallStatus.
            WHEN 'O'.
            WHEN 'X'.
            WHEN 'A'.
            WHEN OTHERS.
                 APPEND VALUE #( %key = ls_travel_result-%key ) TO failed-travel.

                 APPEND VALUE #( %key = ls_travel_result-%key
                                 %msg = new_message( id = 'Z_MC_TRAVEL_A223'
                                               number = '006'
                                               severity = if_abap_behv_message=>severity-error )
                            %element-BeginDate = if_abap_behv=>mk-on
                            %element-EndDate   = if_abap_behv=>mk-on ) TO reported-travel.
            ENDCASE.

        ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCD_I_TRAVEL_ALFA02 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PUBLIC SECTION.
  CONSTANTS: create TYPE string value 'CREATE',
             update TYPE string value 'UPDATE',
             delete TYPE string value 'DELETE'.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCD_I_TRAVEL_ALFA02 IMPLEMENTATION.

  METHOD save_modified.

        DATA: lt_travel_log TYPE STANDARD TABLE OF ztb_log_alfa02,
              lt_travel_log_u TYPE STANDARD TABLE OF ztb_log_alfa02.


        DATA(lv_user) = cl_abap_context_info=>get_user_technical_name(  ).


        IF NOT create-travel is INITIAL.

            lt_travel_log = CORRESPONDING #( create-travel MAPPING travel_id = TravelId ).

            LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).
                GET TIME STAMP FIELD <ls_travel_log>-created_at.

                <ls_travel_log>-changing_operation = lsc_zcd_i_travel_alfa02=>create.
                READ TABLE create-travel WITH TABLE KEY entity COMPONENTS TravelId = <ls_travel_log>-travel_id
                INTO DATA(ls_travel).

                IF sy-subrc eq 0.
                    IF ls_travel-%control-BookingFee eq cl_abap_behv=>flag_changed.
                       <ls_travel_log>-changed_field_name = 'BookingFee'.
                       <ls_travel_log>-changed_value      = ls_travel-BookingFee.
                       <ls_travel_log>-user_mod           = lv_user.
                       TRY.
                            <ls_travel_log>-change_id     = cl_system_uuid=>create_uuid_x16_static(  ).
                       CATCH cx_uuid_error.
                       ENDTRY.
                       APPEND <ls_travel_log> TO lt_travel_log_u.
                    ENDIF.
                ENDIF.
            ENDLOOP.
        ENDIF.

        IF NOT update-travel is INITIAL.
           lt_travel_log = CORRESPONDING #( update-travel MAPPING travel_id = TravelId ).

           LOOP AT update-travel INTO DATA(ls_update_travel).

                ASSIGN lt_travel_log[ travel_id = ls_update_travel-TravelId ] TO FIELD-SYMBOL(<ls_travel_log_bd>).

                GET TIME STAMP FIELD <ls_travel_log_bd>-created_at.

                <ls_travel_log_bd>-changing_operation = lsc_zcd_i_travel_alfa02=>update.

                IF ls_update_travel-%control-CustomerId EQ cl_abap_behv=>flag_changed.

                    <ls_travel_log_bd>-changed_field_name = 'CustomerId'.
                    <ls_travel_log_bd>-changed_value      = ls_update_travel-CustomerId.
                    <ls_travel_log_bd>-user_mod           = lv_user.

                    try.
                        <ls_travel_log_bd>-change_id     = cl_system_uuid=>create_uuid_x16_static(  ).
                    CATCH cx_uuid_error.
                    ENDTRY.
                    APPEND <ls_travel_log_bd> TO lt_travel_log_u.
                ENDIF.
           ENDLOOP.
        ENDIF.

        IF NOT delete-travel is INITIAL.

            lt_travel_log = CORRESPONDING #( delete-travel MAPPING travel_id = TravelId ).

            LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log_del>).
                GET TIME STAMP FIELD <ls_travel_log_del>-created_at.

                <ls_travel_log_del>-changing_operation = lsc_zcd_i_travel_alfa02=>delete.
                <ls_travel_log_del>-user_mod           = lv_user.
                    TRY.
                        <ls_travel_log_del>-change_id          = cl_system_uuid=>create_uuid_x16_static(  ).
                    CATCH cx_uuid_error.
                    ENDTRY.
                APPEND <ls_travel_log_del> TO lt_travel_log_u.
            ENDLOOP.
        ENDIF.

        IF NOT lt_travel_log_u is INITIAL.
            INSERT ztb_log_alfa02 FROM TABLE @lt_travel_log_u.
        ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
