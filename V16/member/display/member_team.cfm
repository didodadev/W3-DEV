<!--- Kurumsal ve Bireysel Uye Ekibi --->
<cfinclude template="../query/get_all_emp_par.cfm">
<cfquery name="company_name" datasource="#dsn#">
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
		<cfquery name="get_rol_name" datasource="#dsn#">
			SELECT PROJECT_ROLES_ID, PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID IN (#role_id_list#) ORDER BY PROJECT_ROLES_ID
		</cfquery>
		<cfset role_id_list = listsort(listdeleteduplicates(valuelist(get_rol_name.project_roles_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
    <tr class="color-header" height="22"> 
        <cfif isDefined("attributes.cpid")>
            <td class="form-title" width="99%"><cf_get_lang dictionary_id='30199.Kurumsal Üye Ekibi'></td>
            <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_form_upd_worker&company_id=#attributes.cpid#</cfoutput>','page_horizantal','popup_form_upd_worker');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="absmiddle"></a></td>
        <cfelse>
            <td class="form-title" width="99%"><cf_get_lang dictionary_id='30564.Bireysel Üye Ekibi'></td>
            <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_form_upd_worker&consumer_id=#attributes.cid#</cfoutput>','page_horizantal','popup_form_upd_worker');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="absmiddle"></a></td>
        </cfif>
    </tr>
    <tr class="color-row">
        <td colspan="2" height="20"> 
        <table width="100%" cellpadding="0" cellspacing="0">
        <cfif get_all_emp_par.recordcount>
		<cfoutput query="get_all_emp_par" group="our_company">
            <tr>
                <td><b>#company_name.nick_name[listfind(our_company_list,our_company,',')]#</b><br/>
                    <cfoutput>
                        <cfif type eq 1>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#member_id#','medium','popup_emp_det');" class="tableyazi">#member_name# #member_surname#</a>
                            <cfif len(role)> - #get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif><cfif master eq 1> - <cf_get_lang dictionary_id='30562.Master'></cfif><br/>
                        <cfelseif type eq 2>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#member_id#','medium','popup_par_det');" class="tableyazi"> #member_name# #member_surname# - #nickname#</a>
                            <cfif len(role)> - #get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif><br/>
                        </cfif>
                    </cfoutput>
                    <br/>
                </td>
            </tr>
        </cfoutput>
		<cfelse>
			<tr class="color-row">
				<td colspan="2" height="15"><cf_get_lang dictionary_id='57484.Kayit Yok'></td>
			</tr>		
		</cfif>        
        </table>
        </td>
    </tr>
</table>

