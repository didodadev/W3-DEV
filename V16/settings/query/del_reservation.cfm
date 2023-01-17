<cfquery name="DELRESERVATION" datasource="#dsn#">
	DELETE FROM SETUP_RESERVATION WHERE RESERVATION_ID=#RESERVATION_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_reservation" addtoken="no">
