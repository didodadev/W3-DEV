<cf_date tarih="attributes.action_date1">
<cf_date tarih="attributes.action_date2">
<cfif len(attributes.due_date1)>
	<cf_date tarih="attributes.due_date1">
</cfif>
<cfif len(attributes.due_date2)>
	<cf_date tarih="attributes.due_date2">
</cfif>
<cfif is_action_date eq 1>
	<cf_date tarih="attributes.action_date">
</cfif>
<cfinclude template="../query/get_due_diff_actions.cfm">

<cfparam name="attributes.page" default="1">	
<cfparam name="attributes.totalrecords" default="#get_actions.recordcount#">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif len(session.ep.money2)>
	<cfquery name="GET_MONEY" dbtype="query">
		SELECT 
			* 
		 FROM 
		 	GET_MONEY_RATE 
		WHERE 
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
	</cfquery>
	<cfif is_action_date eq 1>
		<cfquery name="GET_MONEY_HIST" datasource="#DSN#" maxrows="1">
			SELECT
				<cfif xml_money_type eq 1>
					ISNULL(RATE3,RATE2) RATE2_
				<cfelseif xml_money_type eq 3>
					ISNULL(EFFECTIVE_PUR,RATE2) RATE2_
				<cfelseif xml_money_type eq 4>
					ISNULL(EFFECTIVE_SALE,RATE2) RATE2_
				<cfelse>
					RATE2 RATE2_
				</cfif>
			FROM 
				MONEY_HISTORY
			WHERE 
				VALIDATE_DATE <= #CreateODBCDate(attributes.action_date)#
				AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
			ORDER BY 
				MONEY_HISTORY_ID DESC
		</cfquery>
	</cfif>
	<cfif isdefined("get_money_hist") and get_money_hist.recordcount>
		<cfset rate_money_2 = get_money_hist.rate2_>
	<cfelse>
		<cfset rate_money_2 = get_money.rate2_>
	</cfif>
