<cfquery name="del" datasource="#dsn#">
	DELETE FROM PROJECT_ACCOUNT_RATES WHERE PROJECT_RATE_ID = #attributes.project_rate_id#
</cfquery>
<cfquery name="del_row" datasource="#dsn#">
	DELETE FROM PROJECT_ACCOUNT_RATES_ROW WHERE PROJECT_RATE_ID = #attributes.project_rate_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
