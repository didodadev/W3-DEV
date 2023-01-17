<cfquery name="GET_PC_NUMBER" datasource="#dsn#">
	SELECT UNIT_ID, UNIT_NAME FROM SETUP_PC_NUMBER 
	<cfif isdefined("attributes.unit_id")>
	WHERE
		UNIT_ID = #attributes.unit_id#
	</cfif>	
	ORDER BY UNIT_ID
</cfquery>
