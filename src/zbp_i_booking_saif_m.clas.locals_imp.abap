CLASS lhc_zi_booking_saif_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_booking_saif_m\_Bookingsuppl.

ENDCLASS.

CLASS lhc_zi_booking_saif_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA : lv_max_booking TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zi_travel_saif_m IN LOCAL MODE
    ENTITY zi_booking_saif_m BY \_bookingsuppl FROM CORRESPONDING #( entities )
    LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
          GROUP BY <ls_group_entity>-%tky .


      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                 FOR ls_link IN lt_link_data USING KEY entity
                                 WHERE ( source-TravelId = <ls_group_entity>-TravelId
                                         AND source-BookingId = <ls_group_entity>-BookingId  )
                                 NEXT lv_max = COND /dmo/booking_supplement_id( WHEN lv_max < ls_link-target-BookingSupplementId
                                 THEN ls_link-target-BookingSupplementId
                                 ELSE lv_max ) ).


      lv_max_booking = REDUCE #( INIT lv_max =  lv_max_booking FOR ls_entity IN entities USING KEY entity
                                          WHERE ( TravelId = <ls_group_entity>-TravelId
                                                  AND BookingId = <ls_group_entity>-BookingId )
                                   FOR ls_booking IN ls_entity-%target
                                   NEXT lv_max =  COND /dmo/booking_supplement_id( WHEN lv_max < ls_booking-BookingSupplementId
                                 THEN ls_booking-BookingSupplementId
                                 ELSE lv_max )    ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>) USING KEY entity WHERE TravelId = <ls_group_entity>-TravelId
                                                                            AND   BookingId = <ls_group_entity>-BookingId  .

        LOOP AT <ls_entity>-%target ASSIGNING FIELD-SYMBOL(<ls_target>).

          APPEND CORRESPONDING #( <ls_target> ) TO mapped-zi_booksup_saif_m ASSIGNING FIELD-SYMBOL(<Ls_new_map_booking>).
          IF <ls_target>-BookingSupplementId IS INITIAL.


            lv_max_booking += 10.


            <Ls_new_map_booking>-BookingSupplementId = lv_max_booking.


          ENDIF.
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
