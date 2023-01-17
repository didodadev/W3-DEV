<!--- 	Toplu işlemler için yapılan basket sayfası 20080130SM
		paper_type=1  Gelen havale 
		paper_type=2  Giden havale
		paper_type=3  Kasa Tahsilat
		paper_type=4  Kasa Ödeme
		paper_type=5  Toplu Dekont
 --->
<cf_get_lang_set module_name="objects">
<cfif paper_type eq 1>
	<cfset select_input = 'account_id'>
	<cfset auto_paper_type = "incoming_transfer">
<cfelseif paper_type eq 2>
	<cfset select_input = 'account_id'>
	<cfset auto_paper_type = "outgoing_transfer">
<cfelseif paper_type eq 3>
	<cfset select_input = 'cash_action_to_cash_id'>
	<cfset auto_paper_type = "revenue_receipt">
<cfelseif paper_type eq 4>
	<cfset select_input = 'cash_action_from_cash_id'>
	<cfset auto_paper_type = "cash_payment">
<cfelseif paper_type eq 5>
	<cfset select_input = 'action_currency_id'>
	<cfset auto_paper_type = "debit_claim">
</cfif>
<cf_papers paper_type="#auto_paper_type#">
<cfset str_money_bskt_main = session.ep.money>
<cfset rate_round_num_info = session.ep.our_company_info.rate_round_num>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
</cfquery>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cf_grid_list margin="1">
   <thead>
		<tr>
			<th width="25"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
			<th width="25" nowrap="nowrap"><cf_get_lang dictionary_id="57487.No"></th>
			<th width="171" nowrap="nowrap"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</th>
			<th width="96" nowrap="nowrap"><cf_get_lang dictionary_id='57880.Belge No'><cfif ListFind("3,4",paper_type)>*</cfif></th>
			<th width="85" nowrap="nowrap"><cf_get_lang dictionary_id='57673.Tutar'>*</th>
			<th width="92"  nowrap="nowrap"><cf_get_lang dictionary_id='57489.Para Birimi'></th>            
			<th width="100" nowrap="nowrap"><cf_get_lang dictionary_id='58056.Dövizli Tutar'>*</th>
			<th width="92"  nowrap="nowrap"><cf_get_lang dictionary_id='57677.Döviz'> <cf_get_lang dictionary_id='57489.Para Birimi'> *</th>
			<th width="140" nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<cfif paper_type eq 3>
				<th width="150" nowrap="nowrap"><cf_get_lang dictionary_id='33483.Tahsil Eden'>*</th>
			<cfelseif paper_type eq 4>
				<th width="150" nowrap="nowrap"><cf_get_lang dictionary_id='33207.Ödeme Yapan'>*</th>
			</cfif>	
			<th width="152" nowrap="nowrap"><cf_get_lang dictionary_id ='57416.Proje'><cfif isdefined("x_required_project") and x_required_project eq 1>*</cfif></th>
			<th width="152" nowrap="nowrap"><cf_get_lang dictionary_id ='29502.Abone No'></th>
			<cfif session.ep.our_company_info.asset_followup eq 1>
				<th width="160" nowrap="nowrap"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></th>
			</cfif>
			<cfif isdefined("x_contract_show") and x_contract_show eq 1><th width="150" nowrap><cf_get_lang dictionary_id ='29522.Sözleşme'></th></cfif>
			<cfif isDefined("x_select_type_info") and x_select_type_info neq 0><th width="150" nowrap><cfif listfind("2,4",paper_type)><cf_get_lang dictionary_id='58928.Ödeme Tipi'><cfelseif listfind("1,3",paper_type)><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></cfif> <cfif isDefined("x_select_type_info") and x_select_type_info eq 2>*</cfif></th></cfif>
			<cfif paper_type eq 1 or paper_type eq 2>
				<th width="80" nowrap="nowrap"><cf_get_lang dictionary_id='58930.Masraf'></th>
				<th width="150" nowrap="nowrap"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
				<th width="150" nowrap="nowrap"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
			<cfelseif paper_type eq 5>
				<th width="152" nowrap><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</th>
				<cfif isdefined("is_update") or isdefined("is_copy")>
					<th width="143" nowrap="nowrap" id="exp_center_1" <cfif (get_action_detail.action_type_id eq 410 or get_action_detail.action_type_id eq 45) or ((get_action_detail.action_type_id eq 420 or get_action_detail.action_type_id eq 46) and (isdefined("x_project_expence_center") and x_project_expence_center eq 1))>style="display:none;"</cfif>><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
					<th width="143" nowrap="nowrap" id="exp_item_1" <cfif get_action_detail.action_type_id eq 410 or get_action_detail.action_type_id eq 45>style="display:none;"</cfif>><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
					<th width="143" nowrap="nowrap" id="exp_center_2" <cfif (get_action_detail.action_type_id eq 420 or get_action_detail.action_type_id eq 46) or ((get_action_detail.action_type_id eq 410 or get_action_detail.action_type_id eq 45) and (isdefined("x_project_expence_center") and x_project_expence_center eq 1))>style="display:none;"</cfif>><cf_get_lang dictionary_id='58172.Gelir Merkezi'></th>
					<th width="143" nowrap="nowrap" id="exp_item_2" <cfif get_action_detail.action_type_id eq 420 or get_action_detail.action_type_id eq 46>style="display:none;"</cfif>><cf_get_lang dictionary_id='58173.Gelir Kalemi'></th>
				<cfelse>
					<th width="143" nowrap="nowrap" id="exp_center_1"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
					<th width="143" nowrap="nowrap" id="exp_item_1"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
					<th width="143" nowrap="nowrap" id="exp_center_2"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></th>
					<th width="143" nowrap="nowrap" id="exp_item_2"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></th>
				</cfif>
			</cfif>	
		</tr>
     </thead>
     <tbody id="table_bank_cash_process">
		<cfif isdefined("is_update") or isdefined("is_copy")>
			<input name="upd_num" id="upd_num" type="hidden" value="<cfoutput>#get_action_detail.recordcount#</cfoutput>">
			<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_action_detail.recordcount#</cfoutput>">
			<cfset project_id_list=''>
			<cfset employee_id_list=''>
			<cfset exp_center_id_list=''>
			<cfset exp_item_id_list=''>
			<cfset asset_id_list=''>
			<cfset contract_id_list=''>
			<cfoutput query="get_action_detail">
				<cfif ListFind("3,4",paper_type)>
					<cfif len(employee_id) and not listfind(employee_id_list,employee_id)>
						<cfset employee_id_list=listappend(employee_id_list,employee_id)>
					</cfif>
				</cfif>
				<cfif len(project_id) and not listfind(project_id_list,project_id)>
					<cfset project_id_list=listappend(project_id_list,project_id)>
				</cfif>
				<cfif isdefined("assetp_id") and len(assetp_id) and not listfind(asset_id_list,assetp_id)>
					<cfset asset_id_list=listappend(asset_id_list,assetp_id)>
				</cfif>
				<cfif isdefined("contract_id") and len(contract_id) and not listfind(contract_id_list,contract_id)>
					<cfset contract_id_list=listappend(contract_id_list,contract_id)>
				</cfif>
				<cfif paper_type eq 1 or paper_type eq 2>
					<cfif len(expense_center_id) and not listfind(exp_center_id_list,expense_center_id)>
						<cfset exp_center_id_list=listappend(exp_center_id_list,expense_center_id)>
					</cfif>
					<cfif len(expense_item_id) and not listfind(exp_item_id_list,expense_item_id)>
						<cfset exp_item_id_list=listappend(exp_item_id_list,expense_item_id)>
					</cfif>
				<cfelseif paper_type eq 5>
					<cfif len(expense_center_id) and not listfind(exp_center_id_list,expense_center_id)>
						<cfset exp_center_id_list=listappend(exp_center_id_list,expense_center_id)>
					</cfif>
					<cfif len(income_center_id) and not listfind(exp_center_id_list,income_center_id)>
						<cfset exp_center_id_list=listappend(exp_center_id_list,income_center_id)>
					</cfif>
					<cfif len(expense_item_id) and not listfind(exp_item_id_list,expense_item_id)>
						<cfset exp_item_id_list=listappend(exp_item_id_list,expense_item_id)>
					</cfif>
					<cfif len(income_item_id) and not listfind(exp_item_id_list,income_item_id)>
						<cfset exp_item_id_list=listappend(exp_item_id_list,income_item_id)>
					</cfif>
				</cfif>
			</cfoutput>
			<cfif listlen(project_id_list)>
				<cfset project_id_list=listsort(project_id_list,"numeric","ASC",',')>
				<cfquery name="get_project" datasource="#dsn#">
					SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
				</cfquery>
				<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project.PROJECT_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(asset_id_list)>
				<cfset asset_id_list=listsort(asset_id_list,"numeric","ASC",',')>
				<cfquery name="get_asset" datasource="#dsn#">
					SELECT ASSETP,ASSETP_ID FROM ASSET_P WHERE ASSETP_ID IN (#asset_id_list#) ORDER BY ASSETP_ID
				</cfquery>
				<cfset asset_id_list = listsort(listdeleteduplicates(valuelist(get_asset.ASSETP_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(contract_id_list)>
				<cfset contract_id_list=listsort(contract_id_list,"numeric","ASC",',')>
				<cfquery name="getContract" datasource="#dsn3#">
					SELECT CONTRACT_HEAD,CONTRACT_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID IN (#contract_id_list#) ORDER BY CONTRACT_ID
				</cfquery>
				<cfset contract_id_list = listsort(listdeleteduplicates(valuelist(getContract.CONTRACT_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif ListFind("3,4",paper_type)>
				<cfif listlen(employee_id_list)>
					<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",',')>
					<cfquery name="get_employees" datasource="#dsn#">
						SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
					</cfquery>
					<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employees.employee_id,',')),'numeric','ASC',',')>
				</cfif>
			</cfif>
			<cfif paper_type eq 1 or paper_type eq 2 or paper_type eq 5>
				<cfif len(exp_center_id_list)>
					<cfquery name="get_expense_center" datasource="#dsn2#">
						SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#exp_center_id_list#) ORDER BY EXPENSE_ID
					</cfquery>
					<cfset exp_center_id_list = listsort(listdeleteduplicates(valuelist(get_expense_center.expense_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(exp_item_id_list)>
					<cfquery name="get_expense_item" datasource="#dsn2#">
						SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#exp_item_id_list#) ORDER BY EXPENSE_ITEM_ID
					</cfquery>
					<cfset exp_item_id_list = listsort(listdeleteduplicates(valuelist(get_expense_item.expense_item_id,',')),'numeric','ASC',',')>
				</cfif>
			</cfif>
			<cfoutput query="get_action_detail">
				<tr id="frm_row#currentrow#">
					<td nowrap="nowrap">
						<ul class="ui-icon-list">
							<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
							<input type="hidden" name="act_row_id#currentrow#" id="act_row_id#currentrow#" value="#action_id#"><!--- belge kapama işlemlernde sıkıntı oluşturgu için satırlar update edilecek --->
							<li><a href="javascript://" onClick="sil_bank_cash_process('#currentrow#');"><i class="fa fa-minus"></i></a></li>
								<li><a style="cursor:pointer" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>">
									<i class="fa fa-copy" alt="Aynı satırı Eklemek İçin Tıklayınız"></i></a></li>
							<cfif (isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list)) or (isdefined("get_action_detail.bank_order_id") and len(get_action_detail.bank_order_id))>
								<cfquery name="get_bank_order_type" datasource="#dsn2#">
									SELECT BANK_ORDER_TYPE_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.bank_order_id#"> 
								</cfquery>
								<input type="hidden" name="bank_order_process_cat#currentrow#" id="bank_order_process_cat#currentrow#" value="#get_bank_order_type.bank_order_type_id#"> <!--- Gelen Banka Talimatı process type --->
								<input type="hidden" name="bank_order_id#currentrow#" id="bank_order_id#currentrow#" value="#get_action_detail.bank_order_id#">	
							</cfif>
						</ul>
					</td>
					<td><div class="form-group">#currentrow#<input type="hidden" name="row_#currentrow#" id="row_#currentrow#" value="#currentrow#"></div></td>
					<cfif paper_type eq 2 and len(get_action_detail.masraf)>
						<cfset get_action_detail.action_value = get_action_detail.action_value-get_action_detail.masraf>
					</cfif>
					<td nowrap="nowrap">
						<cfif len(action_employee_id)>
							<cfset member_type_ = 'employee'>
							<cfset member_code_ = get_employee_period(action_employee_id,get_action_detail.acc_type_id)>
						<cfelseif len(action_company_id)>
							<cfset member_type_ = 'partner'>
							<cfset member_code_ = get_company_period(action_company_id)>
						<cfelseif len(action_consumer_id)>
							<cfset member_type_ = 'consumer'>
							<cfset member_code_ = get_consumer_period(action_consumer_id)>
						</cfif>
                        <cfset emp_id = get_action_detail.action_employee_id>
						<cfif isdefined("get_action_detail.acc_type_id") and len(get_action_detail.acc_type_id)>
                            <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
						</cfif>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="related_action_id#currentrow#" id="related_action_id#currentrow#" value="<cfif isdefined("RELATION_ACTION_ID")>#RELATION_ACTION_ID#</cfif>">
								<input type="hidden" name="related_action_type#currentrow#" id="related_action_type#currentrow#" value="<cfif isdefined("RELATION_ACTION_TYPE_ID")>#RELATION_ACTION_TYPE_ID#</cfif>">
								<input type="hidden" name="avans_id#currentrow#" id="avans_id#currentrow#" value="<cfif isdefined("avans_id")>#avans_id#</cfif>">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="#member_code_#">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#member_type_#">
								<input type="hidden" name="action_employee_id#currentrow#" id="action_employee_id#currentrow#" value="#emp_id#">
								<input type="hidden" name="action_company_id#currentrow#" id="action_company_id#currentrow#" value="#get_action_detail.action_company_id#">
								<input type="hidden" name="action_consumer_id#currentrow#" id="action_consumer_id#currentrow#" value="#get_action_detail.action_consumer_id#">
								<input type="text" name="comp_name#currentrow#" id="comp_name#currentrow#" value="<cfif len(get_action_detail.action_company_id)>#get_par_info(get_action_detail.action_company_id,1,1,0)#<cfelseif len(get_action_detail.action_consumer_id)>#get_cons_info(get_action_detail.action_consumer_id,0,0)#<cfelse>#get_emp_info(get_action_detail.action_employee_id,0,0,0,get_action_detail.acc_type_id)#</cfif>" class="boxtext" onFocus="AutoComplete_Create('comp_name#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','','ACCOUNT_CODE,MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','member_code#currentrow#,member_type#currentrow#,action_company_id#currentrow#,action_consumer_id#currentrow#,action_employee_id#currentrow#','','3','250','emp_comp_and_account#currentrow#');">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_company(#currentrow#);"></span>
							</div>
						</div>
					</td>
					<cfif isdefined("is_copy")>
						<td><div class="form-group"><input type="text" id="paper_number#currentrow#" name="paper_number#currentrow#" value="<cfif len(paper_number)>#paper_code & '-' & paper_number#</cfif>" class="boxtext"></div></td>
						<cfif len(paper_number)>
							<cfset paper_number = paper_number + 1>
						</cfif>
					<cfelse>
						<td><div class="form-group"><input type="text" id="paper_number#currentrow#" name="paper_number#currentrow#" value="#get_action_detail.paper_no#" class="boxtext"></div></td>
					</cfif>				
					<td nowrap="nowrap"><div class="form-group"><input type="hidden" name="system_amount#currentrow#" id="system_amount#currentrow#" value=""><input type="text" name="action_value#currentrow#" id="action_value#currentrow#" value="#TLFormat(get_action_detail.action_value)#" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="kur_ekle_f_hesapla('#select_input#',false,#currentrow#);"></div></td>
					<td nowrap="nowrap"><div class="form-group"><input type="text" name="tl_value_#currentrow#" id="tl_value_#currentrow#" class="box" readonly="readonly" value=""></div></td>
                    <td nowrap="nowrap"><div class="form-group"><input type="text" name="action_value_other#currentrow#" id="action_value_other#currentrow#" value="#TLFormat(get_action_detail.action_value_other)#" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="kur_hesapla2('#select_input#');"></div></td>
					<td>
						<div class="form-group">
							<select name="money_id#currentrow#" id="money_id#currentrow#" class="boxtext" onChange="kur_ekle_f_hesapla('#select_input#',false,#currentrow#);">
							<cfloop query="get_money">
								<option value="#get_money.money#;#get_money.rate1#;#get_money.rate2#" <cfif get_money.money eq get_action_detail.action_currency>selected</cfif>>#get_money.money#</option>
							</cfloop>
							</select>
						</div>
					</td>
					<td><div class="form-group"><input type="text" name="action_detail#currentrow#" id="action_detail#currentrow#" value="#get_action_detail.action_detail#" class="boxtext"></div></td>
					<!--- tahsil eden --->
					<cfif ListFind("3,4",paper_type)>
						<td nowrap="nowrap">
							<div class="form-group">
								<div class="input-group">
									<input name="employee_id#currentrow#" id="employee_id#currentrow#" type="hidden" value="#get_action_detail.employee_id#" class="boxtext">
									<input name="employee_name#currentrow#" id="employee_name#currentrow#" value="<cfif len(employee_id_list)>#get_employees.employee_name[listfind(employee_id_list,employee_id,',')]# #get_employees.employee_surname[listfind(employee_id_list,employee_id,',')]#</cfif>" class="boxtext"  onFocus="AutoComplete_Create('employee_name#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id#currentrow#','add_process','3','125');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_employee(#currentrow#);"></span>
								</div>
							</div>
						</td>
					</cfif>
					<td nowrap>
						<div class="form-group">
							<div class="input-group">
								<input name="project_id#currentrow#" id="project_id#currentrow#" type="hidden" value="#get_action_detail.project_id#" class="boxtext">
								<input name="project_head#currentrow#" type="text" id="project_head#currentrow#" value="<cfif len(project_id_list)>#get_project.project_head[listfind(project_id_list,project_id,',')]#</cfif>" class="boxtext"  onFocus="AutoComplete_Create('project_head#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id#currentrow#','','3','200');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_project(#currentrow#);"></span>
							</div>
						</div>
					</td>
					<td nowrap>
						<div class="form-group">
							<div class="input-group">
							<cf_wrk_subscriptions fieldId='subscription_id#currentrow#' fieldName='subscription_no#currentrow#' form_name='add_process' value="#iif(isdefined("get_action_detail.subscription_id") and len(get_action_detail.subscription_id),'get_action_detail.subscription_id',de(''))#"  subscription_no='#get_subscription_no(iif(isdefined("get_action_detail.subscription_id") and len(get_action_detail.subscription_id),'get_action_detail.subscription_id',de(0)))#'>
						</div>
					</div>
					</td>
					<cfif session.ep.our_company_info.asset_followup eq 1>
						<td nowrap>
							<div class="form-group">
								<div class="input-group">
									<input name="asset_id#currentrow#" id="asset_id#currentrow#" type="hidden" value="<cfif isdefined("get_action_detail.assetp_id")>#get_action_detail.assetp_id#</cfif>" class="boxtext">
									<input id="asset_name#currentrow#" name="asset_name#currentrow#" onFocus="autocomp_asset(#currentrow#);" value="<cfif isdefined("get_action_detail.assetp_id") and len(asset_id_list)>#get_asset.assetp[listfind(asset_id_list,get_action_detail.assetp_id,',')]#</cfif>" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_asset(#currentrow#);"></span>
								</div>
							</div>
						</td>
					</cfif>
					<cfif isdefined("x_contract_show") and x_contract_show eq 1>
						<td nowrap="nowrap">
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="contract_id#currentrow#" id="contract_id#currentrow#" value="<cfif isdefined("get_action_detail.contract_id")>#get_action_detail.contract_id#</cfif>">
									<input type="text" name="contract_no#currentrow#" id="contract_no#currentrow#" value="<cfif isdefined("get_action_detail.contract_id") and len(contract_id_list)>#getContract.contract_head[listfind(contract_id_list,get_action_detail.contract_id,',')]#</cfif>" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_contract(#currentrow#);"></span>
								</div>
							</div>
						</td>
					</cfif>
					<cfif isDefined("x_select_type_info") and x_select_type_info neq 0>
						<td>
							<div class="form-group">
								<select name="special_definition_id#currentrow#" id="special_definition_id#currentrow#" class="boxtext">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_special_definition">
										<option value="#special_definition_id#" <cfif (len(get_action_detail.special_definition_id) and get_special_definition.special_definition_id eq get_action_detail.special_definition_id) or (not len(get_action_detail.special_definition_id) and listfind("2,4",paper_type) and isdefined('attributes.payment_type_id') and get_special_definition.special_definition_id eq attributes.payment_type_id)>selected</cfif>>#get_special_definition.special_definition#</option>
									</cfloop>
								</select>
							</div>
						</td>
					</cfif>
					<cfif paper_type eq 1 or paper_type eq 2>
						<td  nowrap="nowrap">
							<div class="form-group">
								<input type="text" name="expense_amount#currentrow#" id="expense_amount#currentrow#" value="#TLFormat(get_action_detail.masraf)#" onkeyup="return(FormatCurrency(this,event));" class="box">
							</div>
						</td>
						<td nowrap>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#" >
									<input type="text" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" onFocus="exp_center(#currentrow#,1);" value="<cfif len(exp_center_id_list)>#get_expense_center.expense[listfind(exp_center_id_list,expense_center_id,',')]#</cfif>" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_exp(#currentrow#);"></span>
								</div>
							</div>
						</td>
						<td nowrap>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
									<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" value="<cfif len(exp_item_id_list)>#get_expense_item.expense_item_name[listfind(exp_item_id_list,expense_item_id,',')]#</cfif>" onFocus="exp_item(#currentrow#,1);" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_item(#currentrow#);"></span>
								</div>
							</div>
						</td>
					<cfelseif paper_type eq 5>
						<td nowrap="nowrap">
							<div class="form-group">
								<div class="input-group">
									<input type="text"  name="action_account_code#currentrow#" id="action_account_code#currentrow#" class="boxtext"  value="#get_action_detail.action_account_code#" onFocus="autocomp_account(#currentrow#);">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_acc2(#currentrow#);"></span>
								</div>
							</div>
						</td>
						<td nowrap="nowrap" id="expense_center_id_1#currentrow#" <cfif (get_action_detail.action_type_id eq 410 or get_action_detail.action_type_id eq 45) or ((get_action_detail.action_type_id eq 420 or get_action_detail.action_type_id eq 46) and (isdefined("x_project_expence_center") and x_project_expence_center eq 1))> style="display:none;"</cfif>>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="expense_center_id#currentrow#" value="#expense_center_id#" id="expense_center_id#currentrow#">
									<input type="text" id="expense_center_name#currentrow#" name="expense_center_name#currentrow#"  onFocus="exp_center(#currentrow#,1);" value="<cfif len(exp_center_id_list)>#get_expense_center.expense[listfind(exp_center_id_list,expense_center_id,',')]#</cfif>" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_exp(#currentrow#);"></span>
								</div>
							</div>
						</td>
						<td nowrap="nowrap" id="expense_item_id_1#currentrow#" <cfif get_action_detail.action_type_id eq 410 or get_action_detail.action_type_id eq 45> style="display:none;"</cfif>>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="expense_item_id#currentrow#" value="#expense_item_id#" id="expense_item_id#currentrow#">
									<input type="text" id="expense_item_name#currentrow#" name="expense_item_name#currentrow#" value="<cfif len(exp_item_id_list)>#get_expense_item.expense_item_name[listfind(exp_item_id_list,expense_item_id,',')]#</cfif>" onFocus="exp_item(#currentrow#,1);" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_item(#currentrow#);"></span>
								</div>
							</div>
						</td>
						<td nowrap="nowrap" id="income_center_id_1#currentrow#" <cfif (get_action_detail.action_type_id eq 420 or get_action_detail.action_type_id eq 46) or ((get_action_detail.action_type_id eq 410 or get_action_detail.action_type_id eq 45) and (isdefined("x_project_expence_center") and x_project_expence_center eq 1))> style="display:none;"</cfif>>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="income_center_id#currentrow#" value="#income_center_id#" id="income_center_id#currentrow#">
									<input type="text" id="income_center_name#currentrow#" name="income_center_name#currentrow#" onFocus="exp_center(#currentrow#,2);" value="<cfif len(exp_center_id_list)>#get_expense_center.expense[listfind(exp_center_id_list,income_center_id,',')]#</cfif>" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_exp2(#currentrow#);"></span>
								</div>
							</div>
						</td>
						<td nowrap="nowrap" id="income_item_id_1#currentrow#" <cfif get_action_detail.action_type_id eq 420 or get_action_detail.action_type_id eq 46> style="display:none;"</cfif>>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="income_item_id#currentrow#" value="#income_item_id#" id="income_item_id#currentrow#">
									<input type="text" id="income_item_name#currentrow#" name="income_item_name#currentrow#" value="<cfif len(exp_item_id_list)>#get_expense_item.expense_item_name[listfind(exp_item_id_list,income_item_id,',')]#</cfif>" onFocus="exp_item(#currentrow#,2);" class="boxtext">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_item2(#currentrow#);"></span>
								</div>
							</div>
						</td>
					</cfif>
				</tr>
			</cfoutput>		
		<cfelse>
        	<tr style="display:none;">
            	<td>
					<input name="upd_num" type="hidden" value="0" id="upd_num">
					<input name="record_num" id="record_num" type="text" value="0">
                </td>
            </tr>
		</cfif>
     </tbody>
  </cf_grid_list>
  <br>
	<div class="ui-row">
		<div id="sepetim_total" class="padding-0">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
				<div class="totalBox">
					<div class="totalBoxHead font-grey-mint">
						<span class="headText"> <cf_get_lang dictionary_id='57677.Dövizler'></span>
						<div class="collapse">
							<span class="icon-minus"></span>
						</div>
					</div>
				<div class="row">
					<cfoutput>
						<div class="totalBoxBody">
					<table cellspacing="0" id="money_rate_table"> 
						<input id="kur_say" type="hidden" name="kur_say" value="#get_money.recordcount#">
						<tbody>
						<cfloop query="get_money">
							<cfif isdefined("xml_money_type") and xml_money_type eq 0>
								<cfset currency_rate_ = RATE2>
							<cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
								<cfset currency_rate_ = RATE3>
							<cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
								<cfset currency_rate_ = RATE2>
							</cfif>	                
							<cfif is_selected eq 1><cfset str_money_bskt_main = money></cfif>
						<tr>
							<cfif session.ep.rate_valid eq 1>
								<cfset readonly_info = "yes">
							<cfelse>
								<cfset readonly_info = "no">
							</cfif>
						<input type="hidden" name="hidden_rd_money_#currentrow#" value="#money#" id="hidden_rd_money_#currentrow#">
						<input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#" id="txt_rate1_#currentrow#">
						<td nowrap="nowrap"><input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif str_money_bskt_main eq money>checked</cfif>></td>
						<td nowrap="nowrap"><label>#money#</label></td>
						<td nowrap="nowrap">#TLFormat(rate1,0)# /</td>
						<td nowrap="nowrap"><input type="text" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:100%;" onKeyUp="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="kur_ekle_f_hesapla('#select_input#',false);"></td>
						</tr>	
					</cfloop>		
					</tbody></table>
				</div>
				</cfoutput>
				</div>
			</div>
		</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<div id="sepetim_total" class="padding-0">
					<div class="totalBox">
					<div class="totalBoxHead font-grey-mint">
						<span class="headText"><cf_get_lang dictionary_id='33046.Sistem Para Birimi'></span>
						<div class="collapse">
							<span class="icon-minus"></span>
						</div>
					</div>
					<div class="totalBoxBody">       
						<table>
							<tbody>
							<tr>
								<td nowrap="nowrap" class="txtbold"> <cf_get_lang dictionary_id='57492.Toplam'> </td>
								<td style="text-align:right;"><input type="text" name="tl_value1" id="tl_value1" style="width:55px;" class="box" readonly="readonly" value="<cfoutput>#session.ep.money#</cfoutput>"></td>
								<td style="text-align:right;" nowrap="nowrap">
									<input type="text" name="total_amount" class="box" readonly value="0" id="total_amount" class="box" style="width:100px;">
								</td>
							</tr> 
						</tbody></table>            
					</div>
				</div>
				</div>
			</div>
		</div>
    </div>
<cfif isdefined("is_update") or isdefined("is_copy")>
	<cfset paper_code = paper_code>
	<cfset paper_number = paper_number>
<cfelse>
	<cfif paper_type neq 3>
		<cfquery name="get_row_multi_paper" datasource="#dsn3#">
			SELECT * FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
		</cfquery>
	<cfelse>
		<cfquery name="get_row_multi_paper" datasource="#dsn3#">
			SELECT * FROM PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC
		</cfquery>
	</cfif>
	<cfif get_row_multi_paper.recordcount and len(evaluate('get_row_multi_paper.#auto_paper_type#_NUMBER'))>
		<cfset paper_code = evaluate('get_row_multi_paper.#auto_paper_type#_NO')>
		<cfset paper_number = evaluate('get_row_multi_paper.#auto_paper_type#_NUMBER') +1>
	<cfelse>
		<cfset paper_code = "">
		<cfset paper_number = "">
	</cfif>
</cfif>
<script type="text/javascript">
	<cfoutput>
		<cfif not (len(paper_code) and len(paper_number))>
			var auto_paper_code = "";
			var auto_paper_number = "";
		<cfelse>
			var auto_paper_code = "#paper_code#-";
			var auto_paper_number = "#paper_number#";
		</cfif>
		<cfif isdefined("is_update") or isdefined("is_copy")>
			var all_action_list = "#ListDeleteDuplicates(ValueList(get_action_detail.action_id,','))#";
			row_count=#get_action_detail.recordcount#;
		<cfelse>
			row_count=0;
		</cfif>
	</cfoutput>
	
	record_exist=0;
	function sil_bank_cash_process(sy)
	{
		var my_element=document.getElementById('row_kontrol'+sy);	
		my_element.value=0;	
		hide('frm_row'+sy);
		toplam_hesapla();		
	}

	function pencere_ac_company(sira_no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&row_no='+ sira_no +'<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,2,3,9&field_comp_id=add_process.action_company_id'+ sira_no +'&field_member_name=add_process.comp_name'+ sira_no +'&field_member_account_code=add_process.member_code'+ sira_no +'&field_type=add_process.member_type' + sira_no + '&field_name=add_process.comp_name' + sira_no +'&field_emp_id=add_process.action_employee_id'+ sira_no +'&field_consumer=add_process.action_consumer_id'+ sira_no +'&call_function=emp_comp_and_account('+sira_no+')','list');
	}

	function open_subscription(sira_no){
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_process.subscription_id'+ sira_no +'&field_no=add_process.subscription_no'+ sira_no,'list','popup_list_subscription');
	}
	function add_row(amount,other_money,member_code,member_type,action_company_id,action_consumer_id,action_employee_id,comp_name,acc_code,paper_no,exp_center_id,exp_item_id,exp_center_name,exp_item_name,inc_center_id,inc_item_id,inc_center_name,inc_item_name,project_id,project_name,expense_amount,action_detail,employee_id,employee_name,asset_id,asset_name,special_definition_id,contract_id,contract_head,avans_id,other_amount,related_cari_action_id,related_action_id,related_action_type,subscription_id,subscription_no)
	{
		if(amount == undefined) amount = 0;
		if(other_amount == undefined) other_amount = 0;
		if(expense_amount == undefined) expense_amount = 0;
		if(other_money == undefined) other_money = '<cfoutput>#session.ep.money#</cfoutput>';
		if(member_code == undefined) member_code = '';
		if(acc_code == undefined) acc_code = '';
		if(action_company_id == undefined) action_company_id = '';
		if(action_consumer_id == undefined) action_consumer_id = '';
		if(action_employee_id == undefined) action_employee_id = '';
		if(comp_name == undefined) comp_name = '';
		if(paper_no == undefined) paper_no = '';
				
		if(exp_center_id == undefined) exp_center_id = '';
		if(exp_item_id == undefined) exp_item_id = '';
		if(exp_center_name == undefined) exp_center_name = '';
		if(exp_item_name == undefined) exp_item_name = '';
		
		if(inc_center_id == undefined) inc_center_id = '';
		if(inc_item_id == undefined) inc_item_id = '';
		if(inc_center_name == undefined) inc_center_name = '';
		if(inc_item_name == undefined) inc_item_name = '';
		
		if(project_id == undefined) project_id = '';
		if(project_name == undefined) project_name = '';
		if(action_detail == undefined) action_detail = '';
		
		if(employee_id == undefined) employee_id = '<cfoutput>#session.ep.userid#</cfoutput>';
		if(employee_name == undefined) employee_name = '<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>';
		if(related_action_id == undefined) related_action_id = '';
		if(related_action_type == undefined) related_action_type = '';
		if(subscription_id == undefined) subscription_id = '';
		if(subscription_no == undefined) subscription_no = '';

		if(asset_id == undefined) asset_id = '';
		if(asset_name == undefined) asset_name = '';
		if(special_definition_id == undefined) special_definition_id = '';
		if (special_definition_id == '') <cfif listfind("2,4",paper_type) and isdefined('attributes.payment_type_id')>special_definition_id = '<cfoutput>#attributes.payment_type_id#</cfoutput>';<cfelse>special_definition_id = '';</cfif>
		if(contract_id == undefined) contract_id = '';
		if(contract_head == undefined) contract_head = '';
		if(avans_id == undefined) avans_id = '';
		if(related_cari_action_id == undefined) related_cari_action_id = '';
		row_count++;
		var newRow;
		var newCell;	
		document.getElementById('record_num').value=row_count;
		newRow = document.getElementById("table_bank_cash_process").insertRow(document.getElementById("table_bank_cash_process").rows.length);
		
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.setAttribute("class","nohover");
		newRow.id = "frm_row" + row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<ul class="ui-icon-list"><input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><li><a onclick="sil_bank_cash_process(' + row_count + ');"><i class="fa fa-minus"></i></a></li><li><a style="cursor:pointer" onclick="copy_row('+row_count+');"><i class="fa fa-copy" alt="Aynı satırı Eklemek İçin Tıklayınız"></i></a></li>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<span id="rowNr">'+row_count+'<input type="hidden" name="row_' + row_count +'" id="row_' + row_count +'" value="'+row_count+'" readonly="readonly" class="box"></span>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="related_action_id' + row_count +'" id="related_action_id' + row_count +'" value="'+related_action_id+'"><input type="hidden" name="related_action_type' + row_count +'" id="related_action_type' + row_count +'" value="'+related_action_type+'"><input type="hidden" name="avans_id' + row_count +'" id="avans_id' + row_count +'" value="'+avans_id+'"><input type="hidden" name="related_cari_action_id' + row_count +'" id="related_cari_action_id' + row_count +'" value="'+related_cari_action_id+'"><input type="hidden" name="member_code' + row_count +'" id="member_code' + row_count +'" value="'+member_code+'">';
		newCell.innerHTML += '<div class="form-group"><div class="input-group"><input type="hidden" name="member_type' + row_count +'" id="member_type' + row_count +'" value="'+member_type+'"><input type="hidden" name="action_company_id' + row_count +'" id="action_company_id' + row_count +'"  value="'+action_company_id+'"><input type="hidden" name="action_consumer_id' + row_count +'" id="action_consumer_id' + row_count +'"  value="'+action_consumer_id+'"><input type="hidden" name="action_employee_id' + row_count +'" id="action_employee_id' + row_count +'"  value="'+action_employee_id+'"><input type="text" name="comp_name' + row_count +'" id="comp_name' + row_count +'" onFocus="autocomp('+row_count+');"  value="'+comp_name+'"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_company('+ row_count +');"></span></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+auto_paper_code + auto_paper_number+'"  class="boxtext"></div>';
		if(auto_paper_number != '')
			auto_paper_number++;

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="system_amount' + row_count +'" id="system_amount'+ row_count + '" value="0"><input type="text" name="action_value' + row_count +'" id="action_value' + row_count + '" value="'+commaSplit(amount)+'" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="tl_value_' + row_count +'" id="tl_value_' + row_count +'" class="box" readonly="readonly" value="'+document.getElementById('tl_value1').value+'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="action_value_other' + row_count +'" id="action_value_other' + row_count + '" value="'+commaSplit(other_amount)+'" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="kur_hesapla2(\'<cfoutput>#select_input#</cfoutput>\');"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<div class="form-group"><select name="money_id' + row_count  +'" id="money_id' + row_count + '" class="boxtext" onChange="kur_ekle_f_hesapla(\'<cfoutput>#select_input#</cfoutput>\',false,'+row_count+');">';
		<cfoutput query="get_money">
			if('#money#' == other_money)
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#" selected>#money#</option>';
			else
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="action_detail' + row_count +'" id="action_detail' + row_count + '" value="'+action_detail+'" class="boxtext"></div>';
		<cfif ListFind("3,4",paper_type)>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" name="employee_name'+ row_count +'" id="employee_name'+ row_count +'" onFocus="autocomp_employee('+row_count+');" value="'+employee_name+'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_employee('+ row_count +');"></span></div></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+project_id+'"><input type="text"  name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="'+project_name+'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value="'+subscription_id+'" /><input type="text" name="subscription_no'+ row_count +'" id="subscription_no'+ row_count +'" value="'+subscription_no+'" /><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="open_subscription('+ row_count +')"></span></div></div>';
	
		<cfif session.ep.our_company_info.asset_followup eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="asset_id'+ row_count +'" name="asset_id'+ row_count +'" value="'+asset_id+'"><input type="text" id="asset_name'+ row_count +'" name="asset_name'+ row_count +'" value="'+asset_name+'" class="boxtext" onFocus="autocomp_asset('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_asset('+ row_count +');"></span></div></div>';
		</cfif>
		<cfif isdefined("x_contract_show") and x_contract_show eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="contract_id'+ row_count +'" name="contract_id'+ row_count +'" value="'+contract_id+'"><input type="text" id="contract_no'+ row_count +'" name="contract_no'+ row_count +'" value="'+contract_head+'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_contract('+ row_count +');"></span></div></div>';
		</cfif>
		<cfif isDefined("x_select_type_info") and x_select_type_info neq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<div class="form-group"><select name="special_definition_id' + row_count  +'" id="special_definition_id' + row_count  +'" class="boxtext"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option></div>';
			<cfoutput query="GET_SPECIAL_DEFINITION">
			if('#SPECIAL_DEFINITION_ID#' == special_definition_id)
				a += '<option value="#SPECIAL_DEFINITION_ID#" selected>#SPECIAL_DEFINITION#</option>';
			else
				a += '<option value="#SPECIAL_DEFINITION_ID#">#SPECIAL_DEFINITION#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select></div>';
		</cfif>
		<cfif paper_type eq 1 or paper_type eq 2>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="expense_amount' + row_count +'" id="expense_amount' + row_count +'" value="'+commaSplit(expense_amount)+'" onkeyup="return(FormatCurrency(this,event));" class="box"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" value="'+exp_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'"  onFocus="exp_center('+row_count+',1);" value="'+exp_center_name+'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_exp('+ row_count +');"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" value="'+exp_item_id+'" id="expense_item_id' + row_count +'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" onFocus="exp_item('+row_count+',1);" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_item('+ row_count +');"></span></div></div>';
		<cfelseif paper_type eq 5>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text"  name="action_account_code' + row_count +'" id="action_account_code'+ row_count +'" class="boxtext"  onFocus="autocomp_account('+row_count+');" value="'+acc_code+'"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_acc2('+ row_count +');"></span></div></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" value="'+exp_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'"  onFocus="exp_center('+row_count+',1);" value="'+exp_center_name+'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_exp('+ row_count +');"></span></div></div>';
			newCell.id = 'expense_center_id_1' + row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" value="'+exp_item_id+'" id="expense_item_id' + row_count +'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" onFocus="exp_item('+row_count+',1);" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_item('+ row_count +');"></span></div></div>';
			newCell.id = 'expense_item_id_1' + row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="income_center_id' + row_count +'" value="'+inc_center_id+'" id="income_center_id' + row_count +'"><input type="text" id="income_center_name' + row_count +'" name="income_center_name' + row_count +'" onFocus="exp_center('+row_count+',2);" value="'+inc_center_name+'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_exp2('+ row_count +');"></span></div></div>';
			newCell.id = 'income_center_id_1' + row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="income_item_id' + row_count +'" value="'+inc_item_id+'" id="income_item_id' + row_count +'"><input type="text" id="income_item_name' + row_count +'" name="income_item_name' + row_count +'" value="'+inc_item_name+'" onFocus="exp_item('+row_count+',2);" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_item2('+ row_count +');"></span></div></div>';
			newCell.id = 'income_item_id_1' + row_count;

			ayarla_gizle_goster();
			<cfif not isdefined("attributes.is_other_act")>
				kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',true,row_count);
			</cfif>
		</cfif>
	}
	function copy_row(no_info)
	{
		member_code = document.getElementById('member_code' + no_info).value;
		member_type = document.getElementById('member_type' + no_info).value;
		comp_name = document.getElementById('comp_name' + no_info).value;
		action_company_id = document.getElementById('action_company_id' + no_info).value; 
		action_consumer_id = document.getElementById('action_consumer_id' + no_info).value; 	
		action_employee_id = document.getElementById('action_employee_id' + no_info).value;
		paper_number = document.getElementById('paper_number' + no_info).value;
		system_amount = document.getElementById('system_amount' + no_info).value;
		if(filterNum(document.getElementById('action_value' + no_info).value) > 0 )
			action_value = filterNum(document.getElementById('action_value' + no_info).value,'<cfoutput>#rate_round_num_info#</cfoutput>');else action_value = 0;
		action_value_other = document.getElementById('action_value_other' + no_info).value;
		money_id = list_getat(document.getElementById('money_id' + no_info).value,1,';');
		action_detail = document.getElementById('action_detail' + no_info).value;
		project_id = document.getElementById('project_id' + no_info).value;
		project_head = document.getElementById('project_head' + no_info).value;
		subscription_id = document.getElementById('subscription_id' + no_info).value;
		subscription_no = document.getElementById('subscription_no' + no_info).value;
		<cfif ListFind("3,4",paper_type)>
			employee_id = document.getElementById('employee_id' + no_info).value;
			employee_name = document.getElementById('employee_name' + no_info).value;
		<cfelse>
			employee_id = '';
			employee_name = '';
		</cfif>
		<cfif session.ep.our_company_info.asset_followup eq 1>
			asset_id = document.getElementById('asset_id' + no_info).value;
			asset_name = document.getElementById('asset_name' + no_info).value;
		<cfelse>
			asset_id = '';
			asset_name = '';
		</cfif>
		<cfif isdefined("x_contract_show") and x_contract_show eq 1>
			contract_id = document.getElementById('contract_id' + no_info).value;
			contract_head = document.getElementById('contract_no' + no_info).value;
		<cfelse>
			contract_id = '';
			contract_head = '';
		</cfif>
		<cfif isDefined("x_select_type_info") and x_select_type_info neq 0>
			special_definition_id = document.getElementById('special_definition_id' + no_info).value;
		<cfelse>
			special_definition_id = '';
		</cfif>
		<cfif paper_type eq 1 or paper_type eq 2>
			if(filterNum(document.getElementById('expense_amount' + no_info).value) > 0 ) expense_amount = filterNum(document.getElementById('expense_amount' + no_info).value,'<cfoutput>#rate_round_num_info#</cfoutput>');else expense_amount = 0;
			expense_center_id = document.getElementById('expense_center_id' + no_info).value;
			expense_center_name = document.getElementById('expense_center_name' + no_info).value;
			expense_item_id = document.getElementById('expense_item_id' + no_info).value;
			expense_item_name = document.getElementById('expense_item_name' + no_info).value;
			action_account_code = '';
			income_center_id = '';
			income_center_name = '';
			income_item_id = '';
			income_item_name = '';
		<cfelse>
			expense_amount = '';
			expense_center_id = '';
			expense_center_name = '';
			expense_item_id = '';
			expense_item_name = '';
		</cfif>
		<cfif paper_type eq 5>
			action_account_code = document.getElementById('action_account_code' + no_info).value;
			expense_center_id = document.getElementById('expense_center_id' + no_info).value;
			expense_center_name = document.getElementById('expense_center_name' + no_info).value;
			expense_item_id = document.getElementById('expense_item_id' + no_info).value;
			expense_item_name = document.getElementById('expense_item_name' + no_info).value;
			income_center_id = document.getElementById('income_center_id' + no_info).value;
			income_center_name = document.getElementById('income_center_name' + no_info).value;
			income_item_id = document.getElementById('income_item_id' + no_info).value;
			income_item_name = document.getElementById('income_item_name' + no_info).value;
		<cfelseif paper_type neq 2 and paper_type neq 1>
			action_account_code = '';
			expense_center_id = '';
			expense_center_name = '';
			expense_item_id = '';
			expense_item_name = '';
			income_center_id = '';
			income_center_name = '';
			income_item_id = '';
			income_item_name = '';
		</cfif>
		add_row(action_value,money_id,member_code,member_type,action_company_id,action_consumer_id,action_employee_id,comp_name,action_account_code,paper_number,expense_center_id,expense_item_id,expense_center_name,expense_item_name,income_center_id,income_item_id,income_center_name,income_item_name,project_id,project_head,expense_amount,action_detail,employee_id,employee_name,asset_id,asset_name,special_definition_id,contract_id,contract_head,'',action_value_other,subscription_id,subscription_no)
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false,row_count);	
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_process.action_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_process.expense_center_id' + no +'&field_name=add_process.expense_center_name' + no,'list');
	}
	function pencere_ac_item(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_process.expense_item_id' + no +'&field_name=add_process.expense_item_name' + no,'list');
	}
	function pencere_ac_exp2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_process.income_center_id' + no +'&field_name=add_process.income_center_name' + no,'list');
	}
	function pencere_ac_item2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_process.income_item_id' + no +'&field_name=add_process.income_item_name' + no + '&is_income=1','list');
	}
	function pencere_ac_asset(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_process.asset_id' + no +'&field_name=add_process.asset_name' + no +'&event_id=0&motorized_vehicle=0','list');
	}
	function pencere_ac_contract(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_contract&field_id=add_process.contract_id' + no +'&field_name=add_process.contract_no' + no,'list');
	}
	function autocomp(no)
	{
		AutoComplete_Create("comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\"","ACCOUNT_CODE,MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","member_code"+no+",member_type"+no+",action_company_id"+no+",action_consumer_id"+no+",action_employee_id"+no+"","",3,250,"emp_comp_and_account("+ no +")");
	}
	function autocomp_employee(no)
	{
		AutoComplete_Create("employee_name"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","3","EMPLOYEE_ID","employee_id"+no,"",3,140);
	}
	function autocomp_project(no)
	{
		AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("action_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","","","",3);
	}
	function autocomp_asset(no)
	{
		AutoComplete_Create("asset_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","asset_id"+no,"",3,200);
	}
	function exp_center(no,type)
	{
		if(type==1)
			AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
		else
			AutoComplete_Create("income_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","income_center_id"+no,"",3);
	}
	function exp_item(no,type)
	{
		if(type==1)
			AutoComplete_Create("expense_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID","expense_item_id"+no,"",3);
		else
			AutoComplete_Create("income_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID","income_item_id"+no,"",3);
	}
	function emp_comp_and_account(no)
	{
		get_expense(no);
		var member_type=document.getElementById('member_type'+no).value;
		if(list_len(document.getElementById('action_employee_id'+no).value,'_'))
		{

			var emp_id=list_getat(document.getElementById('action_employee_id'+no).value,1,'_');
			var acc_type_id=list_getat(document.getElementById('action_employee_id'+no).value,2,'_');
		}
		else
		{
			var emp_id=document.getElementById('action_employee_id'+no).value;
			var acc_type_id = '';
		}
		var comp_id=document.getElementById('action_company_id'+no).value;
		var cons_id=document.getElementById('action_consumer_id'+no).value;
		if(member_type == 'partner')
		{
			var listParam = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + comp_id;
			var get_credit_all = wrk_safe_query('obj_get_credit_all','dsn',0,listParam);
			<cfif get_our_company_info.is_select_risk_money eq 1>
				if(get_credit_all.recordcount && get_credit_all.MONEY != '')
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						if( eval('add_process.hidden_rd_money_'+i).value == get_credit_all.MONEY)
						{
							if(eval('add_process.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money#</cfoutput>')
							{
								rate1_eleman = commaSplit(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#session.ep.money#</cfoutput>').replace(',','.');
								rate2_eleman = commaSplit(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#session.ep.money#</cfoutput>').replace(',','.');
							}
							else
							{
								rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
								rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							}
						}
					}
					new_money = get_credit_all.MONEY;
					if(rate1_eleman != undefined)
						new_money_list = get_credit_all.MONEY+';'+rate1_eleman+';'+rate2_eleman;
					else
						new_money_list = get_credit_all.MONEY+';'+get_credit_all.RATE1+';'+get_credit_all.RATE2;
					document.getElementById('money_id'+no).value = new_money_list;					
				}				
			</cfif>
		}
		else if(member_type == 'consumer')
		{
			var listParam = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + cons_id;
			var get_credit_all = wrk_safe_query('obj_get_credit_all_2','dsn',0,listParam);
			<cfif get_our_company_info.is_select_risk_money eq 1>
				for(var i=1;i<=add_process.kur_say.value;i++)
				{
					if( eval('add_process.hidden_rd_money_'+i).value == get_credit_all.MONEY)
					{
						if(eval('add_process.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money#</cfoutput>')
						{
							rate1_eleman = commaSplit(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#session.ep.money#</cfoutput>').replace(',','.');
							rate2_eleman = commaSplit(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#session.ep.money#</cfoutput>').replace(',','.');
						}
						else
						{
							rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						}
					}
				}
				new_money = get_credit_all.MONEY;
				if(rate1_eleman != undefined)
					new_money_list = get_credit_all.MONEY+';'+rate1_eleman+';'+rate2_eleman;
				else
					new_money_list = get_credit_all.MONEY+';'+get_credit_all.RATE1+';'+get_credit_all.RATE2;
				if(get_credit_all.recordcount && get_credit_all.money != '')
				{
					new_money = get_credit_all.MONEY;
					if(rate1_eleman != undefined)
						new_money_list = get_credit_all.MONEY+';'+rate1_eleman+';'+rate2_eleman;
					else
						new_money_list = get_credit_all.MONEY+';'+get_credit_all.RATE1+';'+get_credit_all.RATE2;
					document.getElementById('money_id'+no).value = new_money_list;					
				}				
			</cfif>
		}
		if(member_type=='employee' && document.getElementById('member_code'+no).value == "")
		{
			var GET_COMPANY=wrk_safe_query('obj_get_company','dsn',0,emp_id);
			if(acc_type_id != undefined && acc_type_id != '')
				var GET_ACCOUNT_CODE=wrk_safe_query('obj_get_acc_code_all','dsn',0,emp_id,acc_type_id);
			else
				var GET_ACCOUNT_CODE=wrk_safe_query('obj_get_acc_code','dsn',0,emp_id);
			
			document.getElementById('action_company_id'+no).value=GET_COMPANY.COMP_ID;
			if(GET_ACCOUNT_CODE.ACCOUNT_CODE!=null && GET_ACCOUNT_CODE.ACCOUNT_CODE!='')
				document.getElementById('member_code'+no).value=GET_ACCOUNT_CODE.ACCOUNT_CODE;
			else
			{
				var GET_ACCOUNT_CODE=wrk_safe_query('obj_get_acc_code_per_adv','dsn3');
				if(GET_ACCOUNT_CODE.PERSONAL_ADVANCE_ACCOUNT!=null)
					document.getElementById('member_code'+no).value=GET_ACCOUNT_CODE.PERSONAL_ADVANCE_ACCOUNT;
				else
					document.getElementById('member_code'+no).value="";
			}
		}
		else
			return false;
		
	}
	function get_expense(no)
	{
	<cfif isdefined("x_expense_show") and x_expense_show eq 1>
		var selected_ptype_ = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
		if(selected_ptype_ != '')
		{
			var member_type=document.getElementById('member_type'+no).value;
			var emp_id=document.getElementById('action_employee_id'+no).value;
			eval('var proc_control_ = document.add_process.ct_process_type_'+selected_ptype_+'.value');
			if(proc_control_ == 420 && ('document.add_process.member_code'+no).value!='' && ('document.add_process.member_type'+no).value!='')
			{
				if(member_type == 'employee')
				{
					var get_expense_center_ = wrk_safe_query('obj_get_expense_center', 'dsn', 0, emp_id);
						if(get_expense_center_.recordcount)
						{
							document.getElementById("expense_center_id"+no).value = get_expense_center_.EXPENSE_CENTER_ID;
							document.getElementById("expense_center_name"+no).value = get_expense_center_.EXPENSE_CODE_NAME;
							document.getElementById('expense_item_id'+no).value = get_expense_center_.EXPENSE_ITEM_ID;
							document.getElementById('expense_item_name'+no).value = get_expense_center_.EXPENSE_ITEM_NAME;
						}
						else
						{
							document.getElementById('expense_center_id'+no).value = '';
							document.getElementById('expense_item_id'+no).value = '';
							document.getElementById('expense_center_name'+no).value = '';
							document.getElementById('expense_item_name'+no).value = '';
						}
				}
			}
			if(proc_control_ == 410 && ('document.add_process.member_code'+no).value!='' && ('document.add_process.member_type'+no).value!='')
			{
				if(member_type == 'employee')
				{
					var get_expense_center_ = wrk_safe_query('obj_get_expense_center', 'dsn', 0, emp_id);
						if(get_expense_center_.recordcount)
						{
							document.getElementById("income_center_id"+no).value = get_expense_center_.EXPENSE_CENTER_ID;
							document.getElementById("income_center_name"+no).value = get_expense_center_.EXPENSE_CODE_NAME;
							document.getElementById('income_item_id'+no).value = get_expense_center_.EXPENSE_ITEM_ID;
							document.getElementById('income_item_name'+no).value = get_expense_center_.EXPENSE_ITEM_NAME;
						}
						else
						{
							document.getElementById('income_center_id'+no).value = '';
							document.getElementById('income_center_name'+no).value = '';
							document.getElementById('income_item_id'+no).value = '';
							document.getElementById('income_item_name'+no).value = '';
						}
				}
			}
		}
	</cfif>
	}
	
	function control_del_form()
	{
		<cfif isdefined("is_update")>
			if(!control_account_process(<cfoutput>'#get_action_detail.multi_action_id#','#get_action_detail.action_type_id#'</cfoutput>)) return false;
			if(!chk_period(add_process.action_date,'İşlem')) return false;
		</cfif>		
		return true;
	}
	
	var is_add_form = 0;//kontroller uzun sürdüğünde form tekrar sbumit edilmesin diye eklendi.
	function control_form()
	{
		if(is_add_form == 0)
		{
			rowFlag = false;
			for(var n=1; n<=add_process.record_num.value;n++)
			{
				if(document.getElementById("row_kontrol"+n).value == 1)
					rowFlag = true;
			}
			if(rowFlag)
			{
				<cfif isdefined("is_update")>
					if(!control_account_process(<cfoutput>'#get_action_detail.multi_action_id#','#get_action_detail.action_type_id#'</cfoutput>)) return false;
				</cfif>
				if(!chk_process_cat('add_process')) return false;
				if(document.getElementById("account_id") != undefined && document.getElementById("account_id").value == '')
				{
					alert("<cf_get_lang dictionary_id='57521.Banka'>/<cf_get_lang dictionary_id='57652.Hesap'> <cf_get_lang dictionary_id='57734.Seçiniz'>!");
					return false;
				}
				if(!check_display_files('add_process')) return false;
				if(!chk_period(add_process.action_date,'İşlem')) return false;
				process=document.add_process.process_cat.value;
				var get_process_cat = wrk_safe_query('obj_get_process_cat', 'dsn3', 0, process);
				paper_num_list='';
				say=0;
				<cfif not isdefined("attributes.is_other_act")>
					kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false);
				</cfif>
				kontrol_say = 0;
				kontrol_number = '';
				is_add_form = 1; //tum kontroller yapildiktan sonra set edilmesi gerekir
				
				<cfif ListFind("1",paper_type)>
					var p_type_ = "INCOMING_TRANSFER";
					var table_name_ = "BANK_ACTIONS";
					var alert_name_ = "<cf_get_lang dictionary_id ='33818.Aynı Belge No İle Kayıtlı Gelen Havale İşlemi Var'>";
					var action_type = 'ACTION_TYPE_ID*24';
				<cfelseif ListFind("2",paper_type)>
					var p_type_ = "OUTGOING_TRANSFER";
					var table_name_ = "BANK_ACTIONS";
					var alert_name_ = "<cf_get_lang dictionary_id ='33819.Aynı Belge No İle Kayıtlı Giden Havale İşlemi Var'>";
					var action_type = 'ACTION_TYPE_ID*25';
				<cfelseif ListFind("3",paper_type)>
					var p_type_ = "REVENUE_RECEIPT";
					var table_name_ = "CASH_ACTIONS";
					var alert_name_ = "<cf_get_lang dictionary_id ='33820.Aynı Belge No İle Kayıtlı Kasa Tahsilat İşlemi Var'>";
					var action_type = 'ACTION_TYPE_ID*31';
				<cfelseif ListFind("4",paper_type)>
					var p_type_ = "CASH_PAYMENT";
					var table_name_ = "CASH_ACTIONS";
					var alert_name_ = "<cf_get_lang dictionary_id ='33821.Aynı Belge No İle Kayıtlı Kasa Ödeme İşlemi Var'>";
					var action_type = 'ACTION_TYPE_ID*32';
				<cfelseif ListFind("5",paper_type)>
					var p_type_ = "DEBIT_CLAIM";
					var table_name_ = "CARI_ACTIONS";
					var alert_name_ = "<cf_get_lang dictionary_id='34279.Aynı Belge No İle Kayıtlı Cari Dekont İşlemi Var'>";
					var action_type = 'ACTION_TYPE_ID*41,42,45,46';
				</cfif>
				<cfif not isdefined("is_update")>
					if(!paper_no_control(document.getElementById('record_num').value,'<cfoutput>#dsn2#</cfoutput>',table_name_,action_type,'PAPER_NO',p_type_,'row_kontrol','paper_number'))
					{
						is_add_form = 0;
						return false;
					}
				<cfelse>
					if(!paper_no_control(document.getElementById('record_num').value,'<cfoutput>#dsn2#</cfoutput>',table_name_,action_type,'PAPER_NO',p_type_,'row_kontrol','paper_number','ACTION_ID-act_row_id'))
					{
						is_add_form = 0;
						return false;
					}
				</cfif>
					
				for(var n=1; n<=add_process.record_num.value;n++)
				{
					<cfif ListFind("5",paper_type)>
						<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
						var action_account_code = document.getElementById("action_account_code"+n).value;
						if(action_account_code != "")
						{ 
							if(WrkAccountControl(action_account_code,n+ "<cf_get_lang dictionary_id='58508.Satır'>: <cf_get_lang dictionary_id='52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir'>!") == 0)
							{
								is_add_form = 0;
								return false;
							}
						}
					</cfif>
					if(eval("document.add_process.row_kontrol"+n).value == 1)
					{
						record_exist=1;
						say++;
	
						//Satirda cari hesap kontrolu
						if((eval("document.add_process.action_company_id"+n).value=="" || eval("document.add_process.action_consumer_id"+n).value=="" || eval("document.add_process.action_employee_id"+n).value=="") && eval("document.add_process.comp_name"+n).value.trim()=="")
						{
							alert("<cf_get_lang dictionary_id ='33557.Cari Hesap Seçiniz '>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
							is_add_form = 0;
							return false;
						}
						//Satirda para birimi kontrolu	
						if(document.getElementById("money_id"+n).value=="")
						{
							alert("<cf_get_lang dictionary_id='48846.Para Birimi Seçiniz'>. <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
							is_add_form = 0;
							return false;
						}	
						if(get_process_cat.IS_ACCOUNT == 1 )
						{
							if (eval("document.add_process.member_code"+n).value=="")
							{ 
								alert ("<cf_get_lang dictionary_id ='33813.Seçilen Cari Hesabın Muhasebe Kodu Tanımlı Değil'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
								is_add_form = 0;
								return false;
							}

						}
					
						if (eval("document.add_process.action_value"+n).value=="")
						{ 
							alert ("<cf_get_lang dictionary_id ='33814.Lütfen İşlem Tutarını Giriniz'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
							is_add_form = 0;
							return false;
						}
	
						deger_project = eval("document.add_process.project_id"+n);
						deger_project_name = eval("document.add_process.project_head"+n);
						<cfif isdefined("x_required_project") and x_required_project eq 1>
							if(eval("document.add_process.project_id"+n).value == "" || eval("document.add_process.project_head"+n).value == "")
							{
								alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
								is_add_form = 0;
								return false;
							}
						</cfif>
						<cfif isDefined("x_select_type_info") and x_select_type_info eq 2>
							<cfif listfind("2,4",paper_type)>
								if(document.getElementById('special_definition_id'+n).value == "")
								{
									alert("<cf_get_lang dictionary_id='58928.Ödeme Tipi'> <cf_get_lang dictionary_id='57734.Seçiniz'>!");
									is_add_form = 0;
									return false;
								}
							<cfelseif listfind("1,3",paper_type)>
								if(document.getElementById('special_definition_id'+n).value == "")
								{
									alert("<cf_get_lang dictionary_id='58929.Tahsilat Tipi'> <cf_get_lang dictionary_id='57734.Seçiniz'>!");
									is_add_form = 0;
									return false;
								}
							</cfif>
						</cfif>
						<cfif isdefined("x_project_expence_center") and x_project_expence_center eq 1>
							if (deger_project.value == "" || deger_project_name.value == "")
							{ 
								alert ("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
								is_add_form = 0;
								return false;
							}					
							var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1", deger_project.value);
							var proje_record_ = get_proje_merkez.recordcount;
							if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
							{
								alert("<cf_get_lang dictionary_id='34265.Proje Masraf Merkezi Bulunamadı'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
								is_add_form = 0;
								return false;
							}
							else
							{
								var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
								eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
													
								var get_code = wrk_safe_query("obj_get_code", "dsn2", "1", get_proje_merkez.EXPENSE_CODE);
									if(proc_control == 420 || proc_control == 46)
										{
										eval("document.add_process.expense_center_id"+n).value = get_code.EXPENSE_ID;
										eval("document.add_process.expense_center_name"+n).value = 'Masraf Merkezi';
										}
									else if(proc_control == 410 || proc_control == 45)
										{
										eval("document.add_process.income_center_id"+n).value = get_code.EXPENSE_ID;
										eval("document.add_process.income_center_name"+n).value = 'Gelir Merkezi';
										}
							}
						</cfif>				
						<cfif ListFind("3,4",paper_type)>
							if (eval("document.add_process.paper_number"+n).value=="")
							{ 
								alert ("<cf_get_lang dictionary_id ='33367.Lütfen Belge No Giriniz'>! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
								is_add_form = 0;
								return false;
							}
							if (eval("document.add_process.employee_name"+n).value=="" || eval("document.add_process.employee_id"+n).value=="")
							{ 
								<cfif paper_type eq 3>
									alert ("<cf_get_lang dictionary_id ='33817.Lütfen Tahsil Eden Giriniz'> ! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
								<cfelse>//paper_type eq 4 yani
									alert ("<cf_get_lang dictionary_id ='33452.Lütfen Ödeme Yapan Giriniz'> ! <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
								</cfif>
								is_add_form = 0;
								return false;
							}
						<cfelseif paper_type eq 1 or paper_type eq 2>
							if(filterNum(eval("document.add_process.expense_amount"+n).value) > 0)
								if(eval("document.add_process.expense_center_id"+n).value=="" || eval("document.add_process.expense_item_id"+n).value== "")
								{
									alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id='57989.Ve'> <cf_get_lang dictionary_id='58551.Gider Kalemi'> <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
									return false;
								}
						<cfelseif paper_type eq 5>
							var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
							eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
							if(get_process_cat.IS_ACCOUNT ==1)
							{
								if (eval("document.add_process.action_account_code"+n).value=="")
								{ 
									alert ("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58811.Muhasebe Kodu'> <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
									is_add_form = 0;
									return false;
								}
							}
							if(proc_control == 420)
							{
								if( (eval("document.add_process.expense_center_id"+n).value=="" && eval("document.add_process.expense_item_id"+n).value!= "" && eval("document.add_process.expense_item_name"+n).value != "") || (eval("document.add_process.expense_center_id"+n).value!="" && eval("document.add_process.expense_item_id"+n).value!="" && eval("document.add_process.expense_item_id"+n).value == "") || (eval("document.add_process.expense_center_name"+n).value=="" && eval("document.add_process.expense_item_name"+n).value!= "") || (eval("document.add_process.expense_center_name"+n).value!="" && eval("document.add_process.expense_item_name"+n).value == "") )
								{
									alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id='57989.Ve'> <cf_get_lang dictionary_id='58551.Gider Kalemi'> <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
									is_add_form = 0;
									return false;
								}
							}
							else
							{
								if( (eval("document.add_process.income_center_id"+n).value=="" && eval("document.add_process.income_item_id"+n).value!= "" && eval("document.add_process.income_item_name"+n).value != "") || (eval("document.add_process.income_center_id"+n).value!="" && eval("document.add_process.income_item_id"+n).value!="" && eval("document.add_process.income_item_id"+n).value == "") || (eval("document.add_process.income_center_name"+n).value=="" && eval("document.add_process.income_item_name"+n).value!= "") || (eval("document.add_process.income_center_name"+n).value!="" && eval("document.add_process.income_item_name"+n).value == "") )
								{
									alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58172.Gelir Merkezi'> <cf_get_lang dictionary_id='57989.Ve'> <cf_get_lang dictionary_id='58173.Gelir Kalemi'> <cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
									is_add_form = 0;
									return false;
								}
							}	
						</cfif>
					}
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='33822.Lütfen Satır Ekleyiniz'>!");
				is_add_form = 0;
				return false;
			}
			return true;
		}
		else
			return false;
		
	}
	
	function kur_ekle_f_hesapla(select_input,doviz_tutar,satir)
	{
		<cfif not isdefined("attributes.is_other_act")>
		if(satir != undefined)
		{
			if(!doviz_tutar) doviz_tutar=false;
			var currency_type = eval('add_process.'+select_input+'.options[add_process.'+select_input+'.selectedIndex]').value;
			if(document.getElementById('currency_id') != undefined)
				currency_type = document.getElementById('currency_id').value;
			else
				currency_type = list_getat(currency_type,2,';');
			row_currency = list_getat(eval("document.add_process.money_id"+satir).value,1,';');
			var other_money_value_eleman=eval("document.add_process.action_value_other"+satir);
			var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
			if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
			{
				other_money_value_eleman.value = '';
				return false;
			}
			if(!doviz_tutar && eval("document.add_process.action_value"+satir) != "" && currency_type != "")
			{
				for(var i=1;i<=add_process.kur_say.value;i++)
				{
					rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					if( eval('add_process.hidden_rd_money_'+i).value == currency_type)
					{
						temp_act=filterNum(eval("document.add_process.action_value"+satir).value)*rate2_eleman/rate1_eleman;
						eval("document.add_process.system_amount"+satir).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
					}
				}
				for(var i=1;i<=add_process.kur_say.value;i++)
				{
					rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
					{
						other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value,'<cfoutput>#rate_round_num_info#</cfoutput>')*rate1_eleman/rate2_eleman);
						eval("document.add_process.system_amount"+satir).value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value,'<cfoutput>#rate_round_num_info#</cfoutput>'),'<cfoutput>#rate_round_num_info#</cfoutput>');
					}
				}
			}
			else if(doviz_tutar)
			{
				<cfif  paper_type eq 5>
					var curre_type = list_getat(eval("document.add_process.money_id"+satir).value,1,';');
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if( eval('add_process.hidden_rd_money_'+i).value == curre_type)
						{
							temp_act=filterNum(eval("document.add_process.action_value_other"+satir).value)*rate2_eleman/rate1_eleman;
							eval("document.add_process.system_amount"+satir).value = commaSplit(temp_act,2);
							eval("document.add_process.action_value"+satir).value = commaSplit(temp_act,2);
						}
					}
				<cfelse>
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>' && filterNum(eval("document.add_process.system_amount"+satir).value) > 0)
								eval('add_process.txt_rate2_' + i).value = commaSplit(filterNum(eval("document.add_process.system_amount"+satir).value)/filterNum(other_money_value_eleman.value),'<cfoutput>#rate_round_num_info#</cfoutput>');
							else
								for(var t=1;t<=add_process.kur_say.value;t++)
									if( eval('add_process.hidden_rd_money_'+t).value == currency_type && eval("document.add_process.action_value"+satir).value > 0  && eval('add_process.hidden_rd_money_'+t).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
										eval('add_process.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(eval("document.add_process.action_value"+satir).value),'<cfoutput>#rate_round_num_info#</cfoutput>');
						}
					}					
					eval("document.add_process.action_value"+satir).value = commaSplit(filterNum(eval("document.add_process.action_value"+satir).value));
				</cfif>
			}
		}
		else
		{
			if(!doviz_tutar) doviz_tutar=false;
			var currency_type = eval('add_process.'+select_input+'.options[add_process.'+select_input+'.selectedIndex]').value;				
			if(document.getElementById('currency_id') != undefined)
				currency_type = document.getElementById('currency_id').value;
			else
				currency_type = list_getat(currency_type,2,';');
				
			document.getElementById('tl_value1').value = currency_type;
			for(var kk=1;kk<=add_process.record_num.value;kk++)
			{
				document.getElementById('tl_value_'+kk).value = currency_type;
				var other_money_value_eleman=eval("document.add_process.action_value_other"+kk);
				var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
				row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');						
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}if(currency_type != "")
				if(!doviz_tutar && eval("document.add_process.action_value"+kk) != "" && currency_type != "")
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == currency_type)
						{
							temp_act=filterNum(eval("document.add_process.action_value"+kk).value)*rate2_eleman/rate1_eleman;
							eval("document.add_process.system_amount"+kk).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
						}
					}
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value,'<cfoutput>#rate_round_num_info#</cfoutput>')*rate1_eleman/rate2_eleman);
							eval("document.add_process.system_amount"+kk).value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value,'<cfoutput>#rate_round_num_info#</cfoutput>'),'<cfoutput>#rate_round_num_info#</cfoutput>');
						}
					}
				}
				else if(doviz_tutar)
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
								eval('add_process.txt_rate2_' + i).value = commaSplit(filterNum(eval("document.add_process.system_amount"+kk).value)/filterNum(other_money_value_eleman.value),'<cfoutput>#rate_round_num_info#</cfoutput>');
							else
								for(var t=1;t<=add_process.kur_say.value;t++)
									if( eval('add_process.hidden_rd_money_'+t).value == currency_type && eval('add_process.hidden_rd_money_'+t).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
										eval('add_process.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(eval("document.add_process.action_value"+kk).value),'<cfoutput>#rate_round_num_info#</cfoutput>');
							if (eval('add_process.hidden_rd_money_'+i).value != '<cfoutput>#str_money_bskt_main#</cfoutput>')
								for(var k=1;k<=add_process.kur_say.value;k++)
								{
									rate1_eleman = filterNum(eval('add_process.txt_rate1_' + k).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
									rate2_eleman = filterNum(eval('add_process.txt_rate2_' + k).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
									if( eval('add_process.hidden_rd_money_'+k).value == currency_type)
									{
										temp_act=filterNum(eval("document.add_process.action_value"+kk).value)*rate2_eleman/rate1_eleman;
										eval("document.add_process.system_amount"+kk).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
									}
								}
							else
								eval("document.add_process.system_amount"+kk).value = other_money_value_eleman.value;
						}
					eval("document.add_process.action_value"+kk).value = commaSplit(filterNum(eval("document.add_process.action_value"+kk).value));
				}
			}
		}	
		toplam_hesapla();
		</cfif>
		return true;
	}	
	function toplam_hesapla()
	{
		rate2_value = 0;
		deger_diger_para = '<cfoutput>#session.ep.money#</cfoutput>';
		for (var t=1; t<=add_process.kur_say.value; t++)
		{
			if(document.add_process.rd_money[t-1].checked == true)
			{
				for(k=1;k<=add_process.record_num.value;k++)
				{
					rate2_value = filterNum(eval("document.add_process.txt_rate2_"+t).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					deger_diger_para = list_getat(document.add_process.rd_money[t-1].value,1,',');
				}
			}
		}
		var total_amount = 0;
		for(j=1;j<=add_process.record_num.value;j++)
		{
			if(eval("document.add_process.row_kontrol"+j).value==1)
			{
				total_amount += parseFloat(filterNum(eval('add_process.action_value'+j).value));
				<cfif isdefined("attributes.debt_claim")>
					eval("document.add_process.action_value_other"+j).value=0;
				<cfelseif isdefined('get_action_detail')>
					var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
					if (selected_ptype != '')
						eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
					else
						var proc_control = '';
					if(proc_control != '' && (proc_control == 45 || proc_control == 46))
						eval("document.add_process.action_value_other"+j).value=0;
					else
					{
						<cfif isdefined("attributes.is_other_act")>
							eval("document.add_process.action_value"+j).value=0;
						</cfif>
					}
				</cfif>
				var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
				if (selected_ptype != '')
					eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
				else
					var proc_control = '';
				if(proc_control != '' && (proc_control == 45 || proc_control == 46))
					eval("document.add_process.action_value_other"+j).value=0;
				else
				{
					<cfif isdefined("attributes.is_other_act")>
						eval("document.add_process.action_value"+j).value=0;
					</cfif>
				}
			}
		}
		if(rate2_value==0)
			other_total_amount=0;
		else
			other_total_amount = total_amount/rate2_value;
		add_process.total_amount.value = commaSplit(total_amount);
	}
	function pencere_ac_employee(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_process.employee_id' + no +'&field_name=add_process.employee_name' + no +'<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_process.project_id' + no +'&project_head=add_process.project_head' + no +'');
	}
	window.onload = function()
	{ 
		<cfif not isdefined("attributes.is_other_act")>
			if(document.getElementById('<cfoutput>#select_input#</cfoutput>').value != '')
				kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false);
		</cfif>
	}
	function kur_hesapla2(select_input){
		var currency_type = eval('add_process.'+select_input+'.options[add_process.'+select_input+'.selectedIndex]').value;	
		if(document.getElementById('currency_id') != undefined)
			currency_type = document.getElementById('currency_id').value;
		else
			currency_type = list_getat(currency_type,2,';');
		for(var kk=1;kk<=add_process.record_num.value;kk++)
		{
			row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');
			for(var i=1;i<=add_process.kur_say.value;i++)
			{	
				rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
				rate2_1 = list_getat(eval("document.add_process.money_id"+kk).value,3,';');
				rate2_2 = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
				if(eval('add_process.hidden_rd_money_'+i).value == currency_type)
				{
					eval("document.add_process.action_value"+kk).value = commaSplit(filterNum(eval("document.add_process.action_value_other"+kk).value,'<cfoutput>#rate_round_num_info#</cfoutput>')*rate2_1/rate2_2);
					temp_act=filterNum(eval("document.add_process.action_value"+kk).value)*rate2_2/rate1_eleman;
					eval("document.add_process.system_amount"+kk).value = commaSplit(temp_act,'<cfoutput>#rate_round_num_info#</cfoutput>');
				}
			}
		}
	toplam_hesapla();
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">