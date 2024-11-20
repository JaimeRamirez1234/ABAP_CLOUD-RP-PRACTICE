@AbapCatalog.sqlViewName: 'ZVW_I_BOOKING_A2'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking View'
@Metadata.ignorePropagatedAnnotations: true
define view ZCD_I_BOOKING_A2 
       as select from ztb_booking_alf2 as Booking
       association to parent ZCD_I_TRAVEL_ALFA02 as _Travel on $projection.TravelId = _Travel.TravelId
       composition [0..*] of ZCD_I_BOOKSUPPL_ALFA02 as _BookSupplement
       association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
       association [1..1] to /DMO/I_Carrier as _Carrier on $projection.CarrierId = _Carrier.AirlineID
       association [1..1] to /DMO/I_Connection as _Connection on $projection.CarrierId = _Connection.AirlineID
                                                             and $projection.ConnectionId = _Connection.ConnectionID
{
    key travel_id as TravelId,
    key booking_id as BookingId,
        booking_date as BookingDate,
        customer_id as CustomerId,
        carrier_id as CarrierId,
        connection_id as ConnectionId,
        flight_date as FlightDate,
        flight_price as FlightPrice,
        currency_code as CurrencyCode,
        booking_status as BookingStatus,
        last_changed_at as LastChangedAt,
        _Travel,
        _BookSupplement,
        _Customer,
        _Carrier,
        _Connection
}
