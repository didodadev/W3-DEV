<cfquery name="GET_DEPARTMENTS2" datasource="#dsn#">
	SELECT 
		DEPARTMENT_ID, 
		DEPARTMENT_HEAD
	FROM 
		DEPARTMENT 
	<cfif isDefined("attributes.BRANCH_ID")>
		WHERE BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
</cfquery>
