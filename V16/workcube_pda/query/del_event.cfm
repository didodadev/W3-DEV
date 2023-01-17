<cfquery name="DEL_EVENT_RESERVATIONS" datasource="#dsn#">
	DELETE FROM
		EVENT
	WHERE
		EVENT_ID = #attributes.EVENT_ID#
</cfquery>	

<cfquery name="DEL_EVENT_RELATIONS" datasource="#dsn#">
	DELETE FROM
		EVENTS_RELATED
	WHERE
		EVENT_ID = #attributes.EVENT_ID#
</cfquery>	

<cfif isdefined("attributes.project_id") or isdefined("attributes.opp_id") or isdefined("attributes.offer_id") or isdefined("attributes.action_id")>
<script type="text/javascript">
 wrk_opener_reload();
 window.close();
</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=pda.daily" addtoken="No">
</cfif>
