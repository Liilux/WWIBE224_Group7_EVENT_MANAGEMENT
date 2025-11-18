@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Participant Interface View'
define view entity ZI_PARTICIPANT
  as select from zparticipant_lk
{
  key participant_uuid  as ParticipantUuid,
      participant_id    as ParticipantId,
      first_name        as FirstName,
      last_name         as LastName,
      email             as Email,
      phone             as Phone,

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
