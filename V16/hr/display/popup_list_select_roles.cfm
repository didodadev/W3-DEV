<cfparam name="attributes.is_employee" default="">
<cfparam name="attributes.role_employee_id" default="">
<cfparam name="attributes.role_employee_name" default="">
<cfquery name="get_workgroup_name" datasource="#dsn#">
	SELECT WORKGROUP_ID, WORKGROUP_NAME, HIERARCHY FROM WORK_GROUP ORDER BY HIERARCHY
</cfquery>
<cfquery name="get_role_name" datasource="#dsn#">
	SELECT PROJECT_ROLES, PROJECT_ROLES_ID FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES
</cfquery>
<cfquery name="GET_USERS" datasource="#dsn#">
<cfif (attributes.is_employee eq 1) or not len(attributes.is_employee)>
	SELECT 
		EMPLOYEES.EMPLOYEE_ID AS USER_ID, 
		EMPLOYEES.EMPLOYEE_NAME AS USER_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME AS USER_SURNAME, 
		WORKGROUP_EMP_PAR.WRK_ROW_ID,
		WORKGROUP_EMP_PAR.WORKGROUP_ID,
		WORKGROUP_EMP_PAR.PARTNER_ID,
		WORKGROUP_EMP_PAR.POSITION_CODE,
		WORKGROUP_EMP_PAR.ROLE_ID,
		WORKGROUP_EMP_PAR.PROJECT_ID,
		WORKGROUP_EMP_PAR.COMPANY_ID,
		WORKGROUP_EMP_PAR.HIERARCHY AS HIERARCHY,
		WORKGROUP_EMP_PAR.ROLE_HEAD,
		WORKGROUP_EMP_PAR.IS_REAL,
		WORKGROUP_EMP_PAR.UPPER_ROW_ID,
		WORKGROUP_EMP_PAR.EMPLOYEE_ID,
		WORKGROUP_EMP_PAR.IS_CRITICAL,
		WORKGROUP_EMP_PAR.IS_ORG_VIEW,
		WORK_GROUP.WORKGROUP_NAME AS  WORKGROUP_NAME 
	FROM
		EMPLOYEES, 
		WORKGROUP_EMP_PAR,
		WORK_GROUP
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND 
		WORKGROUP_EMP_PAR.WORKGROUP_ID = WORK_GROUP.WORKGROUP_ID AND 
		WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL 
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND ROLE_HEAD LIKE '%#ATTRIBUTES.KEYWORD#%'
		</cfif>
		<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
		AND HIERARCHY LIKE '#ATTRIBUTES.hierarchy#%'
		</cfif>
		<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
		AND WORK_GROUP.WORKGROUP_ID = #attributes.workgroup_id#
		</cfif>
		<cfif isdefined("attributes.role_id") and len(attributes.role_id)>
		AND WORKGROUP_EMP_PAR.ROLE_ID = #attributes.role_id#
		</cfif>
		<cfif isdefined("attributes.role_employee_id") and len(attributes.role_employee_id) and len(attributes.role_employee_name)>
		AND WORKGROUP_EMP_PAR.EMPLOYEE_ID = #attributes.role_employee_id#
		</cfif>
</cfif>


<cfif not len(attributes.is_employee) and (not len(attributes.role_employee_id) and not len(attributes.role_employee_name))>UNION</cfif>

<cfif ((attributes.is_employee eq 0) or not len(attributes.is_employee)) and (not len(attributes.role_employee_id) and not len(attributes.role_employee_name))>
	SELECT 
		-1 AS USER_ID,
		'' AS USER_NAME,
		'' AS USER_SURNAME, 
		WORKGROUP_EMP_PAR.WRK_ROW_ID,
		WORKGROUP_EMP_PAR.WORKGROUP_ID,
		WORKGROUP_EMP_PAR.PARTNER_ID,
		WORKGROUP_EMP_PAR.POSITION_CODE,
		WORKGROUP_EMP_PAR.ROLE_ID,
		WORKGROUP_EMP_PAR.PROJECT_ID,
		WORKGROUP_EMP_PAR.COMPANY_ID,
		WORKGROUP_EMP_PAR.HIERARCHY AS HIERARCHY,
		WORKGROUP_EMP_PAR.ROLE_HEAD,
		WORKGROUP_EMP_PAR.IS_REAL,
		WORKGROUP_EMP_PAR.UPPER_ROW_ID,
		WORKGROUP_EMP_PAR.EMPLOYEE_ID,
		WORKGROUP_EMP_PAR.IS_CRITICAL,
		WORKGROUP_EMP_PAR.IS_ORG_VIEW,
		WORK_GROUP.WORKGROUP_NAME AS WORKGROUP_NAME
	FROM 
		WORKGROUP_EMP_PAR,
		WORK_GROUP
	WHERE 
		WORKGROUP_EMP_PAR.WORKGROUP_ID = WORK_GROUP.WORKGROUP_ID AND 
		WORKGROUP_EMP_PAR.POSITION_CODE IS NULL AND 
		WORKGROUP_EMP_PAR.PARTNER_ID IS NULL AND 
		WORKGROUP_EMP_PAR.EMPLOYEE_ID IS NULL AND 
		WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND ROLE_HEAD LIKE '%#ATTRIBUTES.KEYWORD#%'
		</cfif>
		<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
		AND HIERARCHY LIKE '#ATTRIBUTES.hierarchy#%'
		</cfif>
		<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
		AND WORK_GROUP.WORKGROUP_ID = #attributes.workgroup_id#
		</cfif>
		<cfif isdefined("attributes.role_id") and len(attributes.role_id)>
		AND WORKGROUP_EMP_PAR.ROLE_ID = #attributes.role_id#
		</cfif>
