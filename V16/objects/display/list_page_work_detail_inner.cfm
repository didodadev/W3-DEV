<cf_get_lang_set module_name="objects">
<cfif not isdefined("from_in_out")>
	<cfset from_in_out = 0>
</cfif>
<cfquery name="get_note" datasource="#dsn#">
	SELECT * FROM NOTES WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND ACTION_SECTION = 'EMPLOYEE_ID'
</cfquery>
<cfif from_in_out eq 0>
	<cfquery name="get_assetps" datasource="#dsn#">
		SELECT
			ASSET_P.ASSETP_ID,
			ASSET_P.ASSETP,
			ASSET_P_CAT.ASSETP_CAT
		FROM
			ASSET_P
			LEFT JOIN ASSET_P_CAT ON ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
		WHERE
			ASSET_P.STATUS = 1 AND
			ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		ORDER BY
			ASSET_P.ASSETP
	</cfquery>

	<cfquery name="get_zimmets" datasource="#dsn#">
		SELECT 
			ERZR.* 
		FROM 
			EMPLOYEES_INVENT_ZIMMET_ROWS ERZR,
			EMPLOYEES_INVENT_ZIMMET EIZ
		WHERE 
			ERZR.ZIMMET_ID = EIZ.ZIMMET_ID AND
			EIZ.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
</cfif>
<cfquery name="get_all_emps" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID MEMBER_ID,
		EMPLOYEES.EMPLOYEE_NAME MEMBER_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME MEMBER_SURNAME,
		WORKGROUP_EMP_PAR.ROLE_ID ROLE,
		SPR.PROJECT_ROLES
	FROM 
		EMPLOYEES,
		WORKGROUP_EMP_PAR
		LEFT JOIN SETUP_PROJECT_ROLES SPR ON WORKGROUP_EMP_PAR.ROLE_ID = PROJECT_ROLES_ID
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
		WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	 ORDER BY
		MEMBER_ID		
</cfquery>

<cfquery name="get_all_emps_related" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID MEMBER_ID,
		EMPLOYEES.EMPLOYEE_NAME MEMBER_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME MEMBER_SURNAME,
		WORKGROUP_EMP_PAR.ROLE_ID ROLE,
		SPR.PROJECT_ROLES
	FROM
		EMPLOYEES,
		WORKGROUP_EMP_PAR
		LEFT JOIN SETUP_PROJECT_ROLES SPR ON WORKGROUP_EMP_PAR.ROLE_ID = PROJECT_ROLES_ID
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID AND
		WORKGROUP_EMP_PAR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID IS NOT NULL
	 ORDER BY
		MEMBER_ID
</cfquery>
<cfset role_id_list = ''>
<cfoutput query="get_all_emps">
	<cfif len(role) and not listfind(role_id_list,role)>
		<cfset role_id_list=listappend(role_id_list,role)>
	</cfif>
</cfoutput>
<cfoutput query="get_all_emps_related">
	<cfif len(role) and not listfind(role_id_list,role)>
		<cfset role_id_list=listappend(role_id_list,role)>
	</cfif>
</cfoutput>
<cfif len(role_id_list)>
	<cfquery name="get_rol_name" datasource="#dsn#">
		SELECT PROJECT_ROLES_ID,PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID IN (#role_id_list#)
	</cfquery>
	<cfset role_id_list = listsort(listdeleteduplicates(valuelist(get_rol_name.project_roles_id,',')),'numeric','ASC',',')>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfif from_in_out eq 0>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
			<cf_seperator id="zimmet" title="#getLang('','Çalışan Zimmetleri','41817')#">
			<div id="zimmet" class="scrollContent scroll-x3">
				<cf_flat_list>
					<cfif get_assetps.recordcount>
						<cfoutput query="get_assetps">
							<tr>
								<td><b>#assetp#</b> / #assetp_cat#</td>
							</tr>
						</cfoutput>
					</cfif>
					<cfif get_zimmets.recordcount>
						<cfoutput query="get_zimmets">
							<tr>
								<td><b>#DEVICE_NAME#</b> / <cf_get_lang dictionary_id='57487.No'>: #INVENTORY_NO# (#PROPERTY#)</td>
							</tr>
						</cfoutput>
					</cfif>
					<cfif not (get_assetps.recordcount or get_zimmets.recordcount)>
						<tr>
							<td><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				</cf_flat_list>
			</div>
		</div>
	</cfif>
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
		<cf_seperator id="emp_notes" title="#getLang('','Çalışan Notları','33681')#">
		<div id="emp_notes">
			<cf_flat_list>
				<cfif get_all_emps.recordcount>
					<cfoutput query="get_note">
						<tr>
							<td class="txtboldblue" height="20"><li>#NOTE_HEAD#</li></td>
						</tr>
						<tr>
							<td>#NOTE_BODY#</td>
						</tr>					  					  					  
					</cfoutput>
				<cfelse>
					<tr>
						<td><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</cf_flat_list>
		</div>
	</div>
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
		<cf_seperator id="emp_relations" title="#getLang('','İlişkili Çalışanlar','33682')#">
		<div id="emp_relations">
			<cf_flat_list>
				<cfif get_all_emps.recordcount or get_all_emps_related.recordcount>
					<cfoutput query="get_all_emps">
						<tr>
							<td>
								<li>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium');" class="tableyazi">#member_name# #member_surname#</a>
									<cfif len(project_roles)> - #project_roles#</cfif>
								</li>
							</td>
						</tr>
					</cfoutput>
					<cfoutput query="get_all_emps_related">
					<tr>
						<td>
							<li>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium');" class="tableyazi">#member_name# #member_surname#</a>
								<cfif len(project_roles)> - #project_roles#</cfif>
							</li>
						</td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</cf_flat_list>
		</div>
	</div>
</div>
	
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">
