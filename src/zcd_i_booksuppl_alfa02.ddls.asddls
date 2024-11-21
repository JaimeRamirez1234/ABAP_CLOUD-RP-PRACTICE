@AbapCatalog.sqlViewName: 'ZVW_I_BOOKSUP_A2'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
define view ZCD_I_BOOKSUPPL_ALFA02 as select from ztb_booksuppl_a2 as BookingSupplement
    association to parent ZCD_I_BOOKING_A2 as _Booking on $projection.TravelId = _Booking.TravelId
                                                      and $projection.BookingId = _Booking.BookingId
    association [1..1] to ZCD_I_TRAVEL_ALFA02 as _Travel   on $projection.TravelId = _Travel.TravelId
    association [1..1] to /DMO/I_Supplement as _Product on $projection.SupplementId = _Product.SupplementID
    association [1..*] to /DMO/I_SupplementText as _SupplementText on
    $projection.SupplementId = _SupplementText.SupplementID

{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
        supplement_id as SupplementId,
        @Semantics.amount.currencyCode: 'CurrencyCode'
        price as Price,
        @Semantics.currencyCode: true
        currency_code as CurrencyCode,
        last_changed_at as LastChangedAt,
        _Booking,
        _Travel,
        _Product,
        _SupplementText
}
