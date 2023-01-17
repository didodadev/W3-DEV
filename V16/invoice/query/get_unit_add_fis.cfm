<cfquery name="GET_UNIT" datasource="#dsn2#">
	SELECT 
		ADD_UNIT,
		MULTIPLIER,
		MAIN_UNIT,
		PRODUCT_UNIT_ID
	FROM
		#dsn3_alias#.PRODUCT_UNIT 
	WHERE
		PRODUCT_ID = #evaluate("attributes.product_id#i#")# AND
		ADD_UNIT = '#evaluate("attributes.unit#i#")#'
</cfquery>
