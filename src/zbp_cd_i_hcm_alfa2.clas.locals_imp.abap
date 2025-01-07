CLASS lcl_buffer DEFINITION.

  PUBLIC SECTION.
    CONSTANTS: created TYPE c LENGTH 1 VALUE 'C',
               updated TYPE c LENGTH 1 VALUE 'U',
               deleted TYPE c LENGTH 1 VALUE 'D'.

    TYPES: BEGIN OF ty_buffer_master.
             INCLUDE TYPE zhc_master_alfa2 AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer_master.

    TYPES: tt_master TYPE SORTED TABLE OF ty_buffer_master WITH UNIQUE KEY e_number.

    CLASS-DATA mt_buffer_master TYPE tt_master.


ENDCLASS.

CLASS lhc_zcd_i_hcm_alfa2 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS: create FOR MODIFY IMPORTING entities FOR CREATE zcd_i_hcm_alfa2,
             update FOR MODIFY IMPORTING entities FOR UPDATE zcd_i_hcm_alfa2,
             delete FOR MODIFY IMPORTING keys FOR DELETE zcd_i_hcm_alfa2,
             read FOR READ IMPORTING keys FOR READ zcd_i_hcm_alfa2 RESULT result.

ENDCLASS.

CLASS lhc_zcd_i_hcm_alfa2 IMPLEMENTATION.

  METHOD create.

    GET TIME STAMP FIELD DATA(lv_time_stamp).
    DATA(lv_uname) = cl_abap_context_info=>get_user_technical_name(  ).

    SELECT MAX( e_number ) FROM zhc_master_alfa2
              INTO @DATA(lv_max_employee_number).

    lv_max_employee_number += 1.

    LOOP AT entities INTO DATA(ls_entities).
        ls_entities-%data-crea_date_time = lv_time_stamp.
        ls_entities-crea_uname = lv_uname.
        ls_entities-e_number = lv_max_employee_number.

        INSERT VALUE #( flag = lcl_buffer=>created
                        data = CORRESPONDING #( ls_entities-%data ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

        IF NOT ls_entities-%cid IS INITIAL.
           INSERT VALUE #( %cid = ls_entities-%cid
                           e_number = ls_entities-e_number ) INTO TABLE mapped-zcd_i_hcm_alfa2.
        ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD update.

        GET TIME STAMP FIELD DATA(lv_time_stamp).
        DATA(lv_uname) = cl_abap_context_info=>get_user_technical_name(  ).

        LOOP AT entities INTO DATA(ls_entities).

            SELECT SINGLE * FROM zhc_master_alfa2
                   WHERE e_number EQ @ls_entities-%data-e_number
                   INTO @DATA(ls_ddbb).

            ls_entities-%data-lchg_date_time = lv_time_stamp.
            ls_entities-lchg_uname = lv_uname.

            INSERT VALUE #( flag = lcl_buffer=>updated
                            data = VALUE #( e_number = ls_entities-%data-e_number
                                            e_name   = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entities-%data-e_name
                                                       ELSE ls_ddbb-e_name )
                                            e_department = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entities-%data-e_name
                                                       ELSE ls_ddbb-e_name )
                                            status = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entities-%data-e_name
                                                       ELSE ls_ddbb-e_name )
                                            job_title = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entities-%data-e_name
                                                       ELSE ls_ddbb-e_name )
                                            start_date = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entities-%data-e_name
                                                       ELSE ls_ddbb-e_name )
                                            end_date = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entities-%data-e_name
                                                       ELSE ls_ddbb-e_name )
                                            email = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entities-%data-e_name
                                                       ELSE ls_ddbb-e_name )
                                           m_number = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                      THEN ls_entities-%data-e_name
                                                      ELSE ls_ddbb-e_name )
                                           m_name = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                      THEN ls_entities-%data-e_name
                                                      ELSE ls_ddbb-e_name )
                                           m_department = COND #( WHEN ls_entities-%control-e_name EQ if_abap_behv=>mk-on
                                                      THEN ls_entities-%data-e_name
                                                      ELSE ls_ddbb-e_name )
                                           crea_date_time = ls_ddbb-crea_date_time
                                           crea_uname = ls_ddbb-crea_uname
                                            ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

        ENDLOOP.

        IF NOT ls_entities-e_number is INITIAL.
            INSERT VALUE #( %cid = ls_entities-%data-e_number
                            e_number = ls_entities-%data-e_number ) INTO TABLE mapped-zcd_i_hcm_alfa2.
        ENDIF.

  ENDMETHOD.



  METHOD delete.

        LOOP AT keys INTO DATA(ls_keys).
            INSERT VALUE #( flag = lcl_buffer=>deleted
                            data = VALUE #( e_number = ls_keys-e_number ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

        IF NOT ls_keys-e_number IS INITIAL.

            INSERT VALUE #( %cid = ls_keys-%key-e_number
                            e_number = ls_keys-%key-e_number ) INTO TABLE mapped-zcd_i_hcm_alfa2.

        ENDIF.

        ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCD_I_HCM_ALFA2 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCD_I_HCM_ALFA2 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA: lt_data_created  TYPE STANDARD TABLE OF zhc_master_alfa2,
          lt_data_updated  TYPE STANDARD TABLE OF zhc_master_alfa2,
          lt_data_deleted  TYPE STANDARD TABLE OF zhc_master_alfa2.

    lt_data_created = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master
                               WHERE ( flag = lcl_buffer=>created ) ( <row>-data ) ).

    IF NOT lt_data_created IS INITIAL.
        INSERT zhc_master_alfa2 FROM TABLE @lt_data_created.
    ENDIF.



    lt_data_updated = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master
                               WHERE ( flag = lcl_buffer=>updated ) ( <row>-data ) ).

    IF NOT lt_data_updated IS INITIAL.
        UPDATE zhc_master_alfa2 FROM TABLE @lt_data_updated.
    ENDIF.


    lt_data_deleted = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master
                               WHERE ( flag = lcl_buffer=>deleted ) ( <row>-data ) ).

    IF NOT lt_data_deleted IS INITIAL.
        DELETE zhc_master_alfa2 FROM TABLE @lt_data_deleted.
    ENDIF.

    clear lcl_buffer=>mt_buffer_master.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
