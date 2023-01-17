<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_vouchers">
<cfparam name="attributes.due_start_date" default="">
<cfparam name="attributes.due_finish_date" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.payroll_date1" default="">
<cfparam name="attributes.payroll_date2" default="">
<cfparam name="attributes.oby" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.owner_company" default="">
<cfparam name="attributes.owner_company_id" default="">
<cfparam name="attributes.owner_consumer_id" default="">
<cfparam name="attributes.owner_employee_id" default="">
<cfparam name="attributes.owner_member_type" default="">
<cfparam name="attributes.debt_company" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.from_account_id" default="">
<cfparam name="attributes.cash" default="">
<cfparam name="attributes.paper_type" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.status" default="">
<cfquery name="get_user_process_info" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ACCOUNT,
		SPC.IS_ZERO_STOCK_CONTROL,
		SPC.IS_DEFAULT,
		SPC.IS_PROJECT_BASED_ACC,
		SPC.DISPLAY_FILE_NAME,
		SPC.DISPLAY_FILE_FROM_TEMPLATE
	FROM
		#dsn3_alias#.SETUP_PROCESS_CAT_ROWS AS SPCR,
		#dsn3_alias#.SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		#dsn3_alias#.SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE =1053 AND
		<cfif isDefined("session.ep.position_code")>
			EP.POSITION_CODE=#session.ep.position_code# AND
			(
				SPCR.POSITION_CODE=EP.POSITION_CODE OR
				SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID
			)
		<cfelseif isDefined("session.pp.company_id")>
			SPC.IS_PARTNER = 1
		<cfelseif isDefined("session.ww.our_company_id")>
			SPC.IS_PUBLIC = 1
		</cfif>
		ORDER BY SPC.PROCESS_CAT		
</cfquery>
<cfquery name="get_user_process_info2" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ZERO_STOCK_CONTROL,
		SPC.IS_DEFAULT,
		SPC.IS_PROJECT_BASED_ACC,
		SPC.DISPLAY_FILE_NAME,
		SPC.DISPLAY_FILE_FROM_TEMPLATE
	FROM
		#dsn3_alias#.SETUP_PROCESS_CAT_ROWS AS SPCR,
		#dsn3_alias#.SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		#dsn3_alias#.SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE =1056 AND
		<cfif isDefined("session.ep.position_code")>
			EP.POSITION_CODE=#session.ep.position_code# AND
			(
				SPCR.POSITION_CODE=EP.POSITION_CODE OR
				SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID
			)
		<cfelseif isDefined("session.pp.company_id")>
			SPC.IS_PARTNER = 1
		<cfelseif isDefined("session.ww.our_company_id")>
			SPC.IS_PUBLIC = 1
		</cfif>
		ORDER BY SPC.PROCESS_CAT		
</cfquery>
<cfquery name="check_our_company" datasource="#dsn#">
	SELECT IS_REMAINING_AMOUNT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfinclude template="../query/get_money2.cfm">
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_vouchers.cfm">
<cfelse>
	<cfset get_vouchers.recordcount = 0 >
</cfif>
<cfset sistem_toplam = 0>
<cfset sistem2_toplam = 0>
<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
    <cfset 'toplam_ilk_#money#' = 0>
    <cfset 'toplam_paid_#money#' = 0>
