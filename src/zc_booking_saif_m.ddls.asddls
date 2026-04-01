@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking consumption view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_BOOKING_SAIF_M as projection on ZI_BOOKING_SAIF_M
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _bookingsuppl : redirected to composition child ZC_BOOKSUP_SAIF_M,
    _booking_status,
    _carrier,
    _connection,
    _customer,
    _travel : redirected to parent ZC_TRAVEL_SAIF_M
}
