<cfquery name="GET_POS_EQUIPMENT" datasource="#DSN3#">
	SELECT
		*
	FROM
		POS_EQUIPMENT
	WHERE
		POS_ID IS NOT NULL
</cfquery>