</cfoutput>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_vouchers.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_vouchers" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_vouchers" method="post">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" placeholder="#getLang(48,'Filtre',57460)#" maxlength="50" name="keyword" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<select name="paper_type" id="paper_type">
						<option value=""><cf_get_lang dictionary_id='58533.Belge Tipi'></option>
						<option value="0" <cfif attributes.paper_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58008.Senet'></option>
						<option value="1" <cfif attributes.paper_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29945.Ödeme Sözü'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="money_type" id="money_type">
						<option value=""><cf_get_lang dictionary_id='57489.Para Birimi'></option>
						<cfoutput query="get_money">
							<option value="#money#" <cfif isdefined("attributes.money_type") and len(attributes.money_type) and money eq attributes.money_type>selected</cfif>>#money#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="oby" id="oby">
						<option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif> ><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
						<option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif> ><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
						<option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif> ><cf_get_lang dictionary_id='29459.Artan No'></option>
						<option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif> ><cf_get_lang dictionary_id='29458.Azalan No'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-owner_company">
						<label class="col col-12"><cf_get_lang dictionary_id='50488.Senet Sahibi'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="owner_company_id" id="owner_company_id" <cfif len(attributes.owner_company) and len(attributes.owner_company_id)> value="<cfoutput>#attributes.owner_company_id#</cfoutput>"</cfif>>
								<input type="hidden" name="owner_consumer_id" id="owner_consumer_id" <cfif len(attributes.owner_company) and len(attributes.owner_consumer_id)> value="<cfoutput>#attributes.owner_consumer_id#</cfoutput>"</cfif>>
								<input type="hidden" name="owner_employee_id" id="owner_employee_id" <cfif len(attributes.owner_company) and len(attributes.owner_employee_id)> value="<cfoutput>#attributes.owner_employee_id#</cfoutput>"</cfif>>
								<input type="hidden" name="owner_member_type" id="owner_member_type" <cfif len(attributes.owner_company) and len(attributes.owner_member_type)> value="<cfoutput>#attributes.owner_member_type#</cfoutput>"</cfif>>
								<input name="owner_company" type="text" id="owner_company" onFocus="AutoComplete_Create('owner_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','owner_company_id,owner_consumer_id,owner_employee_id,owner_member_type','','3','250');" value="<cfif len(attributes.owner_company) ><cfoutput>#attributes.owner_company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=1,2,3,9&field_comp_id=list_vouchers.owner_company_id&field_member_name=list_vouchers.owner_company&field_name=list_vouchers.owner_company&field_consumer=list_vouchers.owner_consumer_id&field_emp_id=list_vouchers.owner_employee_id&field_type=list_vouchers.owner_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');" title="<cf_get_lang dictionary_id='50488.Senet Sahibi'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company) and len(attributes.company_id)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
								<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company) and len(attributes.consumer_id)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
								<input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company) and len(attributes.employee_id)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
								<input type="hidden" name="member_type" id="member_type" <cfif len(attributes.company) and len(attributes.member_type)> value="<cfoutput>#attributes.member_type#</cfoutput>"</cfif>>
								<input type="text" name="company" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','250');" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=1,2,3,9&field_comp_id=list_vouchers.company_id&field_member_name=list_vouchers.company&field_name=list_vouchers.company&field_consumer=list_vouchers.consumer_id&field_emp_id=list_vouchers.employee_id&field_type=list_vouchers.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-account_id">
						<label class="col col-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
						<div class="col col-12">
							<cf_wrkBankAccounts width='285' fieldId='account_id' selected_value='#attributes.account_id#' is_multiple="1" is_upd="1">
						</div>
					</div>
					<div class="form-group" id="item-cash">
						<label class="col col-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
						<div class="col col-12">
						<cf_wrk_Cash name="cash" value="#attributes.cash#" cash_status="1">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-debt_company">
						<label class="col col-12"><cf_get_lang dictionary_id='58180.Borçlu'></label>
						<div class="col col-12">
							<input type="text" maxlength="255" name="debt_company" id="debt_company" value="<cfif isDefined("attributes.debt_company")><cfoutput>#attributes.debt_company#</cfoutput></cfif>">
						</div>
					</div>
					<div class="form-group" id="item-project_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
									<input type="text" name="project_head" id="project_head" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');" title="<cf_get_lang dictionary_id='58797.Proje Seiniz'>"></span>
								</div>
							</div>
						</div>
					<div class="form-group" id="item-status">
						<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-12">
							<select name="status" id="status" multiple>
								<option value="1" <cfif isDefined("attributes.status") and listfind(attributes.status,'1',',')>selected</cfif>><cf_get_lang dictionary_id='50249.Portföyde'></option>
								<option value="2" <cfif isDefined("attributes.status") and listfind(attributes.status,'2',',')>selected</cfif>><cf_get_lang dictionary_id='50250.Bankada'></option>
								<option value="13" <cfif isDefined("attributes.status") and listfind(attributes.status,'13',',')>selected</cfif>><cf_get_lang dictionary_id='50467.Teminatta'></option>
								<option value="3" <cfif isDefined("attributes.status") and listfind(attributes.status,'3',',')>selected</cfif>><cf_get_lang dictionary_id='50251.Tahsil Edildi'></option>
								<option value="4" <cfif isDefined("attributes.status") and listfind(attributes.status,'4',',')>selected</cfif>><cf_get_lang dictionary_id='50252.Ciro Edildi'></option>
								<option value="5" <cfif isDefined("attributes.status") and listfind(attributes.status,'5',',')>selected</cfif>><cf_get_lang dictionary_id='50334.Protestolu'></option>
								<option value="6" <cfif isDefined("attributes.status") and listfind(attributes.status,'6',',')>selected</cfif>><cf_get_lang dictionary_id='50254.Ödenmedi'></option>
								<option value="7" <cfif isDefined("attributes.status") and listfind(attributes.status,'7',',')>selected</cfif>><cf_get_lang dictionary_id='50255.Ödendi'></option>
								<option value="8" <cfif isDefined("attributes.status") and listfind(attributes.status,'8',',')>selected</cfif>><cf_get_lang dictionary_id='58506.İptal'></option>
								<option value="9" <cfif isDefined("attributes.status") and listfind(attributes.status,'9',',')>selected</cfif>><cf_get_lang dictionary_id='29418.İade'></option>
								<option value="10" <cfif isDefined("attributes.status") and listfind(attributes.status,'10',',')>selected</cfif>><cf_get_lang dictionary_id='50334.Protestolu'>-<cf_get_lang dictionary_id='50249.Portföyde'></option>
								<option value="11" <cfif isDefined("attributes.status") and listfind(attributes.status,'11',',')>selected</cfif>><cf_get_lang dictionary_id='50364.Kısmi Tahsil'></option>
								<option value="12" <cfif isDefined("attributes.status") and listfind(attributes.status,'12',',')>selected</cfif>><cf_get_lang dictionary_id='50363.İcra'></option>
								<option value="14" <cfif isDefined("attributes.status") and listfind(attributes.status,'14',',')>selected</cfif>><cf_get_lang dictionary_id='58568.Transfer'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-record_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>						
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="record_date1"></span>
								</div>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
								</div>
							</div>
						</div>						
					</div>
					<div class="form-group" id="item-due_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Baslama Tarihi Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="due_start_date" value="#dateformat(attributes.due_start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="due_start_date"></span>
								</div>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='50348.bitiş girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="due_finish_date" value="#dateformat(attributes.due_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="due_finish_date"></span>
								</div>
							</div>
						</div>	
					</div>
					<div class="form-group" id="item-payroll_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57521.Banka'><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="payroll_date1" value="#dateformat(attributes.payroll_date1,dateformat_style)#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="payroll_date1"></span>
								</div>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="payroll_date2" value="#dateformat(attributes.payroll_date2,dateformat_style)#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="payroll_date2"></span>
								</div>
							</div>
						</div>	
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(2295,'Senet Listesi',30092)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='50206.Bordro No'></th>
					<cfif x_show_partial_payments neq 1>
						<th><cf_get_lang dictionary_id='57640.Vade'></th>
					</cfif>
					<th><cf_get_lang dictionary_id="50228.Tahsilat Tarihi"></th>
					<th><cf_get_lang dictionary_id='58502.Senet No'></th>
					<th><cf_get_lang dictionary_id='58182.Portföy No'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
					<cfif x_is_dsp_notes eq 1>
						<th><cf_get_lang dictionary_id='57467.Not'></th>
					</cfif>
					<cfif x_show_partial_payments eq 1>
						<th><cf_get_lang dictionary_id='57640.Vade'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='57845.Tahsilat'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
					<th><cf_get_lang dictionary_id='50263.Sistem Para Br.'></th>
					<th>2. <cf_get_lang dictionary_id='57677.Döviz'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<!-- sil -->
					<cfif (x_change_process_type eq 1 and isDefined("attributes.status") and (attributes.status eq '2,13' or attributes.status eq 2 or attributes.status eq 13)) or (x_change_process_type_unpaid eq 1 and isDefined("attributes.status") and attributes.status eq 6)>
						<th width="20" class="header_icn_none">
							<input type="checkbox" name="all_select_cheque" id="all_select_cheque" onClick="wrk_select_all('all_select_cheque','row_voucher');">
						</th>
					</cfif>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-money" title="<cf_get_lang dictionary_id ='50277.senet tahsil işlemi'>"></i></th>
					<th width="20" class="text-center"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>"></i></th>
					<cfif session.ep.our_company_info.sms>
						<th width="20" class="header_icn_none"><i class="fa fa-mobile-phone" title="<cf_get_lang dictionary_id='58590.SMS Gönder'>"></i></th>
					</cfif>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif attributes.page neq 1>
					<cfoutput query="get_vouchers" startrow="1" maxrows="#attributes.startrow-1#">
						<cfif len(other_money_value)>
							<cfset sistem_toplam = sistem_toplam + other_money_value>
						</cfif>
						<cfif len(other_money_value2)>
							<cfset sistem2_toplam = sistem2_toplam + other_money_value2>
						</cfif>
						<cfif len(voucher_value)>
							<cfset 'toplam_#currency_id#' = evaluate('toplam_#currency_id#') +voucher_value>
						</cfif>
					</cfoutput>
				</cfif>
				<cfset process_type_info3 = '1054,1051'>
				<cfif get_vouchers.recordcount>
					<form name="upd_all_vouchers" id="upd_all_vouchers" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=cheque.emptypopup_upd_all_vouchers">
						<input type="hidden" name="voucher_id_list" id="voucher_id_list" value="">
						<input type="hidden" name="type" id="type" value="">
						<cfoutput query="get_vouchers" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfquery name="get_closeds" datasource="#dsn2#">
								SELECT CLOSED_AMOUNT,IS_VOUCHER_DELAY FROM VOUCHER_CLOSED WHERE ACTION_ID = #voucher_id#
							</cfquery>
							<cfquery name="get_voucher_closed" dbtype="query">
								SELECT SUM(CLOSED_AMOUNT) AS CLOSED_AMOUNT FROM get_closeds WHERE IS_VOUCHER_DELAY IS NULL
							</cfquery>
							<cfset company_id=get_vouchers.company_id>
							<tr>
								<td>#currentrow#</td>
								<td>
									<cfif get_vouchers.payroll_no neq -1>
										#get_vouchers.payroll_no# 
									<cfelse>
										<cf_get_lang dictionary_id='50336.Açılış'>
									</cfif>
								</td>
								<cfif x_show_partial_payments neq 1>
									<td>#dateformat(get_vouchers.voucher_duedate,dateformat_style)#</td>
								</cfif>
								<td>#dateformat(get_vouchers.tahsilat_tarihi,dateformat_style)#</td>
								<td width="150">
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_vouchers&event=det&ID=#get_vouchers.VOUCHER_ID#');">#get_vouchers.VOUCHER_NO#</a>
									<cfif len(is_pay_term) and is_pay_term eq 1>-<cf_get_lang dictionary_id='29945.Ödeme Sözü'></cfif>
								</td>
								<td>#get_vouchers.voucher_purse_no#</td>
								<td>#get_vouchers.voucher_code#</td>
								<td nowrap>
									<cfset status=get_vouchers.voucher_status_id>
									<cfswitch expression="#status#">
										<cfcase value="1"><font color="##003399"><cf_get_lang dictionary_id='50249.Portföyde'></font></cfcase>
										<cfcase value="2"><font color="##993366"><cf_get_lang dictionary_id='50250.Bankada'></font></cfcase>
										<cfcase value="3"><cf_get_lang dictionary_id='50251.Tahsil Edildi'></cfcase>
										<cfcase value="4"><font color="##339900"><cf_get_lang dictionary_id='50252.Ciro Edildi'></font></cfcase>
										<cfcase value="5"><font color="##FF0000"><cf_get_lang dictionary_id='50334.Protestolu'></font></cfcase>
										<cfcase value="6"><font color="##FF0000"><cf_get_lang dictionary_id='50254.Ödenmedi'></font></cfcase>
										<cfcase value="7"><font color="##006600"><cf_get_lang dictionary_id='50255.Ödendi'></font></cfcase>
										<cfcase value="8"><font color="##006600"><cf_get_lang dictionary_id='58506.İptal'></font></cfcase>
										<cfcase value="9"><font color="##006600"><cf_get_lang dictionary_id='29418.İade'></font></cfcase>
										<cfcase value="10"><font color="##FF0000"><cf_get_lang dictionary_id='50334.Protestolu'>-<cf_get_lang dictionary_id='50249.Portföyde'></font></cfcase>
										<cfcase value="11"><font color="##993300"><cf_get_lang dictionary_id='50364.Kısmi Tahsil'></font></cfcase>
										<cfcase value="12"><font color="##FF0000"><cf_get_lang dictionary_id='50363.İcra'></font></cfcase>
										<cfcase value="13"><font color="##993366"><cf_get_lang dictionary_id='50467.Teminatta'></font></cfcase>
										<cfcase value="14"><font color="##003399"><cf_get_lang dictionary_id='58568.transfer'></font></cfcase>
									</cfswitch>
								</td>
								<td>
									<cfif len(get_vouchers.voucher_account_id)>
										#get_vouchers.account_name#
								</cfif>
								</td>
								<td>
									<cfif len(ID)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_#LINK#_det&#LINK2#=#ID#','medium');" class="tableyazi">
											<cfif len(get_vouchers.fullname) gt 18>
												#left(get_vouchers.fullname,18)#...
											<cfelse>
												#get_vouchers.fullname#
										</cfif>
										</a>
									</cfif>
								</td>
								<td>#get_vouchers.debtor_name#</td>
								<cfif x_is_dsp_notes eq 1>
									<td>
										<cfif len(note_id)>
											<a href="javascript:" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#NOTE_ID#','small')" class="tableyazi">
												#left(note,50)#
										</a>
										</cfif>
									</td>
								</cfif>
								<cfif len(get_vouchers.other_money_value)>
									<cfif check_our_company.is_remaining_amount eq 1 and status neq 3 and len(get_vouchers.OTHER_REMAINING_VALUE)>
										<cfset sistem_toplam = sistem_toplam + get_vouchers.OTHER_REMAINING_VALUE>
									<cfelse>

										<cfset sistem_toplam = sistem_toplam + get_vouchers.other_money_value>
									</cfif>
								</cfif>
								<cfif len(get_vouchers.other_money_value2) and len(get_vouchers.OTHER_REMAINING_VALUE2)>
									<cfif check_our_company.is_remaining_amount eq 1 and status neq 3>
										<cfset sistem2_toplam = sistem2_toplam + get_vouchers.OTHER_REMAINING_VALUE2>
									<cfelse>
										<cfset sistem2_toplam = sistem2_toplam + get_vouchers.other_money_value2>
									</cfif>
								</cfif>
								<cfif len(get_vouchers.voucher_value)>
									<cfif check_our_company.is_remaining_amount eq 1 and status neq 3 and len(get_vouchers.REMAINING_VALUE)>
										<cfset 'toplam_#currency_id#' = evaluate('toplam_#currency_id#') +get_vouchers.REMAINING_VALUE>
									<cfelse>
										<cfif len(get_voucher_closed.closed_amount)>
											<cfset kalan_tutar = get_vouchers.voucher_value -get_voucher_closed.closed_amount>
										<cfelse>
											<cfset kalan_tutar =get_vouchers.voucher_value>
										</cfif>
										<cfset 'toplam_#currency_id#' = evaluate('toplam_#currency_id#') + kalan_tutar>
									</cfif>
								</cfif>
								<cfif len(get_vouchers.other_money_value)>
									<cfset 'toplam_ilk_#currency_id#' = evaluate('toplam_ilk_#currency_id#') +get_vouchers.voucher_value>
								</cfif>
								<cfif len(get_voucher_closed.closed_amount)>
									<cfset 'toplam_paid_#currency_id#' = evaluate('toplam_paid_#currency_id#') +get_voucher_closed.closed_amount>
								</cfif>
								<cfif x_show_partial_payments eq 1>
								<td>#dateformat(get_vouchers.voucher_duedate,dateformat_style)#</td>
								<td nowrap="nowrap" style="text-align:right;">
									<cfif get_vouchers.voucher_value gt 0>
									#TLFormat(get_vouchers.voucher_value,2)# #currency_id#
									<cfelse>
									#TlFormat(0,2)# #currency_id#
								</cfif>
								</td>
								<td nowrap="nowrap" style="text-align:right;">
									<cfif get_voucher_closed.closed_amount gt 0>
									#TlFormat(get_voucher_closed.closed_amount,2)# #currency_id#
									<cfelse>
									#TlFormat(0,2)# #currency_id#
								</cfif>
								</td>
								</cfif>
								<td style="text-align:right;">
									<cfif check_our_company.is_remaining_amount eq 1 and status neq 3>
										#TLFormat(get_vouchers.REMAINING_VALUE)# #get_vouchers.currency_id#
									<cfelse>
										<cfif len(get_voucher_closed.closed_amount)>
											<cfset kalan_tutar = get_vouchers.voucher_value -get_voucher_closed.closed_amount>
										<cfelse>
											<cfset kalan_tutar =get_vouchers.voucher_value>
										</cfif>
										#TLFormat(kalan_tutar)# #get_vouchers.currency_id#
								</cfif>
								</td>
								<td style="text-align:right;">
									<cfif check_our_company.is_remaining_amount eq 1 and status neq 3>
										#TLFormat(get_vouchers.OTHER_REMAINING_VALUE)# #get_vouchers.other_money#
									<cfelse>
										#TLFormat(get_vouchers.other_money_value)# #get_vouchers.other_money#
								</cfif>
								</td>
								<td style="text-align:right;">
									<cfif check_our_company.is_remaining_amount eq 1 and status neq 3>
										#TLFormat(get_vouchers.OTHER_REMAINING_VALUE2)# #get_vouchers.other_money2#
									<cfelse>
										<cfif len(get_vouchers.other_money_value2)>#TLFormat(get_vouchers.other_money_value2)# #get_vouchers.other_money2#</cfif>
									</cfif>
								</td>
								<td>#dateformat(get_vouchers.record_date,dateformat_style)#</td>
								<!-- sil -->
								<cfif (x_change_process_type eq 1 and isDefined("attributes.status") and (attributes.status eq '2,13' or attributes.status eq 2 or attributes.status eq 13)) or (x_change_process_type_unpaid eq 1 and isDefined("attributes.status") and attributes.status eq 6)>
									<td>
										<input type="checkbox" name="row_voucher" id="row_voucher" value="#voucher_id#;#currency_id#"><input type="hidden" name="row_date_#voucher_id#" id="row_date_#voucher_id#" value="#dateformat(max_act_date,dateformat_style)#">
									</td>
								</cfif>
								<td><cfif get_vouchers.voucher_status_id eq 1><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=cheque.popup_voucher_cash&draggable=1&voucher_id=#get_vouchers.voucher_id#');" class="tableyazi"><i class="fa fa-money" title="<cf_get_lang dictionary_id ='50277.senet tahsil işlemi'>"></i></a></cfif></td>
								<td>
									<cfif get_vouchers.voucher_status_id eq 6>
										<a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_vouchers.voucher_id#&action=cheque.list_vouchers','woc');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>"></i></a>
									</cfif>
								</td>
								<cfif session.ep.our_company_info.sms>
									<td align="center">
										<cfif voucher_status_id eq 1>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#MEMBER_TYPE#&member_id=#ID#&paper_id=#voucher_id#&paper_type=5&sms_action=#fuseaction#','small');"><i class="fa fa-mobile-phone" alt="<cf_get_lang dictionary_id='58590.SMS Gönder'>" title="<cf_get_lang dictionary_id='58590.SMS Gönder'>"></i></a>
										</cfif>
									</td>
								</cfif>
							<!-- sil -->
							</tr>
						</cfoutput>
						<tr class="total">
							<td class="txtbold" style="text-align:right;" <cfif x_is_dsp_notes eq 1>colspan="12"<cfelse>colspan="11"</cfif>><cf_get_lang dictionary_id='57492.Toplam'></td>
							<cfif x_show_partial_payments eq 1>
								<td class="txtbold" style="text-align:right;" nowrap="nowrap">
								<cfoutput query="get_money">
									<cfif evaluate('toplam_ilk_#money#') gt 0>
										#Tlformat(evaluate('toplam_ilk_#money#'))# #money#<br/>
									</cfif>
								</cfoutput>
								</td>
								<td class="txtbold" style="text-align:right;" nowrap="nowrap">
								<cfoutput query="get_money">
									<cfif evaluate('toplam_paid_#money#') gt 0>
										#Tlformat(evaluate('toplam_paid_#money#'))# #money#<br/>
									</cfif>
								</cfoutput>
								</td>
							</cfif>
							<td class="txtbold" style="text-align:right;" nowrap="nowrap">
								<cfoutput query="get_money">
									<cfif evaluate('toplam_#money#') gt 0>
										#Tlformat(evaluate('toplam_#money#'))# #money#<br/>
									</cfif>
								</cfoutput>
							</td>
							<td class="txtbold" style="text-align:right;" nowrap="nowrap"><cfoutput>#Tlformat(sistem_toplam)# #session.ep.money#</cfoutput></td>
							<td class="txtbold" style="text-align:right;" nowrap="nowrap"><cfoutput>#Tlformat(sistem2_toplam)# #session.ep.money2#</cfoutput></td>
							<td></td>
							<!-- sil -->
								<cfif x_change_process_type eq 1 or x_change_process_type_unpaid eq 1>
									<td></td>
								</cfif>
								<td></td>
								<td></td>
								<cfif session.ep.our_company_info.sms>
									<td></td>
								</cfif>
							<!-- sil -->
						</tr>
						<!-- sil -->
						<cfif x_change_process_type eq 1>
							<cfif isDefined("attributes.status") and (attributes.status eq '2,13' or attributes.status eq 2 or attributes.status eq 13)>
								<tr>
									<td colspan="21">
										<table style="text-align:right;">
											<tr>
												<td>
													<cf_get_lang dictionary_id='50251.Tahsil Edildi'><cf_get_lang dictionary_id='57800.İşlem Tipi'>
													<select name="process_type_info1" id="process_type_info1">
														<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfoutput query="get_user_process_info">
															<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
														</cfoutput>
													</select>
												</td>
												<td>
													<cf_get_lang dictionary_id='50334.Protestolu'><cf_get_lang dictionary_id='57800.İşlem Tipi'>
													<select name="process_type_info2" id="process_type_info2">
														<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfoutput query="get_user_process_info2">
															<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
														</cfoutput>
													</select>
												</td>
												<td>
													<cf_get_lang dictionary_id='57879.İşlem Tarihi'>
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem tarihi seçmelisiniz'>!</cfsavecontent>
													<input type="text" name="act_date" id="act_date" required="yes" message="#message#" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
													<cf_wrk_date_image date_field="act_date"> 
													<input type="button" name="tahsil" id="tahsil" value="<cf_get_lang dictionary_id='49774.Tahsil Edildi'>" onClick="update_vouchers(0);"> 
													<input type="button" name="protestolu" id="protestolu" value="Protestolu" onClick="update_vouchers(1);">
													<div id="user_message_demand"></div>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</cfif>
						</cfif>
						<cfif x_change_process_type_unpaid eq 1>
							<cfif isDefined("attributes.status") and attributes.status eq 6>
								<tr>
									<td colspan="21">
										<table style="text-align:right;">
											<tr>
												<td>
													<cf_get_lang dictionary_id='50255.Ödendi'><cf_get_lang dictionary_id='57800.İşlem Tipi'>
													<cf_workcube_process_cat process_type_info='#process_type_info3#' onclick_function="show_bank_info()">
												</td>
												<td id="show_bank" <cfif listfind(process_type_info3,1051)>style="display:none;"</cfif>>
													<div  id="bank_accounts_ajax_"></div>
												</td>
												<td>
													<cf_get_lang dictionary_id='57879.İşlem Tarihi'>
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem tarihi seçmelisiniz'>!</cfsavecontent>
													<input type="text" name="act_date" id="act_date" required="yes" message="#message#" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
													<cf_wrk_date_image date_field="act_date"> 
													<input type="button" name="payment" id="payment" value="<cf_get_lang dictionary_id='50255.Ödendi'>" onClick="update_vouchers(2);"> 
													<div id="user_message_demand"></div>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</cfif>
						</cfif>
						<!-- sil -->
					</form>
				<cfelse>
					<tr>
						<td <cfif x_is_dsp_notes eq 1>colspan="21"<cfelse>colspan="21"</cfif>><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_vouchers" >
		<cfif isDefined('attributes.status') and len(attributes.status)>
			<cfset adres = '#adres#&status=#attributes.status#'>
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isDefined('attributes.oby') and len(attributes.oby)>
			<cfset adres = '#adres#&oby=#attributes.oby#'>
		</cfif>
		<cfif isDefined('attributes.due_start_date') and len(attributes.due_start_date)>
			<cfset adres = '#adres#&due_start_date=#dateformat(attributes.due_start_date,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.due_finish_date') and len(attributes.due_finish_date)>
			<cfset adres = '#adres#&due_finish_date=#dateformat(attributes.due_finish_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
			<cfset adres = '#adres#&is_form_submitted=#attributes.is_form_submitted#'>
		</cfif>
		<cfif len(attributes.company_id) and len(attributes.company)>
			<cfset adres = '#adres#&company_id=#attributes.company_id#'>
		</cfif>
		<cfif len(attributes.consumer_id) and len(attributes.company)>
			<cfset adres = '#adres#&consumer_id=#attributes.consumer_id#'>
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.company)>
			<cfset adres = '#adres#&employee_id=#attributes.employee_id#'>
		</cfif>
		<cfif len(attributes.company)>
			<cfset adres = '#adres#&company=#attributes.company#'>
		</cfif>
		<cfif len(attributes.member_type)>
			<cfset adres = '#adres#&member_type=#attributes.member_type#'>
		</cfif>
		<cfif len(attributes.owner_company_id) and len(attributes.owner_company)>
			<cfset adres = '#adres#&owner_company_id=#attributes.owner_company_id#'>
		</cfif>
		<cfif len(attributes.owner_consumer_id) and len(attributes.owner_company)>
			<cfset adres = '#adres#&owner_consumer_id=#attributes.owner_consumer_id#'>
		</cfif>
		<cfif len(attributes.owner_employee_id) and len(attributes.owner_company)>
			<cfset adres = '#adres#&owner_employee_id=#attributes.owner_employee_id#'>
		</cfif>
		<cfif len(attributes.owner_company)>
			<cfset adres = '#adres#&owner_company=#attributes.owner_company#'>
		</cfif>
		<cfif len(attributes.owner_member_type)>
			<cfset adres = '#adres#&owner_member_type=#attributes.owner_member_type#'>
		</cfif>
		<cfif isdefined('attributes.account_id') and len(attributes.account_id)>
			<cfset adres = '#adres#&account_id=#attributes.account_id#'>
		</cfif>
		<cfif isdefined('attributes.cash') and len(attributes.cash)>
			<cfset adres = '#adres#&cash=#attributes.cash#'>
		</cfif>
		<cfif isdefined('attributes.debt_company') and len(attributes.debt_company)>
			<cfset adres = '#adres#&debt_company=#attributes.debt_company#'>
		</cfif>
		<cfif isdefined('attributes.money_type') and len(attributes.money_type)>
			<cfset adres = '#adres#&money_type=#attributes.money_type#'>
		</cfif>
		<cfif isdefined('attributes.paper_type') and len(attributes.paper_type)>
			<cfset adres = '#adres#&paper_type=#attributes.paper_type#'>
		</cfif>
		<cfif len(attributes.project_id)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
		</cfif>
		<cfif len(attributes.project_head)>
			<cfset adres = "#adres#&project_head=#attributes.project_head#">
		</cfif>
		<cfif isDefined('attributes.record_date1') and len(attributes.record_date1)>
			<cfset adres = '#adres#&record_date1=#dateformat(attributes.record_date1,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.record_date2') and len(attributes.record_date2)>
			<cfset adres = '#adres#&record_date2=#dateformat(attributes.record_date2,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.payroll_date1') and len(attributes.payroll_date1)>
			<cfset adres = '#adres#&payroll_date1=#dateformat(attributes.payroll_date1,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.payroll_date2') and len(attributes.payroll_date2)>
			<cfset adres = '#adres#&payroll_date2=#dateformat(attributes.payroll_date2,dateformat_style)#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function show_bank_info()
	{
		var is_selected=0;
		if(document.getElementsByName('row_voucher').length > 0)
		{
			var voucher_id_list_="";
			var voucher_currency_list="";
			if(document.getElementsByName('row_voucher').length ==1)
			{
				if(document.getElementById('row_voucher').checked==true){
					is_selected=1;
					voucher_id_list_+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';');
					voucher_currency_list+=list_getat(document.upd_all_vouchers.row_voucher.value,2,';');
				}
			}	
			else
			{
				for (i=0;i<document.getElementsByName('row_voucher').length;i++)
				{
					if(document.upd_all_vouchers.row_voucher[i].checked==true)
					{ 
						if(voucher_id_list_ != '')
						{
							voucher_id_list_+=','+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';');
							if(!list_find(voucher_currency_list,list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';'),','))
							{voucher_currency_list+=','+list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';');}
						}
						else
						{
							voucher_id_list_+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';');
							if(!list_find(voucher_currency_list,list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';'),','))
							{voucher_currency_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';');}
							is_selected=1;
						}
					}
				}		
			}
			if(voucher_id_list_ == '')
			{
				alert("<cf_get_lang dictionary_id="51773.İşlem Yapılacak Senetleri Seçiniz">");
				document.getElementById('process_cat').value = '';
				return false;
			}
			if(list_len(voucher_currency_list) > 1)
			{
				alert("<cf_get_lang dictionary_id="51776.Farklı Para Birimleri Olan Senetler Mevcut."> <cf_get_lang dictionary_id= "51779.Lütfen Aynı Para Birimli Senetleri Seçiniz!">");
				document.getElementById('process_cat').value = '';
				return false;
			}
		<cfif listfind(process_type_info3,1051)>
			var selected_ptype = document.upd_all_vouchers.process_cat.options[document.upd_all_vouchers.process_cat.selectedIndex].value;
			if(selected_ptype != '')
			{
				var proc_control = document.getElementById('ct_process_type_'+selected_ptype).value;
				if(proc_control == 1051)
				{
					show_bank.style.display = '';
				}
				else
					show_bank.style.display = 'none';
			}
			else
				show_bank.style.display = 'none';
		</cfif>
		bank_accounts_control(voucher_currency_list);
		}
	}
	function bank_accounts_control(list)
	{
		var list_ = list;
		var send_address = "<cfoutput>#request.self#?fuseaction=cheque.emptypopup_bank_accounts_ajax</cfoutput>&currency_id=";
		send_address += list;
		AjaxPageLoad(send_address,'bank_accounts_ajax_');
	}	
	
	function update_vouchers(type)
	{ 
		document.getElementById('type').value = type;
		if(type==0)
		{
			if(document.getElementById('process_type_info1').value == '')
				{
					alert("<cf_get_lang dictionary_id="51780.Lütfen Tahsil Edildi İşlem Tipi Seçiniz!">");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_voucher').length > 0)
				{
					var voucher_id_list="";
					var voucher_date_list="";
					if(document.getElementsByName('row_voucher').length ==1)
					{
						if(document.getElementById('row_voucher').checked==true){
							is_selected=1;
							voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';')+',';
							var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher.value,1,';')).value;
							voucher_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_voucher').length;i++)
						{
							if(document.upd_all_vouchers.row_voucher[i].checked==true)
							{ 
								voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')+',';
								var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')).value;
								voucher_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id="51807.Seçtiğiniz Senetlerin Bankadan Tahsil İşlemleri Gerçekleşecek.">. <cf_get_lang dictionary_id= "48488.Emin misiniz?">"))
						{
							var kontrol_process_date = voucher_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang dictionary_id='50208.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(voucher_id_list,',') > 1)
							{
								voucher_id_list = voucher_id_list.substr(0,voucher_id_list.length-1);	
								document.getElementById('voucher_id_list').value=voucher_id_list;
								user_message="<cf_get_lang dictionary_id='51708.İşlemler Yapılıyor Lütfen Bekleyiniz!'>";
								AjaxFormSubmit(upd_all_vouchers,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id="51773.İşlem Yapılacak Senetleri Seçiniz!">");
						return false;
					}
				}
			}
		}
		else if (type==1)
		{
			if(document.getElementById('process_type_info2').value == '')
				{
					alert("<cf_get_lang dictionary_id="51794.Lütfen Protestolu İşlem Tipi Seçiniz!">");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_voucher').length > 0)
				{
					var voucher_id_list="";
					var voucher_date_list="";
					if(document.getElementsByName('row_voucher').length ==1)
					{
						if(document.getElementById('row_voucher').checked==true){
							is_selected=1;
							voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';')+',';
							var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher.value,1,';')).value;
							voucher_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_voucher').length;i++)
						{
							if(document.upd_all_vouchers.row_voucher[i].checked==true)
							{ 
								voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')+',';
								var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')).value;
								voucher_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id="51796.Seçtiğiniz Senetlerin Protestolu İşlemleri Gerçekleşecek.">. <cf_get_lang dictionary_id= "48488.Emin misiniz?">"))
						{
							var kontrol_process_date = voucher_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang dictionary_id='50208.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(voucher_id_list,',') > 1)
							{
								voucher_id_list = voucher_id_list.substr(0,voucher_id_list.length-1);	
								document.getElementById('voucher_id_list').value=voucher_id_list;
								user_message="<cf_get_lang dictionary_id='51708.İşlemler Yapılıyor Lütfen Bekleyiniz!'>";
								AjaxFormSubmit(upd_all_vouchers,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id="51773.İşlem Yapılacak Senetleri Seçiniz!">");
						return false;
					}
				}
			}
		}
		else
		{
			if(document.getElementById('process_cat').value == '')
				{
					alert("<cf_get_lang dictionary_id="51732.Lütfen Ödendi İşlem Tipi Seçiniz!">");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_voucher').length > 0)
				{
					var voucher_id_list="";
					var voucher_date_list="";
					if(document.getElementsByName('row_voucher').length ==1)
					{
						if(document.getElementById('row_voucher').checked==true){
							is_selected=1;
							voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';')+',';
							var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher.value,1,';')).value;
							voucher_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_voucher').length;i++)
						{
							if(document.upd_all_vouchers.row_voucher[i].checked==true)
							{
								voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')+',';
								var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')).value;
								voucher_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						var selected_ptype = document.upd_all_vouchers.process_cat.options[document.upd_all_vouchers.process_cat.selectedIndex].value;
						if(selected_ptype != '')
						{
							var proc_control = document.getElementById('ct_process_type_'+selected_ptype).value;
							if(proc_control == 1051 && document.getElementById('from_account_id').value == '')
							{
								alert("<cf_get_lang dictionary_id="58205.Lütfen Banka Hesabı Seçiniz !">");
								return false;
							}
						}
						if(confirm('<cf_get_lang dictionary_id="51806.Seçtiğiniz Senetlerin Ödendi İşlemleri Gerçekleşecek.">. <cf_get_lang dictionary_id="48488.Emin misiniz?">'))
						{
							var kontrol_process_date = voucher_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang dictionary_id='50208.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(voucher_id_list,',') > 1)
							{
								voucher_id_list = voucher_id_list.substr(0,voucher_id_list.length-1);	
								document.getElementById('voucher_id_list').value=voucher_id_list;
								user_message="<cf_get_lang dictionary_id='51708.İşlemler Yapılıyor Lütfen Bekleyiniz'>";
								AjaxFormSubmit(upd_all_vouchers,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id="51773.İşlem Yapılacak Senetleri Seçiniz!">");
						return false;
					}
				}
			}
			return false;
		}
	}
</script>
<br/>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
