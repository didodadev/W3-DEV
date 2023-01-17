<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="cheque.popup_selct_voucher">
<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.voucher_company" default="">
<cfparam name="attributes.voucher_employee_id" default="">
<cfparam name="attributes.voucher_company_id" default="">
<cfparam name="attributes.voucher_consumer_id" default="">
<cfinclude template="../query/get_sel_vouchers.cfm">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default=""> 
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_VOUCHERS.recordcount#">
<cfquery name="check_our_company" datasource="#dsn#">
	SELECT IS_REMAINING_AMOUNT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset control= "">
<cfif isdefined("attributes.entry_ret")>
	<cfset control = "#control#&entry_ret=1">
</cfif>
<cfif isdefined("attributes.endorsement")>
	<cfset control = "#control#&endorsement=1">
</cfif>
<cfif isdefined("attributes.is_return")>
	<cfset control = "#control#&is_return=1">
</cfif>
<cfif isdefined("attributes.endor_ret")>
	<cfset control = "#control#&endor_ret=1">
</cfif>
<cfif isdefined("attributes.out_control")>
	<cfset control = "#control#&out_control=1">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset control = "#control#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset control = "#control#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.employee_id")>
	<cfset control = "#control#&employee_id=#attributes.employee_id#">
</cfif>
<cfif isdefined("attributes.cash_id")>
	<cfset control = "#control#&cash_id=#attributes.cash_id#">
</cfif>
<cfif isdefined("attributes.to_cash_id")>
	<cfset control = "#control#&to_cash_id=#attributes.to_cash_id#">
</cfif>
<cfif isdefined("attributes.acc_id")>
	<cfset control = "#control#&acc_id=#attributes.acc_id#">
</cfif>
<cfif isdefined("attributes.cur_id")>
	<cfset control = "#control#&cur_id=#attributes.cur_id#">
</cfif>
<cfif isdefined("attributes.is_transfer")>
	<cfset control = "#control#&is_transfer=1">
</cfif>
<cfif isdefined("attributes.is_other_act")>
	<cfset control = "#control#&is_other_act=#attributes.is_other_act#">
