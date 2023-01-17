<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
	SELECT * FROM DEPARTMENT WHERE IS_STORE <> 1
	<cfif isDefined("attributes.DEPARTMENT_ID")>
		AND DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	</cfif>
</cfquery>
