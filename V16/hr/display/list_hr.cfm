<cf_xml_page_edit fuseact="hr.list_hr">
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.position_cat_status" default="1">
<cfparam name="attributes.dep_status" default="1">
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword2" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.organization_step_id" default="">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="0">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfscript>
	attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
	
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	titles = cmp_title.get_title();
	//pozisyon ekleme sayfasinin xml ine gore pozisyon alanini kapatiyoruz
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
	get_process_stage = cmp_process.get_process_type_rows(faction: 'hr.list_hr');

	url_str = "&keyword=#attributes.keyword#&keyword2=#attributes.keyword2#";
	if (isdefined("attributes.form_submitted"))
		url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
	if (len(attributes.hierarchy))
		url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
	if (len(attributes.title_id))
		url_str="#url_str#&title_id=#attributes.title_id#";
	if (len(attributes.position_name))
		url_str="#url_str#&position_name=#attributes.position_name#";
	if (len(attributes.position_cat_id))
		url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
	if (isdefined("attributes.branch_id"))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if (isdefined("attributes.department"))
		url_str = "#url_str#&department=#attributes.department#";
	if (isdefined("attributes.emp_status") and len(attributes.emp_status))
		url_str = "#url_str#&emp_status=#attributes.emp_status#";
	if (isdefined("attributes.func_id") and len(attributes.func_id))
		url_str = "#url_str#&func_id=#attributes.func_id#";
	if (isdefined("attributes.organization_step_id") and len(attributes.organization_step_id))
		url_str = "#url_str#&organization_step_id=#attributes.organization_step_id#";
	if (isdefined("attributes.process_stage") and len(attributes.process_stage))
		url_str = "#url_str#&process_stage=#attributes.process_stage#";
	if (isdefined("attributes.duty_type") and len(attributes.duty_type))
		url_str = "#url_str#&duty_type=#attributes.duty_type#";
	include "../query/get_emp_codes.cfm";
	if (isdefined("attributes.form_submitted"))
	{
		cmp_hrs = createObject("component","V16.hr.cfc.get_hrs");
		cmp_hrs.dsn = dsn;
		get_hrs = cmp_hrs.get_hr(
			keyword: attributes.keyword,
			keyword2: attributes.keyword2,
			position_cat_id: attributes.position_cat_id,
			title_id: attributes.title_id,
			branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
			func_id: attributes.func_id,
			organization_step_id: attributes.organization_step_id,
			position_name: attributes.position_name,
			collar_type: attributes.collar_type,
			emp_status: '#iif(isdefined("attributes.emp_status"),"attributes.emp_status",DE(""))#',
			hierarchy: attributes.hierarchy,
			emp_code_list: emp_code_list,
			department: '#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
			process_stage: '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
			employee_id: '#iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
			duty_type: attributes.duty_type,
			fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
			database_type: database_type,
			maxrows: attributes.maxrows,
			startrow: attributes.startrow,
			fuseaction : 'hr.list_hr'
		);
	}
	else
	{
		get_hrs.recordcount = 0;
	}
	cmp_unit = createObject("component","V16.hr.cfc.get_functions");
	cmp_unit.dsn = dsn;
	get_units = cmp_unit.get_function();
	cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_organization_steps = cmp_org_step.get_organization_step();
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cats_ = cmp_pos_cat.get_position_cat();
	cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(ehesap_control:1,branch_status:attributes.is_active);
	if (isdefined('attributes.branch_id') and isnumeric(attributes.branch_id))
	{
		cmp_department = createObject("component","V16.hr.cfc.get_departments");
		cmp_department.dsn = dsn;
		get_department = cmp_department.get_department(branch_id:attributes.branch_id);
	}
	include "list_hr_search.cfm";
