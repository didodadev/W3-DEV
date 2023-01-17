<cfquery name="del_remote_plan" datasource="#dsn#">
	DELETE FROM REMOTE_WORKING_DAY WHERE REMOTE_DAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.REMOTE_DAY_ID#">
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		<cflocation  url="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&empName=#attributes.empName#">
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>