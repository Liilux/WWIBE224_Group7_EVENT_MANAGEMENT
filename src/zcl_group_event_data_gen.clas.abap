CLASS zcl_group_event_data_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_group_event_data_gen IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " Hier nutzen wir DEINE Tabellennamen
    DATA: lt_events        TYPE TABLE OF zevent_lk_a,
          ls_event         TYPE zevent_lk_a,
          lt_participants  TYPE TABLE OF zparticipant_lk,
          ls_participant   TYPE zparticipant_lk,
          lt_registrations TYPE TABLE OF zregistration_lk,
          ls_registration  TYPE zregistration_lk.

    " 1. Alte Daten löschen
    DELETE FROM zevent_lk_a.
    DELETE FROM zparticipant_lk.
    DELETE FROM zregistration_lk.

    out->write( |Deleted old data.| ).

    " -------------------------------------------------------------
    " 2. Events erstellen
    " -------------------------------------------------------------
    ls_event-client = sy-mandt.
    ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_event-event_id = '10001'.
    ls_event-title = 'SAP TechEd 2025'.
    ls_event-location = 'Walldorf'.
    ls_event-start_date = '20251015'.
    ls_event-end_date = '20251017'.
    ls_event-max_participants = 500.
    ls_event-status = 'P'.
    ls_event-description = 'Annual SAP Tech conference'.
    ls_event-created_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_event-created_at.
    ls_event-last_changed_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_event-last_changed_at.
    APPEND ls_event TO lt_events.

    ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_event-event_id = '10002'.
    ls_event-title = 'Oktoberfest Meetup'.
    ls_event-location = 'Munich'.
    ls_event-start_date = '20250920'.
    ls_event-end_date = '20250922'.
    ls_event-max_participants = 50.
    ls_event-status = 'O'.
    ls_event-description = 'Networking event'.
    APPEND ls_event TO lt_events.

    " In die richtige Tabelle schreiben
    INSERT zevent_lk_a FROM TABLE @lt_events.
    out->write( |Inserted Events into ZEVENT_LK_A: { sy-dbcnt }| ).

    " -------------------------------------------------------------
    " 3. Teilnehmer erstellen
    " -------------------------------------------------------------
    ls_participant-client = sy-mandt.
    ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_participant-participant_id = '50001'.
    ls_participant-first_name = 'Max'.
    ls_participant-last_name = 'Mustermann'.
    ls_participant-email = 'max@test.com'.
    ls_participant-created_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_participant-created_at.
    ls_participant-last_changed_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_participant-last_changed_at.
    APPEND ls_participant TO lt_participants.

    " In die richtige Tabelle schreiben
    INSERT zparticipant_lk FROM TABLE @lt_participants.
    out->write( |Inserted Participants into ZPARTICIPANT_LK: { sy-dbcnt }| ).

    " -------------------------------------------------------------
    " 4. Registrierungen erstellen
    " -------------------------------------------------------------
    ls_registration-client = sy-mandt.
    ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_registration-registration_id = '90001'.
    ls_registration-event_uuid = lt_events[ 1 ]-event_uuid.
    ls_registration-participant_uuid = lt_participants[ 1 ]-participant_uuid.
    ls_registration-status = 'New'.
    ls_registration-created_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_registration-created_at.
    ls_registration-last_changed_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_registration-last_changed_at.
    APPEND ls_registration TO lt_registrations.

    " In die richtige Tabelle schreiben
    INSERT zregistration_lk FROM TABLE @lt_registrations.
    out->write( |Inserted Registrations into ZREGISTRATION_LK: { sy-dbcnt }| ).

  ENDMETHOD.
ENDCLASS.
