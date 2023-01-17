<cfquery name="DEL_SETUP_OFFTIME" datasource="#DSN#">
	DELETE FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = #offtimecat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_offtime" addtoken="no">
