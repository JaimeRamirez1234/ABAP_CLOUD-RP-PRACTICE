FUNCTION zfm_suppl_a223.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_SUPPLEMENTS) TYPE  ZTT_SUPPLE_A223
*"     REFERENCE(IV_OP_TYPE) TYPE  ZDE_FLAG_ALFA02
*"  EXPORTING
*"     REFERENCE(EV_UPDATED) TYPE  ZDE_FLAG_ALFA02
*"----------------------------------------------------------------------
    CHECK NOT it_supplements is INITIAL.

    CASE iv_op_type.

        WHEN 'C'.
            INSERT ztb_booksuppl_a2 FROM TABLE @it_supplements.
        WHEN 'U'.
            UPDATE ztb_booksuppl_a2 FROM TABLE @it_supplements.
        WHEN 'D'.
            DELETE ztb_booksuppl_a2 FROM TABLE @it_supplements.
    ENDCASE.

    IF sy-subrc eq 0.

        ev_updated = abap_true.

    ENDIF.

ENDFUNCTION.
