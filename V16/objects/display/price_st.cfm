<cfquery name="GET_PRICE_STANDART" datasource="#dsn3#" maxrows="1">
	SELECT
	<cfif arguments.tax_inc IS 1>
		PS.PRICE_KDV*(SM.RATE2/SM.RATE1) PRICE
	<cfelse>
		PS.PRICE*(SM.RATE2/SM.RATE1) PRICE
	</cfif>
	FROM 
		PRICE_STANDART PS,
		#dsn_alias#.SETUP_MONEY SM
	WHERE 
		PS.PRODUCT_ID=<cfif arguments.is_product_stock is 1>#arguments.product_stock_id#</cfif> AND
		<cfif arguments.cost_method is 6>
			PS.PURCHASESALES = 0 AND 
		<cfelseif arguments.cost_method is 7>
			PS.PURCHASESALES = 1 AND
		</cfif>
		SM.MONEY = PS.MONEY
	ORDER BY 
		PS.RECORD_DATE DESC 
</cfquery>
<cfset stock_cost=wrk_round(GET_PRICE_STANDART.PRICE,4)>

<cfquery name="GET_MONEY" datasource="#DSN#" maxrows="1">
	SELECT 
		RATE1,
		RATE2,
		MONEY
	FROM
		MONEY_HISTORY
	WHERE
		MONEY='#arguments.cost_money#' AND
		VALIDATE_DATE <= #CREATEODBCDATE(GET_ACT.ACTION_DATE)#
	ORDER BY 
		MONEY_HISTORY_ID DESC,
		VALIDATE_DATE DESC
</cfquery>
<cfif not GET_MONEY.RECORDCOUNT>
	<cfquery name="GET_MONEY" datasource="#arguments.period_dsn_type#">
		SELECT 
			RATE1,
			RATE2,
			MONEY
		FROM
			SETUP_MONEY
		WHERE
			MONEY='#arguments.cost_money#'
	</cfquery>
</cfif>
<cfif GET_MONEY.RECORDCOUNT>
	<cfset rate=GET_MONEY.RATE2/GET_MONEY.RATE1>
<cfelse>
	<cfset rate=1>
</cfif>

<cfif (not isdefined('arguments.spec_id') or not len(arguments.spec_id)) and (not isdefined('arguments.spec_main_id') or not len(arguments.spec_main_id))>
	<cfquery name="GET_STOCK" datasource="#arguments.period_dsn_type#">
		SELECT
			SUM(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK, 
			STOCK_ID
		FROM
			STOCKS_ROW
		WHERE
			STOCK_ID=#GET_ACT.STOCK_ID#
			AND SPECT_VAR_ID IS NULL
			AND PROCESS_DATE <= #now()#
			AND PROCESS_TYPE<>81
		GROUP BY
			STOCK_ID
	</cfquery>
<cfelse>
	<cfif isdefined('arguments.spec_id') and len(arguments.spec_id)>
		<cfquery name="GET_SPEC_" datasource="#DSN3#">
			SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#arguments.spec_id#
		</cfquery>
	</cfif>
	<cfquery name="GET_STOCK" datasource="#arguments.period_dsn_type#">
		SELECT
			SUM(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK, 
			STOCK_ID,
			SPECT_VAR_ID
		FROM
			STOCKS_ROW
		WHERE
			STOCK_ID=#GET_ACT.STOCK_ID#
			AND SPECT_VAR_ID=#GET_SPEC_.SPECT_MAIN_ID#
			AND PROCESS_DATE <= #now()#
			AND PROCESS_TYPE<>81
		GROUP BY
			STOCK_ID,
			SPECT_VAR_ID
	</cfquery>
</cfif>
<cfscript>
	if(GET_STOCK.RECORDCOUNT and len(GET_STOCK.PRODUCT_STOCK)) stock_amount_total=GET_STOCK.PRODUCT_STOCK; else stock_amount_total=0;
	if(isdefined('arguments.cost_money_system') and len(arguments.cost_money_system))
	{
		stock_cost_system=stock_cost*rate;
		stock_cost_extra_system=stock_cost_extra*rate;
	}
	if(not isdefined('stock_cost_system'))
	{
		stock_cost_system=0;
		stock_cost_extra_system=0;
	}
</cfscript>
<cfset stock_cost = "#stock_cost#;0;#stock_amount_total#;#stock_cost_system#;#stock_cost_extra_system#">
