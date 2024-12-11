CLASS lhc_BookSupplement DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalSupplimPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR BookSupplement~calculateTotalSupplimPrice.

ENDCLASS.

CLASS lhc_BookSupplement IMPLEMENTATION.

  METHOD calculateTotalSupplimPrice.

        IF NOT keys IS INITIAL.
            zcl_aux_travel_det_alfa02=>calculate_total( it_travel_id =
                                                           VALUE #( for GROUPS <booking> of booking_key in keys
                                                           group by booking_key-TravelId WITHOUT MEMBERS ( <booking> ) ) ).
        ENDIF.

  ENDMETHOD.

ENDCLASS.
