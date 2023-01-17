<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT * FROM TARGET WHERE TARGET_ID = #attributes.TARGET_ID#
</cfquery>
