<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_cheques">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.payroll_date1" default="">
<cfparam name="attributes.payroll_date2" default="">
<cfparam name="attributes.oby" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.owner_company" default="">
<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.owner_company_id" default="">
<cfparam name="attributes.owner_consumer_id" default="">
<cfparam name="attributes.owner_employee_id" default="">
<cfparam name="attributes.owner_member_type" default="">
<cfparam name="attributes.debt_company" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.list_bank_name" default="">
<cfparam name="attributes.list_bank_branch_name" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.cash" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfscript>
	excelCheques = createobject("component","V16.cheque.cfc.cheque");
	excelCheques.dsn2 = dsn2;
	excelCheques.dsn = dsn;
	excelCheques.dsn_alias = dsn_alias;
	excelCheques.dsn3_alias = dsn3_alias;
	excelCheques.upload_folder = upload_folder;
</cfscript>
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
		SPC.PROCESS_TYPE =1043 AND
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
		SPC.PROCESS_TYPE =1046 AND
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
<cfquery name="get_user_process_info3" datasource="#dsn3#">
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
		SPC.PROCESS_TYPE =1044 AND
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
<cfinclude template="../query/get_money2.cfm">
<cfif isdefined("attributes.is_form_submitted")>
	<cfif len(attributes.start_date) and isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
	</cfif>
	<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
		<cf_date tarih = "attributes.record_date1">
	</cfif>
	<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
		<cf_date tarih = "attributes.record_date2">
	</cfif>
	<cfif len(attributes.payroll_date1) and isdate(attributes.payroll_date1)>
		<cf_date tarih = "attributes.payroll_date1">
	</cfif>
	<cfif len(attributes.payroll_date2) and isdate(attributes.payroll_date2)>
		<cf_date tarih = "attributes.payroll_date2">
	</cfif>
	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfscript>
			getChequeExcel = excelCheques.getChequeExcel(
				is_excel : attributes.is_excel,
				start_date : attributes.start_date,
				finish_date : attributes.finish_date,
				record_date1 : attributes.record_date1,
				record_date2 : attributes.record_date2,
				payroll_date1 : attributes.payroll_date1,
				payroll_date2 : attributes.payroll_date2,
				oby : attributes.oby,
				status : attributes.status,
				company : attributes.company,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				employee_id : attributes.employee_id,
				member_type : attributes.member_type,
				owner_company : attributes.owner_company,
				process_cat_id : attributes.process_cat_id,
				owner_company_id : attributes.owner_company_id,
				owner_consumer_id : attributes.owner_consumer_id,
				owner_employee_id : attributes.owner_employee_id,
				owner_member_type : attributes.owner_member_type,
				debt_company : attributes.debt_company,
				keyword : attributes.keyword,
				list_bank_name : attributes.list_bank_name,
				list_bank_branch_name : attributes.list_bank_branch_name,
				account_id : attributes.account_id,
				cash : attributes.cash,
				project_head : attributes.project_head,
				project_id : attributes.project_id,
				x_is_dsp_notes : x_is_dsp_notes,
				x_bordro_no : x_bordro_no,
				fuseaction : attributes.fuseaction,
				title_list : '#getLang('cheque',54)#,#getLang('cheque',55)#,#getLang('cheque',56)#,#getLang('cheque',57)#,#getLang('cheque',58)#,#getLang('cheque',59)#,#getLang('cheque',60)#,#getLang('main',1094)#,#getLang('main',1621)#,#getLang('cheque',58)#-#getLang('cheque',54)#,#getLang('cheque',168)#,#getLang('cheque',272)#,#getLang('main',1156)#'
			);
		</cfscript>
			<cfset get_cheques.recordcount = 0>
	<cfelse>
		<cfinclude template="../query/get_cheques.cfm">
	</cfif>
<cfelse>
	<cfset get_cheques.recordcount = 0>
