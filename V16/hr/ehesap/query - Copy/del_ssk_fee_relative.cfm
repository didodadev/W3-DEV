<cfquery name="DEL_SSK_FEE" datasource="#DSN#">
	DELETE FROM EMPLOYEES_SSK_FEE_RELATIVE WHERE FEE_ID = #attributes.FEE_ID#
</cfquery>	

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_visited_relative';
</script>