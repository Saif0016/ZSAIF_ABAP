@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Approver Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: {
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title: {
        type: #STANDARD,
        label: 'Booking',
        value: 'BookingId'
    }
}
define view entity ZC_BOOKING_APPR_M
  as projection on ZI_BOOKING_SAIF_M
{
      @UI.facet: [{
              id: 'Booking',
              purpose: #STANDARD,
              position: 10 ,
              label: 'Booking',
              type:#IDENTIFICATION_REFERENCE
          }]
      @Search.defaultSearchElement: true
      
  key TravelId,
      @UI.lineItem: [{ position:  10 }]
      @Search.defaultSearchElement: true
      @UI.identification: [{ position: 10 }]
  key BookingId,
      @UI.lineItem: [{ position:  20 }]
      @Search.defaultSearchElement: true
      @UI.identification: [{ position: 20 }]
      BookingDate,
      @UI.lineItem: [{ position:  30 }]
      @UI.identification: [{ position: 30 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Customer',
                                               element: 'CustomerID'} }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _customer.LastName         as CustomerName,
      @UI.lineItem: [{ position:  40 }]
      @UI.identification: [{ position: 40 }]
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Carrier',
                                               element: 'AirlineID'} }]
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _carrier.Name              as CarrierName,
      @UI.lineItem: [{ position:  50 }]
      @UI.identification: [{ position: 50 }]
//      @Consumption.valueHelpDefinition: [{ entity: {
//                                            name: '/DMO/I_Flight',
//                                            element: 'ConnectionId'},
//                                            additionalBinding: [{ element: 'ConnectionID' , localElement: 'ConnectionId' },
//                                                                  { element: 'AirlineID' , localElement: 'CarrierId' },
//                                                                  { element: 'CurrencyCode' , localElement: 'CurrencyCode' },
//                                                                  { element: 'Price' , localElement: 'FlightPrice' }
//                                            ] }]
      ConnectionId,
      @UI.lineItem: [{ position:  60 }]
      @UI.identification: [{ position: 60 }]
//      @Consumption.valueHelpDefinition: [{ entity: {
//                                            name: '/DMO/I_Flight',
//                                            element: 'FlightDate'},
//                                            additionalBinding: [{ element: 'FlightDate' , localElement: 'FlightDate' },
//                                                                  { element: 'AirlineID' , localElement: 'CarrierId' },
//                                                                  { element: 'CurrencyCode' , localElement: 'CurrencyCode' },
//                                                                  { element: 'Price' , localElement: 'FlightPrice' }
//                                            ] }]
      FlightDate,
      @UI.lineItem: [{ position:  70 }]
      @UI.identification: [{ position: 70 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @Consumption.valueHelpDefinition: [{ entity: {
                                              name: 'I_Currency',
                                              element: 'Currency'} }]

      CurrencyCode,
      @UI.lineItem: [{ position:  80 }]
      @UI.identification: [{ position: 80 }]
      @UI.textArrangement: #TEXT_ONLY
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Booking_Status_VH',
                                               element: 'BookingStatus'} }]
      @ObjectModel.text.element: [ 'BookingText' ]
      BookingStatus,
      _booking_status._Text.Text as BookingText : localized,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _bookingsuppl,
      _booking_status,
      _carrier,
      _connection,
      _customer,
      _travel : redirected to parent ZC_TRAVEL_APPR_M
}
