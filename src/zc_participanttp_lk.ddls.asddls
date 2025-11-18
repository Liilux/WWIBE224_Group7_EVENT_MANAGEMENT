@EndUserText.label: 'Participant Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_ParticipantTP_LK
  provider contract transactional_query
  as projection on ZR_PARTICIPANTTP
{
  key ParticipantUuid,
      ParticipantId,
      @Search.defaultSearchElement: true
      FirstName,
      @Search.defaultSearchElement: true
      LastName,
      Email,
      Phone,
      
      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt
}
