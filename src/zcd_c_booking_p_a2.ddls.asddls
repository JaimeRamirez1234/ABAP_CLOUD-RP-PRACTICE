@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCD_C_BOOKING_P_A2 as projection on ZCD_I_BOOKING_A2
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    _Carrier.Name as CarrierName,
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _Travel : redirected to parent ZCD_C_TRAVEL_P_A2,
    _BookSupplement :redirected to composition child zcd_c_booksuppl_p_a2,
    _Customer,
    _Carrier
    
}
