<!--- Talep tahminleme Üstel düzeltme yöntemleri hesaplama sayfası --->
<cfquery name="get_expo" datasource="#dsn3#">
	SELECT * FROM ASSEMPTION_EXPONENTIAL_VALUES ORDER BY EXPONENTIAL_VALUE
</cfquery>
<cfflush interval="100">
<tr>
	<td colspan="2">
		<table>
			<cfoutput query="get_product">
				<tr>
					<td>#currentrow# - #product_name# <cf_get_lang dictionary_id="58786.Tamamlandı">.</td>
				</tr>
				<cfquery name="get_actions" datasource="#dsn3#">
					SELECT
						YEAR,
						MONTH,
						SUM(SALE_AMOUNT) AMOUNT
					FROM
					(
						SELECT
							MS.YEAR,
							MS.MONTH,
							MS.SALE_AMOUNT
						FROM
							MONTHLY_SALES_AMOUNT MS
						WHERE
							MS.STOCK_ID = #get_product.stock_id#
						<cfloop query="get_all_period">
							<cfset new_dsn2 = "#dsn#_#period_year#_#session.ep.company_id#">
							UNION ALL
							SELECT
								YEAR(PROCESS_DATE) YEAR,
								MONTH(PROCESS_DATE) MONTH,
								SR.STOCK_OUT SALE_AMOUNT
							FROM
								#new_dsn2#.STOCKS_ROW SR
							WHERE
								SR.PROCESS_TYPE = 71
								AND SR.STOCK_ID = #get_product.stock_id#
							UNION ALL
							SELECT
								YEAR(PROCESS_DATE) YEAR,
								MONTH(PROCESS_DATE) MONTH,
								-1*SR.STOCK_IN SALE_AMOUNT
							FROM
								#new_dsn2#.STOCKS_ROW SR
							WHERE
								SR.PROCESS_TYPE = 74
								AND SR.STOCK_ID = #get_product.stock_id#
						</cfloop>
						<cfloop from="1" to="12" index="kkk">
							UNION ALL
							SELECT
								#session.ep.period_year#,
								#kkk#,
								0
							FROM
								STOCKS
							WHERE
								STOCK_ID = #get_product.stock_id#
						</cfloop>
					)T1
					GROUP BY
						YEAR,
						MONTH
					ORDER BY
						MONTH+YEAR
				</cfquery>
				<cfloop query="get_expo">
					<cfset expo_value = get_expo.exponential_value>
					<cfset expo_id = get_expo.exponential_id>
					<!--- Eski kayıtlar siliniyor --->
					<cfquery name="del_row" datasource="#dsn3#">
						DELETE FROM DEMAND_ASSEMPTION_PRE WHERE STOCK_ID = #get_product.STOCK_ID# AND METHOD_ID = #attributes.method_type# AND EXPONENTIAL_ID = #expo_id#
					</cfquery>
					<cfloop query="get_actions">
						<cfset "sale_amount_#month#_#year#_#get_product.stock_id#" = amount>
						<cfif get_actions.currentrow eq 1>
							<cfset "total_amount_#month#_#year#_#get_product.stock_id#" = amount>
						<cfelseif isdefined("sale_amount_#month-1#_#year#_#get_product.stock_id#")>
							<cfset "total_amount_#month#_#year#_#get_product.stock_id#" = evaluate("sale_amount_#month-1#_#year#_#get_product.stock_id#")*expo_value+evaluate("total_amount_#month-1#_#year#_#get_product.stock_id#")*(1-expo_value)>
						<cfelse>
							<cfset "total_amount_#month#_#year#_#get_product.stock_id#" = 0>
						</cfif>
						<cfset "hata_#month#_#year#_#get_product.stock_id#" = amount - evaluate("total_amount_#month#_#year#_#get_product.stock_id#")>
						<cfif evaluate("hata_#month#_#year#_#get_product.stock_id#") lt 0>
							<cfset "mad_#month#_#year#_#get_product.stock_id#" = -1*evaluate("hata_#month#_#year#_#get_product.stock_id#")>
						<cfelse>
							<cfset "mad_#month#_#year#_#get_product.stock_id#" = evaluate("hata_#month#_#year#_#get_product.stock_id#")>
						</cfif>
						<cfset "mse_#month#_#year#_#get_product.stock_id#" = evaluate("mad_#month#_#year#_#get_product.stock_id#")*evaluate("mad_#month#_#year#_#get_product.stock_id#")>
					</cfloop>
					<cfset satir_say = 0>
					<cfset hata_toplam = 0>
					<cfset mad_toplam = 0>
					<cfset mse_toplam = 0>
					<cfloop query="get_actions">
						<cfif evaluate("total_amount_#month#_#year#_#get_product.stock_id#") gt 0>
							<cfset satir_say = satir_say+1>
							<cfset hata_toplam = hata_toplam + evaluate("hata_#month#_#year#_#get_product.stock_id#")>
							<cfset mad_toplam = mad_toplam + evaluate("mad_#month#_#year#_#get_product.stock_id#")>
							<cfset mse_toplam = mse_toplam + evaluate("mse_#month#_#year#_#get_product.stock_id#")>
						</cfif>
					</cfloop>
					<cfquery name="add_row" datasource="#dsn3#">
						INSERT INTO
							DEMAND_ASSEMPTION_PRE
						(
							STOCK_ID,
							METHOD_ID,
							EXPONENTIAL_ID,
							MFE,
							MAD,
							MSE
						)
						VALUES
						(
							#get_product.stock_id#,
							#attributes.method_type#,
							#expo_id#,
							<cfif satir_say neq 0>#hata_toplam/satir_say#<cfelse>0</cfif>,
							<cfif satir_say neq 0>#mad_toplam/satir_say#<cfelse>0</cfif>,
							<cfif satir_say neq 0>#mse_toplam/satir_say#<cfelse>0</cfif>
						)
					</cfquery>
				</cfloop>				
			</cfoutput>			
		</table>
	</td>
</tr>

