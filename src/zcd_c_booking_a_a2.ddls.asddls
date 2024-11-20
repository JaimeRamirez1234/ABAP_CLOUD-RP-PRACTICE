@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zcd_c_booking_a_a2 
as projection on ZCD_I_BOOKING_A2
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
    _Travel : redirected to parent ZCD_C_TRAVEL_A_A2,
    _BookSupplement,
    _Carrier,
    _Connection,
    _Customer
}
