CLASS zcl_virt_elem_alfa02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
        INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_virt_elem_alfa02 IMPLEMENTATION.

    METHOD if_sadl_exit_calc_element_read~get_calculation_info.

            IF iv_entity = 'ZCD_C_TRAVEL_A_A2'.
               LOOP AT it_requested_calc_elements INTO data(ls_calc_elements).

                    IF ls_calc_elements = 'DISCOUNTPRICE'.

                        APPEND 'TOTALPRICE' TO et_requested_orig_elements.

                    ENDIF.

               ENDLOOP.
            ENDIF.

    ENDMETHOD.

    METHOD if_sadl_exit_calc_element_read~calculate.

        DATA lt_original_data TYPE STANDARD TABLE OF ZCD_C_TRAVEL_A_A2 WITH DEFAULT KEY.

        lt_original_data = CORRESPONDING #( it_original_data ).

        LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<ls_original_data>).

            <ls_original_data>-DiscountPrice = <ls_original_data>-TotalPrice - ( <ls_original_data>-TotalPrice * ( 1 / 10 ) ).

        ENDLOOP.

        ct_calculated_data = CORRESPONDING #( lt_original_data ).

    ENDMETHOD.



ENDCLASS.
