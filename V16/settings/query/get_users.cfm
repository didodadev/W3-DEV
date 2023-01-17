<cfquery name="GET_USERS" datasource="#DSN#">
	SELECT 
		TO_ALL,
		GROUP_NAME,
		POSITIONS,
		PARTNERS,
		CONSUMERS,
		RECORD_DATE,
		RECORD_MEMBER,
		UPDATE_DATE,
		UPDATE_MEMBER
	FROM 
		USERS
	WHERE
		GROUP_ID = #attributes.group_id#
</cfquery>
