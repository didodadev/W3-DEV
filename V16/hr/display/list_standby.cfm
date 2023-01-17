<cf_xml_page_edit fuseact='hr.list_standby'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfscript>
	attributes.startrow = ((attributes.page-1) * attributes.maxrows) + 1;
	url_str = "";
	if (isdefined("attributes.hierarchy") and len(attributes.hierarchy))
		url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
	if (isdefined("attributes.department") and len(attributes.department))
		url_str = "#url_str#&department=#attributes.department#";
	if (isdefined('positions') and len(positions))
		url_str = '#url_str#&positions=#positions#';
	if (isdefined("attributes.branch_id") and len(attributes.branch_id))
		url_str='#url_str#&branch_id=#attributes.branch_id#';
	if (isdefined("attributes.keyword") and len(attributes.keyword))
		url_str='#url_str#&keyword=#attributes.keyword#';
	include "../query/get_emp_codes.cfm";
	if (isdefined("attributes.keyword"))
	{
		cmp_standby = createObject("component","V16.hr.cfc.get_standbys");
		cmp_standby.dsn = dsn;
		get_standbys = cmp_standby.get_standby(
			positions: '#iif(isdefined("attributes.positions") and len(attributes.positions),"attributes.positions",DE(""))#',
			branch_id: '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
			department: '#iif(isdefined("attributes.department") and len(attributes.department),"attributes.department",DE(""))#',
			keyword: '#iif(isdefined("attributes.keyword") and len(attributes.keyword),"attributes.keyword",DE(""))#',
			fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
			emp_code_list: emp_code_list,
			database_type: database_type,
			maxrows: attributes.maxrows,
			startrow: attributes.startrow
		);
	}
	else
	{
		filtrele = 1;
		get_standbys.query_count = 0;
		get_standbys.recordcount = 0;
	}
	if (fuseaction contains "popup")
		is_popup = 1;
	else
		is_popup = 0;
	
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company();
	
	cmp_quiz = createObject("component","V16.hr.cfc.get_quizes");
	cmp_quiz.dsn = dsn;
	get_quizs = cmp_quiz.get_quiz(
		relation_action: 3,
		is_active: 1,
		is_education: 0,
		is_trainer: 0,
		form_year: session.ep.period_year
	);
	
	cmp_dep_branch = createObject("component","V16.hr.cfc.get_department_branch");
	cmp_dep_branch.dsn = dsn;
	all_branches = cmp_dep_branch.get_department_branch();
	
	if (isdefined('attributes.branch_id') and isnumeric(attributes.branch_id))
	{
		cmp_department = createObject("component","V16.hr.cfc.get_departments");
		cmp_department.dsn = dsn;
		get_department = cmp_department.get_department(branch_id: attributes.branch_id);
	}
	if(get_standbys.recordcount eq 0)
	{
		get_standbys.recordcount = 0;
		get_standbys.query_count = 0;	
	}

