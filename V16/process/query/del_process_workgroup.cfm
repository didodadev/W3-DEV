<cftransaction>
	<cfquery name="DEL_FROM_WORKGROUP" datasource="#dsn#">
		DELETE FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE WORKGROUP_ID = #attributes.workgroup_id#
	</cfquery>
	<cfquery name="DEL_INF" datasource="#dsn#">
		DELETE FROM PROCESS_TYPE_ROWS_INFID WHERE WORKGROUP_ID = #attributes.workgroup_id#
	</cfquery>
	<cfquery name="DEL_PRO" datasource="#dsn#">
		DELETE FROM PROCESS_TYPE_ROWS_POSID WHERE WORKGROUP_ID = #attributes.workgroup_id#
	</cfquery>
	<cfquery name="DEL_CAU" datasource="#dsn#">
		DELETE FROM PROCESS_TYPE_ROWS_CAUID WHERE WORKGROUP_ID = #attributes.workgroup_id#
	</cfquery>
</cftransaction>
<script type="text/javascript">
	<cfif attributes.draggable eq 1>
		location.href = document.referrer;
	<cfelse>
		window.opener.location.reload();
		window.close();
	</cfif>
</script>
