@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event BO View'
define root view entity ZR_EVENTTP
  as select from ZI_EVENT
  composition [0..*] of ZR_REGISTRATIONTP as _Registrations
{
  key EventUuid,
      EventId,
      Title,
      Location,
      StartDate,
      EndDate,
      MaxParticipants,
      Status,
      
      // HIER kommt die Berechnung hin (Base View erlaubt das):
      case Status
        when 'P' then 'Planned'
        when 'O' then 'Open'
        when 'C' then 'Closed'
        else ''
      end as StatusText,
      
      Description,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _Registrations
}
