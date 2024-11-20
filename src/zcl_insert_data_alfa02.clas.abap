CLASS zcl_insert_data_alfa02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insert_data_alfa02 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: lt_travel     TYPE TABLE OF ztb_travel_alfa2,
          lt_booking    TYPE TABLE OF ztb_booking_alf2,
          lt_book_sup  TYPE table of ztb_booksuppl_a2.

    SELECT travel_id,
           agency_id,
           customer_id,
           begin_date,
           end_date,
           booking_fee,
           total_price,
           currency_code,
           description,
           status AS overall_status,
           createdby AS created_by,
           createdat AS created_at,
           lastchangedby AS last_changed_by,
           lastchangedat AS last_changed_at
    FROM /dmo/travel INTO CORRESPONDING FIELDS OF TABLE @lt_travel
    UP TO 15 ROWS.

    SELECT * FROM /dmo/booking INTO CORRESPONDING FIELDS OF
             TABLE @lt_booking.

    SELECT * FROM /dmo/book_suppl INTO CORRESPONDING FIELDS OF
             TABLE @lt_book_sup.

    DELETE FROM: ztb_travel_alfa2,
                 ztb_booking_alf2,
                 ztb_booksuppl_a2.

    INSERT: ztb_travel_alfa2 FROM TABLE @lt_travel,
            ztb_booking_alf2 FROM TABLE @lt_booking,
            ztb_booksuppl_a2 FROM TABLE @lt_book_sup.

    out->write( 'DONE!' ).


  ENDMETHOD.
ENDCLASS.
