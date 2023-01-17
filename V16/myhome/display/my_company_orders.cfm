<cf_xml_page_edit default_value="1" fuseact="myhome.my_company_details">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.cid" default="">
<cfparam name="attributes.cpid" default="">
<cfquery name="GET_ORDER_LIST" datasource="#DSN3#" maxrows="#attributes.maxrows#">
	SELECT
		(SELECT TOP 1 C.CAMP_HEAD FROM CAMPAIGNS C WHERE C.CAMP_STARTDATE <= ORDERS.ORDER_DATE AND C.CAMP_FINISHDATE >= ORDERS.ORDER_DATE) CAMP_HEAD,
		ORDER_NUMBER,
		ORDER_STAGE,
		IS_PROCESSED,
		ORDER_HEAD,
		ORDER_STATUS,
		NETTOTAL,
		ORDER_DATE,
		ORDER_ID,
		OTHER_MONEY,
		OTHER_MONEY_VALUE
		<cfif is_gecen_gun eq 1>
		,(SELECT TOP 1 I.ORDER_ID FROM #dsn2_alias#.INVOICE I WHERE I.ORDER_ID = ORDERS.ORDER_ID) INV_ORDER_ID
		</cfif>
	FROM 
		ORDERS
	WHERE
		(
			(ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0) OR
			(ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1)
		)
		AND 
		(
			IS_INSTALMENT = 0 OR
			IS_INSTALMENT IS NULL
		)
	<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
		AND 
		(
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
			COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
		)
	</cfif>
	<cfif isdefined("attributes.order_number") and len(attributes.order_number)>
		AND 
		(
			ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_number#"> OR
			ORDER_ID IN (SELECT ORR.ORDER_ID FROM ORDER_ROW ORR,PRODUCT P WHERE ORR.ORDER_ID = ORDERS.ORDER_ID AND ORR.PRODUCT_ID = P.PRODUCT_ID AND (P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.order_number#%"> OR P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.order_number#%">))
		)
	</cfif>
	ORDER BY
		ORDER_DATE DESC
</cfquery>
<cfquery name="GET_ORDER_LIST2" datasource="#DSN3#" maxrows="#attributes.maxrows#">
	SELECT 
		ORDER_NUMBER,
		ORDER_STAGE,
		IS_PROCESSED,
		ORDER_HEAD,
		ORDER_STATUS,	
		NETTOTAL,
		ORDER_DATE,
		ORDER_ID,
		OTHER_MONEY,
		OTHER_MONEY_VALUE
	FROM 
		ORDERS
	WHERE
		PURCHASE_SALES = 0 AND 
		ORDER_ZONE = 0
	<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
		AND 
		(
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
			COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
		)
	</cfif>
	<cfif isdefined("attributes.order_number") and len(attributes.order_number)>
		AND 
		(
			ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_number#"> OR
			ORDER_ID IN(SELECT ORR.ORDER_ID FROM ORDER_ROW ORR,PRODUCT P WHERE ORR.ORDER_ID = ORDERS.ORDER_ID AND ORR.PRODUCT_ID = P.PRODUCT_ID AND (P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.order_number#%"> OR P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.order_number#%">))
		)
	</cfif>
	ORDER BY
		ORDER_DATE DESC
</cfquery>
<cfform>
	<cf_box_search>
		<div class="form-group">
			<cf_get_lang dictionary_id='58211.Siparis No'>/<cf_get_lang dictionary_id='58800.Ürün Kodu'> <input type="text" name="order_number" id="order_number" value="<cfif isdefined('attributes.order_number')><cfoutput>#attributes.order_number#</cfoutput></cfif>" onKeyPress="if(event.keyCode==13) {connectAjax_order(); return false;}">
		</div>
		<div class="form-group">
			<cf_wrk_search_button button_type="4" search_function="connectAjax_order()">
		</div>
	</cf_box_search>
</cfform>

	<cf_seperator title="#getLang('','Satış','57448')#" id="item_sale">
	<div id="item_sale">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<cfif is_gecen_gun eq 1>
					<th style="text-align:center"><cf_get_lang dictionary_id='29986.Geçen Gün'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='58054.Süreç Aşama'></th>
					<cfif get_order_list.is_processed eq 1><th><cf_get_lang dictionary_id='57771.Detay'></th></cfif>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='31382.Döviz Tutar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57756.Durum'></th>
				</tr>
			</thead>
			<tbody>
				<cfset colspan_ = 7>
				<cfif get_order_list.recordcount>
					<cfset process_list = "">
					<cfset orders_id_list = "">
					<cfoutput query="get_order_list" startrow="1" maxrows="#attributes.maxrows#">
						<cfif len(order_stage) and not listfind(process_list,order_stage)>
							<cfset process_list=listappend(process_list,order_stage)>
						</cfif>
						<cfif len(order_id) and(is_processed eq 1) and not listfind(orders_id_list,order_id)>
							<cfset orders_id_list =listappend(orders_id_list,order_id)>
						</cfif>
					</cfoutput>
					<cfif len(process_list)>
						<cfquery name="GET_PROCESS_NAME" datasource="#DSN#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset process_list = listsort(listdeleteduplicates(valuelist(get_process_name.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(orders_id_list)>
						<!--- Siparisten irsaliyeye ve direkt faturaya cekilenleri bulduk. --->
						<cfquery name="GET_ORDERS_SHIP_AND_INVOICE" datasource="#DSN3#">
							SELECT 'irsaliye' TYPE,ORDER_ID,SHIP_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (#orders_id_list#) 
							UNION ALL
							SELECT 'fatura' TYPE,ORDER_ID,0 AS SHIP_ID FROM ORDERS_INVOICE  WHERE ORDER_ID IN (#orders_id_list#) 
							<!--- Period Eklerseniz bir önceki dönemin şipariş bilgileri gelmez eklemeyiniz please..M.ER 20 01 2009 --->
						</cfquery>
						<cfset ship_id_list = listdeleteduplicates(ValueList(get_orders_ship_and_invoice.ship_id,','))>
						<cfif len(ship_id_list)>
							<cfquery name="ALL_GET_SHIP_INVOICE" datasource="#DSN2#">
								SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN(#ship_id_list#)
							</cfquery>
							<cfquery name="CONTROL_SHIP_RESULT" datasource="#DSN2#"><!--- siparisin baglı oldugu irsaliyelerin sevkiyatlari kontrol ediliyor --->
								SELECT 
									SR.SHIP_FIS_NO,
									SR.SHIP_RESULT_ID
								FROM
									SHIP_RESULT SR,
									SHIP_RESULT_ROW SR_ROW 
								WHERE 
									SR.SHIP_RESULT_ID = SR_ROW.SHIP_RESULT_ID AND
									SR.IS_TYPE IS NULL AND
									SR_ROW.SHIP_ID IN (#ship_id_list#)
							</cfquery>
						</cfif>
						<cfif get_orders_ship_and_invoice.recordcount>
							<cfscript>
								order_and_ship_list ='';
								for(oi=1;oi lte get_orders_ship_and_invoice.recordcount;oi=oi+1){
									'order_info_#get_orders_ship_and_invoice.order_id[oi]#_#get_orders_ship_and_invoice.type[oi]#' = 1;
									if(get_orders_ship_and_invoice.ship_id[oi] gt 0){
										order_and_ship_list = ListAppend(order_and_ship_list,get_orders_ship_and_invoice.order_id[oi],',');
										order_and_ship_list = ListAppend(order_and_ship_list,get_orders_ship_and_invoice.ship_id[oi],'█');
									}	
								}
							</cfscript>
							<cfif len(order_and_ship_list) and len(ship_id_list)>
								<cfloop list="#order_and_ship_list#" delimiters="," index="sh_or">
									<cfquery name="GET_SHIP_INVOICE" dbtype="query">
										SELECT SHIP_ID FROM ALL_GET_SHIP_INVOICE WHERE SHIP_ID = #ListGetAt(sh_or,2,'█')#
									</cfquery>
									<cfif get_ship_invoice.recordcount><cfset 'order_info_#ListGetAt(sh_or,1,'█')#_fatura' = 1></cfif>
								</cfloop>
							</cfif>
						</cfif>
					</cfif>
					<cfoutput query="get_order_list" startrow="1" maxrows="#attributes.maxrows#">
						<tr>
							<td width="55">#order_number#</td>
							<td width="60">#dateformat(order_date,dateformat_style)#</td>
							<cfif is_gecen_gun eq 1>
								<td style="text-align:center"><cfif len(get_order_list.inv_order_id)>0<cfelseif len(order_date)>#datediff('d',order_date,now())#</cfif>
									<cfset colspan_ = colspan_ + 1>
								</td>
							</cfif>
							<td><cfif len(order_stage)>#get_process_name.stage[listfind(process_list,order_stage,',')]#</cfif></td>
							<td>
								<cfif is_processed eq 1>
									<font color="FF0000">
									<cfif isdefined('order_info_#order_id#_irsaliye')><cf_get_lang dictionary_id='57893.İrsaliye Kesildi'><br/></cfif>
									<cfif isdefined('order_info_#order_id#_fatura')><cf_get_lang dictionary_id='30878.Faturalandı'><br/></cfif>
									<cfif isdefined("control_ship_result") and control_ship_result.recordcount><cf_get_lang dictionary_id='30879.Sevkedildi'></cfif>
									</font>
								</cfif>
								<cfif session.ep.menu_id neq 0 and isdefined("attributes.is_fast_display")><!--- Dore için eklendi menü kullanılıyorsa ve call center ekranından hızlı güncelleme seçiliyse objects2 sipariş detayına gidiyor --->
									<a href="#request.self#?fuseaction=objects2.order_detail&order_id=#order_id#" class="tableyazi">#order_head#</a> (#camp_head#)
								<cfelse>
									
										<cfif get_module_user(11) or get_module_user(32)>
											<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" class="tableyazi">#order_head#</a>
										<cfelse>
											#order_head#
										</cfif>
									
								</cfif>
							</td>
						
							<td width="100" style="text-align:right;"><cfif len(nettotal)>#TlFormat(nettotal)#&nbsp;#session.ep.money#</cfif></td>
							<td width="100" style="text-align:right;"><cfif other_money neq '#session.ep.money#'>#TlFormat(other_money_value)#&nbsp;#other_money#</cfif></td>
							<td style="text-align:right;"><cfif order_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelseif order_status eq 0><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>	
	
	<cf_seperator title="#getLang('','Satın alma','57449')#" id="item_satinalma">
	<div id="item_satinalma">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<cfif is_gecen_gun eq 1>
					<th style="text-align:center"><cf_get_lang dictionary_id='29986.Geçen Gün'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='58054.Süreç Aşama'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='31382.Döviz Tutar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57756.Durum'></th>
				</tr>
			</thead>
			<tbody >
				<cfif get_order_list2.recordcount>
					<cfset process_list_2 = "">
					<cfoutput query="get_order_list2" startrow="1" maxrows="#attributes.maxrows#">
						<cfif len(order_stage) and not listfind(process_list_2,order_stage)>
							<cfset process_list_2=listappend(process_list_2,order_stage)>
						</cfif>
					</cfoutput>
					<cfif len(process_list_2)>
					<cfset process_list_2 = listsort(process_list_2,"numeric","ASC",",")>
						<cfquery name="GET_PROCESS_NAME_2" datasource="#DSN#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list_2#) ORDER BY PROCESS_ROW_ID
						</cfquery>
					</cfif>
					<cfoutput query="get_order_list2" startrow="1" maxrows="#attributes.maxrows#">
						<tr>
							<td width="55">#order_number#</td>
							<td width="60">#dateformat(order_date,dateformat_style)#</td>
							<cfif is_gecen_gun eq 1>
								<td><cfset colspan_ = colspan_ + 1></td>
							</cfif>
							<td><cfif len(order_stage)>#get_process_name_2.stage[listfind(process_list_2,order_stage,',')]#</cfif></td>
							<td><a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" class="tableyazi">#order_head#</a></td>
							<td width="100" style="text-align:right;">#TlFormat(nettotal)#&nbsp;#session.ep.money#</td>
							<td width="100" style="text-align:right;"><cfif other_money neq '#session.ep.money#'>#TlFormat(other_money_value)#&nbsp;#other_money#</cfif></td>
							<td style="text-align:right;"><cfif order_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelseif order_status eq 0><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

	</div>
<script type="text/javascript">
function connectAjax_order()
{	
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.popupajax_my_company_orders&order_number='+document.getElementById('order_number').value+'<cfif len(attributes.cid)>&cid=#attributes.cid#</cfif><cfif len(attributes.cpid)>&cpid=#attributes.cpid#</cfif><cfif isdefined("attributes.is_fast_display") and len(attributes.is_fast_display)>&is_fast_display=#attributes.is_fast_display#</cfif>&maxrows=#attributes.maxrows#</cfoutput>','body_cons_orders',1);
}
</script>
