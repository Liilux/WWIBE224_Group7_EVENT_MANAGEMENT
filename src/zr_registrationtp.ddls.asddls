@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration BO View'
define view entity ZR_REGISTRATIONTP
  as select from ZI_REGISTRATION
  association to parent ZR_EVENTTP as _Event on $projection.EventUuid = _Event.EventUuid
  association [1..1] to ZR_PARTICIPANTTP as _Participant on $projection.ParticipantUuid = _Participant.ParticipantUuid
{
  key RegistrationUuid,
      RegistrationId,
      EventUuid,
      ParticipantUuid,
      Status,
      Remarks,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _Event,
      _Participant
}
