<cfquery name="GET_CONSUMER" datasource="#dsn#">
	SELECT 
		C.CONSUMER_ID,	
		C.CONSUMER_NAME,
		C.CONSUMER_SURNAME,
		C.DEPARTMENT,
		C.CONSUMER_EMAIL,
		C.COMPANY
	FROM 
		CONSUMER AS C
	WHERE
		C.CONSUMER_ID = #attributes.CON_ID#
</cfquery>