</cfscript>
<cfquery name="get_branches" dbtype="query">
	SELECT DISTINCT BRANCH_NAME, BRANCH_ID FROM all_branches
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.totalrecords" default="#get_standbys.query_count#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=hr.list_standby">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<cfinput type="text" name="hierarchy" id="hierarchy" value="#attributes.hierarchy#" maxlength="50" placeholder="#getLang(377,'Özel Kod',57789)#">
				</div>
				<div class="form-group">
					<select name="positions" id="positions">
						<option value="1" <cfif isdefined('attributes.positions') and (attributes.positions eq 1)>selected</cfif>><cf_get_lang dictionary_id='55583.Tüm Pozisyonlar'></option>
						<option value="2" <cfif isdefined('attributes.positions') and (attributes.positions eq 2)>selected</cfif>><cf_get_lang dictionary_id='55584.Dolu Pozisyonlar'></option>
						<option value="3" <cfif isdefined('attributes.positions') and (attributes.positions eq 3)>selected</cfif>><cf_get_lang dictionary_id='55587.Boş Pozisyonlar'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" validate="integer" range="1,250" maxlength="3" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' trail='0'>
				</div>
				<div class="form-group">
					<cfoutput><span class="ui-btn ui-btn-gray2"  onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_chief_positions');"><i class="fa fa-bookmark" title="<cf_get_lang dictionary_id ='56583.Pozisyonun Amiri Olduğu Kişi Listesi'>"></i></span></cfoutput>
				</div>
				<div class="form-group">
					<cfoutput><span class="ui-btn ui-btn-gray" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_all_chief_positions');"><i class="fa fa-eject" title="<cf_get_lang dictionary_id ='56584.Tüm Amirler Listesi'>"></i></span></cfoutput>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-branch_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id"  onChange="showDepartment(this.value)">
								<option value="all" <cfif isdefined("attributes.branch_id") and attributes.branch_id is 'all'>selected</cfif>><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_branches">
									<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)>selected</cfif>>#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1027,'Amirler ve Yedekler',56112)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>   
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id='29666.Amir'> 1-<cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='29666.Amir'> 2-<cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='55502.Yedek'> 1-<cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='56094.Görüş Bildirecek'>-<cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='55907.Değerlendirme Formu'></th>
					<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_standbys.recordcount>
					<cfoutput query="get_standbys">
						<cfset position_cat_id_ = position_cat_id>
						<cfset position_id=get_standbys.position_id>
						<cfquery name="get_position_quiz" dbtype="query">
							SELECT 
								QUIZ_HEAD,
							FORM_OPEN_TYPE,
								POSITION_ID
							FROM 
								get_quizs
							WHERE 
								POSITION_ID IS NOT NULL AND
								POSITION_ID LIKE '%,#position_id#,%' 
						</cfquery>
						<cfif not get_position_quiz.recordcount>
							<cfquery name="get_emp_quizs" dbtype="query">
								SELECT QUIZ_HEAD,FORM_OPEN_TYPE,QUIZ_ID FROM get_quizs WHERE POSITION_CAT_ID IS NOT NULL AND POSITION_CAT_ID =#position_cat_id_# ORDER BY QUIZ_ID DESC<!--- LIKE '%,#position_cat_id_#,%' --->
							</cfquery>
							<!--- <cfset quiz_list=valuelist(get_emp_quizs.QUIZ_HEAD)> --->
						</cfif>
						<tr>
							<td><cfif len(sb_id) and sb_id gt 0><a href="#request.self#?fuseaction=hr.list_standby&event=upd&sb_id=#sb_id#" class="tableyazi">#rownum#</a><cfelse><a href="#request.self#?fuseaction=hr.list_standby&event=add&position_id=#position_id#" class="tableyazi">#rownum#</a></cfif></td>
							<td><cfif len(sb_id) and sb_id gt 0><a href="#request.self#?fuseaction=hr.list_standby&event=upd&sb_id=#sb_id#" class="tableyazi">#position_name#</a><cfelse><a href="#request.self#?fuseaction=hr.list_standby&event=add&position_id=#position_id#" class="tableyazi">#position_name#</a></cfif></td>
							<td>#branch_name#</td>
							<td>#department_head#</td>
							<td><cfif len(sb_id) and sb_id gt 0><a href="#request.self#?fuseaction=hr.list_standby&event=upd&sb_id=#sb_id#" class="tableyazi">#employee_name# #employee_surname#</a><cfelse><a href="#request.self#?fuseaction=hr.list_standby&event=add&position_id=#position_id#" class="tableyazi">#employee_name# #employee_surname#</a></cfif></td>
							<td><cfif len(chief1_code) and chief1_code gt 0>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_chief_positions&chief_code=#chief1_code#','list');" class="tableyazi">#cf1_name# #cf1_surname#</a>-#cf1_position_name#
								<cfelse>-</cfif>
							</td>
							<td><cfif len(chief2_code) and chief2_code gt 0>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_chief_positions&chief_code=#chief2_code#','list');" class="tableyazi">#cf2_name# #cf2_surname#</a>-#cf2_position_name#
								<cfelse>-</cfif>
							</td>
							<td>
								<cfif len(candidate_pos_1) and candidate_pos_1 gt 0>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_chief_positions&chief_code=#candidate_pos_1#','list');" class="tableyazi">#cd1_name# #cd1_surname#</a>-#cd1_position_name#
								<cfelse>-</cfif>
							</td>
							<td><cfif len(chief3_code) and chief1_code gt 0>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_chief_positions&chief_code=#chief3_code#','list');" class="tableyazi">#cf3_name# #cf3_surname#</a>-#cf3_position_name#
								<cfelse>-</cfif>
							</td>
							<td width="170">
								<cfif get_position_quiz.recordcount>
									#get_position_quiz.quiz_head# (P.)
									<cfelseif get_emp_quizs.recordcount>
										#get_emp_quizs.quiz_head# (P.T.)
									<cfelse>
									-
								</cfif>
							</td>
							<cfif isDefined("x_show_level") and x_show_level eq 1>
								<td>                            
									<cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
									<cfif up_dep_len gt 0>
										<cfset temp = up_dep_len> 
										<cfloop from="1" to="#up_dep_len#" index="i" step="1">
											<cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
												<cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
												<cfquery name="get_upper_departments" datasource="#dsn#">
													SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
												</cfquery>
												<cfset up_dep_head = get_upper_departments.department_head>
												#up_dep_head# 
													<cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
													<cfif get_org_level.recordcount>
														(#get_org_level.ORGANIZATION_STEP_NAME#)
													</cfif>
												<cfif up_dep_len neq i>
													>
												</cfif>
											<cfelse>
												<cfset up_dep_head = ''>
											</cfif>
											<cfset temp = temp - 1>
										</cfloop>
									</cfif>​
								</td>
							</cfif>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif isdefined("filtrele")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="hr.list_standby#url_str#&keyword=#attributes.keyword#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="55770.İlişkili Departmanlar">');
		}
	}
</script>
