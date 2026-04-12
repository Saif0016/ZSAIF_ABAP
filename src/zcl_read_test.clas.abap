CLASS zcl_read_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_read_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*    sort form read

*    READ ENTITY zi_travel_saif_m
*        fiELDS ( AgencyId BeginDate BookingFee CreatedAt CustomerId TotalPrice )
*       WITH  VALUE #( ( %key-TravelId = '00004247'
*           ) )
*        RESULT DATA(lt_result_short)
*        FAILED DATA(lt_failed_short).


*    READ ENTITY zi_travel_saif_m
*           ALL FIELDS
*           WITH  VALUE #( ( %key-TravelId = '00004247'
*               ) )
*            RESULT DATA(lt_result_short)
*            FAILED DATA(lt_failed_short).

* READ ENTITY zi_travel_saif_m
*            bY \_booking
*           ALL FIELDS
*           WITH  VALUE #( ( %key-TravelId = '00000019'
*               ) )
*            RESULT DATA(lt_result_short)
*
*            FAILED DATA(lt_failed_short).

** Read Entity long form

*    READ ENTITIES OF zi_travel_saif_m
*           ENTITY zi_travel_saif_m
*              ALL FIELDS
*              WITH  VALUE #( ( %key-TravelId = '00000019'
*                  ) )
*               RESULT DATA(lt_result_short)
*           ENTITY zi_booking_saif_m
*                ALL FIELDS WITH
*                VALUE #( ( %key-TravelId = '00000019'
*                           %key-BookingId = '0001' )
*                          (  %key-TravelId = '00000019'
*                           %key-BookingId = '0002' ) )
*                 RESULT DATA(lt_book_short)
*               FAILED DATA(lt_failed_short).


*    IF lt_failed_short IS NOT  INITIAL.
*      out->write( 'Read Failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*      out->write( lt_book_short ).
*    ENDIF.


    DATA : it_optab         TYPE abp_behv_retrievals_tab,
           it_travel        TYPE TABLE FOR READ IMPORT zi_travel_saif_m,
           it_travel_result TYPE TABLE FOR READ RESULT zi_travel_saif_m,
           it_booking       TYPE TABLE FOR READ IMPORT zi_booking_saif_m,
           it_booking_res   TYPE TABLE FOR READ RESULT zi_booking_saif_m.


    it_travel = VALUE #( ( %key-TravelId = '00000019'
                           %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                               CustomerId =  if_abap_behv=>mk-on
                                               BeginDate =  if_abap_behv=>mk-on
                                               EndDate =  if_abap_behv=>mk-on ) ) ).

    it_booking = VALUE #( ( %key-TravelId = '00000019'
                            %control = VALUE #( BookingDate = if_abap_behv=>mk-on
                                                BookingId   = if_abap_behv=>mk-on ) ) ).



    it_optab = VALUE #( ( op = if_abap_behv=>op-r-read
                          entity_name = 'ZI_TRAVEL_SAIF_M'
                          instances = REF #( it_travel )
                          results = REF #( it_travel_result ) )
                        ( op = if_abap_behv=>op-r-read_ba
                          entity_name = 'ZI_TRAVEL_SAIF_M'
                          sub_name = '_BOOKING'
                          instances = REF #( it_booking )
                          results = REF #( it_booking_res )
                           ) ).

    READ ENTITIES
        OPERATIONS it_optab
        FAILED DATA(lt_failed_short).


    IF lt_failed_short IS NOT  INITIAL.
      out->write( 'Read Failed' ).
    ELSE.
      out->write( it_travel_result ).
      out->write( it_booking_res ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
