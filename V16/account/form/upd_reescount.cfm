<!--- Reeskont Islemleri --->
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_reescount" datasource="#dsn2#">
	SELECT 
		ACTION_DATE,
		DUE_DATE,
		DETAIL,
		PROCESS_CAT,
		RECORD_DATE,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_EMP
	FROM 
		REESCOUNT
	WHERE 
		REESCOUNT_ID = #attributes.reescount_id# 
</cfquery>
<cfquery name="get_reescount_rows" datasource="#dsn2#">
	SELECT 
		V.VOUCHER_NO,
		C.CHEQUE_NO,
		RR.VOUCHER_ID,
		RR.CHEQUE_ID,
		RR.NET_VALUE,
		RR.REESCOUNT_VALUE,
		RR.CURRENCY_ID,
		RR.CHEQ_VOUCHER_DUE_DATE,
		RR.DUEDATE_DIFF
	FROM 
		REESCOUNT_ROWS RR
        LEFT JOIN CHEQUE C ON RR.CHEQUE_ID = C.CHEQUE_ID
        LEFT JOIN VOUCHER V ON RR.VOUCHER_ID = V.VOUCHER_ID
	WHERE 
		REESCOUNT_ID = #attributes.reescount_id# 
</cfquery>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="upd_reescount" id="upd_reescount" method="post" action="#request.self#?fuseaction=account.list_reescount&event=upd">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
						<label class="col col-8 col-xs-12">: <cfoutput>#dateformat(get_reescount.action_date,dateformat_style)#</cfoutput></label>
					</div>
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
						<label class="col col-8 col-xs-12">: <cfoutput>#dateformat(get_reescount.due_date,dateformat_style)#</cfoutput></label>
					</div>
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<label class="col col-8 col-xs-12">: <cfoutput>#get_reescount.detail#</cfoutput></label>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6"><cf_record_info query_name="get_reescount"></div>
				<div class="col col-6">
					<cf_workcube_buttons type_format='1' 
					is_upd='1' 
					is_insert='0' 
					delete_page_url = '#request.self#?fuseaction=account.emptypopup_del_reescount&reescount_id=#attributes.reescount_id#'>	
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Reeskont Tablosu',60886)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58007.Cek'>/<cf_get_lang dictionary_id='58008.Senet'><cf_get_lang dictionary_id='57487.No'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>	  
					<th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
					<th><cf_get_lang dictionary_id='57640.Vade'>/<cf_get_lang dictionary_id='57490.Gun'></th>
					<th class="text-right"><cf_get_lang dictionary_id='50221.Reeskont Tutarı'></th>
					<th class="text-right"><cf_get_lang dictionary_id='50224.İndirgenmiş Değer'></th>
				</tr>
			</thead>
			<tbody>
				<cfscript>
					total_net = 0;
					total_reescount = 0;
					total_discount = 0;
				</cfscript>
				<cfoutput query="get_reescount_rows">
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif len(voucher_id)>
								<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=cheque.popup_view_voucher_detail&id=#voucher_id#','horizantal');" class="tableyazi">#voucher_no#</a>
							<cfelse>
								<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&id=#cheque_id#','horizantal');" class="tableyazi">#cheque_no#</a>
							</cfif>
						</td>
						<td class="text-right">#tlFormat(net_value,2)#</td>
						<td>#currency_id#</td>
						<td>#dateFormat(cheq_voucher_due_date,dateformat_style)#</td>
						<td>#duedate_diff#</td>
						<td class="text-right">#tlFormat(reescount_value,2)#</td>
						<td class="text-right">#tlFormat(net_value-reescount_value,2)#</td>
					</tr>
					<cfscript>
						total_net += net_value;
						total_reescount += reescount_value;
						total_discount += net_value-reescount_value;
					</cfscript>
				</cfoutput>
			</tbody>
			<tfoot>
				<cfoutput>
					<tr>
						<td></td>
						<td class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
						<td class="text-right">#tlformat(total_net)#</td>
						<td class="txtbold">#get_reescount_rows.currency_id#</td>
						<td></td>
						<td></td>
						<td class="text-right">#tlformat(total_reescount)#</td>
						<td class="text-right">#tlformat(total_discount)#</td>
					</tr>
				</cfoutput>
			</tfoot>
		</cf_grid_list>
	</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
