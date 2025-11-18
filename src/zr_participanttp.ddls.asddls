@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Participant BO View'
define root view entity ZR_PARTICIPANTTP
  as select from ZI_PARTICIPANT
{
  key ParticipantUuid,
      ParticipantId,
      FirstName,
      LastName,
      Email,
      Phone,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt
}
