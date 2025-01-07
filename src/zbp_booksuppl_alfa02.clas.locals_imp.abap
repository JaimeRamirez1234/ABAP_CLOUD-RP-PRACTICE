CLASS lhc_BookSupplement DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalSupplimPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR BookSupplement~calculateTotalSupplimPrice.

ENDCLASS.

CLASS lhc_BookSupplement IMPLEMENTATION.

  METHOD calculateTotalSupplimPrice.

*        IF NOT keys IS INITIAL.
*            zcl_aux_travel_det_alfa02=>calculate_total( it_travel_id =
*                                                           VALUE #( for GROUPS <booking> of booking_key in keys
*                                                           group by booking_key-TravelId WITHOUT MEMBERS ( <booking> ) ) ).
*        ENDIF.
IF NOT keys IS INITIAL.
        zcl_aux_travel_det_alfa02=>calculate_total( it_travel_id =
                                                 VALUE #( FOR GROUPS <booking_suppl> OF booking_key IN keys
                                                 GROUP BY booking_key-TravelId WITHOUT MEMBERS ( <booking_suppl> ) ) ).
ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS LSC_SUPPLEMENT DEFINITION INHERITING FROM cl_abap_behavior_saver.

      PUBLIC SECTION.
            CONSTANTS: create TYPE STRING VALUE 'C',
                       update TYPE STRING VALUE 'U',
                       delete TYPE STRING VALUE 'D'.

      PROTECTED SECTION.
        METHODS SAVE_MODIFIED REDEFINITION.

ENDCLASS.

CLASS lsc_supplement IMPLEMENTATION.

  METHOD save_modified.

         DATA: lt_supplement TYPE STANDARD TABLE OF ztb_booksuppl_a2,
               lv_op_type    TYPE zde_flag_alfa02,
               lv_updated    TYPE zde_flag_alfa02.

         IF NOT create-booksupplement IS INITIAL.
            lt_supplement = CORRESPONDING #( create-booksupplement ).
            lv_op_type = lsc_supplement=>create.
         ENDIF.

         IF NOT update-booksupplement IS INITIAL.
            lt_supplement = CORRESPONDING #( update-booksupplement ).
            lv_op_type = lsc_supplement=>update.
         ENDIF.

         IF NOT delete-booksupplement IS INITIAL.
            lt_supplement = CORRESPONDING #( delete-booksupplement ).
            lv_op_type = lsc_supplement=>delete.
         ENDIF.

         IF NOT lt_supplement IS INITIAL.

            CALL FUNCTION 'ZFM_SUPPL_A223'
                 EXPORTING
                    it_supplements = lt_supplement
                    iv_op_type     = lv_op_type
                 IMPORTING
                    ev_updated     = lv_updated.


            IF lv_updated eq abap_true.
*                reported-booksupplement
            ENDIF.

         ENDIF.

  ENDMETHOD.

ENDCLASS.
