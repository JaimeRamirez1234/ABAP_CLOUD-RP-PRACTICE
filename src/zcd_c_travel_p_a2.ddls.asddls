@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCD_C_TRAVEL_P_A2
  provider contract transactional_query
as projection on ZCD_I_TRAVEL_ALFA02
{
    key TravelId,
    AgencyId,
    _Agency.Name as AgencyName,
    CustomerId,
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    OverallStatus,
    LastChangedAt,
    /* Associations */
    _Booking,
    _Agency,
    _Customer
}
