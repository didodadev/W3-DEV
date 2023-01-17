<cfsetting showdebugoutput="yes">
<cfoutput>
	<cfquery name="GET_STOCK" datasource="#DSN3#">
		SELECT
			STOCK_ID,
			STOCK_CODE,
			PRODUCT_NAME,
			IS_PRODUCTION
		FROM
			STOCKS
		WHERE
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
	
</cfoutput>
<cf_medium_list>
	<cfquery name="get_stocks_closed" datasource="#dsn2#">
		SELECT
			SRR.*
		FROM
			STOCKS_ROW_CLOSED SRR
		WHERE
			SRR.PRODUCT_ID = #attributes.pid#
			AND UPD_ID_OUT IS NOT NULL
	</cfquery>
    <cfquery name="get_stocks_closed_in" datasource="#dsn2#">
		SELECT
			SRR.*
		FROM
			STOCKS_ROW_CLOSED SRR
		WHERE
			SRR.PRODUCT_ID = #attributes.pid#
			AND UPD_ID_IN IS NOT NULL
	</cfquery>
	<cfquery name="get_stocks_all" datasource="#dsn2#">
		SELECT
			SRR.*
		FROM
			STOCKS_ROW SRR
		WHERE
			SRR.PRODUCT_ID = #attributes.pid#
			AND PROCESS_TYPE NOT IN(81,811)
	</cfquery>
	<cfquery name="get_stocks_all_in" dbtype="query">
		SELECT
			*
		FROM
			get_stocks_all
		WHERE
			STOCK_IN > 0
		ORDER BY
			PROCESS_DATE,
			UPD_ID
	</cfquery>
	<thead>
		<tr>
			<th colspan="6" style="text-align:center;"><cf_get_lang dictionary_id='60488.Giriş Belge'></th>
			<th colspan="4" style="text-align:center;"><cf_get_lang dictionary_id='60489.Çıkış Belge'></th>
		</tr>
		<tr>
			<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
			<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57800.İşlem Tipi'> </th>
			<th style="width:55px;" nowrap><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th style="width:55px;" nowrap><cf_get_lang dictionary_id='58258.Maliyet'></th>
            <th style="width:55px;" nowrap><cf_get_lang dictionary_id='57175.Ek Maliyet'></th>
			<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
			<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th align="center" style="width:60px;" nowrap><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
			<th style="width:55px;" nowrap><cf_get_lang dictionary_id='57635.Miktar'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_stocks_all_in.recordcount>
			<cfset irsaliye_tipleri = '70,71,72,73,74,75,76,77,78,79,80,81,87,811,761,84,85,86,88,140,141'>
			<cfset upd_id_list=''>
			<cfset upd_id_list2=''>
			<cfset upd_id_list3=''>
			<cfset upd_id_list4=''>
			<cfset upd_id_list5=''>
			<cfoutput query="get_stocks_all_in">
				<cfif listfind(irsaliye_tipleri,get_stocks_all_in.process_type,",")>
					<cfif not listfind(upd_id_list,get_stocks_all_in.upd_id)>
						<cfset upd_id_list = listappend(upd_id_list,get_stocks_all_in.upd_id)>
					</cfif>
				<cfelseif listfind("110,111,112,113,114,115,119,118,1182",get_stocks_all_in.process_type,",")><!--- Üretim,Ambar Fisi(Depolar arasi),Devir Fisi(Dönemler arasi),Sayim Fisi,Üretimden Giriş Fişi(Demontaj)  --->
					<cfif not listfind(upd_id_list2,get_stocks_all_in.upd_id)>
						<cfset upd_id_list2 = listappend(upd_id_list2,get_stocks_all_in.upd_id)>
					</cfif>						
				<cfelseif listfind("67,68,691,69",get_stocks_all_in.process_type,",")>
					<cfif not listfind(upd_id_list3,get_stocks_all_in.upd_id)>
						<cfset upd_id_list3 = listappend(upd_id_list3,get_stocks_all_in.upd_id)>
					</cfif>
				<cfelseif listfind("116",get_stocks_all_in.process_type,",")>
					<cfif not listfind(upd_id_list4,get_stocks_all_in.upd_id)>
						<cfset upd_id_list4 = listappend(upd_id_list4,get_stocks_all_in.upd_id)>
					</cfif>		
				<cfelseif listfind("120,122",get_stocks_all_in.process_type,",")>
					<cfif not listfind(upd_id_list5,get_stocks_all_in.upd_id)>
						<cfset upd_id_list5 = listappend(upd_id_list5,get_stocks_all_in.upd_id)>
					</cfif>		
				</cfif>
			</cfoutput>
			<cfoutput query="get_stocks_closed">
				<cfif listfind(irsaliye_tipleri,get_stocks_closed.process_type_out,",")>
					<cfif not listfind(upd_id_list,get_stocks_closed.upd_id_out)>
						<cfset upd_id_list = listappend(upd_id_list,get_stocks_closed.upd_id_out)>
					</cfif>
				<cfelseif listfind("110,111,112,113,114,115,119,118,1182",get_stocks_closed.process_type_out,",")><!--- Üretim,Ambar Fisi(Depolar arasi),Devir Fisi(Dönemler arasi),Sayim Fisi,Üretimden Giriş Fişi(Demontaj)  --->
					<cfif not listfind(upd_id_list2,get_stocks_closed.upd_id_out)>
						<cfset upd_id_list2 = listappend(upd_id_list2,get_stocks_closed.upd_id_out)>
					</cfif>						
				<cfelseif listfind("67,68,691,69",get_stocks_closed.process_type_out,",")>
					<cfif not listfind(upd_id_list3,get_stocks_closed.upd_id_out)>
						<cfset upd_id_list3 = listappend(upd_id_list3,get_stocks_closed.upd_id_out)>
					</cfif>
				<cfelseif listfind("116",get_stocks_closed.process_type_out,",")>
					<cfif not listfind(upd_id_list4,get_stocks_closed.upd_id_out)>
						<cfset upd_id_list4 = listappend(upd_id_list4,get_stocks_closed.upd_id_out)>
					</cfif>		
				<cfelseif listfind("120,122",get_stocks_closed.process_type_out,",")>
					<cfif not listfind(upd_id_list5,get_stocks_closed.upd_id_out)>
						<cfset upd_id_list5 = listappend(upd_id_list5,get_stocks_closed.upd_id_out)>
					</cfif>		
				</cfif>
			</cfoutput>
			<cfif len(upd_id_list)>
				<cfquery name="get_ship" datasource="#dsn2#">
					SELECT SHIP_NUMBER,SHIP_ID,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,DELIVER_EMP_ID,SHIP_TYPE FROM SHIP WHERE SHIP_ID IN (#upd_id_list#) ORDER BY SHIP_ID
				</cfquery>
				<cfset upd_id_list = ListSort(ListDeleteDuplicates(valuelist(get_ship.SHIP_ID)),"numeric","asc",",")>
			</cfif>
			<cfif len(upd_id_list2)>
				<cfquery name="get_fis" datasource="#dsn2#">
					SELECT
						SF.FIS_NUMBER,
						SF.FIS_ID,
						PO.P_ORDER_NO,
						POR.LOT_NO,
						SF.COMPANY_ID,
						SF.CONSUMER_ID,
						SF.EMPLOYEE_ID
					FROM 
						STOCK_FIS SF
						LEFT JOIN #dsn3_alias#.PRODUCTION_ORDERS PO
						ON SF.PROD_ORDER_NUMBER=PO.P_ORDER_ID
						LEFT JOIN #dsn3_alias#.PRODUCTION_ORDER_RESULTS POR
						ON SF.PROD_ORDER_RESULT_NUMBER=POR.PR_ORDER_ID
					WHERE SF.FIS_ID IN (#upd_id_list2#) ORDER BY SF.FIS_ID
				</cfquery>
				<cfset upd_id_list2 = ListSort(ListDeleteDuplicates(valuelist(get_fis.FIS_ID)),"numeric","asc",",")>
			</cfif>
			<cfif len(upd_id_list3)>
				<cfquery name="get_invoice" datasource="#dsn2#">
					SELECT INVOICE_NUMBER,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,INVOICE_ID FROM INVOICE WHERE INVOICE_ID IN (#upd_id_list3#) ORDER BY INVOICE_ID
				</cfquery>
				<cfset upd_id_list3 = ListSort(ListDeleteDuplicates(valuelist(get_invoice.INVOICE_ID)),"numeric","asc",",")>
			</cfif>
			<cfif len(upd_id_list4)>
				<cfquery name="get_exchange" datasource="#dsn2#">
					SELECT EXCHANGE_NUMBER,STOCK_EXCHANGE_ID FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID IN (#upd_id_list4#) ORDER BY STOCK_EXCHANGE_ID
				</cfquery>
				<cfset upd_id_list4 = ListSort(ListDeleteDuplicates(valuelist(get_exchange.STOCK_EXCHANGE_ID)),"numeric","asc",",")>
			</cfif>
			<cfif len(upd_id_list5)>
				<cfquery name="get_expense" datasource="#dsn2#">
					SELECT PAPER_NO,EXPENSE_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID IN (#upd_id_list5#) ORDER BY EXPENSE_ID
				</cfquery>
				<cfset upd_id_list5 = ListSort(ListDeleteDuplicates(valuelist(get_expense.EXPENSE_ID)),"numeric","asc",",")>
			</cfif>
			<cfoutput query="get_stocks_all_in">
				<cfquery name="get_row_amount" dbtype="query">
					SELECT
						SUM(STOCK_IN) AMOUNT
					FROM
						get_stocks_all_in
					WHERE
						UPD_ID = #get_stocks_all_in.upd_id#
						AND PROCESS_TYPE = #get_stocks_all_in.process_type#
				</cfquery>
                <cfquery name="GET_ROWS_A" dbtype="query">
					SELECT 
						COST_PRICE,
                        COST_EXTRA_PRICE
					FROM 
						get_stocks_closed_in 
					WHERE 
						UPD_ID_IN = #get_stocks_all_in.upd_id#
						AND PROCESS_TYPE_IN = #get_stocks_all_in.process_type#
					ORDER BY
						PROCESS_DATE_OUT
				</cfquery>
				<cfquery name="GET_ROWS_B" dbtype="query">
					SELECT 
						* 
					FROM 
						get_stocks_closed 
					WHERE 
						UPD_ID_IN = #get_stocks_all_in.upd_id#
						AND PROCESS_TYPE_IN = #get_stocks_all_in.process_type#
					ORDER BY
						PROCESS_DATE_OUT
				</cfquery>
				<cfif get_rows_b.recordcount>
					<cfset row_ = get_rows_b.recordcount>
					<cfloop from="1" to="#row_#" index="ccc">
						<tr class="color-list">
							<cfif ccc eq 1>
								<td rowspan="#get_rows_b.recordcount#">#dateformat(get_stocks_all_in.process_date,dateformat_style)#</td>
								<td rowspan="#get_rows_b.recordcount#">
									<cfif listfind(irsaliye_tipleri,get_stocks_all_in.process_type,",") and len(upd_id_list)>
										#get_ship.ship_number[listfind(upd_id_list,get_stocks_all_in.upd_id,',')]#
									<cfelseif listfind("110,111,112,113,114,115,118,1182",get_stocks_all_in.process_type,",") and len(upd_id_list2)>
										#get_fis.fis_number[listfind(upd_id_list2,get_stocks_all_in.upd_id,',')]#
									<cfelseif listfind("67,691,69",get_stocks_all_in.process_type,",") and len(upd_id_list3)>
										#get_invoice.invoice_number[listfind(upd_id_list3,get_stocks_all_in.upd_id,',')]#
									<cfelseif listfind("116",get_stocks_all_in.process_type,",") and len(upd_id_list4)>
										#get_exchange.EXCHANGE_NUMBER[listfind(upd_id_list4,get_stocks_all_in.upd_id,',')]#
									<cfelseif listfind("120,122",get_stocks_all_in.process_type,",") and len(upd_id_list5)>
										#get_expense.PAPER_NO[listfind(upd_id_list5,get_stocks_all_in.upd_id,',')]#
									</cfif>
								</td>
								<td rowspan="#get_rows_b.recordcount#">
									<cfif get_module_user(13)>
										<cfif listfind(irsaliye_tipleri,get_stocks_all_in.process_type,",") and len(upd_id_list) and not listfind("70,71,72,78,79,85,88,141",get_stocks_all_in.process_type,",")>
											<cfswitch expression="#get_stocks_all_in.process_type#">
												<cfcase value="761">
													<cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
												</cfcase>
												<cfcase value="82">
													<cfset url_param = "#request.self#?fuseaction=invent.upd_purchase_invent&ship_id=">
												</cfcase>
												<cfcase value="81">
													<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
												</cfcase>
												<cfdefaultcase>
													<cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
												</cfdefaultcase>
											</cfswitch>
										<cfelseif stock_out gt 0 and not listfind("110,111,112,113,114,115,116,117,118,1182",get_stocks_all_in.process_type,",")>
											<cfswitch expression="#get_stocks_all_in.process_type#">
												<cfcase value="81">
													<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
												</cfcase>
												<cfcase value="811">
													<cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=">
												</cfcase>
												<cfcase value="83">
													<cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
												</cfcase>
												<cfdefaultcase>
													<cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
												</cfdefaultcase>
											</cfswitch>				
										<cfelse>
											<cfswitch expression="#get_stocks_all_in.process_type#">
												<cfcase value="114">
													<cfset url_param="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
												</cfcase>
												<cfcase value="118">
													<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=">
												</cfcase>
												<cfcase value="1182">
													<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
												</cfcase>
												<cfcase value="116">
													<cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
												</cfcase>
												<cfdefaultcase>
													<cfset url_param="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
												</cfdefaultcase>
											</cfswitch>
										</cfif>
										<a href="#url_param##get_stocks_all_in.upd_id#" class="tableyazi" target="_blank">#get_process_name(get_stocks_all_in.process_type)#</a>
									<cfelse>
										<cfif listfind(irsaliye_tipleri,get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_stocks_all_in.upd_id#','list','popup_detail_ship');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("87",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_stocks_all_in.upd_id#','list','popup_detail_ship');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("116",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_stock_virman&exchange_id=#get_stocks_all_in.upd_id#','list','popup_detail_stock_virman');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("122",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cost.popup_list_cost_expense&id=#get_stocks_all_in.upd_id#','page','popup_list_cost_expense');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("69",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.upd_daily_zreport&iid=#get_stocks_all_in.upd_id#','wide');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("110,118,1182",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("111",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("112",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>							
										<cfelseif listfind("113",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>							
										<cfelseif listfind("114",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("115",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
										<cfelseif listfind("119",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>							
										<cfelseif listfind("120",get_stocks_all_in.process_type,",")>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_cost_expense&id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>														
										<cfelse>
											#get_process_name(get_stocks_all_in.process_type)#
										</cfif>
									</cfif>
								</td>
								<td style="text-align:right;" rowspan="#get_rows_b.recordcount#">#tlformat(get_row_amount.amount,4)#</td>
								<td style="text-align:right;" rowspan="#get_rows_b.recordcount#">#tlformat(get_rows_b.cost_price[ccc],4)#</td>
                                <td style="text-align:right;" rowspan="#get_rows_b.recordcount#">#tlformat(get_rows_b.cost_extra_price[ccc],4)#</td>
							</cfif>
							<td>#dateformat(get_rows_b.process_date_out[ccc],dateformat_style)#</td>
							<td>
								<cfif listfind(irsaliye_tipleri,get_rows_b.process_type_out[ccc],",") and len(upd_id_list)>
									#get_ship.ship_number[listfind(upd_id_list,get_rows_b.upd_id_out[ccc],',')]#
								<cfelseif listfind("110,111,112,113,114,115,118,1182",get_rows_b.process_type_out[ccc],",") and len(upd_id_list2)>
									#get_fis.fis_number[listfind(upd_id_list2,get_rows_b.upd_id_out[ccc],',')]#
								<cfelseif listfind("67,691,69",get_rows_b.process_type_out[ccc],",") and len(upd_id_list3)>
									#get_invoice.invoice_number[listfind(upd_id_list3,get_rows_b.upd_id_out[ccc],',')]#
								<cfelseif listfind("116",get_rows_b.process_type_out[ccc],",") and len(upd_id_list4)>
									#get_exchange.EXCHANGE_NUMBER[listfind(upd_id_list4,get_rows_b.upd_id_out[ccc],',')]#
								<cfelseif listfind("120,122",get_rows_b.process_type_out[ccc],",") and len(upd_id_list5)>
									#get_expense.PAPER_NO[listfind(upd_id_list5,get_rows_b.upd_id_out[ccc],',')]#
								</cfif>
							</td>
							<td>
								<cfif get_module_user(13)>
									<cfif listfind(irsaliye_tipleri,get_rows_b.process_type_out[ccc],",") and len(upd_id_list) and not listfind("70,71,72,78,79,85,88,141",get_rows_b.process_type_out[ccc],",")>
										<cfswitch expression="#get_rows_b.process_type_out[ccc]#">
											<cfcase value="761">
												<cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
											</cfcase>
											<cfcase value="82">
												<cfset url_param = "#request.self#?fuseaction=invent.upd_purchase_invent&ship_id=">
											</cfcase>
											<cfcase value="81">
												<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
											</cfcase>
											<cfdefaultcase>
												<cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
											</cfdefaultcase>
										</cfswitch>
									<cfelseif not listfind("110,111,112,113,114,115,116,117,118,1182",get_rows_b.process_type_out[ccc],",")>
										<cfswitch expression="#get_rows_b.process_type_out[ccc]#">
											<cfcase value="81">
												<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
											</cfcase>
											<cfcase value="811">
												<cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=">
											</cfcase>
											<cfcase value="83">
												<cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
											</cfcase>
											<cfdefaultcase>
												<cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
											</cfdefaultcase>
										</cfswitch>				
									<cfelse>
										<cfswitch expression="#get_rows_b.process_type_out[ccc]#">
											<cfcase value="114">
												<cfset url_param="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
											</cfcase>
											<cfcase value="118">
												<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=">
											</cfcase>
											<cfcase value="1182">
												<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
											</cfcase>
											<cfcase value="116">
												<cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
											</cfcase>
											<cfdefaultcase>
												<cfset url_param="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
											</cfdefaultcase>
										</cfswitch>
									</cfif>
									<a href="#url_param##get_rows_b.upd_id_out[ccc]#" class="tableyazi" target="_blank">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
								<cfelse>
									<cfif listfind(irsaliye_tipleri,get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_rows_b.upd_id_out[ccc]#','list','popup_detail_ship');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("87",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_rows_b.upd_id_out[ccc]#','list','popup_detail_ship');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("116",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_stock_virman&exchange_id=#get_rows_b.upd_id_out[ccc]#','list','popup_detail_stock_virman');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("122",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cost.popup_list_cost_expense&id=#get_rows_b.upd_id_out[ccc]#','page','popup_list_cost_expense');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("69",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.upd_daily_zreport&iid=#get_rows_b.upd_id_out[ccc]#','wide');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("110,118,1182",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("111",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("112",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>							
									<cfelseif listfind("113",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>							
									<cfelseif listfind("114",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("115",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>
									<cfelseif listfind("119",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>							
									<cfelseif listfind("120",get_rows_b.process_type_out[ccc],",")>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_cost_expense&id=#get_rows_b.upd_id_out[ccc]#','list');" class="tableyazi">#get_process_name(get_rows_b.process_type_out[ccc])#</a>														
									<cfelse>
										#get_process_name(get_rows_b.process_type_out[ccc])#
									</cfif>
								</cfif>
							</td>
							<td style="text-align:right;">#tlformat(get_rows_b.amount[ccc],4)#</td>
						</tr>
					</cfloop>
				<cfelse>
					<tr class="color-list">
						<td>#dateformat(get_stocks_all_in.process_date,dateformat_style)#</td>
						<td>
							<cfif listfind(irsaliye_tipleri,get_stocks_all_in.process_type,",") and len(upd_id_list)>
								#get_ship.ship_number[listfind(upd_id_list,get_stocks_all_in.upd_id,',')]#
							<cfelseif listfind("110,111,112,113,114,115,118,1182",get_stocks_all_in.process_type,",") and len(upd_id_list2)>
								#get_fis.fis_number[listfind(upd_id_list2,get_stocks_all_in.upd_id,',')]#
							<cfelseif listfind("67,691,69",get_stocks_all_in.process_type,",") and len(upd_id_list3)>
								#get_invoice.invoice_number[listfind(upd_id_list3,get_stocks_all_in.upd_id,',')]#
							<cfelseif listfind("116",get_stocks_all_in.process_type,",") and len(upd_id_list4)>
								#get_exchange.EXCHANGE_NUMBER[listfind(upd_id_list4,get_stocks_all_in.upd_id,',')]#
							<cfelseif listfind("120,122",get_stocks_all_in.process_type,",") and len(upd_id_list5)>
								#get_expense.PAPER_NO[listfind(upd_id_list5,get_stocks_all_in.upd_id,',')]#
							</cfif>
						</td>
						<td>
							<cfif get_module_user(13)>
								<cfif listfind(irsaliye_tipleri,get_stocks_all_in.process_type,",") and len(upd_id_list) and not listfind("70,71,72,78,79,85,88,141",get_stocks_all_in.process_type,",")>
									<cfswitch expression="#get_stocks_all_in.process_type#">
										<cfcase value="761">
											<cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
										</cfcase>
										<cfcase value="82">
											<cfset url_param = "#request.self#?fuseaction=invent.upd_purchase_invent&ship_id=">
										</cfcase>
										<cfcase value="81">
											<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
										</cfcase>
										<cfdefaultcase>
											<cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
										</cfdefaultcase>
									</cfswitch>
								<cfelseif stock_out gt 0 and not listfind("110,111,112,113,114,115,116,117,118,1182",get_stocks_all_in.process_type,",")>
									<cfswitch expression="#get_stocks_all_in.process_type#">
										<cfcase value="81">
											<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
										</cfcase>
										<cfcase value="811">
											<cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=">
										</cfcase>
										<cfcase value="83">
											<cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
										</cfcase>
										<cfdefaultcase>
											<cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
										</cfdefaultcase>
									</cfswitch>				
								<cfelse>
									<cfswitch expression="#get_stocks_all_in.process_type#">
										<cfcase value="114">
											<cfset url_param="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
										</cfcase>
										<cfcase value="118">
											<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=">
										</cfcase>
										<cfcase value="1182">
											<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
										</cfcase>
										<cfcase value="116">
											<cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
										</cfcase>
										<cfdefaultcase>
											<cfset url_param="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
										</cfdefaultcase>
									</cfswitch>
								</cfif>
								<a href="#url_param##get_stocks_all_in.upd_id#" class="tableyazi" target="_blank">#get_process_name(get_stocks_all_in.process_type)#</a>
							<cfelse>
								<cfif listfind(irsaliye_tipleri,get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_stocks_all_in.upd_id#','list','popup_detail_ship');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("87",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#get_stocks_all_in.upd_id#','list','popup_detail_ship');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("116",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_stock_virman&exchange_id=#get_stocks_all_in.upd_id#','list','popup_detail_stock_virman');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("122",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cost.popup_list_cost_expense&id=#get_stocks_all_in.upd_id#','page','popup_list_cost_expense');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("69",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.upd_daily_zreport&iid=#get_stocks_all_in.upd_id#','wide');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("110,118,1182",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("111",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("112",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>							
								<cfelseif listfind("113",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>							
								<cfelseif listfind("114",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("115",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>
								<cfelseif listfind("119",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>							
								<cfelseif listfind("120",get_stocks_all_in.process_type,",")>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_cost_expense&id=#get_stocks_all_in.upd_id#','list');" class="tableyazi">#get_process_name(get_stocks_all_in.process_type)#</a>														
								<cfelse>
									#get_process_name(get_stocks_all_in.process_type)#
								</cfif>
							</cfif>
						</td>
						<td style="text-align:right;">#tlformat(get_row_amount.amount,4)#</td>
						<td style="text-align:right;">#tlformat(GET_ROWS_A.cost_price,4)#</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
                        <td></td>
					</tr>	
				</cfif>
			</cfoutput>
		<cfelse>
			<tr><td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>	
		</cfif>
	</tbody>
</cf_medium_list>
