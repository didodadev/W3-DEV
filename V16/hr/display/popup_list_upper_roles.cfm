<cf_get_lang_set module_name="hr">
<cfquery name="GET_USERS" datasource="#dsn#">
SELECT 
	EMPLOYEES.EMPLOYEE_ID AS USER_ID, 
	EMPLOYEES.EMPLOYEE_NAME AS USER_NAME, 
	EMPLOYEES.EMPLOYEE_SURNAME AS USER_SURNAME, 
	WORKGROUP_EMP_PAR.*,
	WORK_GROUP.WORKGROUP_NAME 
FROM 
	EMPLOYEES, 
	WORKGROUP_EMP_PAR,
	WORK_GROUP
WHERE 
	<cfif isdefined("attributes.aktif_hierarchy") and len(attributes.aktif_hierarchy)>WORKGROUP_EMP_PAR.HIERARCHY <> '#attributes.aktif_hierarchy#' AND</cfif>
	WORKGROUP_EMP_PAR.WORKGROUP_ID = #ATTRIBUTES.WORKGROUP_ID# AND
	EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND 
	WORKGROUP_EMP_PAR.WORKGROUP_ID = WORK_GROUP.WORKGROUP_ID AND 
	WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL
UNION
SELECT 
	'' AS USER_ID, 
	'' AS USER_NAME, 
	'' AS USER_SURNAME, 
	WORKGROUP_EMP_PAR.*,
	WORK_GROUP.WORKGROUP_NAME
FROM 
	WORKGROUP_EMP_PAR,
	WORK_GROUP
WHERE 
	<cfif isdefined("attributes.aktif_hierarchy") and len(attributes.aktif_hierarchy)>WORKGROUP_EMP_PAR.HIERARCHY <> '#attributes.aktif_hierarchy#' AND</cfif>
	WORKGROUP_EMP_PAR.WORKGROUP_ID = #ATTRIBUTES.WORKGROUP_ID# AND
	WORKGROUP_EMP_PAR.WORKGROUP_ID = WORK_GROUP.WORKGROUP_ID AND 
	WORKGROUP_EMP_PAR.POSITION_CODE IS NULL AND 
	WORKGROUP_EMP_PAR.PARTNER_ID IS NULL AND 
	WORKGROUP_EMP_PAR.EMPLOYEE_ID IS NULL AND 
	WORKGROUP_EMP_PAR.HIERARCHY IS NOT NULL
ORDER BY WORK_GROUP.WORKGROUP_NAME,WORKGROUP_EMP_PAR.HIERARCHY
</cfquery>
<!--- popup_list_position_names --->
<script type="text/javascript">
	function add_name(row_id,deger,hierarchy)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.hierarchy_code#</cfoutput>.value=hierarchy;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.upper_rol_head#</cfoutput>.value=deger;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.upper_rol_id#</cfoutput>.value=row_id;
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>

<cf_box title="#getLang('','İş Grubu Rolleri',56593)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57761.Hierarşi'></th>
				<th><cf_get_lang dictionary_id='56596.Rol Adı'></th>
				<th><cf_get_lang dictionary_id='56597.Roldeki Kişi'></th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_USERS.recordcount>
			<cfoutput query="GET_USERS">
				<tr>
					<td><a href="javascript://" onClick="add_name('#WRK_ROW_ID#','#role_head# #user_name# #user_surname#','#hierarchy#');">#hierarchy#</a></td>
					<td>#role_head#</td>
					<td>#user_name# #user_surname#</td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
</cf_box>
</cf_get_lang_set>

