<cf_get_lang_set module_name="finance">
	<cf_xml_page_edit fuseact="finance.add_payment_actions">
	<cfparam name="attributes.closed_type_info" default="2">
	<cfif not isdefined("attributes.invoice_type") and is_inv_control_default eq 1><cfset attributes.invoice_type = 1></cfif>
	<cfset module_name = 'finance'>
	<cfset module_name2 = 'cost'>
	<cfset module_name3 = 'objects'>
	<cfset module = 23>
	<cfif application.systemParam.systemParam().fusebox.use_period eq true>
		<cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
	<cfelse>
		<cfset dsn2 = dsn>
	</cfif>​
	<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
		SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
	</cfquery>
	<cfif not isdefined("attributes.act_type")>
					<cfset attributes.act_type = 2>
	</cfif>
	<cfif isdefined("attributes.act_type") and find(',',attributes.act_type)>
					<cfset attributes.act_type = listfirst(attributes.act_type)>
	</cfif>
	
	<cf_catalystHeader>
	<div class="col col-12 col-xs-12">
		<cfif not isDefined("attributes.correspondence_info")>
			<cfform name="add_payment_actions" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_payment_actions&event=add&act_type=#attributes.act_type#">
				<input type="hidden" name="act_type" id="act_type" value="<cfoutput>#attributes.act_type#</cfoutput>">
				<cfsavecontent variable="title"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
				<cf_box id="payment_actions" closable="0" title="#title#">
					<cf_box_elements>
						<div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-member_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'>*</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("attributes.employee_id_new")>
											<cfset emp_id = ''>
											<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and len(attributes.employee_id_new)>
												<cfset attributes.employee_id_new = "#attributes.employee_id_new#_#attributes.acc_type_id#">
											<cfelse>
												<cfset attributes.acc_type_id = ''>
											</cfif>
											<cfif listlen(attributes.employee_id_new,'_') eq 2>
												<cfset emp_id = listfirst(attributes.employee_id_new,'_')>
											<cfelse>
												<cfset emp_id = attributes.employee_id_new>
											</cfif>
										<cfelse>
											<cfset attributes.employee_id_new = ''>
										</cfif>
										<input type="hidden" name="member_id" id="member_id" value="<cfif isdefined("attributes.member_id") and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#attributes.member_id#</cfoutput></cfif>">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
										<input type="hidden" name="employee_id_new" id="employee_id_new" value="<cfif isdefined("attributes.employee_id_new")><cfoutput>#attributes.employee_id_new#</cfoutput></cfif>">
										<input type="text" name="member_name" id="member_name" style="width:140px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,','member_id,consumer_id,employee_id_new','','3','250');" value="<cfif isdefined("attributes.member_id") and len(attributes.member_id) and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#get_par_info(attributes.member_id,1,1,0)#</cfoutput><cfelseif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput><cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput><cfelseif isdefined("attributes.employee_id_new") and len(attributes.employee_id_new)><cfoutput>#get_emp_info(emp_id,0,0,0,attributes.acc_type_id)#</cfoutput></cfif>" autocomplete="off">
										<cfset str_linke_ait="field_comp_id=add_payment_actions.member_id&field_name=add_payment_actions.member_name&field_consumer=add_payment_actions.consumer_id&field_member_name=add_payment_actions.member_name&field_emp_id=add_payment_actions.employee_id_new&select_list=1,2,3,9">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&#str_linke_ait#&keyword='+encodeURIComponent(add_payment_actions.member_name.value)</cfoutput>);"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-project_head">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
										<input type="text" name="project_head" id="project_head" style="width:140px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_payment_actions.project_id&project_head=add_payment_actions.project_head');"></span>
									</div>
								</div>
							</div>					
							<div class="form-group" id="item-money_type">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='77.Para birimi'></label>
								<div class="col col-8 col-xs-12">
									<select name="money_type" id="money_type" style="width:140px;">
										<cfoutput query="get_money_rate">
											<option value="#money#" <cfif isdefined('attributes.money_type') and attributes.money_type eq money>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-due_date">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no ='469.Vade Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="due_date1" id="due_date1" maxlength="10" value="<cfoutput><cfif isdefined('attributes.due_date1') and len(attributes.due_date1)>#attributes.due_date1#</cfif></cfoutput>" style="width:65px" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="due_date1"></span>
										<span class="input-group-addon no-bg"></span>
										<input type="text" name="due_date2" id="due_date2" maxlength="10" value="<cfoutput><cfif isdefined('attributes.due_date2') and len(attributes.due_date2)>#attributes.due_date2#</cfif></cfoutput>" style="width:65px" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="due_date2"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-dates">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no ='467.İşlem Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="start_date" id="start_date" maxlength="10" value="<cfoutput><cfif isdefined('attributes.start_date') and len(attributes.start_date)>#attributes.start_date#</cfif></cfoutput>" style="width:65px" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
										<span class="input-group-addon no-bg"></span>
										<input type="text" name="finish_date" id="finish_date" maxlength="10" value="<cfoutput><cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>#attributes.finish_date#</cfif></cfoutput>" style="width:65px" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-closed_type_info">
								<label class="col col-4 col-xs-12"></label>
								<div class="col col-8 col-xs-12">
									<select name="closed_type_info" id="closed_type_info" style="width:160px">
										<option value="1"<cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 1>selected</cfif>><cf_get_lang_main no ='669.Hepsi'></option>
										<option value="2"<cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 2>selected</cfif>><cf_get_lang no ='63.Kapanmamışlar'></option>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-employee_name">
								<label class="col col-4 col-xs-12"><cf_get_lang no ='35.Kontrol Eden'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
										<input type="text" name="employee_name" id="employee_name"  style="width:130px;" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','','3','162');" value="<cfif isDefined("attributes.employee_name") and len(attributes.record_emp_id) and len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.record_emp_id,0,0)#</cfoutput></cfif>" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_payment_actions.record_emp_id&field_name=add_payment_actions.employee_name&select_list=1,9&keyword='+encodeURIComponent(document.add_payment_actions.employee_name.value));return false"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-invoice_type">
								<label class="col col-4 col-xs-12"><cf_get_lang no ='59.Fatura Kontrol'></label>
								<div class="col col-8 col-xs-12">
									<select name="invoice_type" id="invoice_type" style="width:130px;">
										<option value=""><cf_get_lang_main no ='669.Hepsi'></option>
										<option value="1"<cfif isdefined('attributes.invoice_type') and attributes.invoice_type eq 1>selected</cfif>><cf_get_lang no ='61.Kontrol Edilenler'></option>
										<option value="0"<cfif isdefined('attributes.invoice_type') and attributes.invoice_type eq 0>selected</cfif>><cf_get_lang no ='62.Kontrol Edilmeyenler'></option>
									</select>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cfsavecontent variable="button_value"><cf_get_lang_main no='238.Dök'></cfsavecontent>
						<cf_wrk_search_button button_name='#button_value#' float="right" button_type="2" search_function='kontrol()'>
					</cf_box_footer>
				</cf_box>
			</cfform>
		</cfif>
		<cfif isDefined("attributes.correspondence_info") or ((isDefined("attributes.member_id") and len(attributes.member_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isDefined("attributes.employee_id_new") and len(attributes.employee_id_new)))>
			<cfif isDefined("attributes.correspondence_info")><cfset url_link = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_payment_actions"><cfelse><cfset url_link = ""></cfif>
			<cfform name="add_payment_actions2" id="add_payment_actions2" method="post" action="#url_link#">
				<input type="hidden" name="money_type" id="money_type" value="<cfif isdefined("attributes.money_type")><cfoutput>#attributes.money_type#</cfoutput></cfif>">
				<input type="hidden" name="act_type" id="act_type" value="<cfif isdefined("attributes.act_type")><cfoutput>#attributes.act_type#</cfoutput></cfif>">
				<cfif not isdefined("attributes.correspondence_info")>
					<cfsavecontent variable="title"><cf_get_lang_main no='365.İşlemler'></cfsavecontent>
					<cf_box title="#title#" right_images="<li><a href='javascript:convertExcel()'><i class='fa fa-file-excel-o'></i></a></li>">
						<cfif isDefined("attributes.due_date1") and len(attributes.due_date1)>
							<cf_date tarih="attributes.due_date1">
						</cfif>
						<cfif isDefined("attributes.due_date2") and len(attributes.due_date2)>
							<cf_date tarih="attributes.due_date2">
						</cfif>
						<cfif isDefined("attributes.start_date") and len(attributes.start_date)>
							<cf_date tarih="attributes.start_date">
						</cfif>
						<cfif isDefined("attributes.finish_date") and len(attributes.finish_date)>
							<cf_date tarih="attributes.finish_date">
						</cfif>
						<cfinclude template="../query/get_payment_actions.cfm">
						<input type="hidden" name="all_records" id="all_records" value="<cfoutput>#get_cari_rows.recordcount#</cfoutput>">
						<input type="hidden" name="member_id" id="member_id" value="">
						<input type="hidden" name="consumer_id" id="consumer_id" value="">
						<input type="hidden" name="employee_id_new" id="employee_id_new" value="">
						<input type="hidden" name="due_datelist" id="due_datelist" value="">
						<input type="hidden" name="action_datelist" id="action_datelist" value="">
						<input type="hidden" name="value_list" id="value_list" value="">
						<cf_grid_list id="process_table">
							<thead>	
								<cfoutput>
								<tr>
									<th width="20" rowspan="2"><input name="ch_all" id="ch_all" type="checkbox" onClick="sec_hepsini();" value=""></th>
									<th width="60" rowspan="2"><cf_get_lang_main no='468.Belge No'></th>			
									<th width="20%"rowspan="2" nowrap="nowrap"><cf_get_lang_main no='388.İşlem Tipi'></th>
									<th width="60" rowspan="2"><cf_get_lang_main no ='467.İşlem Tarihi'></th>
									<th width="40" rowspan="2"><cf_get_lang_main no='228.Vade'></th>
									<th width="60" rowspan="2"><cf_get_lang_main no ='469.Vade Tarihi'></th>
									<th width="170" align="center" colspan="2"><cf_get_lang_main no='1511.Belge Tutarı'></th>
									<th width="170" align="center" colspan="2"><cf_get_lang no ='65.Kapanmış Tutar'></th>
									<cfif attributes.act_type eq 3>
										<th width="170" align="center" colspan="2"><cf_get_lang_main no ='115.Talepler'></th>
									</cfif>
									<cfif attributes.act_type eq 2>
										<th width="170" align="center" colspan="2"><cf_get_lang_main no ='116.Emirler'></th>
									</cfif>
									<th width="200" align="center" colspan="3"><cfif attributes.act_type eq 1><cf_get_lang no ='25.Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang no ='17.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang no ='24.Emir'></cfif></th>
								</tr>
								<tr height="20">
									<th width="85">#session.ep.money# <cf_get_lang_main no='261.Tutar'></th>
									<th width="85"><cf_get_lang_main no ='470.İşlem Tutar'></th>
									<th width="85">#session.ep.money# <cf_get_lang_main no='261.Tutar'></th>
									<th width="85"><cf_get_lang_main no ='470.İşlem Tutar'></th>
									<cfif attributes.act_type eq 3>
										<th width="85">#session.ep.money# <cf_get_lang_main no='261.Tutar'></th>
										<th width="85"><cf_get_lang_main no ='470.İşlem Tutar'></th>
									</cfif>
									<cfif attributes.act_type eq 2>
										<th width="85">#session.ep.money# <cf_get_lang_main no='261.Tutar'></th>
										<th width="85"><cf_get_lang_main no ='470.İşlem Tutar'></th>
									</cfif>
									<th width="1%">#session.ep.money# <cf_get_lang_main no='261.Tutar'></th>
									<th width="80"><cf_get_lang_main no ='470.İşlem Tutar'></th>
									<th width="40"></th>
								</tr>
							</thead> 
							<tbody>
							</cfoutput>
							<cfset checked = 0>
							<cfif get_cari_rows.recordcount>
								<cfoutput query="get_cari_rows">
									<cfquery name="get_process_cat_info" datasource="#dsn3#">
										SELECT IS_ROW_PROJECT_BASED_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_cari_rows.PROCESS_CAT#
									</cfquery>
									<cfquery name="GET_ALL_ACTION" datasource="#dsn2#">
										SELECT
											SUM(TOTAL_1) TOTAL_1,
											SUM(OTHER_TOTAL_1) OTHER_TOTAL_1,
											SUM(TOTAL_2) TOTAL_2,
											SUM(OTHER_TOTAL_2) OTHER_TOTAL_2,
											SUM(TOTAL_3) TOTAL_3,
											SUM(OTHER_TOTAL_3) OTHER_TOTAL_3
										FROM
										(
											SELECT
												SUM(PAYMENT_VALUE) TOTAL_1,
												SUM(OTHER_PAYMENT_VALUE) OTHER_TOTAL_1,
												0 TOTAL_2,
												0 OTHER_TOTAL_2,
												0 TOTAL_3,
												0 OTHER_TOTAL_3
											FROM 
												CARI_CLOSED_ROW
											WHERE
												ACTION_ID = #ACTION_ID# AND
												ACTION_TYPE_ID = #ACTION_TYPE_ID# AND
												<cfif (ACTION_TABLE is 'INVOICE' OR ACTION_TABLE is 'EXPENSE_ITEM_PLANS') AND NOT get_process_cat_info.RECORDCOUNT>
													DUE_DATE = #CreateODBCDateTime(get_cari_rows.DUE_DATE)# AND
												<cfelse>
													CARI_ACTION_ID = #CARI_ACTION_ID# AND
												</cfif>
												OTHER_MONEY = '#OTHER_MONEY#' AND
												CLOSED_AMOUNT IS NULL AND
												PAYMENT_VALUE IS NOT NULL AND
												P_ORDER_VALUE IS NULL
										UNION ALL
											SELECT
												0 TOTAL_1,
												0 OTHER_TOTAL_1,
												SUM(P_ORDER_VALUE) TOTAL_2,
												SUM(OTHER_P_ORDER_VALUE) OTHER_TOTAL_2,
												0 TOTAL_3,
												0 OTHER_TOTAL_3
											FROM 
												CARI_CLOSED_ROW
											WHERE
												ACTION_ID = #ACTION_ID# AND
												ACTION_TYPE_ID = #ACTION_TYPE_ID# AND
												<cfif (ACTION_TABLE is 'INVOICE' OR ACTION_TABLE is 'EXPENSE_ITEM_PLANS') AND NOT get_process_cat_info.RECORDCOUNT>
													DUE_DATE = #CreateODBCDateTime(DUE_DATE)# AND
												<cfelse>
													CARI_ACTION_ID = #CARI_ACTION_ID# AND
												</cfif>
												OTHER_MONEY = '#OTHER_MONEY#' AND
												CLOSED_AMOUNT IS NULL AND
												P_ORDER_VALUE IS NOT NULL
										UNION ALL
											SELECT
												0 TOTAL_1,
												0 OTHER_TOTAL_1,
												0 TOTAL_2,
												0 OTHER_TOTAL_2,
												SUM(CLOSED_AMOUNT) TOTAL_3,
												SUM(OTHER_CLOSED_AMOUNT) OTHER_TOTAL_3
											FROM 
												CARI_CLOSED_ROW
											WHERE
												ACTION_ID = #ACTION_ID# AND
												ACTION_TYPE_ID = #ACTION_TYPE_ID# AND
												<cfif (ACTION_TABLE is 'INVOICE' OR ACTION_TABLE is 'EXPENSE_ITEM_PLANS') AND NOT get_process_cat_info.RECORDCOUNT>
													DUE_DATE = #CreateODBCDateTime(DUE_DATE)# AND
												<cfelse>
													CARI_ACTION_ID = #CARI_ACTION_ID# AND
												</cfif>
												OTHER_MONEY = '#OTHER_MONEY#' AND
												CLOSED_AMOUNT IS NOT NULL AND
												P_ORDER_VALUE IS NOT NULL
										UNION ALL
											SELECT
												0 TOTAL_1,
												0 OTHER_TOTAL_1,
												0 TOTAL_2,
												0 OTHER_TOTAL_2,
												SUM(CLOSED_AMOUNT) TOTAL_3,
												SUM(OTHER_CLOSED_AMOUNT) OTHER_TOTAL_3
											FROM 
												CARI_CLOSED_ROW
											WHERE
												ACTION_ID = #ACTION_ID# AND
												ACTION_TYPE_ID = #ACTION_TYPE_ID# AND
												<cfif ACTION_TABLE is 'INVOICE' OR ACTION_TABLE is 'EXPENSE_ITEM_PLANS'>
													DUE_DATE = #CreateODBCDateTime(DUE_DATE)# AND
												<cfelse>
													CARI_ACTION_ID = #CARI_ACTION_ID# AND
												</cfif>
												OTHER_MONEY = '#OTHER_MONEY#' AND
												CLOSED_AMOUNT IS NOT NULL AND
												PAYMENT_VALUE IS NULL AND
												P_ORDER_VALUE IS NULL
										)T1										
									</cfquery>
									<cfif attributes.act_type eq 3>
										<cfset row_closed_amount = other_p_order_value+GET_ALL_ACTION.OTHER_TOTAL_3>
										<cfset row_closed_amount_system = total_p_order_value+GET_ALL_ACTION.TOTAL_3>
									<cfelseif attributes.act_type eq 2>
										<!--- Talep eklerken kapaması varsa kapama tutarını, yoksa emir tutarını düşerek kontrol edilmesi için eklendi. eğer hiç bir işlemi yoksa talep tutarını düşüp kontrol ediyor --->
										<cfset row_closed_amount = GET_ALL_ACTION.OTHER_TOTAL_1+GET_ALL_ACTION.OTHER_TOTAL_2+GET_ALL_ACTION.OTHER_TOTAL_3>
										<cfset row_closed_amount_system = GET_ALL_ACTION.TOTAL_1+GET_ALL_ACTION.TOTAL_2+GET_ALL_ACTION.TOTAL_3>
									<cfelse>
										<cfset row_closed_amount = other_closed_amount>
										<cfset row_closed_amount_system = total_closed_amount>
									</cfif>
									<cfif (len(from_cmp_id) and isdefined("attributes.member_id") and len(attributes.member_id) and from_cmp_id eq attributes.member_id) or (len(from_consumer_id) and len(attributes.consumer_id) and from_consumer_id eq attributes.consumer_id) or (len(from_employee_id) and len(attributes.employee_id_new) and from_employee_id eq attributes.employee_id_new)>
										<tr>
											<td>
											<input type="hidden" name="purchase_sales#currentrow#" id="purchase_sales#currentrow#" value="1">
											<input type="hidden" name="type_#currentrow#" id="type_#currentrow#" value="0">
											<input type="hidden" name="action_id_#currentrow#" id="action_id_#currentrow#" value="#action_id#">
											<input type="hidden" name="cari_action_id_#currentrow#" id="cari_action_id_#currentrow#" value="#cari_action_id#">
											<input type="hidden" name="action_type_id_#currentrow#" id="action_type_id_#currentrow#" value="#action_type_id#">
											<input type="hidden" name="action_value_#currentrow#" id="action_value_#currentrow#" value="#action_value#">
											<input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
											<input type="hidden" name="due_date_2_#currentrow#" id="due_date_2_#currentrow#" value="#due_date#">
											<input type="hidden" name="due_date_#currentrow#" id="due_date_#currentrow#" value="#dateformat(due_date,dateformat_style)#">
											<input type="hidden" name="action_date_#currentrow#" id="action_date_#currentrow#" value="#dateformat(action_date,dateformat_style)#">
											<input type="hidden" name="rate2_#currentrow#" id="rate2_#currentrow#" value="<cfif other_cash_act_value neq 0>#wrk_round(action_value/other_cash_act_value,session.ep.our_company_info.rate_round_num)#<cfelse>#wrk_round(0,session.ep.our_company_info.rate_round_num)#</cfif>">
											<input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#wrk_round(action_value-row_closed_amount_system)#">
											<input type="hidden" name="h_to_other_closed_amount_#currentrow#" id="h_to_other_closed_amount_#currentrow#" value="<cfif listfind('48,49',ACTION_TYPE_ID,',')>#tlformat(action_value-row_closed_amount_system)#<cfelse>#tlformat(other_cash_act_value-row_closed_amount)#</cfif>">
											<input type="checkbox" name="is_closed_#currentrow#" id="is_closed_#currentrow#" value="" onchange="check_kontrol(this);total_amount();" onClick="check_kontrol(this);total_amount();" <cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>checked</cfif>>
											</td>
											<cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>
												<cfset checked=1>
											</cfif>
											<td>
												<cfset type="">
												<cfswitch expression = "#ACTION_TYPE_ID#">
													<cfcase value="24"><cfset type="#module_name3#.popup_dsp_gelenh"></cfcase>
													<cfcase value="25"><cfset type="#module_name3#.popup_dsp_gidenh"></cfcase>
													<cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
													<cfcase value="31"><cfset type="#module_name3#.popup_dsp_cash_revenue"></cfcase><!---tahsilat--->
													<cfcase value="32"><cfset type="#module_name3#.popup_dsp_cash_payment"></cfcase><!---odeme--->
													<cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
													<cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
													<cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
													<cfcase value="90"><cfset type="#module_name3#.popup_dsp_payroll_entry"></cfcase>
													<cfcase value="106"><cfset type="#module_name3#.popup_dsp_payroll_entry"></cfcase>
													<cfcase value="91"><cfset type="#module_name3#.popup_dsp_payroll_endorsement"></cfcase>
													<cfcase value="94"><cfset type="#module_name3#.popup_dsp_payroll_endor_return"></cfcase>
													<cfcase value="95"><cfset type="#module_name3#.popup_dsp_payroll_entry_return"></cfcase>
													<cfcase value="97"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="98"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="101"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="108"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
													<cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
													<cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
													<cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
													<cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
													<cfcase value="120,121"><cfset type="#module_name2#.popup_list_cost_expense"></cfcase><!--- Masraf Fişi, Gelir Fişi --->
													<cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
													<cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
													<cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
														<cfif isdefined("invoice_partner_link")>
															<cfset type = invoice_partner_link>
														<cfelse>
															<cfset type="objects.popup_detail_invoice">
														</cfif>
													</cfcase>
													<cfdefaultcase><cfset type=""></cfdefaultcase>
												</cfswitch>
												<cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
													<cfset page_type = 'small'>
												<cfelse>
													<cfset page_type = 'page'>
												</cfif>
												<cfif len(type)>
													<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#','#page_type#');">#paper_no#</a>
												<cfelse>
													#paper_no#
											</cfif>
											</td>
											<td>#action_name#</td>
											<td>#dateformat(action_date,dateformat_style)#</td>
											<td align="center"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></td>
											<td><cfif len(due_date)>#dateformat(due_date,dateformat_style)#<cfelse>&nbsp;</cfif></td>
											<td class="moneybox">#TLFormat(action_value)# #session.ep.money#</td>
											<td class="moneybox"><cfif listfind('48,49',ACTION_TYPE_ID,',') and len(action_value)>#TLFormat(action_value)# #session.ep.money#<cfelseif len(other_cash_act_value)>#TLFormat(other_cash_act_value)# #other_money#</font></cfif></td>
											<cfif attributes.act_type eq 1>
												<td class="moneybox">#tlformat(dsp_total_closed_amount)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(dsp_other_closed_amount)# #I_OTHER_MONEY#</td>
											<cfelseif attributes.act_type eq 2>
												<td class="moneybox">#tlformat(dsp_total_closed_amount)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(dsp_other_closed_amount)# #I_OTHER_MONEY#</td>
												<td class="moneybox">#tlformat(TOTAL_P_ORDER_VALUE)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(OTHER_P_ORDER_VALUE)# #I_OTHER_MONEY#</td>
											<cfelseif attributes.act_type eq 3>
												<td class="moneybox">#tlformat(dsp_total_closed_amount)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(dsp_other_closed_amount)# #I_OTHER_MONEY#</td>
												<td class="moneybox">#tlformat(TOTAL_PAYMENT_VALUE)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(OTHER_PAYMENT_VALUE)# #I_OTHER_MONEY#</td>
											</cfif>
											<td>
												<input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px;">
											</td>
											<td>		 
											<input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif listfind('48,49',ACTION_TYPE_ID,',') and len(action_value)>#tlformat(action_value-row_closed_amount_system)#<cfelseif len(DSP_OTHER_CLOSED_AMOUNT) and len(other_cash_act_value)>#tlformat(other_cash_act_value-row_closed_amount)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100%">
											</td>
											<td>#other_money#</td>
										</tr>
									<cfelse>
										<tr>
											<td>
												<input type="hidden" name="purchase_sales#currentrow#" id="purchase_sales#currentrow#" value="0">
												<input type="hidden" name="type_#currentrow#" id="type_#currentrow#" value="1">
												<input type="hidden" name="action_id_#currentrow#" id="action_id_#currentrow#" value="#action_id#">
												<input type="hidden" name="cari_action_id_#currentrow#" id="cari_action_id_#currentrow#" value="#cari_action_id#">
												<input type="hidden" name="action_type_id_#currentrow#" id="action_type_id_#currentrow#" value="#action_type_id#">
												<input type="hidden" name="action_value_#currentrow#" id="action_value_#currentrow#" value="#action_value#">
												<input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
												<input type="hidden" name="action_date_#currentrow#" id="action_date_#currentrow#" value="#dateformat(action_date,dateformat_style)#">
												<input type="hidden" name="due_date_#currentrow#" id="due_date_#currentrow#" value="#dateformat(due_date,dateformat_style)#">
												<input type="hidden" name="rate2_#currentrow#" id="rate2_#currentrow#" value="<cfif other_cash_act_value neq 0>#wrk_round(action_value/other_cash_act_value,session.ep.our_company_info.rate_round_num)#<cfelse>#wrk_round(0,session.ep.our_company_info.rate_round_num)#</cfif>">
												<input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#wrk_round(action_value-row_closed_amount_system)#">
												<input type="hidden" name="h_to_other_closed_amount_#currentrow#" id="h_to_other_closed_amount_#currentrow#" value="<cfif listfind('48,49',ACTION_TYPE_ID,',')>#tlformat(action_value-row_closed_amount_system)#<cfelse>#tlformat(other_cash_act_value-row_closed_amount)#</cfif>">
												<input type="checkbox" name="is_closed_#currentrow#" id="is_closed_#currentrow#" value="" onchange="check_kontrol(this);total_amount();" onClick="check_kontrol(this);total_amount();" <cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>checked</cfif>>
											</td>
											<cfif isdefined("attributes.row_action_id") and action_id eq attributes.row_action_id and action_type_id eq attributes.row_action_type>
												<cfset checked=1>
											</cfif>
											<td>
												<cfset type="">
												<cfswitch expression = "#ACTION_TYPE_ID#">
													<cfcase value="24"><cfset type="#module_name3#.popup_dsp_gelenh"></cfcase>
													<cfcase value="25"><cfset type="#module_name3#.popup_dsp_gidenh"></cfcase>
													<cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
													<cfcase value="31"><cfset type="#module_name3#.popup_dsp_cash_revenue"></cfcase><!---tahsilat--->
													<cfcase value="32"><cfset type="#module_name3#.popup_dsp_cash_payment"></cfcase><!---odeme--->
													<cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
													<cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
													<cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
													<cfcase value="90"><cfset type="#module_name3#.popup_dsp_payroll_entry"></cfcase>
													<cfcase value="106"><cfset type="#module_name3#.popup_dsp_payroll_entry"></cfcase>
													<cfcase value="91"><cfset type="#module_name3#.popup_dsp_payroll_endorsement"></cfcase>
													<cfcase value="94"><cfset type="#module_name3#.popup_dsp_payroll_endor_return"></cfcase>
													<cfcase value="95"><cfset type="#module_name3#.popup_dsp_payroll_entry_return"></cfcase>
													<cfcase value="97"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="98"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="101"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="108"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
													<cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
													<cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
													<cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
													<cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
													<cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
													<cfcase value="120,121"><cfset type="#module_name2#.popup_list_cost_expense"></cfcase><!--- Masraf Fişi, Gelir Fişi --->
													<cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
													<cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
													<cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
														<cfif isdefined("invoice_partner_link")>
															<cfset type = invoice_partner_link>
														<cfelse>
															<cfset type="objects.popup_detail_invoice">
														</cfif>
													</cfcase>
													<cfdefaultcase><cfset type=""></cfdefaultcase>
												</cfswitch>
												<cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
													<cfset page_type = 'small'>
												<cfelse>
													<cfset page_type = 'page'>
												</cfif>
												<cfif len(type)>
													<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#','#page_type#');"><font color="red">#paper_no#</font></a>
												<cfelse>
													<font color="red">#paper_no#</font>
												</cfif>
											</td>
											<td><font color="red">#action_name#</font></td>
											<td><font color="red">#dateformat(action_date,dateformat_style)#</font></td>
											<td align="center"><font color="red"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></font></td>
											<td><font color="red"><cfif len(due_date)>#dateformat(due_date,dateformat_style)#<cfelse>&nbsp;</cfif></font></td>				
											<td class="moneybox"><font color="red">#TLFormat(action_value)# #session.ep.money#</font></td>
											<td class="moneybox"><font color="red"><cfif listfind('48,49',ACTION_TYPE_ID,',') and len(action_value)>#TLFormat(action_value)# #session.ep.money#<cfelseif len(other_cash_act_value)>#TLFormat(other_cash_act_value)# #other_money#</font></cfif></td>
											<cfif attributes.act_type eq 1>
												<td class="moneybox">#tlformat(dsp_total_closed_amount)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(dsp_other_closed_amount)# #I_OTHER_MONEY#</td>
											<cfelseif attributes.act_type eq 2>
												<td class="moneybox">#tlformat(dsp_total_closed_amount)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(dsp_other_closed_amount)# #I_OTHER_MONEY#</td>
												<td class="moneybox">#tlformat(TOTAL_P_ORDER_VALUE)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(OTHER_P_ORDER_VALUE)# #I_OTHER_MONEY#</td>
											<cfelseif attributes.act_type eq 3>
												<td class="moneybox">#tlformat(dsp_total_closed_amount)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(dsp_other_closed_amount)# #I_OTHER_MONEY#</td>
												<td class="moneybox">#tlformat(TOTAL_PAYMENT_VALUE)# #session.ep.money#</td>
												<td class="moneybox">#tlformat(OTHER_PAYMENT_VALUE)# #I_OTHER_MONEY#</td>
											</cfif>
											<td>
												<input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="" onblur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100px;">
											</td>
											<td>
												<input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="<cfif listfind('48,49',ACTION_TYPE_ID,',') and len(action_value)>#tlformat(action_value-row_closed_amount_system)#<cfelseif len(DSP_OTHER_CLOSED_AMOUNT) and len(other_cash_act_value)>#tlformat(other_cash_act_value-row_closed_amount)#</cfif>" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" style="width:100%">
											</td>
											<td>#other_money#</td>
										</tr>
									</cfif> 
								</cfoutput>
							<cfelse>
								<tr>
									<td colspan="15"><cf_get_lang_main no='72.Kayıt Bulunamadı'></td>
								</tr>		 
							</cfif>
							</tbody>
						</cf_grid_list>
						<cfif checked eq 1>
							<input type="hidden" name="total_record" id="total_record" value="1">
						<cfelse>
							<input type="hidden" name="total_record" id="total_record" value="0">
						</cfif>
					</cf_box>
					<cfif (isDefined("attributes.member_id") and len(attributes.member_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isDefined("attributes.employee_id_new") and len(attributes.employee_id_new))>
						<cfsavecontent  variable="right">
							<cfoutput>
							<li>
								<cfif isDefined("attributes.member_id") and len(attributes.member_id)>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#attributes.member_id#');">
									<i class="icon-file-text-o" border="0" title="<cf_get_lang_main no='163.Üye Bilgileri'>"></i></a>
								<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#attributes.consumer_id#','medium');">
									<i class="icon-file-text-o" border="0" title="<cf_get_lang_main no='163.Üye Bilgileri'>"></i></a>
								</cfif>
							</li>
							</cfoutput>
						</cfsavecontent>
						<cf_box title="#getLang('main',673)#" right_images="#right#" resize="0">
							<cfif isDefined("attributes.member_id") and len(attributes.member_id)><!--- company --->
								<cfset attributes.company_id = attributes.member_id>
								<cfset company_id = attributes.member_id>
								<cfif isDefined("attributes.member_name") and len(attributes.member_name)>
									<cfset attributes.company = attributes.member_name>
									<cfset company = attributes.member_name>
								<cfelse>
									<cfset attributes.company = get_par_info(attributes.member_id,1,1,0)>
									<cfset company = get_par_info(attributes.member_id,1,1,0)>
								</cfif>
								<cfset member_type = 'partner'>
								<cfset session_base = evaluate('session.ep')>
							<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)><!--- partner --->
								<cfif isDefined("attributes.member_name") and len(attributes.member_name)>
									<cfset attributes.company = attributes.member_name>
									<cfset company = attributes.member_name>
								<cfelse>
									<cfset attributes.company = get_cons_info(attributes.consumer_id,0,0)>
									<cfset company = get_cons_info(attributes.consumer_id,0,0)>
								</cfif>
								<cfset member_type = 'consumer'>
								<cfset session_base = evaluate('session.ep')>
							<cfelseif isDefined("attributes.employee_id_new") and len(attributes.employee_id_new)><!--- employee --->
								<cfif isDefined("attributes.member_name") and len(attributes.member_name)>
									<cfset attributes.company = attributes.member_name>
									<cfset company = attributes.member_name>
									<cfif listlen(attributes.employee_id_new,'_') eq 2>
										<cfset attributes.employee_id = listfirst(attributes.employee_id_new,'_')>
									<cfelse>	
										<cfset attributes.employee_id = attributes.employee_id_new>
									</cfif>
								<cfelse>
									<cfif listlen(attributes.employee_id_new,'_') eq 2>
										<cfset attributes.company = get_emp_info(listfirst(attributes.employee_id_new,'_'),0,0)>
										<cfset attributes.employee_id = listfirst(attributes.employee_id_new,'_')>
									<cfelse>	
										<cfset attributes.company = get_emp_info(attributes.employee_id_new,0,0)>
										<cfset attributes.employee_id = attributes.employee_id_new>
									</cfif>
									<cfset company = get_emp_info(attributes.employee_id_new,0,0)>
								</cfif>
								<cfset member_type = 'employee'>
								<cfset session_base = evaluate('session.ep')>
							</cfif>
							<cfif isDefined("member_type") and member_type is not 'employee'>
								<cfinclude template="../../objects/display/dsp_extre_summary.cfm">									
							</cfif>	
						</cf_box>
					</cfif>
					<cfsavecontent  variable="title_"><cfif attributes.act_type eq 1><cf_get_lang no ='25.Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang no ='17.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang no ='24.Emir'></cfif></cfsavecontent>
					<cf_box title="#title_#">
						<cf_box_elements>
							<div class="col col-4 col-md-6 col-xs-12" type="column" index="4" sort="true">
								<cfif attributes.act_type eq 2 and xml_show_process_stage eq 1>
									<div class="form-group" id="item-process_cat">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main dictionary_id='57800.işlem tipi'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cf_workcube_process_cat slct_width="100">
										</div>
									</div>
								</cfif>	
								<div class="form-group" id="item-total_debt_amount">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label><cf_get_lang dictionary_id='54455.Borç Toplamı'></label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="text" name="total_debt_amount" id="total_debt_amount" value="" class="moneybox" readonly>
											<span class="input-group-addon width">
												<cfif isdefined("attributes.money_type") and len(attributes.money_type)><cfoutput>#attributes.money_type#</cfoutput><cfelse><cfoutput>#session.ep.money#</cfoutput></cfif>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-total_claim_amount">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label><cf_get_lang_main dictionary_id='54456.Alacak Toplamı'></label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="text" name="total_claim_amount" id="total_claim_amount" value="" class="moneybox" readonly> 
											<span class="input-group-addon width">
												<cfif isdefined("attributes.money_type") and len(attributes.money_type)><cfoutput>#attributes.money_type#</cfoutput> <cfelse><cfoutput>#session.ep.money#</cfoutput></cfif>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-total_difference_amount">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label><cfif attributes.act_type eq 1><cf_get_lang dictionary_id ='54411.Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang dictionary_id='30828.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang dictionary_id='36656.Emir'></cfif><cf_get_lang dictionary_id='54452.Tutarı'></label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="text" name="total_difference_amount" id="total_difference_amount" value="" class="moneybox" readonly> 
											<span class="input-group-addon width">
												<cfif isdefined("attributes.money_type") and len(attributes.money_type)><cfoutput>#attributes.money_type#</cfoutput> <cfelse><cfoutput>#session.ep.money#</cfoutput></cfif>
											</span>
										</div>
									</div>
								</div>								
							</div>
							<div class="col col-4 col-md-6 col-xs-12" type="column" index="5" sort="true">
								<div class="form-group" id="item-payment_date">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif attributes.act_type eq 1><cf_get_lang dictionary_id ='54411.Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang dictionary_id='30828.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang dictionary_id='36656.Emir'></cfif><cf_get_lang dictionary_id='57742.Tarih'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
											<cfinput type="text" name="payment_date" id="payment_date" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="payment_date"></span>
										</div>							
									</div>
								</div>
								<div class="form-group" id="item-due_date">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57861.Ortalama Vade'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='54454.Vade Tarihi Girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="due_date" id="due_date" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
										</div>							
									</div>
								</div>
								<div class="form-group" id="item-process">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'>						
									</div>
								</div>
								<div class="form-group" id="item-paymethod">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<cfif not len(attributes.employee_id_new)>
												<cfquery name="get_paymethod" datasource="#DSN#">
													SELECT
														SETUP_PAYMETHOD.PAYMETHOD,
														SETUP_PAYMETHOD.PAYMETHOD_ID
													FROM
														SETUP_PAYMETHOD,
														COMPANY_CREDIT
													WHERE
													<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
														COMPANY_CREDIT.COMPANY_ID = #attributes.member_id# AND
													<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
														COMPANY_CREDIT.CONSUMER_ID = #attributes.consumer_id# AND
													</cfif>
														SETUP_PAYMETHOD.PAYMETHOD_ID = COMPANY_CREDIT.PAYMETHOD_ID AND
														SETUP_PAYMETHOD.PAYMETHOD_STATUS = 1
												</cfquery>
											<cfelse>
												<cfset get_paymethod.recordcount = 0>
											</cfif>
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif get_paymethod.recordcount><cfoutput>#get_paymethod.paymethod_id#</cfoutput></cfif>">
											<input type="text" name="paymethod" id="paymethod"  value="<cfif get_paymethod.recordcount><cfoutput>#get_paymethod.paymethod#</cfoutput></cfif>"> 
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="open_pay_window();"></span>
										</div>
									</div>
								</div>						
							</div>					
							<div class="col col-4 col-md-6 col-xs-12" type="column" index="6" sort="true">
								<cfif attributes.act_type neq 1>					
									<div class="form-group" id="item-contract_id">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sözlesme'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
													<cfquery name="get_contract_head" datasource="#dsn3#">
														SELECT CONTRACT_ID,CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#">
													</cfquery>
													<input type="hidden" name="contract_id" id="contract_id" value="<cfif len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>">
													<input type="text" name="contract_head" id="contract_head" value="<cfif len(attributes.contract_id)><cfoutput>#get_contract_head.contract_head#</cfoutput></cfif>" style="width:150px;">
												<cfelse>
													<input type="hidden" name="contract_id" id="contract_id" value="">
													<input type="text" name="contract_head" id="contract_head" value="">
												</cfif>		
												<span class="input-group-addon icon-ellipsis btnPointer"  onClick="open_contract_window();"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-order_id">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='199.Sipariş'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
													<cfquery name="GET_ORDER" datasource="#dsn3#">
														SELECT ORDER_ID,ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
													</cfquery>
													<input type="hidden" name="order_id" id="order_id" value="<cfif len(attributes.order_id)><cfoutput>#attributes..order_id#</cfoutput></cfif>">
													<input type="text" name="related_order_no" id="related_order_no"  value="<cfif len(attributes.order_id)><cfoutput>#GET_ORDER.ORDER_NUMBER#</cfoutput></cfif>" readonly>
												<cfelse>
													<input type="hidden" name="order_id" id="order_id" value="">
													<input type="text" name="related_order_no" id="related_order_no"  value="" readonly>
												</cfif>	   
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="add_payment_order();"></span>
											</div>             
										</div>                
									</div>   
								</cfif>  		
								<div class="form-group" id="item-action_detail">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<textarea name="action_detail" id="action_detail"></textarea>
									</div>
								</div>
							</div>
						</cf_box_elements>
						<cf_box_footer>
							<cfsavecontent variable="message_kap"><cf_get_lang no ='73.Kapama İşlemi'></cfsavecontent>
								<cfif attributes.act_type eq 1><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message_kap#' add_function='kontrol2(1)'></cfif>
								<cfsavecontent variable="message_ol"><cf_get_lang no ='74.Talep Oluştur'></cfsavecontent>
								<cfif attributes.act_type eq 2><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message_ol#' add_function='kontrol2(2)'></cfif>
								<cfsavecontent variable="message"><cf_get_lang no ="71.Ödeme Emri Ver"></cfsavecontent>
								<cfif attributes.act_type eq 3><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#' add_function='kontrol2(3)'></cfif>
						</cf_box_footer>
					</cf_box>
				<cfelse>
					<input type="hidden" name="correspondence_info" id="correspondence_info" value="<cfoutput>#attributes.correspondence_info#</cfoutput>">
					<cf_basket_form id="payment_actions_bask">
						<cf_box>
								<cf_box_elements>
									<div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
										<div class="form-group" id="item-member_name">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'>*</label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfif isdefined("attributes.employee_id_new")>
														<cfset emp_id = ''>
														<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and len(attributes.employee_id_new)>
															<cfset attributes.employee_id_new = "#attributes.employee_id_new#_#attributes.acc_type_id#">
														<cfelse>
															<cfset attributes.acc_type_id = ''>
														</cfif>
														<cfif listlen(attributes.employee_id_new,'_') eq 2>
															<cfset emp_id = listfirst(attributes.employee_id_new,'_')>
														<cfelse>
															<cfset emp_id = attributes.employee_id_new>
														</cfif>
													<cfelse>
														<cfset attributes.employee_id_new = ''>
													</cfif>
													<input type="hidden" name="member_id" id="member_id" value="<cfif isdefined("attributes.member_id") and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#attributes.member_id#</cfoutput></cfif>">
													<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
													<input type="hidden" name="employee_id_new" id="employee_id_new" value="<cfif isdefined("attributes.employee_id_new")><cfoutput>#attributes.employee_id_new#</cfoutput></cfif>">
													<input type="text" name="member_name" id="member_name"  style="width:160px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,','member_id,consumer_id,employee_id_new','','3','250');" value="<cfif isdefined("attributes.member_id") and len(attributes.member_id) and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#get_par_info(attributes.member_id,1,1,0)#</cfoutput><cfelseif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput><cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput><cfelseif isdefined("attributes.employee_id_new") and len(attributes.employee_id_new)><cfoutput>#get_emp_info(emp_id,0,0,0,attributes.acc_type_id)#</cfoutput></cfif>" autocomplete="off">
													<cfset str_linke_ait2="is_cari_action=1&field_comp_id=add_payment_actions2.member_id&field_name=add_payment_actions2.member_name&field_comp_name=add_payment_actions2.member_name&field_consumer=add_payment_actions2.consumer_id&field_member_name=add_payment_actions2.member_name&field_emp_id=add_payment_actions2.employee_id_new&select_list=1,2,3,9">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&#str_linke_ait2#</cfoutput>');"></span>										
												</div>
											</div>
										</div>
										<div class="form-group" id="item-project_head">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>	
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
													<input type="text" name="project_head" id="project_head"  style="width:160px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_payment_actions.project_id&project_head=add_payment_actions.project_head');"></span>                    
												</div>
											</div>
										</div>
										<div class="form-group" id="item-money_type">
											<label class="col col-4 col-xs-12"><cfif attributes.act_type eq 1><cf_get_lang no ='25.Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang no ='17.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang no ='24.Emir'></cfif><cf_get_lang no ='66.Tutarı'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<input type="text" name="total_difference_amount" id="total_difference_amount" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" maxlength="50" style="width:80px;">
													<span class="input-group-addon no-bg">
														<select name="money_type" id="money_type" style="width:75px;">
															<cfoutput query="get_money_rate">
																<option value="#money#"<cfif isdefined('attributes.money_type') and attributes.money_type eq money>selected</cfif>>#money#</option>
															</cfoutput>
														</select>
													</span>	
												</div>	
											</div>
										</div>
									</div>
									<div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
										<div class="form-group" id="item-payment_date">
											<label class="col col-4 col-xs-12"><cfif attributes.act_type eq 1><cf_get_lang no ='25.Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang no ='17.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang no ='24.Emir'></cfif><cf_get_lang_main no ='330.Tarih'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
													<cfinput type="text" name="payment_date" id="payment_date" style="width:70px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="payment_date">
													</span>	
												</div>
											</div>
										</div>
										<div class="form-group" id="item-due_date">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no ='449.Ortalama Vade'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang no ='68.Vade Tarihi Girmelisiniz'></cfsavecontent>
													<cfinput type="text" name="due_date" id="due_date" style="width:70px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="due_date">
													</span>
												</div>
											</div>
										</div>	
										
										<div class="form-group" id="item-paymethod">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfif not isDefined("attributes.correspondence_info")>
														<cfquery name="get_paymethod" datasource="#DSN#">
															SELECT
																SETUP_PAYMETHOD.PAYMETHOD,
																SETUP_PAYMETHOD.PAYMETHOD_ID
															FROM
																SETUP_PAYMETHOD,
																COMPANY_CREDIT
															WHERE
															<cfif isdefined("attributes.member_id") and len(attributes.member_id)>
																COMPANY_CREDIT.COMPANY_ID = #attributes.member_id# AND
															<cfelse>
																COMPANY_CREDIT.CONSUMER_ID = #attributes.consumer_id# AND
															</cfif>
																SETUP_PAYMETHOD.PAYMETHOD_ID = COMPANY_CREDIT.PAYMETHOD_ID AND
																SETUP_PAYMETHOD.PAYMETHOD_STATUS = 1
														</cfquery>
													<cfelse>
														<cfset get_paymethod.recordcount = 0>
													</cfif>
													<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif get_paymethod.recordcount><cfoutput>#get_paymethod.paymethod_id#</cfoutput></cfif>">
													<input type="text" name="paymethod" id="paymethod" style="width:70px;" value="<cfif get_paymethod.recordcount><cfoutput>#get_paymethod.paymethod#</cfoutput></cfif>"> 
													<span class="input-group-addon icon-ellipsis btnPointer" onClick="open_pay_window();"></span> 
												</div>		
											</div>
										</div>
									</div>
									<div class="col col-4 col-md-6 col-xs-12" type="column" index="3" sort="true">
										<div class="form-group" id="item-process">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='1447.Süreç'>*</label>
											<div class="col col-8 col-xs-12">
												<cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'>
											</div>
										</div>	
										<div class="form-group" id="item-contract_id">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='1725.Sözlesme'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
														<cfquery name="get_contract_head" datasource="#dsn3#">
															SELECT CONTRACT_ID,CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#">
														</cfquery>
														<input type="hidden" name="contract_id" id="contract_id" value="<cfif len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>">
														<input type="text" name="contract_head" id="contract_head" value="<cfif len(attributes.contract_id)><cfoutput>#get_contract_head.contract_head#</cfoutput></cfif>" style="width:150px;">
													<cfelse>
														<input type="hidden" name="contract_id" id="contract_id" value="">
														<input type="text" name="contract_head" id="contract_head" value="">
													</cfif>		
													<span class="input-group-addon icon-ellipsis btnPointer"  onClick="open_contract_window();"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-order_id">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='199.Sipariş'></label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
														<cfquery name="GET_ORDER" datasource="#dsn3#">
															SELECT ORDER_ID,ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
														</cfquery>
															<input type="hidden" name="order_id" id="order_id" value="<cfif len(attributes.order_id)><cfoutput>#attributes..order_id#</cfoutput></cfif>">
															<input type="text" name="related_order_no" id="related_order_no"  value="<cfif len(attributes.order_id)><cfoutput>#GET_ORDER.ORDER_NUMBER#</cfoutput></cfif>" readonly>
													<cfelse>
														<input type="hidden" name="order_id" id="order_id" value="">
														<input type="text" name="related_order_no" id="related_order_no"  value="" readonly>
													</cfif>	   
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="add_payment_order();"></span>
												</div>             
											</div>                
										</div>     							
										<div class="form-group" id="item-action_detail">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
											<div class="col col-8 col-xs-12">
												<textarea name="action_detail" id="action_detail" style="width:180px;height:50px;"></textarea>
											</div>
										</div>
										<div class="form-group" id="item-more_detail">
											<cfsavecontent variable="header"><cf_get_lang dictionary_id='55330.Ek Açıklamalar'></cfsavecontent>
											<cf_seperator id="more_detail" header="#header#">
												<div id="more_detail">
													<div class="col col-12 col-xs-12">
														<cfmodule
															template="/fckeditor/fckeditor.cfm"
															toolbarset="Basic"
															basepath="/fckeditor/"
															instancename="additional_subject"
															valign="top">
													</div>
											</div>
										</div>
									</div>
								</cf_box_elements>	
								<cf_box_footer>
									<cfsavecontent variable="message_kap"><cf_get_lang no ='73.Kapama İşlemi'></cfsavecontent>
									<cfif attributes.act_type eq 1><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message_kap#' add_function='kontrol2(1)'></cfif>
									<cfsavecontent variable="message_ol"><cf_get_lang no ='74.Talep Oluştur'></cfsavecontent>
									<cfif attributes.act_type eq 2><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message_ol#' add_function='kontrol2(2)'></cfif>
									<cfsavecontent variable="message_emir"><cf_get_lang no ="71.Ödeme Emri Ver"></cfsavecontent>
									<cfif attributes.act_type eq 3><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message_emir#' add_function='kontrol2(3)'></cfif>
								</cf_box_footer>
							</cf_box>
					</cf_basket_form>
				</cfif>
				<iframe name="tarihsel" id="tarihsel" width="0" height="0" frameborder="0" scrolling="no"></iframe>
			</cfform>
		</cfif>
	</div>
	<script type="text/javascript">
	<cfif isdefined("checked") and checked eq 1>
		total_amount();
	</cfif>
		function sec_hepsini()
		{
			<cfif isdefined("get_cari_rows") and get_cari_rows.recordcount >
				if(add_payment_actions2.ch_all.checked)
				{
					for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
					{
						var form_field2 = eval("document.add_payment_actions2.is_closed_" + i);
						form_field2.checked = true;
						check_kontrol(form_field2);
					}
				}
				else
				{
					for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
					{
						form_field2 = eval("document.add_payment_actions2.is_closed_" + i);
						form_field2.checked = false;
						check_kontrol(form_field2);
					}				
				}
				total_amount();
			</cfif>
		}
		function open_pay_window()
		{
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_payment_actions2.paymethod_id&field_name=add_payment_actions2.paymethod</cfoutput>&paymentdate_value=' + add_payment_actions2.payment_date.value);
		}
		function open_contract_window()
		{
			if (document.getElementById('member_name').value!="" || (document.getElementById('member_id').value!="" && document.getElementById('consumer_id').value!="" && document.getElementById('employee_id_new').value!=""))
			{    
				var member_id = document.getElementById('member_id').value;
				var consumer_id = document.getElementById('consumer_id').value;
				var employee_id_new = document.getElementById('employee_id_new').value;
				str_irslink = '&field_id=add_payment_actions2.contract_id&field_name=add_payment_actions2.contract_head&member_id='+member_id + '&consumer_id='+consumer_id + '&employee_id_new='+employee_id_new; 
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_contract' + str_irslink);
				return true;
			}
			else (document.getElementById('consumer_id').value=="")
			{
				alert("<cf_get_lang no='40.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
		}
		var control_closed=document.all.control_closed;
		function kontrol2(type_info)
		{ 
			if(document.add_payment_actions2.value_list != undefined && document.add_payment_actions2.value_list.value=="") {
				alert('Kapanacak işlem seçiniz!');
				return false;
			}
			<cfif isDefined("attributes.correspondence_info")>
				if(document.add_payment_actions2.member_name.value=="" || (document.add_payment_actions2.member_id.value=="" && document.add_payment_actions2.consumer_id.value=="" && document.add_payment_actions2.employee_id_new.value==""))
				{
					alert("<cf_get_lang no ='40.Cari Hesap Seçiniz'>!");
					return false;
				}
				if(document.add_payment_actions2.total_difference_amount.value=="")
				{
					alert("<cf_get_lang_main no='1738.Tutar Giriniz'>!");
					return false;
				}
			</cfif>
			if(type_info == 1)
			{
				if(control_closed < 2)
				{
					alert("<cf_get_lang no ='52.Fatura Kapama İçin En Az İki İşlem Seçmelisiniz'>!");
					return false;
				}
				total_difference_amount_ = filterNum(document.getElementById('total_difference_amount').value);
				if(total_difference_amount_ != 0)
				{
					alert("<cf_get_lang no ='50.Borç ve Alacak Toplamları Eşit Olmalı'>");
					return false;
				}
			}
			total_amount();
			convert_to_system_money();
			<cfif not isDefined("attributes.correspondence_info") and isdefined("get_cari_rows")>
				for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
				{
					if(eval('add_payment_actions2.is_closed_'+i).checked)	
					{
						<cfif attributes.act_type eq 2>
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.action_value_'+i).value)))
							{
								alert("<cf_get_lang no ='49.Talep Edilen Tutar İşlem Tutarından Fazla Olamaz'> !");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.h_to_closed_amount_'+i).value)))
							{
								alert("<cf_get_lang no='557.Toplam Talep Belge Tutarını Aşıyor'>");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
						<cfelseif attributes.act_type eq 3>
							if(wrk_round((parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.action_value_'+i).value))))
							{
								alert("<cf_get_lang no ='46.Emir Verilen Tutar İşlem Tutarından Fazla Olamaz'> !");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.h_to_closed_amount_'+i).value)))
							{
								alert("<cf_get_lang no='557.Toplam Talep Belge Tutarını Aşıyor'>");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
						<cfelse>
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.h_to_closed_amount_'+i).value)))
							{
								alert("<cf_get_lang no ='45.İşlem Tutarını Kontrol Ediniz'>");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
						</cfif>
					}
				}
				document.add_payment_actions2.member_id.value = document.add_payment_actions.member_id.value;
				document.add_payment_actions2.consumer_id.value = document.add_payment_actions.consumer_id.value;
				document.add_payment_actions2.employee_id_new.value = document.add_payment_actions.employee_id_new.value;
				document.add_payment_actions2.money_type.value = document.add_payment_actions.money_type.value;
				document.add_payment_actions2.act_type.value = document.add_payment_actions.act_type.value;
				document.add_payment_actions2.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_add_payment_actions&act_type='+type_info;
				if((document.getElementById('total_debt_amount').value == 0 && document.getElementById('total_claim_amount').value == 0) || (document.getElementById('total_debt_amount').value == '' && document.getElementById('total_claim_amount').value == ''))
				{
					alert("<cf_get_lang no ='41.Lütfen Tutarlarınızı Kontrol Ediniz'>");
					return false;
				}
			</cfif>
			unformat_fields();
			return process_cat_control();
		}
		function unformat_fields()
		{
			<cfif not isDefined("attributes.correspondence_info") and isdefined("get_cari_rows")>
				for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
				{
					if(eval('add_payment_actions2.is_closed_'+i).checked)
					{
						eval("add_payment_actions2.to_closed_amount_" + i).value = filterNum(eval("add_payment_actions2.to_closed_amount_" + i).value);
						eval("add_payment_actions2.other_closed_amount_" + i).value = filterNum(eval("add_payment_actions2.other_closed_amount_" + i).value);
					}
				}
				document.add_payment_actions2.total_debt_amount.value = filterNum(document.add_payment_actions2.total_debt_amount.value);
				document.add_payment_actions2.total_claim_amount.value = filterNum(document.add_payment_actions2.total_claim_amount.value);
			</cfif>
			document.add_payment_actions2.total_difference_amount.value = filterNum(document.add_payment_actions2.total_difference_amount.value);
		}
		function check_kontrol(nesne)
		{
			if(nesne.checked)
				control_closed++;
			else
				control_closed--;
		}
		function total_amount()
		{
			var order_total = 0;
			var due_datelist = '';
			var action_datelist = '';
			var value_list ='';
			var total_debt_amount = 0;
			var total_claim_amount = 0;
			<cfif not isDefined("attributes.correspondence_info") and isdefined("get_cari_rows")>
				for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
				{		
					if(eval('add_payment_actions2.is_closed_'+i).checked)	
					{
						if(eval('add_payment_actions2.type_'+i).value == 1)
							total_debt_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
						else
							total_claim_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
						
						bool_alis=eval("document.add_payment_actions2.purchase_sales" + i);
						if(bool_alis.value == 1)
						{
							due_datelist+=","+eval("document.add_payment_actions2.due_date_2_" + i+".value");
							action_datelist+=","+eval("document.add_payment_actions2.action_date_" + i+".value");
							value_list+=","+filterNum(eval("document.add_payment_actions2.to_closed_amount_" + i+".value"));
						}
						if(bool_alis.value == 0)
						{
							order_total += (parseFloat(eval("document.add_payment_actions2.to_closed_amount_" + i+".value")));
						}
						else
						{
							order_total -= (parseFloat(eval("document.add_payment_actions2.to_closed_amount_" + i+".value")));
						}
					}
				}
				document.getElementById('due_datelist').value = due_datelist;
				document.getElementById('action_datelist').value = action_datelist;
				document.getElementById('value_list').value = value_list;
			</cfif>
			
			if(document.getElementById('total_debt_amount') != undefined)
			{
				<cfif not isDefined("attributes.correspondence_info")>
					document.getElementById('total_debt_amount').value = commaSplit(total_debt_amount);
					document.getElementById('total_claim_amount').value = commaSplit(total_claim_amount);
				</cfif>
				document.getElementById('total_difference_amount').value = commaSplit(total_claim_amount-total_debt_amount);
			}
		}
		function convert_to_system_money(i)
		{	
			if(i != undefined)
			{
				if(eval('add_payment_actions2.is_closed_'+i).checked)	
				{	
					rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
					eval('add_payment_actions2.to_closed_amount_'+i).value= commaSplit(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value)*rate2_eleman);
					if(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value) == filterNum(eval('add_payment_actions2.h_to_other_closed_amount_'+i).value))
						eval('add_payment_actions2.to_closed_amount_'+i).value = commaSplit(eval('add_payment_actions2.h_to_closed_amount_'+i).value);
				}
			}
			else
			{
				<cfif isdefined("get_cari_rows")>	
					for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
					{	
						
						rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
						eval('add_payment_actions2.to_closed_amount_'+i).value = commaSplit(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value)*rate2_eleman);
						if(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value) == filterNum(eval('add_payment_actions2.h_to_other_closed_amount_'+i).value))
							eval('add_payment_actions2.to_closed_amount_'+i).value = commaSplit(eval('add_payment_actions2.h_to_closed_amount_'+i).value);
					}
				</cfif>
			}
		}
		function convert_to_other_money(i)
		{	
			if(eval('add_payment_actions2.is_closed_'+i).checked)	
			{
				rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
				eval('add_payment_actions2.other_closed_amount_'+i).value= commaSplit(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)/rate2_eleman);
				if(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value) == filterNum(eval('add_payment_actions2.h_to_closed_amount_'+i).value))
					eval('add_payment_actions2.other_closed_amount_'+i).value = commaSplit(filterNum(eval('add_payment_actions2.h_to_other_closed_amount_'+i).value));
			}
		}
		function add_payment_order() 
		{
			if (document.getElementById('member_name').value!="" || (document.getElementById('member_id').value!="" && document.getElementById('consumer_id').value!="" && document.getElementById('employee_id_new').value!=""))
			{    
				var member_id = document.getElementById('member_id').value;
				var consumer_id = document.getElementById('consumer_id').value;
				var employee_id_new = document.getElementById('employee_id_new').value;
				str_irslink = '&field_id=add_payment_actions2.order_id&field_name=add_payment_actions2.related_order_no&is_purchase=1&member_id='+member_id + '&consumer_id='+consumer_id + '&employee_id_new='+employee_id_new; 
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_orders_list' + str_irslink);
				return true;
			}
			else (document.getElementById('consumer_id').value=="")
			{
				alert("<cf_get_lang no='40.Cari Hesap Seçmelisiniz'> !");
				return false;
			}        
		}
		function kontrol()
		{
			if (document.getElementById('member_name').value=="" || (document.getElementById('member_id').value=="" && document.getElementById('consumer_id').value=="" && document.getElementById('employee_id_new').value==""))
			{
				alert("<cf_get_lang no ='40.Cari Hesap Seçiniz'>!");
				return false;
			}
			return true;
		}
		convert_to_system_money();
		function convertExcel(){
			$( "#process_table td input[type=text]" ).each(function() {
 				$(this).parents('td').text($(this).val());
			});
			TableToExcel.convert(document.getElementById('process_table'));
		}
	</script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
	<cfsetting showdebugoutput="yes"> 
	