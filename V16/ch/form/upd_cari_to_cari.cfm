<cf_get_lang_set module_name="ch">
<cf_xml_page_edit fuseact="ch.add_cari_to_cari">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">

<cfquery name="get_note" datasource="#dsn2#">
	SELECT * FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.id#
</cfquery>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT IS_PROCESS_CURRENCY FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_note.process_cat#
</cfquery>
<cfif not get_note.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfset to_member_code = ''>
<cfset from_member_code = ''>
<cfif len(get_note.to_consumer_id)>
	<cfquery name="get_to_consumer_code" datasource="#dsn2#">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn_alias#.CONSUMER_PERIOD
		WHERE
			CONSUMER_ID = #get_note.to_consumer_id#
			AND	PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfset to_member_code = get_to_consumer_code.ACCOUNT_CODE>
</cfif>
<cfif len(get_note.from_consumer_id)>
	<cfquery name="get_from_consumer_code" datasource="#dsn2#">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn_alias#.CONSUMER_PERIOD
		WHERE
			CONSUMER_ID = #get_note.from_consumer_id#
			AND	PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfset from_member_code = get_from_consumer_code.ACCOUNT_CODE>
</cfif>
<cfif len(get_note.to_cmp_id)>
	<cfquery name="get_to_company_code" datasource="#dsn2#">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn_alias#.COMPANY_PERIOD
		WHERE
			COMPANY_ID = #get_note.to_cmp_id#
			AND	PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfset to_member_code = get_to_company_code.ACCOUNT_CODE>
</cfif>
<cfif len(get_note.from_cmp_id)>
	<cfquery name="get_from_company_code" datasource="#dsn2#">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn_alias#.COMPANY_PERIOD
		WHERE
			COMPANY_ID = #get_note.from_cmp_id#
			AND	PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfset from_member_code = get_from_company_code.ACCOUNT_CODE>
</cfif>
<cfif len(get_note.to_employee_id)>
	<cfquery name="get_to_employee_code" datasource="#dsn2#">
		SELECT
			EIOP.ACCOUNT_CODE
		FROM
			#dsn_alias#.EMPLOYEES_IN_OUT EIO,
            <cfif len(get_note.acc_type_id) and get_note.acc_type_id neq 0>
                #dsn_alias#.EMPLOYEES_ACCOUNTS EIOP
            <cfelse>
                #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP
			</cfif>
		WHERE
			EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_note.to_employee_id#">
			<cfif len(get_note.acc_type_id) and get_note.acc_type_id neq 0>
				AND EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID
            <cfelse>
				AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID
			</cfif>
            <cfif len(get_note.acc_type_id) and get_note.acc_type_id neq 0>
				AND EIOP.ACC_TYPE_ID = #get_note.acc_type_id#
			</cfif>
			AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfset to_member_code = get_to_employee_code.ACCOUNT_CODE>
</cfif>
<cfif len(get_note.from_employee_id)>
	<cfquery name="get_from_employee_code" datasource="#dsn2#">
		SELECT
			EIOP.ACCOUNT_CODE
		FROM
			#dsn_alias#.EMPLOYEES_IN_OUT EIO,
            <cfif len(get_note.from_acc_type_id) and get_note.from_acc_type_id neq 0>
                #dsn_alias#.EMPLOYEES_ACCOUNTS EIOP
            <cfelse>
                #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP
			</cfif>
		WHERE
			EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_note.from_employee_id#">
			<cfif len(get_note.from_acc_type_id) and get_note.acc_type_id neq 0>
				AND EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID
            <cfelse>
				AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID
			</cfif>
            <cfif len(get_note.from_acc_type_id) and get_note.from_acc_type_id neq 0>
				AND EIOP.ACC_TYPE_ID = #get_note.from_acc_type_id#
			</cfif>
			AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfset from_member_code = get_from_employee_code.ACCOUNT_CODE>
