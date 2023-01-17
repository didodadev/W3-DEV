<cf_xml_page_edit fuseact="salesplan.add_sales_quota">
<cfif isdefined("attributes.q_id") and len(attributes.q_id)>
	<cfquery name="get_sales_quotas" datasource="#dsn3#">
		SELECT * FROM SALES_QUOTAS WHERE SALES_QUOTA_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.q_id#">
	</cfquery>
	<cfquery name="get_sales_quotas_row" datasource="#dsn3#">
		SELECT * FROM SALES_QUOTAS_ROW WHERE SALES_QUOTA_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.q_id#"> ORDER BY SALES_QUOTA_ROW_ID
	</cfquery>
	<cfquery name="get_sales_quotas_money" datasource="#dsn3#">
		SELECT MONEY_TYPE AS MONEY,* FROM SALES_QUOTAS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.q_id#">
	</cfquery>
</cfif>
<cfif (isdefined("attributes.q_id") and not get_sales_quotas_money.recordcount) or not isdefined("attributes.q_id")>
	<cfquery name="get_sales_quotas_money" datasource="#dsn2#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY ORDER BY MONEY_ID
	</cfquery>
</cfif>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
	SELECT HIERARCHY,PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT ORDER BY HIERARCHY
</cfquery>
<cfquery name="get_company_cat" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM  COMPANY_CAT  ORDER BY COMPANYCAT
</cfquery>
<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
<cfset attributes.finish_date = date_add('d',+7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
<cfform name="add_sales_quota" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_quota" enctype="multipart/form-data">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
	<cfoutput>
	<input type="hidden" name="multi_category_selected" id="multi_category_selected" value="#x_row_multi_category_selected#">
	<input type="hidden" name="x_premium_percent_2_3" id="x_premium_percent_2_3" value="#x_premium_percent_2_3#">
	<input type="hidden" name="x_products_not_included" id="x_products_not_included" value="#x_products_not_included#">
	</cfoutput>
	<cf_box_elements id="sales_quota">
		<cfoutput>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_active">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<input type="checkbox" name="is_active" id="is_active"  <cfif (isdefined("attributes.q_id") and get_sales_quotas.is_active eq 1) or not isdefined("attributes.q_id")>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
					</label>
				</div>
				<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_purchase_discounts">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<input type="checkbox" name="is_purchase_discounts" id="is_purchase_discounts" value="1" <cfif (isdefined("attributes.q_id") and get_sales_quotas.is_purchase_discounts eq 1) or not isdefined("attributes.q_id")>checked</cfif>><cf_get_lang dictionary_id='41469.Satınalma Koşulları Düşülsün'>
					</label>
				</div>
				<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_action_discounts">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<input type="checkbox" name="is_action_discounts" id="is_action_discounts" value="1" <cfif (isdefined("attributes.q_id") and get_sales_quotas.is_action_discounts eq 1) or not isdefined("attributes.q_id")>checked</cfif>><cf_get_lang dictionary_id='41485.Aksiyon İndirimleri Düşülsün'>
					</label>
				</div>
				<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_total_inside_discounts">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<input type="checkbox" name="is_total_inside_discounts" id="is_total_inside_discounts" value="1" <cfif (isdefined("attributes.q_id") and get_sales_quotas.is_total_inside_discounts eq 1) or not isdefined("attributes.q_id")>checked</cfif>><cf_get_lang dictionary_id='41486.Tutardan İndirimler Düşülsün'>
					</label>
				</div>
				<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-is_returns">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<input type="checkbox" name="is_returns" id="is_returns" value="1" <cfif isdefined("attributes.q_id") and get_sales_quotas.is_returns eq 1>checked</cfif>><cf_get_lang dictionary_id='41464.İadeler Düşülsün'>
					</label>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
					<div class="col col-8 col-xs-12">
						<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
					</div>
				</div>
				<div class="form-group" id="item-paper_no">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
					<div class="col col-8 col-xs-12">
							<cfinput type="text" name="paper_no" value="" maxlength="40" style="width:120px;" required="yes">
					</div>
				</div>
				<div class="form-group" id="item-comp_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'> - <cf_get_lang dictionary_id='57322.Satış Ortağı'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id')>#attributes.company_id#<cfelseif isdefined("attributes.q_id") and Len(get_sales_quotas.company_id)>#get_sales_quotas.company_id#</cfif>">
							<input name="comp_name" type="text" id="comp_name" value="<cfif isdefined('attributes.comp_name')>#attributes.comp_name#<cfelseif isdefined("attributes.q_id") and Len(get_sales_quotas.company_id)>#get_par_info(get_sales_quotas.company_id,1,0,0)#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID','company_id,partner_name,consumer_id,partner_id','','3','200');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&select_list=2,3&field_name=add_sales_quota.partner_name&field_partner=add_sales_quota.partner_id&field_comp_name=add_sales_quota.comp_name&field_comp_id=add_sales_quota.company_id&field_consumer=add_sales_quota.consumer_id</cfoutput>&call_function=add_general_prom()'); "title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-partner_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
					<div class="col col-8 col-xs-12">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.partner_id)>#get_sales_quotas.partner_id#</cfif>">
							<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.consumer_id)>#get_sales_quotas.consumer_id#</cfif>">
							<input type="text" name="partner_name" id="partner_name" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.partner_id)>#get_par_info(get_sales_quotas.partner_id,0,-1,0)#<cfelseif isdefined("attributes.q_id") and Len(get_sales_quotas.consumer_id)>#get_cons_info(get_sales_quotas.consumer_id,0,0)#</cfif>">
					</div>
				</div>
				<div class="form-group" id="item-start_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç Tarihi'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.plan_date)>
								<cfset start_date_ = get_sales_quotas.plan_date>
							<cfelse>
								<cfset start_date_ = attributes.start_date>
							</cfif>
							<cfinput name="start_date" type="text" validate="#validate_style#" required="Yes" value="#dateformat(start_date_,dateformat_style)#" passThrough="onblur=""change_money_info('add_sales_quota','start_date');""">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date" call_function="change_money_info"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş Tarihi'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.finish_date)>
								<cfset finish_date_ = get_sales_quotas.finish_date>
							<cfelse>
								<cfset finish_date_ = attributes.finish_date>
							</cfif>
							<cfinput name="finish_date" type="text" validate="#validate_style#" required="Yes"  value="#dateformat(finish_date_,dateformat_style)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<cfif is_multi_dimension eq 1>
				<div class="form-group" id="item-companycat_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
					<div class="col col-8 col-xs-12">
						<select name="companycat_id" id="companycat_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
							<cfloop query="get_company_cat">
								<option value="#companycat_id#" <cfif (isdefined("attributes.companycat_id") and attributes.companycat_id eq companycat_id) or (isdefined("attributes.q_id") and get_sales_quotas.companycat_id eq companycat_id)>selected</cfif>>#companycat#</option>
							</cfloop>
						</select>
					</div>
				</div>
				</cfif>
			<cfif is_multi_dimension eq 1>
				<div class="form-group" id="item-customer_value">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
					<div class="col col-8 col-xs-12">
						<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
							SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
						</cfquery>
						<select name="customer_value" id="customer_value" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="GET_CUSTOMER_VALUE">
								<option value="#CUSTOMER_VALUE_ID#" <cfif isdefined("attributes.q_id") and get_sales_quotas.customer_value_id eq customer_value_id>selected</cfif>>#CUSTOMER_VALUE#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-resource">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38262.İlişki Tipi'></label>
					<div class="col col-8 col-xs-12">
						<cfquery name="GET_RESOURCE" datasource="#dsn#">
							SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE
						</cfquery>
						<select name="resource" id="resource" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="GET_RESOURCE">
								<option value="#RESOURCE_ID#" <cfif isdefined("attributes.q_id") and get_sales_quotas.relation_type_id eq resource_id>selected</cfif>>#RESOURCE#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-project_head">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41585.İlişkili Proje'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.related_project_id)>#get_sales_quotas.related_project_id#</cfif>">
							<input name="project_head" type="text" id="project_head" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.related_project_id)>#get_project_name(get_sales_quotas.related_project_id)#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_sales_quota','3','120');" autocomplete="off" >
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_sales_quota.project_head&project_id=add_sales_quota.project_id');return false" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-budget_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41586.İlişkili Bütçe'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("attributes.q_id") and len(get_sales_quotas.related_budget_id)>
								<cfquery name="get_budget" datasource="#dsn#">
									SELECT BUDGET_NAME FROM BUDGET WHERE BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_quotas.related_budget_id#">
								</cfquery>
							</cfif>
							<input type="hidden" name="budget_id" id="budget_id" value="<cfif isdefined("attributes.q_id") and len(get_sales_quotas.related_budget_id)>#get_sales_quotas.related_budget_id#</cfif>">
							<input name="budget_name" type="text" id="budget_name" value="<cfif isdefined("attributes.q_id") and len(get_sales_quotas.related_budget_id)>#get_budget.budget_name#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('budget_name','BUDGET_NAME',' BUDGET_NAME','get_budget','','BUDGET_ID','budget_id','','3','120');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_budget&field_id=add_sales_quota.budget_id&field_name=add_sales_quota.budget_name&select_list=2','','ui-draggable-box-small');return false" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-planner_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41560.Planlayan'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="planner_id" id="planner_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.planner_emp_id)>#get_sales_quotas.planner_emp_id#</cfif>">
							<input name="planner_name" type="Text" id="planner_name" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.planner_emp_id)>#get_emp_info(get_sales_quotas.planner_emp_id,0,0)#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('planner_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','planner_id','','3','120');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_sales_quota.planner_id&field_name=add_sales_quota.planner_name&select_list=1');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
						</div>
					</div>
				</div>
				</cfif>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
			<cfif is_multi_dimension eq 1>
				<div class="form-group" id="item-sales_zone_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
					<div class="col col-8 col-xs-12">
						<cfquery name="GET_SALES_ZONES" datasource="#dsn#">
							SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
						</cfquery>
						<select name="sales_zone_id" id="sales_zone_id" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="GET_SALES_ZONES">
								<option value="#SZ_ID#" <cfif isdefined("attributes.q_id") and get_sales_quotas.sales_zone_id eq sz_id>selected</cfif>>#SZ_NAME#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-team_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58511.Takım'></label>
					<div class="col col-8 col-xs-12">
							<div class="input-group">
							<cfif isdefined("attributes.q_id") and len(get_sales_quotas.team_id)>
								<cfquery name="get_team" datasource="#dsn#">
									SELECT TEAM_NAME FROM SALES_ZONES_TEAM WHERE TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_quotas.team_id#">
								</cfquery>
							</cfif>
							<input type="hidden" name="team_id" id="team_id" value="<cfif isdefined("attributes.q_id") and len(get_sales_quotas.team_id)>#get_sales_quotas.team_id#</cfif>">
							<input name="team_name" type="text" id="team_name" value="<cfif isdefined("attributes.q_id") and len(get_sales_quotas.team_id)>#get_team.team_name#</cfif>" onFocus="AutoComplete_Create('team_name','TEAM_NAME','TEAM_NAME,SZ_NAME','get_team','','TEAM_ID','team_id','','3','175');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zones_team&field_sz_team_id=add_sales_quota.team_id&field_sz_team_name=add_sales_quota.team_name','','ui-draggable-box-small');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
					</div>
				</div>
				<div class="form-group" id="item-ims_code_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58134.Micro Bölge Kodu'></label>
					<div class="col col-8 col-xs-12">
							<div class="input-group">
							<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.ims_code_id)>
								<cfquery name="get_ims" datasource="#dsn#">
									SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALES_QUOTAS.IMS_CODE_ID#">
								</cfquery>
							</cfif>
							<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.ims_code_id)>#get_sales_quotas.ims_code_id#</cfif>">
							<input name="ims_code_name" type="text" id="ims_code_name" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.ims_code_id)>#get_ims.ims_code# #get_ims.ims_code_name#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('ims_code_name',' IMS_CODE_NAME',' IMS_CODE_NAME','get_code','',' IMS_CODE_ID','ims_code_id','','3','200');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=add_sales_quota.ims_code_name&field_id=add_sales_quota.ims_code_id&select_list=1','','ui-draggable-box-small');return false" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
					</div>
				</div>
				<div class="form-group" id="item-employee_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
					<div class="col col-8 col-xs-12">
							<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.employee_id)>#get_sales_quotas.employee_id#</cfif>">
							<input name="employee_name" type="Text" id="employee_name" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.employee_id)>#get_emp_info(get_sales_quotas.employee_id,0,0)#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','120');" autocomplete="on">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_sales_quota.employee_id&field_name=add_sales_quota.employee_name&select_list=1');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
					</div>
				</div>
				<div class="form-group" id="item-branch_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.branch_id)>
								<cfquery name="get_branch" datasource="#dsn#">
									SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_quotas.branch_id#">
								</cfquery>
							</cfif>
							<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.branch_id)>#get_sales_quotas.branch_id#</cfif>">
							<input name="branch_name" type="text" id="branch_name" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.branch_id)>#get_branch.branch_name#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('branch_name','BRANCH_NAME','BRANCH_NAME','get_position_branch','','BRANCH_ID','branch_id','add_sales_quota','3','120')" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=add_sales_quota.branch_id&field_branch_name=add_sales_quota.branch_name</cfoutput>')" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
					</div>
				</div>
				<div class="form-group" id="item-department">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
					<div class="col col-8 col-xs-12">
							<div class="input-group">
							<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.department_id)>
								<cfquery name="get_department" datasource="#dsn#">
									SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_quotas.department_id#">
								</cfquery>
							</cfif>
							<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.department_id)>#get_sales_quotas.department_id#</cfif>">
							<input type="text" name="department" id="department" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.department_id)>#get_department.department_head#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD,BRANCH_NAME','get_department1','','DEPARTMENT_ID','department_id','','3','200');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick=" openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_sales_quota.department_id' +'&field_name=add_sales_quota.department','','ui-draggable-box-small')" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
					</div>
				</div>
				</cfif>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
				<div class="form-group" id="item-quota_type">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41595.Kota Türü'>*</label>
					<div class="col col-8 col-xs-12">
						<select name="quota_type" id="quota_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif isdefined("attributes.q_id") and get_sales_quotas.is_sales_purchase eq 1>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
							<option value="0" <cfif isdefined("attributes.q_id") and get_sales_quotas.is_sales_purchase eq 0>selected</cfif>><cf_get_lang dictionary_id='57449.Satınalma'></option>
						</select>
					</div>
				</div>
			<cfif x_main_product_info eq 1>
				<div class="form-group" id="item-main_product_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="main_product_id" id="main_product_id" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.main_product_id)>#get_sales_quotas.main_product_id#</cfif>">
							<input type="text" name="main_product_name" id="main_product_name" value="<cfif isdefined("attributes.q_id") and Len(get_sales_quotas.main_product_id)>#get_product_name(get_sales_quotas.main_product_id)#</cfif>" onFocus="AutoComplete_Create('main_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','main_product_id','','3','150','','1')" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=add_sales_quota.main_product_id&field_name=add_sales_quota.main_product_name');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
						</div>
					</div>
				</div>
			</cfif>
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="detail" id="detail" style="width:140px;height:45px;"><cfif isdefined("attributes.q_id") and len(get_sales_quotas.detail)>#get_sales_quotas.detail#</cfif></textarea>
					</div>
				</div>
			</div>
		</cfoutput>
	</cf_box_elements>
	<cf_box_footer>
		<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	</cf_box_footer>
	<cf_basket id="sales_quota_bask">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<label class="col col-1 col-xs-12">
					<input type="checkbox" onClick="ac_kapa(1);" value="1" name="is_wiew_purveyor" id="is_wiew_purveyor" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_purveyor eq 1) or not isdefined("attributes.q_id")>checked<cfelseif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'0'))>checked</cfif>><cf_get_lang dictionary_id='57658.Üye'>
				</label>
				<label class="col col-1 col-xs-12"><input type="checkbox" onClick="ac_kapa(2);" value="<cfif isdefined("attributes.q_id")>1<cfelse>0</cfif>" name="is_wiew_mark" id="is_wiew_mark" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_mark eq 1)>checked<cfelseif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'1'))>checked</cfif>><cf_get_lang dictionary_id='58847.Marka'></label>
				<label class="col col-1 col-xs-12"><input type="checkbox" onClick="ac_kapa(3);" value="<cfif isdefined("attributes.q_id")>1<cfelse>0</cfif>" name="is_wiew_cat" id="is_wiew_cat" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_cat eq 1)>checked<cfelseif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'2'))>checked</cfif>><cf_get_lang dictionary_id='57486.Kategori'></label>
				<label class="col col-1 col-xs-12"><input type="checkbox" onClick="ac_kapa(4);" value="<cfif isdefined("attributes.q_id")>1<cfelse>0</cfif>" name="is_wiew_product" id="is_wiew_product" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_product eq 1)>>checked<cfelseif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'3'))>checked</cfif>><cf_get_lang dictionary_id='57657.Ürün'></label>
			</div>
		</cf_box_elements>
		<cf_grid_list sort="0" id="table1">
			<thead>
				<tr>
					<th align="center" nowrap="nowrap" style="width:15px;">
						<input name="record_num" id="record_num" type="hidden" value="<cfif isdefined("attributes.q_id") and get_sales_quotas_row.recordcount><cfoutput>#get_sales_quotas_row.recordcount#</cfoutput><cfelse>0</cfif>">
						<a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57707.Satır Ekle'>" alt="<cf_get_lang dictionary_id ='57707.Satır Ekle'>"></i></a>
					</th>
					<th id="g_tedarikci" <cfif not isdefined("url.is_from_file") and isdefined("attributes.q_id") and get_sales_quotas.is_wiew_purveyor eq 0>style="display:none"</cfif> <cfif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'0'))>style="display:none"</cfif> width="200" nowrap><cf_get_lang dictionary_id='57658.Üye'></th>
					<th id="g_marka" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_mark eq 0) or not isdefined("attributes.q_id")>style="display:none"</cfif> <cfif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'1'))>style="display:none"</cfif> width="200" nowrap><cf_get_lang dictionary_id='58847.Marka'></th>
					<th id="g_kategori" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_cat eq 0) or not isdefined("attributes.q_id")>style="display:none"</cfif> <cfif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'2'))>style="display:none"</cfif> width="<cfif x_row_multi_category_selected eq 1>250<cfelse>200</cfif>" nowrap><cf_get_lang dictionary_id='57486.Kategori'></th>
					<cfif x_products_not_included eq 1>
						<th id="g_urun2_" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_cat eq 0) or not isdefined("attributes.q_id")>style="display:none"</cfif> <cfif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'2'))>style="display:none"</cfif> width="<cfif x_row_multi_category_selected eq 1>250<cfelse>120</cfif>" nowrap><cf_get_lang dictionary_id='41642.Prime Dahil Edilmeyecek Ürünler'></th>
					</cfif>
					<th id="g_urun" <cfif not isdefined("url.is_from_file") and (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_product eq 0) or not isdefined("attributes.q_id")>style="display:none"</cfif> <cfif (isdefined("url.is_from_file") and url.is_from_file eq 1 and isdefined("attributes.change_options") and listfindNocase("attributes.change_options",'3'))>style="display:none"</cfif> width="200" nowrap><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th width="75" nowrap><cf_get_lang dictionary_id='58472.Dönem'></th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='57635.Miktar'></th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='58908.Min'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th width="75" nowrap class="text-right"><cf_get_lang dictionary_id='58908.Min'> <cf_get_lang dictionary_id='41579.Tutar Döviz'></th>
					<th width="75" nowrap class="text-right"><cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='41579.Tutar Döviz'></th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='41588.Prim'> %</th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='41588.Prim'>2 %</th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='41588.Prim'>3 %</th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='41588.Prim'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th width="75" nowrap id="g_mal_fazlasi" style="text-align:right;<cfif (isdefined("attributes.q_id") and get_sales_quotas.is_wiew_product eq 0) or not isdefined("attributes.q_id")>display:none"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='41594.Mal Fazlası'></th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='41516.Kar'> %</th>
					<th width="75" nowrap class="text-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='41516.Kar'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					<th width="200" nowrap><cf_get_lang dictionary_id='57629.Açıklama'>/<cf_get_lang dictionary_id='57467.Not'></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.q_id") and get_sales_quotas_row.recordcount><!--- Kopyalama Bilgileri --->
					<cfset company_id_list = ''>
					<cfset brand_id_list = ''>
					<cfoutput query="get_sales_quotas_row">
						<cfif len(supplier_id) and not listfind(company_id_list,supplier_id)>
						<cfset company_id_list=listappend(company_id_list,supplier_id)>
						</cfif>
						<cfif len(brand_id) and not listfind(brand_id_list,brand_id)>
						<cfset brand_id_list=listappend(brand_id_list,brand_id)>
						</cfif>
					</cfoutput>
					<cfif len(company_id_list)>
						<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
						<cfquery name="get_comp_detail" datasource="#dsn#">
							SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(brand_id_list)>
						<cfset brand_id_list=listsort(brand_id_list,"numeric","ASC",",")>
						<cfquery name="get_brand_detail" datasource="#dsn3#">
							SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_id_list#) ORDER BY BRAND_ID
						</cfquery>
					</cfif>
					<cfoutput query="get_sales_quotas_row">
						<tr id="frm_row#currentrow#">
							<td align="center" nowrap="nowrap"><input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
							<td <cfif get_sales_quotas.is_wiew_purveyor eq 0>style="display:none;"</cfif> nowrap="nowrap" id="tedarikci_#currentrow#">
							<div class="form-group large">
								<div class="input-group widFull">
									<cfif len(supplier_id)>
										<input type="hidden" name="row_company_id#currentrow#" id="row_company_id#currentrow#" value="#SUPPLIER_ID#">
										<input type="text" name="row_comp_name#currentrow#" id="row_comp_name#currentrow#"  value="#get_comp_detail.NICKNAME[listfind(company_id_list,SUPPLIER_ID,',')]#"  class="boxtext" title="#ROW_DETAIL#" onFocus="AutoComplete_Create('row_comp_name#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','row_company_id#currentrow#','','3','225');" autocomplete="off">
										<span class="input-group-addon" href="javascript://" onclick="pencere_ac_company('#currentrow#');"><i class="fa fa-plus"></i></a>
									<cfelse>
										<input type="hidden" name="row_company_id#currentrow#" id="row_company_id#currentrow#" value="">
										<input type="text" name="row_comp_name#currentrow#" id="row_comp_name#currentrow#"  value=""  class="boxtext" title="#ROW_DETAIL#"  onFocus="AutoComplete_Create('row_comp_name#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','row_company_id#currentrow#','','3','225');" autocomplete="off">
										<span class="input-group-addon" href="javascript://" onclick="pencere_ac_company('#currentrow#');"><i class="fa fa-plus"></i></a>
									</cfif>
								</div>
							</div>
							</td>
							<td <cfif get_sales_quotas.is_wiew_mark eq 0>style="display:none;"</cfif> nowrap="nowrap" id="marka_#currentrow#">
								<div class="form-group large">
									<div class="input-group widFull">
										<cfif len(brand_id)>
											<input type="hidden" name="row_brand_id#currentrow#" id="row_brand_id#currentrow#" value="#BRAND_ID#">
											<input type="text" name="row_brand_name#currentrow#" id="row_brand_name#currentrow#"  value="#get_brand_detail.BRAND_NAME[listfind(brand_id_list,BRAND_ID,',')]#"  class="boxtext" title="#ROW_DETAIL#">
											<span class="input-group-addon" onclick="pencere_ac_brand('#currentrow#');"></span>
										<cfelse>
											<input type="hidden" name="row_brand_id#currentrow#" id="row_brand_id#currentrow#" value="">
											<input type="text" name="row_brand_name#currentrow#" id="row_brand_name#currentrow#"  value=""  class="boxtext" title="#ROW_DETAIL#">
											<span class="input-group-addon" onclick="pencere_ac_brand('#currentrow#');"></span>
										</cfif>
									</div>
								</div>
							</td>
							<td <cfif get_sales_quotas.is_wiew_cat eq 0>style="display:none;"</cfif> nowrap="nowrap" id="kategori_#currentrow#">
								<cfif x_row_multi_category_selected eq 1>
									<cfset deger_row_category_id = MULTI_CATEGORY_ID>
								<cfelse>
									<cfset deger_row_category_id = CATEGORY_ID>
								</cfif>
								<cfif Len(deger_row_category_id)>
									<cfquery name="get_product_cat" datasource="#dsn1#">
										SELECT HIERARCHY + ' ' + PRODUCT_CAT PRODUCT_CAT_ALL FROM PRODUCT_CAT WHERE PRODUCT_CATID IN (#ListDeleteDuplicates(deger_row_category_id)#)
									</cfquery>
									<cfset Product_Cat_Names = ValueList(get_product_cat.product_cat_all,',')>
								<cfelse>
									<cfset Product_Cat_Names = "">
								</cfif>
								<div class="form-group large">
									<div class="input-group widFull">
										<input type="hidden" name="row_category#currentrow#" id="row_category#currentrow#" value="#deger_row_category_id#">
										<input type="text" name="row_category_name#currentrow#" id="row_category_name#currentrow#" value="#Product_Cat_Names#" style="width:<cfif x_row_multi_category_selected eq 1>240<cfelse>110</cfif>px;" class="boxtext">
										<span class="input-group-addon" onClick="document.all.row_category#currentrow#.value= ''; document.all.row_category_name#currentrow#.value= ''; openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_sales_quota.row_category#currentrow#&field_name=add_sales_quota.row_category_name#currentrow#&is_sub_category=1<cfif x_row_multi_category_selected eq 1>&is_multi_selection=1</cfif>');"></span>
									</div>
								</div>
							</td>
							<cfif x_products_not_included eq 1>
								<cfset deger_product_id2 = MULTI_PRODUCT_ID2>
								<cfset deger_stock_id2 = MULTI_STOCK_ID2>
								<cfif Len(deger_product_id2)>
									<cfquery name="get_product_name" datasource="#dsn3#">
										SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#ListDeleteDuplicates(deger_stock_id2)#)
									</cfquery>
									<cfset Product_Names = ValueList(get_product_name.PRODUCT_NAME,',')>
								<cfelse>
									<cfset Product_Names = "">
								</cfif>
								<td <cfif get_sales_quotas.is_wiew_cat eq 0>style="display:none;"</cfif> nowrap="nowrap" id="urun2_#currentrow#">
									<div class="form-group large">
										<div class="input-group widFull">
											<input  type="hidden" name="product_id2#currentrow#" id="product_id2#currentrow#" value="#deger_product_id2#">
											<input  type="hidden" name="stock_id2#currentrow#" id="stock_id2#currentrow#" value="#deger_stock_id2#">
											<input type="text" name="product_name2#currentrow#" id="product_name2#currentrow#" class="boxtext" style="width:240px;" value="#Product_Names#" title="#ROW_DETAIL#">
											<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=add_sales_quota.product_id2#currentrow#&field_id=add_sales_quota.stock_id2#currentrow#&field_name=add_sales_quota.product_name2#currentrow#&is_multi_selection=1');"></span>
										</div>
									</div>
								</td>
							</cfif>
							<td <cfif get_sales_quotas.is_wiew_product eq 0>style="display:none;"</cfif> nowrap="nowrap" id="urun_#currentrow#">
								<div class="form-group large">
									<div class="input-group widFull">
										<input  type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
										<input  type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
										<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" class="boxtext" style="width:130px;" value="#PRODUCT_NAME#" title="#ROW_DETAIL#">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=add_sales_quota.product_id#currentrow#&field_id=add_sales_quota.stock_id#currentrow#&field_name=add_sales_quota.product_name#currentrow#');"></span>
									</div>
								</div>
							</td>
							<td><cfif x_period_type eq 1>
									<select name="period_type#currentrow#" id="period_type#currentrow#">
										<option value="0" <cfif period_type eq 0>selected</cfif>>1.<cf_get_lang dictionary_id='58472.Dönem'>(01.01-31.03)</option>
										<option value="1" <cfif period_type eq 1>selected</cfif>>2.<cf_get_lang dictionary_id='58472.Dönem'>(01.04-30.06)</option>
										<option value="2" <cfif period_type eq 2>selected</cfif>>3.<cf_get_lang dictionary_id='58472.Dönem'>(01.07-30.09)</option>
										<option value="3" <cfif period_type eq 3>selected</cfif>>4.<cf_get_lang dictionary_id='58472.Dönem'>(01.10-31.12)</option>
									</select>
								<cfelse>
									<select name="period_type#currentrow#" id="period_type#currentrow#">
										<option value="0" <cfif period_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
										<option value="1" <cfif period_type eq 1>selected</cfif>>3 <cf_get_lang dictionary_id='58724.Ay'></option>
										<option value="2" <cfif period_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58455.Yıl'></option>
									</select>
								</cfif>
							</td>
							<td><div class="form-group widFull"><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#quantity#" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" onBlur="if(filterNum(this.value) <=1) this.value=1;hesapla('#currentrow#');" title="#row_detail#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="row_total#currentrow#" id="row_total#currentrow#" value="#TLFormat(row_total)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" title="#row_detail#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="row_total_max#currentrow#" id="row_total_max#currentrow#" value="#TLFormat(row_total_max)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="row_other_total#currentrow#" id="row_other_total#currentrow#" value="#TLFormat(row_other_total)#"  onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="row_other_total_max#currentrow#" id="row_other_total_max#currentrow#" value="#TLFormat(row_other_total_max)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="premium_per_#currentrow#" id="premium_per_#currentrow#" value="#TLFormat(row_premium_percent)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="premium_per2_#currentrow#" id="premium_per2_#currentrow#" value="#TLFormat(row_premium_percent2)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="premium_per3_#currentrow#" id="premium_per3_#currentrow#" value="#TLFormat(row_premium_percent3)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="row_premium_total#currentrow#" id="row_premium_total#currentrow#" value="#TLFormat(row_premium_total)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#',1);" title="#ROW_DETAIL#"></div></td>
							<td <cfif GET_SALES_QUOTAS.IS_WIEW_PRODUCT eq 0>style="display:none"</cfif> id="mal_fazlasi#currentrow#"><div class="form-group widFull"><input type="text" name="extra_stock#currentrow#" id="extra_stock#currentrow#" value="#ROW_EXTRA_STOCK#" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" onBlur="if(filterNum(this.value) <0) this.value=0;hesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="profit_per#currentrow#" id="profit_per#currentrow#" value="#TLFormat(row_profit_percent)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" title="#ROW_DETAIL#"></div></td>
							<td><div class="form-group widFull"><input type="text" name="row_profit_total#currentrow#" id="row_profit_total#currentrow#" value="#TLFormat(row_profit_total)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#',1);" title="#ROW_DETAIL#"></div></td>
							<td><input type="text" name="row_detail#currentrow#" id="row_detail#currentrow#" class="boxtext" value="#row_detail#" maxlength="300" title="#ROW_DETAIL#"></td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_basket_footer height="95">
			<cfoutput>
				<div class="ui-row">
					<div id="sepetim_total" class="padding-0">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"> <cf_get_lang dictionary_id='57677.Dövizler'> </span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<table>
										<input type="hidden" name="kur_say" id="kur_say" value="#get_sales_quotas_money.recordcount#">
										<cfif session.ep.rate_valid eq 1>
											<cfset readonly_info = "yes">
										<cfelse>
											<cfset readonly_info = "no">
										</cfif>
										<cfloop query="get_sales_quotas_money">
											<tr>
												<td>
													<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
													<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
													<input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="toplam_doviz_hesapla();" <cfif isdefined("attributes.q_id") and get_sales_quotas.other_money eq money>checked<cfelseif session.ep.money2 eq money>checked</cfif>>#money#
												</td>
												<td style="text-align:right">#TLFormat(rate1,0)#/</td>
												<td valign="bottom"><input type="text" class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_doviz_hesapla();" <cfif readonly_info>readonly</cfif><cfif money eq session.ep.money>readonly="yes"</cfif>></td>
											</tr>
										</cfloop>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">    	
									<table>
										<tr>
											<td><cf_get_lang dictionary_id='57635.Miktar'></td>
											<td class="text-right">
												<input type="text" name="toplam_miktar" id="toplam_miktar" class="box" readonly="" value="<cfif isdefined("attributes.q_id")>#get_sales_quotas.total_quantity#<cfelse>0</cfif>" style="width:120px;" onkeyup="return(FormatCurrency(this,event,0));">
											</td>
										</tr>
										<tr>
											<td><cf_get_lang dictionary_id='57673.Tutar'></td>
											<td class="text-right">
												<input type="text" name="toplam_tutar" id="toplam_tutar" class="box" readonly="" value="<cfif isdefined("attributes.q_id")>#TLFormat(get_sales_quotas.total_amount)#<cfelse>0</cfif>" style="width:120px;">
											</td>
										</tr>
										<tr>
											<td><cf_get_lang dictionary_id='41579.Tutar Döviz'></td>
											<td  class="text-right">
												<input type="text" name="tutar_doviz" id="tutar_doviz" class="box" readonly="" value="<cfif isdefined("attributes.q_id")>#TLFormat(get_sales_quotas.other_total_amount)#<cfelse>0</cfif>" style="width:120px;">
											</td>
										</tr>
										
										<tr>
											<td><cf_get_lang dictionary_id='37660.Mal Fazlası'></td>
											<td  class="text-right">
												<input type="text" name="mal_miktar" id="mal_miktar" class="box" readonly="" value="<cfif isdefined("attributes.q_id")>#get_sales_quotas.total_extra_stock#<cfelse>0</cfif>" style="width:120px;">
											</td>
										</tr>
										<tr>
											<td><cf_get_lang dictionary_id='48246.Prim Tutar'></td>
											<td  class="text-right">
												<input type="text" name="prim_tutar" id="prim_tutar" class="box" readonly="" value="<cfif isdefined("attributes.q_id")>#TLFormat(get_sales_quotas.total_premium_amount)#<cfelse>0</cfif>" style="width:120px;">
											</td>
										</tr>
										<tr>
											<td><cf_get_lang dictionary_id='60216.Kar Tutar'></td>
											<td  class="text-right">
												<input type="text" name="kar_tutar" id="kar_tutar" class="box" readonly="" value="<cfif isdefined("attributes.q_id")>#TLFormat(get_sales_quotas.total_profit_amount)#<cfelse>0</cfif>" style="width:120px;">
											</td>
										</tr>
									</table>   
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfoutput>
		</cf_basket_footer>
 	</cf_basket>
</cf_box>
</div>
</cfform>
<script type="text/javascript">
	<cfif isdefined("attributes.q_id") and len(attributes.q_id)>
		row_count=<cfoutput>#get_sales_quotas_row.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
	function sil(sy)
	{
		var my_element=eval("add_sales_quota.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function add_row(row_company_id,row_comp_name,row_brand_id,row_brand_name,row_category,row_category_name,product_id,stock_id,product_name,period_type,quantity,row_total,row_total_max,row_other_total,row_other_total_max,premium_per_,premium_per2_,premium_per3_,row_premium_total,extra_stock,profit_per,row_profit_total,row_detail)
	{
		if(quantity) // Import dosyada zorunlu alan
			import_file = 1;
		else
			import_file = 0;

		if(document.add_sales_quota.is_wiew_purveyor.checked==true)
			var ekle_tedarik=1;
		else
			var ekle_tedarik=0;

		if(document.add_sales_quota.is_wiew_mark.checked==true)
			var ekle_marka=1;
		else
			var ekle_marka=0;

		if(document.add_sales_quota.is_wiew_cat.checked==true)
		{
			var ekle_kategori=1;
			var ekle_urun2_=1;
		}
		else
		{
			var ekle_kategori=0;
			var ekle_urun2_=0;
		}

		if(document.add_sales_quota.is_wiew_product.checked==true)
			var ekle_urun=1;
		else
			var ekle_urun=0;

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.className = 'color-row';
		document.add_sales_quota.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" ><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);//Tedarikçi
		newCell.setAttribute("name","tedarikci_" + row_count);
		newCell.setAttribute("id","tedarikci_" + row_count);
		newCell.setAttribute("NAME","tedarikci_" + row_count);
		newCell.setAttribute("ID","tedarikci_" + row_count);
		if(ekle_tedarik==0)
			newCell.style.display = 'none';
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && row_company_id.length)
			newCell.innerHTML = '<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="row_company_id' + row_count +'" id="row_company_id' + row_count +'" value="' + row_company_id +'"><input type="text" name="row_comp_name' + row_count +'" id="row_comp_name' + row_count +'" value="' + row_comp_name +'" class="boxtext"  onFocus="autocomp('+row_count+');"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_company('+ row_count +');"></span></div></div>';
		else
			newCell.innerHTML = '<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="row_company_id' + row_count +'" id="row_company_id' + row_count +'"><input type="text" name="row_comp_name' + row_count +'" id="row_comp_name' + row_count +'" class="boxtext"  onFocus="autocomp('+row_count+');"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_company('+ row_count +');"></span></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);//Marka
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("name","marka_" + row_count);
		newCell.setAttribute("id","marka_" + row_count);
		newCell.setAttribute("NAME","marka_" + row_count);
		newCell.setAttribute("ID","marka_" + row_count);
		if(ekle_marka==0)
			newCell.style.display = 'none';
		if(import_file == 1 && row_brand_id.length)
			newCell.innerHTML = '<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="row_brand_id' + row_count +'" id="row_brand_id' + row_count +'" value="'+row_brand_id+'"><input type="text" name="row_brand_name' + row_count +'" id="row_brand_name' + row_count +'" value="'+row_brand_name+'" onFocus="AutoComplete_Create(\'row_brand_name' + row_count +'\',\'BRAND_NAME\',\'BRAND_NAME\',\'get_brand\',\'\',\'BRAND_ID\',\'row_brand_id' + row_count +'\',\'add_sales_quota\',3,120);" class="boxtext"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_brand('+ row_count +');"></span></div></div>';
		else
			newCell.innerHTML = '<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="row_brand_id' + row_count +'" id="row_brand_id' + row_count +'"><input type="text" name="row_brand_name' + row_count +'" id="row_brand_name' + row_count +'" onFocus="AutoComplete_Create(\'row_brand_name' + row_count +'\',\'BRAND_NAME\',\'BRAND_NAME\',\'get_brand\',\'\',\'BRAND_ID\',\'row_brand_id' + row_count +'\',\'add_sales_quota\',3,120);" class="boxtext"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_brand('+ row_count +');"></span></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);//kategori
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("name","kategori_" + row_count);
		newCell.setAttribute("id","kategori_" + row_count);
		newCell.setAttribute("NAME","kategori_" + row_count);
		newCell.setAttribute("ID","kategori_" + row_count);
		if(ekle_kategori==0)
			newCell.style.display = 'none';
		if(import_file == 1 && row_category.length)
			newCell.innerHTML ='<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="row_category'+ row_count +'" id="row_category'+ row_count +'" value="'+row_category+'"><input type="text" style="width:<cfif x_row_multi_category_selected eq 1>238<cfelse>108</cfif>px;" class="boxtext" name="row_category_name'+ row_count +'" id="row_category_name'+ row_count +'" value="'+row_category_name+'"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_category('+ row_count +');"></span></div></div>';
		else
			newCell.innerHTML ='<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="row_category'+ row_count +'" id="row_category'+ row_count +'"><input type="text" style="width:<cfif x_row_multi_category_selected eq 1>238<cfelse>108</cfif>px;" class="boxtext" name="row_category_name'+ row_count +'" id="row_category_name'+ row_count +'"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_category('+ row_count +');"></span></div></div>';

		<cfif x_products_not_included eq 1>
			newCell = newRow.insertCell(newRow.cells.length);//Urun2(Prime Dahil Edilmeyecek Urunler)
			newCell.setAttribute("name","urun2_" + row_count);
			newCell.setAttribute("id","urun2_" + row_count);
			newCell.setAttribute("NAME","urun2_" + row_count);
			newCell.setAttribute("ID","urun2_" + row_count);
			if(ekle_urun2_==0)
				newCell.style.display = 'none';
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="product_id2' + row_count +'" ><input  type="hidden" name="stock_id2' + row_count +'" ><input type="text" name="product_name2' + row_count +'" id="product_name2' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name2' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID\',\'product_id2' + row_count +',stock_id2' + row_count +'\',\'add_sales_quota\',3,128);"><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_sales_quota.product_id2" + row_count + "&field_id=add_sales_quota.stock_id2" + row_count + "&field_name=add_sales_quota.product_name2" + row_count + "&is_multi_selection=1');"+'"></span></div></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("name","urun_" + row_count);
		newCell.setAttribute("id","urun_" + row_count);
		newCell.setAttribute("NAME","urun_" + row_count);
		newCell.setAttribute("ID","urun_" + row_count);
		if(ekle_urun==0)
			newCell.style.display = 'none';
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && product_id.length)
			newCell.innerHTML = '<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+product_name+'" class="boxtext" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID\',\'product_id' + row_count +',stock_id' + row_count +'\',\'add_sales_quota\',3,128);"><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_sales_quota.product_id" + row_count + "&field_id=add_sales_quota.stock_id" + row_count + "&field_name=add_sales_quota.product_name" + row_count + "');"+'"></span></div></div>';
		else
			newCell.innerHTML = '<div class="form-group large"><div class="input-group widFull"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID\',\'product_id' + row_count +',stock_id' + row_count +'\',\'add_sales_quota\',3,128);"><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_sales_quota.product_id" + row_count + "&field_id=add_sales_quota.stock_id" + row_count + "&field_name=add_sales_quota.product_name" + row_count + "');"+'"></span></div></div>';

		<cfif x_period_type eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="period_type'+ row_count +'" id="period_type'+ row_count +'" class="moneybox"><option value="0">1.<cf_get_lang dictionary_id='58472.Dönem'>(01.01-31.03)</option><option value="1">2.<cf_get_lang dictionary_id='58472.Dönem'>(01.04-30.06)</option><option value="2">3.<cf_get_lang dictionary_id='58472.Dönem'>(01.07-30.09)</option><option value="3">4.<cf_get_lang dictionary_id='58472.Dönem'>(01.10-31.12)</option></select>';
		<cfelse>
			newCell = newRow.insertCell(newRow.cells.length);

		if(import_file == 1 && period_type.length)
		{
			switch(period_type)
			{
				case '1' : text_ = '<option value="0"><cf_get_lang dictionary_id="58724.Ay"></option><option value="1" selected>3 <cf_get_lang dictionary_id="58724.Ay"></option><option value="2"><cf_get_lang dictionary_id="58455.Yıl"></option>'; break;
				case '2' : text_ = '<option value="0"><cf_get_lang dictionary_id="58724.Ay"></option><option value="1">3 <cf_get_lang dictionary_id="58724.Ay"></option><option value="2" selected><cf_get_lang dictionary_id="58455.Yıl"></option>'; break;
				default : text_ = '<option value="0" selected><cf_get_lang dictionary_id="58724.Ay"></option><option value="1">3 <cf_get_lang dictionary_id="58724.Ay"></option><option value="2"><cf_get_lang dictionary_id="58455.Yıl"></option>'; break;
			}
			newCell.innerHTML = '<select name="period_type'+ row_count +'" id="period_type'+ row_count +'" style="width:70px;" class="moneybox">'+text_+'</select>';
		}
		else
			newCell.innerHTML = '<select name="period_type'+ row_count +'" id="period_type'+ row_count +'" style="width:70px;" class="moneybox"><option value="0"><cf_get_lang dictionary_id="58724.Ay"></option><option value="1">3 <cf_get_lang dictionary_id="58724.Ay"></option><option value="2"><cf_get_lang dictionary_id="58455.Yıl"></option></select>';
		</cfif>

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && quantity.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="'+quantity+'" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" onBlur="if(filterNum(this.value) <=1) this.value=1;hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="1" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" onBlur="if(filterNum(this.value) <=1) this.value=1;hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && row_total.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="'+row_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && row_total_max.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_total_max' + row_count +'" id="row_total_max' + row_count +'" value="'+row_total_max+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_total_max' + row_count +'" id="row_total_max' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && row_other_total.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="'+row_other_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && row_other_total_max.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_other_total_max' + row_count +'" id="row_other_total_max' + row_count +'" value="'+row_other_total_max+'"  onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_other_total_max' + row_count +'" id="row_other_total_max' + row_count +'" value="0"  onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);Dhesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && premium_per_.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="premium_per_' + row_count +'" id="premium_per_' + row_count +'" value="'+premium_per_+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="premium_per_' + row_count +'" id="premium_per_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		if(import_file == 1 && premium_per2_.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="premium_per2_' + row_count +'" id="premium_per2_' + row_count +'" value="'+premium_per2_+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="premium_per2_' + row_count +'" id="premium_per2_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		if(import_file == 1 && premium_per3_.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="premium_per3_' + row_count +'" id="premium_per3_' + row_count +'" value="'+premium_per3_+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="premium_per3_' + row_count +'" id="premium_per3_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		if(import_file == 1 && row_premium_total.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_premium_total' + row_count +'" id="row_premium_total' + row_count +'" value="'+row_premium_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_premium_total' + row_count +'" id="row_premium_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","mal_fazlasi" + row_count);
		if(ekle_urun==0)
			newCell.style.display = 'none';
		if(import_file == 1 && extra_stock.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="extra_stock' + row_count +'" id="extra_stock' + row_count +'" value="'+extra_stock+'" onkeyup="return(FormatCurrency(this,event,0))</div>" class="moneybox" onBlur="if(filterNum(this.value) <0) this.value=0;hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="extra_stock' + row_count +'" id="extra_stock' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" onBlur="if(filterNum(this.value) <0) this.value=0;hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && profit_per.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="profit_per' + row_count +'" id="profit_per' + row_count +'" value="'+profit_per+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="profit_per' + row_count +'" id="profit_per' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && row_profit_total.length)
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_profit_total' + row_count +'" id="row_profit_total' + row_count +'" value="'+row_profit_total+'" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);"></div>';
		else
			newCell.innerHTML = '<div class="form-group widFull"><input type="text" name="row_profit_total' + row_count +'" id="row_profit_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+',1);"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		if(import_file == 1 && row_detail.length)
			newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" value="'+row_detail+'" class="boxtext" maxlength="300">';
		else
			newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" class="boxtext" maxlength="300">';

		if(import_file == 1)
		{
			if(row_total)
				hesapla(row_count);
			else
				Dhesapla(row_count);
		}

	}
	function autocomp(no)
	{
		AutoComplete_Create("row_comp_name" + no,"MEMBER_NAME,MEMBER_PARTNER_NAME","MEMBER_NAME,MEMBER_PARTNER_NAME","get_member_autocomplete","1,0,0","COMPANY_ID","row_company_id" + no,"add_sales_quota",3,225);
	}
	function pencere_ac_brand(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=add_sales_quota.row_brand_id' + no +'&brand_name=add_sales_quota.row_brand_name' + no +'','','ui-draggable-box-small');
	}
	function pencere_ac_company(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_period_kontrol=0&select_list=2&field_comp_name=add_sales_quota.row_comp_name' + no +'&field_comp_id=add_sales_quota.row_company_id' + no + '');
	}
	function pencere_ac_category(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=add_sales_quota.row_category' + no + '&field_name=add_sales_quota.row_category_name' + no + '&is_sub_category=1<cfif x_row_multi_category_selected eq 1>&is_multi_selection=1</cfif>');
	}
	function Dhesapla(row_no)
	{

		var d_satir_toplam=filterNum(eval('add_sales_quota.row_other_total'+row_no).value);
		var d_satir_toplam_max = filterNum(eval('add_sales_quota.row_other_total_max'+row_no).value);
		if('<cfoutput>#session.ep.money2#</cfoutput>' == '')
			for(i=1;i<=add_sales_quota.kur_say.value;i++)
			{
				if(document.add_sales_quota.rd_money.checked == true)
				{
					form_txt_rate2_ = filterNum(eval("document.add_sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('add_sales_quota.row_total'+row_no).value = commaSplit(d_satir_toplam*form_txt_rate2_);
					eval('add_sales_quota.row_total_max'+row_no).value = commaSplit(d_satir_toplam_max*form_txt_rate2_);
				}
			}
		else
			for(i=1;i<=add_sales_quota.kur_say.value;i++)
			{
				if(document.add_sales_quota.rd_money[i-1].checked == true)
				{
					form_txt_rate2_ = filterNum(eval("document.add_sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('add_sales_quota.row_total'+row_no).value = commaSplit(d_satir_toplam*form_txt_rate2_);
					eval('add_sales_quota.row_total_max'+row_no).value = commaSplit(d_satir_toplam_max*form_txt_rate2_);
				}
			}
			hesapla(row_no,0);
	}
	function hesapla(row_no,type)//satirdaki işlemleri hesaplar
	{
		var satir_toplam = filterNum(eval('add_sales_quota.row_total'+row_no).value);
		var satir_toplam_max = filterNum(eval('add_sales_quota.row_total_max'+row_no).value);
		if(type != undefined && type == 1 && document.add_sales_quota.x_premium_percent_2_3.value != 1)
		{
			eval('add_sales_quota.premium_per_'+row_no).value = commaSplit(filterNum(commaSplit(filterNum(eval('add_sales_quota.row_premium_total'+row_no).value)*100/satir_toplam)));
			eval('add_sales_quota.profit_per'+row_no).value = commaSplit(filterNum(commaSplit(filterNum(eval('add_sales_quota.row_profit_total'+row_no).value)*100/satir_toplam)));
		}
		else
		{
			var row_premium_total_1 = filterNum(commaSplit(satir_toplam*filterNum(eval('add_sales_quota.premium_per_'+row_no).value)/100));
			var row_premium_total_2 = filterNum(commaSplit((satir_toplam-row_premium_total_1)*filterNum(eval('add_sales_quota.premium_per2_'+row_no).value)/100));
			var row_premium_total_3 = filterNum(commaSplit((satir_toplam-row_premium_total_1-row_premium_total_2)*filterNum(eval('add_sales_quota.premium_per3_'+row_no).value)/100));
			eval('add_sales_quota.row_premium_total'+row_no).value = commaSplit(row_premium_total_1 + row_premium_total_2 + row_premium_total_3);
			eval('add_sales_quota.row_profit_total'+row_no).value = commaSplit(satir_toplam*filterNum(eval('add_sales_quota.profit_per'+row_no).value)/100);
		}
		if(type==undefined || (type!=undefined && type!=0))
		{
		if('<cfoutput>#session.ep.money2#</cfoutput>' == '')
			for(i=1;i<=add_sales_quota.kur_say.value;i++)
			{
				if(document.add_sales_quota.rd_money.checked == true)
				{
					form_txt_rate2_ = filterNum(eval("document.add_sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('add_sales_quota.row_other_total'+row_no).value = commaSplit(satir_toplam/form_txt_rate2_);
					eval('add_sales_quota.row_other_total_max'+row_no).value = commaSplit(satir_toplam_max/form_txt_rate2_);
				}
			}
		else
			for(i=1;i<=add_sales_quota.kur_say.value;i++)
			{
				if(document.add_sales_quota.rd_money[i-1].checked == true)
				{
					form_txt_rate2_ = filterNum(eval("document.add_sales_quota.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('add_sales_quota.row_other_total'+row_no).value = commaSplit(satir_toplam/form_txt_rate2_);
					eval('add_sales_quota.row_other_total_max'+row_no).value = commaSplit(satir_toplam_max/form_txt_rate2_);
				}
			}
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var total_quantity = 0;
		var total_amount = 0;
		var other_total_amount = 0;
		var stock_quantity_total = 0;
		var prem_total = 0;
		var total_profit = 0;
		for(j=1;j<=add_sales_quota.record_num.value;j++)
		{
			if(eval("document.add_sales_quota.row_kontrol"+j).value==1)
			{
				total_quantity += parseFloat(filterNum(eval('add_sales_quota.quantity'+j).value));
				total_amount += parseFloat(filterNum(eval('add_sales_quota.row_total'+j).value));
				other_total_amount += parseFloat(filterNum(eval('add_sales_quota.row_other_total'+j).value));
				stock_quantity_total += parseFloat(filterNum(eval('add_sales_quota.extra_stock'+j).value));
				prem_total += parseFloat(filterNum(eval('add_sales_quota.row_premium_total'+j).value));
				total_profit += parseFloat(filterNum(eval('add_sales_quota.row_profit_total'+j).value));
			}
		}
		add_sales_quota.toplam_miktar.value = total_quantity;
		add_sales_quota.toplam_tutar.value = commaSplit(total_amount);
		add_sales_quota.tutar_doviz.value = commaSplit(other_total_amount);
		add_sales_quota.mal_miktar.value = stock_quantity_total;
		add_sales_quota.prim_tutar.value = commaSplit(prem_total);
		add_sales_quota.kar_tutar.value = commaSplit(total_profit);

	}
	function toplam_doviz_hesapla()
	{
		if('<cfoutput>#session.ep.money2#</cfoutput>' == '')
			for (var t=1; t<=add_sales_quota.kur_say.value; t++)
			{
				if(document.add_sales_quota.rd_money.checked == true)
				{
					for(k=1;k<=add_sales_quota.record_num.value;k++)
					{
						rate2_value = filterNum(eval("document.add_sales_quota.txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						eval('add_sales_quota.row_other_total'+k).value = commaSplit(filterNum(eval('add_sales_quota.row_total'+k).value)/rate2_value);
						eval('add_sales_quota.row_other_total_max'+k).value = commaSplit(filterNum(eval('add_sales_quota.row_total_max'+k).value)/rate2_value);
					}
				}
			}

		else
			for (var t=1; t<=add_sales_quota.kur_say.value; t++)
			{
				if(document.add_sales_quota.rd_money[t-1].checked == true)
				{
					for(k=1;k<=add_sales_quota.record_num.value;k++)
					{
						rate2_value = filterNum(eval("document.add_sales_quota.txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						eval('add_sales_quota.row_other_total'+k).value = commaSplit(filterNum(eval('add_sales_quota.row_total'+k).value)/rate2_value);
						eval('add_sales_quota.row_other_total_max'+k).value = commaSplit(filterNum(eval('add_sales_quota.row_total_max'+k).value)/rate2_value);
					}
				}
			}
		toplam_hesapla();
	}
	function kontrol()
	{
		if(!$("#paper_no").val().length)
		{
			alertObject({message: "<cfoutput>#getLang('finance',482)#</cfoutput>"})
			return false;
		}
		var record_exist=0;
		period_list_0 = '';
		period_list_1 = '';
		period_list_2 = '';
		period_list_3 = '';
		for(r=1;r<=add_sales_quota.record_num.value;r++)
		{
			if(eval("document.add_sales_quota.row_kontrol"+r).value==1)
			{
				record_exist=1;
				if(eval('add_sales_quota.period_type'+r).value == 0)
					period_list_0+=eval('add_sales_quota.period_type'+r).value;
				else if(eval('add_sales_quota.period_type'+r).value == 1)
					period_list_1+=eval('add_sales_quota.period_type'+r).value;
				else if(eval('add_sales_quota.period_type'+r).value == 1)
					period_list_2+=eval('add_sales_quota.period_type'+r).value;
				else
					period_list_3+=eval('add_sales_quota.period_type'+r).value;
			}
		}
		if(document.add_sales_quota.employee_name != undefined && document.add_sales_quota.employee_name.value != '' && document.add_sales_quota.team_name.value != '')
		{
			alert("<cf_get_lang dictionary_id='41597.Lütfen Takım veya Çalışandan Sadece Birini Seçiniz'>!");
			return false;
		}
		if(document.add_sales_quota.employee_name != undefined && document.add_sales_quota.employee_name.value == '' && document.add_sales_quota.team_name.value == '')
		{
			alert("<cf_get_lang dictionary_id='41598.Lütfen Takım veya Çalışandan Birini Seçiniz'>!");
			return false;
		}
		if (document.add_sales_quota.quota_type.value == '')
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='41595.Kota Türü'>!");
			return false;
		}
		new_diff = datediff(document.add_sales_quota.start_date.value,document.add_sales_quota.finish_date.value,0);
		<cfif x_period_type eq 1>
			if((period_list_0 != '' || period_list_1 != ''|| period_list_2 != '' || period_list_3 != '') && new_diff < 89)
			{
				alert("<cf_get_lang dictionary_id='41639.3 Aylık Planlama Yapabilmek İçin Tarih Aralığı 90dan Küçük Olmamalı'> !");
				return false;
			}
		</cfif>
			/*if(period_list_0 != '' && new_diff < 30)
			{
				alert("<cf_get_lang dictionary_id='193.Aylık Planlama Yapabilmek İçin Tarih Aralığı 30 dan Küçük Olmamalı'> !");
				return false;
			}
			else if(period_list_1 != '' && new_diff < 90)
			{
				alert("<cf_get_lang dictionary_id='194.3 Aylık Planlama Yapabilmek İçin Tarih Aralığı 90 dan Küçük Olmamalı'> !");
				return false;
			}
			else if(period_list_2 != '' && new_diff < 364)
			{
				alert("<cf_get_lang dictionary_id='195.Yıllık Planlama Yapabilmek İçin Tarih Aralığı 365 den Küçük Olmamalı'> !");
				return false;
			}*/

		if (record_exist == 0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58508.Satır'>");
			return false;
		}
		return unformat_fields();

	}
	function unformat_fields()
	{
	
		for(rm=1;rm<=add_sales_quota.record_num.value;rm++)
		{
			eval("add_sales_quota.row_total"+rm).value =  filterNum(eval("add_sales_quota.row_total"+rm).value);
			eval("add_sales_quota.row_total_max"+rm).value =  filterNum(eval("add_sales_quota.row_total_max"+rm).value);
			eval("add_sales_quota.quantity"+rm).value =  filterNum(eval("add_sales_quota.quantity"+rm).value);
			eval("add_sales_quota.row_other_total"+rm).value =  filterNum(eval("add_sales_quota.row_other_total"+rm).value);
			eval("add_sales_quota.row_other_total_max"+rm).value =  filterNum(eval("add_sales_quota.row_other_total_max"+rm).value);
			eval("add_sales_quota.premium_per_"+rm).value =  filterNum(eval("add_sales_quota.premium_per_"+rm).value);
			eval("add_sales_quota.premium_per2_"+rm).value =  filterNum(eval("add_sales_quota.premium_per2_"+rm).value);
			eval("add_sales_quota.premium_per3_"+rm).value =  filterNum(eval("add_sales_quota.premium_per3_"+rm).value);
			eval("add_sales_quota.row_premium_total"+rm).value =  filterNum(eval("add_sales_quota.row_premium_total"+rm).value);
			eval("add_sales_quota.profit_per"+rm).value =  filterNum(eval("add_sales_quota.profit_per"+rm).value);
			eval("add_sales_quota.row_profit_total"+rm).value =  filterNum(eval("add_sales_quota.row_profit_total"+rm).value);
		}
	
		add_sales_quota.toplam_tutar.value = filterNum(add_sales_quota.toplam_tutar.value);
		add_sales_quota.prim_tutar.value = filterNum(add_sales_quota.prim_tutar.value);
		add_sales_quota.kar_tutar.value = filterNum(add_sales_quota.kar_tutar.value);
		add_sales_quota.toplam_miktar.value = filterNum(add_sales_quota.toplam_miktar.value);
		add_sales_quota.tutar_doviz.value = filterNum(add_sales_quota.tutar_doviz.value);
		for(st=1;st<=add_sales_quota.kur_say.value;st++)
		{
			eval('add_sales_quota.txt_rate2_' + st).value = filterNum(eval('add_sales_quota.txt_rate2_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_sales_quota.txt_rate1_' + st).value = filterNum(eval('add_sales_quota.txt_rate1_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		return true;
	}
	function ac_kapa(type)
	{
	/* type1=Tedarikci type2=Marka type3=Kategori type4=Ürün */
		if(type==1)
		{
			if(document.add_sales_quota.is_wiew_purveyor.checked == false)
			{
				gizle(g_tedarikci);
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("tedarikci_"+rt));
			}
			else
			{
				goster(g_tedarikci);
				for(dt=1;dt<=row_count;dt++)
					goster(eval("tedarikci_"+dt));
			}
		}
		if(type==2)
		{
			if(document.add_sales_quota.is_wiew_mark.checked == false)
			{
				gizle(g_marka);
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("marka_"+rt));
			}
			else
			{
				//Ürün gizleniyor
				document.add_sales_quota.is_wiew_product.checked = false
				gizle(g_urun);
				gizle(g_mal_fazlasi);
				for(rt=1;rt<=row_count;rt++)
				{
					gizle(eval("urun_"+rt));
					gizle(eval("mal_fazlasi"+rt));
				}
				goster(g_marka);
				for(dt=1;dt<=row_count;dt++)
					goster(eval("marka_"+dt));
			}
		}
		if(type==3)
		{
			if(document.add_sales_quota.is_wiew_cat.checked == false)
			{
				gizle(g_kategori);
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("kategori_"+rt));
				<cfif x_products_not_included eq 1>
					gizle(g_urun2_);
					for(ut=1;ut<=row_count;ut++)
						gizle(eval("urun2_"+ut));
				</cfif>
			}
			else
			{
				//Ürün gizleniyor
				document.add_sales_quota.is_wiew_product.checked = false
				gizle(g_urun);
				gizle(g_mal_fazlasi);
				for(rt=1;rt<=row_count;rt++)
				{
					gizle(eval("urun_"+rt));
					gizle(eval("mal_fazlasi"+rt));
				}
				goster(g_kategori);
				for(dt=1;dt<=row_count;dt++)
					goster(eval("kategori_"+dt));
				<cfif x_products_not_included eq 1>
					goster(g_urun2_);
					for(ut=1;ut<=row_count;ut++)
						goster(eval("urun2_"+ut));
				</cfif>
			}
		}
		if(type==4)
		{
			if(document.add_sales_quota.is_wiew_product.checked == false)
			{
				gizle(g_urun);
				gizle(g_mal_fazlasi);
				for(rt=1;rt<=row_count;rt++)
				{
					gizle(eval("urun_"+rt));
					gizle(eval("mal_fazlasi"+rt));
				}
			}
			else
			{
				//Kategori gizleniyor
				gizle(g_kategori);
				document.add_sales_quota.is_wiew_cat.checked = false
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("kategori_"+rt));
				<cfif x_products_not_included eq 1>
					//Urun2 gizleniyor(Prime Dahil Edilmeyecek Olan Urunler)
					gizle(g_urun2_);
					document.add_sales_quota.is_wiew_cat.checked = false
					for(ut=1;ut<=row_count;ut++)
						gizle(eval("urun2_"+ut));
				</cfif>
				//Marka Gizleniyor
				gizle(g_marka);
				document.add_sales_quota.is_wiew_mark.checked = false
				for(rt=1;rt<=row_count;rt++)
					gizle(eval("marka_"+rt));
				//Ürün Gösteriliyor
				goster(g_urun);
				goster(g_mal_fazlasi);
				for(dt=1;dt<=row_count;dt++)
				{
					goster(eval("urun_"+dt));
					goster(eval("mal_fazlasi"+dt));
				}
			}
		}
	}
	function open_file()
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_sales_quota_from_file&type=2<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>','','ui-draggable-box-large');
		return false;
	}
</script>
<cfif isdefined("attributes.is_from_file")><!--- Dosya importtan gelmişse satırlar eklenecek --->
	<cfinclude template="../../objects/query/get_sales_quota_row_from_file.cfm">
</cfif>