</cfif>
ORDER BY 
	WORKGROUP_NAME, 
	HIERARCHY
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default=#GET_USERS.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="employees" action="#request.self#?fuseaction=hr.popup_list_select_roles" method="post">
			<cf_box_search>
				<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>" placeholder="<cfoutput>#getLang('','Filtre',57460)#</cfoutput>" maxlength="255">
				</div>
				<div class="form-group">
					<input type="text" name="hierarchy" id="hierarchy" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" placeholder="<cfoutput>#getLang('','Hierarşi',57761)#</cfoutput>" maxlength="255">
				</div>
				<div class="form-group">
					<select name="is_employee" id="is_employee">
						<option value="" <cfif attributes.is_employee eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_employee eq 1>selected</cfif>><cf_get_lang dictionary_id ='55541.Dolu'></option>
						<option value="0" <cfif attributes.is_employee eq 0>selected</cfif>><cf_get_lang dictionary_id ='55552.Boş'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#"></td>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>	 --->		
				</div>
			</cf_box_search>
		</cfform>
		<cf_box_search_detail>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-role_employee_name">
					<input type="hidden" name="role_employee_id" id="role_employee_id" value="<cfoutput>#attributes.role_employee_id#</cfoutput>">      
					<div class="input-group">
						<input type="text" name="role_employee_name" id="role_employee_name" value="<cfif isdefined("attributes.role_employee_name")><cfoutput>#attributes.role_employee_name#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=employees.role_employee_id&field_name=employees.role_employee_name&select_list=1','list','popup_list_positions')"></span>
					</div>
				</div>
				<div class="form-group" id="item-role_employee_name">
					<select name="workgroup_id" id="workgroup_id">
						<option value=><cf_get_lang dictionary_id='58140.İş Grubu'></option>
						<cfoutput query="get_workgroup_name">
							<option value="#workgroup_id#" <cfif isdefined("attributes.workgroup_id") and attributes.workgroup_id eq workgroup_id>selected</cfif>>#hierarchy# #workgroup_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-role_employee_name">
					<select name="role_id" id="role_id">
						<option value=><cf_get_lang dictionary_id ='56594.Rol Tipi'></option>
						<cfoutput query="get_role_name">
							<option value="#project_roles_id#" <cfif isdefined("attributes.role_id") and attributes.role_id eq project_roles_id>selected</cfif>>#PROJECT_ROLES#</option>
						</cfoutput>
					</select>
				</div>
			</div>
		</cf_box_search_detail>
	</cf_box>
	<cf_box title="#getLang('','İş Grubu Rolleri',56593)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58140.İş Grubu'></th>
					<th><cf_get_lang dictionary_id='57761.Hiyerarşi'></th>
					<th><cf_get_lang dictionary_id ='56596.Rol Adı'></th>
					<th><cf_get_lang dictionary_id ='56597.Roldeki Kişi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif GET_USERS.recordcount>
					<cfoutput query="GET_USERS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<tr>
						<td>#workgroup_name#</td>
						<td>
							<cfif len(user_name)>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56598.Bu Rolde Kayıtlı Olan Kişiyi Silinecektir! Emin misiniz'></cfsavecontent>
								<a href="##" onClick="javascript:if(confirm('#message#')) window.location.href='#request.self#?fuseaction=hr.emptypopup_add_position_to_role&employee_id=#attributes.employee_id#&WRK_ROW_ID=#WRK_ROW_ID#'; else return false;" class="tableyazi">#hierarchy#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=hr.emptypopup_add_position_to_role&employee_id=#attributes.employee_id#&WRK_ROW_ID=#WRK_ROW_ID#" class="tableyazi">#hierarchy#</a>
							</cfif>
						</td>
						<td>#role_head#</td>
						<td>#user_name# #user_surname#</td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>	
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfset url_str = "#url_str#&is_employee=#attributes.is_employee#">
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.role_employee_id") and len(attributes.role_employee_id)>
			<cfset url_str = "#url_str#&role_employee_id=#attributes.role_employee_id#">
			</cfif>
			<cfif isdefined("attributes.role_employee_name") and len(attributes.role_employee_name)>
			<cfset url_str = "#url_str#&role_employee_name=#attributes.role_employee_name#">
			</cfif>
			<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
			<cfset url_str = "#url_str#&workgroup_id=#attributes.workgroup_id#">
			</cfif>
			<cfif isdefined("attributes.role_id") and len(attributes.role_id)>
			<cfset url_str = "#url_str#&role_id=#attributes.role_id#">
			</cfif>
			<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
			<cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
			</cfif>
			<!-- sil -->
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="hr.popup_list_select_roles&employee_id=#attributes.employee_id##url_str#"> 
			<!-- sil -->
		</cfif>
	</cf_box>
</div>