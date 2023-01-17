<!--- 
	bu dosya list_product_tree_costs sayfasindan cagiriliyor.
	stock_id adli degiskeni aliyor.
--->
<cfquery name="GET_TOTAL" datasource="#DSN#">
	SELECT
		((((W.VALUE_STATION*(SM1.RATE2/SM1.RATE1)/W.AMORTISMAN)/W.AVG_CAPACITY_DAY)/W.AVG_CAPACITY_HOUR)/WP.CAPACITY +(W.COST*(SM2.RATE2/SM2.RATE1)) )AS RESULT, 
		W.ENERGY AS ENERGY_T, 
		1 AS CAPACITY
	FROM
		#dsn3_alias#.WORKSTATIONS W ,
		#dsn3_alias#.WORKSTATIONS_PRODUCTS WP,
		SETUP_MONEY SM1,
		SETUP_MONEY SM2

	WHERE
		SM1.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		SM2.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		W.VALUE_STATION_MONEY=SM1.MONEY_ID AND
		W.COST_MONEY=SM2.MONEY_ID AND
		WP.WS_ID=W.STATION_ID
		<cfif isdefined('attributes.report_ws_id')>
		AND W.STATION_ID=#attributes.report_ws_id#
		</cfif>
		AND WP.STOCK_ID IN (#attributes.STOCK_IDS#)
</cfquery>