</cfif>
<cfset sistem_toplam = 0>
<cfset sistem2_toplam = 0>
<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
</cfoutput>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_cheques.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_cheques" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cheques" method="post">
			<input type="hidden" value="1" name="is_form_submitted" id="is_form_submitted">
			<cf_box_search title="#getLang(2305,'Çek Listesi',30102)#"> 
				<div class="form-group">
					<cfinput type="text" name="keyword" style="width:100px;" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="money_type" id="money_type" style="width:85px;">
						<option value=""><cf_get_lang dictionary_id='57489.Para Birimi'></option>
						<cfoutput query="get_money">
							<option value="#money#" <cfif isdefined("attributes.money_type") and len(attributes.money_type) and money eq attributes.money_type>selected</cfif>>#money#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="oby" id="oby">
						<option value="1" <cfif (isDefined('attributes.oby') and attributes.oby eq 1) or (x_maturity_date eq 1)>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
						<option value="2" <cfif (isDefined('attributes.oby') and attributes.oby eq 2) or (x_maturity_date eq 0)>selected</cfif> ><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
						<option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif> ><cf_get_lang dictionary_id='29459.Artan No'></option>
						<option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif> ><cf_get_lang dictionary_id='29458.Azalan No'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' trail='0'> 
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' trail='0'>
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=cheque.popup_collected_print</cfoutput>','page');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='50339.Toplu Çek Yazdır'>" title="<cf_get_lang dictionary_id='50339.Toplu Çek Yazdır'>"></i></a>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>>
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='57858.Excel Getir'></span>
					</div>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-owner_company_id">
							<label class="col col-12"><cf_get_lang dictionary_id='58902.Çek Sahibi'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="owner_company_id" id="owner_company_id" <cfif len(attributes.owner_company) and len(attributes.owner_company_id)>value="<cfoutput>#attributes.owner_company_id#</cfoutput>"</cfif>>
									<input type="hidden" name="owner_consumer_id" id="owner_consumer_id" <cfif len(attributes.owner_company) and len(attributes.owner_consumer_id)>value="<cfoutput>#attributes.owner_consumer_id#</cfoutput>"</cfif>>
									<input type="hidden" name="owner_employee_id" id="owner_employee_id" <cfif len(attributes.owner_company) and len(attributes.owner_employee_id)>value="<cfoutput>#attributes.owner_employee_id#</cfoutput>"</cfif>>
									<input type="hidden" name="owner_member_type" id="owner_member_type" <cfif len(attributes.owner_company) and len(attributes.owner_member_type)>value="<cfoutput>#attributes.owner_member_type#</cfoutput>"</cfif>>
									<input name="owner_company" type="text" id="owner_company" style="width:200px;" onFocus="AutoComplete_Create('owner_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','owner_company_id,owner_consumer_id,owner_employee_id,owner_member_type','','3','250');" value="<cfif len(attributes.owner_company) ><cfoutput>#attributes.owner_company#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=1,2,3,9&field_comp_id=list_cheques.owner_company_id&field_member_name=list_cheques.owner_company&field_name=list_cheques.owner_company&field_consumer=list_cheques.owner_consumer_id&field_emp_id=list_cheques.owner_employee_id&field_type=list_cheques.owner_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company) and len(attributes.company_id)>value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
									<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company) and len(attributes.consumer_id)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
									<input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company) and len(attributes.employee_id)>value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
									<input type="hidden" name="member_type" id="member_type" <cfif len(attributes.company) and len(attributes.member_type)>value="<cfoutput>#attributes.member_type#</cfoutput>"</cfif>>
									<input name="company" type="text" id="company" style="width:200px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','250');" value="<cfif len(attributes.company) ><cfoutput>#URLDecode(company)#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=1,2,3,9&field_comp_id=list_cheques.company_id&field_member_name=list_cheques.company&field_name=list_cheques.company&field_consumer=list_cheques.consumer_id&field_emp_id=list_cheques.employee_id&field_type=list_cheques.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');" title="<cf_get_lang dictionary_id='58902.Çek Sahibi'>"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-account_id">
							<label class="col col-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
							<div class="col col-12">
								<cf_wrkBankAccounts width='200' selected_value='#attributes.account_id#' is_multiple="1" is_upd="1">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-project_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57521.Banka'></label>
							<div class="col col-12">
								<cfinput type="text" name="list_bank_name" style="width:140px;" value="#attributes.list_bank_name#" maxlength="255">
							</div>
						</div>
						<div class="form-group" id="item-debt_company">
							<label class="col col-12"><cf_get_lang dictionary_id='58180.Borçlu'></label>
							<div class="col col-12">
								<input type="text" maxlength="255" name="debt_company" id="debt_company" style="width:140px;" value="<cfif isDefined("attributes.debt_company")><cfoutput>#attributes.debt_company#</cfoutput></cfif>">
							</div>
						</div>
						<div class="form-group" id="item-cash">
							<label class="col col-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
							<div class="col col-12">
								<cf_wrk_Cash name="cash" value="#attributes.cash#" cash_status="1">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-project">
							<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
									<input type="text" name="project_head" id="project_head" style="width:110px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');" title="<cf_get_lang dictionary_id='58797.Proje Seiniz'>"></span>                       
								</div>
							</div>
						</div>
						<div class="form-group" id="item-list_bank_branch_name">
							<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-12">
								<cfinput type="text" name="list_bank_branch_name" style="width:140px;" value="#attributes.list_bank_branch_name#" maxlength="255">
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
							<div class="col col-12">
								<select name="status" id="status" multiple style="width:140px;height:50px;">
									<option value="1" <cfif isDefined("attributes.status") and listfind(attributes.status,'1',',')>selected</cfif>><cf_get_lang dictionary_id='50249.Portföyde'></option>
									<option value="2" <cfif isDefined("attributes.status") and listfind(attributes.status,'2',',')>selected</cfif>><cf_get_lang dictionary_id='50250.Bankada'></option>
									<option value="13" <cfif isDefined("attributes.status") and listfind(attributes.status,'13',',')>selected</cfif>><cf_get_lang dictionary_id='50467.Teminatta'></option>
									<option value="3" <cfif isDefined("attributes.status") and listfind(attributes.status,'3',',')>selected</cfif>><cf_get_lang dictionary_id='50251.Tahsil Edildi'></option>
									<option value="4" <cfif isDefined("attributes.status") and listfind(attributes.status,'4',',')>selected</cfif>><cf_get_lang dictionary_id='50252.Ciro Edildi'></option>
									<option value="5" <cfif isDefined("attributes.status") and listfind(attributes.status,'5',',')>selected</cfif>><cf_get_lang dictionary_id='50253.Karşılıksız'></option>
									<option value="6" <cfif isDefined("attributes.status") and listfind(attributes.status,'6',',')>selected</cfif>><cf_get_lang dictionary_id='50254.Ödenmedi'></option>
									<option value="7" <cfif isDefined("attributes.status") and listfind(attributes.status,'7',',')>selected</cfif>><cf_get_lang dictionary_id='50255.Ödendi'></option>
									<option value="8" <cfif isDefined("attributes.status") and listfind(attributes.status,'8',',')>selected</cfif>><cf_get_lang dictionary_id='58506.İptal'></option>
									<option value="9" <cfif isDefined("attributes.status") and listfind(attributes.status,'9',',')>selected</cfif>><cf_get_lang dictionary_id='29418.İade'></option>
									<option value="10" <cfif isDefined("attributes.status") and listfind(attributes.status,'10',',')>selected</cfif>><cf_get_lang dictionary_id='50253.Karşılıksız'>-<cf_get_lang dictionary_id='50249.Portföyde'></option>
									<option value="12" <cfif isDefined("attributes.status") and listfind(attributes.status,'12',',')>selected</cfif>><cf_get_lang dictionary_id='50363.İcra'></option>
									<option value="14" <cfif isDefined("attributes.status") and listfind(attributes.status,'14',',')>selected</cfif>><cf_get_lang dictionary_id='58568.Transfer'></option>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-record_date1">
							<label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" style="width:65px;" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="record_date1"></span>
									<span class="input-group-addon no-bg"></span>
									<cfinput validate="#validate_style#" type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" style="width:65px;" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-start_date">
							<label class="col col-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.başlama tarihi girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									<span class="input-group-addon no-bg"></span>
									<cfinput validate="#validate_style#" type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-payroll_date1">
							<label class="col col-12"><cf_get_lang dictionary_id='57521.Banka'><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="payroll_date1" value="#dateformat(attributes.payroll_date1,dateformat_style)#" style="width:65px;" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="payroll_date1"></span>
									<span class="input-group-addon no-bg"></span>
									<cfinput validate="#validate_style#" type="text" name="payroll_date2" value="#dateformat(attributes.payroll_date1,dateformat_style)#" style="width:65px;" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="payroll_date2"></span>
								</div>
							</div>
						</div>
					</div>
				<!---<cfif x_is_dsp_notes eq 1>colspan="17"<cfelse>colspan="16"</cfif>--->
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(2305,'Çek Listesi',30102)#" uidrop="1" hide_table_column="1">
		<cf_grid_list sort="#iif((isdefined("attributes.status") and attributes.status eq 2),0,1)#">
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='50206.Bordro No'></th>
					<th><cf_get_lang dictionary_id='57640.Vade'></th>
					<th><cf_get_lang dictionary_id='50220.Çek No'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57521.Banka'>/<cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
					<cfif x_is_dsp_notes eq 1>
						<th><cf_get_lang dictionary_id='57467.Not'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='50272.İşlem Para Br'></th>
					<th><cf_get_lang dictionary_id='57489.Para birimi'></th>
					<th><cf_get_lang dictionary_id='50263.Sistem Para Br'></th>
					<th><cf_get_lang dictionary_id='57489.Para birimi'></th>
					<th>2.<cf_get_lang dictionary_id='57677.Döviz'></th>
					<th><cf_get_lang dictionary_id='57489.Para birimi'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<!-- sil -->
					<th width="20"><cfif (x_change_process_type eq 1 and isDefined("attributes.status") and (attributes.status eq '2,13' or attributes.status eq 2 or attributes.status eq 13)) or (x_change_process_type_unpaid eq 1 and isDefined("attributes.status") and attributes.status eq 6)><input type="checkbox" name="all_select_cheque" id="all_select_cheque" onClick="wrk_select_all('all_select_cheque','row_cheque');"></cfif></th>
					<th width="20" class="text-center"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>"></i></th>
					<!-- sil -->
				</tr>
			</thead>
			<cfif attributes.page neq 1>
				<cfoutput query="get_cheques" startrow="1" maxrows="#attributes.startrow-1#">
					<cfif len(other_money_value)>
						<cfset sistem_toplam = sistem_toplam + other_money_value>
					</cfif>
					<cfif len(other_money_value2)>
						<cfset sistem2_toplam = sistem2_toplam + other_money_value2>
					</cfif>
					<cfif isdefined("cheque_value") and len(cheque_value)>
						<cfset 'toplam_#currency_id#' = evaluate('toplam_#currency_id#') +cheque_value>
					</cfif>
				</cfoutput>				  
			</cfif>
			<tbody>
				<cfif get_cheques.recordcount>
					<form name="upd_all_cheques" id="upd_all_cheques" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=cheque.emptypopup_upd_all_cheques">
						<input type="hidden" name="cheque_id_list" id="cheque_id_list" value="">
						<input type="hidden" name="cheque_act_date_list" id="cheque_id_list" value="">
						<input type="hidden" name="type" id="type" value="">
						<cfoutput query="get_cheques" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>#get_cheques.currentrow#</td>
								<td>
									<cfif get_cheques.payroll_no eq -1>
										<cf_get_lang dictionary_id='141.Açılış'>
									<cfelseif get_cheques.payroll_no eq -2>
										-
									<cfelse>
										<cfswitch expression="#payroll_type#">
											<cfcase value="90">
												<!--- <cfset act="Çek Giriş Bordrosu"> --->
												<cfset Xurl="form_add_payroll_entry&event=upd">
											</cfcase>
											<cfcase value="91">
												<!--- <cfset act="Çek Çıkış Bordrosu-Ciro"> --->
												<cfset Xurl="form_add_payroll_endorsement&event=upd">
											</cfcase>
											<cfcase value="92">
												<!--- <cfset act="Çek Çıkış Bordrosu-Tahsil"> --->
												<cfset Xurl="form_add_payroll_bank_revenue&event=upd">
											</cfcase>
											<cfcase value="93">
												<!--- <cfset act="Çek Çıkış Bordrosu-Banka"> --->
												<cfset Xurl="form_add_payroll_bank_guaranty&event=upd">
											</cfcase>
											<cfcase value="133">
												<!--- <cfset act="Çek Çıkış Bordrosu-Banka Teminat"> --->
												<cfset Xurl="form_add_payroll_bank_guaranty_tem&event=upd">
											</cfcase>
											<cfcase value="94">
												<!--- <cfset act="Çek İade Çıkış Bordrosu"> --->
												<cfset Xurl="form_add_payroll_endor_return&event=upd">
											</cfcase>
											<cfcase value="95">
												<!--- <cfset act="Çek İade Giriş Bordrosu"> --->
												<cfset Xurl="form_add_payroll_entry_return&event=upd">
											</cfcase>
											<cfcase value="105">
												<!--- <cfset act="Çek İade Giriş Bordrosu-Banka"> --->
												<cfset Xurl="form_add_payroll_bank_guaranty_return&event=upd">
											</cfcase>
											<cfcase value="134">
												<!--- <cfset act="Çek Transfer işlemi(çıkış)"> --->
												<cfset Xurl="form_add_cheque_transfer&event=upd">
											</cfcase>
											<cfcase value="135">
												<!--- <cfset act="Çek Transfer işlemi(giriş)"> --->
												<cfset Xurl="form_add_cheque_transfer&event=upd">
											</cfcase>
											<cfcase value="106">
												<!--- <cfset act=""> --->
												<cfset Xurl="">
											</cfcase>
											<cfdefaultcase>
												<!--- <cfset act=""> --->
												<cfset Xurl="">
											</cfdefaultcase>
										</cfswitch>
										<cfif (payroll_type eq 90 and process_cat eq 0)>
											#get_cheques.payroll_no#
										<cfelse>
											<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#Xurl#&ID=#ACTION_ID#" class="tableyazi">#get_cheques.payroll_no#
										</cfif>
									</cfif>
									<cfif x_bordro_no eq 1><cfif len(get_cheques.cheque_code)>-#get_cheques.cheque_code#</cfif></cfif>
								</td>
								<td>
									#dateformat(get_cheques.cheque_duedate,dateformat_style)#
								</td>
								<td>
									<cfif get_cheques.payroll_no eq -2>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_self_cheque_list&ID=#GET_CHEQUES.CHEQUE_ID#','medium');" class="tableyazi">#get_cheques.CHEQUE_NO#</a>
									<cfelse>	
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cheques&event=det&ID=#GET_CHEQUES.CHEQUE_ID#');">#get_cheques.CHEQUE_NO#</a>									</cfif>
								</td>
								<td nowrap>
									<cfset status = get_cheques.cheque_status_id>
									<cfswitch expression="#status#">
										<cfcase value="1"><font color="##003399"><cf_get_lang dictionary_id='50249.Portföyde'></font></cfcase>
										<cfcase value="2"><font color="##993366"><cf_get_lang dictionary_id='50250.Bankada'></font></cfcase>
										<cfcase value="13"><font color="##993366"><cf_get_lang dictionary_id='50467.Teminatta'></font></cfcase>
										<cfcase value="3"><cf_get_lang dictionary_id='50251.Tahsil Edildi'></cfcase>
										<cfcase value="4"><font color="##339900"><cf_get_lang dictionary_id='50252.Ciro Edildi'></font></cfcase>
										<cfcase value="5"><font color="##FF0000"><cf_get_lang dictionary_id='50253.Karşılıksız'></font></cfcase>
										<cfcase value="6"><font color="##FF0000"><cf_get_lang dictionary_id='50254.Ödenmedi'></font></cfcase>
										<cfcase value="7"><font color="##006600"><cf_get_lang dictionary_id='50255.Ödendi'></font></cfcase>
										<cfcase value="8"><font color="##006600"><cf_get_lang dictionary_id='58506.İptal'></font></cfcase>
										<cfcase value="9"><font color="##006600"><cf_get_lang dictionary_id='29418.İade'></font></cfcase>
										<cfcase value="10"><font color="##FF0000"><cf_get_lang dictionary_id='50253.Karşılıksız'>-<cf_get_lang dictionary_id='50249.Portföyde'></font></cfcase>
										<cfcase value="12"><font color="##FF0000"><cf_get_lang dictionary_id='50363.İcra'></font></cfcase>
										<cfcase value="14"><font color="##003399"><cf_get_lang dictionary_id='58568.transfer'></font></cfcase>
									</cfswitch>
								</td>
								<td>
									<cfif len(get_cheques.bank_name)>
										#get_cheques.bank_name# #get_cheques.bank_branch_name#
									</cfif>
								</td>
								<td>
									<cfif len(get_cheques.cheque_account_id)>
										#get_cheques.account_name#&nbsp;#get_cheques.account_currency_id#
									</cfif>
								</td>
								<td>
									<cfif len(get_cheques.cheque_payroll_id)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_#LINK#_det&#LINK2#=#ID#','medium');" class="tableyazi">
												#get_cheques.FULLNAME#       
										</a>	
									</cfif>
								</td>
								<td>
										#get_cheques.debtor_name#
								</td>
								<cfif x_is_dsp_notes eq 1>
								<td>
									<cfif len(note_id)>
										<a href="javascript:" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#NOTE_ID#','small')" class="tableyazi">
											#left(NOTE_BODY,50)#
										</a>
									</cfif>
								</td>
								</cfif>
								<td style="text-align:right;">#TLFormat(get_cheques.cheque_value)#</td>
								<td style="text-align:left;">#get_cheques.currency_id#</td>
								<cfif len(get_cheques.other_money_value)>
									<cfset sistem_toplam = sistem_toplam + get_cheques.other_money_value>
								</cfif>
								<cfif len(get_cheques.other_money_value2)>
									<cfset sistem2_toplam = sistem2_toplam + get_cheques.other_money_value2>
								</cfif>
								<cfif isdefined("get_cheques.cheque_value") and len(get_cheques.cheque_value)>
									<cfset 'toplam_#currency_id#' = evaluate('toplam_#currency_id#') +get_cheques.cheque_value>
								</cfif>
								<td style="text-align:right;">#TLFormat(get_cheques.other_money_value)#</td>
								<td style="text-align:left;">#get_cheques.other_money#</td>
								<td style="text-align:right;"><cfif len(get_cheques.other_money_value2)>#TLFormat(get_cheques.other_money_value2)#</cfif></td>
								<td style="text-align:left;"><cfif len(get_cheques.other_money2)>#get_cheques.other_money2#</cfif></td>
								<td>#dateformat(record_date,dateformat_style)#</td>
								<!-- sil -->
								<td width="15"><cfif (x_change_process_type eq 1 and isDefined("attributes.status") and (attributes.status eq '2,13' or attributes.status eq 2 or attributes.status eq 13)) or (x_change_process_type_unpaid eq 1 and isDefined("attributes.status") and attributes.status eq 6)><input type="checkbox" name="row_cheque" id="row_cheque" value="#cheque_id#"><input type="hidden" name="row_date_#cheque_id#" id="row_date_#cheque_id#" value="#dateformat(max_act_date,dateformat_style)#"></cfif></td>
								<td align="center"><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_cheques.cheque_id#&print_type=110','print_page');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>"></i></a></td>
									<!-- sil -->
							<!--- 	<cfif session.ep.our_company_info.sms>
									<td style="text-align:center;">
										<cfif cheque_status_id eq 1>
											<cfif len(GET_CHEQUES.ID)>
												<a href="javascript://" title="<cf_get_lang dictionary_id='58590.SMS Gönder'>" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#GET_CHEQUES.MEMBER_TYPE#&member_id=#GET_CHEQUES.ID#&paper_id=#get_cheques.cheque_id#&paper_type=4&sms_action=#fuseaction#','small');"><i class="fa fa-mobile-phone"></i></a>
											</cfif>
										</cfif>
									</td>
								</cfif> --->
								
							</tr>
						</cfoutput>
						<tfoot>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<cfif x_is_dsp_notes eq 1><td></td></cfif>
								<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								<td class="txtbold" style="text-align:right;" nowrap="nowrap">
									<cfoutput query="get_money">
										<cfif evaluate('toplam_#money#') gt 0>
											#Tlformat(evaluate('toplam_#money#'))#<br/>
										</cfif>
									</cfoutput>
								</td>
								<td class="txtbold" style="text-align:left;" nowrap="nowrap">
									<cfoutput query="get_money">
										<cfif evaluate('toplam_#money#') gt 0>
											#money#<br/>
										</cfif>
									</cfoutput>
								</td>
								<td class="txtbold" style="text-align:right;" nowrap="nowrap"><cfoutput>#Tlformat(sistem_toplam)#</cfoutput></td>
								<td class="txtbold" style="text-align:left;" nowrap="nowrap"><cfoutput>#session.ep.money#</cfoutput></td>
								<td class="txtbold" style="text-align:right;" nowrap="nowrap"><cfoutput>#Tlformat(sistem2_toplam)#</cfoutput></td>
								<td class="txtbold" style="text-align:left;" nowrap="nowrap"><cfoutput>#session.ep.money2#</cfoutput></td>
								<td></td>
								<!-- sil -->
								<td></td>
								<td></td>
								<cfif session.ep.our_company_info.sms>							
								</cfif>
								<!-- sil -->
							</tr>
							
						</tfoot>
						<!-- sil -->
						<cfif x_change_process_type eq 1>
							<cfif isDefined("attributes.status") and (attributes.status eq '2,13' or attributes.status eq 2 or attributes.status eq 13)>
							<tr class="nohover">
								<td colspan="17">
									<div class="nohover_div">
										<table style="text-align:right;">
											<tr>
												<td>
													<cf_get_lang dictionary_id='50251.Tahsil Edildi'><cf_get_lang dictionary_id='57800.İşlem Tipi'>
													<select name="process_type_info1" id="process_type_info1" style="width:160px;">
														<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfoutput query="get_user_process_info">
															<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
														</cfoutput>
													</select>
												</td>
												<td>
													<cf_get_lang dictionary_id='50253.Karşılıksız'><cf_get_lang dictionary_id='57800.İşlem Tipi'>
													<select name="process_type_info2" id="process_type_info2" style="width:160px;">
														<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfoutput query="get_user_process_info2">
															<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
														</cfoutput>
													</select>
												</td>
												<td>
													<cf_get_lang dictionary_id='57879.İşlem Tarihi'>
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem tarihi seçmelisiniz'>!</cfsavecontent>
													<input type="text" name="act_date" id="act_date" required="yes"  style="width:65px"  message="#message#" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
													<cf_wrk_date_image date_field="act_date"> 
													<input type="button" name="tahsil" id="tahsil" value="<cf_get_lang dictionary_id='49774.Tahsil Edildi'>" onClick="update_cheques(0);"> 
													<input type="button" name="karsiliksiz" id="karsiliksiz" value="<cf_get_lang dictionary_id='49810.Karşılıksız'>" onClick="update_cheques(1);">
													<div id="user_message_demand"></div>
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
							</cfif>
						</cfif>
						<cfif x_change_process_type_unpaid eq 1>
							<cfif isDefined("attributes.status") and attributes.status eq 6>
								<tr>
									<td colspan="18" class="nohover">
										<div class="nohover_div">
											<table style="text-align:right;">
												<tr>
													<td>
														<cf_get_lang dictionary_id='50255.Ödendi'><cf_get_lang dictionary_id='57800.İşlem Tipi'>
														<select name="process_type_info3" id="process_type_info3" style="width:160px;">
															<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
															<cfoutput query="get_user_process_info3">
																<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
															</cfoutput>
														</select>
													</td>
													<td>
														<cf_get_lang dictionary_id='57879.İşlem Tarihi'>
														<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem tarihi seçmelisiniz'>!</cfsavecontent>
														<input type="text" name="act_date" id="act_date" required="yes"  style="width:65px"  message="#message#" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
														<cf_wrk_date_image date_field="act_date"> 
														<input type="button" name="payment" id="payment" value="<cf_get_lang dictionary_id='50255.Ödendi'>" onClick="update_cheques(2);"> 
														<div id="user_message_demand"></div>
													</td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
							</cfif>
						</cfif>
						<!-- sil -->
					</form>
				<cfelse>
					<tr>
						<td colspan="20"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_cheques">
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isDefined('attributes.list_bank_name') and len(attributes.list_bank_name)>
			<cfset adres = '#adres#&list_bank_name=#attributes.list_bank_name#'>
		</cfif>
		<cfif isDefined('attributes.list_bank_branch_name') and len(attributes.list_bank_branch_name)>
			<cfset adres = '#adres#&list_bank_branch_name=#attributes.list_bank_branch_name#'>
		</cfif>
		<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
			<cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
			<cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
		</cfif>
		<cfif isDefined('attributes.oby') and len(attributes.oby)>
			<cfset adres = '#adres#&oby=#attributes.oby#'>
		</cfif>	
		<cfif isDefined('attributes.status') and len(attributes.status)>
			<cfset adres = '#adres#&status=#attributes.status#'>
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
		<cfif isdefined('attributes.money_type') and len(attributes.money_type)>
			<cfset adres = '#adres#&money_type=#attributes.money_type#'>
		</cfif>
		<cfif isdefined('attributes.account_id') and len(attributes.account_id)>
			<cfset adres = '#adres#&account_id=#attributes.account_id#'>
		</cfif>
		<cfif isdefined('attributes.cash') and len(attributes.cash)>
			<cfset adres = '#adres#&cash=#attributes.cash#'>
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
		<cfif isdefined('attributes.debt_company') and len(attributes.debt_company)>
			<cfset adres = '#adres#&debt_company=#attributes.debt_company#'>
		</cfif>
		<cfif len(attributes.project_id)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
		</cfif>
		<cfif len(attributes.project_head)>
			<cfset adres = "#adres#&project_head=#attributes.project_head#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#&is_form_submitted=1">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function update_cheques(type)
	{
		document.getElementById('type').value = type;
		if(type==0)
		{
			if(document.getElementById('process_type_info1').value == '')
				{
					alert("<cf_get_lang dictionary_id="51701.Lütfen Tahsil Edildi İşlem Tipi Seçiniz!">");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_cheque').length > 0)
				{
					var cheque_id_list="";
					var cheque_date_list="";
					if(document.getElementsByName('row_cheque').length ==1)
					{
						if(document.getElementById('row_cheque').checked==true){
							is_selected=1;
							cheque_id_list+=document.upd_all_cheques.row_cheque.value+',';
							var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque.value).value;
							cheque_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_cheque').length;i++)
						{
							if(document.upd_all_cheques.row_cheque[i].checked==true)
							{ 
								cheque_id_list+=document.upd_all_cheques.row_cheque[i].value+',';
								var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque[i].value).value;
								cheque_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id="51702.Seçtiğiniz Çeklerin Bankadan Tahsil İşlemleri Gerçekleşecek">.<cf_get_lang dictionary_id="48488.Emin misiniz?">"))
						{
							var kontrol_process_date = cheque_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang dictionary_id='50207.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(cheque_id_list , ',') > 1)
							{
								cheque_id_list = cheque_id_list.substr(0,cheque_id_list.length-1);	
								document.getElementById('cheque_id_list').value=cheque_id_list;
								//listelenen kayıt sayısı kadar oluşan row_date inputları kayıt sayısı fazla olunca request filtresinden geçemiyordu. Query tarafında kullanılmadığından form post edilmeden önce kaynaktan siliniyor.
								$("input[name^='row_date']").remove();
								user_message="<cf_get_lang dictionary_id='51708.İşlemler Yapılıyor Lütfen Bekleyiniz!'>";
								AjaxFormSubmit(upd_all_cheques,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id="51713.İşlem Yapılacak Çekleri Seçiniz!">");
						return false;
					}
				}
			}
		}
		else if(type==1)
		{
			if(document.getElementById('process_type_info2').value == '')
				{
					alert("<cf_get_lang dictionary_id="51714.Lütfen Karşılıksız İşlem Tipi Seçiniz!">");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_cheque').length > 0)
				{
					var cheque_id_list="";
					var cheque_date_list="";
					if(document.getElementsByName('row_cheque').length ==1)
					{
						if(document.getElementById('row_cheque').checked==true){
							is_selected=1;
							cheque_id_list+=document.upd_all_cheques.row_cheque.value+',';
							var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque.value).value;
							cheque_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_cheque').length;i++)
						{
							if(document.upd_all_cheques.row_cheque[i].checked==true)
							{ 
								cheque_id_list+=document.upd_all_cheques.row_cheque[i].value+',';
								var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque[i].value).value;
								cheque_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id="51715.Seçtiğiniz Çeklerin Karşılıksız İşlemleri Gerçekleşecek">.<cf_get_lang dictionary_id="48488.Emin misiniz?">"))
						{
							var kontrol_process_date = cheque_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang dictionary_id='50207.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(cheque_id_list,',') > 1)
							{
								cheque_id_list = cheque_id_list.substr(0,cheque_id_list.length-1);	
								document.getElementById('cheque_id_list').value=cheque_id_list;
								user_message='İşlemler Yapılıyor Lütfen Bekleyiniz!';
								$("input[name^='row_date']").remove();
								AjaxFormSubmit(upd_all_cheques,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id="51713.İşlem Yapılacak Çekleri Seçiniz!">");
						return false;
					}
				}
			}
		}
		else
		{
			if(document.getElementById('process_type_info3').value == '')
			{
				alert("<cf_get_lang dictionary_id="51732.Lütfen Ödendi İşlem Tipi Seçiniz!">");
				return false;
			}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_cheque').length > 0)
				{
					var cheque_id_list="";
					var cheque_date_list="";
					if(document.getElementsByName('row_cheque').length ==1)
					{
						if(document.getElementById('row_cheque').checked==true){
							is_selected=1;
							cheque_id_list+=document.upd_all_cheques.row_cheque.value+',';
							var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque.value).value;
							cheque_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_cheque').length;i++)
						{
							if(document.upd_all_cheques.row_cheque[i].checked==true)
							{ 
								cheque_id_list+=document.upd_all_cheques.row_cheque[i].value+',';
								var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque[i].value).value;
								cheque_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id="51731.Seçtiğiniz Çeklerin Ödendi İşlemleri Gerçekleşecek">.<cf_get_lang dictionary_id="48488.Emin misiniz?">"))
						{
							var kontrol_process_date = cheque_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang dictionary_id='50207.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(cheque_id_list,',') > 1)
							{
								cheque_id_list = cheque_id_list.substr(0,cheque_id_list.length-1);	
								document.getElementById('cheque_id_list').value=cheque_id_list;
								user_message="<cf_get_lang dictionary_id="51708.İşlemler Yapılıyor Lütfen Bekleyiniz!">";
								$("input[name^='row_date']").remove();
								AjaxFormSubmit(upd_all_cheques,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id ="51713.İşlem Yapılacak Çekleri Seçiniz!">");
						return false;
					}
				}
			}
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
