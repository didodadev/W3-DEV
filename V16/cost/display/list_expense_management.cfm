<cf_xml_page_edit>
	<cfparam name="attributes.expense_cat" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.search_date1" default=''>
	<cfparam name="attributes.search_date2" default=''>
	<cfparam name="attributes.expense_item_id" default="">
	<cfparam name="attributes.expense_center_id" default="">
	<cfparam name="attributes.activity_type" default="">
	<cfparam name="attributes.form_exist" default="">
	<cfparam name="attributes.process_cat" default="">
	<cfparam name="attributes.asset_id" default="">
	<cfparam name="attributes.asset" default="">
	<cfparam name="attributes.project_id" default="">
	<cfparam name="attributes.project" default="">
	<cfparam name="attributes.expense_paper_type" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.member_type" default="">
	<cfparam name="attributes.expense_part_id" default="">
	<cfparam name="attributes.expense_cons_id" default="">
	<cfparam name="attributes.expense_emp_id" default="">
	<cfparam name="attributes.recorder_name" default="">
	<cfparam name="attributes.ch_member_type" default="">
	<cfparam name="attributes.ch_company_id" default="">
	<cfparam name="attributes.ch_consumer_id" default="">
	<cfparam name="attributes.ch_employee_id" default="">
	<cfparam name="attributes.ch_company" default="">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
	<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
	<cfif isDefined("attributes.record_date1") and isDate(attributes.record_date1)>
		<cf_date tarih = "attributes.record_date1">
	<cfelse>
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.record_date1=''>
		<cfelse>
			<cfset attributes.record_date1 = dateadd('d',-7,wrk_get_today())>
		</cfif>
	</cfif>
	<cfif isDefined("attributes.record_date2") and isDate(attributes.record_date2)>
		<cf_date tarih = "attributes.record_date2">
	<cfelse>
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.record_date2=''>
		<cfelse>
			<cfset attributes.record_date2 = dateadd('d',7,attributes.record_date1)>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
		<cf_date tarih = "attributes.search_date1">
		<cfelse>
			<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.search_date1 = ''>
	<cfelse>
		<cfset attributes.search_date1 = dateadd('d',-7,wrk_get_today())>
		</cfif>
	</cfif>
	<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
	<cfset get_xauthorizedbranch = get_fuseaction_property.get_fuseaction_property(
		company_id : session.ep.company_id,
		fuseaction_name : 'budget.detail_budget_report',
		property_name : 'x_authorized_branch'
		)>
	<cfset x_authorized_branch = get_xauthorizedbranch.PROPERTY_VALUE>
	<cfset get_xauthorizedbranchall = get_fuseaction_property.get_fuseaction_property(
		company_id : session.ep.company_id,
		fuseaction_name : 'budget.detail_budget_report',
		property_name : 'x_authorized_branch_all'
		)>
	<cfset x_authorized_branch_all = get_xauthorizedbranchall.PROPERTY_VALUE>
	<cfset get_xauthorizedbranchpositions = get_fuseaction_property.get_fuseaction_property(
		company_id : session.ep.company_id,
		fuseaction_name : 'budget.detail_budget_report',
		property_name : 'x_authorized_branch_positions'
		)>
	<cfset x_authorized_branch_positions = get_xauthorizedbranchpositions.PROPERTY_VALUE>
	<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
		<cf_date tarih = "attributes.search_date2">
		<cfelse>
			<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.search_date2 = ''>
	<cfelse>
		<cfset attributes.search_date2 = dateadd('d',7,attributes.search_date1)>
		</cfif>
	</cfif>
	<cfquery name=GET_ASSET_N datasource="#dsn#">
		SELECT * FROM ASSET_P WHERE ASSETP_ID = 3
	</cfquery>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT EXPENSE_ID, EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER
		WHERE
		EXPENSE_ACTIVE = 1
		<cfif x_authorized_branch eq 1 and isdefined("x_authorized_branch_positions") and not listfind(x_authorized_branch_positions,session.ep.position_code)>
			AND 
				(
				EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
				<cfif isdefined("x_authorized_branch_all") and x_authorized_branch_all neq 1>
					OR (EXPENSE_BRANCH_ID = -1)
				</cfif>
				)
			AND 
			(
			(
				(EXPENSE_DEPARTMENT_ID IN(SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
				or
				(EXPENSE_DEPARTMENT_ID IN(select D2.DEPARTMENT_ID from #dsn_alias#.DEPARTMENT D LEFT JOIN #dsn_alias#.DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) where d.DEPARTMENT_ID = (SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)))
			)
			)
				OR
				EXPENSE_DEPARTMENT_ID IN (
					SELECT EP.DEPARTMENT_ID
					FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP
					WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					)
				OR
				(EXPENSE_DEPARTMENT_ID = - 1)
				)	 
		</cfif>
		ORDER BY EXPENSE_CODE
	</cfquery>
	<cfif  isdefined("attributes.form_exist") and attributes.form_exist eq 1>
		<cfif len(attributes.expense_center_id)>
			<cfset attributes.expense_center_id_list=attributes.expense_center_id>
			<cfquery name="GET_EXPENSE_CODE" dbtype="query">
				SELECT EXPENSE_CODE FROM GET_EXPENSE_CENTER WHERE EXPENSE_ID=#attributes.expense_center_id#
			</cfquery>
			<cfquery name="GET_EXPENSE_LIKE" dbtype="query">
				SELECT EXPENSE_ID FROM GET_EXPENSE_CENTER WHERE EXPENSE_CODE LIKE '#GET_EXPENSE_CODE.EXPENSE_CODE#.%'
			</cfquery>
			<cfif GET_EXPENSE_LIKE.RECORDCOUNT>
				<cfset attributes.expense_center_id_list=listappend(attributes.expense_center_id_list,ValueList(GET_EXPENSE_LIKE.EXPENSE_ID,','),',')>
				<cfset attributes.expense_center_id_list=listdeleteduplicates(listsort(attributes.expense_center_id_list,"numeric","ASC"))>
			</cfif>
		</cfif>
		<cfinclude template="../query/get_expense_rows.cfm">
		<cfparam name="attributes.totalrecords" default="#get_expense_item_row_all.query_count#">
		<cfif get_expense_item_row_all.recordcount>
			<cfset company_id_list=''>
			<cfset consumer_id_list=''>
			<cfset employee_id_list=''>
			<cfoutput query="get_expense_item_row_all">
				<cfif isdefined('company_id') and len(company_id) and not listfind(company_id_list,company_id)>
					<cfset company_id_list=listappend(company_id_list,company_id)>
				</cfif>
				<cfif isdefined('consumer_id') and len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
					<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
				</cfif>
				<cfif isdefined('employee_id') and len(employee_id) and not listfind(employee_id_list,employee_id)>
					<cfset employee_id_list=listappend(employee_id_list,employee_id)>
				</cfif>
			</cfoutput>
			<cfif listlen(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_company" datasource="#DSN#">
					SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN(#company_id_list#) ORDER BY COMPANY_ID
				</cfquery>
				<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company.COMPANY_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
				<cfquery name="get_consumer" datasource="#dsn#">
					SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
				</cfquery>
				<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer.CONSUMER_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfquery name="get_employee" datasource="#dsn#">
					SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.EMPLOYEE_ID,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
	<cfquery name="get_document_type" datasource="#dsn#">
		SELECT
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
		FROM
			SETUP_DOCUMENT_TYPE,
			SETUP_DOCUMENT_TYPE_ROW
		WHERE
			SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
			SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%cost.form_add_expense_cost%">
		ORDER BY
			DOCUMENT_TYPE_NAME
	</cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="search_expense" id="search_expense" action="#request.self#?fuseaction=cost.list_expense_management" method="post">
				<input name="form_exist" id="form_exist" type="hidden" value="1">			
				<cf_box_search>
					<div class="form-group">
						<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
					</div>	
					<div class="form-group medium" id="item-expense_code">
						<cfset pre_expense_code="">
						<select name="expense_center_id" id="expense_center_id" class="txt">
							<option value=""><cf_get_lang dictionary_id='58460.Masraf Merkezi'></option>
							<cfoutput query="get_expense_center">
								<option value="#EXPENSE_ID#" <cfif attributes.expense_center_id eq EXPENSE_ID>selected</cfif>>
									<cfif listfirst(expense_code,'.') eq pre_expense_code>;;</cfif>
									#expense#
								</option>
								<cfset pre_expense_code=listfirst(expense_code,'.')>
							</cfoutput>
						</select>
					</div>
					<div class="form-group medium" id="item-expense_cat">
						<cfsavecontent variable="text"><cf_get_lang dictionary_id='51314.Gider Kategori'></cfsavecontent>
						<cf_wrk_budgetcat name="expense_cat" option_text="#text#" value="#attributes.expense_cat#" width="115">
					</div>
					<div class="form-group medium" id="item-expense_item_id">
						<cfsavecontent variable="text"><cf_get_lang dictionary_id='58551.Gider Kalemi'></cfsavecontent>
						<cf_wrk_budgetitem name="expense_item_id" width="170" class="txt" value="#attributes.expense_item_id#" income_expense="0" option_text="#text#">
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">										
						<div class="form-group" id="item-asset">
							<label><cf_get_lang dictionary_id='29452.Varlık'></label>
							<div class="input-group">
								<cfif len(attributes.asset) and len(attributes.asset_id)>
									<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
									<input type="text" name="asset" id="asset" value="<cfoutput>#attributes.asset#</cfoutput>">
								<cfelse>
									<input type="hidden" name="asset_id" id="asset_id" value="">
									<input type="text" name="asset" id="asset" value="">
								</cfif>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=search_expense.asset_id&field_name=search_expense.asset&event_id=0&motorized_vehicle=0','list');" title="<cfoutput>#getLang(48,'Filtre',57460)#</cfoutput>"></span>
							</div>
						</div>
						<div class="form-group" id="item-project">
							<label><cf_get_lang dictionary_id='57416.Proje'></label>
							<cfif x_is_project_popup eq 0>
								<cfset get_project = get_fuseaction_property.get_project()>
								<cf_multiselect_check 
									query_name="get_project"  
									name="project_id"
									width="135" 
									option_value="project_id"
									option_name="project_head"
									value="#attributes.project_id#">
							<cfelse>
								<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
								<div class="input-group">
									<input name="project_head" type="text" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','217');" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_expense.project_id&project_head=search_expense.project_head&is_empty_project&moreProject=1&draggable=1');"></span>
								</div>
							</cfif>
						</div>	
						<div class="form-group" id="item-ch_company">
							<label><cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput></label>
							<div class="input-group">
								<input type="hidden" name="ch_member_type" id="ch_member_type" value="<cfoutput>#attributes.ch_member_type#</cfoutput>">
								<input type="hidden" name="ch_company_id" id="ch_company_id" value="<cfif isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type is 'partner'><cfoutput>#attributes.ch_company_id#</cfoutput></cfif>">
								<input type="hidden" name="ch_consumer_id" id="ch_consumer_id" value="<cfif isdefined("attributes.ch_consumer_id") and len(attributes.ch_consumer_id) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type is 'consumer'><cfoutput>#attributes.ch_consumer_id#</cfoutput></cfif>">
								<input type="hidden" name="ch_employee_id"  id="ch_employee_id"value="<cfif isdefined("attributes.ch_employee_id") and len(attributes.ch_employee_id) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type is 'employee'><cfoutput>#attributes.ch_employee_id#</cfoutput></cfif>">
								<input type="text" name="ch_company" id="ch_company" onFocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'1\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','ch_company_id,ch_consumer_id,ch_employee_id,ch_member_type','','3','225');" value="<cfif  isdefined("attributes.ch_company") and len(attributes.ch_company)><cfoutput>#attributes.ch_company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=search_expense.ch_company&is_cari_action=1&field_type=search_expense.ch_member_type&field_comp_name=search_expense.ch_company&field_consumer=search_expense.ch_consumer_id&field_emp_id=search_expense.ch_employee_id&field_comp_id=search_expense.ch_company_id&select_list=2,3,1,9</cfoutput>','list');" title="<cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">	
						<div class="form-group" id="item-recorder_name">
							<label><cfoutput>#getLang('cost',5)#</cfoutput></label>
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="expense_part_id" id="expense_part_id" value="#attributes.expense_part_id#">
									<input type="hidden" name="expense_cons_id" id="expense_cons_id" value="#attributes.expense_cons_id#">
									<input type="hidden" name="expense_emp_id" id="expense_emp_id" value="#attributes.expense_emp_id#">
									<input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
									<input type="text" name="recorder_name" id="recorder_name" onFocus="AutoComplete_Create('recorder_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','expense_emp_id,expense_part_id,expense_cons_id,member_type','','3','110');" value="#attributes.recorder_name#" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_expense.expense_emp_id&field_partner=search_expense.expense_part_id&field_consumer=search_expense.expense_cons_id&field_name=search_expense.recorder_name&field_type=search_expense.member_type&select_list=1,2,3&is_form_submitted=1&keyword='+encodeURIComponent(document.search_expense.recorder_name.value),'list');" title="#getLang('cost',5)#"></span>
								</cfoutput>
							</div>							
						</div>			
						<div class="form-group" id="item-document_type">
							<label><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
								<select name="expense_paper_type" id="expense_paper_type">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_document_type">
										<option value="#document_type_id#" <cfif attributes.expense_paper_type eq document_type_id>selected</cfif>>
											#document_type_name#
										</option>
									</cfoutput>
								</select>
						</div>
						<div class="form-group" id="item-process_cat">
							<label><cf_get_lang dictionary_id="57800.İşlem Tipi"></label>
								<cfquery name="get_process_cat" datasource="#dsn3#">
									SELECT PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (18,302,21,22,23,2311,2313,24,25,30,31,32,33,34,35,44,45,46,48,49,50,51,52,53,54,55,56,58,59,60,62,63,64,65,66,67,68,120,161,1201,1202,1203,121,122,130,131,311,254,592,531,533,534,5312,5313,555,561,591,601,690,691,241,2410,243,291,292,293,294,2931,2932,296,318)
								</cfquery>
								<cf_multiselect_check 
									query_name="get_process_cat"  
									name="process_cat"
									width="135" 
									option_value="process_type"
									option_name="process_cat"
									value="#attributes.process_cat#"
									>					
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
						<div class="form-group" id="item-branch">
							<label><cf_get_lang dictionary_id='57453.Şube'></label>
							<cfsavecontent variable="opt_value"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
							<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='130' selected_value='#attributes.branch_id#' option_value='#opt_value#'>
						</div>
						<div class="form-group" id="item-activity_type">
							<label><cfoutput>#getLang('cost',15)#</cfoutput></label>
							<cfsavecontent variable="text"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
							<cf_wrk_budgetactivity name="activity_type" width="130" class="txt" option_text="#text#" value="#attributes.activity_type#">
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
						<div class="form-group" id="item-record_date">
							<label><cfoutput>#getLang(215,'Kayıt Tarihi',57627)#</cfoutput></label>
							<div class="input-group">
								<cfinput type="text" name="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date1"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date2"></span>
							</div>
						</div>
						<div class="form-group" id="item-search_date">
							<label><cfoutput>#getLang('cost',4)#</cfoutput></label>
							<div class="input-group">
								<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
									<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent> 
									<cfinput type="text" name="search_date1" message="#message#" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
								<span class="input-group-addon no-bg"></span>
								<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
									<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
									<cfinput type="text" name="search_date2" message="#message#" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date2"></span>
							</div>
						</div>
					</div>
				</cf_box_search_detail>			
			</cfform>
		</cf_box>
		<cf_box title="#getLang('cost',23)#" uidrop="1" hide_table_column="1" resize="1" collapsable="1">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
						<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
						<th><cf_get_lang dictionary_id='57416.Proje'></th>
						<th><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
						<th nowrap><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='51309.Harcama Yapan'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='50982.öiv'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57644.Son Toplam'></th>
						<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='58517.Dövizli Son Toplam'></th>
						<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<!-- sil --><th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th><!-- sil -->	
						
					</tr>
				</thead>
					<cfif len(attributes.form_exist)>
						<cfif  get_expense_item_row_all.recordcount>
							<cfscript>
								toplam1 = 0;
								toplam2 = 0;
								toplam3 = 0;
								toplam4 = 0;
								toplam5 = 0;
								toplam6 = 0;
								toplam7 = 0;
								toplam8 = 0;
								toplam_oiv = 0;
							</cfscript>
							<tbody>
							<cfoutput query="get_expense_item_row_all">
								<cfif currentrow eq 1>
									<cfscript>
										toplam1 = get_expense_item_row_all.toplam1 ;				
										toplam2 = get_expense_item_row_all.toplam2 ;
										toplam7 = get_expense_item_row_all.toplam8 ;
										toplam3 = get_expense_item_row_all.toplam3 ;
										toplam_oiv = get_expense_item_row_all.toplam_oiv ;
									</cfscript>
								</cfif>
								<cfscript>
									if (len(QUANTITY))
										amount_info = (AMOUNT*QUANTITY);
									else
										amount_info = AMOUNT;
									if(len(amount_kdv))
										kdv_deger = amount_kdv;
									else
										kdv_deger = 0;
									if(len(amount_otv))
										otv_deger = amount_otv;
									else
										otv_deger = 0;
									if(len(amount_oiv))
										oiv_deger = amount_oiv;
									else
										oiv_deger = 0;
									toplam4 = toplam4 + amount_info;				
									toplam5 = toplam5 + kdv_deger;
									toplam7 = toplam7 + otv_deger;
									toplam6 = toplam6 + amount_info + kdv_deger + otv_deger; // + oiv_deger;
								</cfscript>
								<tr>
									<td>#rownum#</td>
									<td>#expense#</td>
									<td>#expense_item_name#</td>
									<td><cfif isdefined('project_id') and len(project_id)>#GET_PROJECT_NAME(project_id)#</cfif></td>
									<td>#ASSETP#</td>
									<td>
										#COMPANY_NAME#
									</td>
									<td>#BRANCH#</td>
									<td>#paper_no#</td>
									<td>#detail#</td>
									<td>#get_process_name(expense_cost_type)#</td>
									<td>#dateformat(expense_date,dateformat_style)#</td>
									<td>
										<cfif member_type eq 'partner'>#get_par_info(company_partner_id,0,0,1)#
										<cfelseif member_type eq 'consumer'>#get_cons_info(company_partner_id,0,1)#
										<cfelseif member_type eq 'employee'>#get_emp_info(company_partner_id,0,1)#
										<cfelse>#get_emp_info(company_partner_id,1,1)#</cfif>	
									</td>
									<td style="text-align:right;">
										<cfif expense_id neq 0 and expense_cost_type eq 120>
											<a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#" class="tableyazi">#TLFormat(amount_info)#</a>
										<cfelse>
											#TLFormat(amount_info)# 
										</cfif>
									<td style="text-align:right;"><cfif len(amount_kdv)>#tlformat(amount_kdv)#<cfelse>0 </cfif></td>
									<td style="text-align:right;">#TLFormat(amount_otv)#</td>
									<td style="text-align:right;">#TLFormat(amount_oiv)#</td>
									<td style="text-align:right;">
										<cfif len(total_amount)>
											#tlformat(total_amount)# 
										<cfelse>
											<cfif len(amount_kdv)>
												<cfset kvd_deger = amount_kdv>
											<cfelse>
												<cfset kvd_deger = 0>
											</cfif>
											#TLFormat((kvd_deger + otv_deger + amount_info))# 
										</cfif>
									</td>
									<td>#session.ep.money#</td>
									<td style="text-align:right;">#TLFormat(other_money_value)#</td>
									<td style="text-align:right;">#TLFormat(other_money_gross_total)#</td>
									<td>#money_currency_id#</td>
									<!-- sil -->
									<td>
										<cfif expense_id neq 0 and expense_cost_type eq 120>
											<a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										<cfelse>
											<cfif expense_cost_type eq 122><!--- bakım fişi --->
												<a href="#request.self#?fuseaction=assetcare.form_add_expense_cost&event=upd&expense_id=#expense_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif expense_cost_type eq 32><!--- kasa ödeme --->
												<a href="#request.self#?fuseaction=cash.form_add_cash_payment&event=upd&id=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("50,52,53,56,62,67,531",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#invoice_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("51,54,55,59,60,63,64,68,591,64,690,691",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#invoice_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("65",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("66",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("118",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("243",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_upd_bank_cc_payment&ID=#action_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("42,46",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_print_upd_debit_claim_note&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
											</cfif>
											<cfif listfind("291",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.popup_dsp_credit_payment&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("1043",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_check_preview&ID=#action_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("25",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_dsp_gidenh&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("24",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_dsp_gelenh&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("18",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
											</cfif>
											<cfif listfind("160",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&ID=#action_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
											</cfif>
											<cfif listfind("23",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=bank.form_add_virman&event=upd&ID=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("133,93",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_dsp_payroll_bank_guaranty&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("131",expense_cost_type,",")>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_dsp_collacted_dekont&ID=#action_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("111",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#FIS_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
											<cfif listfind("162",expense_cost_type,",")>
												<a href="#request.self#?fuseaction=budget.MagicbudgeterRun&wizard_id=#action_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
											</cfif>
										</cfif>
									</td>
									<!-- sil -->
								</tr>
							</cfoutput>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="12" class="txtbold"><cf_get_lang dictionary_id='51312.Sayfa Toplam'></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam4)# </cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam5)# </cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam7)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam_oiv)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam6)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								</tr>
								<tr>
									<td colspan="12" class="txtbold"> <cf_get_lang dictionary_id='57680.GenelToplam'></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam1)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam2)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam8)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam_oiv)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#TLFormat(toplam3)#</cfoutput></td>
									<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								</tr>
							</tfoot>
						<cfelse>
							<tr>
								<td colspan="22"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
							</tr>
						</cfif>
					<cfelse>
						<tr>
							<td colspan="22"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
						</tr>
					</cfif>
			</cf_grid_list>
			<cfscript>
				url_str = "";
				if ( len(attributes.keyword) )
					url_str = "#url_str#&keyword=#attributes.keyword#";
				if ( len(attributes.search_date1) )
					url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#";
				if ( len(attributes.search_date2) )
					url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#";
				if ( len(attributes.record_date1) )
					url_str = "#url_str#&record_date1=#dateformat(attributes.record_date1,dateformat_style)#";
				if ( len(attributes.record_date2) )
					url_str = "#url_str#&record_date2=#dateformat(attributes.record_date2,dateformat_style)#";
				if ( len(attributes.asset) )
					url_str = "#url_str#&asset=#attributes.asset#";
				if ( len(attributes.process_cat) )
					url_str = "#url_str#&asset=#attributes.process_cat#";
				if ( len(attributes.asset_id) )
					url_str = "#url_str#&asset_id=#attributes.asset_id#";
				if ( len(attributes.project_id) )
					url_str = "#url_str#&project_id=#attributes.project_id#";
				if ( len(attributes.project) )
					url_str = "#url_str#&project=#attributes.project#";
				if ( len(attributes.expense_paper_type) )
					url_str = "#url_str#&expense_paper_type=#attributes.expense_paper_type#";
				if ( len(attributes.expense_item_id) )
					url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
				if ( len(attributes.expense_center_id) )
					url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
				if ( len(attributes.activity_type) )
					url_str = "#url_str#&activity_type=#attributes.activity_type#";
				if ( len(attributes.form_exist) )
					url_str = "#url_str#&form_exist=#attributes.form_exist#";
				if ( len(attributes.expense_cat) )
					url_str = "#url_str#&expense_cat=#attributes.expense_cat#";
				if (len(attributes.branch_id))
					url_str = "#url_str#&branch_id=#attributes.branch_id#";
				
				if (len(attributes.ch_company) and len(attributes.ch_member_type)) url_str = "#url_str#&ch_member_type=#attributes.ch_member_type#";
				if (len(attributes.ch_company) and len(attributes.ch_company_id)) url_str = "#url_str#&ch_company_id=#attributes.ch_company_id#";
				if (len(attributes.ch_company) and len(attributes.ch_consumer_id)) url_str = "#url_str#&ch_consumer_id=#attributes.ch_consumer_id#";
				if (len(attributes.ch_company) and len(attributes.ch_employee_id)) url_str = "#url_str#&ch_employee_id=#attributes.ch_employee_id#";
				if (len(attributes.ch_company) and len(attributes.ch_company)) url_str = "#url_str#&ch_company=#attributes.ch_company#";
				
				if (len(attributes.recorder_name) and len(attributes.member_type)) url_str = "#url_str#&member_type=#attributes.member_type#";
				if (len(attributes.recorder_name) and len(attributes.expense_part_id)) url_str = "#url_str#&expense_part_id=#attributes.expense_part_id#";
				if (len(attributes.recorder_name) and len(attributes.expense_cons_id)) url_str = "#url_str#&expense_cons_id=#attributes.expense_cons_id#";
				if (len(attributes.recorder_name) and len(attributes.expense_emp_id)) url_str = "#url_str#&expense_emp_id=#attributes.expense_emp_id#";
				if (len(attributes.recorder_name) and len(attributes.recorder_name)) url_str = "#url_str#&recorder_name=#attributes.recorder_name#";
			</cfscript>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="cost.list_expense_management&#url_str#">
		</cf_box>
	</div>
	<script type="text/javascript">
		document.getElementById('keyword').focus();
	</script>
	