</cfif>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','main',30092)#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="list_voucher_actions" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_selct_voucher&control=#control#" method="post">
				<cf_box_search>
					<div class ="form-group"> <cfinput type="text" placeholder="#getLang('','settings',57460)#" name="keyword" value="#attributes.keyword#"></div>
				<cfif isdefined("attributes.endorsement")>
					<input type="hidden" name="endorsement" id="endorsement" value="1">
					<div class ="form-group">
						<select name="self_" id="self_">
                            <option value="" ><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="1" <cfif isdefined("attributes.self_") and (attributes.self_ eq 1)>selected</cfif>><cf_get_lang dictionary_id='50073.Portföyde'></option>
                            <option value="2" <cfif isdefined("attributes.self_") and (attributes.self_ eq 2) >selected</cfif>><cf_get_lang dictionary_id='50254.Ödenmedi'></option>
						</select>
					</div>
				</cfif>
				<cfif isdefined("attributes.endor_ret")>
					<input type="hidden" name="endor_ret" id="endor_ret" value="1">
					<div class ="form-group">
						<select name="endor" id="endor">
                            <option value="" ><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="1" <cfif isdefined("attributes.endor") and (attributes.endor eq 1)>selected</cfif>><cf_get_lang dictionary_id='50073.Portföyde'></option>
                            <option value="2" <cfif isdefined("attributes.endor") and (attributes.endor eq 2) >selected</cfif>><cf_get_lang dictionary_id='50077.Protestolu'></option>
						</select>
					</div>
				</cfif>
				<div class ="form-group">
					<select name="sort_type" id="sort_type">
                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                        <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
					</select>
				</div>
				<div class ="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class ="form-group"><cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_voucher_actions' , #attributes.modal_id#)"),DE(""))#"></div>
				</cf_box_search>
				<cf_box_search_detail  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_voucher_actions' , #attributes.modal_id#)"),DE(""))#">
					<div class="col col-3 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-companyID">
						<div class="input-group">
						<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
						<input type="hidden" name="voucher_employee_id" id="voucher_employee_id" value="<cfif len(attributes.voucher_employee_id) and len(attributes.voucher_company)><cfoutput>#attributes.voucher_employee_id#</cfoutput></cfif>">
						<input type="hidden" name="voucher_company_id" id="voucher_company_id" value="<cfif len(attributes.voucher_company_id) and len(attributes.voucher_company)><cfoutput>#attributes.voucher_company_id#</cfoutput></cfif>">
						<input type="hidden" name="voucher_consumer_id" id="voucher_consumer_id" value="<cfif len(attributes.voucher_consumer_id) and len(attributes.voucher_company)><cfoutput>#attributes.voucher_consumer_id#</cfoutput></cfif>">
						<cf_wrk_members form_name='list_voucher_actions' member_name='voucher_company' consumer_id='voucher_consumer_id' company_id='voucher_company_id' employee_id='voucher_employee_id' member_type='member_type' select_list='1,2,3'>
						<input type="text" placeholder="<cfoutput>#getLang('','main',57519)#</cfoutput>" name="voucher_company" id="voucher_company" style="width:175px;" value="<cfif isDefined("attributes.voucher_company")><cfoutput>#attributes.voucher_company#</cfoutput></cfif>" onKeyUp="get_member();">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=list_voucher_actions.voucher_company&field_comp_id=list_voucher_actions.voucher_company_id&field_member_name=list_voucher_actions.voucher_company&field_name=list_voucher_actions.voucher_company&field_consumer=list_voucher_actions.voucher_consumer_id&field_emp_id=list_voucher_actions.voucher_employee_id&field_type=list_voucher_actions.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3</cfoutput>&keyword='+encodeURIComponent(document.list_voucher_actions.voucher_company.value),'list','popup_list_pars')"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" border="0" align="absmiddle"></a>
						</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
						<div class="form-group" id="item-companyID">
							<div class="input-group">
						<cfif isdate(attributes.start_date)>
							<cfset attributes.start_date=dateformat(attributes.start_date,dateformat_style)>
						<cfelse>
							<cfset attributes.start_date="">
						</cfif>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Baslama Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" placeholder="#getLang('','main',58053)#" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
						<span class="input-group-addon btnPointer">
						<cf_wrk_date_image date_field="start_date">
						</span>
						</div>
					</div>
				</div>
					<div class="col col-3 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
						<div class="form-group" id="item-companyID">
							<div class="input-group">
						<cfif isdate(attributes.finish_date)>
							<cfset attributes.finish_date=dateformat(attributes.finish_date,dateformat_style)>
						<cfelse>
							<cfset attributes.finish_date="">
						</cfif>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='50348.Filtre bitiş girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finish_date" placeholder="#getLang('','main',57700)#" value="#attributes.finish_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
						<span class="input-group-addon btnPointer">
						<cf_wrk_date_image date_field="finish_date">
						</span>
						</div>
					</div>
					</div>
			</cf_box_search_detail>