</cfif>
<cf_grid_list>
	<thead>
		<tr>
			<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
			<th><cf_get_lang dictionary_id="57789.Özel Kod"></th>
			<th><cf_get_lang dictionary_id ='57558.Üye No'></th>
			<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
			<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
			<th><cf_get_lang dictionary_id ='58759.Fatura Tarihi'></th>
			<th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
			<th><cf_get_lang dictionary_id="50041.Gecikme Günü"></th>
			<th>V.F.U.</th>
			<th>V.F.U. <cf_get_lang dictionary_id='59541.Tarihi'></th>
			<th>V.F.U. <cf_get_lang dictionary_id='50041.Gecikme Günü'></th>
			<th><cf_get_lang dictionary_id='50001.Açık Fatura'></th>
			<th><cf_get_lang dictionary_id='50000.Hesaplanan Vade Farkı'></th>
			<th width="20"><input type="checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view();"></th>
		</tr>
	</thead>
	<tbody>
	<cfif is_action_date eq 1>	
		<cfset kontrol_date_now = attributes.action_date>
	<cfelseif len(attributes.action_date2)>
		<cfset kontrol_date_now = attributes.action_date2>
	<cfelse>
		<cfset kontrol_date_now = now()>
	</cfif>
	<input type="hidden" name="all_records" id="all_records" value="<cfoutput>#get_actions.recordcount#</cfoutput>">
	<cfset total_amount = 0>
	<cfif get_actions.recordcount>
		<cfoutput query="get_actions">
			<cfif isdefined("due_day_info") and len(due_day_info)>
				<cfif invoice_date eq main_invoice_date>
					<cfset due_date_info = date_add('d',due_day_info,invoice_date)>
				<cfelse>
					<cfset due_date_info = invoice_date>
				</cfif>
			<cfelse>
				<cfset due_date_info = due_date>
			</cfif>
			<cfset kontrol_date=''>
			<cfloop from="0" to="7" index="kk">
				<cfset date_1 = date_add('d',kk,due_date_info)>
				<cfquery name="GET_GENERAL_OFFTIMES" datasource="#DSN#">
					SELECT 
						OFFTIME_ID
					FROM 
						SETUP_GENERAL_OFFTIMES
					WHERE 
						START_DATE <= #createodbcdatetime(date_1)#
						AND FINISH_DATE >= #createodbcdatetime(date_1)#
				</cfquery>
				<cfset day_value = dayofweek(date_1)>
				<cfif get_general_offtimes.recordcount eq 0 and day_value neq 1 and day_value neq 7>
					<cfset kontrol_date = date_1>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif len(kontrol_date) and datediff('d',kontrol_date,kontrol_date_now) gt 0>
				<cfset count_row = count_row + 1>
				<cfset control_amount = OTHER_MONEY_VALUE*((due_date_rate*(datediff('d',kontrol_date,kontrol_date_now))/30)/100)>
				<cfif len(session.ep.money2)>
					<cfset control_amount_2 = control_amount/rate_money_2>
				</cfif>
				<input type="hidden" name="cari_action_id_#currentrow#" id="cari_action_id_#currentrow#" value="#cari_action_id#">
				<input type="hidden" name="subscription_id_#currentrow#" id="subscription_id_#currentrow#" value="#subscription_id#">
				<input type="hidden" name="period_id_#currentrow#" id="period_id_#currentrow#" value="#session.ep.period_id#">
				<cfif attributes.member_action_type eq 1>
					<input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#member_id#">
				<cfelse>
					<input type="hidden" name="consumer_id_#currentrow#" id="consumer_id_#currentrow#" value="#member_id#">
				</cfif>
				<input type="hidden" name="invoice_id_#currentrow#" id="invoice_id_#currentrow#" value="#invoice_id#">
				<input type="hidden" name="invoice_date_#currentrow#" id="invoice_date_#currentrow#" value="#dateformat(invoice_date,dateformat_style)#">
				<input type="hidden" name="invoice_number_#currentrow#" id="invoice_number_#currentrow#" value="#invoice_number#">
				<input type="hidden" name="control_amount_#currentrow#" id="control_amount_#currentrow#" value="#wrk_round(control_amount,4)#">
				<input type="hidden" name="act_value_#currentrow#" id="act_value_#currentrow#" value="#nettotal#">
				<cfset total_amount = total_amount + nettotal>
				<cfif currentrow lte session.ep.maxrows>
					<tr>
						<td>#currentrow#</td>
						<td>#ozel_kod#</td>
						<td>#member_code#</td>
						<td>
							<cfif type eq 1>
								<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','medium');">#fullname#</a>
							<cfelse>
								<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','medium');">#fullname#</a>							
							</cfif>
						</td>
						<td>#invoice_number#</td>
						<td>#dateformat(main_invoice_date,dateformat_style)#</td>
						<td>#dateformat(due_date_info,dateformat_style)#</td>
						<td style="text-align:right;">#datediff('d',kontrol_date,kontrol_date_now)#</td>
						<cfquery name="get_control_records" datasource="#dsn2#">
							SELECT 
								CD.ACTION_DATE
							FROM
								CARI_DUE_DIFF_ACTIONS CD JOIN 
								CARI_DUE_DIFF_ACTIONS_ROW CDR ON CDR.DUE_DIFF_ID = CD.DUE_DIFF_ID
							WHERE 
								CDR.INVOICE_ID = #INVOICE_ID#
						</cfquery>
						<td style="text-align:center">
							<cfif get_control_records.recordcount>
								<i class="fa fa-check" style="color:green; font-size:20px"></i>
							</cfif>
						</td>
						<td style="text-align:center;"><cfif get_control_records.recordcount>#dateformat(get_control_records.ACTION_DATE,dateformat_style)#</cfif></td>
						<td style="text-align:right;"><cfif get_control_records.recordcount>#datediff('d',get_control_records.ACTION_DATE,now())#<cfelse>#datediff('d',kontrol_date,kontrol_date_now)#</cfif></td>
						<td style="text-align:right;"><!---#tlformat(nettotal)# #session.ep.money#---> #tlformat(OTHER_MONEY_VALUE)# #OTHER_MONEY# </td>
						<td style="text-align:right;">#tlformat(control_amount,4)# #OTHER_MONEY#
						<input type="hidden" name="control_amount_2_#currentrow#" value="#tlformat(control_amount_2,4)#">
						</td>						
						<td style="text-align:center">
							<input type="checkbox" class="checkControl" total_value="#OTHER_MONEY_VALUE#" money_type="<cfif len(other_money)>#other_money#<cfelse>TL</cfif>" name="is_pay_#currentrow#" id="is_pay_#currentrow#" value="#invoice_id#"  onclick="check_kontrol(this);">
						</td>
					</tr>
				<cfelse>
					<input type="hidden" name="control_amount_2_#currentrow#" value="#tlformat(control_amount_2,4)#" class="box" readonly style="width:100px;">
					<cfif control_amount gt 0>
						<input type="hidden" name="is_pay_#currentrow#" id="is_pay_#currentrow#" value="1" class="box">
					</cfif>
				</cfif>
			</cfif>
		</cfoutput>
	</cfif>
	<cfif count_row eq 0>
		<tr>
			<td colspan="15"><cf_get_lang dictionary_id ='57484.Kayıt Yok'> !</td>
		</tr>
	</cfif>
	</tbody>
</cf_grid_list>
