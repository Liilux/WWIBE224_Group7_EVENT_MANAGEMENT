CLASS zcl_event_data_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Das Interface macht die Klasse ausführbar (F9)
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_event_data_gen IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA: lt_events        TYPE TABLE OF zevent_a,
          ls_event         TYPE zevent_a,
          lt_participants  TYPE TABLE OF zparticipant_a,
          ls_participant   TYPE zparticipant_a,
          lt_registrations TYPE TABLE OF zregistration_a,
          ls_registration  TYPE zregistration_a.

    " 1. Clean up existing data (Löschen alter Daten)
    DELETE FROM zevent_a.
    DELETE FROM zparticipant_a.
    DELETE FROM zregistration_a.

    out->write( |Deleted old data.| ).

    " -------------------------------------------------------------
    " 2. Create Events (5 records)
    " -------------------------------------------------------------

    " Event 1
    ls_event-client = sy-mandt.
    ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_event-event_id = '10001'.
    ls_event-title = 'SAP TechEd 2025'.
    ls_event-location = 'Walldorf'.
    ls_event-start_date = '20251015'.
    ls_event-end_date = '20251017'.
    ls_event-max_participants = 500.
    ls_event-status = 'P'. " Planned
    ls_event-description = 'Annual SAP Tech conference'.
    ls_event-created_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_event-created_at.
    ls_event-last_changed_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_event-last_changed_at.
    APPEND ls_event TO lt_events.

    " Event 2
    ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_event-event_id = '10002'.
    ls_event-title = 'Oktoberfest Meetup'.
    ls_event-location = 'Munich'.
    ls_event-start_date = '20250920'.
    ls_event-end_date = '20250922'.
    ls_event-max_participants = 50.
    ls_event-status = 'O'. " Open
    ls_event-description = 'Networking event during Oktoberfest'.
    GET TIME STAMP FIELD ls_event-created_at.
    GET TIME STAMP FIELD ls_event-last_changed_at.
    APPEND ls_event TO lt_events.

    " Event 3
    ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_event-event_id = '10003'.
    ls_event-title = 'Abap Code Retreat'.
    ls_event-location = 'Berlin'.
    ls_event-start_date = '20251101'.
    ls_event-end_date = '20251102'.
    ls_event-max_participants = 20.
    ls_event-status = 'P'.
    ls_event-description = 'Intensive coding weekend'.
    GET TIME STAMP FIELD ls_event-created_at.
    GET TIME STAMP FIELD ls_event-last_changed_at.
    APPEND ls_event TO lt_events.

    " Event 4
    ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_event-event_id = '10004'.
    ls_event-title = 'Design Thinking Workshop'.
    ls_event-location = 'Hamburg'.
    ls_event-start_date = '20250610'.
    ls_event-end_date = '20250610'.
    ls_event-max_participants = 15.
    ls_event-status = 'C'. " Closed
    ls_event-description = 'Learn how to innovate'.
    GET TIME STAMP FIELD ls_event-created_at.
    GET TIME STAMP FIELD ls_event-last_changed_at.
    APPEND ls_event TO lt_events.

    " Event 5
    ls_event-event_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_event-event_id = '10005'.
    ls_event-title = 'Community BBQ'.
    ls_event-location = 'Heidelberg'.
    ls_event-start_date = '20250715'.
    ls_event-end_date = '20250715'.
    ls_event-max_participants = 100.
    ls_event-status = 'O'.
    ls_event-description = 'Summer BBQ for all employees'.
    GET TIME STAMP FIELD ls_event-created_at.
    GET TIME STAMP FIELD ls_event-last_changed_at.
    APPEND ls_event TO lt_events.

    " Insert Events into DB
    INSERT zevent_a FROM TABLE @lt_events.
    out->write( |Inserted Events: { sy-dbcnt }| ).


    " -------------------------------------------------------------
    " 3. Create Participants (5 records)
    " -------------------------------------------------------------

    " Participant 1
    ls_participant-client = sy-mandt.
    ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_participant-participant_id = '50001'.
    ls_participant-first_name = 'Max'.
    ls_participant-last_name = 'Mustermann'.
    ls_participant-email = 'max.mustermann@example.com'.
    ls_participant-phone = '+491701234567'.
    ls_participant-created_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_participant-created_at.
    ls_participant-last_changed_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_participant-last_changed_at.
    APPEND ls_participant TO lt_participants.

    " Participant 2
    ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_participant-participant_id = '50002'.
    ls_participant-first_name = 'Erika'.
    ls_participant-last_name = 'Musterfrau'.
    ls_participant-email = 'erika.musterfrau@example.com'.
    ls_participant-phone = '+491709876543'.
    GET TIME STAMP FIELD ls_participant-created_at.
    GET TIME STAMP FIELD ls_participant-last_changed_at.
    APPEND ls_participant TO lt_participants.

    " Participant 3
    ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_participant-participant_id = '50003'.
    ls_participant-first_name = 'John'.
    ls_participant-last_name = 'Doe'.
    ls_participant-email = 'john.doe@example.com'.
    ls_participant-phone = '+15550199'.
    GET TIME STAMP FIELD ls_participant-created_at.
    GET TIME STAMP FIELD ls_participant-last_changed_at.
    APPEND ls_participant TO lt_participants.

    " Participant 4
    ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_participant-participant_id = '50004'.
    ls_participant-first_name = 'Jane'.
    ls_participant-last_name = 'Smith'.
    ls_participant-email = 'jane.smith@example.com'.
    ls_participant-phone = '+447700900077'.
    GET TIME STAMP FIELD ls_participant-created_at.
    GET TIME STAMP FIELD ls_participant-last_changed_at.
    APPEND ls_participant TO lt_participants.

    " Participant 5
    ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_participant-participant_id = '50005'.
    ls_participant-first_name = 'Lukas'.
    ls_participant-last_name = 'Podolski'.
    ls_participant-email = 'lukas@fussball.de'.
    ls_participant-phone = '+4916099887766'.
    GET TIME STAMP FIELD ls_participant-created_at.
    GET TIME STAMP FIELD ls_participant-last_changed_at.
    APPEND ls_participant TO lt_participants.

    " Insert Participants into DB
    INSERT zparticipant_a FROM TABLE @lt_participants.
    out->write( |Inserted Participants: { sy-dbcnt }| ).


    " -------------------------------------------------------------
    " 4. Create Registrations (5 records)
    " -------------------------------------------------------------
    " Hier verknüpfen wir Events und Teilnehmer über ihre UUIDs

    " Registration 1: Max goes to TechEd
    ls_registration-client = sy-mandt.
    ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_registration-registration_id = '90001'.
    ls_registration-event_uuid = lt_events[ 1 ]-event_uuid. " Nimmt UUID von Event 1
    ls_registration-participant_uuid = lt_participants[ 1 ]-participant_uuid. " Nimmt UUID von Teilnehmer 1
    ls_registration-status = 'New'.
    ls_registration-remarks = 'Early Bird'.
    ls_registration-created_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_registration-created_at.
    ls_registration-last_changed_by = 'GENERATOR'.
    GET TIME STAMP FIELD ls_registration-last_changed_at.
    APPEND ls_registration TO lt_registrations.

    " Registration 2: Erika goes to TechEd
    ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_registration-registration_id = '90002'.
    ls_registration-event_uuid = lt_events[ 1 ]-event_uuid.
    ls_registration-participant_uuid = lt_participants[ 2 ]-participant_uuid.
    ls_registration-status = 'Approved'.
    ls_registration-remarks = 'Paid via Invoice'.
    GET TIME STAMP FIELD ls_registration-created_at.
    GET TIME STAMP FIELD ls_registration-last_changed_at.
    APPEND ls_registration TO lt_registrations.

    " Registration 3: John goes to Oktoberfest
    ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_registration-registration_id = '90003'.
    ls_registration-event_uuid = lt_events[ 2 ]-event_uuid.
    ls_registration-participant_uuid = lt_participants[ 3 ]-participant_uuid.
    ls_registration-status = 'New'.
    ls_registration-remarks = ''.
    GET TIME STAMP FIELD ls_registration-created_at.
    GET TIME STAMP FIELD ls_registration-last_changed_at.
    APPEND ls_registration TO lt_registrations.

    " Registration 4: Jane goes to Code Retreat
    ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_registration-registration_id = '90004'.
    ls_registration-event_uuid = lt_events[ 3 ]-event_uuid.
    ls_registration-participant_uuid = lt_participants[ 4 ]-participant_uuid.
    ls_registration-status = 'Rejected'.
    ls_registration-remarks = 'Event full'.
    GET TIME STAMP FIELD ls_registration-created_at.
    GET TIME STAMP FIELD ls_registration-last_changed_at.
    APPEND ls_registration TO lt_registrations.

    " Registration 5: Lukas goes to BBQ
    ls_registration-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    ls_registration-registration_id = '90005'.
    ls_registration-event_uuid = lt_events[ 5 ]-event_uuid.
    ls_registration-participant_uuid = lt_participants[ 5 ]-participant_uuid.
    ls_registration-status = 'Approved'.
    ls_registration-remarks = 'Vegetarian'.
    GET TIME STAMP FIELD ls_registration-created_at.
    GET TIME STAMP FIELD ls_registration-last_changed_at.
    APPEND ls_registration TO lt_registrations.

    " Insert Registrations into DB
    INSERT zregistration_a FROM TABLE @lt_registrations.
    out->write( |Inserted Registrations: { sy-dbcnt }| ).

  ENDMETHOD.
ENDCLASS.
