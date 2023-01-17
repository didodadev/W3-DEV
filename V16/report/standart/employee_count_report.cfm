<!--- Calisan Sayilari Raporu created by: GSO 20140722--->
<cfsetting showdebugoutput="false">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.education" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.inout_statue" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.org_step_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.pos_cat_id" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.yas" default="">
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../../hr/query/get_edu_level.cfm">
<cfif isdefined('attributes.report_base') and attributes.report_base eq 1 and isdate(attributes.start_date) and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.start_date">
	<cf_date tarih = "attributes.finish_date">
	<cfset attributes.startdate = "#day(attributes.start_date)#/#month(attributes.start_date)#/#year(attributes.start_date)#">
	<cfset attributes.finishdate = "#day(attributes.finish_date)#/#month(attributes.finish_date)#/#year(attributes.finish_date)#">
	<cf_date tarih = "attributes.startdate">
	<cf_date tarih = "attributes.finishdate">
<cfelseif isdefined('attributes.report_base') and attributes.report_base eq 0 and isdate(attributes.start_date) and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.start_date">
	<cf_date tarih = "attributes.finish_date">
	<cfset attributes.startdate = "#day(attributes.start_date)#/#month(attributes.start_date)#/#year(attributes.start_date)#">
	<cfset attributes.finishdate = "#day(attributes.finish_date)#/#month(attributes.finish_date)#/#year(attributes.finish_date)#">
	<cf_date tarih = "attributes.startdate">
	<cf_date tarih = "attributes.finishdate">
<cfelseif not (isdefined('attributes.report_base') and len(attributes.report_base))>
	<cfset attributes.startdate = "#day(now())#/#month(now())#/#year(now())#">
	<cfset attributes.finishdate = "#day(now())#/#month(now())#/#year(now())#">
	<cf_date tarih = "attributes.startdate">
	<cf_date tarih = "attributes.finishdate">
</cfif>
<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company(is_control : 1);
	cmp_zone = createObject("component","V16.hr.cfc.get_zones");
	cmp_zone.dsn = dsn;
	get_zone = cmp_zone.get_zone();
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(comp_id : '#iif(len(attributes.comp_id),"attributes.comp_id",DE(""))#', ehesap_control : 1);
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	get_title = cmp_title.get_title();
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cat = cmp_pos_cat.get_position_cat();
	cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_org_step = cmp_org_step.get_organization_step();
	cmp_func = createObject("component","V16.hr.cfc.get_functions");
	cmp_func.dsn = dsn;
	get_func = cmp_func.get_function();
	url_str = "";
	if(isdefined('attributes.form_submitted'))
		url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
	if(isdefined('attributes.comp_id') and len(attributes.comp_id))
		url_str = "#url_str#&comp_id=#attributes.comp_id#";
	if(isdefined('attributes.branch_id') and len(attributes.branch_id))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if(isdefined('attributes.zone_id') and len(attributes.zone_id))
		url_str = "#url_str#&zone_id=#attributes.zone_id#";
	if(isdefined('attributes.department') and len(attributes.department))
		url_str = "#url_str#&department=#attributes.department#";
	if(isdefined('attributes.title_id') and len(attributes.title_id))
		url_str = "#url_str#&title_id=#attributes.title_id#";
	if(isdefined('attributes.collar_type') and len(attributes.collar_type))
		url_str = "#url_str#&collar_type=#attributes.collar_type#";
	if(isdefined('attributes.pos_cat_id') and len(attributes.pos_cat_id))
		url_str = "#url_str#&pos_cat_id=#attributes.pos_cat_id#";
	if(isdefined('attributes.org_step_id') and len(attributes.org_step_id))
		url_str = "#url_str#&org_step_id=#attributes.org_step_id#";
	if(isdefined('attributes.func_id') and len(attributes.func_id))
		url_str = "#url_str#&func_id=#attributes.func_id#";
	if(isdefined('attributes.status') and len(attributes.status))
		url_str = "#url_str#&status=#attributes.status#";
	if(isdefined('attributes.blood_type') and len(attributes.blood_type))
		url_str = "#url_str#&blood_type=#attributes.blood_type#";
	if(isdefined('attributes.gender') and len(attributes.gender))
		url_str = "#url_str#&gender=#attributes.gender#";
	if(isdefined('attributes.education') and len(attributes.education))
		url_str = "#url_str#&education=#attributes.education#";
	if(isdefined('attributes.inout_statue') and len(attributes.inout_statue))
		url_str = "#url_str#&inout_statue=#attributes.inout_statue#";
	if(isdefined('attributes.defection_level') and len(attributes.defection_level))
		url_str = "#url_str#&defection_level=#attributes.defection_level#";
	if(isdefined('attributes.duty_type') and len(attributes.duty_type))
		url_str = "#url_str#&duty_type=#attributes.duty_type#";
	if(isdefined('attributes.use_ssk') and len(attributes.use_ssk))
		url_str = "#url_str#&use_ssk=#attributes.use_ssk#";
	if(isdefined('attributes.ssk_statute') and len(attributes.ssk_statute))
		url_str = "#url_str#&ssk_statute=#attributes.ssk_statute#";
	if(isdefined('attributes.startdate') and len(attributes.startdate))
		url_str = "#url_str#&start_date=#dateformat(attributes.startdate,dateformat_style)#";
	if(isdefined('attributes.finishdate') and len(attributes.finishdate))
		url_str = "#url_str#&finish_date=#dateformat(attributes.finishdate,dateformat_style)#";
	if(isdefined('attributes.report_type') and len(attributes.report_type))
		url_str = "#url_str#&report_type=#attributes.report_type#";
	if(isdefined("attributes.report_base") and len(attributes.report_base))
		url_str = "#url_str#&report_base=#attributes.report_base#";
	if(isdefined('is_get_pos_chng') and len(attributes.is_get_pos_chng))
		url_str = "#url_str#&is_get_pos_chng=#attributes.is_get_pos_chng#";
	if(isdefined('is_all_dep') and len(attributes.is_all_dep))
		url_str = "#url_str#&is_all_dep=#attributes.is_all_dep#";
