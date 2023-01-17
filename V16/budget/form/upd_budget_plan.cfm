<div style="display:none;z-index:99999;" id="wizard_div"></div>
<cf_xml_page_edit fuseact="budget.add_budget_plan">
<cfscript>
	budget_plan=createObject("component","V16.budget.cfc.budget_plan") ;
	get_budget_plan=budget_plan.get_budget_plan(budget_plan_id:attributes.budget_plan_id);
	get_branches=budget_plan.get_branches();
	get_budget_plan_row=budget_plan.get_budget_plan_row(budget_plan_id:attributes.budget_plan_id);
	get_budget_plan_money=budget_plan.get_budget_plan_money(budget_plan_id:attributes.budget_plan_id);
	get_expense_center=budget_plan.get_expense_center();
	get_activity_types=budget_plan.get_activity_types();
	get_workgroups=budget_plan.get_workgroups();
</cfscript>
<cfif len(attributes.budget_plan_id) and len(get_budget_plan.process_cat) and len(get_budget_plan.process_type)>
		<cfset get_company_period_control=budget_plan.get_company_period_control(budget_plan_id:attributes.budget_plan_id)>
	<cfif  len(get_company_period_control.period_id) and (get_company_period_control.period_id neq session.ep.period_id or get_company_period_control.our_company_id neq session.ep.company_id)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='49124.Bu Bütçe Çalıştığınız Şirket ve Muhasebe Döneminde Tanımlı Değildir'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
	get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
</cfscript>

