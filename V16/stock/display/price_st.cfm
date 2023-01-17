<cfif isDefined("attributes.stock_id")>
	<cfset total=total_stk>
	<cfif total gt 0>
		<cfquery name="GET_PRICE_STANDART" datasource="#dsn3#" maxrows="1">
		SELECT
		<cfif attributes.tax IS 1>
			PS.PRICE_KDV*(SM.RATE2/SM.RATE1) PRICE
		<cfelse>
			PS.PRICE*(SM.RATE2/SM.RATE1) PRICE
		</cfif>
		FROM 
			PRICE_STANDART PS,
			#dsn_alias#.SETUP_MONEY SM
		WHERE 
			PS.PRODUCT_ID=#attributes.product_id# AND
			<cfif attributes.inventory_calc_type eq 8>
				PS.PURCHASESALES = 1 AND <!--- standart satis--->
			<cfelse><!--- attributes.inventory_calc_type eq 7 : standart alis--->
				PS.PURCHASESALES = 0 AND
			</cfif>
			SM.MONEY = PS.MONEY
		ORDER BY 
			PS.RECORD_DATE DESC 
		</cfquery>
		<cfset nettotal = GET_PRICE_STANDART.PRICE * TOTAL>
	<cfelse>
		<cfset nettotal=0>
	</cfif>
</cfif>
