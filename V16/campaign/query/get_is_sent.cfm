<cfquery name="GET_IS_SENT" datasource="#dsn#">
	SELECT
		CONT_ID
	FROM
		SEND_CONTENTS
	WHERE
		SEND_CON LIKE '%,#attributes.CONSUMER_ID#,%' AND 
		CONT_ID = #attributes.CONT_ID#
</cfquery>

