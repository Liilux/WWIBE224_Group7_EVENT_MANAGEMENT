@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Interface View'
define view entity ZI_EVENT
  as select from zevent_lk_a
{
  key event_uuid        as EventUuid,
      event_id          as EventId,
      title             as Title,
      location          as Location,
      start_date        as StartDate,
      end_date          as EndDate,
      max_participants  as MaxParticipants,
      status            as Status,
      description       as Description,

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
