<cfsetting showdebugoutput="no">
<cfquery name="get_member_team" datasource="#dsn#">
	SELECT 
		PARTNER_ID 
	FROM 
		WORKGROUP_EMP_PAR 
	WHERE 
		COMPANY_ID = <cfif isdefined('attributes.company_id')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"></cfif> AND 
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
</cfquery>
<cfquery name="get_rol" datasource="#dsn#">
	SELECT PROJECT_ROLES_ID,PROJECT_ROLES FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES	
</cfquery>
<cfform name="add_member_team" action="#request.self#?fuseaction=objects2.emptypopup_add_member_team">
<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
<input type="hidden" name="my_team" id="my_team" value="<cfoutput>#get_member_team.recordcount#</cfoutput>">
<table cellspacing="0" cellpadding="0" border="0" width="150" height="100%">
	<tr>
	  <td>Rol *</td>
	  <td class="txtbold">
		<select name="role_name" id="role_name" style="width:120px;">
			<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
			 <cfloop query="get_rol">
				<cfoutput><option value="#project_roles_id#">#project_roles#</option></cfoutput>
			</cfloop>
		</select>
	  </td>
	</tr>
	<tr height="35">
		<td></td>
		<td><input type="button" style="width:50px;" value="Ekle" onClick="add_team();"></td>
	</tr>
</table>
<div id="SHOW_UPD_MESSAGE"></div>
</cfform>
<script type="text/javascript">
	function add_team(){
	if (document.add_member_team.role_name[add_member_team.role_name.selectedIndex].value == '')
	{
		alert("Lütfen Kendinize Bir Rol Belirleyiniz!");
		return false;
	}
	if (document.add_member_team.my_team.value == '' || document.add_member_team.my_team.value != 0)
	{
		alert("Bu Ekibe Kayıtlısınız!");
		return false;
	}
	 AjaxFormSubmit('add_member_team','SHOW_UPD_MESSAGE','1','Ekleniyor..','Eklendi.','','SHOW_LIST_PAGE')
	}
</script>

