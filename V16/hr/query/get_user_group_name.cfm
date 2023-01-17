<cfquery name="GET_USER_GROUP_NAME" datasource="#dsn#">
	SELECT 
		USER_GROUP_NAME
	FROM 
		USER_GROUP
	WHERE
		USER_GROUP_ID = #attributes.USER_GROUP_ID#
</cfquery>

