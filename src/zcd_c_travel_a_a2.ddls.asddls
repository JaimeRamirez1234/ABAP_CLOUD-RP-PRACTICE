@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCD_C_TRAVEL_A_A2
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
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VIRT_ELEM_ALFA02'
    virtual DiscountPrice : /dmo/total_price,
    /* Associations */
    _Agency,
    _Booking : redirected to composition child zcd_c_booking_a_a2,
    _Currency,
    _Customer
}
