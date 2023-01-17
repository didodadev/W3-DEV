<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.empty_position" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.user_group_id" default="">
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%settings.list_emp_authority_definition%">
</cfquery>
<cfscript>
	cmp_func = createObject("component","V16.hr.cfc.get_functions");
	cmp_func.dsn = dsn;
	get_fonc_units = cmp_func.get_function();
	cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_organization_steps = cmp_org_step.get_organization_step();
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_our_company = cmp_company.get_company();
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branch = cmp_branch.get_branch(comp_id : '#iif(isdefined("attributes.comp_id") and len(attributes.comp_id),"attributes.comp_id",DE(""))#');
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cats = cmp_pos_cat.get_position_cat();
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	titles = cmp_title.get_title();
</cfscript>
<cfquery name="GET_USER_GROUP" datasource="#DSN#">
	SELECT USER_GROUP_NAME, USER_GROUP_ID FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery>
<cfif isdefined('attributes.form_submitted')>
	<cfinclude template="../query/get_authority_definitions.cfm">
<cfelse>
	<cfset get_authority_definitions.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_authority_definitions.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','çalışan yetki tanımları','43055')#">
		<cfform name="search" action="#request.self#?fuseaction=settings.list_emp_authority_definition" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" maxlength="255" placeholder="#getLang('','keyword',57460)#" value="#attributes.keyword#">
				</div>   
				<div class="form-group">
					<cfinput type="text" name="hierarchy" placeholder="#getLang('','özel kod',57789)#" value="#attributes.hierarchy#" maxlength="50">
				</div>        
				<div class="form-group">
					<select name="unit_id" id="unit_id" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id='32073.Birimler'></option>
						<cfoutput query="get_fonc_units">
							<option value="#unit_id#" <cfif isdefined('attributes.unit_id') and attributes.unit_id eq unit_id>selected</cfif>>#unit_name#</option>
						</cfoutput>
					</select>
				</div>    
				<div class="form-group">
					<select name="organization_step_id" id="organization_step_id" style="width:80px;">
						<option value=""><cf_get_lang dictionary_id='58710.Kademe'></option>
						<cfoutput query="get_organization_steps">
							<option value="#organization_step_id#" <cfif isdefined('attributes.organization_step_id') and attributes.organization_step_id eq organization_step_id>selected</cfif>>#ORGANIZATION_STEP_NAME#</option>
						</cfoutput>
					</select>
				</div>  
				<div class="form-group">
					<select name="status" id="status">
						<option value="-1"<cfif isdefined("attributes.status") and (attributes.status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>/<c<cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="1"<cfif isdefined("attributes.status") and (attributes.status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isdefined("attributes.status") and (attributes.status eq 0)>selected</cfif>><<cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="process_stage" id="process_stage" style="width:110px;">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_process_stage">
							<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>  
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#getLang('','sayı hatası',57482)#" maxlength="3" style="width:25px;">
				</div>  
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-3 col-sm-12 column" type="column" index="1" sort="true">
					<div class="form-group">
						<div class="input-group">
							<select name="comp_id" id="comp_id" onChange="showBranch(this.value)">
								<option value=""><cf_get_lang dictionary_id='29531.Şirketler'></option>
								<cfoutput query="get_our_company">
									<option value="#comp_id#"<cfif isdefined('attributes.comp_id') and attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>  
					<div class="form-group">
						<div class="input-group">
							<div width="125" id="BRANCH_PLACE">
							<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
								<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
								<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
									<cfoutput query="get_branch">
										<option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
									</cfoutput>
								</cfif>
							</select>
							</div>
						</div>
					</div>  
					</div>
					<div class="col col-3 col-md-3 col-sm-12 column" type="column" index="2" sort="true">
						<div class="form-group">
							<div width="125" id="DEPARTMENT_PLACE">
								<select name="department" id="department" <cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>>
									<option value=""><cf_get_lang dictionary_id='35449.Departman'></option>
									<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
										<cfoutput query="get_department">
											<option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
										</cfoutput>
									</cfif>
								</select>
							</div>
						</div>
						<div class="form-group">
							<select name="collar_type" id="collar_type">
								<option value=""><cf_get_lang dictionary_id='30928.Yaka Tipi'></option>
								<option value="1"<cfif isdefined('attributes.collar_type') and attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='38910.Mavi Yaka'></option> 
								<option value="2"<cfif isdefined('attributes.collar_type') and attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='38911.Beyaz Yaka'></option>
							</select>
						</div>  
					</div>
					<div class="col col-3 col-md-3 col-sm-12 column" type="column" index="3" sort="true">
						<div class="form-group">
							<select name="position_cat_id" id="position_cat_id">
								<option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></option>
								<cfoutput query="get_position_cats">
									<option value="#position_cat_id#"<cfif isdefined("attributes.position_cat_id") and attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
								</cfoutput>
							</select>
						</div>  
						<div class="form-group">
							<select name="title_id" id="title_id" >
								<option value=""><cf_get_lang dictionary_id='32232.Ünvanlar'></option>
								<cfoutput query="titles">
									<option value="#title_id#" <cfif isdefined('attributes.title_id') and attributes.title_id eq title_id>selected</cfif>>#title#</option>
								</cfoutput>
							</select>
						</div>  
					</div>
					<div class="col col-3 col-md-3 col-sm-12 column" type="column" index="4" sort="true">
						<div class="form-group">
							<select name="empty_position" id="empty_position">
								<option value=""<cfif isdefined("attributes.empty_position") and not len(attributes.empty_position)> selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<option value="1"<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 1)> selected</cfif>><cf_get_lang dictionary_id='55541.Dolu'></option>
								<option value="0"<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 0)> selected</cfif>><cf_get_lang dictionary_id='30941.Boş'></option>
							</select>
						</div>  
						<div class="form-group">
							<cf_multiselect_check 
								query_name="get_user_group"  
								name="user_group_id"
								width="110" 
								option_value="USER_GROUP_ID"
								option_name="USER_GROUP_NAME"
								value="#attributes.user_group_id#"
								option_text="#getLang('','',30350)#">
						</div> 
					</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','çalışan yetki tanımları','43055')#" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="120"><cf_get_lang dictionary_id='44021.Görevli'></th>
					<th width="160"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<th width="160"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th width="120"><cf_get_lang dictionary_id='57571.Ünvan'></th>
					<th width="120"><cf_get_lang dictionary_id='35449.Departman'></th>
					<th width="120"><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="120"><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
					<th width="100"><cf_get_lang dictionary_id='30350.Yetki Grubu'></th>
					<th class="header_icn_none"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_authority_definitions.recordcount>
					<cfoutput query="get_authority_definitions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td><cfif employee_id eq 0 or not len(employee_id)>
									<font color="##FF0000"><cf_get_lang dictionary_id='30941.Boş'></font>
								<cfelse>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','page')" class="tableyazi">#employee_name# #employee_surname#</a>
								</cfif>
							</td>
							<td>#position_cat#</td>
							<td>#position_name#&nbsp;<cfif is_vekaleten eq 1>(V.)</cfif></td>
							<td>#title#</td>
							<td>#department_head#</td>
							<td>#branch_name#</td>
							<td>#nick_name#</td>
							<td>#user_group_name#</td>
							<td align="center" width="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions_poweruser&employee_id=#employee_id#&position_id=#position_id#&employee_name=#employee_name# #employee_surname#','wwide1');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
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
			if (isdefined("attributes.user_group_id") and len(attributes.user_group_id))
				url_str = "#url_str#&user_group_id=#attributes.user_group_id#";
			if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
				url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
		</cfscript>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="settings.list_emp_authority_definition&#url_str#">
	</cf_box>
</div>	
<script type="text/javascript">
	$('#keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = $('#branch_id').val();
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		{
			var myList = $("#department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id='35449.Departman'>'));
			myList.appendChild(txtFld);
		}
	}
	function showBranch(comp_id)	
	{
		var comp_id = $('#comp_id').val();
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="1730.İlişkili Şubeler">');
		}
		else 
		{
			$('#branch_id').val("");
			$('#department').val("");
		}
		//departman bilgileri sıfırla
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id='35449.Departman'>');
	}
</script>
