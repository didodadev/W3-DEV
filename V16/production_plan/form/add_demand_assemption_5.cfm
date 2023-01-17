<!--- Talep tahminleme mevsimsel trend analizi hesaplama sayfası --->
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
				<cfset year_list = ''>
				<cfloop query="get_actions">
					<cfif listfind("1,2,3",month)>
						<cfset index = 1>
					<cfelseif listfind("4,5,6",month)>
						<cfset index = 2>
					<cfelseif listfind("7,8,9",month)>
						<cfset index = 3>
					<cfelseif listfind("10,11,12",month)>
						<cfset index = 4>
					</cfif>
					<cfif year neq last_year>
						<cfif not listfind(year_list,year)>
							<cfset year_list = listappend(year_list,year)>
						</cfif>
						<cfif not isdefined("total_#index#_#year#_#get_product.stock_id#")>
							<cfset "total_#index#_#year#_#get_product.stock_id#" = 0>
						</cfif>
						<cfif not isdefined("all_total_#year#_#get_product.stock_id#")>
							<cfset "all_total_#year#_#get_product.stock_id#" = 0>
						</cfif>
						<cfset "total_#index#_#year#_#get_product.stock_id#" = evaluate("total_#index#_#year#_#get_product.stock_id#") + amount>
						<cfset "all_total_#year#_#get_product.stock_id#" = evaluate("all_total_#year#_#get_product.stock_id#") + amount>
					<cfelse>
						<cfif not isdefined("total_#index#_#year#_#get_product.stock_id#")>
							<cfset "total_#index#_#year#_#get_product.stock_id#" = 0>
						</cfif>
						<cfset "total_#index#_#year#_#get_product.stock_id#" = evaluate("total_#index#_#year#_#get_product.stock_id#") + amount>
					</cfif>
				</cfloop>
				<cfif listlen(year_list)>
					<cfset all_total = 0>
					<cfloop list="#year_list#" index="kk">
						<cfif isdefined("all_total_#kk#_#get_product.stock_id#")>
							<cfset all_total = all_total + evaluate("all_total_#kk#_#get_product.stock_id#")>
						</cfif>
					</cfloop>
					<cfset avg_all = all_total / 12>
					<cfloop from="1" to="4" index="mvs">
						<cfset "total_#mvs#" = 0>
						<cfloop list="#year_list#" index="kk">
							<cfif isdefined("total_#mvs#_#kk#_#get_product.stock_id#")>
								<cfset "total_#mvs#" = evaluate("total_#mvs#") + evaluate("total_#mvs#_#kk#_#get_product.stock_id#")>
							</cfif>
						</cfloop>
						<cfset "avg_#mvs#" = evaluate("total_#mvs#")/listlen(year_list)>
						<cfif avg_all neq 0>
							<cfset "avg_new_#mvs#" = evaluate("avg_#mvs#")/avg_all>
						<cfelse>
							<cfset "avg_new_#mvs#" = 0 >
						</cfif>
						<!--- #mvs#___#evaluate("avg_#mvs#")#___#evaluate("avg_new_#mvs#")#__#all_total#___#avg_all#<br> --->
					</cfloop>
				<cfelse>
					<cfloop from="1" to="4" index="mvs">
						<cfset "avg_#mvs#" = 0>
						<cfset "avg_new_#mvs#" = 0 >
					</cfloop>
				</cfif>
				<cfset sale_amount = 0>
				<cfset total_sale_amount = 0>
				<cfset month_amount = 0>
				<cfset total_month_amount = 0>
				<cfset count_new = 0>
				<cfif listlen(year_list)>
					<cfloop list="#year_list#" index="kk">
						<cfloop from="1" to="4" index="mvs">
							<cfset count_new =count_new+1>
							<cfif isdefined("total_#mvs#_#kk#_#get_product.stock_id#")>
								<cfif evaluate("avg_new_#mvs#") neq 0>
									<cfset "avg_total_#mvs#_#kk#_#get_product.stock_id#" = evaluate("total_#mvs#_#kk#_#get_product.stock_id#")/evaluate("avg_new_#mvs#")>
								<cfelse>
									<cfset "avg_total_#mvs#_#kk#_#get_product.stock_id#" = 0>
								</cfif>
								<cfset sale_amount = sale_amount + evaluate("avg_total_#mvs#_#kk#_#get_product.stock_id#")>
								<cfset total_sale_amount = total_sale_amount + evaluate("avg_total_#mvs#_#kk#_#get_product.stock_id#")*count_new>
								<cfset month_amount = month_amount + count_new>
								<cfset total_month_amount = total_month_amount + count_new*count_new>
							</cfif>
						</cfloop>
					</cfloop>
				</cfif>
				<cfif ((get_actions.month*total_month_amount)-(month_amount*month_amount)) neq 0>
					<cfset a = ((sale_amount*total_month_amount)-(month_amount*total_sale_amount))/((count_new*total_month_amount)-(month_amount*month_amount))>
					<cfset b = ((count_new*total_sale_amount)-(month_amount*sale_amount))/((count_new*total_month_amount)-(month_amount*month_amount))>
				<cfelse>
					<cfset a = 0>	
					<cfset b = 0>	
				</cfif>
				<cfloop from="1" to="4" index="mvs">
					<cfset count_new =count_new+1>
					<cfif isdefined("is_record")><!--- Kaydetme ekranından geliyorsa tahminleri kaydedecek --->
						<cfset demand_amount = (a+count_new*b)>
						<cfif demand_amount neq 0>
							<cfset day_amount = demand_amount / 12>
							<cfset year_info = last_year>
							<cfloop from="1" to="3" index="mmm">
								<cfif mvs eq 1>
									<cfif mmm eq 1>
										<cfset month_info = 1>
									<cfelseif mmm eq 2>
										<cfset month_info = 2>
									<cfelseif mmm eq 3>
										<cfset month_info = 3>
									</cfif>
								<cfelseif mvs eq 2>
									<cfif mmm eq 1>
										<cfset month_info = 4>
									<cfelseif mmm eq 2>
										<cfset month_info = 5>
									<cfelseif mmm eq 3>
										<cfset month_info = 6>
									</cfif>
								<cfelseif mvs eq 3>
									<cfif mmm eq 1>
										<cfset month_info = 7>
									<cfelseif mmm eq 2>
										<cfset month_info = 8>
									<cfelseif mmm eq 3>
										<cfset month_info = 9>
									</cfif>
								<cfelseif mvs eq 4>
									<cfif mmm eq 1>
										<cfset month_info = 10>
									<cfelseif mmm eq 2>
										<cfset month_info = 11>
									<cfelseif mmm eq 3>
										<cfset month_info = 12>
									</cfif>
								</cfif>
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
							</cfloop>
						</cfif>
					</cfif>
					<cfset "hata_#mvs#_#last_year#_#get_product.stock_id#" = (evaluate("total_#mvs#_#last_year#_#get_product.stock_id#") - (a+count_new*b))*evaluate("avg_new_#mvs#")>
					<cfif evaluate("hata_#mvs#_#last_year#_#get_product.stock_id#") lt 0>
						<cfset "mad_#mvs#_#last_year#_#get_product.stock_id#" = -1*evaluate("hata_#mvs#_#last_year#_#get_product.stock_id#")>
					<cfelse>
						<cfset "mad_#mvs#_#last_year#_#get_product.stock_id#" = evaluate("hata_#mvs#_#last_year#_#get_product.stock_id#")>
					</cfif>
					<cfset "mse_#mvs#_#last_year#_#get_product.stock_id#" = evaluate("mad_#mvs#_#last_year#_#get_product.stock_id#")*evaluate("mad_#mvs#_#last_year#_#get_product.stock_id#")>
				</cfloop>
				<cfset satir_say = 0>
				<cfset hata_toplam = 0>
				<cfset mad_toplam = 0>
				<cfset mse_toplam = 0>
				<cfloop query="get_actions">
					<cfif year eq last_year>
						<cfif listfind("1,2,3",month)>
							<cfset index = 1>
						<cfelseif listfind("4,5,6",month)>
							<cfset index = 2>
						<cfelseif listfind("7,8,9",month)>
							<cfset index = 3>
						<cfelseif listfind("10,11,12",month)>
							<cfset index = 4>
						</cfif>
						<cfset satir_say = satir_say+1>
						<cfset hata_toplam = hata_toplam + evaluate("hata_#index#_#year#_#get_product.stock_id#")>
						<cfset mad_toplam = mad_toplam + evaluate("mad_#index#_#year#_#get_product.stock_id#")>
						<cfset mse_toplam = mse_toplam + evaluate("mse_#index#_#year#_#get_product.stock_id#")>
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

