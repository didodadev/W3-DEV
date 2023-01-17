<!--- Talep tahminleme trend analizi hesaplama sayfası --->
<cfif not isdefined("is_record")>
	<cfflush interval="100">
</cfif>
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
				<!--- Eski kayıtlar siliniyor --->
				<cfif not isdefined("is_record")>
					<cfquery name="del_row" datasource="#dsn3#">
						DELETE FROM DEMAND_ASSEMPTION_PRE WHERE STOCK_ID = #get_product.STOCK_ID# AND METHOD_ID = #attributes.method_type#
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
					<cfset last_year = year(attributes.finish_date)>
				<cfelse>
					<cfset last_year = year(now())>
				</cfif>
				<cfset sale_amount = 0>
				<cfset total_sale_amount = 0>
				<cfset month_amount = 0>
				<cfset total_month_amount = 0>
				<cfloop query="get_actions">
					<cfif year neq last_year>
						<cfset sale_amount = sale_amount + amount>
						<cfset total_sale_amount = total_sale_amount + amount*month>
						<cfset month_amount = month_amount + month>
						<cfset total_month_amount = total_month_amount + month*month>
					</cfif>
				</cfloop>
				<cfif ((get_actions.month*total_month_amount)-(month_amount*month_amount)) neq 0>
					<cfset a = ((sale_amount*total_month_amount)-(month_amount*total_sale_amount))/((get_actions.month*total_month_amount)-(month_amount*month_amount))>
					<cfset b = ((get_actions.month*total_sale_amount)-(month_amount*sale_amount))/((get_actions.month*total_month_amount)-(month_amount*month_amount))>
				<cfelse>
					<cfset a = 0>	
					<cfset b = 0>	
				</cfif>
				<cfloop query="get_actions">
					<cfif year eq last_year>
						<cfif isdefined("is_record")><!--- Kaydetme ekranından geliyorsa tahminleri kaydedecek --->
							<cfset demand_amount = a+amount*b>
							<cfif demand_amount neq 0>
								<cfset day_amount = demand_amount / 4>
								<cfset month_info = month>
								<cfset year_info = year>
								<cfloop from="1" to="4" index="jjj">
									<cfquery name="add_row" datasource="#dsn3#">
										INSERT INTO
											DEMAND_ASSEMPTION
										(
											STOCK_ID,
											METHOD_ID,
											EXPONENTIAL_ID,
											DAY,
											MONTH,
											YEAR,
											ASSEMPTION_AMOUNT,
											RECORD_DATE,
											RECORD_IP,
											RECORD_EMP
										)
										VALUES
										(
											#stock_id_#,
											#method_id_#,
											#expo_id_#,
											<cfif jjj eq 1>1<cfelseif jjj eq 2>8<cfelseif jjj eq 3>15<cfelse>22</cfif>,
											#month_info#,
											#year_info#,
											#day_amount#,							
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
											<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
										)
									</cfquery>	
								</cfloop>
							</cfif>
						</cfif>
						<cfset "hata_#month#_#year#_#get_product.stock_id#" = amount - (a+amount*b)>
						<cfif evaluate("hata_#month#_#year#_#get_product.stock_id#") lt 0>
							<cfset "mad_#month#_#year#_#get_product.stock_id#" = -1*evaluate("hata_#month#_#year#_#get_product.stock_id#")>
						<cfelse>
							<cfset "mad_#month#_#year#_#get_product.stock_id#" = evaluate("hata_#month#_#year#_#get_product.stock_id#")>
						</cfif>
						<cfset "mse_#month#_#year#_#get_product.stock_id#" = evaluate("mad_#month#_#year#_#get_product.stock_id#")*evaluate("mad_#month#_#year#_#get_product.stock_id#")>
					</cfif>
				</cfloop>
				<cfset satir_say = 0>
				<cfset hata_toplam = 0>
				<cfset mad_toplam = 0>
				<cfset mse_toplam = 0>
				<cfloop query="get_actions">
					<cfif year eq last_year>
						<cfset satir_say = satir_say+1>
						<cfset hata_toplam = hata_toplam + evaluate("hata_#month#_#year#_#get_product.stock_id#")>
						<cfset mad_toplam = mad_toplam + evaluate("mad_#month#_#year#_#get_product.stock_id#")>
						<cfset mse_toplam = mse_toplam + evaluate("mse_#month#_#year#_#get_product.stock_id#")>
					</cfif>
				</cfloop>
				<cfif not isdefined("is_record")>
					<cfquery name="add_row" datasource="#dsn3#">
						INSERT INTO
							DEMAND_ASSEMPTION_PRE
						(
							STOCK_ID,
							METHOD_ID,
							MFE,
							MAD,
							MSE
						)
						VALUES
						(
							#get_product.stock_id#,
							#attributes.method_type#,
							<cfif satir_say neq 0>#hata_toplam/satir_say#<cfelse>0</cfif>,
							<cfif satir_say neq 0>#mad_toplam/satir_say#<cfelse>0</cfif>,
							<cfif satir_say neq 0>#mse_toplam/satir_say#<cfelse>0</cfif>
						)
					</cfquery>
				</cfif>
			</cfoutput>			
		</table>
	</td>
</tr>

