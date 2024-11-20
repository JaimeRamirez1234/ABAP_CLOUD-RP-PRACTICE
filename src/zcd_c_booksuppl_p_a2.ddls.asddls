@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity zcd_c_booksuppl_p_a2 
as projection on ZCD_I_BOOKSUPPL_ALFA02
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplementDescription' ]
    SupplementId,
    _SupplementText.Description as SupplementDescription : localized,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    /* Associations */
    _Travel : redirected to ZCD_C_TRAVEL_P_A2,
    _Booking : redirected to parent ZCD_C_BOOKING_P_A2,
    _SupplementText
}
