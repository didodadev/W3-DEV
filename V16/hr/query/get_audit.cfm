<cfquery name="GET_AUDIT" datasource="#DSN#">
	SELECT 
		*
	FROM 
		EMPLOYEES_AUDIT AS AU
	WHERE
		AU.AUDIT_ID = #attributes.audit_id#
</cfquery>
