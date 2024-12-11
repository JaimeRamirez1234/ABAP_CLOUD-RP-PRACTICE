CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalFlightPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalFlightPrice.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateStatus.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD calculateTotalFlightPrice.

        IF NOT keys IS INITIAL.

            zcl_aux_travel_det_alfa02=>calculate_total( it_travel_id =
                                                           VALUE #( for GROUPS <booking> of booking_key in keys
                                                           group by booking_key-TravelId WITHOUT MEMBERS ( <booking> ) ) ).

        ENDIF.

  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

ENDCLASS.