</cfscript>
<cfsavecontent variable="head"><cf_get_lang dictionary_id="58875.Calisanlar"></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_hr_id', print_type : 173 }#">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
					<!-- sil --><th width="20"><a href="javascript://"><i style="font-size:18px;" class="fa fa-frown-o"></i></a></th><!-- sil -->
					<th width="50"><cf_get_lang dictionary_id='57487.No'></th>
					<!-- sil --><th width="30"></th><!-- sil -->
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
					<cfif is_ozel_kod>
						<th width="80"><cf_get_lang dictionary_id="57789.Özel Kod"></th>
					</cfif>
					<th width="125"><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="125"><cf_get_lang dictionary_id='57572.Departman'></th>
					<th width="125"><cf_get_lang dictionary_id='59004.Pozisyon tipi'></th>
					<cfif show_position eq 1>
						<th width="125"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					</cfif>
					<cfif isdefined("xml_upper_code") and xml_upper_code eq 1>
						<th width="125"><cf_get_lang dictionary_id='56110.birinci amir'></th>
						<th width="125"><cf_get_lang dictionary_id='38936.ikinci amir'></th>
					</cfif>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='55738.Gruba Giriş'></th>
					<th><cf_get_lang dictionary_id ='55975.Son İşe Giriş'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='56398.Son İşten Çıkış'></th>
					<!-- sil -->
					<th class="header_icn_none"><cf_get_lang dictionary_id='58143.İletişim'></th>
					<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
					<th width="20" class="header_icn_none">
						<cfif not listfindnocase(denied_pages,'hr.form_add_emp')>
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr&event=add">
								<i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
							</a>
						</cfif>
					</th>
					<cfif  get_hrs.recordcount>
						<th width="20" nowrap="nowrap" class="text-center header_icn_none">
							<cfif get_hrs.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a> </cfif> 
							<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_hr_id');">
						</th>
					</cfif>
				<!--- 	<th width="20" class="header_icn_none"><a href="javascript://"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></th> --->
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_hrs.recordcount>
					<cfobject component="/WMO/GeneralFunctions" name="GnlFunctions">
					<cfset attributes.totalrecords = get_hrs.query_count>	
					<cfoutput query="get_hrs">
						<tr>
							<td>#rownum#</td>
							<!-- sil --><td><CF_ONLINE id="#employee_id#" zone="ep"></td><!-- sil -->
							<td>#employee_no#</td>
							<!-- sil -->
							<td> 
								<cfif len(get_hrs.photo) and len(get_hrs.photo_server_id)>
									<cf_get_server_file output_file="hr/#photo#" output_server="#photo_server_id#" output_type="0" image_width="30" image_height="40" image_link="1">
								<cfelse>
									<cfif get_hrs.sex eq 1>
										<img src="/images/male.jpg" width="30" height="40" title="<cf_get_lang dictionary_id='58546.Yok'>">
									<cfelse>
										<img src="/images/female.jpg" width="30" height="40" title="<cf_get_lang dictionary_id='58546.Yok'>">
									</cfif>
								</cfif>
							</td>
							<!-- sil -->
							<td <cfif len(last_surname)>title="Kızlık Soyadı : #last_surname#"</cfif>><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#">#employee_name# #employee_surname#</a></td>
							<td><cf_duxi name='tc_identity_no' class="tableyazi" type="label" value="#tc_identy_no#" gdpr="2"></td>
							<cfif is_ozel_kod>
								<td style="mso-number-format:\@;">#hierarchy#</td>
							</cfif>
							<td>#branch_name#</td>
							<td>#department_head#</td>
							<td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#">#position_cat#</a></td>
							<cfif show_position eq 1>
								<td>#position_name#</td>
							</cfif>
							<cfif isdefined("xml_upper_code") and xml_upper_code eq 1>
								<td>#get_emp_info(upper_position_code,1,1)#</td>
								<td>#get_emp_info(upper_position_code2,1,1)#</td>
							</cfif>
							<td>#dateformat(group_startdate,dateformat_style)#</td>
							<td><cfif len(start_date)>#dateformat(start_date,dateformat_style)#</cfif></td>
							<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
							<!-- sil -->
							<td>
								<ul class="ui-icon-list">
									<cfif len(employee_email)><li><a href="mailto:#employee_email#"><i class="fa fa-envelope" title="#employee_email#"></i></a></li></cfif>
									<cfif (len(mobilcode) and len(mobiltel)) or (len(mobilcode_spc) and len(mobiltel_spc))>
										<li>
											<cfif session.ep.our_company_info.sms eq 1>
												<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=employee&member_id=#EMPLOYEE_ID#&sms_action=#fuseaction#','small');"><i class="fa fa-mobile-phone" title="#iif(Len(mobilcode_spc) and Len(mobiltel_spc),de('(#mobilcode_spc#) #mobiltel_spc#'),de('(#mobilcode#) #mobiltel#'))#"></i></a>
											<cfelse>
												<a href="javascript://"><i style="font-size:16px!important;" class="fa fa-mobile-phone" title="#iif(Len(mobilcode_spc) and Len(mobiltel_spc),de('(#mobilcode_spc#) #mobiltel_spc#'),de('(#mobilcode#) #mobiltel#'))#"></i></a>
											</cfif>
										</li>
									</cfif>
									<cfif len(direct_telcode) and len(direct_tel)>
										<li><a href="javascript://"><i class="fa fa-phone" title="(#direct_telcode#) #direct_tel#"></i></a></li>
									</cfif>
								</ul>
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
							<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
								<td style="text-align:center"><input type="checkbox" name="print_hr_id" id="print_hr_id" value="#employee_id#"></td>
							<!--- <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#GET_HRS.employee_id#&print_type=173','print_page','workcube_print');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td> --->
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="16">
							<cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif>
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="hr.list_hr#url_str#">
	</cf_box>
</div>
<script language="javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'item-department',1,'İlişkili Departmanlar');
		}
	}
</script> 
