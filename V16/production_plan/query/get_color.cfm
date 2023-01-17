<cfquery name="get_color" datasource="#dsn_ts#">
	SELECT
		*
	FROM
		SETUP_COLOR
	WHERE
	COLOR_ID='#attributes.COLOR_ID#'
		
</cfquery>
