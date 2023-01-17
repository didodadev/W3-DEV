<cfquery name="del_group_emp" datasource="#DSN#">
	DELETE FROM 
		WORKGROUP_EMP_PAR
	WHERE
		WRK_ROW_ID = #ATTRIBUTES.WRK_ROW_ID#
</cfquery>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=service.list_workgroup</cfoutput>';
</script>
