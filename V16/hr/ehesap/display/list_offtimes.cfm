<cf_get_lang_set module_name="ehesap">
<cf_xml_page_edit fuseact='ehesap.offtimes'>
<cfparam name="attributes.izin_type" default="0">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.keyword" default="#get_emp_info(attributes.employee_id,0,0)#">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.off_validate" default="0">
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cfparam name="attributes.startdate" default="#dateformat(attributes.startdate,dateformat_style)#">
<cfelse>
	<cfparam name="attributes.startdate" default="#dateformat((date_add('m',-1,CreateDate(year(now()),month(now()),1))),dateformat_style)#">
</cfif>
<cfparam name="attributes.finishdate" default="#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),dateformat_style)#"> 
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.filter_process" default="">
<cfparam name="attributes.group_paper_no" default="" />

<cfset genel_izin_toplam = 0>
<cfset genel_dk_toplam = 0>
<cfset kisi_izin_toplam = 0>
<cfset kisi_izin_sayilmayan = 0>
<cfset izin_sayilmayan = 0>

<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")>
<!--- Aşama Component --->
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.offtimes')>
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
    <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
		<cfset totalValues = structNew()>
		<cfset totalValues = {
				total_offtime : 0
			}>
		<cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
			<cfset url_str="#url_str#&comp_id=#attributes.comp_id#">
		</cfif>
		<cfset action_list_id = replace(attributes.action_list_id,";",",","all")>
		<cf_workcube_general_process
			mode = "query"
			general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
			general_paper_no = "#attributes.general_paper_no#"
			general_paper_date = "#attributes.general_paper_date#"
			action_list_id = "#action_list_id#"
			process_stage = "#attributes.process_stage#"
			general_paper_notice = "#attributes.general_paper_notice#"
			responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
			responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
			action_table = 'OFFTIME'
			action_column = 'OFFTIME_ID'
			action_page = '#request.self#?fuseaction=ehesap.offtimes'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>

