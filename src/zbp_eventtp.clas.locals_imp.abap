**/* ========================================================================
**   LOGIK FÜR EVENT (APP 1)
**   ======================================================================== */
*CLASS lhc_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR Event RESULT result.
*
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR Event RESULT result.
*
*    METHODS DetermineEventId FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR Event~DetermineEventId.
*
*    METHODS DetermineStatus FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR Event~DetermineStatus.
*
*    METHODS ValidateDates FOR VALIDATE ON SAVE
*      IMPORTING keys FOR Event~ValidateDates.
*
*    METHODS OpenEvent FOR MODIFY
*      IMPORTING keys FOR ACTION Event~OpenEvent RESULT result.
*
*    METHODS CloseEvent FOR MODIFY
*      IMPORTING keys FOR ACTION Event~CloseEvent RESULT result.
*ENDCLASS.
*
*CLASS lhc_Event IMPLEMENTATION.
*  METHOD get_instance_authorizations.
*
*    " Berechtigung für UPDATE (Edit-Button) für alle angeforderten Schlüssel erteilen
*    result = VALUE #( FOR key IN keys ( %tky = key-%tky %update = if_abap_behv=>auth-allowed ) ).
*
*    " Hinweis: Wenn DELETE oder Actions blockiert wären, müssten sie hier auch erlaubt werden,
*    " z.B.: %delete = if_abap_behv=>auth-allowed
*
*  ENDMETHOD.
*
*  METHOD get_global_authorizations.
*    IF requested_authorizations-%create <> if_abap_behv=>mk-on.
*      RETURN.
*    ENDIF.
*
*    " Explizit Erlaubnis zum Erstellen geben
*    result-%create = if_abap_behv=>auth-allowed.
*  ENDMETHOD.
*
*  METHOD DetermineEventId.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event FIELDS ( EventId ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_events).
*    DELETE lt_events WHERE EventId IS NOT INITIAL.
*    CHECK lt_events IS NOT INITIAL.
*    SELECT SINGLE FROM zevent_lk_a FIELDS MAX( event_id ) INTO @DATA(lv_max_id).
*    MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event UPDATE FROM VALUE #( FOR ls_event IN lt_events INDEX INTO i (
*          %tky = ls_event-%tky
*          EventId = lv_max_id + i ) ).
*  ENDMETHOD.
*
*  METHOD DetermineStatus.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event FIELDS ( Status ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_events).
*    MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event UPDATE FIELDS ( Status )
*      WITH VALUE #( FOR ls_event IN lt_events ( %tky = ls_event-%tky Status = 'P' ) ).
*  ENDMETHOD.
*
*  METHOD ValidateDates.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event FIELDS ( StartDate EndDate ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_events).
*    LOOP AT lt_events INTO DATA(ls_event).
*      IF ls_event-StartDate < cl_abap_context_info=>get_system_date( ).
*        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
*        APPEND VALUE #( %tky = ls_event-%tky
*                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                      text = 'Start Date cannot be in the past.' )
*                      ) TO reported-event.
*      ENDIF.
*      IF ls_event-EndDate < ls_event-StartDate.
*        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
*        APPEND VALUE #( %tky = ls_event-%tky
*                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                      text = 'End Date cannot be before Start Date.' )
*                      ) TO reported-event.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD OpenEvent.
*    MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event UPDATE FIELDS ( Status )
*      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'O' ) )
*      FAILED failed REPORTED reported.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(events).
*    result = VALUE #( FOR event IN events ( %tky = event-%tky %param = event ) ).
*  ENDMETHOD.
*
*  METHOD CloseEvent.
*    MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event UPDATE FIELDS ( Status )
*      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'C' ) )
*      FAILED failed REPORTED reported.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Event ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(events).
*    result = VALUE #( FOR event IN events ( %tky = event-%tky %param = event ) ).
*  ENDMETHOD.
*ENDCLASS.
*
*
*/* ========================================================================
*   LOGIK FÜR REGISTRATION (APP 2)
*   ======================================================================== */
*CLASS lhc_Registration DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*    METHODS ApproveRegistration FOR MODIFY
*      IMPORTING keys FOR ACTION Registration~ApproveRegistration RESULT result.
*
*    METHODS RejectRegistration FOR MODIFY
*      IMPORTING keys FOR ACTION Registration~RejectRegistration RESULT result.
*
*    METHODS DetermineRegistrationId FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR Registration~DetermineRegistrationId.
*
*    METHODS DetermineRegistrationStatus FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR Registration~DetermineRegistrationStatus.
*
*    METHODS ValidateMaxParticipants FOR VALIDATE ON SAVE
*      IMPORTING keys FOR Registration~ValidateMaxParticipants.
*ENDCLASS.
*
*CLASS lhc_Registration IMPLEMENTATION.
*
*  METHOD ApproveRegistration.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration FIELDS ( Status ) WITH CORRESPONDING #( keys )
*      RESULT DATA(registrations).
*
*    LOOP AT registrations INTO DATA(reg).
*      IF reg-Status = 'Approved' OR reg-Status = 'Rejected'.
*        APPEND VALUE #( %tky = reg-%tky ) TO failed-registration.
*        APPEND VALUE #( %tky = reg-%tky
*                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                      text = 'Registration is already processed.' )
*                      ) TO reported-registration.
*        CONTINUE.
*      ENDIF.
*
*      MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*        ENTITY Registration UPDATE FIELDS ( Status )
*        WITH VALUE #( ( %tky = reg-%tky Status = 'Approved' ) ).
*    ENDLOOP.
*
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(updated_regs).
*    result = VALUE #( FOR r IN updated_regs ( %tky = r-%tky %param = r ) ).
*  ENDMETHOD.
*
*  METHOD RejectRegistration.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration FIELDS ( Status ) WITH CORRESPONDING #( keys )
*      RESULT DATA(registrations).
*
*    LOOP AT registrations INTO DATA(reg).
*      IF reg-Status = 'Approved' OR reg-Status = 'Rejected'.
*        APPEND VALUE #( %tky = reg-%tky ) TO failed-registration.
*        APPEND VALUE #( %tky = reg-%tky
*                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                      text = 'Registration is already processed.' )
*                      ) TO reported-registration.
*        CONTINUE.
*      ENDIF.
*
*      MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*        ENTITY Registration UPDATE FIELDS ( Status )
*        WITH VALUE #( ( %tky = reg-%tky Status = 'Rejected' ) ).
*    ENDLOOP.
*
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(updated_regs).
*    result = VALUE #( FOR r IN updated_regs ( %tky = r-%tky %param = r ) ).
*  ENDMETHOD.
*
*  METHOD DetermineRegistrationId.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration FIELDS ( RegistrationId ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_regs).
*    DELETE lt_regs WHERE RegistrationId IS NOT INITIAL.
*    CHECK lt_regs IS NOT INITIAL.
*    SELECT SINGLE FROM zregistration_lk FIELDS MAX( registration_id ) INTO @DATA(lv_max_id).
*    MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration UPDATE FROM VALUE #( FOR ls_reg IN lt_regs INDEX INTO i (
*          %tky = ls_reg-%tky
*          RegistrationId = lv_max_id + i ) ).
*  ENDMETHOD.
*
*  METHOD DetermineRegistrationStatus.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration FIELDS ( Status ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_regs).
*    MODIFY ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration UPDATE FIELDS ( Status )
*      WITH VALUE #( FOR ls_reg IN lt_regs ( %tky = ls_reg-%tky Status = 'New' ) ).
*  ENDMETHOD.
*
*  METHOD ValidateMaxParticipants.
*    READ ENTITIES OF ZR_EVENTTP IN LOCAL MODE
*      ENTITY Registration BY \_Event
*      FIELDS ( EventUuid MaxParticipants )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_events).
*
*    LOOP AT lt_events INTO DATA(ls_event).
*      SELECT COUNT( * ) FROM zregistration_lk
*        WHERE event_uuid = @ls_event-EventUuid
*        INTO @DATA(lv_current_count).
*
*      IF lv_current_count >= ls_event-MaxParticipants.
*        APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-registration.
*        APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                      text = 'Event is full. Cannot register.' )
*                      ) TO reported-registration.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*ENDCLASS.

