<cfquery name="GET_CONTENTS" datasource="#dsn#">
	SELECT 
		CONTENT_ID,
		CONT_HEAD,
		CONT_BODY,
		RECORD_MEMBER,
		POSITION_ID,
		POSITION_CAT_ID,
		RECORD_DATE
	FROM 
		CONTENT
	WHERE 
		POSITION_CAT_ID IS NOT NULL
</cfquery>