<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfscript>
	url_str = "";
	if (len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (len(attributes.employee_id))
		url_str = "#url_str#&employee_id=#attributes.employee_id#";
	if (len(attributes.hierarchy))
		url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
	if (len(attributes.off_validate))
		url_str = "#url_str#&off_validate=#attributes.off_validate#";
	if (len(attributes.izin_type))
		url_str = "#url_str#&izin_type=#attributes.izin_type#";
	if (isdefined("attributes.startdate"))
		url_str = "#url_str#&startdate=#attributes.startdate#";
	if (isdefined("attributes.finishdate"))
		url_str = "#url_str#&finishdate=#attributes.finishdate#";
	if (isdefined("attributes.branch_id"))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if (isdefined("attributes.department"))
		url_str = "#url_str#&department=#attributes.department#";
	if (isdefined("attributes.offtimecat_id"))
		url_str = "#url_str#&offtimecat_id=#attributes.offtimecat_id#";
	if (isdefined("attributes.group_paper_no"))
		url_str = "#url_str#&group_paper_no=#attributes.group_paper_no#";
	if (isdefined("attributes.form_submit"))
		url_str = "#url_str#&form_submit=1";	
</cfscript>
<cfif isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<!--- sorgu sirayi bozmayin  --->
<!--- <cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company();
</cfscript> --->
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
	WHERE
		1 = 1
		<cfif not session.ep.ehesap>
			AND COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY
		NICK_NAME
</cfquery>
<cfinclude template="../query/get_our_comp_and_branchs.cfm">
<cfif isdefined('attributes.form_submit')>
	<cfinclude template="../query/get_offtimes.cfm">
<cfelse>
	<cfset get_offtimes.recordcount = 0>
</cfif>
<cfinclude template="../query/get_offtime_cats.cfm">
<!--- sorgu sirayi bozmayin  --->
<cfparam name="attributes.totalrecords" default='#get_offtimes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="action_"><cfif fusebox.circuit is 'hr'>hr.list_offtimes<cfelse>ehesap.offtimes</cfif></cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="list_health_expense_search" closable="0" collapsable="0">
		<cfform action="#request.self#?fuseaction=#action_#" method="post" name="filter_offtime">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<input type="hidden" name="valid" id="valid" value="">
			<cfsavecontent variable="title"><cf_get_lang dictionary_id="52986.İzinler"></cfsavecontent>
			<cf_box_search plus="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57789.Özel Kod'></cfsavecontent>
					<cfinput type="text" name="hierarchy" id="hierarchy" placeholder="#message#" value="#attributes.hierarchy#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='change_action()' button_type="4">
				</div>
				<cfoutput>
					<div class="form-group">
						<cfif listgetat(attributes.fuseaction,1,'.')  is 'hr'>
							<a class="ui-btn ui-btn-gray" href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_offtimes&event=add-added" ><i class="fa fa-plus" title = "<cf_get_lang dictionary_id ='53989.Parçalı İzin Talebi Düzenle'>"></i></a>
						<cfelseif listgetat(attributes.fuseaction,1,'.')  is 'ehesap'>
							<a class="ui-btn ui-btn-gray" href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.offtimes&event=add-added" ><i class="fa fa-plus" title = "<cf_get_lang dictionary_id ='53989.Parçalı İzin Talebi Düzenle'>"></i></a>
						</cfif>
						
					</div>
					<div class="form-group">
						<cfif listgetat(attributes.fuseaction,1,'.') is 'hr'>
							<a class="ui-btn ui-btn-gray2" href="#request.self#?fuseaction=hr.list_offtimes&event=add-plan" class="tableyazi"><i class="fa icon-file-text" title="<cf_get_lang dictionary_id='54264.izin planları'>"></i></a>
						<cfelseif listgetat(attributes.fuseaction,1,'.') is 'ehesap'>
							<a class="ui-btn ui-btn-gray2" href="#request.self#?fuseaction=ehesap.offtimes&event=add-plan" class="tableyazi"><i class="fa icon-file-text" title="<cf_get_lang dictionary_id='54264.izin planları'>"></i></a>
						</cfif>

						
					</div>
				</cfoutput>
				<cfif IsDefined('form_submit') and get_offtimes.recordcount and listgetat(attributes.fuseaction,1,'.') is 'ehesap'>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" href="javascript://" onclick="send_pdf_print();"><i class="fa fa-print" title="<cf_get_lang dictionary_id ='53990.Toplu İzin Yazdır'>"></i></a>
					</div>
				</cfif>
			</cf_box_search>

			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-izin_type">
						<label><cf_get_lang dictionary_id='52986.İzinler'></label>
						<select name="izin_type" id="izin_type">
							<option value="0" <cfif attributes.izin_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<option value="1" <cfif attributes.izin_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='53991.İzin Talepleri'></option>
							<option value="2" <cfif attributes.izin_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='53992.İK İzinler'></option>
						</select>
					</div>
				<div class="form-group" id="item-company_id">
						<label><cf_get_lang dictionary_id='53701.İlgili Şirket'></label>
						<div>
							<cf_multiselect_check
								query_name="get_company"
								name="comp_id"
								option_value="COMP_ID"
								option_name="nick_name"
								option_text="#getLang('main',322)#"
								value="#attributes.comp_id#">
						</div>
					</div>
					
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-offtimecat_id">
						<label><cf_get_lang dictionary_id='54109.İzin Kategorisi'></label>
						<select name="offtimecat_id" id="offtimecat_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_offtime_cats">
								<option value="#offtimecat_id#"<cfif isdefined('attributes.offtimecat_id') and (attributes.offtimecat_id eq offtimecat_id)> selected</cfif>><cfif UPPER_OFFTIMECAT_ID neq 0>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>#offtimecat#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-branch_id">
						<label><cf_get_lang dictionary_id="57453.Şube"></label>
						<div id="BRANCH_PLACE">
							<select name="branch_id" id="branch_id" onchange="showDepartment(this.value)">
								<option value="all"<cfif isdefined('attributes.branch_id') and attributes.branch_id is "all">selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_our_comp_and_branchs" group="branch_id">
									<option value="#branch_id#"<cfif isdefined('attributes.branch_id') and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-off_validate">
						<label><cf_get_lang dictionary_id='53042.Onay Durumu'></label>
						<select name="filter_process" id="filter_process">
							<option value="" ><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
							<cfoutput query="get_process"> 
								<option value="#process_row_id#" <cfif isdefined("attributes.filter_process") and (process_row_id eq attributes.filter_process)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-DEPARTMENT_PLACE">
						<label><cf_get_lang dictionary_id="57572.Departman"></label>
						<div width="125" id="DEPARTMENT_PLACE">
							<select name="department" id="department">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif attributes.branch_id eq 0 or attributes.branch_id eq ''>
								<cfelseif isdefined('attributes.branch_id') and attributes.branch_id is not "all">
									<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
										SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
									</cfquery>
									<cfoutput query="get_department">
										<option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-dates">
						<label><cf_get_lang dictionary_id="57501.Başlangıç"> - <cf_get_lang dictionary_id="57700.Bitiş Tarihi"></label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlangıç tarihi girmelisiniz'></cfsavecontent>
							<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							<span class="input-group-addon no-bg"></span>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
							<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>

					<div class="form-group">
						<label><cf_get_lang dictionary_id='60286.Batch Document Number'></label>
						<input type="text" name="group_paper_no" id="group_paper_no" placeholder="<cf_get_lang dictionary_id='60286.Batch Document Number'>" value="<cfoutput>#attributes.group_paper_no#</cfoutput>" />
					</div>
				</div>					
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfif isdefined('x_show_total_offdays') and x_show_total_offdays eq 1>
		<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
			SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
		</cfquery>
		<cfset offday_list_ = ''>
		<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
		<cfset halfofftime_list2 = ''>
		<cfset halfofftime_list3 = ''><!--- Bitiş --->
		<cfoutput query="GET_GENERAL_OFFTIMES">
			<cfscript>
				offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
				offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
				offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
				for (mck=0; mck lt offday_gun; mck=mck+1)
				{
					temp_izin_gunu = date_add("d",mck,offday_startdate);
					daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
					if(not listfindnocase(offday_list_,'#daycode#'))
					offday_list_ = listappend(offday_list_,'#daycode#');
					if(GET_GENERAL_OFFTIMES.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
					{
						halfofftime_list = listappend(halfofftime_list,'#daycode#');
					}
				}
				
			</cfscript>
		</cfoutput>	
		<cfquery name="get_hours" datasource="#dsn#">
			SELECT		
				OUR_COMPANY_HOURS.*
			FROM
				OUR_COMPANY_HOURS
			WHERE
				OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfif len(get_hours.recordcount) and len(get_hours.weekly_offday)>
			<cfset this_week_rest_day_ = get_hours.weekly_offday>
		<cfelse>
			<cfset this_week_rest_day_ = 1>
		</cfif>
	</cfif>
	<!--- çalışma saati başlangıç ve bitişleri al--->
	<cfquery name="get_work_time" datasource="#dsn#">
		SELECT 
			PROPERTY_VALUE,
			PROPERTY_NAME
		FROM
			FUSEACTION_PROPERTY
		WHERE
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			FUSEACTION_NAME = 'ehesap.form_add_offtime_popup' AND
			(PROPERTY_NAME = 'start_hour_info' OR
			PROPERTY_NAME = 'start_min_info' OR
			PROPERTY_NAME = 'finish_hour_info' OR
			PROPERTY_NAME = 'finish_min_info' OR
			PROPERTY_NAME = 'finish_am_hour_info' OR
			PROPERTY_NAME = 'finish_am_min_info' OR
			PROPERTY_NAME = 'start_pm_hour_info' OR
			PROPERTY_NAME = 'start_pm_min_info' OR
			PROPERTY_NAME = 'x_min_control'
			)	
	</cfquery>
	<cfif get_work_time.recordcount>
		<cfloop query="get_work_time">	
			<cfif PROPERTY_NAME eq 'start_hour_info'>
				<cfset start_hour = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'start_min_info'>
				<cfset start_min = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'finish_hour_info'>
				<cfset finish_hour = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'finish_min_info'>
				<cfset finish_min = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'finish_am_hour_info'>
				<cfset finish_am_hour = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'finish_am_min_info'>
				<cfset finish_am_min = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'start_pm_hour_info'>
				<cfset start_pm_hour = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'start_pm_min_info'>
				<cfset start_pm_min = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'x_min_control'>
				<cfset x_min_control = PROPERTY_VALUE>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset start_hour = '00'>
		<cfset start_min = '00'>
		<cfset finish_hour = '00'>
		<cfset finish_min = '00'>
		<cfset finish_am_hour = '00'>
		<cfset finish_am_min = '00'>
		<cfset start_pm_hour = '00'>
		<cfset start_pm_min = '00'>
		<cfset x_min_control = 0>
	</cfif>	
	<cfif not isdefined("x_min_control")>
		<cfset x_min_control = 0>
	</cfif>
	<cfif not isdefined("finish_am_hour")>
		<cfset start_hour = '00'>
		<cfset start_min = '00'>
		<cfset finish_hour = '00'>
		<cfset finish_min = '00'>
		<cfset finish_am_hour = '00'>
		<cfset finish_am_min = '00'>
		<cfset start_pm_hour = '00'>
		<cfset start_pm_min = '00'>
	</cfif>
	<cfform name="setProcessForm" id="setProcessForm" method="post" action="">
		<cf_box id="list_offtime_list" closable="0" collapsable="1" uidrop="1" title="#title#" add_href="#request.self#?fuseaction=ehesap.offtimes&event=add"  woc_setting = "#{ checkbox_name : 'print_offtime_id',  print_type : 175 }#"> 
			<input type="hidden" name="box_submitted" id="box_submitted" value="1">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<cfif isdefined('x_show_tc_no') and x_show_tc_no eq 1><th><cf_get_lang dictionary_id='58025.tc kimlik no'></th></cfif>
						<th><cf_get_lang dictionary_id ="32328.Sicil no"></th>
						<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<cfif x_show_branch eq 1>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='35449.Departman'></th>
						<th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
						<th style="width:100px;"><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th style="width:15px;"></th>
						<th style="width:15px;"></th>
						<th><cf_get_lang dictionary_id='53027.Tarihler'></td>
						<th><cf_get_lang dictionary_id='59976.İşbaşı Tarihi'></td>
						<cfif isdefined('x_show_total_offdays') and x_show_total_offdays eq 1>
							<th width="15"><cf_get_lang dictionary_id="57490.Gün"></th>
							<cfif x_min_control eq 1><th align="center"><cf_get_lang dictionary_id="57490.Gün"> / <cf_get_lang dictionary_id='57491.Saat'> / <cf_get_lang dictionary_id='58827.Dk'></th></cfif>
						</cfif>
						<cfif fusebox.circuit is 'ehesap'>
							<th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
						</cfif>
						<cfif isdefined("attributes.off_validate") and attributes.off_validate eq 4><th style=" width:15px;"></th></cfif>
						<cfif fusebox.circuit is 'ehesap'>
						<!-- sil -->
							<th width="20" class="text-center"><a href="<cfoutput>#request.self#?fuseaction=ehesap.offtimes&event=add</cfoutput>" ><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<cfif listfirst(attributes.fuseaction,'.') eq 'ehesap' and len(attributes.filter_process)>
								<th width="20"><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>
							</cfif>
						<!-- sil -->
						<cfelse>
							<th></th>
						</cfif>
						<cfif isdefined("attributes.form_submit") and get_offtimes.recordcount >
							<th width="20" class="text-center">
							<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_offtime_id');"></th>	</cfif>
					</tr>
				</thead>
				<tbody>
					<cfif IsDefined('form_submit')>
						<cfif get_offtimes.recordcount>
							<cfoutput query="get_offtimes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
								<tr <cfif (IS_PUANTAJ_OFF eq 1 and IS_ADDED_OFFTIME neq 1) or SETUP_PUANTAJ_OFF eq 1>title="<cf_get_lang dictionary_id='45462.Bu izin puantajda görünmemektedir.'>" style="color:999999;font-weight:bold;"</cfif> <cfif IS_ADDED_OFFTIME eq 1>title="<cf_get_lang dictionary_id='45457.Bu izin başka bir izne dönüştürülmüştür.'>" style="color:006600;font-weight:bold;"</cfif>>
									<cfif fusebox.circuit is 'ehesap'>
										<td width="25"><a href="#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#offtime_id#" class="tableyazi">#currentrow#</a></td>
									<cfelse>
										<td width="25">#currentrow#</td>
									</cfif>
										
									<cfif isdefined('x_show_tc_no') and x_show_tc_no eq 1>
										<td>#tc_identy_no#</td>
									</cfif>
									<td>
										#EMPLOYEE_NO#
									</td>
									<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','','ui-draggable-box-medium');">#employee_name# #employee_surname#</a></td>
									<cfif x_show_branch eq 1>
										<td>#branch_name#</td>
									</cfif>
									<td>#DEPARTMENT_HEAD#</td>
									<td>#position_name#</td>
									<cfif fusebox.circuit is 'ehesap'>
										<td><a href="#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#offtime_id#&is_view_agenda=#is_view_agenda#&x_event_catid=#x_event_catid#" class="tableyazi">#NEW_CAT_NAME#</a></td>
									<cfelse>
										<td>#NEW_CAT_NAME#</td>
									</cfif>
									<td title="<cfif IS_PLAN eq 1>Planlanan İzin<cfelse>Gerçek İzin</cfif>"><cfif IS_PLAN eq 1>P<cfelse>G</cfif></td>
									<td align="center"><cfif IS_PUANTAJ_OFF eq 1 or SETUP_PUANTAJ_OFF eq 1><strike>&nbsp;P&nbsp;</strike></cfif></td>
									<td><cfif (startdate lt now() and finishdate gt now()) or (startdate eq now() and finishdate gt now())>
											<font color="##FF0000">
											#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#)
											- 
											#dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#)
											</font>
										<cfelse>
											#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#)
											- 
											#dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#)
										</cfif>			
									</td>
									<td>
										#dateformat(date_add('h',session.ep.time_zone,WORK_STARTDATE),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,WORK_STARTDATE),timeformat_style)#)
									</td>
									<cfif isdefined('x_show_total_offdays') and x_show_total_offdays eq 1>
										<cfquery name="get_emp_group_ids" datasource="#dsn#">
											SELECT
												E.EMPLOYEE_ID,
												(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY FINISH_DATE DESC) AS PUANTAJ_GROUP_IDS
											FROM
												EMPLOYEES E
											WHERE
												E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#get_offtimes.employee_id#">
										</cfquery>
										<!--- Çalışanın vardiyalı çalışma saatleri --->
										<cfset finishdate_ = dateadd("d", 1, finishdate)>
										<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : employee_id, start_date : startdate, finish_date : finishdate_, control : 0)>
										<td>
											<cfquery name="get_puantaj_group_id" dbtype="query">
												SELECT PUANTAJ_GROUP_IDS FROM get_emp_group_ids WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
											</cfquery>
											<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
												SELECT LIMIT_ID,SATURDAY_ON,DAY_CONTROL,DAY_CONTROL_AFTERNOON,SUNDAY_ON,PUBLIC_HOLIDAY_ON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
												<cfif len(get_puantaj_group_id.PUANTAJ_GROUP_IDS)>
												(
													<cfloop from="1" to="#listlen(get_puantaj_group_id.puantaj_group_ids)#" index="i">
														','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(get_puantaj_group_id.PUANTAJ_GROUP_IDS,i,',')#,%' <cfif listlen(get_puantaj_group_id.PUANTAJ_GROUP_IDS) neq i>OR</cfif> 
													</cfloop>
												)
												<cfelse>
													PUANTAJ_GROUP_IDS IS NULL
												</cfif>
											</cfquery>
											<cfif get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on)>
												<cfset saturday_on = get_offtime_cat.saturday_on>
											<cfelse>
												<cfset saturday_on = 1>
											</cfif>
											<cfif get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
												<cfset day_control_ = get_offtime_cat.day_control>
											<cfelse>
												<cfset day_control_ = 0>
											</cfif>
											<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
												<cfset day_control_afternoon = get_offtime_cat.day_control_afternoon>
											<cfelse>
												<cfset day_control_afternoon = 0>
											</cfif>
											<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
												<cfset day_control = get_offtime_cat.day_control>
											<cfelse>
												<cfset day_control = 0>
											</cfif>
											<cfif get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on)>
												<cfset sunday_on = get_offtime_cat.sunday_on>
											<cfelse>
												<cfset sunday_on = 0>
											</cfif>
											<cfif get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on)>
												<cfset public_holiday_on = get_offtime_cat.public_holiday_on>
											<cfelse>
												<cfset public_holiday_on = 0>
											</cfif>
											<!--- İzin Hesapları bu dosyada yapılıyor ---->
											<cfif x_min_control eq 1>
												<cfif get_shift.recordcount>
													<cfinclude template="offtime_calc_shift.cfm">
												<cfelse>
													<cfinclude template="offtime_calc.cfm">
												</cfif>
												#TLFormat(total_day_calc,2)# 
											<cfelse>
												<cfif get_shift.recordcount gt 0>
													<cfquery name="get_emp_in_out" datasource="#dsn#">
														SELECT   
															IS_VARDIYA
														FROM
															EMPLOYEES_IN_OUT EI
														WHERE
															EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
														ORDER BY 
															IN_OUT_ID DESC, IS_VARDIYA DESC
													</cfquery>
													<cfif len(get_shift.WEEK_OFFDAY) and get_emp_in_out.IS_VARDIYA eq 2>
														<cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
													<cfelse>
														<cfset this_week_rest_day_ = 1>
													</cfif>
												<cfelse>
													<cfset this_week_rest_day_ = this_week_rest_day_>
												</cfif>
												<cfinclude template="offtime_calc_day.cfm">
												#izin_gun# 
											</cfif>
										</td>
										<cfif x_min_control eq 1>
											<td  align="center">
												<cfsavecontent variable = "day">
													<cf_get_lang dictionary_id ="57490.Gün">
												</cfsavecontent>
												<cfsavecontent variable = "hour">
													<cf_get_lang dictionary_id ="57491.Saat">
												</cfsavecontent>
												<cfsavecontent variable = "min">
													<cf_get_lang dictionary_id ="58827.Dk">
												</cfsavecontent>
												<cfif days neq 0>#days##left(day,1)# </cfif>
												<cfif hours neq 0>#hours##left(hour,1)# </cfif>
												<cfif minutes neq 0>#minutes##min# </cfif>
											</td>
										</cfif>
									</cfif>
									<td id="valid_status_#offtime_id#">
										<cf_workcube_process type="color-status" process_stage="#OFFTIME_STAGE#">
									</td>
									<cfif isdefined("attributes.off_validate") and attributes.off_validate eq 4><td><input type="checkbox" name="offtime_plan_check" id="offtime_plan_check" value="#offtime_id#" /></td></cfif>
									<cfif fusebox.circuit is 'ehesap'>
										<td><a href="#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#offtime_id#&is_view_agenda=#is_view_agenda#&x_event_catid=#x_event_catid#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
									</cfif>
									<cfif listfirst(attributes.fuseaction,'.') eq 'ehesap' and len(attributes.filter_process)>
										<td>
											<input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#offtime_id#"/>
										</td>
									</cfif>
									<td style="text-align:center"><input type="checkbox" name="print_offtime_id" id="print_offtime_id"  value="#offtime_id#"></td>
								</tr>
							</cfoutput> 
							<cfif isdefined("attributes.off_validate") and attributes.off_validate eq 4>
								<tr class="color-row">
									<td colspan="12" style="text-align:right;">
										<select name="select_action" id="select_action">
											<option value="0" <cfif isdefined("attributes.select_action") and attributes.select_action eq 0>selected</cfif>><cf_get_lang dictionary_id ='54282.Talebe dönüştür'></option>
											<option value="1" <cfif isdefined("attributes.select_action") and attributes.select_action eq 1>selected</cfif>><cf_get_lang dictionary_id ='58475.Onayla'></option>
											<option value="2" <cfif isdefined("attributes.select_action") and attributes.select_action eq 2>selected</cfif>><cf_get_lang dictionary_id ='58461.Reddet'></option>
										</select>
										<input type="submit" name="submit_action" id="submit_action" value="İşlem Yap" />
									</td>
								</tr>
							</cfif>
						</cfif>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cfif get_offtimes.recordcount eq 0>
				<div class="ui-info-bottom">
					<p><cfif isDefined('attributes.form_submit') and attributes.form_submit eq 1><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
				</div>
			</cfif>
			<cf_paging
				name="setProcessForm"
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#action_##url_str#"
				is_form="1"
				>
		</cf_box>
		<cfif isdefined("attributes.form_submit") and len(attributes.form_submit) and len(attributes.filter_process)>
			<cf_box id="list_checked" closable="0" title="#getLang('','',46186)#">
				<cf_box_elements vertical="1">
					<div class="col col-4 col-xs-12" type="column" index="1" sort="true">
						<cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
						faction_list : 'ehesap.offtimes',
						filter_stage: '#attributes.filter_process#')>
						<cf_workcube_general_process print_type="175" select_value = '#get_process_f.process_row_id#'>						
					</div>
				</cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="ui-form-list-btn">
						<input type="hidden" id="paper_submit" name="paper_submit" value="0">
						<div>
							<input type="submit" name="setOfftimeProcess" id="setOfftimeProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setofftimesProcess(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
						</div>
					</div>
				</div>
			</cf_box>
		</cfif>
	</cfform>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	$(function(){
            $('input[name=checkAll]').click(function(){
                if(this.checked){
                    $('.checkControl').each(function(){
                        $(this).prop("checked", true);
                    });
                }
                else{
                    $('.checkControl').each(function(){
                        $(this).prop("checked", false);
                    });
                }
            });
        });
	 function setofftimesProcess(){
		var controlChc = 0;
		$('.checkControl').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		});
		if(controlChc == 0){
			alert("İzin Seçiniz");
			return false;
		}
		if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
            	alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
				return false;
			}
		}
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("Lütfen Belge Tarihi Giriniz!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("Lütfen Ek Açıklama Giriniz!");
			return false;
		}
		document.getElementById("paper_submit").value = 1;
		$('#setProcessForm').submit();
		
	}
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="54322.İlişkili Departmanlar">');
		}
	}
	function offtime_valid(valid_type_,offtime_id_)
	{
		div_id = 'offtime_valid'+offtime_id_;
		var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.emptypopup_ajax_offtime_valid&valid_type='+ valid_type_ +'&offtime_id='+offtime_id_;
		AjaxPageLoad(send_address,div_id,1);
	}
	function change_action()
	{
		filter_offtime.action='<cfoutput>#request.self#?fuseaction=ehesap.offtimes</cfoutput>';
		filter_offtime.target='';
		return true;
	}
	function send_pdf_print()
	{
		windowopen('','page','print_window');
		filter_offtime.action='<cfoutput>#request.self#?fuseaction=ehesap.popup_offtimes_pdf_print</cfoutput>';
		filter_offtime.target='print_window';
		filter_offtime.submit();
	}
	function change_action()
	{
		if( !date_check(document.all.filter_offtime.startdate, document.all.filter_offtime.finishdate, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}
	/* function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	} */
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">