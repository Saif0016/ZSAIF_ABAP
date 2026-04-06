@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking  supp Consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BOOKSUP_SAIF_M
  as projection on ZI_BOOKSUP_SAIF_M
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'supplementtext' ]
      SupplementId,
      _supplementtext.Description as supplementtext : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _booking : redirected to parent ZC_BOOKING_SAIF_M,
      _Travel  : redirected to ZC_TRAVEL_SAIF_M,
      _supplement,
      _supplementtext
}