</cfscript>
<cfif isdefined("attributes.form_submitted")>
	<cfscript>
		cmp = createObject("component","V16.report.cfc.get_employee_count");
		cmp.dsn = dsn;
		get_employee_count = cmp.get_emp_count(
		startrow : attributes.startrow,
		maxrows : attributes.maxrows,
		comp_id : attributes.comp_id,
		branch_id : attributes.branch_id,
		zone_id : attributes.zone_id,
		title_id : attributes.title_id,
		department : attributes.department,
		report_type : attributes.report_type,
		pos_cat_id : attributes.pos_cat_id,
		org_step_id : attributes.org_step_id,
		func_id : attributes.func_id,
		status : attributes.status,
		is_get_pos_chng : '#iif(isdefined("attributes.is_get_pos_chng"),"attributes.is_get_pos_chng",DE(""))#',
		collar_type : '#iif(isdefined("attributes.collar_type"),"attributes.collar_type",DE(""))#',
		blood_type : '#iif(isdefined("attributes.blood_type"),"attributes.blood_type",DE(""))#',
		gender : '#iif(isdefined("attributes.gender"),"attributes.gender",DE(""))#',
		education : attributes.education,
		inout_statue : attributes.inout_statue,
		defection_level : '#iif(isdefined("attributes.defection_level"),"attributes.defection_level",DE(""))#',
		duty_type : '#iif(isdefined("attributes.duty_type"),"attributes.duty_type",DE(""))#',
		ssk_statute : '#iif(isdefined("attributes.ssk_statute"),"attributes.ssk_statute",DE(""))#',
		use_ssk : '#iif(isdefined("attributes.use_ssk"),"attributes.use_ssk",DE(""))#',
		start_date : '#iif(isdefined("attributes.startdate"),"attributes.startdate",DE(""))#',
		finish_date : '#iif(isdefined("attributes.finishdate"),"attributes.finishdate",DE(""))#',
		is_all_dep : '#iif(isdefined("attributes.is_all_dep"),"attributes.is_all_dep",DE(""))#');
	</cfscript>
	<cfif attributes.report_type neq 17>
		<cfquery name="get_type_result" dbtype="query">
			SELECT DISTINCT 
				<cfif attributes.report_type eq 1>COMPANY_NAME,COMP_ID
				<cfelseif attributes.report_type eq 2>ZONE_NAME,ZONE_ID
				<cfelseif attributes.report_type eq 3>BRANCH_NAME,BRANCH_ID
				<cfelseif attributes.report_type eq 4>DEPARTMENT_ID,DEPARTMENT_HEAD
				<cfelseif attributes.report_type eq 5>POSITION_CAT,POSITION_CAT_ID
				<cfelseif attributes.report_type eq 6>TITLE,TITLE_ID
				<cfelseif attributes.report_type eq 7>UNIT_NAME,UNIT_ID
				<cfelseif attributes.report_type eq 8>ORGANIZATION_STEP_NAME,ORGANIZATION_STEP_ID
				<cfelseif attributes.report_type eq 9>COLLAR_TYPE
				<cfelseif attributes.report_type eq 10>YAS
				<cfelseif attributes.report_type eq 11>EDUCATION_NAME,EDU_LEVEL_ID
				<cfelseif attributes.report_type eq 12>DEFECTION_LEVEL
				<cfelseif attributes.report_type eq 13>USE_SSK
				<cfelseif attributes.report_type eq 14>SSK_STATUTE
				<cfelseif attributes.report_type eq 15>SEX
				<cfelseif attributes.report_type eq 16>BLOOD_TYPE
				<cfelseif attributes.report_type eq 18>DUTY_TYPE
				</cfif>
			FROM
				get_employee_count
			ORDER BY
				<cfif attributes.report_type eq 1>COMP_ID,COMPANY_NAME
				<cfelseif attributes.report_type eq 2>ZONE_ID,ZONE_NAME
				<cfelseif attributes.report_type eq 3>BRANCH_ID,BRANCH_NAME
				<cfelseif attributes.report_type eq 4>DEPARTMENT_ID,DEPARTMENT_HEAD
				<cfelseif attributes.report_type eq 5>POSITION_CAT_ID,POSITION_CAT
				<cfelseif attributes.report_type eq 6>TITLE_ID,TITLE
				<cfelseif attributes.report_type eq 7>UNIT_ID,UNIT_NAME
				<cfelseif attributes.report_type eq 8>ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME
				<cfelseif attributes.report_type eq 9>COLLAR_TYPE
				<cfelseif attributes.report_type eq 10>YAS
				<cfelseif attributes.report_type eq 11>EDU_LEVEL_ID,EDUCATION_NAME
				<cfelseif attributes.report_type eq 12>DEFECTION_LEVEL
				<cfelseif attributes.report_type eq 13>USE_SSK
				<cfelseif attributes.report_type eq 14>SSK_STATUTE
				<cfelseif attributes.report_type eq 15>SEX
				<cfelseif attributes.report_type eq 16>BLOOD_TYPE
				<cfelseif attributes.report_type eq 18>DUTY_TYPE</cfif>
		</cfquery>
	<cfelse>
		<cfset get_type_result.recordcount = 0>
	</cfif>
<cfelse>
	<cfset get_type_result.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_type_result.recordcount#'>
