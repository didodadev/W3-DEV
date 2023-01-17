<cf_xml_page_edit fuseact='hr.list_positions'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.unit_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.our_company_id" default="">
<cfparam name="attributes.organization_step_id" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.status" default="-1">
<cfparam name="attributes.empty_position" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.reason_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfscript>
	attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1;
	
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	titles = cmp_title.get_title();
	
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cats = cmp_pos_cat.get_position_cat();
	
	//Pozisyon ekleme sayfasinin xml ine gore pozisyon alanini kapatiyoruz
	cmp_property = createObject("component","V16.hr.cfc.get_fuseaction_property");
	cmp_property.dsn = dsn;
	get_position_list_xml = cmp_property.get_property(
		our_company_id: session.ep.company_id,
		fuseaction_name: 'hr.form_add_position'
	);
	if ((get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0)
		show_position = 1;
	else
		show_position = 0;
		
	cmp_process = createObject("component","V16.hr.cfc.get_process_rows");
	cmp_process.dsn = dsn;
	get_process_stage = cmp_process.get_process_type_rows(faction: 'hr.list_positions');
	
	include "../query/get_emp_codes.cfm";
	
	if (not isdefined("attributes.keyword"))
	{
		arama_yapilmali = 1;
		get_positions.recordcount = 0;
	}
	else
	{
		arama_yapilmali = 0;
		cmp_position = createObject("component","V16.hr.cfc.get_positions");
		cmp_position.dsn = dsn;
		get_positions = cmp_position.get_position(
			collar_type: attributes.collar_type,
			process_stage: '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
			empty_position: attributes.empty_position,
			status: attributes.status,
			reason_id:attributes.reason_id,
			position_cat_id: attributes.position_cat_id,
			unit_id: attributes.unit_id,
			title_id: attributes.title_id,
			organization_step_id:attributes.organization_step_id,
			comp_id: attributes.comp_id,
			keyword: attributes.keyword,
			hierarchy: attributes.hierarchy,
			emp_code_list: emp_code_list,
			branch_id: attributes.branch_id,
			department: attributes.department,
			duty_type: attributes.duty_type,
			fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
			database_type: database_type,
			startrow: attributes.startrow,
			maxrows: attributes.maxrows
		);
	}
	
	if (fuseaction contains "popup")
		is_popup = 1;
	else
		is_popup = 0;
		
	/* cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_our_company = cmp_company.get_company(); */
	
	cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_organization_steps = cmp_org_step.get_organization_step();
	
	reason_conn = createObject("component","V16.hr.cfc.get_fire_reasons");
	reason_conn.dsn = dsn;
	get_fire_reasons = reason_conn.get_fire_reasons();
	
	cmp_unit = createObject("component","V16.hr.cfc.get_functions");
	cmp_unit.dsn = dsn;
	get_fonc_units = cmp_unit.get_function();
	
	if (isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all")
	{
		cmp_branch = createObject("component","V16.hr.cfc.get_branches");
		cmp_branch.dsn = dsn;
		get_branch = cmp_branch.get_branch(comp_id: attributes.comp_id);
	}
	
	if (isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all")
	{
		cmp_department = createObject("component","V16.hr.cfc.get_departments");
		cmp_department.dsn = dsn;
		get_department = cmp_department.get_department(branch_id: attributes.branch_id);
	}
</cfscript>

<cfparam name="attributes.totalrecords" default='#get_positions.query_count#'>
<cfscript>
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	QueryAddRow(duty_type,8);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang(164,'Çalışan',57576)#",1);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang(1320,'Ürün Eklendi',58732)#",2);//işveren vekili
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang(1321,'Alıcı',58733)#",3);//işveren
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Sendikalı',4);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Sözleşmeli',5);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Kapsam Dışı',6);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Kısmi İstihdam',7);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Taşeron',8);
</cfscript>
<cfquery name="get_our_company" datasource="#dsn#">
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" action="#request.self#?fuseaction=hr.list_positions" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getlang(48,'Filtre',57460)#" id="keyword" maxlength="255" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<cfinput type="text" name="hierarchy" placeholder="#getlang(377,'Özel Kod',57789)#" value="#attributes.hierarchy#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="status" id="status">
						<option value="-1"<cfif isdefined("attributes.status") and (attributes.status eq -1)>selected</cfif>><cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="1"<cfif isdefined("attributes.status") and (attributes.status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isdefined("attributes.status") and (attributes.status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-comp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
						<div class="col col-12">
							<select name="comp_id" id="comp_id" onChange="showBranch(this.value)">
								<option value="all"><cf_get_lang dictionary_id='29531.Şirketler'></option>
								<cfoutput query="get_our_company"><option value="#comp_id#"<cfif attributes.comp_id eq comp_id>selected</cfif>>#nick_name#</option></cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-BRANCH_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
								<option value="all"><cf_get_lang dictionary_id='57453.Şube'></option>
								<cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all">
									<cfoutput query="get_branch">
										<option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-DEPARTMENT_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-12">
							<select name="department" id="department">
								<option value="all"><cf_get_lang dictionary_id='57572.Departman'></option>
								<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
									<cfoutput query="get_department">
										<option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-unit_id">
						<label class="col col-12"><cf_get_lang dictionary_id ='55217.Birimler'></label>
						<div class="col col-12">
							<select name="unit_id" id="unit_id" >
								<option value=""><cf_get_lang dictionary_id ='55217.Birimler'></option>
								<cfoutput query="get_fonc_units">
									<option value="#unit_id#" <cfif attributes.unit_id eq unit_id>selected</cfif>>#unit_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-collar_type">
						<label class="col col-12"><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
						<div class="col col-12">
							<select name="collar_type" id="collar_type">
								<option value=""><cf_get_lang dictionary_id='56063.Yaka Tipi'></option>
								<option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
								<option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-position_cat_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
						<div class="col col-12">
							<select name="position_cat_id" id="position_cat_id">
								<option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></option>
								<cfoutput query="get_position_cats">
									<option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-title_id">
						<label class="col col-12"><cf_get_lang dictionary_id ='55168.Ünvanlar'></label>
						<div class="col col-12">
							<select name="title_id" id="title_id">
								<option value=""><cf_get_lang dictionary_id ='55168.Ünvanlar'></option>
								<cfoutput query="titles">
									<option value="#title_id#" <cfif attributes.title_id EQ title_id>selected</cfif>>#title#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-organization_step_id">
						<label class="col col-12"><cf_get_lang dictionary_id ='58710.Kademe'></label>
						<div class="col col-12">
							<select name="organization_step_id" id="organization_step_id">
								<option value=""><cf_get_lang dictionary_id ='58710.Kademe'></option>
								<cfoutput query="get_organization_steps">
									<option value="#organization_step_id#" <cfif attributes.organization_step_id eq organization_step_id>selected</cfif>>#ORGANIZATION_STEP_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-empty_position">
						<label class="col col-12"><cf_get_lang dictionary_id='58081.Hepsi'></label>
						<div class="col col-12">
							<select name="empty_position" id="empty_position">
								<option value=""<cfif isdefined("attributes.empty_position") and not len(attributes.empty_position)> selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<option value="1"<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 1)> selected</cfif>><cf_get_lang dictionary_id='55541.Dolu'></option>
								<option value="0"<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 0)> selected</cfif>><cf_get_lang dictionary_id='55552.Boş'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-duty_type">
						<label class="col col-12"><cfoutput>#getlang(806,'Çalışan Tipi',55891)#</cfoutput></label>
						<div class="col col-12">
							<cf_multiselect_check 
							query_name="duty_type"
							name="duty_type"
							width="135"
							option_value="DUTY_TYPE_ID"
							option_name="DUTY_TYPE_NAME"
							value="#attributes.duty_type#"
							option_text="#getLang(806,'Çalışan Tipi',55891)#">
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-12">
							<select name="process_stage" id="process_stage">
								<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
								<cfoutput query="get_process_stage">
									<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-reason_id">
						<label class="col col-12"><cf_get_lang dictionary_id='55550.Gerekçe'></label>
						<div class="col col-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='55550.Gerekçe'></cfsavecontent>					
							<cf_multiselect_check 
								query_name="get_fire_reasons"  
								name="reason_id"
								width="135" 
								option_value="REASON_ID"
								option_name="REASON"
								value="#attributes.reason_id#"
								option_text="#message#">
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(77,'Pozisyonlar',55162)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58487.Çalışan No'></th>
					<th><cf_get_lang dictionary_id='57569.Görevli'></th>
					<th width="20" class="text-center"><i class="fa fa-black-tie" title="<cf_get_lang dictionary_id ='56711.Vekalet Tarihi'>" alt="<cf_get_lang dictionary_id ='56711.Vekalet Tarihi'>"></i></th>
					<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<cfif show_position eq 1>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='58485.Şirket Adi'></th>
					<th><cf_get_lang dictionary_id='57992.Bölge'></th>
					<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center">
						<cfoutput>
							<a href="#request.self#?fuseaction=hr.list_positions&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</cfoutput>
					</th>
					<!-- sil -->
					
				</tr>
			</thead>
			<tbody>
				<cfif get_positions.recordcount>
					<cfoutput query="get_positions">
						<tr>
							<td>#rownum#</td>
							<td>#employee_no#</td>
							<td><cfif employee_id eq 0 or not len(employee_id)>
									<font color="##FF0000"><cf_get_lang dictionary_id='55552.Boş'></font>
								<cfelse>
									<a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name# #employee_surname#</a>
								</cfif>
							</td>
							<td class="text-center"><cfif is_vekaleten eq 1><i class="fa fa-black-tie" style="color:##FFA500;" title="<cf_get_lang dictionary_id ='56711.Vekalet Tarihi'> : #dateformat(vekaleten_date,dateformat_style)#"></i></cfif></td>
							<cfif show_position eq 1>
								<td>#position_cat#</td>
								<td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#" class="tableyazi">#position_name#&nbsp;<cfif is_vekaleten eq 1>(V.)</cfif></a></td>
							<cfelse>
								<td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#" class="tableyazi">#position_cat#&nbsp;<cfif is_vekaleten eq 1>(V.)</cfif></a></td>
							</cfif>
							<td>#title#</td>								
							<td>#department_head#</td>
							<td>#branch_name#</td>
							<td>#nick_name#</td>
							<td>#zone_name#</td>
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
							<!-- sil -->
							<td class="text-center" width="20">
								<a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
							
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfif show_position eq 1>10<cfelse>9</cfif>"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		
	
		<cfscript>
			url_str = "";
			if (isdefined("attributes.comp_id") and len(attributes.comp_id))
				url_str = "#url_str#&comp_id=#attributes.comp_id#";
			if (isdefined("attributes.branch_id") and len(attributes.branch_id))
				url_str = "#url_str#&branch_id=#attributes.branch_id#";
			if (isdefined("attributes.reason_id") and len(attributes.reason_id))
				url_str = "#url_str#&reason_id=#attributes.reason_id#";
			if (isdefined("attributes.department") and len(attributes.department))
				url_str = "#url_str#&department=#attributes.department#";
			if (isdefined("attributes.unit_id") and len(attributes.unit_id))
				url_str = "#url_str#&unit_id=#attributes.unit_id#";
			if (isdefined("attributes.organization_step_id") and len(attributes.organization_step_id))
				url_str = "#url_str#&organization_step_id=#attributes.organization_step_id#";
			if (isdefined("attributes.process_stage") and len(attributes.process_stage))
				url_str = "#url_str#&process_stage=#attributes.process_stage#";
			if (isdefined("attributes.collar_type") and len(attributes.collar_type))
				url_str = "#url_str#&collar_type=#attributes.collar_type#";
			if (isdefined("attributes.hierarchy") and len(attributes.hierarchy))
				url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
			if (isdefined("attributes.keyword"))
				url_str = "#url_str#&keyword=#attributes.keyword#";
			if (isdefined("attributes.status") and len(attributes.status))
				url_str = "#url_str#&status=#attributes.status#";
			if (isdefined("attributes.empty_position") and len(attributes.empty_position))
				url_str = "#url_str#&empty_position=#attributes.empty_position#";
			if (isdefined("attributes.position_cat_id") and len(attributes.position_cat_id))
				url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
			if (isdefined("attributes.our_company_id") and len(attributes.our_company_id))
				url_str = "#url_str#&our_company_id=#attributes.our_company_id#";
			if (isdefined("attributes.title_id") and len(attributes.title_id))
				url_str = "#url_str#&title_id=#attributes.title_id#";
			if (isdefined("attributes.duty_type") and len(attributes.duty_type))
				url_str = "#url_str#&duty_type=#attributes.duty_type#";
		</cfscript>
		<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="hr.list_positions&#url_str#">
	</cf_box>
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.search.branch_id.value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'item-DEPARTMENT_PLACE',0,'İlişkili Departmanlar');
		}
		else
		{
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode("<cf_get_lang dictionary_id='57572.Departman'>"));
			myList.appendChild(txtFld);
		}
	}
	function showBranch(comp_id)	
	{
		var comp_id = document.search.comp_id.value;
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
			AjaxPageLoad(send_address,'item-BRANCH_PLACE',0,"<cf_get_lang dictionary_id='55769.İlişkili Şubeler'>");
		}
		else {document.search.branch_id.value = "";document.search.department.value ="";}
		//departman bilgileri sıfırla
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
		AjaxPageLoad(send_address,'item-DEPARTMENT_PLACE',0,"<cf_get_lang dictionary_id='55770.İlişkili Departmanlar'>");
	}
</script>