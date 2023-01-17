<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.popup_selct_cheque">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<!--- cari hesap filtresi --->
<cfparam name="attributes.companyName" default="">
<cfparam name="attributes.companyID" default="">
<cfparam name="attributes.consumerID" default="">
<cfparam name="attributes.employeeID" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">  
<cfinclude template="../query/get_money2.cfm">
<cfinclude template="../query/get_sel_cheques.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_cheques.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset control= "">
<cfif isdefined("attributes.entry_ret")>
	<cfset control = "#control#&entry_ret=1">
</cfif>
<cfif isdefined("attributes.is_return")>
	<cfset control = "#control#&is_return=1">
</cfif>
<cfif isdefined("attributes.endorsement")>
	<cfset control = "#control#&endorsement=1">
</cfif>
<cfif isdefined("attributes.endor_ret")>
	<cfset control = "#control#&endor_ret=1">
</cfif>
<cfif isdefined("attributes.out_control")>
	<cfset control = "#control#&out_control=1">
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
<cfif isdefined("attributes.company_id")>
	<cfset control = "#control#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset control = "#control#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.employee_id")>
	<cfset control = "#control#&employee_id=#attributes.employee_id#">
</cfif>
<cfif isdefined("attributes.out_bank")>
	<cfset control = "#control#&out_bank=1">
</cfif>
<cfif isdefined("attributes.is_transfer")>
	<cfset control = "#control#&is_transfer=1">
