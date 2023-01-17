<cfquery name="ADD_SSK_FEE" datasource="#DSN#">
	DELETE FROM	EMPLOYEES_SSK_FEE WHERE FEE_ID = #attributes.FEE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=hr.list_visited" addtoken="no">