<cfform name="rapor" action="#request.self#?fuseaction=report.employee_count_report" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40398.Çalışan Sayıları Raporu'></cfsavecontent>
	<cf_report_list_search id="count_report" title="#title#">	
		<cf_report_list_search_area>		
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<div class="row">					
				<div class="col col-12 col-xs-12">										
					<div class="row formContent">
						<cfsavecontent variable="title"><cf_get_lang dictionary_id='57972.Organizasyon'></cfsavecontent>
						<cf_seperator id="organizasyon_" header="#title#" is_closed="0">
						<div class="row" type="row" id="organizasyon_">	
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12" >								
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z5">
											<cf_multiselect_check
												query_name="get_company"
												name="comp_id"
												width="140"
												option_value="COMP_ID"
												option_name="COMPANY_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.comp_id#"
												onchange="get_branch_list(this.value)">
										</div>
									</div>
								</div>															
							</div>	
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12" >
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
									<div class="col col-12 col-xs-12">
										<div id="BRANCH_PLACE" class="multiselect-z5">
											<cf_multiselect_check 
												query_name="get_branches"  
												name="branch_id"
												width="140" 
												option_value="BRANCH_ID"
												option_name="BRANCH_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.branch_id#"
												onchange="get_department_list(this.value)">
										</div>
									</div>
								</div>									
							</div>																			
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12" >								
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57992.Bölge'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z4">
											<cf_multiselect_check
												query_name="get_zone"
												name="zone_id"
												width="140"
												option_value="ZONE_ID"
												option_name="ZONE_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.zone_id#">
										</div>
									</div>
								</div>					
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">														
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
									<div class="col col-12 col-xs-12">
										<div id="DEPARTMENT_PLACE" class="multiselect-z4">
											<cf_multiselect_check 
												query_name="get_department"  
												name="department"
												width="140" 
												option_value="DEPARTMENT_ID"
												option_name="DEPARTMENT_HEAD"
												option_text="#getLang('main',322)#"
												value="#attributes.department#"
												onchange="alt_departman_chckbx(this.value);">
										</div>
									</div>
								</div>
							</div>
						</div>
						<cfsavecontent variable="header"><cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
						<cf_seperator id="pozisyon_" header="#header#" is_closed="0">
						<div class="row" type="row" id="pozisyon_">							
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12" >								
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z3">
											<cf_multiselect_check
												query_name="get_title"
												name="title_id"
												width="140"
												option_value="TITLE_ID"
												option_name="TITLE"
												option_text="#getLang('main',322)#"
												value="#attributes.title_id#">
										</div>
									</div>
								</div>
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z2">
											<cf_multiselect_check
												query_name="get_position_cat"
												name="pos_cat_id"
												width="140"
												option_value="POSITION_CAT_ID"
												option_name="POSITION_CAT"
												option_text="#getLang('main',322)#"
												value="#attributes.pos_cat_id#">
										</div>
									</div>
								</div>																					
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">	
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z1">
											<cf_multiselect_check
												query_name="get_func"
												name="func_id"
												width="140"
												option_value="unit_id"
												option_name="unit_name"
												option_text="#getLang('main',322)#"
												value="#attributes.func_id#">
										</div>
									</div>
								</div>								
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">							
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38908.Yaka Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="collar_type" id="collar_type" style="width:145px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1" <cfif isdefined('attributes.collar_type') and attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='38910.Mavi Yaka'></option> 
												<option value="2" <cfif isdefined('attributes.collar_type') and attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='38911.Beyaz Yaka'></option>
											</select>
										</div>
								</div>								
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58710.Kademe'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z2">
											<cf_multiselect_check
												query_name="get_org_step"
												name="org_step_id"
												width="140"
												option_value="ORGANIZATION_STEP_ID"
												option_name="ORGANIZATION_STEP_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.org_step_id#">
										</div>
									</div>
								</div>		
								
							</div>
						</div>		
						<cf_seperator id="eprofil_" header="#getLang('main',578)#" is_closed="0">			
						<div class="row"  type="row" id="eprofil_">																		
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12" >								
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
									<div class="col col-12 col-xs-12">
										<select name="status" id="status" style="width:145px;">
											<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
											<option value="1" <cfif isdefined('attributes.status') and attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option> 
											<option value="0" <cfif isdefined('attributes.status') and attributes.status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
										</select>
									</div>
								</div>																	
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">						
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
									<div class="col col-12 col-xs-12">
										<select name="gender" id="gender" style="width:145px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif isdefined('attributes.gender') and attributes.gender eq 1> selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'></option> 
											<option value="0" <cfif isdefined('attributes.gender') and attributes.gender eq 0> selected</cfif>><cf_get_lang dictionary_id='58958.Kadın'></option>
										</select>
									</div>
								</div>	
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">						
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39708.Eğitim Durumu'></label>
										<div class="col col-12 col-xs-12">
											<select name="education" id="education" style="width:145px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_edu_level">
													<option value="#edu_level_id#" <cfif attributes.education eq edu_level_id >selected</cfif>>#education_name#</option>	
												</cfoutput>
											</select>
										</div>
								</div>						
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12" >
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
									<div class="col col-12 col-xs-12">
										<select name="blood_type" id="blood_type">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="0" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 0> selected</cfif>>0 Rh+</option> 
											<option value="1" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 1> selected</cfif>>0 Rh-</option>
											<option value="2" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 2> selected</cfif>>A Rh+</option>
											<option value="3" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 3> selected</cfif>>A Rh-</option>
											<option value="4" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 4> selected</cfif>>B Rh+</option>
											<option value="5" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 5> selected</cfif>>B Rh-</option>
											<option value="6" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 6> selected</cfif>>AB Rh+</option>
											<option value="7" <cfif isdefined('attributes.blood_type') and attributes.blood_type eq 7> selected</cfif>>AB Rh-</option>
										</select>
									</div>
								</div>											
							</div>
						</div>
						<cfsavecontent variable="header"><cf_get_lang dictionary_id='40057.Ücret'></cfsavecontent>
						<cf_seperator id="ucret_" header="#header#" is_closed="0">			
						<div class="row"  type="row" id="ucret_">																		
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12" >								
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39082.Çalışma Durumu'></label>
									<div class="col col-12 col-xs-12">
										<select name="inout_statue" id="inout_statue" style="width:145px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="3"<cfif attributes.inout_statue eq 3> selected</cfif>><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></option>
											<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
											<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
											<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='39083.Aktif Çalışanlar'></option>
										</select>
									</div>
								</div>
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39085.Sakatlık Derecesi'></label>
									<div class="col col-12 col-xs-12">
										<select name="defection_level" id="defection_level" style="width:145px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="0" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
											<option value="1" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 1>selected</cfif>>1</option>
											<option value="2" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 2>selected</cfif>>2</option>
											<option value="3" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 3>selected</cfif>>3</option>
										</select> 
									</div>
								</div>											
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">						
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40323.SGK Durumu'></label>
									<div class="col col-12 col-xs-12">
										<select name="use_ssk" id="use_ssk" style="width:145px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif isdefined("attributes.use_ssk") and attributes.use_ssk eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
											<option value="0" <cfif isdefined("attributes.use_ssk") and attributes.use_ssk eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
										</select>
									</div>
								</div>									
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38993.SGK Statüsü'></label>
									<div class="col col-12 col-xs-12">
										<select name="ssk_statute" id="ssk_statute" style="width:145px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfset count_ = 0>
											<cfloop list="#list_ucret()#" index="ccn">
												<cfset count_ = count_ + 1>
												<cfoutput><option value="#ccn#" <cfif isdefined("attributes.ssk_statute") and attributes.ssk_statute eq ccn>selected</cfif>>#listgetat(list_ucret_names(),count_,'*')#</option></cfoutput>
											</cfloop>
										</select>
									</div>
								</div>	
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">						
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="duty_type" id="duty_type" style="width:145px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="2" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
												<option value="1" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 1>selected</cfif>><cf_get_lang dictionary_id='38967.İşveren Vekili'></option>
												<option value="0" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 0>selected</cfif>><cf_get_lang dictionary_id='38968.İşveren'></option>
												<option value="3" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39111.Sendikalı'></option>
												<option value="4" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 4>selected</cfif>><cf_get_lang dictionary_id='39113.Sözleşmeli'></option>
												<option value="5" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 5>selected</cfif>><cf_get_lang dictionary_id='39146.Kapsam dışı'></option>
												<option value="6" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 6>selected</cfif>><cf_get_lang dictionary_id='39152.Kısmi İstihdam'></option>
												<option value="7" <cfif isdefined("attributes.duty_type") and attributes.duty_type eq 7>selected</cfif>><cf_get_lang dictionary_id='39156.Taşeron'></option>
											</select>
										</div>
								</div>						
							</div>
						</div>						
					</div>
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12 ">
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12 col-xs-12">
										<select name="report_type" id="report_type">
											<option value="1" <cfif isdefined("attributes.report_type") and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57574.Şirket'></option>
											<option value="2" <cfif isdefined("attributes.report_type") and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57992.Bölge'></option>
											<option value="3" <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
											<option value="4" <cfif isdefined("attributes.report_type") and attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
											<option value="5" <cfif isdefined("attributes.report_type") and attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></option>
											<option value="6" <cfif isdefined("attributes.report_type") and attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id='57571.Ünvan'></option>
											<option value="7" <cfif isdefined("attributes.report_type") and attributes.report_type eq 7>selected</cfif>><cf_get_lang dictionary_id='58701.Fonksiyon'></option>
											<option value="8" <cfif isdefined("attributes.report_type") and attributes.report_type eq 8>selected</cfif>><cf_get_lang dictionary_id='58710.Kademe'></option>
											<option value="9" <cfif isdefined("attributes.report_type") and attributes.report_type eq 9>selected</cfif>><cf_get_lang dictionary_id='38908.Yaka Tipi'></option>
											<option value="10" <cfif isdefined("attributes.report_type") and attributes.report_type eq 10>selected</cfif>><cf_get_lang dictionary_id='39531.Yaş Aralığı'></option>
											<option value="11" <cfif isdefined("attributes.report_type") and attributes.report_type eq 11>selected</cfif>><cf_get_lang dictionary_id='39708.Eğitim Durumu'></option>
											<option value="12" <cfif isdefined("attributes.report_type") and attributes.report_type eq 12>selected</cfif>><cf_get_lang dictionary_id='39085.Sakatlık Derecesi'></option>
											<option value="13" <cfif isdefined("attributes.report_type") and attributes.report_type eq 13>selected</cfif>><cf_get_lang dictionary_id='40323.SGK Durumu'></option>
											<option value="14" <cfif isdefined("attributes.report_type") and attributes.report_type eq 14>selected</cfif>><cf_get_lang dictionary_id='38993.SGK Statüsü'></option>
											<option value="15" <cfif isdefined("attributes.report_type") and attributes.report_type eq 15>selected</cfif>><cf_get_lang dictionary_id='57764.Cinsiyet'></option>
											<option value="16" <cfif isdefined("attributes.report_type") and attributes.report_type eq 16>selected</cfif>><cf_get_lang dictionary_id='58441.Kan Grubu'></option>
											<option value="17" <cfif isdefined("attributes.report_type") and attributes.report_type eq 17>selected</cfif>><cf_get_lang dictionary_id='39082.Çalışma Durumu'></option>
											<option value="18" <cfif isdefined("attributes.report_type") and attributes.report_type eq 18>selected</cfif>><cf_get_lang dictionary_id='58538.Görev Tipi'></option>
										</select>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12 ">
								<div class="form-group">
									<div class="col col-6 col-xs-12">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></cfsavecontent>
											<cfinput value="#dateformat(attributes.start_date,dateformat_style)#" type="text" id="start_date" name="start_date" message="#alert#" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
										</div>	
									</div>							
									</div>
									<div class="col col-6 col-xs-12">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarih'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="alert2"><cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
											<cfinput value="#dateformat(attributes.finish_date,dateformat_style)#" type="text" id="finish_date" name="finish_date" message="#alert2#" validate="#validate_style#">												
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
										</div>											
									</div>
								</div>
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12 ">
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39174.Rapor Baz'></label>
									<div class="col col-12 col-xs-12">
										<select name="report_base" id="report_base">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif isdefined("attributes.report_base") and attributes.report_base eq 1>selected</cfif>><cf_get_lang dictionary_id='40698.Ay bazında'></option>
											<option value="0" <cfif isdefined("attributes.report_base") and attributes.report_base eq 0>selected</cfif>><cf_get_lang dictionary_id='60699.Yıl bazında'></option>
										</select>											
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12 ">
								<div class="form-group">
									<div class="col col-12 col-xs-12">
										<label><input type="checkbox" name="is_get_pos_chng" id="is_get_pos_chng" value="1" <cfif isdefined('attributes.is_get_pos_chng')>checked</cfif>><cf_get_lang dictionary_id='64916.Görev Değişikliği Al'></label>  							
									</div>
									<div class="col col-12 col-xs-12">													
										<div id="alt_departman_td" style="<cfif not(isdefined('attributes.department') and len(attributes.department))>display:none;</cfif>">
											<label><input type="checkbox" name="is_all_dep" id="is_all_dep" value="1" <cfif isdefined('attributes.is_all_dep')>checked</cfif>><cf_get_lang dictionary_id='45397.Alt Departmanları Getir'></label> 
										</div>
									</div>
								</div>
							</div>
						</div>	
					</div>	
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>				
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
							<cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1' is_excel='1'>
						</div>
            		</div>																	
			    </div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.form_submitted")>
	<cfif attributes.is_excel eq 1>
		<cfset filename="employee_count_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_type_result.recordcount>
	</cfif>
	<cf_report_list>		
		<thead>
			<tr>
				<th>&nbsp;</th>
				<cfif isdefined('attributes.report_base') and len(attributes.report_base) and attributes.report_base eq 1 and isdefined('attributes.startdate') and len(attributes.startdate) and isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfset temp_start = attributes.startdate>
					<cfset temp_finish = CreateDate(year(attributes.finish_date),month(attributes.finish_date),day(attributes.finish_date))>
					<cfloop condition = "DateCompare(temp_finish, temp_start) gte 0">
						<th><cfoutput>#ListGetAt(ay_list(), month(temp_start),',')#</cfoutput></th>
						<cfset temp_start = "1/#month(temp_start)#/#year(temp_start)#">
						<cf_date tarih = "temp_start">
						<cfset temp_start = dateadd("m",1,temp_start)>
					</cfloop>
				<cfelseif isdefined('attributes.report_base') and len(attributes.report_base) and attributes.report_base eq 0 and isdefined('attributes.startdate') and len(attributes.startdate) and isdefined('attributes.finishdate') and len(attributes.finishdate)>
					<cfset temp_start = attributes.startdate>
					<cfset temp_finish = CreateDate(year(attributes.finish_date),12,1)>
					<cfloop condition = "DateCompare(temp_finish, temp_start) gte 0">
						<th><cfoutput>#year(temp_start)#</cfoutput></th>
						<cfset temp_start = "1/1/#year(temp_start)#">
						<cf_date tarih = "temp_start">
						<cfset temp_start = dateadd("yyyy",1,temp_start)>
					</cfloop>
				<cfelse>
					<th><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></th>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfif attributes.report_type neq 17 and get_type_result.recordcount>
				<cfoutput query="get_type_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>
							<cfif attributes.report_type eq 1><cfif len(comp_id)>#company_name#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 2><cfif len(zone_id)>#zone_name#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 3><cfif len(branch_id)>#branch_name#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 4><cfif len(department_id)>#department_head#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 5><cfif len(position_cat_id)>#position_cat#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 6><cfif len(title_id)>#title#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 7><cfif len(unit_id)>#unit_name#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 8><cfif len(organization_step_id)>#organization_step_name#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 9>
								<cfif collar_type eq 1>
									<cf_get_lang dictionary_id='38910.Mavi Yaka'>
								<cfelseif collar_type eq 2>
									<cf_get_lang dictionary_id='38911.Beyaz Yaka'>
								<cfelseif not len(collar_type)>
									<cf_get_lang dictionary_id='58156.Diğer'>
								</cfif>
							<cfelseif attributes.report_type eq 10>
								<cfif yas eq 0><cf_get_lang dictionary_id='58156.Diğer'>
								<cfelseif yas eq 1>- 18
								<cfelseif yas eq 2>19 - 24
								<cfelseif yas eq 3>25 - 34
								<cfelseif yas eq 4>35 - 54
								<cfelseif yas eq 5>55 +</cfif>
							<cfelseif attributes.report_type eq 11><cfif len(edu_level_id)>#education_name#<cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif>
							<cfelseif attributes.report_type eq 12>
								<cfif defection_level eq 0>
									<cf_get_lang dictionary_id='58546.Yok'>
								<cfelse>
									#defection_level#
								</cfif>
							<cfelseif attributes.report_type eq 13>
								<cfif use_ssk eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelseif use_ssk eq 0><cf_get_lang dictionary_id='57496.Hayır'></cfif>
							<cfelseif attributes.report_type eq 14>
								<cfif not len(ssk_statute)>
									<cf_get_lang dictionary_id='58156.Diğer'>
								<cfelse>
									#listgetat(list_ucret_names(),listfind(list_ucret(),ssk_statute,','),'*')#
								</cfif>
							<cfelseif attributes.report_type eq 15>
								<cfif sex eq 0><cf_get_lang dictionary_id='58958.Kadın'><cfelseif sex eq 1><cf_get_lang dictionary_id='58959.Erkek'></cfif>
							<cfelseif attributes.report_type eq 16>
								<cfif not len(blood_type)>
									<cf_get_lang dictionary_id='58156.Diğer'>
								<cfelse>
									<cfif blood_type eq 0>0 Rh+
									<cfelseif blood_type eq 1>0 Rh-
									<cfelseif blood_type eq 2>A Rh+
									<cfelseif blood_type eq 3>A Rh-
									<cfelseif blood_type eq 4>B Rh+
									<cfelseif blood_type eq 5>B Rh-
									<cfelseif blood_type eq 6>AB Rh+
									<cfelseif blood_type eq 7>AB Rh-
									</cfif>
								</cfif>
							<cfelseif attributes.report_type eq 18>
								<cfif not len(duty_type)>
									<cf_get_lang dictionary_id='58156.Diğer'>
								<cfelse>
									<cfif duty_type eq 0><cf_get_lang dictionary_id='38968.İşveren'>
									<cfelseif duty_type eq 1><cf_get_lang dictionary_id='38967.İşveren Vekili'>
									<cfelseif duty_type eq 2><cf_get_lang dictionary_id='57576.Çalışan'>
									<cfelseif duty_type eq 3><cf_get_lang dictionary_id='39111.Sendikalı'>
									<cfelseif duty_type eq 4><cf_get_lang dictionary_id='39113.Sözleşmeli'>
									<cfelseif duty_type eq 5><cf_get_lang dictionary_id='39146.Kapsam dışı'>
									<cfelseif duty_type eq 6><cf_get_lang dictionary_id='39152.Kısmi İstihdam'>
									<cfelseif duty_type eq 7><cf_get_lang dictionary_id='39156.Taşeron'>
									</cfif>
								</cfif>
							</cfif>
						</td>
						<cfif isdefined('attributes.report_base') and attributes.report_base eq 1 and isdefined('attributes.startdate') and len(attributes.startdate) and isdefined('attributes.finishdate') and len(attributes.finishdate)>
							<cfset temp_start = attributes.startdate>
							<cfset temp_finish = CreateDate(year(attributes.finish_date),month(attributes.finish_date),1)>
						<cfelseif isdefined('attributes.report_base') and attributes.report_base eq 0 and isdefined('attributes.startdate') and len(attributes.startdate) and isdefined('attributes.finishdate') and len(attributes.finishdate)>
							<cfset temp_start = attributes.startdate>
							<cfset temp_finish = attributes.finish_date>
						</cfif>
						<cfif isdefined('attributes.report_base') and len(attributes.report_base) and isdefined('temp_start') and isdefined('temp_finish')>
							<cfloop condition = "DateCompare(temp_finish, temp_start) gte 0">
								<cfif attributes.report_base eq 1>
									<cfif month(temp_start) eq month(attributes.finish_date)>
										<cfset qry_finish = attributes.finish_date>
									<cfelse>
										<cfset qry_finish = CreateDate(year(temp_start),month(temp_start),DaysInMonth(CreateDate(year(temp_start),month(temp_start),1)))>
									</cfif>
								<cfelseif attributes.report_base eq 0>
									<cfif year(temp_start) eq year(attributes.finish_date)>
										<cfset qry_finish = temp_finish>
									<cfelse>
										<cfset qry_finish = CreateDate(year(temp_start),12,DaysInMonth(CreateDate(year(temp_start),12,1)))>
									</cfif>
								</cfif>
								<cfquery name="get_count" dbtype="query">
									SELECT 
										<cfif attributes.report_type eq 3>
											EMPLOYEE_ID 
										<cfelseif attributes.report_type eq 1>
											DISTINCT EMPLOYEE_ID,COMP_ID,COMPANY_NAME
										<cfelse>
											COUNT(EMPLOYEE_ID) AS TOTAL_COUNT 	
										</cfif>
									FROM 
										get_employee_count 
									WHERE 
										<cfif attributes.report_type eq 1>COMP_ID = #comp_id#
										<cfelseif attributes.report_type eq 2>ZONE_ID = #zone_id#
										<cfelseif attributes.report_type eq 3>BRANCH_ID = #branch_id#
										<cfelseif attributes.report_type eq 4>DEPARTMENT_ID = #department_id#
										<cfelseif attributes.report_type eq 5>POSITION_CAT_ID = #position_cat_id#
										<cfelseif attributes.report_type eq 6>TITLE_ID <cfif len(title_id)>= #title_id#<cfelse>IS NULL</cfif>
										<cfelseif attributes.report_type eq 7>UNIT_ID <cfif len(unit_id)>= #unit_id#<cfelse>IS NULL</cfif>
										<cfelseif attributes.report_type eq 8>ORGANIZATION_STEP_ID <cfif len(organization_step_id)>= #organization_step_id#<cfelse>IS NULL</cfif>
										<cfelseif attributes.report_type eq 9>COLLAR_TYPE <cfif len(collar_type)>= #collar_type#<cfelse>IS NULL</cfif>
										<cfelseif attributes.report_type eq 10>YAS = #yas#
										<cfelseif attributes.report_type eq 11>EDU_LEVEL_ID <cfif len(edu_level_id)>= #edu_level_id#<cfelse>IS NULL</cfif>
										<cfelseif attributes.report_type eq 12>DEFECTION_LEVEL = #defection_level#
										<cfelseif attributes.report_type eq 13>USE_SSK = #use_ssk#
										<cfelseif attributes.report_type eq 14>SSK_STATUTE <cfif len(ssk_statute)>= #ssk_statute#<cfelse>IS NULL</cfif> 
										<cfelseif attributes.report_type eq 15>SEX = #sex#
										<cfelseif attributes.report_type eq 16>BLOOD_TYPE <cfif len(blood_type)>= #blood_type#<cfelse>IS NULL</cfif>
										<cfelseif attributes.report_type eq 18>DUTY_TYPE <cfif len(duty_type)>= #duty_type#<cfelse>IS NULL</cfif></cfif> 
										<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
											<cfif isdefined('temp_start') and isdate(temp_start)>
												AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">
											</cfif>
											<cfif isdefined('qry_finish') and isdate(qry_finish)>
												AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
											</cfif>
										<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
											<cfif isdefined('temp_start') and isdate(temp_start)>
												AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
											</cfif>
											<cfif isdefined('qry_finish') and isdate(qry_finish)>
												AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
											</cfif>
											AND	FINISH_DATE IS NOT NULL
										<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
											AND 
											(
												<cfif isdate(temp_start) or isdate(qry_finish)>
													<cfif isdate(temp_start) and not isdate(qry_finish)>
													(
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">)
														OR
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE IS NULL)
													)
													<cfelseif not isdate(temp_start) and isdate(qry_finish)>
													(
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#"> AND FINISH_DATE IS NULL)
													)
													<cfelse>
													(
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE IS NULL)
														OR
														(START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
													)
													</cfif>
												<cfelse>
													FINISH_DATE IS NULL
												</cfif>
											)
										<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
											AND 
											(
												(
													START_DATE IS NOT NULL
													<cfif isdefined('temp_start') and isdate(temp_start)>
														AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">
													</cfif>
													<cfif isdefined('qry_finish') and isdate(qry_finish)>
														AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
													</cfif>
												)
												OR
												(
													START_DATE IS NOT NULL
													<cfif isdefined('temp_start') and isdate(temp_start)>
														AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">
													</cfif>
													<cfif isdefined('qry_finish') and isdate(qry_finish)>
														AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
													</cfif>
												)
											)
										<cfelse>
											AND 
											(
												<cfif isdate(temp_start) or isdate(qry_finish)>
													(
														(START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#"> AND FINISH_DATE IS NULL)
														OR
														(START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
													)
												<cfelse>
													FINISH_DATE IS NULL
												</cfif>
											)
										</cfif>
									GROUP BY
										<cfif attributes.report_type eq 1>EMPLOYEE_ID,COMP_ID,COMPANY_NAME
										<cfelseif attributes.report_type eq 2>ZONE_ID,ZONE_NAME
										<cfelseif attributes.report_type eq 3>EMPLOYEE_ID,POSITION_NAME
										<cfelseif attributes.report_type eq 4>DEPARTMENT_ID,DEPARTMENT_HEAD
										<cfelseif attributes.report_type eq 5>POSITION_CAT_ID,POSITION_CAT
										<cfelseif attributes.report_type eq 6>TITLE_ID,TITLE
										<cfelseif attributes.report_type eq 7>UNIT_ID,UNIT_NAME
										<cfelseif attributes.report_type eq 8>ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME
										<cfelseif attributes.report_type eq 9>COLLAR_TYPE
										<cfelseif attributes.report_type eq 10>YAS
										<cfelseif attributes.report_type eq 11>EDU_LEVEL_ID,EDUCATION_NAME
										<cfelseif attributes.report_type eq 12>DEFECTION_LEVEL
										<cfelseif attributes.report_type eq 13>USE_SSK
										<cfelseif attributes.report_type eq 14>SSK_STATUTE
										<cfelseif attributes.report_type eq 15>SEX
										<cfelseif attributes.report_type eq 16>BLOOD_TYPE
										<cfelseif attributes.report_type eq 18>DUTY_TYPE</cfif>
								</cfquery>								
								<cfset url_str_ = url_str>
								<cfif attributes.report_type eq 1><cfif find("&comp_id=#attributes.comp_id#",url_str_)><cfset url_str_ = replace(url_str_,"&comp_id=#attributes.comp_id#","&comp_id=#comp_id#")><cfelse><cfset url_str_ = "#url_str_#&comp_id=#comp_id#"></cfif>
								<cfelseif attributes.report_type eq 2><cfif find("&zone_id=#attributes.zone_id#",url_str_)><cfset url_str_ = replace(url_str_,"&zone_id=#attributes.zone_id#","&zone_id=#zone_id#")><cfelse><cfset url_str_ = "#url_str_#&zone_id=#zone_id#"></cfif>
								<cfelseif attributes.report_type eq 3><cfif find("&branch_id=#attributes.branch_id#",url_str_)><cfset url_str_ = replace(url_str_,"&branch_id=#attributes.branch_id#","&branch_id=#branch_id#")><cfelse><cfset url_str_ = "#url_str_#&branch_id=#branch_id#"></cfif>
								<cfelseif attributes.report_type eq 4><cfif find("&department=#attributes.department#",url_str_)><cfset url_str_ = replace(url_str_,"&department=#attributes.department#","&department=#department_id#")><cfelse><cfset url_str_ = "#url_str_#&department=#department_id#"></cfif>
								<cfelseif attributes.report_type eq 5><cfif find("&pos_cat_id=#attributes.pos_cat_id#",url_str_)><cfset url_str_ = replace(url_str_,"&pos_cat_id=#attributes.pos_cat_id#","&pos_cat_id=#position_cat_id#")><cfelse><cfset url_str_ = "#url_str_#&pos_cat_id=#position_cat_id#"></cfif>
								<cfelseif attributes.report_type eq 6><cfif find("&title_id=#attributes.title_id#",url_str_)><cfset url_str_ = replace(url_str_,"&title_id=#attributes.title_id#","&title_id=#title_id#")><cfelse><cfset url_str_ = "#url_str_#&title_id=#title_id#"></cfif>
								<cfelseif attributes.report_type eq 7><cfif find("&func_id=#attributes.func_id#",url_str_)><cfset url_str_ = replace(url_str_,"&func_id=#attributes.func_id#","&func_id=#unit_id#")><cfelse><cfset url_str_ = "#url_str_#&func_id=#unit_id#"></cfif>
								<cfelseif attributes.report_type eq 8><cfif find("&org_step_id=#attributes.org_step_id#",url_str_)><cfset url_str_ = replace(url_str_,"&org_step_id=#attributes.org_step_id#","&org_step_id=#organization_step_id#")><cfelse><cfset url_str_ = "#url_str_#&org_step_id=#organization_step_id#"></cfif>
								<cfelseif attributes.report_type eq 9><cfif find("&collar_type=#attributes.collar_type#",url_str_)><cfset url_str_ = replace(url_str_,"&collar_type=#attributes.collar_type#","&collar_type=#collar_type#")><cfelse><cfset url_str_ = "#url_str_#&collar_type=#collar_type#"></cfif>
								<cfelseif attributes.report_type eq 10><cfif find("&yas=#attributes.yas#",url_str_)><cfset url_str_ = replace(url_str_,"&yas=#attributes.yas#","&yas=#yas#")><cfelse><cfset url_str_ = "#url_str_#&yas=#yas#"></cfif>
								<cfelseif attributes.report_type eq 11><cfif find("&education=#attributes.education#",url_str_)><cfset url_str_ = replace(url_str_,"&education=#attributes.education#","&education=#edu_level_id#")><cfelse><cfset url_str_ = "#url_str_#&education=#edu_level_id#"></cfif>
								<cfelseif attributes.report_type eq 12><cfif find("&defection_level=#attributes.defection_level#",url_str_)><cfset url_str_ = replace(url_str_,"&defection_level=#attributes.defection_level#","&defection_level=#defection_level#")><cfelse><cfset url_str_ = "#url_str_#&defection_level=#defection_level#"></cfif>
								<cfelseif attributes.report_type eq 13><cfif find("&use_ssk=#attributes.use_ssk#",url_str_)><cfset url_str_ = replace(url_str_,"&use_ssk=#attributes.use_ssk#","&use_ssk=#use_ssk#")><cfelse><cfset url_str_ = "#url_str_#&use_ssk=#use_ssk#"></cfif>
								<cfelseif attributes.report_type eq 14><cfif find("&ssk_statute=#attributes.ssk_statute#",url_str_)><cfset url_str_ = replace(url_str_,"&ssk_statute=#attributes.ssk_statute#","&ssk_statute=#ssk_statute#")><cfelse><cfset url_str_ = "#url_str_#&ssk_statute=#ssk_statute#"></cfif>
								<cfelseif attributes.report_type eq 15><cfif find("&gender=#attributes.gender#",url_str_)><cfset url_str_ = replace(url_str_,"&gender=#attributes.gender#","&gender=#sex#")><cfelse><cfset url_str_ = "#url_str_#&gender=#sex#"></cfif>
								<cfelseif attributes.report_type eq 16><cfif find("&blood_type=#attributes.blood_type#",url_str_)><cfset url_str_ = replace(url_str_,"&blood_type=#attributes.blood_type#","&blood_type=#blood_type#")><cfelse><cfset url_str_ = "#url_str_#&blood_type=#blood_type#"></cfif>
								<cfelseif attributes.report_type eq 18><cfif find("&duty_type=#attributes.duty_type#",url_str_)><cfset url_str_ = replace(url_str_,"&duty_type=#attributes.duty_type#","&duty_type=#duty_type#")><cfelse><cfset url_str_ = "#url_str_#&duty_type=#duty_type#"></cfif>
								</cfif>
								<cfif find("&start_date=#dateformat(attributes.startdate,dateformat_style)#",url_str_)><cfset url_str_ = replace(url_str_,"&start_date=#dateformat(attributes.startdate,dateformat_style)#","&start_date=#dateformat(temp_start,dateformat_style)#")><cfelse><cfset url_str_ = "#url_str_#&start_date=#dateformat(temp_start,dateformat_style)#"></cfif>
								<cfif find("&finish_date=#dateformat(attributes.finishdate,dateformat_style)#",url_str_)><cfset url_str_ = replace(url_str_,"&finish_date=#dateformat(attributes.finishdate,dateformat_style)#","&finish_date=#dateformat(qry_finish,dateformat_style)#")><cfelse><cfset url_str_ = "#url_str_#&finish_date=#dateformat(qry_finish,dateformat_style)#"></cfif>
								<td>
										<cfif attributes.report_type eq 3>
											<cfif get_count.recordcount neq 0>
												<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_list_profile_detail&from_count_report=1#url_str_#');"><cfif attributes.report_type eq 1>#count_query.TOTAL_COUNT#<cfelse>#get_count.recordcount#</cfif></a>
											<cfelse>-
											</cfif>
										<cfelse><cfif attributes.report_type eq 1>
													<cfquery name="count_query" dbtype="query">
														select count(EMPLOYEE_ID)  AS TOTAL_COUNT FROM get_count
													</cfquery>
													<cfif count_query.TOTAL_COUNT neq 0>
														<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_list_profile_detail&from_count_report=1#url_str_#');">#count_query.TOTAL_COUNT#</a>
													<cfelse>
													</cfif>
												<cfelse>
													<cfif get_count.total_count neq 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_list_profile_detail&from_count_report=1#url_str_#');">#get_count.total_count#</a>
													<cfelse>-
													</cfif>
												</cfif>
										</cfif>
								</td>
								<cfif attributes.report_base eq 1>
									<cfset temp_start = "1/#month(temp_start)#/#year(temp_start)#">
									<cf_date tarih = "temp_start">
									<cfset temp_start = dateadd("m",1,temp_start)>
								<cfelseif attributes.report_base eq 0>
									<cfset temp_start = "1/1/#year(temp_start)#">
									<cf_date tarih = "temp_start">
									<cfset temp_start = dateadd("yyyy",1,temp_start)>
								</cfif>
							</cfloop>
						<cfelse>
							<cfquery name="get_count" dbtype="query">
								SELECT COUNT(EMPLOYEE_ID) AS TOTAL_COUNT 
								FROM 
									get_employee_count 
								WHERE 
									<cfif attributes.report_type eq 1>COMP_ID = #comp_id#
									<cfelseif attributes.report_type eq 2>ZONE_ID = #zone_id#
									<cfelseif attributes.report_type eq 3>BRANCH_ID = #branch_id#
									<cfelseif attributes.report_type eq 4>DEPARTMENT_ID = #department_id#
									<cfelseif attributes.report_type eq 5>POSITION_CAT_ID = #position_cat_id#
									<cfelseif attributes.report_type eq 6>TITLE_ID <cfif len(title_id)>= #title_id#<cfelse>IS NULL</cfif>
									<cfelseif attributes.report_type eq 7>UNIT_ID <cfif len(unit_id)>= #unit_id#<cfelse>IS NULL</cfif>
									<cfelseif attributes.report_type eq 8>ORGANIZATION_STEP_ID <cfif len(organization_step_id)>= #organization_step_id#<cfelse>IS NULL</cfif>
									<cfelseif attributes.report_type eq 9>COLLAR_TYPE <cfif len(collar_type)>= #collar_type#<cfelse>IS NULL</cfif>
									<cfelseif attributes.report_type eq 10>YAS = #yas#
									<cfelseif attributes.report_type eq 11>EDU_LEVEL_ID <cfif len(edu_level_id)>= #edu_level_id#<cfelse>IS NULL</cfif>
									<cfelseif attributes.report_type eq 12>DEFECTION_LEVEL = #defection_level#
									<cfelseif attributes.report_type eq 13>USE_SSK = #use_ssk#
									<cfelseif attributes.report_type eq 14>SSK_STATUTE <cfif len(ssk_statute)>= #ssk_statute#<cfelse>IS NULL</cfif> 
									<cfelseif attributes.report_type eq 15>SEX = #sex#
									<cfelseif attributes.report_type eq 16>BLOOD_TYPE <cfif len(blood_type)>= #blood_type#<cfelse>IS NULL</cfif>
									<cfelseif attributes.report_type eq 18>DUTY_TYPE <cfif len(duty_type)>= #duty_type#<cfelse>IS NULL</cfif></cfif> 
								GROUP BY
									<cfif attributes.report_type eq 1>COMP_ID,COMPANY_NAME
									<cfelseif attributes.report_type eq 2>ZONE_ID,ZONE_NAME
									<cfelseif attributes.report_type eq 3>BRANCH_ID,BRANCH_NAME
									<cfelseif attributes.report_type eq 4>DEPARTMENT_ID,DEPARTMENT_HEAD
									<cfelseif attributes.report_type eq 5>POSITION_CAT_ID,POSITION_CAT
									<cfelseif attributes.report_type eq 6>TITLE_ID,TITLE
									<cfelseif attributes.report_type eq 7>UNIT_ID,UNIT_NAME
									<cfelseif attributes.report_type eq 8>ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME
									<cfelseif attributes.report_type eq 9>COLLAR_TYPE
									<cfelseif attributes.report_type eq 10>YAS
									<cfelseif attributes.report_type eq 11>EDU_LEVEL_ID,EDUCATION_NAME
									<cfelseif attributes.report_type eq 12>DEFECTION_LEVEL
									<cfelseif attributes.report_type eq 13>USE_SSK
									<cfelseif attributes.report_type eq 14>SSK_STATUTE
									<cfelseif attributes.report_type eq 15>SEX
									<cfelseif attributes.report_type eq 16>BLOOD_TYPE
									<cfelseif attributes.report_type eq 18>DUTY_TYPE</cfif>
							</cfquery>
							<cfset url_str_ = url_str>
							<cfif attributes.report_type eq 1><cfif find("&comp_id=#attributes.comp_id#",url_str_)><cfset url_str_ = replace(url_str_,"&comp_id=#attributes.comp_id#","&comp_id=#comp_id#")><cfelse><cfset url_str_ = "#url_str_#&comp_id=#comp_id#"></cfif>
							<cfelseif attributes.report_type eq 2><cfif find("&zone_id=#attributes.zone_id#",url_str_)><cfset url_str_ = replace(url_str_,"&zone_id=#attributes.zone_id#","&zone_id=#zone_id#")><cfelse><cfset url_str_ = "#url_str_#&zone_id=#zone_id#"></cfif>
							<cfelseif attributes.report_type eq 3><cfif find("&branch_id=#attributes.branch_id#",url_str_)><cfset url_str_ = replace(url_str_,"&branch_id=#attributes.branch_id#","&branch_id=#branch_id#")><cfelse><cfset url_str_ = "#url_str_#&branch_id=#branch_id#"></cfif>
							<cfelseif attributes.report_type eq 4><cfif find("&department=#attributes.department#",url_str_)><cfset url_str_ = replace(url_str_,"&department=#attributes.department#","&department=#department_id#")><cfelse><cfset url_str_ = "#url_str_#&department=#department_id#"></cfif>
							<cfelseif attributes.report_type eq 5><cfif find("&pos_cat_id=#attributes.pos_cat_id#",url_str_)><cfset url_str_ = replace(url_str_,"&pos_cat_id=#attributes.pos_cat_id#","&pos_cat_id=#position_cat_id#")><cfelse><cfset url_str_ = "#url_str_#&pos_cat_id=#position_cat_id#"></cfif>
							<cfelseif attributes.report_type eq 6><cfif find("&title_id=#attributes.title_id#",url_str_)><cfset url_str_ = replace(url_str_,"&title_id=#attributes.title_id#","&title_id=#title_id#")><cfelse><cfset url_str_ = "#url_str_#&title_id=#title_id#"></cfif>
							<cfelseif attributes.report_type eq 7><cfif find("&func_id=#attributes.func_id#",url_str_)><cfset url_str_ = replace(url_str_,"&func_id=#attributes.func_id#","&func_id=#unit_id#")><cfelse><cfset url_str_ = "#url_str_#&func_id=#unit_id#"></cfif>
							<cfelseif attributes.report_type eq 8><cfif find("&org_step_id=#attributes.org_step_id#",url_str_)><cfset url_str_ = replace(url_str_,"&org_step_id=#attributes.org_step_id#","&org_step_id=#organization_step_id#")><cfelse><cfset url_str_ = "#url_str_#&org_step_id=#organization_step_id#"></cfif>
							<cfelseif attributes.report_type eq 9><cfif find("&collar_type=#attributes.collar_type#",url_str_)><cfset url_str_ = replace(url_str_,"&collar_type=#attributes.collar_type#","&collar_type=#collar_type#")><cfelse><cfset url_str_ = "#url_str_#&collar_type=#collar_type#"></cfif>
							<cfelseif attributes.report_type eq 10><cfif find("&yas=#attributes.yas#",url_str_)><cfset url_str_ = replace(url_str_,"&yas=#attributes.yas#","&yas=#yas#")><cfelse><cfset url_str_ = "#url_str_#&yas=#yas#"></cfif>
							<cfelseif attributes.report_type eq 11><cfif find("&education=#attributes.education#",url_str_)><cfset url_str_ = replace(url_str_,"&education=#attributes.education#","&education=#edu_level_id#")><cfelse><cfset url_str_ = "#url_str_#&education=#edu_level_id#"></cfif>
							<cfelseif attributes.report_type eq 12><cfif find("&defection_level=#attributes.defection_level#",url_str_)><cfset url_str_ = replace(url_str_,"&defection_level=#attributes.defection_level#","&defection_level=#defection_level#")><cfelse><cfset url_str_ = "#url_str_#&defection_level=#defection_level#"></cfif>
							<cfelseif attributes.report_type eq 13><cfif find("&use_ssk=#attributes.use_ssk#",url_str_)><cfset url_str_ = replace(url_str_,"&use_ssk=#attributes.use_ssk#","&use_ssk=#use_ssk#")><cfelse><cfset url_str_ = "#url_str_#&use_ssk=#use_ssk#"></cfif>
							<cfelseif attributes.report_type eq 14><cfif find("&ssk_statute=#attributes.ssk_statute#",url_str_)><cfset url_str_ = replace(url_str_,"&ssk_statute=#attributes.ssk_statute#","&ssk_statute=#ssk_statute#")><cfelse><cfset url_str_ = "#url_str_#&ssk_statute=#ssk_statute#"></cfif>
							<cfelseif attributes.report_type eq 15><cfif find("&gender=#attributes.gender#",url_str_)><cfset url_str_ = replace(url_str_,"&gender=#attributes.gender#","&gender=#sex#")><cfelse><cfset url_str_ = "#url_str_#&gender=#sex#"></cfif>
							<cfelseif attributes.report_type eq 16><cfif find("&blood_type=#attributes.blood_type#",url_str_)><cfset url_str_ = replace(url_str_,"&blood_type=#attributes.blood_type#","&blood_type=#blood_type#")><cfelse><cfset url_str_ = "#url_str_#&blood_type=#blood_type#"></cfif>
							<cfelseif attributes.report_type eq 18><cfif find("&duty_type=#attributes.duty_type#",url_str_)><cfset url_str_ = replace(url_str_,"&duty_type=#attributes.duty_type#","&duty_type=#duty_type#")><cfelse><cfset url_str_ = "#url_str_#&duty_type=#duty_type#"></cfif>
							</cfif>
							<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_list_profile_detail&from_count_report=1#url_str_#');">#get_count.total_count#</a></td>
						</cfif>
					</tr>
				</cfoutput>
			<cfelseif attributes.report_type eq 17>
				<cfif len(attributes.inout_statue)>
					<cfset from_ = attributes.inout_statue><cfset to_ = attributes.inout_statue>
				<cfelse>
					<cfset from_ = 0><cfset to_ = 3>
				</cfif>
				<cfloop from="#from_#" to="#to_#" index="j">
					<tr>
						<td><cfif j eq 0><cf_get_lang dictionary_id='58536.Çıkışlar'><cfelseif j eq 1><cf_get_lang dictionary_id='58535.Girişler'><cfelseif j eq 2><cf_get_lang dictionary_id='39083.Aktif Çalışanlar'><cfelseif j eq 3><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></cfif></td>
						<cfif isdefined('attributes.report_base') and attributes.report_base eq 1 and isdefined('attributes.startdate') and len(attributes.startdate) and isdefined('attributes.finishdate') and len(attributes.finishdate)>
							<cfset temp_start = attributes.startdate>
							<cfset temp_finish = CreateDate(year(attributes.finish_date),month(attributes.finish_date),1)>
						<cfelseif isdefined('attributes.report_base') and attributes.report_base eq 0 and isdefined('attributes.startdate') and len(attributes.startdate) and isdefined('attributes.finishdate') and len(attributes.finishdate)>
							<cfset temp_start = attributes.startdate>
							<cfset temp_finish = attributes.finish_date>
						</cfif>
						<cfif isdefined('attributes.report_base') and isdefined('temp_start') and isdefined('temp_finish')>
							<cfloop condition = "DateCompare(temp_finish, temp_start) gte 0">
								<cfif attributes.report_base eq 1>
									<cfif month(temp_start) eq month(attributes.finish_date)>
										<cfset qry_finish = attributes.finish_date>
									<cfelse>
										<cfset qry_finish = CreateDate(year(temp_start),month(temp_start),DaysInMonth(CreateDate(year(temp_start),month(temp_start),1)))>
									</cfif>
								<cfelseif attributes.report_base eq 0>
									<cfif year(temp_start) eq year(attributes.finish_date)>
										<cfset qry_finish = temp_finish>
									<cfelse>
										<cfset qry_finish = CreateDate(year(temp_start),12,DaysInMonth(CreateDate(year(temp_start),12,1)))>
									</cfif>
								</cfif>
								<cfquery name="get_count" dbtype="query">
									SELECT COUNT(EMPLOYEE_ID) AS TOTAL_COUNT 
									FROM 
										get_employee_count 
									WHERE 
										1=1
										<cfif j eq 1><!--- Girişler --->
											<cfif isdefined('temp_start') and isdate(temp_start)>
												AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">
											</cfif>
											<cfif isdefined('qry_finish') and isdate(qry_finish)>
												AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
											</cfif>
										<cfelseif j eq 0><!--- Çıkışlar --->
											<cfif isdefined('temp_start') and isdate(temp_start)>
												AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">
											</cfif>
											<cfif isdefined('qry_finish') and isdate(qry_finish)>
												AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
											</cfif>
											AND	FINISH_DATE IS NOT NULL
										<cfelseif j eq 2><!--- aktif calisanlar --->
											AND 
											(
												<cfif isdate(temp_start) or isdate(qry_finish)>
													<cfif isdate(temp_start) and not isdate(qry_finish)>
													(
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">)
														OR
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE IS NULL)
													)
													<cfelseif not isdate(temp_start) and isdate(qry_finish)>
													(
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#"> AND FINISH_DATE IS NULL)
													)
													<cfelse>
													(
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE IS NULL)
														OR
														(START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
														OR
														(FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#"> AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">)
													)
													</cfif>
												<cfelse>
													FINISH_DATE IS NULL
												</cfif>
											)
										<cfelseif j eq 3><!--- giriş ve çıkışlar Seçili ise --->
											AND 
											(
												(
													START_DATE IS NOT NULL
													<cfif isdefined('temp_start') and isdate(temp_start)>
														AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">
													</cfif>
													<cfif isdefined('qry_finish') and isdate(qry_finish)>
														AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
													</cfif>
												)
												OR
												(
													START_DATE IS NOT NULL
													<cfif isdefined('temp_start') and isdate(temp_start)>
														AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#temp_start#">
													</cfif>
													<cfif isdefined('qry_finish') and isdate(qry_finish)>
														AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qry_finish#">
													</cfif>
												)
											)
										</cfif>
								</cfquery>
								<cfset url_str_ = url_str>
								<cfif find("&start_date=#dateformat(attributes.startdate,dateformat_style)#",url_str_)><cfset url_str_ = replace(url_str_,"&start_date=#dateformat(attributes.startdate,dateformat_style)#","&start_date=#dateformat(temp_start,dateformat_style)#")><cfelse><cfset url_str_ = "#url_str_#&start_date=#dateformat(temp_start,dateformat_style)#"></cfif>
								<cfif find("&finish_date=#dateformat(attributes.finishdate,dateformat_style)#",url_str_)><cfset url_str_ = replace(url_str_,"&finish_date=#dateformat(attributes.finishdate,dateformat_style)#","&finish_date=#dateformat(qry_finish,dateformat_style)#")><cfelse><cfset url_str_ = "#url_str_#&finish_date=#dateformat(qry_finish,dateformat_style)#"></cfif>
								<cfif find("&inout_statue=#attributes.inout_statue#",url_str_)><cfset url_str_ = replace(url_str_,"&inout_statue=#attributes.inout_statue#","&inout_statue=#j#")><cfelse><cfset url_str_ = "#url_str_#&inout_statue=#j#"></cfif>
								<td><cfoutput><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_list_profile_detail&from_count_report=1#url_str_#');">#get_count.total_count#</a></cfoutput></td>
								<cfif attributes.report_base eq 1>
									<cfset temp_start = "1/#month(temp_start)#/#year(temp_start)#">
									<cf_date tarih = "temp_start">
									<cfset temp_start = dateadd("m",1,temp_start)>
								<cfelseif attributes.report_base eq 0>
									<cfset temp_start = "1/1/#year(temp_start)#">
									<cf_date tarih = "temp_start">
									<cfset temp_start = dateadd("yyyy",1,temp_start)>
								</cfif>
							</cfloop>
						</cfif>
					</tr>
				</cfloop>
			</cfif>
		</tbody>
	</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="report.employee_count_report#url_str#">
</cfif>
<script type="text/javascript">
	function get_branch_list(gelen)
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
	}
	
	function get_department_list(gelen){
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	function alt_departman_chckbx(val)
	{
		checkedValues_b = $("#department").multiselect("getChecked");
		if(checkedValues_b.length > 0)
		{
			document.getElementById('alt_departman_td').style.display = '';
		}
		else
		{
			document.getElementById('alt_departman_td').style.display = 'none';
			document.getElementById('is_all_dep').checked = false;
		}
	}
	function control()
	{
		if(datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value) < 0)
        {
            alert("<cf_get_lang dictionary_id ='40467.Başlangıç Tarihi Bitiş Tarihinden Büyük Olmamalıdır'>");
            return false;
        }
        if ((document.rapor.start_date.value != '') && (document.rapor.finish_date.value != '') &&
        !date_check(form.start_date,form.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
             return false;
		
		if(document.rapor.is_excel.checked==false)
			{
				document.rapor.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.employee_count_report"
				return true;
			}
			else{
				document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_employee_count_report</cfoutput>"}
		
	}
</script>