</cfif>
<cfif isdefined("attributes.is_other_act")>
	<cfset control = "#control#&is_other_act=#attributes.is_other_act#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('main',2305)#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_cheque_actions" id="list_cheque_actions" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_selct_cheque&control=#control#">
			<cfoutput>
				<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
				<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
				<input type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
			</cfoutput>
			<cfif isdefined("attributes.out_bank")>
				<input type="hidden" name="out_bank" id="out_bank" value="1">
			</cfif>
        	<cf_box_search>
            	<div class ="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="255" style="width:90px;" placeholder="#getLang('main',68)#">
				</div>
                <div class ="form-group">
					<select name="money_type" id="money_type">
						<option value=""><cf_get_lang dictionary_id='57489.Para Birimi'></option>
						<cfoutput query="get_money">
						<option value="#money#" <cfif isdefined("attributes.money_type") and len(attributes.money_type) and money eq attributes.money_type>selected</cfif>>#money#</option>
						</cfoutput>
					</select>
                </div>
                <div class ="form-group">
                    <select name="sort_type" id="sort_type">
                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                        <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                    </select>
                </div>
                <div class ="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
                <div class ="form-group">
                    	<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_cheque_actions' , #attributes.modal_id#)"),DE(""))#">
     			</div>
            </cf_box_search>
			<!---<table>
				<tr>      
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="255" style="width:90px;"></td>
					<td>
						<select name="money_type" id="money_type">
							<option value=""><cf_get_lang_main no='77.Para Birimi'></option>
							<cfoutput query="get_money">
								<option value="#money#" <cfif isdefined("attributes.money_type") and len(attributes.money_type) and money eq attributes.money_type>selected</cfif>>#money#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<select name="sort_type" id="sort_type">
							<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
							<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
						</select>
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>---> 
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_cheque_actions' , #attributes.modal_id#)"),DE(""))#">
				<div class="col col-3 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group" id="item-companyID">
							<div class="input-group">
								<input type="hidden" name="companyID" id="companyID" <cfif len(attributes.companyName) and len(attributes.companyID)>value="<cfoutput>#attributes.companyID#</cfoutput>"</cfif>>
								<input type="hidden" name="consumerID" id="consumerID" <cfif len(attributes.companyName) and len(attributes.consumerID)>value="<cfoutput>#attributes.consumerID#</cfoutput>"</cfif>>
								<input type="hidden" name="employeeID" id="employeeID" <cfif len(attributes.companyName) and len(attributes.employeeID)>value="<cfoutput>#attributes.employeeID#</cfoutput>"</cfif>>
								<input type="text" name="companyName" id="companyName" placeholder="<cfoutput>#getLang('main',107)#</cfoutput>" value="<cfif len(attributes.companyName)><cfoutput>#URLDecode(companyName)#</cfoutput></cfif>" message="#message#" style="width:100px;" onFocus="AutoComplete_Create('companyName','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','companyID,consumerID,employeeID','','3','150','');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=list_cheque_actions.companyID&field_member_name=list_cheque_actions.companyName&field_name=list_cheque_actions.companyName&field_consumer=list_cheque_actions.consumerID&field_emp_id=list_cheque_actions.employeeID<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list','popup_list_pars');" title="<cf_get_lang dictionary_id='57519.cari hesap'>"></span>
							</div>
						</div>
					<cfif isdefined("attributes.endor_ret")>
						<div class="form-group" id="item-endor_ret">
							<input type="hidden" name="endor_ret" id="endor_ret" value="1">
							<select name="endor" id="endor">
								<option value="" ><cf_get_lang dictionary_id='57482.Aşama'></option>
								<option value="1" <cfif isdefined("attributes.endor") and (attributes.endor eq 1)>selected</cfif>><cf_get_lang dictionary_id='54542.Porftföyde'></option>
								<option value="2" <cfif isdefined("attributes.endor") and (attributes.endor eq 2)>selected</cfif>><cf_get_lang dictionary_id='54546.Karşılıksız'></option>
							</select>
							<cfif isdefined("attributes.endorsement")>
								<input type="hidden" name="endorsement" id="endorsement" value="1">
							</cfif>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group" id="item-start_date">
						<div class="input-group">
							<cfif isdate(attributes.finish_date)>
							<cfset attributes.finish_date=dateformat(attributes.finish_date,dateformat_style)>
							<cfelse>
							<cfset attributes.finish_date="">
							</cfif>
							<cfinput type="text" name="start_date" id="start_date" placeholder="#getLang('main',641)#" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group" id="item-finish_date">
						<div class="input-group">
							<cfif isdate(attributes.finish_date)>
							<cfset attributes.finish_date=dateformat(attributes.finish_date,dateformat_style)>
							<cfelse>
							<cfset attributes.finish_date="">
							</cfif>
							<cfinput type="text" name="finish_date" id="finish_date" placeholder="#getLang('main',288)#" value="#attributes.finish_date#" style="width:65px;" validate="#validate_style#" maxlength="10" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
				<!---<table>
					<tr>
						<td nowrap="nowrap"><cf_get_lang_main no='107.cari hesap'></td>
						<td>
							<input type="hidden" name="companyID" id="companyID" <cfif len(attributes.companyName) and len(attributes.companyID)>value="<cfoutput>#attributes.companyID#</cfoutput>"</cfif>>
							<input type="hidden" name="consumerID" id="consumerID" <cfif len(attributes.companyName) and len(attributes.consumerID)>value="<cfoutput>#attributes.consumerID#</cfoutput>"</cfif>>
							<input type="hidden" name="employeeID" id="employeeID" <cfif len(attributes.companyName) and len(attributes.employeeID)>value="<cfoutput>#attributes.employeeID#</cfoutput>"</cfif>>
							<input type="text" name="companyName" id="companyName" value="<cfif len(attributes.companyName)><cfoutput>#URLDecode(companyName)#</cfoutput></cfif>" message="#message#" style="width:100px;" onFocus="AutoComplete_Create('companyName','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','companyID,consumerID,employeeID','','3','150','');" autocomplete="off">
							<a href="javascript://" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=list_cheque_actions.companyID&field_member_name=list_cheque_actions.companyName&field_name=list_cheque_actions.companyName&field_consumer=list_cheque_actions.consumerID&field_emp_id=list_cheque_actions.employeeID<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list','popup_list_pars');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='107.cari hesap'>" align="absmiddle" border="0"></a>
						</td>
						<td>
							<cf_wrkBankAccounts width='175' selected_value='#attributes.account_id#'>
						</td>
						<cfif isdefined("attributes.endor_ret")>
							<input type="hidden" name="endor_ret" id="endor_ret" value="1">
							<td>
								<select name="endor" id="endor">
									<option value="" ><cf_get_lang_main no='70.Aşama'></option>
									<option value="1" <cfif isdefined("attributes.endor") and (attributes.endor eq 1)>selected</cfif>><cf_get_lang no='54.Porftföyde'></option>
									<option value="2" <cfif isdefined("attributes.endor") and (attributes.endor eq 2)>selected</cfif>><cf_get_lang no='58.Karşılıksız'></option>
								</select>
							</td>
						</cfif>
						<cfif isdefined("attributes.endorsement")>
							<input type="hidden" name="endorsement" id="endorsement" value="1">
						</cfif>
						<td nowrap>
							<cfif isdate(attributes.start_date)>
								<cfset attributes.start_date=dateformat(attributes.start_date,dateformat_style)>
							<cfelse>
								<cfset attributes.start_date="">
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang_main no='1333.Baslama Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="start_date" id="start_date" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" >
							<cf_wrk_date_image date_field="start_date">
						</td>
						<td nowrap>
							<cfif isdate(attributes.finish_date)>
								<cfset attributes.finish_date=dateformat(attributes.finish_date,dateformat_style)>
							<cfelse>
								<cfset attributes.finish_date="">
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang no='153.Filtrebitiş girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="finish_date" id="finish_date" value="#attributes.finish_date#" style="width:65px;" validate="#validate_style#" maxlength="10" >
							<cf_wrk_date_image date_field="finish_date">
						</td>
					</tr>
				</table>--->	
			</cf_box_search_detail>
		</cfform>	
		<cfif get_cheques.recordcount>
			<cfoutput query="get_cheques" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfform name="cheques#currentrow#" id="cheques#currentrow#" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_session&control=#control#">
					<input type="Hidden" name="draggable" id="draggable" value="1">
					<cfinput type="hidden" name="modal_id" id="modal_id" value="#iif(isDefined("attributes.modal_id"),attributes.modal_id,DE(""))#">
					<input type="Hidden" name="cheque_id" id="cheque_id" value="#CHEQUE_ID#">
					<input type="hidden" name="cheque_no" id="cheque_no" value="#CHEQUE_NO#">
					<input type="hidden" name="cheque_code" id="cheque_code" value="#CHEQUE_CODE#">
					<input type="Hidden" name="portfoy_no" id="portfoy_no" value="#CHEQUE_PURSE_NO#">
					<input type="Hidden" name="bank_name" id="bank_name" value="#BANK_NAME#">
					<input type="Hidden" name="debtor_name" id="debtor_name" value="#DEBTOR_NAME#">
					<input type="Hidden" name="cheque_city" id="cheque_city" value="#CHEQUE_CITY#">
					<input type="Hidden" name="cheque_duedate" id="cheque_duedate" value="#dateformat(CHEQUE_DUEDATE,dateformat_style)#">
					<input type="Hidden" name="cheque_value" id="cheque_value" value="#CHEQUE_VALUE#">
					<input type="Hidden" name="cheque_currency_id" id="cheque_currency_id" value="#CURRENCY_ID#">
					<input type="Hidden" name="payroll_id" id="payroll_id" value="#CHEQUE_PAYROLL_ID#">
					<input type="hidden" name="cheque_status_id" id="cheque_status_id" value="#CHEQUE_STATUS_ID#">
					<input type="hidden" name="account_id" id="account_id" value="#ACCOUNT_ID#">
					<input type="hidden" name="account_no" id="account_no" value="#ACCOUNT_NO#">
					<input type="hidden" name="self_cheque_" id="self_cheque_" value="#SELF_CHEQUE#">
					<input type="hidden" name="tax_place" id="tax_place" value="#TAX_PLACE#">
					<input type="Hidden" name="close_draggable" id="close_draggable" value="">
					<input type="hidden" name="tax_no" id="tax_no" value="#TAX_NO#">
					<input type="hidden" name="bank_branch_name" id="bank_branch_name" value="#BANK_BRANCH_NAME#">
					<cfif CHEQUE_STATUS_ID eq 6>
						<input type="hidden" name="self_cheque" id="self_cheque" value="true">
					</cfif>
					<cfif isdefined("attributes.entry_ret")>
						<input type="hidden" name="entry_ret" id="entry_ret" value="1">
					</cfif>
					<cfif isdefined("attributes.is_return")>
						<input type="hidden" name="is_return" id="is_return" value="1">
					</cfif>
					<input type="hidden" name="cheque_system_currency_value" id="cheque_system_currency_value" value="#OTHER_MONEY_VALUE#">
					<input type="hidden" name="money_type" id="money_type" value="#OTHER_MONEY2#">
					<input type="hidden" name="cheque_other_money_value" id="cheque_other_money_value" value="#OTHER_MONEY_VALUE2#">
					<input type="hidden" name="system_value#currentrow#" id="system_value#currentrow#" value="#OTHER_MONEY_VALUE#">
					<input type="hidden" name="duedate_diff#currentrow#" id="duedate_diff#currentrow#" value="#DateDiff('d',CHEQUE_DUEDATE,now())#" />
				</cfform>
			</cfoutput>
		</cfif>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><input type="checkbox" name="allcheck" id="allcheck" onClick="wrk_select_all('allcheck','is_sec'); hesapla();"></th>
					<cfset colspan_ = 12>
					<th><cf_get_lang dictionary_id='58182.Portfoy No'></th>
					<th><cf_get_lang dictionary_id='54490.Çek No'></th>
					<th><cf_get_lang dictionary_id='57789.Ozel Kod'></th>
					<cfif x_project_info eq 1>
						<th><cf_get_lang dictionary_id='57416.Proje'></th>
						<cfset colspan_+=1>
					</cfif>
					<th width="150"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
					<th><cf_get_lang dictionary_id='58181.Ödeme Yeri'></th>
					<th width="55"><cf_get_lang dictionary_id='57640.Vade'></th>
					<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='50272.İşlem Para Br'></th>
					<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58177.Sistem Para Br'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_cheques.recordcount>
					<cfoutput query="get_cheques" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr id="tr#currentrow#">
							<td>
								<input type="checkbox" name="is_sec" id="is_sec" value="#cheque_id#"  onclick="hesapla(); ">
								</td>
								<td>#CHEQUE_PURSE_NO#</td>
								<td>#CHEQUE_NO#</td>
								<td>#CHEQUE_CODE#</td>
								<cfif x_project_info eq 1>
									<td>#PROJECT_HEAD#</td>
								</cfif>
								<td>
									<cfif len(company_id)>
										#get_par_info(company_id,1,1,1)#	
									<cfelseif len(consumer_id)>
										#get_cons_info(consumer_id,0,1)#
									<cfelseif len(employee_id)>
										#get_emp_info(employee_id,0,1)#
									</cfif>
								</td>
								<td>#BANK_NAME#</td>
								<td>#DEBTOR_NAME#</td>
								<td>#CHEQUE_CITY#</td>
								<td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
								<td style="text-align:right;">#TLFormat(CHEQUE_VALUE)#&nbsp;#CURRENCY_ID#</td>
								<td style="text-align:right;"><cfif len(OTHER_MONEY_VALUE)>#TLFormat(OTHER_MONEY_VALUE)#&nbsp;#OTHER_MONEY#</cfif></td>
								<td>
									<cfif CHEQUE_STATUS_ID eq 1><cf_get_lang dictionary_id='54542.Portföyde'>
									<cfelseif CHEQUE_STATUS_ID eq 2><cf_get_lang dictionary_id='54543.Bankada'>
									<cfelseif CHEQUE_STATUS_ID eq 3><cf_get_lang dictionary_id='50251.Tahsil Edildi'>
									<cfelseif CHEQUE_STATUS_ID eq 4><cf_get_lang dictionary_id='50252.Ciro Edildi'>
									<cfelseif CHEQUE_STATUS_ID eq 5><cf_get_lang dictionary_id='50253.Karşılıksız'>
									<cfelseif CHEQUE_STATUS_ID eq 6><cf_get_lang dictionary_id='54547.Ödenmedi'>
									<cfelseif CHEQUE_STATUS_ID eq 7><cf_get_lang dictionary_id='50255.Ödendi'>
									<cfelseif CHEQUE_STATUS_ID eq 10><cf_get_lang dictionary_id='54546.Karşılıksız'>-<cf_get_lang dictionary_id='54542.Portföyde'>
									<cfelseif CHEQUE_STATUS_ID eq 13><cf_get_lang dictionary_id='50467.Teminatta'>
									<cfelseif CHEQUE_STATUS_ID eq 14><cf_get_lang dictionary_id='58568.Transfer'>
									</cfif>
								</td>
							</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<div class="ui-info-bottom flex-end">
			<cfoutput>
				<div class="ui-form-list flex-end">
					<div class="form-group"><input type="text" name="total_value" id="total_value" value="#session.ep.money#" class="box"></div>
					<div class="form-group"><input type="text" name="avg_day" id="avg_day" class="box" placeholder="Ortalama Gün"></div>
					<div class="form-group"><input type="text" name="avg_due_date" id="avg_due_date" class="box" placeholder="Ortalama Vade"></div>
				</div>
				<div><input type="button" name="save_cheq" id="save_cheq" value="Kaydet" onclick="check_all_cheque();"></div>
			</cfoutput>
		</div>
		<cfset adres = '#listgetat(attributes.fuseaction,1,'.')#.popup_selct_cheque'>
		<cfset control = "#control#&sort_type=#attributes.sort_type#">
		<cfif isdefined("attributes.endor") and len(attributes.endor)>
			<cfset control = "#control#&endor=#attributes.endor#">
		</cfif>
		<cfif isdefined("attributes.endorsement") and len(attributes.endorsement)>
			<cfset control = "#control#&endorsement=#attributes.endorsement#">
		</cfif>
		<cfif isdefined("attributes.self_") and len(attributes.self_)>
			<cfset control = "#control#&self_=#attributes.self_#">
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			<cfset control = "#control#&start_date=#attributes.start_date#">
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			<cfset control = "#control#&finish_date=#attributes.finish_date#">
		</cfif>   
		<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
			<cfset control = "#control#&account_id=#attributes.account_id#">
		</cfif>
		<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
			<cfset control = "#control#&money_type=#attributes.money_type#">
		</cfif>
		<cfif isdefined("attributes.out_bank")>
			<cfset control = "#control#&out_bank=1">
		</cfif>
		<!--- cari hesap filtresi --->
		<cfif isdefined("attributes.companyName")>
			<cfset control = "#control#&companyName=#attributes.companyName#">
		</cfif>
		<cfif isdefined("attributes.companyID")>
			<cfset control = "#control#&companyID=#attributes.companyID#">
		</cfif>
		<cfif isdefined("attributes.consumerID")>
			<cfset control = "#control#&consumerID=#attributes.consumerID#">
		</cfif>
		<cfif isdefined("attributes.employeeID")>
			<cfset control = "#control#&employeeID=#attributes.employeeID#">
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset control = '#control#&draggable=#attributes.draggable#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#"
			adres="#adres#&control=#control#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cf_box>
	<div id="new_div"></div>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function hesapla()
	{
		var cheque_total_value = 0;
		var total_carpan_new = 0;
		var avg_duedate_new = 0;
		<cfoutput query="get_cheques" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.getElementsByName("is_sec")[#currentrow-attributes.startrow#].checked == true)
			{
				cheque_total_value += parseFloat(document.getElementById("system_value#currentrow#").value);
				total_carpan_new = parseFloat(total_carpan_new) + parseFloat(filterNum(document.getElementById("system_value#currentrow#").value)*document.getElementById("duedate_diff#currentrow#").value);
			}
		</cfoutput>
		document.getElementById("total_value").value = commaSplit(cheque_total_value);
		if (cheque_total_value != 0)																			
			avg_duedate_new = parseInt(total_carpan_new / cheque_total_value);
		document.getElementById('avg_day').value = avg_duedate_new;		//ortalama gun
		var currentDt = new Date();
		var mm = currentDt.getMonth() + 1;
		var dd = currentDt.getDate();
		var yyyy = currentDt.getFullYear();
		var date = mm + '/' + dd + '/' + yyyy;
		avg_duedate_new = date_add('d',avg_duedate_new,date);
		document.getElementById('avg_due_date').value = avg_duedate_new;	//ortalama Vade
	}
	function check_all_cheque()
	{	
		var sayac = 0;
		<cfoutput query="get_cheques" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.getElementsByName("is_sec")[#currentrow-attributes.startrow#].checked == true)
				sayac+=1;
		</cfoutput>
		if (sayac == 0)
		{
			alert("<cf_get_lang dictionary_id ="49087.En Az Bir İşlem Seçmelisiniz!">");
			return false;
		}
		var check_list = 0;
		<cfoutput query="get_cheques" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.getElementsByName("is_sec")[#currentrow-attributes.startrow#].checked == true){
				var div = document.createElement("input");
				div.setAttribute("id", "is_ajax");
				div.setAttribute("name", "is_ajax");
				div.setAttribute("type", "hidden");
				div.setAttribute("value", "1");
				div.setAttribute("value", "1");
				document.getElementById('cheques#currentrow#').appendChild(div);
				AjaxFormSubmit('cheques#currentrow#','new_div',0,'','','','',1);
	}
	
		</cfoutput>
	}

</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<!--- <script type="text/javascript">
function kontrol​()
{
    if(!$("#start_date").val().length)
        {
            alertObject({message: "<cfoutput><cf_get_lang_main no='1333.Baslama Tarihi Girmelisiniz'> !</cfoutput>"})    
            return false;
    ​}
	 if(!$("#finish_date").val().length)
        {
            alertObject({message: "<cfoutput><cf_get_lang no='153.Filtrebitiş girmelisiniz'> !</cfoutput>"})    
            return false;
    ​}
	
}
</script>    
 --->