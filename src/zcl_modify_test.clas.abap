CLASS zcl_modify_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_modify_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA : lt_book TYPE TABLE FOR CREATE zi_travel_saif_m\_booking.

** Modify short form with create
*    MODIFY ENTITY zi_travel_saif_m
*    CREATE FROM VALUE #( (
*        %cid = 'cid1'
*        %data-BeginDate = '20260413'
*        %control-BeginDate = if_abap_behv=>mk-on
*        %data-EndDate  = '20260414'
*        %control-EndDate = if_abap_behv=>mk-on
*
*     ) )
*     CREATE BY \_booking
*     FROM VALUE #( ( %cid_ref = 'cid1'
*                     %target = VALUE #( (  %cid = 'cid11'
*                                        %data-BookingDate = '20250413'
*                                        %control-BookingDate = if_abap_behv=>mk-on ) ) ) )
*     FAILED FINAL(it_failed)
*     MAPPED FINAL(it_mapped)
*     REPORTED FINAL(it_result).
*
*    IF it_failed IS NOT INITIAL.
*
*      out->write( it_failed ).
*    ELSE.
*
*      COMMIT ENTITIES.
*
*    ENDIF.

*** Modify short form delete entity

**    MODIFY ENTITY zi_booking_saif_m
**    DELETE FROM VALUE #( ( %key-TravelId = '00004139'
**                           %key-BookingId = '0010' ) )
**    FAILED FINAL(it_failed1)
**    MAPPED FINAL(it_mapped1)
**    REPORTED FINAL(it_result1).
**
**    IF it_failed1 IS NOT INITIAL.
**
**      out->write( it_failed1 ).
**    ELSE.
**
**      COMMIT ENTITIES.
**
**    ENDIF.

*** modify entity longer form

    MODIFY ENTITIES OF zi_travel_saif_m
        ENTITY zi_travel_saif_m
        UPDATE FIELDS ( BeginDate )
        WITH VALUE #( (   %key-TravelId = '00004139'
                        BeginDate = '20260415' ) )
        ENTITY zi_travel_saif_m
        DELETE FROM VALUE #( (   TravelId = '00004140' ) ).

    COMMIT ENTITIES.


  ENDMETHOD.

ENDCLASS.
