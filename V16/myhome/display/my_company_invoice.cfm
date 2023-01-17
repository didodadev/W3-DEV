<cfsetting showdebugoutput="no">
<cfparam name="attributes.cid" default="">
<cfparam name="attributes.cpid" default="">
<cfif len(attributes.cid)>
	<cfset body_div_ = "body_cons_invoices">
<cfelseif len(attributes.cpid)>
	<cfset body_div_ = "body_box_bill">
</cfif>
<cfquery name="GET_INVOICE_LIST" datasource="#dsn2#">
	SELECT 
		COMPANY_ID,
		CONSUMER_ID,
		(SELECT TOP 1 C.CAMP_HEAD FROM #dsn3_alias#.CAMPAIGNS C WHERE C.CAMP_STARTDATE <= INVOICE.INVOICE_DATE AND C.CAMP_FINISHDATE >= INVOICE.INVOICE_DATE) CAMP_HEAD,
		INVOICE_NUMBER,
		PRINT_COUNT,
		NETTOTAL,
		OTHER_MONEY_VALUE,
		OTHER_MONEY,
		INVOICE_DATE,
		INVOICE_CAT,
		INVOICE_ID,
		PURCHASE_SALES
	FROM 
		INVOICE
	WHERE
		PURCHASE_SALES =1
		AND IS_IPTAL = 0
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
			AND 
			(
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		</cfif>
		<cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
			AND INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invoice_number#%">
		</cfif>
		<cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
			AND 
			(
				INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invoice_number#%"> OR
				INVOICE_ID IN(SELECT ORR.INVOICE_ID FROM INVOICE_ROW ORR,#dsn3_alias#.PRODUCT P WHERE ORR.INVOICE_ID = INVOICE.INVOICE_ID AND ORR.PRODUCT_ID = P.PRODUCT_ID AND (P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invoice_number#%"> OR P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invoice_number#%">))
			)
		</cfif>
	ORDER BY
		INVOICE_DATE DESC
</cfquery>
<cfquery name="GET_INVOICE_LIST2" datasource="#dsn2#">
	SELECT 
		COMPANY_ID,
		CONSUMER_ID,
		INVOICE_NUMBER,
		PRINT_COUNT,
		NETTOTAL,
		OTHER_MONEY_VALUE,
		OTHER_MONEY,
		INVOICE_DATE,
		INVOICE_CAT,
		INVOICE_ID,
		PURCHASE_SALES
	FROM 
		INVOICE
	WHERE
		PURCHASE_SALES = 0 AND
		IS_IPTAL = 0
		<cfif isdefined ("attributes.cpid") and len(attributes.cpid)>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		<cfelseif isdefined ("attributes.cid") and len(attributes.cid)>
			AND 
			(
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> OR
				COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE RELATED_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			)
		</cfif>
		<cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
			AND INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_number#">
		</cfif>
	ORDER BY
		INVOICE_DATE DESC
</cfquery>
	<cfform>
		<cf_box_search>
			<div class="form-group">
				<cf_get_lang dictionary_id='58133.Fatura No'>/<cf_get_lang dictionary_id='58800.Ürün Kodu'> <input type="text" name="invoice_number" id="invoice_number" value="<cfif isdefined("attributes.invoice_number")><cfoutput>#attributes.invoice_number#</cfoutput></cfif>" style="width:100px;">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="connectAjax_invoice()">
			</div>
		</cf_box_search>
	</cfform>

	<cf_seperator title="#getLang('','Satış Faturaları','31965')#" id="satis_fatura">
	<div id="satis_fatura">
		<cf_ajax_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='30882.Print Sayısı'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='31382.Döviz Tutar'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_invoice_list.recordcount>
					<cfset company_id_list = "">
					<cfset consumer_id_list = "">
					<cfoutput query="get_invoice_list" maxrows="#attributes.maxrows#" startrow="1">
						<cfif Len(company_id) and not ListFind(company_id_list,company_id,',')>
							<cfset company_id_list = ListAppend(company_id_list,company_id,',')>
						</cfif>
						<cfif Len(consumer_id) and not ListFind(consumer_id_list,consumer_id,',')>
							<cfset consumer_id_list = ListAppend(consumer_id_list,consumer_id,',')>
						</cfif>
					</cfoutput>
					<cfif ListLen(company_id_list)>
						<cfquery name="get_company_info" datasource="#dsn#">
							SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_company_info.Company_id,",")),"numeric","asc",",")>
					</cfif>
					<cfif ListLen(consumer_id_list)>
						<cfquery name="get_consumer_info" datasource="#dsn#">
							SELECT CONSUMER_ID,CONSUMER_NAME + ' ' + CONSUMER_SURNAME NICKNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_info.consumer_id,",")),"numeric","asc",",")>
					</cfif>
					<cfoutput query="get_invoice_list" maxrows="#attributes.maxrows#" startrow="1">
						<tr>
							<td width="55">#currentrow#</td>
							<td><cfif purchase_sales eq 1>
									<cfif invoice_cat eq 52>
										<a href="#request.self#?fuseaction=invoice.add_bill_retail&event=upd&iid=#invoice_id#" class="tableyazi">#invoice_number#</a>
									<cfelseif invoice_cat eq 66>
										<a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#invoice_id#" class="tableyazi">#invoice_number#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#invoice_id#" class="tableyazi">#invoice_number#</a>
									</cfif>
								</cfif>				
								<cfif isdefined("attributes.is_fast_display")>
									(#camp_head#)
								</cfif>
							</td>
							<td>#get_process_name(invoice_cat)#</td>
							<td><cfif Len(company_id)>#get_company_info.nickname[ListFind(company_id_list,company_id,',')]#<cfelseif Len(consumer_id)>#get_consumer_info.nickname[ListFind(consumer_id_list,consumer_id,',')]#</cfif></td>
							<td width="70" align="center">#print_count#</td>
							<td width="60">#dateformat(invoice_date,dateformat_style)#</td>
							<td width="100" style="text-align:right;">#TlFormat(nettotal)#&nbsp;#session.ep.money#</td>
							<td width="100" style="text-align:right;">#TlFormat(other_money_value)#&nbsp;#other_money#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_ajax_list>
	</div>

	<cf_seperator title="#getLang('','Alış Faturaları','31966')#" id="alis_fatura">
	<div id="alis_fatura">
		<cf_ajax_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='30882.Print Sayısı'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='31382.Döviz Tutar'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_invoice_list2.recordcount>
					<cfset company_id_list = "">
					<cfset consumer_id_list = "">
					<cfoutput query="get_invoice_list2" maxrows="#attributes.maxrows#" startrow="1">
						<cfif Len(company_id) and not ListFind(company_id_list,company_id,',')>
							<cfset company_id_list = ListAppend(company_id_list,company_id,',')>
						</cfif>
						<cfif Len(consumer_id) and not ListFind(consumer_id_list,consumer_id,',')>
							<cfset consumer_id_list = ListAppend(consumer_id_list,consumer_id,',')>
						</cfif>
					</cfoutput>
				<cfif ListLen(company_id_list)>
					<cfquery name="get_company_info" datasource="#dsn#">
						SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
					</cfquery>
					<cfset company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_company_info.Company_id,",")),"numeric","asc",",")>
				</cfif>
				<cfif ListLen(consumer_id_list)>
					<cfquery name="get_consumer_info" datasource="#dsn#">
						SELECT CONSUMER_ID,CONSUMER_NAME + ' ' + CONSUMER_SURNAME NICKNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
					</cfquery>
					<cfset consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_info.consumer_id,",")),"numeric","asc",",")>
				</cfif>
				<cfoutput query="get_invoice_list2" startrow="1" maxrows="#attributes.maxrows#">
					<tr>
						<td width="55">#currentrow#</td>
						<td>
							<cfif invoice_cat eq 65>
								<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#invoice_id#" class="tableyazi">#INVOICE_NUMBER#</a>
							<cfelse>
								<cfif not get_module_user(20)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_invoice&period_id=#session.ep.period_id#&ID=#invoice_id#','medium','popup_detail_invoice');" class="tableyazi">#INVOICE_NUMBER#</a>
								<cfelse>
									<a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#invoice_id#" class="tableyazi">#INVOICE_NUMBER#</a>
								</cfif>
							</cfif>
						</td>
						<td>#get_process_name(invoice_cat)#</td>
						<td><cfif Len(company_id)>#get_company_info.nickname[ListFind(company_id_list,company_id,',')]#<cfelseif Len(consumer_id)>#get_consumer_info.nickname[ListFind(consumer_id_list,consumer_id,',')]#</cfif></td>
						<td width="70" align="center">#print_count#</td>
						<td width="60">#dateformat(invoice_date,dateformat_style)#</td>
						<td width="100" style="text-align:right;">#TlFormat(nettotal)#&nbsp;#session.ep.money#</td>
						<td width="100" style="text-align:right;">#TlFormat(other_money_value)#&nbsp;#other_money#</td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
   			 </tbody>
		</cf_ajax_list>
	</div>

<script type="text/javascript">
	
	function connectAjax_invoice()
	{	
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.popupajax_my_company_invoice&invoice_number='+document.getElementById('invoice_number').value+'<cfif len(attributes.cid)>&cid=#attributes.cid#</cfif><cfif len(attributes.cpid)>&cpid=#attributes.cpid#</cfif>&maxrows=#attributes.maxrows#</cfoutput><cfif isdefined("attributes.is_fast_display") and len(attributes.is_fast_display)>&is_fast_display=#attributes.is_fast_display#</cfif>','<cfoutput>#body_div_#</cfoutput>',1);
	}
</script>	
