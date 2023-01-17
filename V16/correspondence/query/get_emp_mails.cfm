<cfquery name="EMP_MAIL_LIST" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CUBE_MAIL 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id#
		<cfif isDefined("attributes.mailbox_id")>
		AND
		MAILBOX_ID = #attributes.mailbox_id#	
		</cfif>
</cfquery>
