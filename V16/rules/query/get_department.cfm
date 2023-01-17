<!--- attributes.department_id ye göre department ayrýntýlarý alýnýr --->
<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
	SELECT * FROM DEPARTMENT 
	<cfif isDefined("attributes.DEPARTMENT_ID")>
		WHERE DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	</cfif>
</cfquery>