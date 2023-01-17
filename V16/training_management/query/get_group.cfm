<cfquery name="GET_GROUP" datasource="#dsn#">
     SELECT 
	 	GROUP_NAME,
	 	GROUP_ID 
	 FROM 
	 	USERS 
	 WHERE 
	 	GROUP_ID = #attributes.GROUP_ID#
</cfquery>