</cfform>
<cfset list=1>
<cfif get_vouchers.recordcount>
	<cfset company_id_list=''>
	<cfset consumer_id_list=''>
	<cfset employee_id_list=''>
	<cfset voucher_id_list = ''>
	<cfoutput query="get_vouchers" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(company_id) and not listfind(company_id_list,company_id)>
			<cfset company_id_list=listappend(company_id_list,company_id)>
		</cfif>
		<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
			<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
		</cfif>
		<cfif len(employee_id) and not listfind(employee_id_list,employee_id)>
			<cfset employee_id_list=listappend(employee_id_list,employee_id)>
		</cfif>
		<cfif len(voucher_id) and not listfind(voucher_id_list,voucher_id)>
			<cfset voucher_id_list=listappend(voucher_id_list,voucher_id)>
		</cfif>
	</cfoutput>
	<cfif len(company_id_list)>
		<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
		<cfquery name="get_company_name" datasource="#dsn#">
			SELECT COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
		</cfquery>
	</cfif>
	<cfif len(consumer_id_list)>
		<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
		<cfquery name="get_consumer_name" datasource="#dsn#">
			SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
		</cfquery>
	</cfif>
	<cfif len(employee_id_list)>
		<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
		<cfquery name="get_employee_name" datasource="#dsn#">
			SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
	</cfif>
	<cfif len(voucher_id_list)>
		<cfset voucher_id_list=listsort(voucher_id_list,"numeric","ASC",",")>
			<cfquery name="get_remaining_amount" datasource="#dsn2#">
				SELECT 
					VOUCHER_ID, 
					REMAINING_VALUE, 
					OTHER_REMAINING_VALUE, 
					OTHER_REMAINING_VALUE2 
				FROM 
					VOUCHER_REMAINING_AMOUNT 
				WHERE 
					VOUCHER_ID IN (#voucher_id_list#) ORDER BY VOUCHER_ID
			</cfquery>
		<cfset voucher_id_list = listsort(listdeleteduplicates(valuelist(get_remaining_amount.VOUCHER_ID,',')),'numeric','ASC',',')>
	</cfif>
<cfoutput query="GET_VOUCHERS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<cfform name="vouchers#currentrow#" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_voucher_session&control=#control#">
		<cfif check_our_company.is_remaining_amount eq 1>
			<cfset voucher_value_ = get_remaining_amount.REMAINING_VALUE[listfind(voucher_id_list,voucher_id,',')]>
			<cfset other_money_value_ = get_remaining_amount.OTHER_REMAINING_VALUE[listfind(voucher_id_list,voucher_id,',')]>
			<cfset other_money_value2_ = get_remaining_amount.OTHER_REMAINING_VALUE2[listfind(voucher_id_list,voucher_id,',')]>
		<cfelse>
			<cfset voucher_value_ = VOUCHER_VALUE>
			<cfset other_money_value_ = OTHER_MONEY_VALUE>
			<cfset other_money_value2_ = OTHER_MONEY_VALUE2>
		</cfif>
		<input type="hidden" name="voucher_id" id="voucher_id" value="#VOUCHER_ID#">
		<input type="hidden" name="is_pay_term" id="is_pay_term" value="#is_pay_term#">
		<input type="hidden" name="voucher_no" id="voucher_no" value="#VOUCHER_NO#">
		<input type="hidden" name="voucher_code" id="voucher_code" value="#VOUCHER_CODE#">
		<input type="hidden" name="portfoy_no" id="portfoy_no" value="#VOUCHER_PURSE_NO#">
		<input type="hidden" name="debtor_name" id="debtor_name" value="#DEBTOR_NAME#">
		<input type="hidden" name="voucher_city" id="voucher_city" value="#VOUCHER_CITY#">
		<input type="hidden" name="voucher_duedate" id="voucher_duedate" value="#dateformat(VOUCHER_DUEDATE,dateformat_style)#">
		<input type="hidden" name="voucher_value" id="voucher_value" value="#voucher_value_#">
		<input type="hidden" name="currency_id" id="currency_id" value="#CURRENCY_ID#">
		<input type="hidden" name="payroll_id" id="payroll_id" value="#VOUCHER_PAYROLL_ID#">
		<input type="hidden" name="voucher_status_id" id="voucher_status_id" value="#VOUCHER_STATUS_ID#">
		<input type="hidden" name="account_no" id="account_no" value="#ACCOUNT_NO#">
		<input type="hidden" name="self_voucher_" id="self_voucher_" value="#SELF_VOUCHER#">
		<input type="hidden" name="acc_code" id="acc_code" value="#ACCOUNT_CODE#">
		<input type="hidden" name="cash_id_row" id="cash_id_row" value="#CASH_ID#">
		<input type="hidden" name="bank_name" id="bank_name" value="">
		<input type="hidden" name="bank_branch_name" id="bank_branch_name" value="">
		<input type="hidden" name="tax_no" id="tax_no" value="">
		<input type="hidden" name="tax_place" id="tax_place" value="">
		<input type="Hidden" name="close_draggable" id="close_draggable" value="">
		<cfif VOUCHER_STATUS_ID eq 6>
			<input type="hidden" name="self_voucher_" id="self_voucher_" value="true">
		</cfif>
		<cfif isdefined("attributes.entry_ret")>
			<input type="hidden" name="entry_ret" id="entry_ret" value="1">
		</cfif>
		<input type="hidden" name="voucher_system_currency_value" id="voucher_system_currency_value" value="#OTHER_MONEY_VALUE_#">
		<input type="hidden" name="money_type" id="money_type" value="#OTHER_MONEY2#">
		<input type="hidden" name="voucher_other_money_value" id="voucher_other_money_value" value="#OTHER_MONEY_VALUE2_#">
	</cfform>
</cfoutput>
</cfif>
<cf_grid_list>
	<thead>
		<tr>
			<cfset colspan_ = 10>
			<th width="20"><input type="checkbox" name="allcheck" id="allcheck" onClick="wrk_select_all('allcheck','is_sec');"></th>
			<th><cf_get_lang dictionary_id='58182.Portfoy No'></th>
			<th><cf_get_lang dictionary_id='58502.Senet No'></th>
			<cfif x_project_info eq 1>
				<th><cf_get_lang dictionary_id='57416.Proje'></th>
				<cfset colspan_+=1>
			</cfif>
			<th width="110"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
			<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
			<th><cf_get_lang dictionary_id='58181.Ödeme Yeri'></th>
			<th><cf_get_lang dictionary_id='57640.Vade'></th>
			<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='35578.İşlem Para Br'></th>
			<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58177. Sistem Para Br'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_vouchers.recordcount>
			<cfoutput query="GET_VOUCHERS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif check_our_company.is_remaining_amount eq 1>
					<cfset voucher_value_ = get_remaining_amount.REMAINING_VALUE[listfind(voucher_id_list,voucher_id,',')]>
					<cfset other_money_value_ = get_remaining_amount.OTHER_REMAINING_VALUE[listfind(voucher_id_list,voucher_id,',')]>
					<cfset other_money_value2_ = get_remaining_amount.OTHER_REMAINING_VALUE2[listfind(voucher_id_list,voucher_id,',')]>
				<cfelse>
					<cfset voucher_value_ = VOUCHER_VALUE>
					<cfset other_money_value_ = OTHER_MONEY_VALUE>
					<cfset other_money_value2_ = OTHER_MONEY_VALUE2>
				</cfif>	
				<tr>
					<td>
						<input type="checkbox" name="is_sec" id="is_sec" value="#VOUCHER_ID#">
						</td>
						<td>#VOUCHER_PURSE_NO#</td>
						<td>#VOUCHER_NO#<cfif is_pay_term eq 1> - <cf_get_lang dictionary_id='29945.Ödeme Sözü'></cfif></td>
						<cfif x_project_info eq 1>
							<td>#PROJECT_HEAD#</td>
						</cfif>
                        <td>
							<cfif len(company_id)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">
									#get_company_name.fullname[listfind(company_id_list,company_id,',')]#
								</a>
							<cfelseif len(consumer_id)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">
									#get_consumer_name.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_name.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#
								</a>
							<cfelseif len(employee_id)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">
									#get_employee_name.employee_name[listfind(employee_id_list,employee_id,',')]# #get_employee_name.employee_surname[listfind(employee_id_list,employee_id,',')]#
								</a>
							</cfif>
						</td>
						<td>#DEBTOR_NAME#</td>
						<td>#VOUCHER_CITY#</td>
						<td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
						<td style="text-align:right;">
							#TLFormat(voucher_value_)#&nbsp;#CURRENCY_ID#
						</td>
						<td style="text-align:right;">
							<cfif len(OTHER_MONEY_VALUE_)>#TLFormat(OTHER_MONEY_VALUE_)#&nbsp;#OTHER_MONEY#</cfif>
						</td>
						<td nowrap>
							<cfif VOUCHER_STATUS_ID eq 1><cf_get_lang dictionary_id='50073.Portföyde'>
							<cfelseif VOUCHER_STATUS_ID eq 2><cf_get_lang dictionary_id='50250.Bankada'>
							<cfelseif VOUCHER_STATUS_ID eq 3><cf_get_lang dictionary_id='54544.Tahsil Edildi'>
							<cfelseif VOUCHER_STATUS_ID eq 4><cf_get_lang dictionary_id='54545.Ciro Edildi'>
							<cfelseif VOUCHER_STATUS_ID eq 5><cf_get_lang dictionary_id='50334.Protestolu'>
							<cfelseif VOUCHER_STATUS_ID eq 6><cf_get_lang dictionary_id='41226.Ödenmedi'>
							<cfelseif VOUCHER_STATUS_ID eq 7><cf_get_lang dictionary_id='50255.Ödendi'>
							<cfelseif VOUCHER_STATUS_ID eq 10><cf_get_lang dictionary_id='50334.Protestolu'>-<cf_get_lang dictionary_id='49748.Portföyde'>
							<cfelseif VOUCHER_STATUS_ID eq 13><cf_get_lang dictionary_id='50467.Teminatta'>
							<cfelseif VOUCHER_STATUS_ID eq 11><cf_get_lang dictionary_id='50364.Kısmi Tahsil'>
							<cfelseif VOUCHER_STATUS_ID eq 14><cf_get_lang dictionary_id='58568.transfer'>
							</cfif>
						</td>
					</tr>
			</cfoutput>
		<cfelse>
			<tr>
			<cfoutput><td colspan="#colspan_#"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td></cfoutput>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	  <cfset adres = '#listgetat(attributes.fuseaction,1,'.')#.popup_selct_voucher'>
	  <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	  	<cfset adres = '#adres#&keyword=#attributes.keyword#'>
	  </cfif> 
	  <cfif isdefined("control")>
		<cfset adres = "#adres#&control=#control#">
	  </cfif>
	  <cfif isdefined("attributes.sort_type")>
		<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
	  </cfif>
	   <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
		<cfset control = "#control#&start_date=#attributes.start_date#">
	   </cfif>
	   <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
		<cfset control = "#control#&finish_date=#attributes.finish_date#">
	   </cfif>   
	   <cfif isdefined("attributes.voucher_company_id") and len(attributes.voucher_company_id) and len(attributes.voucher_company)>
			<cfset adres = '#adres#&voucher_company_id=#attributes.voucher_company_id#&voucher_company=#attributes.voucher_company#'>
		</cfif>
		<cfif isdefined("attributes.voucher_consumer_id") and len(attributes.voucher_consumer_id) and len(attributes.voucher_company)>
			<cfset adres = '#adres#&voucher_consumer_id=#attributes.voucher_consumer_id#&voucher_company=#attributes.voucher_company#'>
		</cfif>
		<cfif isdefined("attributes.voucher_employee_id") and len(attributes.voucher_employee_id) and len(attributes.voucher_company)>
			<cfset adres = '#adres#&voucher_employee_id=#attributes.voucher_employee_id#&voucher_company=#attributes.voucher_company#'>
		</cfif>
		<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
			<cfset adres = '#adres#&member_type=#attributes.member_type#'>
		</cfif>
		<cfif isdefined("attributes.self_") and len(attributes.self_)>
			<cfset adres = "#adres#&self_=#attributes.self_#">
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset adres = '#adres#&draggable=#attributes.draggable#'>
		</cfif>
	  <cf_paging 
	  		page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
</cfif>
<cf_box_footer><input type="button" name="save_cheq" id="save_cheq" value="Kaydet" onclick="check_all_voucher();"></cf_box_footer>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function check_all_voucher()
	{	
		var sayac = 0;
		<cfoutput query="GET_VOUCHERS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.getElementsByName("is_sec")[#currentrow-attributes.startrow#].checked == true)
				sayac+=1;
		</cfoutput>
		if (sayac == 0)
		{
			alert("<cf_get_lang dictionary_id ="49087.En Az Bir İşlem Seçmelisiniz!">");
			return false;
		}
		var check_list = 0;
		<cfoutput query="GET_VOUCHERS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.getElementsByName("is_sec")[#currentrow-attributes.startrow#].checked == true){
				check_list+=1
				if(check_list==sayac){$("##vouchers#currentrow# ##close_draggable").val("1");}
				
		#iif(isdefined("attributes.draggable"),DE("loadPopupBox('vouchers#currentrow#' , #attributes.modal_id#);"),DE(""))#
	}
		</cfoutput>
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