</cfif>
	<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="upd_cari_to_cari" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_cari_to_cari">
			<cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cari_to_cari'>
				<input type="hidden" name="is_popup" id="is_popup" value="1">
			</cfif>
			<cfoutput>
				<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
				<input type="hidden" name="action_id" id="action_id" value="#get_note.action_id#">	
				<input type="hidden" name="id" id="id" value="#attributes.id#">
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-survey_head">
							<label class="col col-4 col-xs-12"><cf_get_lang no='188.İşlem Türü'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="175" onclick_function="ayarla_gizle_goster()" process_cat = "#get_note.process_cat#">
							</div>
						</div>
						<cfset emp_id = get_note.to_employee_id>
						<cfset comp_id = get_note.to_cmp_id>
						<cfset cons_id = get_note.to_consumer_id>
						<cfif len(get_note.acc_type_id)>
							<cfset emp_id = "#emp_id#_#get_note.acc_type_id#">
						</cfif>
						<cfif len(get_note.to_cmp_id)>
							<cfset member_name=get_par_info(get_note.to_cmp_id,1,1,0,get_note.acc_type_id)>
							<cfset to_member_type="partner">
							<cfif len(get_note.acc_type_id)>
								<cfset comp_id =comp_id&'_'&get_note.acc_type_id>
							</cfif>
						<cfelseif len(get_note.to_consumer_id)>
							<cfset member_name=get_cons_info(get_note.to_consumer_id,0,0,get_note.acc_type_id)>
							<cfset to_member_type="consumer">
							<cfif len(get_note.acc_type_id)>
								<cfset cons_id =cons_id&'_'&get_note.acc_type_id>
							</cfif>
						<cfelseif len(get_note.to_employee_id)>
							<cfset member_name=get_emp_info(get_note.to_employee_id,0,0,0,get_note.acc_type_id)>
							<cfset to_member_type="employee">
						</cfif>
						<div class="form-group" id="item-to_company_id">
							<label class="col col-4 col-xs-12"><cf_get_lang no='187.Borçlu Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="to_company_id" id="to_company_id" value="#comp_id#">
									<input type="hidden" name="to_consumer_id" id="to_consumer_id" value="#cons_id#">
									<input type="hidden" name="to_employee_id" id="to_employee_id" value="#emp_id#">
									<input type="hidden" name="to_member_type" id="to_member_type" value="#to_member_type#">
									<input type="hidden" name="to_member_code" id="to_member_code" value="#to_member_code#">
									<input type="text" name="to_company_name" id="to_company_name" value="#member_name#" onFocus="AutoComplete_Create('to_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','to_company_id,to_consumer_id,to_employee_id,to_member_type,to_member_code','','3','250','get_money_info(\'upd_cari_to_cari\',\'action_date\',\'ACTION_CURRENCY_ID\')');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_multi_act=1&select_list=1,2,3,9&is_cari_action=1&field_comp_id=upd_cari_to_cari.to_company_id&field_member_name=upd_cari_to_cari.to_company_name&field_name=upd_cari_to_cari.to_company_name&field_consumer=upd_cari_to_cari.to_consumer_id&field_emp_id=upd_cari_to_cari.to_employee_id&field_type=upd_cari_to_cari.to_member_type&field_member_account_code=upd_cari_to_cari.to_member_code&is_kur=0&field_select_name=add_cari_to_cari.ACTION_CURRENCY_ID','list');"></span>
								</div>
							</div>
						</div>
						<cfset emp_id = get_note.from_employee_id>
						<cfset from_comp_id = get_note.from_cmp_id>
						<cfset from_cons_id =get_note.from_consumer_id>
						<cfif len(get_note.from_acc_type_id)>
							<cfset emp_id = "#emp_id#_#get_note.from_acc_type_id#">
						</cfif>
						<cfif len(get_note.from_cmp_id)>
							<cfset member_name_2= get_par_info(get_note.from_cmp_id,1,1,0,get_note.from_acc_type_id)>
							<cfset from_member_type="partner">
							<cfif len(get_note.from_acc_type_id)>
								<cfset from_comp_id =from_comp_id&'_'&get_note.from_acc_type_id>
							</cfif>
						<cfelseif len(get_note.from_consumer_id)>
							<cfset member_name_2=get_cons_info(get_note.from_consumer_id,0,0,get_note.from_acc_type_id)>
							<cfset from_member_type="consumer">
							<cfif len(get_note.from_acc_type_id)>
								<cfset from_cons_id =from_cons_id&'_'&get_note.from_acc_type_id>
							</cfif>
						<cfelseif len(get_note.from_employee_id)>
							<cfset member_name_2=get_emp_info(get_note.from_employee_id,0,0,0,get_note.from_acc_type_id)>
							<cfset from_member_type="employee">
						</cfif>
						<div class="form-group" id="item-from_company_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="from_company_id" id="from_company_id" value="#from_comp_id#">
									<input type="hidden" name="from_consumer_id" id="from_consumer_id" value="#from_cons_id#">
									<input type="hidden" name="from_employee_id" id="from_employee_id" value="#emp_id#">
									<input type="hidden" name="from_member_type" id="from_member_type" value="#from_member_type#">
									<input type="hidden" name="from_member_code" id="from_member_code" value="#from_member_code#">
									<input type="text" name="from_company_name" id="from_company_name" value="#member_name_2#" onFocus="AutoComplete_Create('from_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'1\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','from_company_id,from_consumer_id,from_employee_id,from_member_type,from_member_code','','3','250','get_money_info(\'add_cari_to_cari\',\'action_date\',\'ACTION_CURRENCY_ID_\')');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_multi_act=1&select_list=1,2,3,9&is_cari_action=1&field_comp_id=upd_cari_to_cari.from_company_id&field_member_name=upd_cari_to_cari.from_company_name&field_name=upd_cari_to_cari.from_company_name&field_consumer=upd_cari_to_cari.from_consumer_id&field_emp_id=upd_cari_to_cari.from_employee_id&field_type=upd_cari_to_cari.from_member_type&field_member_account_code=upd_cari_to_cari.from_member_code&is_kur=0&field_select_name=add_cari_to_cari.ACTION_CURRENCY_ID_','list');"></span>
								</div>
							</div>
						</div>															
						<div class="form-group" id="item-paper_number">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="paper_number" value="#get_note.paper_no#">
							</div>
						</div>						
						<div class="form-group" id="item-ACTION_CURRENCY_ID">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='175.Borc'><cf_get_lang_main no='261.Tutar'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="action_value" id="action_value" value="#TLFormat(get_note.action_value)#" class="moneybox" required="yes"  onBlur="kur_ekle_f_hesapla('ACTION_CURRENCY_ID',false,1);" onkeyup="return(FormatCurrency(this,event));">
									<span class="input-group-addon width">
										<select name="ACTION_CURRENCY_ID" id="ACTION_CURRENCY_ID" onChange="kur_ekle_f_hesapla('ACTION_CURRENCY_ID',false,1);">
										<cfloop query="get_money_rate">
											<option value="#MONEY_ID#;#MONEY#"<cfif MONEY eq get_note.ACTION_CURRENCY_ID>selected</cfif>>#MONEY#</option>
										</cfloop>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='176.Alacak'><cf_get_lang_main no='261.Tutar'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								<cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(get_note.OTHER_CASH_ACT_VALUE)#" class="moneybox" onBlur="kur_ekle_f_hesapla('ACTION_CURRENCY_ID_',true,1);" onkeyup="return(FormatCurrency(this,event));">
								<span class="input-group-addon width">
									<select name="ACTION_CURRENCY_ID_" id="ACTION_CURRENCY_ID_" onChange="kur_ekle_f_hesapla('ACTION_CURRENCY_ID_',true,1);">
										<cfloop query="get_money_rate">
											<option value="#MONEY_ID#;#MONEY#"<cfif MONEY eq get_note.OTHER_MONEY>selected</cfif>>#MONEY#</option>
										</cfloop>
									</select>
								</span>										
								</div>
							</div>
						</div>					
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-subscription_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='768.Borçlu'> <cf_get_lang_main no ='1705.Abone No'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='upd_cari_to_cari' subscription_id='#get_note.subscription_id#' subscription_no='#get_subscription_no(iif(len(get_note.subscription_id),get_note.subscription_id,0))#'>
							</div>
						</div>
						<div class="form-group" id="item-subscription_id">
							<label class="col col-4 col-xs-12"><cf_get_lang no='156.Alacaklı'> <cf_get_lang_main no ='1705.Abone No'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								<cfoutput>
									<input type="hidden" name="subscription_id2" id="subscription_id2" value="#get_note.to_subscription_id#">
									<input type="text" name="subscription_no2" id="subscription_no2"  placeholder="<cf_get_lang_main no='1705.Sistem No'>" value="#get_subscription_no(iif(len(get_note.to_subscription_id),get_note.to_subscription_id,0))#" onfocus="AutoComplete_Create('subscription_no2','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id2','','3','200');" autocomplete="off">
									<cfset str_subscription_link="field_partner=&field_id=add_cari_to_cari.subscription_id2&field_no=add_cari_to_cari.subscription_no2">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#','list','popup_list_subscription');" title="<cf_get_lang_main no='1705.Sistem NO'>"></span>
								</cfoutput>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-project_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='768.Borçlu'> <cf_get_lang_main no='4.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="#get_note.project_id#">
									<input type="text" name="project_name" id="project_name" value="<cfif len(get_note.project_id)>#get_project_name(get_note.project_id)#</cfif>" style="width:175px;"  onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer"  onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_cari_to_cari.project_name&project_id=upd_cari_to_cari.project_id');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-project_id_2">
							<label class="col col-4 col-xs-12"><cf_get_lang no='156.Alacaklı'> <cf_get_lang_main no='4.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="project_id_2" id="project_id_2" value="#get_note.project_id_2#">
									<input type="text" name="project_name_2" id="project_name_2" value="<cfif len(get_note.project_id_2)>#get_project_name(get_note.project_id_2)#</cfif>" style="width:175px;"  onFocus="AutoComplete_Create('project_name_2','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_2','','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_cari_to_cari.project_name_2&project_id=upd_cari_to_cari.project_id_2');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-branch_id_borc">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='768.Borçlu'> <cf_get_lang_main no='41.Sube'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='branch_id_borc' is_branch='1' width='175' is_default='1' is_deny_control='1' selected_value='#get_note.to_branch_id#'>
							</div>
						</div>
						<div class="form-group" id="item-branch_id_alacak">
							<label class="col col-4 col-xs-12"><cf_get_lang no='156.Alacaklı'> <cf_get_lang_main no='41.Sube'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='branch_id_alacak' is_branch='1' width='175' is_default='1' is_deny_control='1' selected_value='#get_note.from_branch_id#'>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="action_date" value="#dateformat(get_note.action_date,dateformat_style)#" readonly validate="#validate_style#" required="yes"  style="width:100px;" onblur="change_money_info('upd_cari_to_cari','action_date');">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"  call_function="change_money_info" control_date="#dateformat(get_note.action_date,dateformat_style)#"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-due_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ="57587.Borç"><cf_get_lang_main no='1439.Ödeme Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="due_date" value="#dateformat(get_note.due_date,dateformat_style)#" validate="#validate_style#"  style="width:100px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-from_due_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57588.Alacak"><cf_get_lang_main no='1439.Ödeme Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="from_due_date" value="#dateformat(get_note.from_due_date,dateformat_style)#" validate="#validate_style#"  style="width:100px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="from_due_date"></span>
								</div>
							</div>
						</div>
						<cfif session.ep.our_company_info.asset_followup eq 1>
							<div class="form-group" id="item-asset_id1">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='768.Borçlu'> <cf_get_lang_main no ='1421.Fiziki Varlık'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkAssetp asset_id='#get_note.assetp_id#' fieldId='asset_id1' fieldName='asset_name1' form_name='upd_cari_to_cari' width='175' line_info='1'>
								</div>
							</div>
							<div class="form-group" id="item-asset_id2">
								<label class="col col-4 col-xs-12"><cf_get_lang no='156.Alacaklı'> <cf_get_lang_main no ='1421.Fiziki Varlık'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkAssetp asset_id='#get_note.assetp_id_2#' fieldId='asset_id2' fieldName='asset_name2' form_name='upd_cari_to_cari' width='175' line_info='2'>
								</div>
							</div>
						</cfif>	
						<div class="form-group" id="item-action_detail">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="action_detail" id="action_detail" style="width:175px;height:50px;">#get_note.action_detail#</textarea>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-money_br">
							<label class="col col-12 bold"><cf_get_lang no='165.İşlem Para Br'></label>
						</div>
						<div class="form-group" id="item-kur">
							<cfscript>f_kur_ekle(is_disable:1,action_id:URL.ID,process_type:1,base_value:'action_value',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_cari_to_cari',action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'ACTION_CURRENCY_ID',selected_money:'#session.ep.money#',call_function:'fnc');</cfscript>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6 col-xs-12">
						<cf_record_info query_name="get_note">
					</div>
					<div class="col col-6 col-xs-12">
						<cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cari_to_cari'>
						<cfset url_link = "&is_popup=1">
						<cfelse>
						<cfset url_link = "">
						</cfif>
						<cf_workcube_buttons 
						is_upd='1'
						add_function='kontrol()'
						del_function_for_submit='del_kontrol()'
						update_status='#get_note.UPD_STATUS#'
						delete_page_url='#request.self#?fuseaction=ch.emptypopup_del_debit_claim&action_id=#get_note.action_id#&process_type=#get_note.action_type_id#&head=#get_note.paper_no#&old_process_type=#get_note.action_type_id##url_link#'>
					</div>
				</cf_box_footer>
			</cfoutput>		
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	
	$(document).ready(function(){
		$("table tr:first-child input[name=rd_money]").prop("checked",true);
			kur_ekle_f_hesapla('ACTION_CURRENCY_ID_',true,1);
			kur_ekle_f_hesapla('ACTION_CURRENCY_ID',false,1);
			$("#money_type").val('<cfoutput>#session.ep.money#</cfoutput>')
		
	});


	ayarla_gizle_goster();
	
	function ayarla_gizle_goster()
	{
		if(document.upd_cari_to_cari.process_cat.options[document.upd_cari_to_cari.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.upd_cari_to_cari.process_cat.options[document.upd_cari_to_cari.process_cat.selectedIndex].value;
			str1_ = "SELECT IS_PROCESS_CURRENCY FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = '"+ selected_ptype +"'";
			var get_is_process_currency = wrk_query(str1_,'dsn3');
			
			str2_ = "SELECT TOP 1 ACTION_VALUE FROM CARI_ROWS WHERE PROCESS_CAT = '"+ selected_ptype +"' AND ACTION_ID = '"+ document.getElementById("action_id").value +"'";
			var get_act_value = wrk_query(str2_,'dsn2');
			if(get_act_value.recordcount)
				temp_system_val = get_act_value.ACTION_VALUE;
			
			if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
			{	
				$('#tr_system_price').show();
				if(temp_system_val == undefined)
					temp_system_val =  $('#system_amount').val();
				temp_system_val = commaSplit(temp_system_val,2);
				$('#system_amount').remove();
				$('<input>').attr({
					type: 'text',
					id: 'system_amount',
					name: 'system_amount',
					style: 'width:100px;text-align:right;',
					value: temp_system_val
				}).appendTo('#td_system_price');
			}
			else
				$('#tr_system_price').hide();
		}
		else
			$('#tr_system_price').hide();
	}
	
	function del_kontrol()
	{
		if(!chk_period(upd_cari_to_cari.action_date,'İşlem')) return false;
		else return true;
	}
	
	function kontrol()
	{
		if(!chk_process_cat('upd_cari_to_cari')) return false;
		if(!check_display_files('upd_cari_to_cari')) return false;
		if(!chk_period(upd_cari_to_cari.action_date,'İşlem')) return false;
		x = (200 - upd_cari_to_cari.action_detail.value.length);
		if( x < 0 )
		{ 
			alert ("Açıklama "+ ((-1) * x) +" Karakter Uzun");
			return false;
		}
		return true;
		
	}
	function fnc(){
		var action_value = $("#ACTION_CURRENCY_ID").val();
		var other_cash_value = $("#ACTION_CURRENCY_ID_").val();
		if(action_value == other_cash_value){
			$("#OTHER_CASH_ACT_VALUE").val($("#action_value").val());
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
