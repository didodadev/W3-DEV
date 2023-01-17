<cfquery name="GET_CONS_SENT_CONTS" datasource="#dsn#">
	SELECT
		CONT_ID,
		CONT_TYPE,
		'1' AS IS_SENT
	FROM
		SEND_CONTENTS
	WHERE
		SEND_CON LIKE '%#attributes.CONSUMER_ID#%'
		AND 
		CONT_ID = #attributes.CONT_ID#
</cfquery>
