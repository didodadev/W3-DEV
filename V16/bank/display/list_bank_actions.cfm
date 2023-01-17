<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
	<cf_xml_page_edit fuseact="bank.list_bank_actions">
	<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions">
	<cfif isDefined('attributes.date1') and isdate(attributes.date1)>
		<cfset adres = '#adres#&date1=#attributes.date1#'>
	</cfif>
	<cfif isDefined('attributes.date2') and isdate(attributes.date2)>
		<cfset adres = '#adres#&date2=#attributes.date2#'>
	</cfif>
	<cfif isDefined('attributes.page_action_type')>
		<cfset adres = '#adres#&page_action_type=#attributes.page_action_type#'>
	</cfif>
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		<cfset adres = '#adres#&keyword=#attributes.keyword#'>
	</cfif>
	<cfif isDefined('attributes.paper_number') and len(attributes.paper_number)>
		<cfset adres = '#adres#&paper_number=#attributes.paper_number#'>
	</cfif>
	<cfif isDefined('attributes.account')>
		<cfset adres = '#adres#&account=#attributes.account#'>
	</cfif>
	<cfif isDefined('attributes.oby') and len(attributes.oby)>
		<cfset adres = '#adres#&oby=#attributes.oby#'>
	</cfif>
	<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
		<cfset adres = adres&"&is_form_submitted=1">
	</cfif>
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih = "attributes.date1">
	<cfelse>	
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.date1 = ''>
		<cfelse>
			<cfset attributes.date1 = date_add('d',-7,wrk_get_today())>
		</cfif>
	</cfif>
	
	<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
		<cf_date tarih = "attributes.date2">
	<cfelse>	
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.date2 = ''>
		<cfelse>
			<cfset attributes.date2 = #date_add('d',7,attributes.date1)#>
		</cfif>
	</cfif>
	<cfparam name="attributes.search_id" default="">
	<cfparam name="attributes.search_name" default="">
	<cfparam name="attributes.search_type" default="">
	<cfparam name="attributes.emp_type" default="">
	<cfparam name="attributes.emp_name" default="">
	<cfparam name="attributes.emp_id" default="">
	<cfparam name="attributes.record_emp_id" default="">
	<cfparam name="attributes.record_emp_name" default="">
	<cfparam name="attributes.record_date" default="">
	<cfparam name="attributes.record_date2" default="">
	<cfparam name="attributes.oby" default="2">
	<cfparam name="attributes.special_definition_id" default="">
	<cfparam name="bakiye" default="0">
	<cfparam name="bakiye_" default="0">
	<cfparam name="masraf_" default="0">
	<cfparam name="attributes.action_bank" default="2">
	<cfparam name="attributes.project_head" default="">
	<cfparam name="attributes.project_id" default="">
	<cfparam name="attributes.is_excel" default="">

	<cfset type = "">
	<cfinclude template="../query/get_money_rate.cfm">
	<cfif isdefined("attributes.is_form_submitted")>
		<cfinclude template="../query/get_actions.cfm">
		<cfset arama_yapilmali = 0>
	<cfelse>
		<cfset get_actions.recordcount = 0>
		<cfset arama_yapilmali = 1>
	</cfif>
	<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
		SELECT
			ACCOUNT_ID,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNT_CURRENCY_ID,
		</cfif>
			ACCOUNT_NAME
		FROM
			ACCOUNTS
		WHERE
			ACCOUNT_STATUS = 1
		<cfif session.ep.isBranchAuthorization>
			AND ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
		</cfif>
		ORDER BY
			ACCOUNT_NAME
	</cfquery>
	<cfquery name="get_branchs" datasource="#dsn#">
		SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH 
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				AND BRANCH_STATUS = 1
		<cfif session.ep.isBranchAuthorization>
				AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
		ORDER BY BRANCH_NAME
	</cfquery>
	<cfif isdefined("attributes.account") and len(attributes.account) and attributes.oby eq 2 and len(attributes.date1)>
		<cfquery name="get_sum_borc1" datasource="#dsn2#">
			SELECT 
				SUM(ROUND(ACTION_VALUE,2)) TOPLAM,
				SUM(ROUND(SYSTEM_ACTION_VALUE,2)) TOPLAM2,
				ACTION_TO_ACCOUNT_ID,
				SUM(ROUND(MASRAF,2)) AS MASRAF
			FROM
				BANK_ACTIONS
			WHERE
				ACTION_ID IS NOT NULL AND
				ACTION_TO_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account#">
			<cfif len(attributes.date1)>
				AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
			</cfif>	
			GROUP BY
				ACTION_TO_ACCOUNT_ID	
		</cfquery>
		<cfquery name="SUM_ACCOUNT_BORC" dbtype="query">
			SELECT SUM(TOPLAM) AS TOPLAM,SUM(TOPLAM2) AS TOPLAM2, SUM(MASRAF) AS MASRAF FROM get_sum_borc1 GROUP BY ACTION_TO_ACCOUNT_ID
		</cfquery>
		<cfquery name="SUM_ACCOUNT_ALACAK" datasource="#DSN2#">
			SELECT 
				SUM(ROUND(ACTION_VALUE,2)) TOPLAM,
				SUM(ROUND(SYSTEM_ACTION_VALUE,2)) TOPLAM2
			FROM
				BANK_ACTIONS
			WHERE
				ACTION_ID IS NOT NULL AND
				ACTION_FROM_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account#">
			<cfif len(attributes.date1)>
				AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
			</cfif>
		</cfquery>
		<cfquery name="get_account_money" datasource="#dsn3#">
			SELECT ACCOUNT_CURRENCY_ID FROM ACCOUNTS WHERE ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account#">
		</cfquery>
		<cfif len(SUM_ACCOUNT_BORC.TOPLAM)>
			<cfset bakiye = bakiye + SUM_ACCOUNT_BORC.TOPLAM - SUM_ACCOUNT_BORC.MASRAF>
			<cfset bakiye_ = bakiye_ + SUM_ACCOUNT_BORC.TOPLAM2>
		</cfif>
		<cfif len(SUM_ACCOUNT_ALACAK.TOPLAM)>
			<cfset bakiye = bakiye - SUM_ACCOUNT_ALACAK.TOPLAM>
			<cfset bakiye_ = bakiye_ - SUM_ACCOUNT_ALACAK.TOPLAM2> <!---(bakiye_): tl karşılığı checkboxına ve dövizli hesaba bağlı gelen bakiye-tl kolonu için hesaplamalarda kullanıldı. --->
		</cfif>
	</cfif>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.paper_number" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset cat_list = '20,21,22,23,2311,2313,24,25,230,240,253,26,27,104,105,120,121,243,247,244,248,291,292,293,294,254'>
	<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
		SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#cat_list#) ORDER BY PROCESS_TYPE
	</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="bank_list" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions" method="post">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1"/>
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
				</div>
				<div class="form-group">
					<cfinput maxlength="50" type="text" name="paper_number" id="paper_number" value="#attributes.paper_number#" placeholder="#getLang('main',468)#">
				</div>
				<div class="form-group">
					<select name="oby" id="oby">
						<option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
						<option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
						<option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
						<option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="account_status" id="account_status" >
						<option value=""><cf_get_lang dictionary_id='38857.Hesap Türü'></option>
						<option value="1"<cfif isDefined("attributes.account_status") and (attributes.account_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='59009.Aktif Hesap'></option>
						<option value="0"<cfif isDefined("attributes.account_status") and (attributes.account_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='49082.Pasif Hesap'></option>
					</select>
				</div>
				<div class="form-group">
					<label><input type="checkbox" name="is_money" id="is_money" <cfif isdefined("attributes.is_money")>checked</cfif>> <cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='42004.Karşılığı'> </label>
				</div>
				<div class="form-group">
					<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>
			</cf_box_search>
			<cfparam name="attributes.totalrecords" default='#get_actions.recordcount#'>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfif isdefined("attributes.action_type")>
				<cfset kontrol_ = 0>
			<cfelse>
				<cfset kontrol_ = 2>
			</cfif>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif x_select_type_info>
						<div class="form-group" id="item-special_definition_id">
							<label><cfoutput>#getLang('main',433)#/#getLang('main',1516)#</cfoutput></label>
							<cf_wrk_special_definition width_info="145" list_filter_info="1" field_id="special_definition_id" selected_value='#attributes.special_definition_id#'>
						</div>
					</cfif>
					<div class="form-group" id="item-project_id">
						<label><cf_get_lang dictionary_id='57416.Proje'></label>
						<div>
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
								<input type="text" name="project_head" id="project_head" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-emp_type">
						<label><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="input-group">
							<input type="hidden" name="emp_type" id="emp_type" value="<cfif len(attributes.emp_type)><cfoutput>#attributes.emp_type#</cfoutput></cfif>">
							<input type="hidden" name="emp_id" id="emp_id" value="<cfif len(attributes.emp_id)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
							<input type="hidden" name="search_type" id="search_type" value="<cfif len(attributes.search_type)><cfoutput>#attributes.search_type#</cfoutput></cfif>">
							<input type="hidden" name="search_id" id="search_id"  value="<cfif len(attributes.search_id)><cfoutput>#attributes.search_id#</cfoutput></cfif>">
							<input type="text" name="emp_name" id="emp_name"  onClick="hesap_sec();" value="<cfif len(attributes.emp_name)><cfoutput>#attributes.emp_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','MEMBER_TYPE,EMPLOYEE_ID,MEMBER_ID','search_type,emp_id,search_id','','3','135');">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_name=bank_list.emp_name&field_comp_id=bank_list.search_id&field_emp_id=bank_list.emp_id&field_type=bank_list.search_type&field_consumer=bank_list.search_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9,2,3','list');return false"></span>
						</div>
					</div>
					<div class="form-group" id="item-record_emp_id">
						<label><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="input-group">
							<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
							<input name="record_emp_name" type="text" id="record_emp_name" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','bank_list','3','125');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput> </cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=bank_list.record_emp_name&field_emp_id=bank_list.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-action_bank">
						<label><cf_get_lang dictionary_id='57554.Giriş'>/<cf_get_lang dictionary_id='57431.Çıkış'></label>
						<select name="action_bank" id="action_bank" >
							<option value="2"><cf_get_lang dictionary_id='57554.Giriş'>/<cf_get_lang dictionary_id='57431.Çıkış'></option>
							<option value="1"<cfif isDefined("attributes.action_bank") and (attributes.action_bank eq 1)> selected</cfif>><cf_get_lang dictionary_id='57554.Giriş'></option>
							<option value="0"<cfif isDefined("attributes.action_bank") and (attributes.action_bank eq 0)> selected</cfif>><cf_get_lang dictionary_id='57431.Çıkış'></option>
						</select>
					</div>
					<div class="form-group" id="item-branch_id">
						<label><cf_get_lang dictionary_id='57453.Şube'></label>
						<select name="branch_id" id="branch_id">
							<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
							<cfoutput query="get_branchs">
								<option value="#branch_id#"<cfif isdefined('attributes.branch_id') and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-page_action_type">
						<label><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
						<select name="page_action_type" id="page_action_type">
							<option value="" selected><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
							<cfoutput query="get_process_cat" group="process_type">
								<option value="#process_type#-0" <cfif isdefined("attributes.page_action_type") and ('#process_type#-0' is attributes.page_action_type)> selected</cfif>>#get_process_name(process_type)#</option>										
								<cfoutput>
									<option value="#process_type#-#process_cat_id#" <cfif isdefined("attributes.page_action_type") and (attributes.page_action_type is '#process_type#-#process_cat_id#')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
								</cfoutput>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-account">
						<label><cf_get_lang dictionary_id='57652.Hesap'></label>
						<select name="account" id="account">
							<option value=""><cf_get_lang dictionary_id='57652.Hesap'></option>
							<cfoutput query="get_accounts">
								<option value="#account_id#" <cfif isDefined("attributes.account") and attributes.account eq get_accounts.account_id>selected</cfif> >#account_name#-#account_currency_id#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-record_date">
						<label><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
						<div class="input-group">
							<cfsavecontent variable="record_date"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol ediniz'></cfsavecontent>
							<cfinput type="text" maxlength="10" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" validate="#validate_style#" message="#record_date#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
							<span class="input-group-addon no-bg"></span>
							<cfinput type="text" maxlength="10" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" validate="#validate_style#" message="#record_date#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
						</div>
					</div>
					<div class="form-group" id="item-date1">
						<label><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol ediniz'></cfsavecontent>
							<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
								<cfinput name="date1" type="text" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
							<cfelse>
								<cfinput value="#dateformat(attributes.date1,dateformat_style)#" message="#message#" type="text" name="date1" required="yes" validate="#validate_style#" maxlength="10">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
							<span class="input-group-addon no-bg"></span>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol ediniz'></cfsavecontent>
							<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
								<cfinput value="#dateformat(attributes.date2,dateformat_style)#" type="text" name="date2" validate="#validate_style#" maxlength="10" message="#message#">
							<cfelse>
								<cfinput value="#dateformat(attributes.date2,dateformat_style)#" message="#message#" type="text" name="date2" required="yes" validate="#validate_style#" maxlength="10">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename="bank#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_actions.recordcount>
	</cfif>
	<cf_box title="#getLang('main',1484)#" uidrop="#IIf((isdefined('attributes.is_excel') and attributes.is_excel eq 1),Evaluate(DE("")),DE("1"))#" scroll="1" hide_table_column="1">	
		<cf_grid_list>
			<cfset colspan_ = 10>
			<cfset colspan_info = 8>
			<thead>
				<tr>
					<th id="th_0" width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th id="th_1"><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th id="th_2"><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th id="th_3"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th id="th_20"><cfoutput>#getlang("process",142,"İşlem Kategorisi")#</cfoutput></th>
					<th id="th_5"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif x_branch_info>
						<th id="th_6"><cf_get_lang dictionary_id='57453.Şube'></th>
						<cfset colspan_ +=1>
						<cfset colspan_info +=1>
					</cfif>
					<cfif x_project_info>
						<th id="th_7"><cf_get_lang dictionary_id='57416.Proje'></th>
						<cfset colspan_ +=1>
						<cfset colspan_info +=1>
					</cfif>
					<th id="th_8"><cf_get_lang dictionary_id='38361.Hesaptan'></th>
					<th id="th_9"><cf_get_lang dictionary_id='38362.Hesaba'></th> 
					<th class="text-right" id="th_10" nowrap="nowrap"><cf_get_lang dictionary_id='30060.Masraf Tutarı'></th>
					<th id="th_11" nowrap="nowrap"><cf_get_lang dictionary_id='57489.Para Br'></th>
					<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
						<cfset colspan_ = colspan_+2>
						<th class="text-right" id="th_12"><cf_get_lang dictionary_id='57587.Borç'></th>
						<th id="th_13" nowrap="nowrap"><cf_get_lang dictionary_id='57489.Para Br'></th>
					</cfif>
					<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
						<cfset colspan_ = colspan_+2>
						<th class="text-right" id="th_14"><cf_get_lang dictionary_id='57588.Alacak'></th>
						<th id="th_15" nowrap="nowrap"><cf_get_lang dictionary_id='57489.Para Br'></th>
					</cfif>
					<cfif isdefined("attributes.account") and len(attributes.account) and (attributes.oby eq 2)>
						<cfset colspan_ = colspan_++>
						<th class="text-right" id="th_16"><cf_get_lang dictionary_id='57589.Bakiye'></th>
					</cfif>
					<cfif isdefined("attributes.is_money")>
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
							<cfset colspan_ = colspan_++>
							<th class="text-right" id="th_17"><cf_get_lang dictionary_id='57587.Borç'> <cfoutput>#session.ep.money#</cfoutput></th>
						</cfif>
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
							<cfset colspan_ = colspan_++>
							<th class="text-right" id="th_18"><cf_get_lang dictionary_id='57588.Alacak'> <cfoutput>#session.ep.money#</cfoutput></th>
						</cfif> 
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 1) or (attributes.action_bank eq 2)) and isdefined("attributes.account") and len(attributes.account)>
							<cfset colspan_ = colspan_++>
							<th class="text-right" id="th_19"><cf_get_lang dictionary_id='57589.Bakiye'> <cfoutput>#session.ep.money#</cfoutput></th>
						</cfif> 
					</cfif>
				</tr>
			</thead>
			
			<tbody>
				<cfif isDefined("attributes.account") and len(attributes.account) and attributes.oby eq 2>
					<tr>
						<td colspan="<cfoutput>#colspan_#</cfoutput>" align="left"><cf_get_lang dictionary_id='48903.Önceki Devir'></td>
						<td class="text-right"><cfoutput>#TLFormat(bakiye)#</cfoutput></td>
						<cfif isdefined("attributes.is_money")>
							<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
								<td></td>
							</cfif>
							<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
								<td></td>
							</cfif> 
							<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2)) and isdefined("attributes.account") and len(attributes.account)>
								<td class="text-right"><cfoutput>#TLFormat(bakiye_)#</cfoutput></td>
							</cfif> 
						</cfif>
					</tr>
				</cfif>
				<cfif get_actions.recordcount>
					<cfset company_id_list=''>
					<cfset account_id_list=''>
					<cfset cash_id_list=''>
					<cfset employee_id_list=''>
					<cfset consumer_id_list=''>
					<cfset debt_total = 0>
					<cfset claim_total = 0>
					<cfoutput query="get_money_rate">
						<cfset "expense_total_#money#" = 0>
						<cfset "debt_total_#money#" = 0>
						<cfset "claim_total_#money#" = 0>
					</cfoutput>
					<cfif attributes.page neq 1>
						<cfoutput query="get_actions" startrow="1" maxrows="#attributes.startrow-1#">
							<cfif len(MASRAF) and MASRAF gt 0>
								<cfset "expense_total_#action_currency_id#" = evaluate("expense_total_#action_currency_id#")+MASRAF>
							</cfif>
							<cfif len(ACTION_TO_ACCOUNT_ID)>
								<cfset "debt_total_#action_currency_id#" = evaluate("debt_total_#action_currency_id#")+ACTION_VALUE>
							<cfelse>
								<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
									<cfset "claim_total_#action_currency_id#" = evaluate("claim_total_#action_currency_id#")+MULTI_VALUE><!--- TOPLU GİDEN HAVALE TOPLAM DEĞERI --->
								<cfelse>
									<cfset "claim_total_#action_currency_id#" = evaluate("claim_total_#action_currency_id#")+ACTION_VALUE>
								</cfif>
							</cfif>
						</cfoutput>				  
					</cfif>
					<cfif attributes.page gt 1 and isdefined("attributes.account") and len(attributes.account) and attributes.oby eq 2>
						<cfloop from="1" to="#(attributes.page-1)*attributes.maxrows#" index="x">
							<cfif len(get_actions.ACTION_FROM_ACCOUNT_ID[x]) and (get_actions.ACTION_FROM_ACCOUNT_ID[x] eq attributes.account)>
								<cfset bakiye = bakiye - get_actions.ACTION_VALUE[x]> 
							<cfelse>
								<cfset bakiye = bakiye + get_actions.ACTION_VALUE[x]-get_actions.MASRAF[X]> 
							</cfif>
						</cfloop>
					</cfif>
						<cfif attributes.page gt 1 and isdefined("attributes.account") and len(attributes.account) and attributes.oby eq 2>
						<cfloop from="1" to="#(attributes.page-1)*attributes.maxrows#" index="x">
							<cfif len(get_actions.ACTION_FROM_ACCOUNT_ID[x]) and (get_actions.ACTION_FROM_ACCOUNT_ID[x] eq attributes.account)>
								<cfset bakiye_ = bakiye_ - get_actions.SYSTEM_ACTION_VALUE[x]> 
							<cfelse>
								<cfset bakiye_ = bakiye_ + get_actions.SYSTEM_ACTION_VALUE[x]-get_actions.MASRAF[X]> 
							</cfif>
						</cfloop>
					</cfif>
					<cfoutput query="get_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(ACTION_FROM_COMPANY_ID) and not listfind(company_id_list,ACTION_FROM_COMPANY_ID)>
							<cfset company_id_list=listappend(company_id_list,ACTION_FROM_COMPANY_ID)>
						</cfif>
						<cfif len(ACTION_TO_COMPANY_ID) and not listfind(company_id_list,ACTION_TO_COMPANY_ID)>
							<cfset company_id_list=listappend(company_id_list,ACTION_TO_COMPANY_ID)>
						</cfif>
						<cfif len(ACTION_FROM_ACCOUNT_ID) and not listfind(account_id_list,ACTION_FROM_ACCOUNT_ID)>
							<cfset account_id_list=listappend(account_id_list,ACTION_FROM_ACCOUNT_ID)>
						</cfif>
						<cfif len(ACTION_TO_ACCOUNT_ID) and not listfind(account_id_list,ACTION_TO_ACCOUNT_ID)>
							<cfset account_id_list=listappend(account_id_list,ACTION_TO_ACCOUNT_ID)>
						</cfif>
						<cfif len(ACTION_FROM_CASH_ID) and not listfind(cash_id_list,ACTION_FROM_CASH_ID)>
							<cfset cash_id_list=listappend(cash_id_list,ACTION_FROM_CASH_ID)>
						</cfif>
						<cfif len(ACTION_TO_CASH_ID) and not listfind(cash_id_list,ACTION_TO_CASH_ID)>
							<cfset cash_id_list=listappend(cash_id_list,ACTION_TO_CASH_ID)>
						</cfif>
						<cfif len(ACTION_TO_EMPLOYEE_ID) and not listfind(employee_id_list,ACTION_TO_EMPLOYEE_ID)>
							<cfset employee_id_list=listappend(employee_id_list,ACTION_TO_EMPLOYEE_ID)>
						</cfif>
						<cfif len(ACTION_TO_CONSUMER_ID) and not listfind(consumer_id_list,ACTION_TO_CONSUMER_ID)>
							<cfset consumer_id_list=listappend(consumer_id_list,ACTION_TO_CONSUMER_ID)>
						</cfif>
						<cfif len(ACTION_FROM_CONSUMER_ID) and not listfind(consumer_id_list,ACTION_FROM_CONSUMER_ID)>
							<cfset consumer_id_list=listappend(consumer_id_list,ACTION_FROM_CONSUMER_ID)>
						</cfif>
						<cfif len(ACTION_FROM_EMPLOYEE_ID) and not listfind(employee_id_list,ACTION_FROM_EMPLOYEE_ID)>
							<cfset employee_id_list=listappend(employee_id_list,ACTION_FROM_EMPLOYEE_ID)>
						</cfif>
					</cfoutput>
					<cfif len(company_id_list)>
						<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
						<cfquery name="get_company_detail" datasource="#dsn#">
							SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_company_detail.COMPANY_ID)),"numeric","asc",",")>
					</cfif>
					<cfif len(account_id_list)>
						<cfset account_id_list=listsort(account_id_list,"numeric","ASC",",")>
						<cfquery name="get_account_detail" dbtype="query">
							SELECT ACCOUNT_NAME,ACCOUNT_CURRENCY_ID,ACCOUNT_ID FROM get_accounts WHERE ACCOUNT_ID IN (#account_id_list#) ORDER BY ACCOUNT_ID
						</cfquery>
						<cfset account_id_list = ListSort(ListDeleteDuplicates(ValueList(get_account_detail.account_id)),"numeric","asc",",")>
					</cfif>
					<cfif len(cash_id_list)>
						<cfset cash_id_list=listsort(cash_id_list,"numeric","ASC",",")>
						<cfquery name="get_cash_detail" datasource="#dsn2#">
							SELECT CASH_ID,CASH_NAME,CASH_CURRENCY_ID FROM CASH WHERE CASH_ID IN (#cash_id_list#) ORDER BY CASH_ID
						</cfquery>
						<cfset cash_id_list = ListSort(ListDeleteDuplicates(ValueList(get_cash_detail.CASH_ID)),"numeric","asc",",")>
					</cfif>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="get_emp_detail" datasource="#dsn#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset employee_id_list = ListSort(ListDeleteDuplicates(ValueList(get_emp_detail.EMPLOYEE_ID)),"numeric","asc",",")>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="get_cons_detail" datasource="#dsn#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_cons_detail.CONSUMER_ID)),"numeric","asc",",")>
					</cfif>
					<cfset money_type = ''>
					
					<cfoutput query="get_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset type="">
						<cfswitch expression = "#get_actions.ACTION_TYPE_ID#">
							<cfcase value=20><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_account_open&event=upd"></cfcase>
							<cfcase value=21><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_invest_money&event=upd"></cfcase>
							<cfcase value=22><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_get_money&event=upd"></cfcase>
							<cfcase value="23,26,27"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_virman&event=upd"></cfcase>
							<cfcase value="2311"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_term_deposit&event=upd"></cfcase>
							<cfcase value=24><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_gelenh&event=upd"></cfcase>
							<cfcase value=25><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_gidenh&event=upd"></cfcase>
							<cfcase value="29"><cfset type="bank.popup_upd_bank_gider_pusula"></cfcase>
							<cfcase value="241"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_creditcard_revenue"></cfcase>
							<cfcase value="1040,1043,1044,1045">
								<cfset type="ch.popup_check_preview"></cfcase>
							<cfcase value="1052,1053,1054,1051">
								<cfset type="ch.popup_voucher_preview"></cfcase><!--- senet gelecek --->
							<cfcase value="243,247"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_upd_bank_cc_payment"></cfcase><!---banka hesaba geçiş --->
							<cfcase value="244,248">
								<cfset type="bank.list_credit_card_expense&event=updDebit"></cfcase><!---banka kredikartı borcu ödeme--->
							<cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
							<cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
						</cfswitch>
					<!---	<cfif len(multi_action_id) and (currentrow neq 1 and multi_action_id neq multi_action_id[currentrow - 1] )>
						a	#paper_no# <br>
						</cfif>
						<cfif  len(multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )>
						b	#paper_no# <br>
						</cfif>
						currentrow-#currentrow# recordcount-#recordcount# multi_action_id #multi_action_id# * #multi_action_id[currentrow + 1]# * #multi_action_id[currentrow - 1]# <br>
						--->
						<cfif	(isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 0) or  ( 
							isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and
							action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and len(get_actions.multi_action_id) and 
							(currentrow neq 1 and multi_action_id neq multi_action_id[currentrow - 1] )
							and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))
							)
							or (action_type_id neq 25) 
							or (not len(get_actions.multi_action_id) and action_type_id eq 25)
							or (len(get_actions.multi_action_id) and action_type_id eq 25 AND NOT len(ACTION_TO_EMPLOYEE_ID))
							or ( len(get_actions.multi_action_id) and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) AND (module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id) OR  module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))
							>
							<tr>
								<td width="20">#get_actions.currentrow#&nbsp;</td>
								<td>#get_actions.paper_no#</td>
								<td>#dateformat(get_actions.action_date,dateformat_style)#</td>
								<td>#dateformat(get_actions.record_date,dateformat_style)#</td>
								<td> 
									<cfif action_type_id eq 120>
										<a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#">#get_actions.STAGE#</a>
									<cfelseif action_type_id eq 121>
										<a href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#expense_id#">#get_actions.STAGE#</a>
									<cfelseif action_type_id eq 254 and len(multi_action_id)><!--- kur değerleme işlemi--->
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=bank.popup_dsp_bank_rate_valuation&multi_action_id=#multi_action_id#')">#get_actions.STAGE#</a> 
									<cfelseif len(get_actions.multi_action_id) and action_type_id eq 24><!--- toplu gelen havale --->
										<a href="#request.self#?fuseaction=bank.form_add_gelenh&event=updMulti&multi_id=#get_actions.MULTI_ACTION_ID#">#get_actions.STAGE#</a>
									<cfelseif len(get_actions.multi_action_id) and action_type_id eq 25><!--- toplu giden havale --->
										<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 0 and len(ACTION_TO_EMPLOYEE_ID) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) OR (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
											#get_actions.STAGE#
										<cfelse>
											<a href="#request.self#?fuseaction=bank.form_add_gidenh&event=updMulti&multi_id=#get_actions.MULTI_ACTION_ID#">#get_actions.STAGE#</a>
										</cfif>
									<cfelseif len(get_actions.multi_action_id) and action_type_id eq 23><!--- toplu virman --->
										<a href="#request.self#?fuseaction=bank.form_add_virman&event=updMulti&multi_id=#get_actions.MULTI_ACTION_ID#">#get_actions.STAGE#</a>
									<cfelseif listfind("291,292",get_actions.action_type_id)><!--- Kredi Odemesi ,Kredi Tahsilat --->
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=credit.popup_dsp_credit_payment&action_id=#get_actions.action_id#&period_id=#session.ep.period_id#&our_company_id=#session.ep.company_id#');">#get_actions.STAGE#</a>
									<cfelseif listfind("293,294",get_actions.action_type_id)><!--- Menkul Kıymet Alış, Menkul Kıymet Satış --->
										<cfif get_actions.action_type eq "MENKUL KIYMET SATIŞI - KOMİSYON">
											<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=credit.popup_dsp_stockbond_purchase&action_id=#get_actions.action_id-1#');">#get_actions.STAGE#</a>
										<cfelse>
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=credit.popup_dsp_stockbond_purchase&action_id=#get_actions.action_id#','page');">#get_actions.STAGE#</a>
										</cfif>
									<cfelseif listfind('24,25',action_type_id) and process_cat eq 0><!---Senet tahsilat ekranından eklenen havale--->
										<a href="javascript://" onClick="alert('Bu İşlemi İlgili Olduğu #paper_no# Nolu Senet Tahsilat İşleminden Güncelleyebilirsiniz!');">#get_actions.STAGE#</a>
									<cfelseif listfind("23,26,27",action_type_id,",")><!--- doviz alıs-satıs-virman islemleri --->
										<cfif get_actions.with_next_row eq 0>
											<cfquery name="first_action_id" datasource="#dsn2#" maxrows="1">
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE ACTION_ID < #get_actions.ACTION_ID# ORDER BY ACTION_ID DESC
											</cfquery>
										</cfif>		
										<a href="#request.self#?fuseaction=#type#&ID=<cfif get_actions.with_next_row neq 0>#get_actions.ACTION_ID#<cfelse>#first_action_id.ACTION_ID#</cfif>">#get_actions.STAGE#</a>
									<cfelseif listfind("2311",action_type_id,",")> <!--- vadeli mevduat hesaba yatır --->
										<cfif get_actions.with_next_row eq 0>
											<cfquery name="first_action_id" datasource="#dsn2#" maxrows="1">
												SELECT ACTION_ID FROM BANK_ACTIONS WHERE ACTION_ID < #get_actions.ACTION_ID# ORDER BY ACTION_ID DESC
											</cfquery>
										</cfif>	
										<a href="#request.self#?fuseaction=#type#&ID=<cfif get_actions.with_next_row neq 0>#get_actions.ACTION_ID#<cfelse>#first_action_id.ACTION_ID#</cfif>">#get_actions.STAGE#</a>
									<cfelseif action_type_id eq 22>
										<a href="#request.self#?fuseaction=#type#&ID=#get_actions.ACTION_ID#">#get_actions.STAGE#</a>
									<cfelseif not len(type)><!--- display sayfası olmayan tipler için --->
										#get_actions.STAGE#
									<cfelseif listfind("1052,1053,1054,1051,1040,1043,1044,1045",action_type_id,",")>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&ID=#get_actions.ACTION_ID#','small');">#get_actions.STAGE#</a>
									<cfelseif listfind("244,243,247",action_type_id,",")>
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#type#&ID=#get_actions.ACTION_ID#');">#get_actions.STAGE#</a>
									<cfelse>
										<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and len(ACTION_TO_EMPLOYEE_ID) and action_type_id eq 25 and ( (not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)) )>
											#get_actions.STAGE#
										<cfelse>
											<a href="#request.self#?fuseaction=#type#&ID=#get_actions.ACTION_ID#">#get_actions.STAGE#</a>
										</cfif>
									</cfif>
								</td>
								<td title="#action_detail#">#left(ACTION_DETAIL,40)#</td>
								<!--- Proje ve Şube --->
								<cfif x_branch_info>
									<td>#get_actions.BRANCH#</td>
								</cfif>
								<cfif x_project_info>
									<td>#get_actions.PROJECT#</td>
								</cfif>
								<cfif len(ACTION_FROM_ACCOUNT_ID)>
									<cfset money_type = get_account_detail.ACCOUNT_CURRENCY_ID[listfind(account_id_list,ACTION_FROM_ACCOUNT_ID,',')]>
								</cfif>
								<cfif len(ACTION_TO_ACCOUNT_ID)>
									<cfset money_type = get_account_detail.ACCOUNT_CURRENCY_ID[listfind(account_id_list,ACTION_TO_ACCOUNT_ID,',')]>
								</cfif>
								<td>
									<cfif len(ACTION_FROM_ACCOUNT_ID)>#get_account_detail.ACCOUNT_NAME[listfind(account_id_list,ACTION_FROM_ACCOUNT_ID,',')]#-#money_type#</cfif>
									<cfif len(ACTION_FROM_COMPANY_ID)>#get_company_detail.FULLNAME[listfind(company_id_list,ACTION_FROM_COMPANY_ID,',')]# (<cf_get_lang dictionary_id='58061.cari'>)</cfif>
									<cfif len(ACTION_FROM_CASH_ID)>#get_cash_detail.CASH_NAME[listfind(cash_id_list,ACTION_FROM_CASH_ID,',')]#-#get_cash_detail.CASH_CURRENCY_ID[listfind(cash_id_list,ACTION_FROM_CASH_ID,',')]#</cfif>
									<cfif len(ACTION_FROM_CONSUMER_ID)>#get_cons_detail.CONSUMER_NAME[listfind(consumer_id_list,ACTION_FROM_CONSUMER_ID,',')]#	#get_cons_detail.CONSUMER_SURNAME[listfind(consumer_id_list,ACTION_FROM_CONSUMER_ID,',')]#</cfif>
									<cfif len(ACTION_FROM_EMPLOYEE_ID)>#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,ACTION_FROM_EMPLOYEE_ID,',')]#	#get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,ACTION_FROM_EMPLOYEE_ID,',')]#</cfif>
								</td>
								<!--- kredi karti borcu odeme islemi ise --->
								<cfif get_actions.ACTION_TYPE_ID eq 244 and len(get_actions.creditcard_id)>
									<cfquery name="get_credit_account_to_name" datasource="#dsn3#">
										SELECT
											CREDITCARD_NUMBER,
											ACCOUNT_NAME
										FROM
											CREDIT_CARD,
											ACCOUNTS
										WHERE
											CREDIT_CARD.ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
											AND CREDIT_CARD.CREDITCARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_actions.creditcard_id#">
									</cfquery>
								</cfif>
								<td>
									<cfif len(ACTION_TO_ACCOUNT_ID)>#get_account_detail.ACCOUNT_NAME[listfind(account_id_list,ACTION_TO_ACCOUNT_ID,',')]#-#money_type#</cfif>
									<cfif len(ACTION_TO_COMPANY_ID)>#get_company_detail.FULLNAME[listfind(company_id_list,ACTION_TO_COMPANY_ID,',')]# (<cf_get_lang dictionary_id='58061.cari'>)</cfif>
									<cfif len(ACTION_TO_CASH_ID)>#get_cash_detail.CASH_NAME[listfind(cash_id_list,ACTION_TO_CASH_ID,',')]#-#get_cash_detail.CASH_CURRENCY_ID[listfind(cash_id_list,ACTION_TO_CASH_ID,',')]#</cfif>
									<cfif len(ACTION_TO_EMPLOYEE_ID) and isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1>
										<cfsavecontent  variable="val"><cf_get_lang dictionary_id = "57576.Çalışan"></cfsavecontent>
										<cfif not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)>
											<cf_wrk_element mask_type = "1"  static="#val#">
										<cfelseif not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)>
											<cf_wrk_element mask_type = "1" static="#val#">
										<cfelse>
											#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,ACTION_TO_EMPLOYEE_ID,',')]#	#get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,ACTION_TO_EMPLOYEE_ID,',')]#
										</cfif>
									<cfelseif  len(ACTION_TO_EMPLOYEE_ID)>
											#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,ACTION_TO_EMPLOYEE_ID,',')]#	#get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,ACTION_TO_EMPLOYEE_ID,',')]#
									</cfif>
									<cfif len(ACTION_TO_CONSUMER_ID)>#get_cons_detail.CONSUMER_NAME[listfind(consumer_id_list,ACTION_TO_CONSUMER_ID,',')]#	#get_cons_detail.CONSUMER_SURNAME[listfind(consumer_id_list,ACTION_TO_CONSUMER_ID,',')]#</cfif>
									<cfif get_actions.ACTION_TYPE_ID eq 244 and len(get_actions.creditcard_id) and get_credit_account_to_name.recordcount>
										<cfset key_type = '#session.ep.company_id#'>
										<cfscript>
											getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
											getCCNOKey.dsn = dsn;
											getCCNOKey1 = getCCNOKey.getCCNOKey1();
											getCCNOKey2 = getCCNOKey.getCCNOKey2();
										</cfscript>
										<cfset key_type = '#session.ep.company_id#'>
										<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
										<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
											<!--- anahtarlar decode ediliyor --->
											<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
											<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
											<!--- kart no encode ediliyor --->
											<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_credit_account_to_name.creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
											<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
										<cfelse>
											<cfset content = '#mid(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
										</cfif>
										#get_credit_account_to_name.account_name# / #content#
									</cfif>
								</td>
									<td class="text-right">
										<cfif listfind("291",action_type_id)>
											<cfif x_masraf_alacak eq 0>
												<cfif len(OTHER_COST) and OTHER_COST gt 0>#TLFormat(OTHER_COST)#
												<cfelseif len(MASRAF) and MASRAF gt 0>#TLFormat(MASRAF)#
												</cfif>
											</cfif>
										<cfelse>
											<cfif len(MASRAF) and MASRAF gt 0>#TLFormat(MASRAF)#<cfset masraf_ = MASRAF></cfif>
										</cfif>
									</td>
									<td>
										<cfif listfind("291",action_type_id)>
											<cfif x_masraf_alacak eq 0 and len(MASRAF) and MASRAF gt 0>#ACTION_CURRENCY_ID#</cfif>
										<cfelse>
											<cfif len(MASRAF) and MASRAF gt 0>#ACTION_CURRENCY_ID#</cfif>
										</cfif>
									</td>
								<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
									<td class="text-right">
										<cfif isdefined("attributes.account") and len(attributes.account)>
											<cfif len(ACTION_TO_ACCOUNT_ID) and ACTION_TO_ACCOUNT_ID eq attributes.account>
												<cfif action_type_id eq 243 or action_type_id eq 1043 or action_type_id eq 294>
													#TLFormat(ACTION_VALUE)#
												<cfelseif len(MASRAF) and MASRAF gt 0 and action_type_id neq 24>
													#TLFormat(ACTION_VALUE - MASRAF)#
													<cfset masraf_ = MASRAF+masraf_>
												<cfelse>
													#TLFormat(ACTION_VALUE)#
												</cfif>
											</cfif>
										<cfelse>
											<cfif len(ACTION_TO_ACCOUNT_ID)>
												<cfif action_type_id eq 243 or action_type_id eq 1043 or action_type_id eq 294>
													#TLFormat(ACTION_VALUE + MASRAF)#
												<cfelseif len(MASRAF)  and MASRAF gt 0 and action_type_id neq 24>
													#TLFormat(ACTION_VALUE - MASRAF)#
												<cfelse>
													#TLFormat(ACTION_VALUE)#
												</cfif>
											</cfif>
										</cfif>
									</td>
									<td><cfif len(ACTION_TO_ACCOUNT_ID)>&nbsp;#ACTION_CURRENCY_ID#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
								
									<td class="text-right">
										<cfif isdefined("attributes.account") and len(attributes.account)>
											<cfif len(ACTION_FROM_ACCOUNT_ID) and ACTION_FROM_ACCOUNT_ID eq attributes.account>
												<cfif listfind("291,292",action_type_id)>
													<cfif len(MASRAF) and MASRAF gt 0>
														#TLFormat(OTHER_CASH_ACT_VALUE - MASRAF)# 
													<cfelse> 
														#TLFormat(OTHER_CASH_ACT_VALUE)# 
													</cfif>
												<cfelse>
													<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
														#TLFormat(MULTI_VALUE)# <!--- TOPLU GİDEN HAVALE TOPLAM DEĞERI --->
													<cfelse>
														<cfif listfind("243,247",action_type_id)>
															#TLFormat(ACTION_VALUE)#
														<cfelseif len(MASRAF) and MASRAF gt 0>
															#TLFormat(ACTION_VALUE - MASRAF)#
														<cfelse>
															#TLFormat(ACTION_VALUE)#
														</cfif><!--- hesaba geçiş işlemi farkından --->
													</cfif>
												</cfif>
											</cfif>
										<cfelse>
											<cfif len(ACTION_FROM_ACCOUNT_ID)>
												<cfif listfind("291",action_type_id)>
													<cfif x_masraf_alacak eq 0>
														<cfif len(OTHER_COST)> #TLFormat(OTHER_CASH_ACT_VALUE - OTHER_COST)#
														<cfelseif len(MASRAF) and MASRAF gt 0> #TLFormat(OTHER_CASH_ACT_VALUE - MASRAF)#
														<cfelse> #TLFormat(OTHER_CASH_ACT_VALUE)#
														</cfif>
													<cfelse>
														#TLFormat(OTHER_CASH_ACT_VALUE)#
													</cfif>
												<cfelse>
													<cfif listfind("243,247",action_type_id)>#TLFormat(ACTION_VALUE)#
													<cfelseif len(MASRAF) and MASRAF gt 0>#TLFormat(ACTION_VALUE - MASRAF)#
													<cfelse>
														<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
															#TLFormat(MULTI_VALUE)# <!--- TOPLU GİDEN HAVALE TOPLAM DEĞERI --->
														<cfelse>
															#TLFormat(ACTION_VALUE)#
														</cfif>
													</cfif><!--- hesaba geçiş işlemi farkından --->
												</cfif>
											</cfif>
										</cfif>
									</td>
									<td><cfif len(ACTION_FROM_ACCOUNT_ID)>&nbsp;#ACTION_CURRENCY_ID#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.account") and len(attributes.account) and (attributes.oby eq 2)>
									<cfif len(MASRAF) and MASRAF gt 0>
										<cfset bakiye = bakiye>
									</cfif>
									<cfif len(get_actions.ACTION_FROM_ACCOUNT_ID) and get_actions.ACTION_FROM_ACCOUNT_ID eq attributes.account>
										<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
											<cfset bakiye = bakiye - wrk_round(get_actions.MULTI_VALUE)> 
										<cfelse>
											<cfset bakiye = bakiye - wrk_round(get_actions.ACTION_VALUE)> 
										</cfif>
									<cfelse>
										<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
											<cfset bakiye = bakiye + wrk_round(get_actions.MULTI_VALUE)> 
										<cfelse>
											<cfif not len(masraf_)><cfset masraf_ = 0></cfif>								
											<cfset bakiye = bakiye + wrk_round(get_actions.ACTION_VALUE-MASRAF)>											
										</cfif>
									</cfif>
									<td class="text-right">#TLFormat(bakiye)#</td>
								</cfif>
								<cfif isdefined("attributes.is_money")>
									<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
										<td class="text-right">
											<cfif len(ACTION_TO_ACCOUNT_ID)>
												<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
													#TLFormat(MULTI_SYSTEM_VALUE)#
													<cfset debt_total = debt_total+MULTI_SYSTEM_VALUE>
												<cfelse>
													#TLFormat(SYSTEM_ACTION_VALUE)#
													<cfset debt_total = debt_total+SYSTEM_ACTION_VALUE>
												</cfif>
											</cfif>
										</td>
									</cfif>
									<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
										<td class="text-right">
											<cfif len(ACTION_FROM_ACCOUNT_ID)>
												<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
													#TLFormat(MULTI_SYSTEM_VALUE)#
													<cfset claim_total = claim_total + MULTI_SYSTEM_VALUE>
												<cfelse>
													#TLFormat(SYSTEM_ACTION_VALUE)#
													<cfset claim_total = claim_total + SYSTEM_ACTION_VALUE>
												</cfif>
											</cfif>
										</td>
									</cfif>
									<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2)) and isdefined("attributes.account") and len(attributes.account)>
											<cfif len(MASRAF) and MASRAF gt 0>
												<cfset bakiye_ = bakiye_-MASRAF>
											</cfif>
											<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
												<cfif len(get_actions.ACTION_FROM_ACCOUNT_ID) and get_actions.ACTION_FROM_ACCOUNT_ID eq attributes.account>
													<cfset bakiye_ = bakiye_ - wrk_round(get_actions.MULTI_SYSTEM_VALUE)> 
												<cfelse>
													<cfset bakiye_ = bakiye_ + wrk_round(get_actions.MULTI_SYSTEM_VALUE)> 
												</cfif>
											<cfelse>
												<cfif len(get_actions.ACTION_FROM_ACCOUNT_ID) and get_actions.ACTION_FROM_ACCOUNT_ID eq attributes.account>
													<cfset bakiye_ = bakiye_ - wrk_round(get_actions.SYSTEM_ACTION_VALUE)> 
												<cfelse>
													<cfset bakiye_ = bakiye_ + wrk_round(get_actions.SYSTEM_ACTION_VALUE)> 
												</cfif>
											</cfif>
											<td class="text-right">
												#TLFormat(bakiye_)#
											</td>
										</cfif>
								</cfif>	
								<cfif isdefined("is_total") and is_total eq 1><!--- xml e bağlı olarak alt toplamlar hesaplanıyor --->
									<cfif len(MASRAF) and MASRAF gt 0>
										<cfset "expense_total_#action_currency_id#" = evaluate("expense_total_#action_currency_id#")+MASRAF>
									</cfif>
									<cfif len(ACTION_TO_ACCOUNT_ID)>
										<cfif action_type_id eq 243 or  action_type_id eq 1043 or action_type_id eq 294>
											<cfset "debt_total_#action_currency_id#" = evaluate("debt_total_#action_currency_id#")+ACTION_VALUE>
										<cfelseif len(MASRAF) and MASRAF gt 0>
											<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
												<cfset "debt_total_#action_currency_id#" = evaluate("debt_total_#action_currency_id#")+MULTI_VALUE - MASRAF>
											<cfelse>
												<cfset "debt_total_#action_currency_id#" = evaluate("debt_total_#action_currency_id#")+ACTION_VALUE - MASRAF>
											</cfif>
										<cfelse>
											<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
												<cfset "debt_total_#action_currency_id#" = evaluate("debt_total_#action_currency_id#")+MULTI_VALUE>
											<cfelse>
												<cfset "debt_total_#action_currency_id#" = evaluate("debt_total_#action_currency_id#")+ACTION_VALUE>
											</cfif>
										</cfif>
									<cfelse>
										<cfif listfind("243,247",action_type_id)>
											<cfset "claim_total_#action_currency_id#" = evaluate("claim_total_#action_currency_id#")+ACTION_VALUE>
										<cfelseif len(MASRAF) and MASRAF gt 0>
											<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
												<cfset "claim_total_#action_currency_id#" = evaluate("claim_total_#action_currency_id#")+MULTI_VALUE - MASRAF> <!---toplu giden havale değeri --->
											<cfelse>
												<cfset "claim_total_#action_currency_id#" = evaluate("claim_total_#action_currency_id#")+ACTION_VALUE - MASRAF>
											</cfif>								
										<cfelse>
											<cfif isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1 and action_type_id eq 25 and len(ACTION_TO_EMPLOYEE_ID) and (len(get_actions.multi_action_id) and (currentrow neq recordcount and multi_action_id eq multi_action_id[currentrow + 1] )) and ((not module_power_user_hr and listfind(hr_type_list,GET_ACTIONS.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,GET_ACTIONS.acc_type_id)))>
												<cfset "claim_total_#action_currency_id#" = evaluate("claim_total_#action_currency_id#")+MULTI_VALUE><!---toplu giden havale değeri --->
											<cfelse>
												<cfset "claim_total_#action_currency_id#" = evaluate("claim_total_#action_currency_id#")+ACTION_VALUE>
											</cfif>
										</cfif>
									</cfif>
								</cfif>
							</tr>
						</cfif>
					</cfoutput>
					
				<cfelseif not(isDefined("attributes.account") and len(attributes.account) and attributes.oby eq 2)>
					<tr>
						<cfset colspan_info = 11>
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
							<cfset colspan_info = colspan_info + 2>
						</cfif>
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
							<cfset colspan_info = colspan_info + 2>
						</cfif> 
						<cfif isdefined("attributes.account") and len(attributes.account) and (attributes.oby eq 2)>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<cfif isdefined("attributes.is_money")>
							<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
								<cfset colspan_info = colspan_info + 1>
							</cfif>
							<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
								<cfset colspan_info = colspan_info + 1>
							</cfif> 
						</cfif>
						<cfif x_branch_info>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<cfif x_project_info>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
			<cfif isdefined("is_total") and is_total eq 1 and get_actions.recordcount><!--- xml e bağlı olarak alt toplamlar getiriliyor --->
				<div class="ui-info-bottom flex-end">
					<p class="bold"><cf_get_lang dictionary_id='57492.Toplam'></p>
					<p>&nbsp;
						<cfoutput query="get_money_rate">
							<cfif evaluate('expense_total_#money#') gt 0>
								<b><cf_get_lang dictionary_id='30060.Masraf Tutarı'> : </b>
								#Tlformat(evaluate('expense_total_#money#'))#
							</cfif>
						</cfoutput>
						<cfoutput query="get_money_rate">
							<cfif evaluate('expense_total_#money#') gt 0>
								&nbsp;#money#
							</cfif>
						</cfoutput>
					</p>
					<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
						<p>&nbsp;<b><cf_get_lang dictionary_id='57587.Borç'> : </b>
							<cfoutput query="get_money_rate">
								<cfif evaluate('debt_total_#money#') gt 0>
									#Tlformat(evaluate('debt_total_#money#'))#
								</cfif>
							</cfoutput>
					
							<cfoutput query="get_money_rate">
								<cfif evaluate('debt_total_#money#') gt 0>
									&nbsp;#money#
								</cfif>
							</cfoutput>
						</p>
					</cfif>
					<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
						<p>&nbsp;<b><cf_get_lang dictionary_id='57588.Alacak'> : </b>
							<cfoutput query="get_money_rate">
								<cfif evaluate('claim_total_#money#') gt 0>
									#Tlformat(evaluate('claim_total_#money#'))#
								</cfif>
							</cfoutput>
							<cfoutput query="get_money_rate">
								<cfif evaluate('claim_total_#money#') gt 0>
									&nbsp;#money#
								</cfif>
							</cfoutput>
						</p>
					</cfif>
					<cfif isdefined("attributes.account") and len(attributes.account) and (attributes.oby eq 2)>
						<p class="bold"><cfoutput>#tlFormat(bakiye)#</cfoutput></p>
					</cfif>
					<cfset last_expense_total = 0>
					<cfset last_debt_total = 0>
					<cfset last_claim_total = 0>
					<cfif isdefined("attributes.is_money")>
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 1) or (attributes.action_bank eq 2))>
							<p class="bold">
								<cfoutput>#Tlformat(debt_total)#</cfoutput>
							</p>
						</cfif>
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2))>
							<p class="bold">
								<cfoutput>#Tlformat(claim_total)#</cfoutput>
							</p>
						</cfif>
						<cfif isdefined("attributes.action_bank") and ((attributes.action_bank eq 0) or (attributes.action_bank eq 2)) and isdefined("attributes.account") and len(attributes.account)>
							   <p class="bold"><cfoutput>#tlFormat(bakiye_)#</cfoutput></p>
						</cfif>
					</cfif>
				</div>
			</cfif>
		<cfif isDefined('attributes.search_id') and len(attributes.search_id)>
			<cfset adres = '#adres#&search_id=#attributes.search_id#'>
		</cfif>
		<cfif isDefined('attributes.emp_id') and len(attributes.emp_id)>
			<cfset adres = '#adres#&emp_id=#attributes.emp_id#'>
		</cfif>
		<cfif isDefined('attributes.emp_name') and len(attributes.emp_name)>
			<cfset adres = '#adres#&emp_name=#attributes.emp_name#'>
		</cfif>
		<cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
			<cfset adres = '#adres#&branch_id=#attributes.branch_id#'>
		</cfif>
		<cfif isDefined('attributes.record_emp_name') and len(attributes.record_emp_name)>
			<cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#'>
			<cfset adres = '#adres#&record_emp_name=#attributes.record_emp_name#'>
		</cfif>
		<cfif isDefined('attributes.search_name') and len(attributes.search_name)>
			<cfset adres = '#adres#&search_name=#attributes.search_name#'>
		</cfif>
		<cfif isDefined('attributes.account_status') and len(attributes.account_status)>
			<cfset adres = '#adres#&account_status=#attributes.account_status#'>
		</cfif>
		<cfif isDefined ("attributes.record_date")>
			<cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
		</cfif>
		<cfif isDefined ("attributes.record_date2")>
			<cfset adres = "#adres#&record_date2=#dateformat(attributes.record_date2,dateformat_style)#">
		</cfif>
		<cfif isDefined('attributes.special_definition_id') and len(attributes.special_definition_id)>
			<cfset adres = '#adres#&special_definition_id=#attributes.special_definition_id#'>
		</cfif>
		<cfif isDefined('attributes.action_bank')>
			<cfset adres = '#adres#&action_bank=#attributes.action_bank#'>
		</cfif>
		<cfif isDefined('attributes.is_money')>
			<cfset adres = '#adres#&is_money=#attributes.is_money#'>
		</cfif>
		<cfif len(attributes.project_id)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
		</cfif>
		<cfif len(attributes.project_head)>
			<cfset adres = "#adres#&project_head=#attributes.project_head#">
		</cfif>
		<cfif isDefined('attributes.search_type') and len(attributes.search_type)>
			<cfif attributes.search_type is 'employee'>
				<cfset attributes.emp_name = get_emp_info(emp_id,0,0)>
			</cfif>
			<cfif attributes.search_type is 'partner'>
				<cfset attributes.search_name = get_par_info(search_id,1,1,0)>
			<cfelseif attributes.search_type is 'consumer'>
				<cfset attributes.search_name = get_cons_info(search_id,0,0)> 
			</cfif>
			<cfset adres = '#adres#&search_type=#attributes.search_type#'>
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
	<script language="javascript">
		document.getElementById('keyword').focus();
		function hesap_sec()
		{
			if(document.bank_list.search_id.value!='')
			{
				document.bank_list.search_id.value='';
				document.bank_list.emp_name.value='';
				document.bank_list.emp_type.value='';
			}
			if(document.bank_list.emp_id != undefined && document.bank_list.emp_id.value!='')
			{
				document.bank_list.emp_id.value='';
				document.bank_list.emp_name.value='';
				document.bank_list.emp_type.value='';
			}
			if(document.bank_list.search_type.value!='')
			{
				document.bank_list.search_type.value='';
				document.bank_list.emp_name.value='';
				document.bank_list.emp_type.value='';
			}
		}
		function kontrol() {
			if(document.bank_list.is_excel.checked==false)
			{
				document.bank_list.action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>"
				return true;
			}
            else
            {
                document.bank_list.action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_list_bank_actions</cfoutput>"
                document.bank_list.submit();
            }
		}
	</script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	<cfsetting showdebugoutput="yes">