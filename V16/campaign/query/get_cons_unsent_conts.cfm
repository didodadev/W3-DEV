<cfquery name="GET_CONS_UNSENT_CONTS" datasource="#dsn#">
	SELECT
		CONT_ID,
		CONT_TYPE,
		'0' AS IS_SENT
	FROM
		SEND_CONTENTS
	WHERE
		CONT_ID NOT IN (#attributes.CONT_IDS#)
</cfquery>
