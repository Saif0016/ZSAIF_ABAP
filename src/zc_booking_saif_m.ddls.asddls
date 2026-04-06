@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BOOKING_SAIF_M
  as projection on ZI_BOOKING_SAIF_M
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _customer.LastName as CustomerName,
       @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId, 
      _carrier.Name as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingText' ]
      BookingStatus,
       _booking_status._Text.Text as BookingText : localized,
      LastChangedAt,
      /* Associations */
      _bookingsuppl : redirected to composition child ZC_BOOKSUP_SAIF_M,
      _booking_status,
      _carrier,
      _connection,
      _customer,
      _travel       : redirected to parent ZC_TRAVEL_SAIF_M
}
