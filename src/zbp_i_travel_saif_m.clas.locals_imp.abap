CLASS lhc_ZI_TRAVEL_SAIF_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_saif_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_saif_m RESULT result.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_saif_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_saif_m~copytravel.

    METHODS recalctotprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_saif_m~recalctotprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_saif_m~rejecttravel RESULT result.


    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities
                  FOR CREATE zi_travel_saif_m\_booking.


    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_saif_m.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_SAIF_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.

    DELETE lt_entities WHERE TravelId IS NOT INITIAL.

    TRY.

        CALL METHOD cl_numberrange_runtime=>number_get
          EXPORTING
*           ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
*           subobject         =
*           toyear            =
          IMPORTING
            number            = DATA(lv_latest_num)
            returncode        = DATA(lv_code)
            returned_quantity = DATA(lv_qty).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).
        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #( %cid  = ls_entities-%cid
                          %key  = ls_entities-%key )
                      TO failed-zi_travel_saif_m.

          APPEND VALUE #( %cid  = ls_entities-%cid
                          %key  = ls_entities-%key
                          %msg  = lo_error )
                      TO reported-zi_travel_saif_m.
        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).

    DATA(lv_curr_num) = lv_latest_num - lv_qty.

    CLEAR ls_entities.

    LOOP AT lt_entities INTO ls_entities.

      lv_curr_num = lv_curr_num + 1.

      APPEND VALUE #(  %cid = ls_entities-%cid
                       TravelId = lv_curr_num ) TO  mapped-zi_travel_saif_m.

    ENDLOOP.

  ENDMETHOD.



  METHOD earlynumbering_cba_Booking.

    DATA : lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF zi_travel_saif_m IN LOCAL MODE
    ENTITY zi_travel_saif_m BY \_booking FROM CORRESPONDING #( entities )
    LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
        GROUP BY <ls_group_entity>-TravelId .


      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                 FOR ls_link IN lt_link_data USING KEY entity
                                 WHERE ( source-TravelId = <ls_group_entity>-TravelId )
                                 NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                 THEN ls_link-target-BookingId
                                 ELSE lv_max ) ).


      lv_max_booking = REDUCE #( INIT lv_max =  lv_max_booking FOR ls_entity IN entities USING KEY entity
                                          WHERE ( TravelId = <ls_group_entity>-TravelId )
                                   FOR ls_booking IN ls_entity-%target
                                   NEXT lv_max =  COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                 THEN ls_booking-BookingId
                                 ELSE lv_max )    ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>) USING KEY entity WHERE TravelId = <ls_group_entity>-TravelId  .

        LOOP AT <ls_entity>-%target ASSIGNING FIELD-SYMBOL(<ls_target>).

        APPEND CORRESPONDING #( <ls_target> ) TO mapped-zi_booking_saif_m ASSIGNING FIELD-SYMBOL(<Ls_new_map_booking>).

          IF <ls_target>-BookingId IS INITIAL.

            lv_max_booking += 10.


            <Ls_new_map_booking>-BookingId = lv_max_booking.


          ENDIF.
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.



  ENDMETHOD.


  METHOD acceptTravel.

  ModiFY enTITIES OF zi_travel_saif_m in local MODE
  enTITY zi_travel_saif_m
  update fieLDS ( OverallStatus )
  with VALUE #( for ls_keys  in keys ( %tky = ls_keys-%tky
                                        OverallStatus = 'A' ) )
  rePORTED data(lt_travel).

  read eNTITIES OF zi_travel_saif_m in local MODE
  enTITY zi_travel_saif_m
  alL FIELDS WITH corRESPONDING #( keys )
  resULT data(lt_result).

  result = Value #( for ls_result in lt_result ( %tky = ls_result-%tky %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyTravel.

    DATA : lt_travel       TYPE TABLE FOR CREATE zi_travel_saif_m,
           lt_booking_cba  TYPE TABLE FOR CREATE zi_travel_saif_m\_booking,
           lt_booksupl_cba TYPE TABLE FOR CREATE zi_booking_saif_m\_bookingsuppl.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF zi_travel_saif_m IN LOCAL MODE
    ENTITY zi_travel_saif_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_failed).

    READ ENTITIES OF zi_travel_saif_m IN LOCAL MODE
    ENTITY zi_travel_saif_m BY \_booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).

    READ ENTITIES OF zi_travel_saif_m IN LOCAL MODE
    ENTITY zi_booking_saif_m BY \_bookingsuppl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booksup_r).

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId  ) )
                     TO lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel>-EndDate   = cl_abap_context_info=>get_system_date( ) + 30.
      <ls_travel>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid ) TO lt_booking_cba
      ASSIGNING FIELD-SYMBOL(<it_booking>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                           USING KEY entity WHERE TravelId = <ls_travel_r>-TravelId.

        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelId ) )
                        TO <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_new>).

        <ls_booking_new>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_new>-%cid ) TO lt_booksupl_cba
    ASSIGNING FIELD-SYMBOL(<ls_booksupp>).

        LOOP AT lt_booksup_r ASSIGNING FIELD-SYMBOL(<ls_booksupp_r>)
                              USING KEY entity
                              WHERE TravelId = <ls_travel_r>-TravelId
                              AND BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksupp_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_booking_new> EXCEPT  TravelId BookingId ) )
                          TO <ls_booksupp>-%target.

        ENDLOOP.



      ENDLOOP.



    ENDLOOP.

     MODIFY ENTITIES OF zi_travel_saif_m IN LOCAL MODE
        ENTITY zi_travel_saif_m
        CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
        WITH lt_travel
        ENTITY zi_travel_saif_m
        CREATE BY \_booking
        FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
        WITH lt_booking_cba
        ENTITY zi_booking_saif_m
        CREATE BY \_bookingsuppl
        FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
        WITH lt_booksupl_cba
        MAPPED DATA(lt_mapped).

        mapped-zi_travel_saif_m = lt_mapped-zi_travel_saif_m.




  ENDMETHOD.

  METHOD recalcTotPrice.
  ENDMETHOD.

  METHOD rejectTravel.

   ModiFY enTITIES OF zi_travel_saif_m in local MODE
  enTITY zi_travel_saif_m
  update fieLDS ( OverallStatus )
  with VALUE #( for ls_keys  in keys ( %tky = ls_keys-%tky
                                        OverallStatus = 'X' ) )
  rePORTED data(lt_travel).

  read eNTITIES OF zi_travel_saif_m in local MODE
  enTITY zi_travel_saif_m
  alL FIELDS WITH corRESPONDING #( keys )
  resULT data(lt_result).

  result = Value #( for ls_result in lt_result ( %tky = ls_result-%tky %param = ls_result ) ).
  ENDMETHOD.

ENDCLASS.
