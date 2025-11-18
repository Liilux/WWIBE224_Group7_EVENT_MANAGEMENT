@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Interface View'
define view entity ZI_REGISTRATION
  as select from zregistration_lk
{
  key registration_uuid as RegistrationUuid,
      registration_id   as RegistrationId,
      event_uuid        as EventUuid,
      participant_uuid  as ParticipantUuid,
      status            as Status,
      remarks           as Remarks,

      /* Administrative Data */
      @Semantics.user.createdBy: true
      created_by        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at        as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by   as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at   as LastChangedAt
}
