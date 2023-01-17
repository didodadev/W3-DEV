<cfquery name="get_all_emp_par" datasource="#DSN#">
	SELECT 
		1 TYPE,
		EMPLOYEE_POSITIONS.POSITION_CODE MEMBER_ID,
		-1 COMPANY_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME MEMBER_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME MEMBER_SURNAME,
		' ' NICKNAME,
		WORKGROUP_EMP_PAR.OUR_COMPANY_ID OUR_COMPANY,
		WORKGROUP_EMP_PAR.ROLE_ID ROLE,
		WORKGROUP_EMP_PAR.IS_MASTER MASTER
	FROM 
		EMPLOYEE_POSITIONS,
		WORKGROUP_EMP_PAR
	WHERE 
		EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND 
		<cfif isDefined("attributes.action_id")>
			WORKGROUP_EMP_PAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
			WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL AND
		<cfelseif isDefined("attributes.action_id_2")>
			WORKGROUP_EMP_PAR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#"> AND
			WORKGROUP_EMP_PAR.CONSUMER_ID IS NOT NULL AND
		</cfif>
		WORKGROUP_EMP_PAR.POSITION_CODE IS NOT NULL AND
		WORKGROUP_EMP_PAR.OUR_COMPANY_ID IS NOT NULL
	UNION
	SELECT 
		2 TYPE,
		COMPANY_PARTNER.PARTNER_ID MEMBER_ID,
		COMPANY_PARTNER.COMPANY_ID COMPANY_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME MEMBER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
		COMPANY.NICKNAME NICKNAME,
		WORKGROUP_EMP_PAR.OUR_COMPANY_ID OUR_COMPANY,
		WORKGROUP_EMP_PAR.ROLE_ID ROLE,
		WORKGROUP_EMP_PAR.IS_MASTER MASTER
	FROM 
		COMPANY_PARTNER,
		COMPANY,
		WORKGROUP_EMP_PAR
	 WHERE 
		COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID AND
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		<cfif isdefined("attributes.action_id")>
			WORKGROUP_EMP_PAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
			WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL AND
		<cfelseif isDefined("attributes.action_id_2")>
			WORKGROUP_EMP_PAR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#"> AND
			WORKGROUP_EMP_PAR.CONSUMER_ID IS NOT NULL AND
		</cfif>
	 	WORKGROUP_EMP_PAR.PARTNER_ID IS NOT NULL AND
		WORKGROUP_EMP_PAR.OUR_COMPANY_ID IS NOT NULL
	 ORDER BY
		OUR_COMPANY,
		MEMBER_ID		
</cfquery>

<cfquery name="company_name" datasource="#DSN#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY COMP_ID 
</cfquery>

<cfset our_company_list = listsort(listdeleteduplicates(valuelist(company_name.comp_id,',')),'numeric','ASC',',')>
<cfif get_all_emp_par.recordcount>
	<cfset role_id_list =''>
	<cfoutput query="get_all_emp_par">
		<cfif len(role) and not listfind(role_id_list,role)>
			<cfset role_id_list=listappend(role_id_list,role)>
		</cfif>
	</cfoutput>
	<cfif len(role_id_list)>
		<cfquery name="get_rol_name" datasource="#DSN#">
			SELECT PROJECT_ROLES_ID, PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID IN (#role_id_list#) ORDER BY PROJECT_ROLES_ID
		</cfquery>
		<cfset role_id_list = listsort(listdeleteduplicates(valuelist(get_rol_name.project_roles_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>

<cf_ajax_list>
    <tbody>
    <cfif get_all_emp_par.recordcount>
        <cfoutput query="get_all_emp_par" group="our_company">
            <tr>
                <td><b>#company_name.nick_name[listfind(our_company_list,our_company,',')]#</b><br />
                    <cfoutput>
                        <cfif type eq 1>
                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#member_id#','','ui-draggable-box-medium');">#member_name# #member_surname#</a>
                            <cfif len(role)> - #get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif><cfif master eq 1> - Master</cfif><br /> <!--- Master --->
                        <cfelseif type eq 2>
                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#member_id#');"> #member_name# #member_surname# - #nickname#</a>
                            <cfif len(role)> - #get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif><br />
                        </cfif>
                    </cfoutput>
                    <br />
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
        </tr>		
    </cfif>
    </tbody> 
</cf_ajax_list>
