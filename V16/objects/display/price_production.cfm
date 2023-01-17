<cfquery name="GET_ACTION" datasource="#DSN3#">
	SELECT 
		POR.FINISH_DATE ACTION_DATE,
		PORR.AMOUNT,
		PORR.SPECT_ID SPEC_ID,
		PORR.PURCHASE_NET_SYSTEM,
		PORR.PURCHASE_NET_SYSTEM_MONEY,
		PORR.PURCHASE_EXTRA_COST_SYSTEM,
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID
	FROM 
		PRODUCTION_ORDERS PO,
		PRODUCTION_ORDER_RESULTS POR,
		PRODUCTION_ORDER_RESULTS_ROW PORR,
		#dsn1_alias#.STOCKS STOCKS,
		#dsn1_alias#.PRODUCT PRODUCT
	WHERE
		POR.PR_ORDER_ID=#attributes.action_id# AND
		PO.P_ORDER_ID=POR.P_ORDER_ID AND
		POR.PR_ORDER_ID=PORR.PR_ORDER_ID AND
		STOCKS.STOCK_ID=PORR.STOCK_ID AND
		STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
		PRODUCT.IS_COST=1 AND
		PORR.TYPE=1 AND
		PO.IS_DEMONTAJ<>1
</cfquery>
<cfscript>
	stock_cost=0;
	stock_cost_extra=0;
	stock_amount_total=0;
</cfscript>
<cfif GET_ACTION.RECORDCOUNT>
	<cfif arguments.cost_money neq PURCHASE_NET_SYSTEM_MONEY>
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
		<cfscript>
		if(GET_MONEY.RECORDCOUNT)
			rate=GET_MONEY.RATE2/GET_MONEY.RATE1;
		else
			rate=1;
		</cfscript>
	</cfif>
	<cfscript>//ytl den diger parabirimlerine cevrildigi icin kura boluyoruz
		stock_cost=GET_ACTION.PURCHASE_NET_SYSTEM/rate;
		stock_cost_extra=GET_ACTION.PURCHASE_EXTRA_COST_SYSTEM/rate;
		//stock_amount_total=GET_ACTION.AMOUNT;
	</cfscript>
	
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
				AND PROCESS_DATE <= #createodbcdatetime(GET_ACTION.ACTION_DATE)#
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
				AND PROCESS_DATE <= #createodbcdatetime(GET_ACTION.ACTION_DATE)#
				AND PROCESS_TYPE<>81
			GROUP BY
				STOCK_ID,
				SPECT_VAR_ID
		</cfquery>
	</cfif>
	<cfscript>
		if(GET_STOCK.RECORDCOUNT and len(GET_STOCK.PRODUCT_STOCK)) stock_amount_total=GET_STOCK.PRODUCT_STOCK; else stock_amount_total=0;
	</cfscript>
</cfif>
<cfset stock_cost = "#stock_cost#;#stock_cost_extra#;#stock_amount_total#">
