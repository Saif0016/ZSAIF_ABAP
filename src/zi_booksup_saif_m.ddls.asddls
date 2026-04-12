@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking  supp Interface view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKSUP_SAIF_M
  as select from zbooksupp_saif_m
  association        to parent ZI_BOOKING_SAIF_M as _booking        on  $projection.TravelId  = _booking.TravelId
                                                                    and $projection.BookingId = _booking.BookingId
  association [1..1] to ZI_TRAVEL_SAIF_M         as _Travel         on  $projection.TravelId = _Travel.TravelId
  association [1..1] to /DMO/I_Supplement        as _supplement     on  $projection.SupplementId = _supplement.SupplementID
  association [1..*] to /DMO/I_SupplementText    as _supplementtext on  $projection.SupplementId = _supplementtext.SupplementID
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      _booking,
      _Travel,
      _supplement,
      _supplementtext
}
