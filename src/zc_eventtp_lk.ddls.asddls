@EndUserText.label: 'Event Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_EventTP_LK
  provider contract transactional_query
  as projection on ZR_EVENTTP
{
  key EventUuid,
      EventId,
      @Search.defaultSearchElement: true
      Title,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Location,
      StartDate,
      EndDate,
      MaxParticipants,
      Status,
      
      // HIER nur noch den Namen des Feldes aus dem Base View angeben
      StatusText,
      
      @Search.defaultSearchElement: true
      Description,
      
      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      
      /* Associations */
      _Registrations : redirected to composition child ZC_RegistrationTP_LK
}