CLASS lhc_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Event RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Event RESULT result.

    " ... (Die restlichen Methoden-Definitionen bleiben hier weg für Übersicht,
    " aber wenn Sie den Code von vorhin noch haben, lassen Sie die LOGIK-Methoden drin.
    " WICHTIG ist nur die authorization Methode unten!)

    METHODS DetermineEventId FOR DETERMINE ON MODIFY IMPORTING keys FOR Event~DetermineEventId.
    METHODS DetermineStatus FOR DETERMINE ON MODIFY IMPORTING keys FOR Event~DetermineStatus.
    METHODS ValidateDates FOR VALIDATE ON SAVE IMPORTING keys FOR Event~ValidateDates.
    METHODS OpenEvent FOR MODIFY IMPORTING keys FOR ACTION Event~OpenEvent RESULT result.
    METHODS CloseEvent FOR MODIFY IMPORTING keys FOR ACTION Event~CloseEvent RESULT result.
ENDCLASS.

CLASS lhc_Event IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " HIER IST DER FIX: Wir erlauben alles explizit!
    result = VALUE #( FOR key IN keys (
      %tky = key-%tky
      %update = if_abap_behv=>auth-allowed
      %delete = if_abap_behv=>auth-allowed
      %action-OpenEvent = if_abap_behv=>auth-allowed
      %action-CloseEvent = if_abap_behv=>auth-allowed
    ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.

  " ... Fügen Sie hier Ihre Logik-Methoden (DetermineEventId, etc.) von vorhin wieder ein ...
  " Wenn Sie die Logik gerade nicht parat haben, lassen Sie die Methoden leer:
  METHOD DetermineEventId. ENDMETHOD.
  METHOD DetermineStatus. ENDMETHOD.
  METHOD ValidateDates. ENDMETHOD.
  METHOD OpenEvent. ENDMETHOD.
  METHOD CloseEvent. ENDMETHOD.

ENDCLASS.

CLASS lhc_Registration DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS ApproveRegistration FOR MODIFY IMPORTING keys FOR ACTION Registration~ApproveRegistration RESULT result.
    METHODS RejectRegistration FOR MODIFY IMPORTING keys FOR ACTION Registration~RejectRegistration RESULT result.
    METHODS DetermineRegistrationId FOR DETERMINE ON MODIFY IMPORTING keys FOR Registration~DetermineRegistrationId.
    METHODS DetermineRegistrationStatus FOR DETERMINE ON MODIFY IMPORTING keys FOR Registration~DetermineRegistrationStatus.
    METHODS ValidateMaxParticipants FOR VALIDATE ON SAVE IMPORTING keys FOR Registration~ValidateMaxParticipants.
ENDCLASS.

CLASS lhc_Registration IMPLEMENTATION.
  METHOD ApproveRegistration. ENDMETHOD.
  METHOD RejectRegistration. ENDMETHOD.
  METHOD DetermineRegistrationId. ENDMETHOD.
  METHOD DetermineRegistrationStatus. ENDMETHOD.
  METHOD ValidateMaxParticipants. ENDMETHOD.
ENDCLASS.
