@EndUserText.label: 'Registration Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_RegistrationTP_LK
  as projection on ZR_REGISTRATIONTP
{
  key RegistrationUuid,
      RegistrationId,
      EventUuid,

      // HIER: Die Wertehilfe, damit man den Teilnehmer auswählen kann [cite: 49]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_PARTICIPANT', element: 'ParticipantUuid' } }]
      ParticipantUuid,

      Status,
      Remarks,
      
      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      
      /* Associations */
      _Event : redirected to parent ZC_EventTP_LK,
      _Participant : redirected to ZC_ParticipantTP_LK
}
