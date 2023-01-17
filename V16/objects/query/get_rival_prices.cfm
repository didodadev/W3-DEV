<cfquery name="get_rival_prices" datasource="#dsn#">
	SELECT
		PR.PR_ID,
		PR.PRICE,
		PR.MONEY,
		PR.STARTDATE,
		PR.FINISHDATE,
		SETUP_UNIT.UNIT,
		SETUP_RIVALS.RIVAL_NAME,
		PR.STOCK_ID,
		PU.PRODUCT_UNIT_ID
	FROM
		SETUP_RIVALS,
		#dsn3_alias#.PRICE_RIVAL PR,
		#dsn3_alias#.PRODUCT_UNIT PU,
	<cfif isdefined("attributes.stock_id")>
		#dsn3_alias#.STOCKS S,
	</cfif>
		SETUP_UNIT
	WHERE
		PU.PRODUCT_UNIT_ID = PR.UNIT_ID	
	<cfif isdefined("attributes.stock_id")>
 		AND	S.STOCK_ID = PR.STOCK_ID 
	</cfif>
		AND	SETUP_UNIT.UNIT_ID = PU.UNIT_ID
		AND	SETUP_RIVALS.R_ID = PR.R_ID
	<cfif isdefined("attributes.product_id")>
		AND PR.PRODUCT_ID = #attributes.PRODUCT_ID#
	</cfif>
	<cfif isdefined("attributes.stock_id")>
		AND S.STOCK_ID = #attributes.stock_id#
	</cfif>
</cfquery>
