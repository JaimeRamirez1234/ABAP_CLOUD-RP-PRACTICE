@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCD_C_BOOKING_M_A2 
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
    _BookSupplement,
    _Carrier,
    _Connection,
    _Customer,
    _Travel
}
