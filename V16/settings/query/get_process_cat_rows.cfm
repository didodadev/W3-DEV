<cfquery name="GET_PROCESS_CAT_ROWS" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		SETUP_PROCESS_CAT_ROWS
	WHERE
		PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
</cfquery>

<cfquery name="GET_PROCESS_CAT_ROWS_POSITIONS" datasource="#dsn3#">
	SELECT 
		EP.POSITION_NAME,
		EP.POSITION_CODE
	FROM 
		SETUP_PROCESS_CAT_ROWS SPCR,
		#DSN_ALIAS#.EMPLOYEE_POSITIONS EP
	WHERE
		SPCR.PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		AND
		SPCR.POSITION_CODE = EP.POSITION_CODE
	ORDER BY
		EP.POSITION_NAME
</cfquery>

<cfquery name="GET_PROCESS_CAT_ROWS_POSITION_CATS" datasource="#dsn3#">
	SELECT 
		SPC.POSITION_CAT,
		SPC.POSITION_CAT_ID
	FROM 
		SETUP_PROCESS_CAT_ROWS SPCR,
		#DSN_ALIAS#.SETUP_POSITION_CAT SPC
	WHERE
		SPCR.PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		AND
		SPCR.POSITION_CAT_ID = SPC.POSITION_CAT_ID
	ORDER BY
		SPC.POSITION_CAT
</cfquery>
