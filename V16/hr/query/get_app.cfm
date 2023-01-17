<cfquery name="GET_APP" datasource="#DSN#">
	SELECT *,WANT_CALL,RESOURCE_ID,WANT_SMS,WANT_EMAIL FROM EMPLOYEES_APP WHERE EMPAPP_ID = #attributes.EMPAPP_ID#
</cfquery>
<cfquery name="GET_IM" datasource="#DSN#">
	SELECT * FROM EMPLOYEES_INSTANT_MESSAGE WHERE EMPAPP_ID = #attributes.EMPAPP_ID#
</cfquery>

