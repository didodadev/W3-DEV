<cfquery name="DEL_CARE_STATE" datasource="#DSN#">
	DELETE FROM
		CARE_STATES
	WHERE
		SERVICE_ID = #attributes.service_id# AND
		CARE_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
/* 	wrk_opener_reload();
 */	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.id#</cfoutput>' );
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=service.list_care&event=upd&id=#attributes.service_id#</cfoutput>";
</script>

