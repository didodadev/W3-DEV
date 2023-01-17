<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD FROM  DEPARTMENT WHERE DEPARTMENT_ID = #attributes.department_id#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<!--- History icin --->
		<cfquery name="del_department_history" datasource="#dsn#">
			DELETE FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = #department_id#
		</cfquery>
		<cfquery name="DEL_DEPARTMENT" datasource="#dsn#">
			DELETE FROM DEPARTMENT WHERE DEPARTMENT_ID=#department_id#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.DEPARTMENT_ID#" action_name="#GET_DEPARTMENT.DEPARTMENT_HEAD#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.list_depts" addtoken="no">

