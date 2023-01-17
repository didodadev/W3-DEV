<cfset urun= evaluate("attributes.unit#i#") >
<cfset urun_kod = evaluate("attributes.product_id#i#") >	
<cfquery name="GET_UNIT" datasource="#dsn2#">
	SELECT 
		ADD_UNIT,
		MULTIPLIER,
		MAIN_UNIT,
		PRODUCT_UNIT_ID
	FROM
		#dsn3_alias#.PRODUCT_UNIT 
	WHERE 
		PRODUCT_ID = #urun_kod# AND
		ADD_UNIT = '#urun#'
</cfquery>
