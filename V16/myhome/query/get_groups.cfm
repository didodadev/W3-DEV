<cfquery name="GET_GROUP" datasource="#dsn#">
	SELECT 
		GROUP_ID,
		GROUP_NAME
	FROM 
		USERS
	WHERE 
		GROUP_ID IN (#LISTSORT(attributes.GROUP_IDS,"NUMERIC")#)
</cfquery>
