@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Approver Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
        type: #STANDARD,
        label: 'Travel',
        value: 'TravelId'
    }
}
define root view entity ZC_TRAVEL_APPR_M
  provider contract transactional_query
  as projection on ZI_TRAVEL_SAIF_M
{
      @UI.facet: [{
            id: 'Travel',
            purpose: #STANDARD,
            position: 10 ,
            label: 'Travel',
            type:#IDENTIFICATION_REFERENCE
        },
        {
            id: 'Booking',
            purpose: #STANDARD,
            position: 20 ,
            label: 'Booking',
            type:#LINEITEM_REFERENCE,
            targetElement: '_booking'

        }]
      @UI.lineItem: [{ position:  10 }]
      @UI.identification: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key TravelId,
      @UI: { lineItem: [{ position: 20 }],
               selectionField: [{ position:  20 }],
               identification: [{ position: 20 }]
        }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Agency',
                                               element: 'AgencyID'
                                           } }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _agency.Name       as AgencyName,
      @UI: { lineItem: [{ position: 30 }],
              selectionField: [{ position:  30 }],
              identification: [{ position: 30 }]
        }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Customer',
                                               element: 'CustomerID'} }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _customer.LastName as CustomerName,
      @UI.lineItem: [{ position:  40 }]
      @UI.identification: [{ position: 40 }]
      BeginDate,
      @UI.lineItem: [{ position:  50 }]
      @UI.identification: [{ position: 50 }]
      EndDate,
      @UI.identification: [{ position: 55 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @UI.lineItem: [{ position:  60 }]
      @UI.identification: [{ position: 60 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity: {
                                           name: 'I_Currency',
                                           element: 'Currency'} }]
      CurrencyCode,
      @UI.identification: [{ position: 65 }]
      Description,
      @UI: { lineItem: [{ position: 70 },
                        { type: #FOR_ACTION , dataAction: 'acceptTravel', label: 'Accept Travel' },
                        {type: #FOR_ACTION , dataAction: 'rejectTravel', label: 'Reject Travel'}],

         selectionField: [{ position:  70 }],
         identification: [{ position: 70 },
                           { type: #FOR_ACTION , dataAction: 'acceptTravel', label: 'Accept Travel' },
                        {type: #FOR_ACTION , dataAction: 'rejectTravel', label: 'Reject Travel'}],
         textArrangement: #TEXT_ONLY
      }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Overall_Status_VH',
                                               element: 'OverallStatus'} }]
      @ObjectModel.text.element: [ 'OverallstatusText' ]
      OverallStatus,
      @UI.hidden: true
      _status._Text.Text as OverallstatusText : localized,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _agency,
      _booking : redirected to composition child ZC_BOOKING_APPR_M,
      _currency,
      _customer,
      _status
}
