<cfquery name="get_all_emps_pars" datasource="#dsn#">
    SELECT 
        1 TYPE,
        EMPLOYEE_POSITIONS.EMPLOYEE_ID MEMBER_ID,
        EMPLOYEE_POSITIONS.EMPLOYEE_NAME MEMBER_NAME,
        EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME MEMBER_SURNAME,
        '' NICKNAME,
        WORKGROUP_EMP_PAR.ROLE_ID ROLE,
        WORKGROUP_EMP_PAR.IS_MASTER IS_MASTER
    FROM 
        EMPLOYEE_POSITIONS,
        WORKGROUP_EMP_PAR
    WHERE 
        WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NOT NULL AND
        <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
			WORKGROUP_EMP_PAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		<cfelse>
			WORKGROUP_EMP_PAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
		</cfif>
        EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND
        WORKGROUP_EMP_PAR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
	UNION ALL
    SELECT 
        2 TYPE,
        COMPANY_PARTNER.PARTNER_ID MEMBER_ID,
        COMPANY_PARTNER.COMPANY_PARTNER_NAME MEMBER_NAME,
        COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
        COMPANY.NICKNAME NICKNAME,
        WORKGROUP_EMP_PAR.ROLE_ID ROLE,
        WORKGROUP_EMP_PAR.IS_MASTER IS_MASTER
    FROM 
        COMPANY_PARTNER,
        COMPANY,
        WORKGROUP_EMP_PAR
    WHERE 
        WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL AND
		COMPANY_PARTNER.PARTNER_ID IS NOT NULL AND
         <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
			WORKGROUP_EMP_PAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		<cfelse>
			WORKGROUP_EMP_PAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
		</cfif>
        COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID AND
        COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
        WORKGROUP_EMP_PAR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
</cfquery>	
<cfif get_all_emps_pars.recordcount>
    <cfset role_id_list =''>
	<cfoutput query="get_all_emps_pars">
        <cfif len(role) and not listfind(role_id_list,role)>
            <cfset role_id_list=listappend(role_id_list,role)>
        </cfif>
    </cfoutput>
    <cfif len(role_id_list)>
        <cfquery name="get_rol_name" datasource="#dsn#">
            SELECT PROJECT_ROLES_ID,PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID IN (#role_id_list#) ORDER BY PROJECT_ROLES_ID
        </cfquery>
        <cfset role_id_list = listsort(listdeleteduplicates(valuelist(get_rol_name.project_roles_id,',')),'numeric','ASC',',')>
    </cfif>
</cfif>
<cfsavecontent variable="team"><cf_get_lang dictionary_id="30199.Kurumsal Üye Ekibi"></cfsavecontent>
<cf_box title="#team#" add_href=""  closable="0">
	<div class="table-responsive-lg">
		<table>
			<cfif get_all_emps_pars.recordcount>
				<cfoutput query="get_all_emps_pars">
					<tr height="30">
						<td width="21"><cf_online id="#member_id#" zone="ep"></td>
						<td>
							<cfif type eq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#encrypt(member_id,"WORKCUBE","BLOWFISH","Hex")#','list')" class="tableyazi" >#member_name# #member_surname#</a><cfif is_master eq 1><i> - <cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></i></cfif>
							<cfelseif type eq 2>
								#member_name# #member_surname# - #nickname#
							</cfif>
							/
							<cfif len(role)>#get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif>
						</td>
					</tr>
					<cfif get_all_emps_pars.recordcount neq currentrow>
					<tr>
						<td colspan="2"><hr style="color:CCCCCC; height:0.1px;" /></td>
					</tr>
					</cfif>
				</cfoutput>
			<cfelse>
				<tr height="30">
					<td colspan="2">Kayıt Yok!</td>
				</tr>
			</cfif>
			<cfif isdefined('attributes.is_member_add_team') and attributes.is_member_add_team eq 1>
				<tr>
					<td colspan="2"><hr style="color:CCCCCC; height:0.1px;" /></td>
				</tr>
				<tr height="35">
					<td colspan="2"><a onClick="gizle_goster(my_add_team);" style="cursor:pointer;"><img src="/images/pod_edit.gif" border="0"></a>&nbsp;&nbsp;<b>Ekibe Katılmak İçin Tıklayınız.</b></td>
				</tr>
				<tr style="display:none;" id="my_add_team">
					<td colspan="2"><cfinclude template="add_member_group_team.cfm"></td>
				</tr>
			</cfif>
		</table>
	</div>
</cf_box>