<cf_catalystHeader>
<cf_box>
	<cfform name="upd_budget_plan" method="post" action="#request.self#?fuseaction=budget.emptypopup_upd_budget_plan" >
			<cfoutput>
				<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
				<input type="hidden" name="budget_plan_id" id="budget_plan_id" value="#attributes.budget_plan_id#">
				<input type="hidden" name="process_type" id="process_type" value="#get_budget_plan.process_type#">
			</cfoutput>
			<cf_box_elements id="budget_plan">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',388)#</cfoutput> *</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process_cat process_cat='#get_budget_plan.process_cat#' process_type_info='#get_budget_plan.process_type#' slct_width='150' form_name="upd_budget_plan">
						</div>
					</div>
					<div class="form-group" id="item-surec">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1447)#</cfoutput> *</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' select_value='#get_budget_plan.process_stage#' process_cat_width='150' is_detail='1'>
						</div>
					</div>
					<div class="form-group" id="item-surec">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('budget',85)#</cfoutput></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_budget_plan.budget_id)>
									<cfquery name="get_budget" datasource="#dsn#">
										SELECT BUDGET_NAME FROM BUDGET WHERE BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_budget_plan.budget_id#">
									</cfquery>
									<cfset budget_id = get_budget_plan.budget_id>
									<cfset budget_name = get_budget.budget_name>
								<cfelse>
									<cfset budget_id = ''>
									<cfset budget_name = ''>
								</cfif>
								<input type="text" name="budget_name" id="budget_name" value="<cfoutput>#budget_name#</cfoutput>">
								<input type="hidden" name="budget_id" id="budget_id" value="<cfoutput>#budget_id#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_budget&field_id=upd_budget_plan.budget_id&field_name=upd_budget_plan.budget_name&select_list=2');return false" title="<cfoutput>#getLang('budget',85)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<cfif is_show_branch eq 1>
						<div class="form-group" id="item-acc_branch_id">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',41)#</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<select name="acc_branch_id" id="acc_branch_id" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branches">
										<option value="#BRANCH_ID#" <cfif get_budget_plan.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-paper_number">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#</cfoutput> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="paper_number" id="paper_number" value="#get_budget_plan.paper_no#" maxlength="40">
						</div>
					</div>
					<div class="form-group" id="item-record_date">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',215)#</cfoutput></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput name="record_date" id="record_date" type="text" validate="#validate_style#" required="Yes" style="width:80px;" value="#dateformat(get_budget_plan.BUDGET_PLAN_DATE,dateformat_style)#" onblur="change_money_info('upd_budget_plan','record_date');">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date" call_function="change_money_info"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('budget',81)#</cfoutput><cfif not isdefined("attributes.from_plan_list")> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_budget_plan.budget_planner_emp_id#</cfoutput>">
								<input type="Text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_budget_plan.budget_planner_emp_id,0,0)#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_budget_plan.employee_id&field_name=upd_budget_plan.employee_name&select_list=1');" title="<cfoutput>#getLang('budget',81)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<cfif xml_acc_department_info>
						<div class="form-group" id="item-acc_department_id">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',160)#</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' width='150' selected_value='#get_budget_plan.ACC_DEPARTMENT_ID#'>
							</div>
						</div>
					</cfif>		
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',217)#</cfoutput></label>
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail" style="width:150px;height:41px;"><cfoutput>#get_budget_plan.DETAIL#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-is_scenario">
						<label class="col col-12"><input name="is_scenario" id="is_scenario" type="checkbox" value="" <cfif get_budget_plan.is_scenario eq 1>checked</cfif>><cfoutput>#getLang('budget',19)#</cfoutput></label>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-document_type">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1121)#</cfoutput></label>
						<div class="col col-8 col-xs-12">
							<select name="document_type" id="document_type" onchange="display_duedate()">
								<option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
								<cfoutput query="get_account_card_document_types">
									<option value="#document_type_id#"<cfif document_type_id EQ get_budget_plan.document_type>selected</cfif>>#document_type#</option>
								</cfoutput>
							</select>
						</div>                      	
					</div>
					<div class="form-group" id="item-payment_type">
						<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',2260)#</cfoutput></label>
						<div class="col col-8 col-xs-12">
							<select name="payment_type" id="payment_type" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_account_card_payment_types">
									<option value="#payment_type_id#" <cfif payment_type_id EQ get_budget_plan.payment_method>selected</cfif>>#payment_type#</option>
								</cfoutput>
							</select>
						</div>                      	
					</div>
					<div class="form-group" id="item-due_date"  <cfif not isdefined("attributes.budget_plan_id") or not listFind("-1,-3",get_budget_plan.document_type)>style="display:none;"</cfif>>
						<label id="td_due_date_label" class="col col-4 col-xs-12"><cfoutput>#getLang('main',469)#</cfoutput></label>
						<div id="td_due_date_input" class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="due_date" maxlength="10" validate="#validate_style#" style="width:65px;" value="#dateformat(get_budget_plan.due_date,dateformat_style)#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date"></span> 
							</div>
						</div>                      	
					</div>
				</div>
			</cf_box_elements>
			<cf_grid_list margin="1">
				<thead>
					<tr>
						<th style="min-width:20px;"><cf_get_lang dictionary_id='57487.No'></th>
						<th>
							<input name="record_num_kontrol" id="record_num_kontrol" type="hidden" value="<cfoutput>#get_budget_plan_row.recordcount#</cfoutput>">
							<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_budget_plan_row.recordcount#</cfoutput>">
							<a style="cursor:pointer" onclick="add_row();" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>"><i class="fa fa-plus"alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a>
						</th>
						<cfoutput>
							<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
								<cfswitch expression="#xlr#">
								<cfcase value="1"><!--- 1.Tarih --->
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
									<th style="min-width:120px;"><cf_get_lang dictionary_id='57742.Tarih'>&nbsp;<input type="text" name="temp_date" id="temp_date" value="#dateformat(get_budget_plan.BUDGET_PLAN_DATE,dateformat_style)#" onBlur="change_date_info();" validate="#validate_style#" message="#message#"></th>
								</cfcase>
								<cfcase value="2"><!--- 2.Açıklama --->
									<th style="min-width:100px;"><cf_get_lang dictionary_id='57629.Açıklama'>*</th>
								</cfcase>
								<cfcase value="3"><!--- 3.Masraf Merkezi --->
									<th style="min-width:150px;"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'> *</th>
								</cfcase>
								<cfcase value="4"><!--- 4.Butce Kategorisi --->
									<th style="min-width:120px;"><cf_get_lang dictionary_id='32999.Butce Kategorisi'></th>
								</cfcase>
								<cfcase value="5"><!--- 5.Butce Kalemi --->
									<th style="min-width:120px;"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'> *</th>
								</cfcase>
								<cfcase value="6"><!--- 6.Muhasebe Kodu --->
									<th style="min-width:120px;"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
								</cfcase>
								<cfcase value="7"><!--- 7.Aktivite Tipi --->
									<th style="min-width:100px;"><cf_get_lang dictionary_id='49184.Aktivite Tipi'></th>
								</cfcase>
								<cfcase value="8"><!--- 8.Is Grubu --->
									<th style="min-width:100px;"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
								</cfcase>
								<cfcase value="17"><!--- 17.Fiziki Varlık --->
									<th style="min-width:120px;"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
								</cfcase>
								<cfcase value="9"><!--- 9.Proje --->
									<th style="min-width:120px;"><cf_get_lang dictionary_id='57416.Proje'></th>
								</cfcase>
								<cfcase value="10"><!--- 10.Cari Hesap --->
									<th style="min-width:120px;"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
								</cfcase>
								<cfcase value="11"><!--- 11.Gelir TL --->
									<th style="min-width:70px;"><cf_get_lang dictionary_id='58677.Gelir'> #session.ep.money#</th>
								</cfcase>
								<cfcase value="12"><!--- 12.Gider TL --->
									<th style="min-width:70px;"><cf_get_lang dictionary_id='58678.Gider'> #session.ep.money#</th>
								</cfcase>
								<cfcase value="13"><!--- 13.Fark TL --->
									<th style="min-width:70px;"><cf_get_lang dictionary_id='58583.Fark'> #session.ep.money#</th>
								</cfcase>
								<cfcase value="14"><!--- 14.Gelir Doviz --->
									<th style="min-width:70px;"><cf_get_lang dictionary_id='58677.Gelir'> <input type="text" name="other_money_info2" id="other_money_info2" class="moneybox" readonly="" style="width:20px;" value="#GET_BUDGET_PLAN.OTHER_MONEY#"></th>
								</cfcase>
								<cfcase value="15"><!--- 15.Gider Doviz --->
									<th style="min-width:70px;"><cf_get_lang dictionary_id='58678.Gider'> <input type="text" name="other_money_info3" id="other_money_info3" class="moneybox" readonly="" style="width:20px;" value="#GET_BUDGET_PLAN.OTHER_MONEY#"></th>
								</cfcase>
								<cfcase value="16"><!--- 16.Fark Doviz --->
									<th style="min-width:70px;"><cf_get_lang dictionary_id='58583.Fark'> <input type="text" name="other_money_info4" id="other_money_info4" class="moneybox" readonly="" style="width:20px;" value="#GET_BUDGET_PLAN.OTHER_MONEY#"></th>
								</cfcase>
							</cfswitch>
						</cfloop>
					</cfoutput>
					</tr>
				</thead>
					<cfset budget_project_list=''>
					<cfset budget_item_id_list=''>
					<cfset budget_assetp_id_list=''>
					<cfoutput query="get_budget_plan_row">
						<cfif len(budget_item_id) and not listfind(budget_item_id_list,budget_item_id)>
							<cfset budget_item_id_list=listappend(budget_item_id_list,budget_item_id)>
						</cfif>
						<cfif len(project_id) and not listfind(budget_project_list,project_id)>
							<cfset budget_project_list=listappend(budget_project_list,project_id)>
						</cfif>
						<cfif len(assetp_id) and not listfind(budget_assetp_id_list,assetp_id)>
							<cfset budget_assetp_id_list=listappend(budget_assetp_id_list,assetp_id)>
						</cfif>
					</cfoutput>
					<cfif len(budget_item_id_list)>
						<cfset budget_item_id_list=listsort(budget_item_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_detail" datasource="#dsn2#">
							SELECT
								EI.EXPENSE_ITEM_NAME,
								EI.ACCOUNT_CODE,
								EI.EXPENSE_ITEM_ID,
								EC.EXPENSE_CAT_NAME,
								EC.EXPENSE_CAT_ID
							FROM
								EXPENSE_ITEMS EI
								LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
							WHERE
								EXPENSE_ITEM_ID IN (#budget_item_id_list#)
							ORDER BY
								EXPENSE_ITEM_ID
						</cfquery>
					</cfif>
					<cfif len(budget_project_list)>
						<cfset budget_project_list=listsort(budget_project_list,"numeric","ASC",",")>
						<cfquery name="get_project_id" datasource="#dsn#">
							SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#budget_project_list#) ORDER BY PROJECT_ID
						</cfquery>
					</cfif>
					<cfif len(budget_assetp_id_list)>
						<cfset budget_assetp_id_list=listsort(budget_assetp_id_list,"numeric","ASC",",")>
						<cfquery name="get_assetp_name" datasource="#dsn#">
							SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#budget_assetp_id_list#) ORDER BY ASSETP_ID
						</cfquery>
					</cfif>
				<tbody name="table1" id="table1">
					<cfoutput query="get_budget_plan_row">
						<tr id="frm_row#currentrow#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td style="width:10px;" nowrap="nowrap">#currentrow#</td>
							<td nowrap="nowrap">
								<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>"></i></a><a style="cursor:pointer" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="icon-copy"></i></a>
								<input type="hidden" value="#budget_plan_row_id#" name="budget_plan_row_id#currentrow#" id="budget_plan_row_id#currentrow#">
							</td>
							<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
								<cfswitch expression="#xlr#">
									<cfcase value="1"><!--- 1.Tarih --->
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="text" name="expense_date#currentrow#" id="expense_date#currentrow#" style="width:95px;" value="#dateformat(get_budget_plan_row.PLAN_DATE,dateformat_style)#" title="#detail#">
													<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="expense_date#currentrow#"></span>
												</div>
											</div>
										</td>
									</cfcase>
									<cfcase value="2"><!--- 2.Açıklama --->
										<td><div class="form-group"><input type="text" class="boxtext" name="row_detail#currentrow#" id="row_detail#currentrow#" style="width:120px;" value="#get_budget_plan_row.DETAIL#" title="#detail#"></div></td>
									</cfcase>
									<cfcase value="3"><!--- 3.Masraf Merkezi --->
										<td><cfset deger_expense_center_id = get_budget_plan_row.exp_inc_center_id>
											<div class="form-group">
												<select name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" style="width:100px;" class="boxtext">
													<option value=""><cf_get_lang dictionary_id='58972.Masraf/Gelir Merkezi'></option>
													<cfloop query="get_expense_center">
														<option value="#expense_id#" <cfif deger_expense_center_id eq get_expense_center.expense_id>selected</cfif>>#EXPENSE#</option>
													</cfloop>
													</select>
											</div>	
										</td>
									</cfcase>
									<cfcase value="4"><!--- 4.Butce Kategorisi --->
										<td nowrap="nowrap">
											<div class="form-group">
												<input type="hidden" name="expense_cat_id#currentrow#" id="expense_cat_id#currentrow#" value="<cfif len(budget_item_id_list)>#get_exp_detail.expense_cat_id[listfind(budget_item_id_list,budget_item_id,',')]#</cfif>" style="width:25px;"/>
												<input type="text" name="expense_cat_name#currentrow#" id="expense_cat_name#currentrow#"  value="<cfif len(budget_item_id_list)>#get_exp_detail.expense_cat_name[listfind(budget_item_id_list,budget_item_id,',')]#</cfif>" style="width:100%;" class="boxtext" >
											</div>
										</td>
									</cfcase>
									<cfcase value="5"><!--- 5.Butce Kalemi --->
										<td>
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#budget_item_id#">
													<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" value="<cfif len(budget_item_id_list)>#get_exp_detail.expense_item_name[listfind(budget_item_id_list,budget_item_id,',')]#</cfif>" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME','expense_item_id#currentrow#,account_code#currentrow#,account_id#currentrow#,expense_cat_id#currentrow#,expense_cat_name#currentrow#','upd_budget_plan',1);" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_exp('#currentrow#');"></span>
												</div>
											</div>
										</td>
									</cfcase>
									<cfcase value="6"><!--- 6.Muhasebe Kodu --->
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#budget_account_code#">
													<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" value="#budget_account_code#" style="width:105px;" class="boxtext" title="#detail#" onFocus="AutoComplete_Create('account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','account_id#currentrow#','','3','225');" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_acc('#currentrow#');"></span>
												</div>
											</div>
										</td>
									</cfcase>
									<cfcase value="7"><!--- 7.Aktivite Tipi --->
										<td nowrap="nowrap"><cfset deger_activity_type_id = get_budget_plan_row.activity_type_id>
											<div class="form-group">
												<select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:100px;" class="boxtext">
													<option value=""><cf_get_lang dictionary_id='49184.Aktivite Tipi'></option>
													<cfloop query="get_activity_types">
														<option value="#activity_id#" <cfif deger_activity_type_id eq activity_id>selected</cfif>>#activity_name#</option>
													</cfloop>
												</select>
											</div>
										</td>
									</cfcase>
									<cfcase value="8"><!--- 8.Is Grubu --->
										<td nowrap="nowrap"><cfset deger_workgroup_id = get_budget_plan_row.workgroup_id>
											<div class="form-group">
												<select name="workgroup_id#currentrow#" id="workgroup_id#currentrow#" style="width:100px;" class="boxtext">
													<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
													<cfloop query="get_workgroups">
														<option value="#workgroup_id#" <cfif deger_workgroup_id eq workgroup_id>selected</cfif>>#WORKGROUP_NAME#</option>
													</cfloop>
												</select>
											</div>
										</td>
									</cfcase>
									<cfcase value="17"><!--- 17.Fiziki Varlik --->
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="assetp_id#currentrow#" id="assetp_id#currentrow#" value="#get_budget_plan_row.assetp_id#">
													<input type="text" name="assetp_name#currentrow#" id="assetp_name#currentrow#" style="width:105px;" onFocus="autocomp_assetp('#currentrow#');" value="<cfif len(budget_assetp_id_list)>#get_assetp_name.assetp[listfind(budget_assetp_id_list,assetp_id,',')]#</cfif>" class="boxtext" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_assetp('#currentrow#');"></span>
												</div>
											</div>
										</td>
									</cfcase>
									<cfcase value="9"><!--- 9.Proje --->
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#get_budget_plan_row.project_id#">
													<input type="text" style="width:105px;" name="project_head#currentrow#" id="project_head#currentrow#" onFocus="autocomp_project('#currentrow#');" value="<cfif len(budget_project_list)>#get_project_id.project_head[listfind(budget_project_list,project_id,',')]#</cfif>" class="boxtext">
													<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_project('#currentrow#');"></span>
												</div>
											</div>
										</td>
									</cfcase>
									<cfcase value="10"><!--- 10.Cari Hesap --->
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<cfif related_emp_type eq 'partner'>
														<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="">
														<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="">
														<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#related_emp_id#">
														<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#related_emp_type#">
														<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_par_info(related_emp_id,1,0,0)#" class="boxtext" title="#detail#" onFocus="autocomp_cari(#currentrow#);" autocomplete="off">&nbsp;
														<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span></td>
													<cfelseif related_emp_type eq 'consumer'>
														<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="">
														<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#related_emp_id#">
														<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
														<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#related_emp_type#">
														<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_cons_info(related_emp_id,0,0)#" class="boxtext" title="#detail#" onFocus="autocomp_cari(#currentrow#);" autocomplete="off">&nbsp;
														<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span></td>
													<cfelseif related_emp_type eq 'employee'>
														<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="<cfif len(acc_type_id)>#related_emp_id#_#acc_type_id#<cfelse>#related_emp_id#</cfif>">
														<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="">
														<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
														<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#related_emp_type#">
														<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_emp_info(related_emp_id,0,0,0,acc_type_id)#" class="boxtext" title="#detail#" onFocus="autocomp_cari(#currentrow#);" autocomplete="off">&nbsp;
														<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span></td>
													<cfelse>
														<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="">
														<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="">
														<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
														<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
														<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="" class="boxtext" title="#detail#" onFocus="autocomp_cari(#currentrow#);" autocomplete="off">&nbsp;
														<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('#currentrow#');"></span>
													</cfif>
												</div>
											</div>
										</td>
									</cfcase>
									<cfcase value="11"><!--- 11.Gelir TL --->
										<td><div class="form-group"><input type="text" name="income_total#currentrow#" id="income_total#currentrow#" value="#TLFormat(row_total_income)#" onkeyup="FormatCurrency(this,event);" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" class="moneybox" title="#detail#"></div></td>
									</cfcase>
									<cfcase value="12"><!--- 12.Gider TL --->
										<td><div class="form-group"><input type="text" name="expense_total#currentrow#" id="expense_total#currentrow#" value="#TLFormat(row_total_expense)#"  onkeyup="FormatCurrency(this,event);" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" class="moneybox" title="#detail#"></div></td>
									</cfcase>
									<cfcase value="13"><!--- 13.Fark TL --->
										<td><div class="form-group"><input type="text" name="diff_total#currentrow#" id="diff_total#currentrow#" value="#TLFormat(row_total_diff)#"  onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" class="moneybox" title="#detail#"></div></td>
									</cfcase>
									<cfcase value="14"><!--- 14.Gelir Doviz --->
										<td><div class="form-group"><input type="text" name="other_income_total#currentrow#" id="other_income_total#currentrow#" value="#TLFormat(other_row_total_income)#" class="moneybox" readonly="yes" title="#detail#"></div></td>
									</cfcase>
									<cfcase value="15"><!--- 15.Gider Doviz --->
										<td><div class="form-group"><input type="text" name="other_expense_total#currentrow#" id="other_expense_total#currentrow#" value="#TLFormat(other_row_total_expense)#" class="moneybox" readonly="yes" title="#detail#"></div></td>
									</cfcase>
									<cfcase value="16"><!--- 16.Fark Doviz --->
										<td><div class="form-group"><input type="text" name="other_diff_total#currentrow#" id="other_diff_total#currentrow#" value="#TLFormat(other_row_total_diff)#" class="moneybox" readonly="yes" title="#detail#"></div></td>
									</cfcase>
								</cfswitch>
							</cfloop>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>					
			<div id="sepetim_total">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="totalBox">
						<div class="totalBoxHead font-grey-mint">
							<span class="headText"><cf_get_lang dictionary_id='57677.Döviz'></span>
							<div class="collapse">
								<span class="icon-minus"></span>
							</div>
						</div>
						<div class="totalBoxBody">
							<cfoutput>
								<table>
									<input type="hidden" name="kur_say" id="kur_say" value="#get_budget_plan_money.recordcount#">
									<cfloop query="get_budget_plan_money">
										<tr>
											<td height="17">
												<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
												<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
												<input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="toplam_doviz_hesapla();" <cfif is_selected eq 1>checked</cfif>>
											</td>
											<td>#MONEY#</td>
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<td>#TLFormat(rate1,0)#/</td>
											<td valign="bottom"><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_doviz_hesapla();"></td>
										</tr>
									</cfloop>
								</table>  
							</cfoutput>                  
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="totalBox">
						<div class="totalBoxHead font-grey-mint">
							<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='57635.Miktar'></span>
							<div class="collapse">
								<span class="icon-minus"></span>
							</div>
						</div>
						<div class="totalBoxBody">
							<table>
								<tr>
									<td width="150" class="txtbold" style="text-align:right;" colspan="2"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='57492.Toplam'></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58677.Gelir'></td>
									<td style="text-align:right;">
										<input type="text" name="income_total_amount" id="income_total_amount" class="box" readonly="" value="#TLFormat(GET_BUDGET_PLAN.INCOME_TOTAL)#" style="width:100%;">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58678.Gider'></td>
									<td style="text-align:right;">
										<input type="text" name="expense_total_amount" id="expense_total_amount" class="box" readonly="" value="#TLFormat(GET_BUDGET_PLAN.EXPENSE_TOTAL)#" style="width:100%;">
									</td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='58583.Fark'></td>
									<td style="text-align:right;">
										<input type="text" name="diff_total_amount" id="diff_total_amount" class="box" readonly="" value="#TLFormat(GET_BUDGET_PLAN.DIFF_TOTAL)#" style="width:100%;">
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
				<div class="totalBox">
					<div class="totalBoxHead font-grey-mint">
						<span class="headText"><cf_get_lang dictionary_id='58156.Diğer'></span>
						<div class="collapse">
							<span class="icon-minus"></span>
						</div>
					</div>
					<div class="totalBoxBody">
						<table>
							<tr>
								<td width="150" class="txtbold" style="text-align:right;" colspan="2"><input type="text" name="other_money_info" id="other_money_info" class="box" readonly="" style="width:35px;" value="<cfoutput>#GET_BUDGET_PLAN.OTHER_MONEY#</cfoutput>">&nbsp;&nbsp;<cf_get_lang dictionary_id='57492.Toplam'></td>
							</tr>
							<tr>
								<td style="text-align:right;">
									<input type="text" name="other_income_total_amount" id="other_income_total_amount" class="box" readonly="" value="#TLFormat(GET_BUDGET_PLAN.OTHER_INCOME_TOTAL)#" style="width:100%;">
								</td>
							</tr>
							<tr>
								<td style="text-align:right;">
									<input type="text" name="other_expense_total_amount" id="other_expense_total_amount" class="box" readonly="" value="#TLFormat(GET_BUDGET_PLAN.OTHER_EXPENSE_TOTAL)#" style="width:100%;">
								</td>
							</tr>
							<tr>
								<td style="text-align:right;">
									<input type="text" name="other_diff_total_amount" id="other_diff_total_amount" class="box" readonly="" value="#TLFormat(GET_BUDGET_PLAN.OTHER_DIFF_TOTAL)#" style="width:100%;">
								</td>
							</tr>
						</table>
					</div>
				</div>
				</div>
			</div>
			<cf_box_footer>	
				<div class="col col-6">
					<cf_record_info query_name='get_budget_plan'>
				</div>                	
				<div class="col col-6">
					<cfif len(get_budget_plan.invoice_id)>
						<cfoutput>
							<cfif get_budget_plan.period_id eq session.ep.period_id>
								<span style = "color:red;"><cf_get_lang dictionary_id='64344.Bu kayıt'> #get_budget_plan.invoice_number# <cf_get_lang dictionary_id='64343.numaralı faturadan oluşturulmuştur.'></span>
							<cfelse>
								<span style = "color:red;"><cf_get_lang dictionary_id='64345.Bu kayıt faturadan oluşturulmuştur. Lütfen ilgili döneme geçiniz.'></span>
							</cfif>
						</cfoutput>
					<cfelse>
						<cf_workcube_buttons is_upd='1' add_function='kontrol()' update_status="#get_budget_plan.upd_status#" del_function_for_submit='del_kontrol()' delete_page_url='#request.self#?fuseaction=budget.emptypopup_del_budget_plan&budget_plan_id=#attributes.budget_plan_id#&old_process_type=#get_budget_plan.process_type#&budget_id=#get_budget_plan.budget_id#'>
					</cfif>
				</div>
			</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">

		var count = 0;
       $('.collapse').click(function(){
        $(this).parent().parent().find('.totalBoxBody').slideToggle();
            if($(this).find("span").hasClass("icon-minus")){
                $(this).find("span").removeClass("icon-minus").addClass("icon-pluss");
            }
            else{
                $(this).find("span").removeClass("icon-pluss").addClass("icon-minus");
            }
	   });

	row_count=<cfoutput>#get_budget_plan_row.recordcount#</cfoutput>;

	function open_wizard() {
		document.getElementById("wizard_div").style.display ='';
		
		$("#wizard_div").css('margin-left',$("#tabMenu").position().left - 500);
		$("#wizard_div").css('margin-top',$("#tabMenu").position().top + 50);
		$("#wizard_div").css('position','absolute');
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_budget_row_calculator&type=budget_plan','wizard_div',1);
		return true;
	}

	function display_duedate()
	{
		if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
		{
			document.getElementById('item-due_date').style.display = '';
		}
		else
		{
			document.getElementById('item-due_date').style.display = 'none';
		}
	}

	function check_all(deger)
	{
		if(upd_budget_plan.hepsi.checked)
		{
			for(i=1;i<=document.getElementById("record_num").value;i++)
			{
				if(document.getElementById("row_kontrol"+i).value==1 && document.getElementById("is_payment"+i).disabled==false)
				{
					var form_field = document.getElementById("is_payment" + i);
					form_field.checked = true;
					document.getElementById("is_payment"+i).focus();
				}
			}
		}
		else
		{
			for(i=1;i<=document.getElementById("record_num").value;i++)
			{
				if(document.getElementById("row_kontrol"+i).value==1 && document.getElementById("is_payment"+i).disabled==false)
				{
					form_field = document.getElementById("is_payment" + i);
					form_field.checked = false;
					document.getElementById("is_payment"+i).focus();
				}
			}
		}
	}
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		document.getElementById("record_num_kontrol").value=document.getElementById("record_num_kontrol").value-1;
	}
	function add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_head,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name)
	{
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if(expense_date == undefined)expense_date = '';
		if(row_detail == undefined)row_detail = '';
		if(expense_center_id == undefined)expense_center_id = '';
		if(expense_item_id == undefined)expense_item_id = '';
		if(expense_item_name == undefined)expense_item_name = '';
		if(expense_cat_id == undefined)expense_cat_id = '';
		if(expense_cat_name == undefined)expense_cat_name = '';
		if(account_id == undefined)account_id = '';
		if(account_code == undefined)account_code = '';
		if(activity_type == undefined)activity_type = '';
		if(workgroup_id == undefined)workgroup_id = '';
		if(member_type == undefined)member_type = '';
		if(company_id == undefined)company_id = '';
		if(consumer_id == undefined)consumer_id = '';
		if(employee_id == undefined)employee_id = '';
		if(authorized == undefined)authorized = '';
		if(project_id == undefined) project_id = '';
		if(project_head == undefined) project_head = '';
		if(assetp_id == undefined) assetp_id = '';
		if(assetp_name == undefined) assetp_name = '';
		if(income_total == undefined)income_total = 0;
		if(expense_total == undefined)expense_total = 0;
		if(diff_total == undefined)diff_total = 0;
		if(other_income_total == undefined)other_income_total = 0;
		if(other_expense_total == undefined)other_expense_total = 0;
		if(other_diff_total == undefined)other_diff_total = 0;

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.className = 'color-row';
		document.getElementById("record_num").value=row_count;
		document.getElementById("record_num_kontrol").value=document.getElementById("record_num_kontrol").value+1;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="satir_no' + row_count +'" id="satir_no' + row_count +'" value=' +row_count+' class="boxtext" style="width:15px;" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="0" name="budget_plan_row_id' + row_count +'" id="budget_plan_row_id' + row_count +'"><input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>"></i></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="icon-copy"></i></a>';
		<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
			<cfswitch expression="#xlr#">
				<cfcase value="1">//1.Tarih
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="expense_date' + row_count +'" id="expense_date' + row_count +'" class="text" maxlength="10" value="' + expense_date +'"><span class="input-group-addon" id="expense_date' + row_count + '_td"></span></div></div>';
					wrk_date_image('expense_date' + row_count);
				</cfcase>
				<cfcase value="2">//2.Açıklama
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:120px;" class="boxtext" maxlength="300" value="' + row_detail +'"></div>';
				</cfcase>
				<cfcase value="3">//3.Masraf Merkezi
					newCell = newRow.insertCell(newRow.cells.length);
					a = '<div class="form-group"><select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'"  style="width:100px;" class="boxtext"><option value=""><cf_get_lang dictionary_id="58235.Masraf/Gelir Merkezi"></option>';
					<cfoutput query="get_expense_center">
						if('#expense_id#' == expense_center_id)
							a += '<option value="#expense_id#" selected>#expense#</option>';
						else
							a += '<option value="#expense_id#">#expense#</option>';
					</cfoutput>
					newCell.innerHTML =a+ '</select></div>';
				</cfcase>
				<cfcase value="4">//4.Butce Kategorisi
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type ="hidden" name="expense_cat_id' + row_count + '" id="expense_cat_id' + row_count + '" value="'+ expense_cat_id +'"><input type="text" name="expense_cat_name'+ row_count +'" id="expense_cat_name'+ row_count +'" value="'+ expense_cat_name +'" class="boxtext"></div>';
				</cfcase>
				<cfcase value="5">//5.Butce Kalemi
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+expense_item_id+'"><input type="text" style="width:105px;" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" class="boxtext" value="'+expense_item_name+'" onFocus="autocomp_budget('+row_count+');"><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_exp('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="6">//6.Muhasebe Kodu
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="text" style="width:105px;" name="account_code' + row_count +'" id="account_code' + row_count +'" class="boxtext"  value="'+account_code+'" onFocus="autocomp_acc_code('+row_count+');"> <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="7">//7.Aktivite Tipi
					newCell = newRow.insertCell(newRow.cells.length);
					b = '<div class="form-group"><select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:100px;" class="boxtext"><option value=""><cf_get_lang dictionary_id="49184.Aktivite Tipi"></option>';
					<cfoutput query="get_activity_types">
						if('#activity_id#' == activity_type)
							b += '<option value="#activity_id#" selected>#activity_name#</option>';
						else
							b += '<option value="#activity_id#">#activity_name#</option>';
					</cfoutput>
					newCell.innerHTML =b+ '</select></div>';
				</cfcase>
				<cfcase value="8">//8.Is Grubu
					newCell = newRow.insertCell(newRow.cells.length);
					b = '<div class="form-group"><select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:100px;" class="boxtext"><option value=""><cf_get_lang dictionary_id="58140.İş Grubu"></option>';
					<cfoutput query="get_workgroups">
						if('#workgroup_id#' == workgroup_id)
							b += '<option value="#workgroup_id#" selected>#workgroup_name#</option>';
						else
							b += '<option value="#workgroup_id#">#workgroup_name#</option>';
					</cfoutput>
					newCell.innerHTML =b+ '</select></div>';
				</cfcase>
				<cfcase value="17">//17.Fiziki Varlik
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="assetp_id'+ row_count +'" id="assetp_id'+ row_count +'" value="'+assetp_id+'"><input type="text" style="width:105px;" name="assetp_name'+ row_count +'" id="assetp_name'+ row_count +'" onFocus="autocomp_assetp('+row_count+');" value="'+assetp_name+'" class="boxtext"> <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_assetp('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="9">//9.Proje
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+project_id+'"><input type="text" style="width:105px;" name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="'+project_head+'" class="boxtext"> <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="10">//10.Cari Hesap
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+member_type+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+company_id+'"><input type="hidden" name="consumer_id'+ row_count +'" id="consumer_id'+ row_count +'" value="'+consumer_id+'"><input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value="'+employee_id+'"><input type="text" style="width:110px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+authorized+'" onFocus="autocomp_cari('+row_count+');" class="boxtext">&nbsp;<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_ac_company('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="11">//11.Gelir TL
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="income_total' + row_count +'" id="income_total' + row_count +'" value="'+income_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
				</cfcase>
				<cfcase value="12">//12.Gider TL
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="expense_total' + row_count +'" id="expense_total' + row_count +'" value="'+expense_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
				</cfcase>
				<cfcase value="13">//13.Fark TL
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="diff_total' + row_count +'" id="diff_total' + row_count +'" value="'+diff_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="hesapla('+row_count+');" readonly="yes"></div>';
				</cfcase>
				<cfcase value="14">//14.Gelir Doviz
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_income_total' + row_count +'" id="other_income_total' + row_count +'" value="'+other_income_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly="yes"></div>';
				</cfcase>
				<cfcase value="15">//15.Gider Doviz
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_expense_total' + row_count +'" id="other_expense_total' + row_count +'" value="'+other_expense_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly="yes"></div>';
				</cfcase>
				<cfcase value="16">//16.Fark Doviz
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_diff_total' + row_count +'" id="other_diff_total' + row_count +'" value="'+other_diff_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly="yes"></div>';
				</cfcase>
			</cfswitch>
		</cfloop>
		toplam_hesapla();
	}
	function copy_row(no)
	{
		if (document.getElementById("expense_date" + no) == undefined) expense_date =""; else expense_date = document.getElementById("expense_date" + no).value;
		if (document.getElementById("row_detail" + no) == undefined) row_detail =""; else row_detail = document.getElementById("row_detail" + no).value;
		if (document.getElementById("expense_center_id" + no) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no).value;
		if (document.getElementById("expense_item_id" + no) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no).value;
		if (document.getElementById("expense_item_name" + no) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no).value;
		if(document.getElementById("expense_cat_id" + no) != undefined)
		{
			expense_cat_id = document.getElementById("expense_cat_id" + no).value;
			expense_cat_name = document.getElementById("expense_cat_name" + no).value;
		}
		else
		{
			expense_cat_id = '';
			expense_cat_name = '';
		}
		if (document.getElementById("account_id" + no) == undefined) account_id =""; else account_id = document.getElementById("account_id" + no).value;
		if (document.getElementById("account_code" + no) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no).value;
		if (document.getElementById("activity_type" + no) == undefined) activity_type =""; else activity_type = document.getElementById("activity_type" + no).value;
		if (document.getElementById("workgroup_id" + no) == undefined) workgroup_id =""; else workgroup_id = document.getElementById("workgroup_id" + no).value;
		if (document.getElementById("member_type" + no) == undefined) member_type =""; else member_type = document.getElementById("member_type" + no).value;
		if (document.getElementById("company_id" + no) == undefined) company_id =""; else company_id = document.getElementById("company_id" + no).value;
		if (document.getElementById("consumer_id" + no) == undefined) consumer_id =""; else consumer_id = document.getElementById("consumer_id" + no).value;
		if (document.getElementById("employee_id" + no) == undefined) employee_id =""; else employee_id = document.getElementById("employee_id" + no).value;
		if (document.getElementById("authorized" + no) == undefined) authorized =""; else authorized = document.getElementById("authorized" + no).value;
		if(document.getElementById("project_id" + no) != undefined)
		{
			project_id = document.getElementById("project_id" + no).value;
			project_head = document.getElementById("project_head" + no).value;
		}
		else
		{
			project_id = '';
			project_head = '';
		}
		if(document.getElementById("assetp_id" + no) != undefined)
		{
			assetp_id = document.getElementById("assetp_id" + no).value;
			assetp_name = document.getElementById("assetp_name" + no).value;
		}
		else
		{
			assetp_id = '';
			assetp_name = '';
		}
		if (document.getElementById("income_total" + no) == undefined) income_total =""; else income_total = document.getElementById("income_total" + no).value;
		if (document.getElementById("expense_total" + no) == undefined) expense_total =""; else expense_total = document.getElementById("expense_total" + no).value;
		if (document.getElementById("diff_total" + no) == undefined) diff_total =""; else diff_total = document.getElementById("diff_total" + no).value;
		if (document.getElementById("other_income_total" + no) == undefined) other_income_total =""; else other_income_total = document.getElementById("other_income_total" + no).value;
		if (document.getElementById("other_expense_total" + no) == undefined) other_expense_total =""; else other_expense_total = document.getElementById("other_expense_total" + no).value;
		if (document.getElementById("other_diff_total" + no) == undefined) other_diff_total =""; else other_diff_total = document.getElementById("other_diff_total" + no).value;
		add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_head,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name);
	}
	function pencere_ac_acc(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_budget_plan.account_id' + no +'&field_name=upd_budget_plan.account_code' + no +'');
	}
	function pencere_ac_exp(no)
	{
		var selected_ptype = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
		eval('var proc_control = document.upd_budget_plan.ct_process_type_'+selected_ptype+'.value');
		if(document.getElementById("expense_cat_id" + no) != undefined)
		{
			if(proc_control != 161)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_budget_plan.expense_item_id' + no +'&field_name=upd_budget_plan.expense_item_name' + no + '&field_account_no=upd_budget_plan.account_code' + no +'&field_account_no2=upd_budget_plan.account_id' + no + '&field_cat_id=upd_budget_plan.expense_cat_id' + no + '&field_cat_name=upd_budget_plan.expense_cat_name' + no);
			else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_budget_plan.expense_item_id' + no +'&field_name=upd_budget_plan.expense_item_name' + no + '&field_cat_id=upd_budget_plan.expense_cat_id' + no + '&field_cat_name=upd_budget_plan.expense_cat_name' + no);
		}
		else
		{
			if(proc_control != 161)
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_budget_plan.expense_item_id' + no +'&field_name=upd_budget_plan.expense_item_name' + no + '&field_account_no=upd_budget_plan.account_code' + no +'&field_account_no2=upd_budget_plan.account_id' + no);
			else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_budget_plan.expense_item_id' + no +'&field_name=upd_budget_plan.expense_item_name' + no);
		}
	}

	function pencere_ac_company(no)
	{
		document.getElementById("company_id"+no).value='';
		document.getElementById("authorized"+no).value='';
		document.getElementById("employee_id"+no).value='';
		document.getElementById("consumer_id"+no).value='';
		var send_account_code = '';
		<cfif xml_account_code_from_member eq 1>
			var send_account_code= "&field_member_account_code=upd_budget_plan.account_code"+no+"&field_member_account_id=upd_budget_plan.account_id"+no;
		</cfif>
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1'+send_account_code+'&field_name=upd_budget_plan.authorized' + no +'&field_type=upd_budget_plan.member_type' + no +'&field_comp_name=upd_budget_plan.authorized' + no +'&field_consumer=upd_budget_plan.consumer_id' + no + '&field_emp_id=upd_budget_plan.employee_id' + no + '&field_comp_id=upd_budget_plan.company_id' + no + '&select_list=1,2,3,9');
	}
	function hesapla(row_no)
	{
		if(document.getElementById("diff_total"+row_no) != undefined)
			document.getElementById("diff_total"+row_no).value = commaSplit(filterNum(document.getElementById("income_total"+row_no).value)-filterNum(document.getElementById("expense_total"+row_no).value));
		if(document.getElementById("kur_say").value == 1)
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
						if(document.getElementById("other_diff_total"+k) != undefined)
							document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info2") != undefined)
						document.getElementById("other_money_info2").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.getElementById("rd_money").value;
				}
			}
		else
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.upd_budget_plan.rd_money[t-1].checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						if(document.getElementById("other_income_total"+k) != undefined)
							document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
						if(document.getElementById("other_diff_total"+k) != undefined)
							document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.upd_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info2") != undefined)
						document.getElementById("other_money_info2").value = document.upd_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.upd_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.upd_budget_plan.rd_money[t-1].value;
				}
			}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var total_amount = 0;
		var other_total_amount = 0;
		var expense_total = 0;
		var other_expense_total = 0;
		var diff_total = 0;
		var other_diff_total = 0;
		for(j=1;j<=document.getElementById("record_num").value;j++)
		{
			if(document.getElementById("row_kontrol"+j).value==1)
			{
				total_amount = parseFloat(total_amount + parseFloat(filterNum(document.getElementById("income_total"+j).value)));
				if(document.getElementById("other_income_total"+j) != undefined)
					other_total_amount = parseFloat(other_total_amount + parseFloat(filterNum(document.getElementById("other_income_total"+j).value)));
				expense_total = parseFloat(expense_total + parseFloat(filterNum(document.getElementById("expense_total"+j).value)));
				if(document.getElementById("other_expense_total"+j) != undefined)
					other_expense_total = parseFloat(other_expense_total + parseFloat(filterNum(document.getElementById("other_expense_total"+j).value)));
				if(document.getElementById("diff_total"+j) != undefined)
					diff_total = parseFloat(diff_total + parseFloat(filterNum(document.getElementById("diff_total"+j).value)));
				if(document.getElementById("other_diff_total"+j) != undefined)
					other_diff_total = parseFloat(other_diff_total + parseFloat(filterNum(document.getElementById("other_diff_total"+j).value)));
			}
		}
		document.getElementById("income_total_amount").value = commaSplit(total_amount);
		document.getElementById("other_income_total_amount").value = commaSplit(other_total_amount);
		document.getElementById("expense_total_amount").value = commaSplit(expense_total);
		document.getElementById("other_expense_total_amount").value = commaSplit(other_expense_total);
		document.getElementById("diff_total_amount").value = commaSplit(diff_total);
		document.getElementById("other_diff_total_amount").value = commaSplit(other_diff_total);
	}
	function toplam_doviz_hesapla()
	{
		if(document.getElementById("kur_say").value == 1)
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
						if(document.getElementById("other_diff_total"+k) != undefined)
							document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.getElementById("rd_money").value;
					document.getElementById("other_money_info2").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.getElementById("rd_money").value;
				}
			}
		else
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.upd_budget_plan.rd_money[t-1].checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						if(document.getElementById("other_income_total"+k) != undefined)
							document.getElementById("other_income_total"+k).value = commaSplit(filterNum(document.getElementById("income_total"+k).value)/rate2_value);
						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
						if(document.getElementById("other_diff_total"+k) != undefined)
							document.getElementById("other_diff_total"+k).value = commaSplit(filterNum(document.getElementById("diff_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.upd_budget_plan.rd_money[t-1].value;
					document.getElementById("other_money_info2").value = document.upd_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.upd_budget_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.upd_budget_plan.rd_money[t-1].value;
				}
			}
		toplam_hesapla();
	}
	function del_kontrol()
	{
		return control_account_process(<cfoutput>'#attributes.budget_plan_id#','#get_budget_plan.PROCESS_TYPE#'</cfoutput>);
		
	}
	function kontrol()
	{
		if(!chk_process_cat('upd_budget_plan')) return false;
		if(!chk_period(upd_budget_plan.record_date,"İşlem")) return false;
		if(!check_display_files('upd_budget_plan')) return false;
		if(!paper_control(document.getElementById("paper_number"),'BUDGET_PLAN',true,'<cfoutput>#attributes.budget_plan_id#</cfoutput>','<cfoutput>#get_budget_plan.paper_no#</cfoutput>','0','0','0','<cfoutput>#dsn#</cfoutput>')) return false;
		if(document.getElementById("paper_number").value == "")
		{
			alert("<cf_get_lang dictionary_id='49122.Lütfen Belge No Giriniz'> !");
			return false;
		}
		if((document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3) && document.getElementById('due_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='59046.Vade Tarihi Giriniz'>!");
			return false;
		}
		var record_exist=0;
		process=document.getElementById("process_cat").value;
		var get_process_cat = wrk_safe_query('bdg_get_process_cat','dsn3',0,process);
		var selected_ptype = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
		eval('var proc_control = document.upd_budget_plan.ct_process_type_'+selected_ptype+'.value');
		var income_total_ = 0;
		var expense_total_ = 0;
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2 and session.ep.isBranchAuthorization eq 0> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.getElementById("acc_department_id").options[document.getElementById("acc_department_id").selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lütfen Departman Seçiniz'>!");
				return false;
			}
		</cfif>
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				var account_code_value = list_getat(document.getElementById("account_code"+r).value,1,'-');
				if(account_code_value != "")
				{
					if(WrkAccountControl(account_code_value,r+ "<cf_get_lang dictionary_id='58508.Satır:'><cf_get_lang dictionary_id='52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir'>") == 0)
					return false;
				}
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				record_exist=1;
				if (document.getElementById("expense_date"+r) != undefined && document.getElementById("expense_date"+r).value == "")
				{
					alert ("<cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'>!");
					return false;
				}
				if(is_show_project==1){
					if (document.getElementById("project_id"+r) != undefined && document.getElementById("project_id"+r).value == "")
					{
						
						alert ("<cf_get_lang dictionary_id='32379.Lütfen Proje Seçiniz'>!");
						return false;
					}
				}
				if (document.getElementById("row_detail"+r).value == "")
				{
					alert ("<cf_get_lang dictionary_id='49156.Lütfen Açıklama Giriniz'>!");
					return false;
				}
				if(proc_control != 161)
				{
					x = document.getElementById("expense_center_id"+r).selectedIndex;
					if (document.getElementById("expense_center_id"+r)[x].value == "")
					{
						alert ("<cf_get_lang dictionary_id='49154.Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
						return false;
					}
					if (get_process_cat.IS_ACCOUNT == 0)
					{
						if (document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "")
						{
							alert ("<cf_get_lang dictionary_id='49131.Lütfen Bütçe Kalemi Seçiniz'>!");
							return false;
						}
					}
					<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),10)>
						if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
						{
							if(document.getElementById("authorized"+r).value != "")
							{
								alert("<cf_get_lang dictionary_id='49112.Gelir ve Gider Değerlerini Girdiğinizde Cari Hesap Seçemezsiniz'> !");
								return false;
							}
						}
					</cfif>
					if (get_process_cat.IS_ACCOUNT == 1)
					{
						if (document.getElementById("account_code"+r).value == "")
						{
							alert ("<cf_get_lang dictionary_id='49133.Lütfen Muhasebe Kodu Seçiniz'> !");
							return false;
						}
					}
				}
				else
				{
					if ((document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "") && document.getElementById("authorized"+r).value == '' && document.getElementById("account_code"+r).value == '')
					{
						alert ("<cf_get_lang dictionary_id='59037.Bütçe Kalemi, Cari Hesap veya Muhasebe Kodu Seçmelisiniz'>!");
						return false;
					}
					if ((document.getElementById("expense_item_id"+r).value != "" && document.getElementById("expense_item_name"+r).value != ""))
					{
						x = document.getElementById("expense_center_id"+r).selectedIndex;
						if (document.getElementById("expense_center_id"+r)[x].value == "")
						{
							alert ("<cf_get_lang dictionary_id='49154.Satıra Lütfen Masraf/Gelir Merkezi Seçiniz'>!");
							return false;
						}
					}
					if(filterNum(document.getElementById("income_total"+r).value) > 0 && filterNum(document.getElementById("expense_total"+r).value) > 0)
					{
						alert("<cf_get_lang dictionary_id='59043.Tahakkuk Fişi İçin Gelir ve Gider Değerlerini Aynı Anda Giremezsiniz'>!");
						return false;
					}
					if(document.getElementById("account_code"+r).value != '')
					{
						income_total_ = parseFloat(income_total_ + parseFloat(filterNum(document.getElementById("income_total"+r).value)));
						expense_total_ = parseFloat(expense_total_ + parseFloat(filterNum(document.getElementById("expense_total"+r).value)));
					}
				}
			}
		}
		<cfif is_kontrol_value eq 1>
			if(proc_control == 161)
			{
				if(filterNum(document.getElementById("income_total_amount").value) != filterNum(document.getElementById("expense_total_amount").value))
				{
					alert("<cf_get_lang dictionary_id='59044.Tahakkuk Fişi İçin Gelir ve Gider Değer Toplamları Eşit Olmalı'>!");
					return false;
				}
			}
		</cfif>
		if(proc_control == 161 && get_process_cat.IS_ACCOUNT != 0)
		{
			if(commaSplit(income_total_) != commaSplit(expense_total_))
			{
				alert("<cf_get_lang no='100.Muhasebe Hesabı Seçilen Satırların Gelir Gider Toplamları Eşit Olmalı'>!");
				return false;
			}
		}
		if (record_exist == 0)
		{
			alert("<cf_get_lang dictionary_id='49152.Lütfen Plan Giriniz'>!");
			return false;
		}
		process_cat_control();
		return(unformat_fields());
		return control_account_process(<cfoutput>'#attributes.budget_plan_id#','#get_budget_plan.PROCESS_TYPE#'</cfoutput>);
	}
	function unformat_fields()
	{
		for(rm=1;rm<=document.getElementById("record_num").value;rm++)
		{
			document.getElementById("income_total"+rm).value =  filterNum(document.getElementById("income_total"+rm).value);
			if(document.getElementById("other_income_total"+rm) != undefined)
				document.getElementById("other_income_total"+rm).value =  filterNum(document.getElementById("other_income_total"+rm).value);
			document.getElementById("expense_total"+rm).value =  filterNum(document.getElementById("expense_total"+rm).value);
			if(document.getElementById("other_expense_total"+rm) != undefined)
				document.getElementById("other_expense_total"+rm).value =  filterNum(document.getElementById("other_expense_total"+rm).value);
			if(document.getElementById("diff_total"+rm) != undefined)
				document.getElementById("diff_total"+rm).value =  filterNum(document.getElementById("diff_total"+rm).value);
			if(document.getElementById("other_diff_total"+rm) != undefined)
				document.getElementById("other_diff_total"+rm).value =  filterNum(document.getElementById("other_diff_total"+rm).value);
		}
		document.getElementById("income_total_amount").value = filterNum(document.getElementById("income_total_amount").value);
		document.getElementById("expense_total_amount").value = filterNum(document.getElementById("expense_total_amount").value);
		document.getElementById("other_income_total_amount").value = filterNum(document.getElementById("other_income_total_amount").value);
		document.getElementById("other_expense_total_amount").value = filterNum(document.getElementById("other_expense_total_amount").value);
		document.getElementById("diff_total_amount").value = filterNum(document.getElementById("diff_total_amount").value);
		document.getElementById("other_diff_total_amount").value = filterNum(document.getElementById("other_diff_total_amount").value);

		for(st=1;st<=document.getElementById("kur_say").value;st++)
		{
			document.getElementById("txt_rate2_" + st).value = filterNum(document.getElementById("txt_rate2_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("txt_rate1_" + st).value = filterNum(document.getElementById("txt_rate1_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}

	}
	function open_exp_center()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=upd_budget_plan.wizard_expense_center_id&field_name=upd_budget_plan.wizard_expense_center');
	}
	function open_exp_item(sira)
	{
		if(sira == 1)
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_budget_plan.wizard_month_expense_item_id&field_name=upd_budget_plan.wizard_month_expense_item_name&field_account_no=upd_budget_plan.wizard_month_account_code&field_account_id=upd_budget_plan.wizard_month_account_id');
		else if(sira == 2)
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_budget_plan.wizard_year_expense_item_id&field_name=upd_budget_plan.wizard_year_expense_item_name&field_account_no=upd_budget_plan.wizard_year_account_code&field_account_id=upd_budget_plan.wizard_year_account_id');
	}
	function change_date_info()
	{
		if(document.getElementById("temp_date").value != '')
			for(tt=1;tt<=document.getElementById("record_num").value;tt++)
				if(document.getElementById("row_kontrol"+tt).value==1)
					document.getElementById("expense_date"+tt).value = document.getElementById("temp_date").value;
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_budget_plan.project_id' + no +'&project_head=upd_budget_plan.project_head' + no +'');
	}
	function autocomp_project(no)
	{
		AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
	}
	function pencere_ac_assetp(no)
	{
		adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps';
		adres += '&field_id=all.assetp_id' + no +'&field_name=all.assetp_name' + no +'&event_id=0&motorized_vehicle=0';
		openBoxDraggable(adres);
	}
	function autocomp_assetp(no)
	{
		AutoComplete_Create("assetp_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","assetp_id"+no,"",3,200);
	}
	function autocomp_acc_code(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","","ACCOUNT_CODE","account_id"+no,"",3,225);
	}
	function autocomp_budget(no)
	{
		AutoComplete_Create("expense_item_name"+no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME","expense_item_id"+no+",account_code"+no+",account_id"+no+",expense_cat_id"+no+",expense_cat_name"+no,3,200);
	}
	function autocomp_cari(no)
	{
		<cfif xml_account_code_from_member eq 1>
			AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\",\"\",\"\"","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,ACCOUNT_CODE,ACCOUNT_CODE","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no+",account_code"+no+",account_id"+no,'upd_budget_plan',3,250);
		<cfelse>
			AutoComplete_Create("authorized"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\"","MEMBER_TYPE,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","member_type"+no+",company_id"+no+",consumer_id"+no+",employee_id"+no,3,250);
		</cfif>
	}
	var is_show_project = <cfoutput>#is_show_project#</cfoutput>;
	toplam_hesapla();
	toplam_doviz_hesapla();
</script>