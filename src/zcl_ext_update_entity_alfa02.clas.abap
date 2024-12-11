CLASS zcl_ext_update_entity_alfa02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
        INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ext_update_entity_alfa02 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

        MODIFY ENTITIES OF zcd_i_travel_alfa02
               ENTITY Travel
               UPDATE FIELDS ( AgencyId Description )
               WITH VALUE #( ( TravelId = '00000012'
                               AgencyId = '070099'
                               Description = 'Nuevo viaje' ) )
               FAILED data(failed)
               reported data(reported).

        READ ENTITIES OF zcd_i_travel_alfa02
             ENTITY Travel
             FIELDS ( AgencyId Description )
             WITH VALUE #( ( TravelId = '00000012' ) )
             RESULT DATA(lt_travel_data)
             FAILED failed
             REPORTED reported.

       COMMIT ENTITIES.

       IF failed is INITIAL.
          out->write( 'Commit Successfull' ).
       ELSE.
          out->write( 'Commit Failed' ).
       ENDIF.

  ENDMETHOD.


ENDCLASS.
