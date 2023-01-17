<cfquery name="get_position" datasource="#dsn#">
	SELECT POSITION_NAME,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #attributes.position_code#
</cfquery>
<cfquery name="get_workgroups" datasource="#dsn#">
	SELECT 
		WG.WORKGROUP_NAME,
		WG.HIERARCHY AS GROUP_HIERARCHY,
		WEP.*
	FROM 
		WORK_GROUP WG,
		WORKGROUP_EMP_PAR WEP
	WHERE 
		WG.WORKGROUP_ID=WEP.WORKGROUP_ID AND
		WEP.POSITION_CODE = #attributes.position_code#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29818.İş Grupları"></cfsavecontent>
<cf_medium_list_search title="#message#: #get_position.POSITION_NAME# (#get_position.EMPLOYEE_NAME# #get_position.EMPLOYEE_SURNAME#)">
    <cf_medium_list_search_area>
        <table>
            <tr>
                <td>
                  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_select_roles&position_code=#attributes.position_code#</cfoutput>','medium');"><cf_get_lang dictionary_id='55699.Gruba Çalışan Ekle'></a>
                  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_form_add_worker2&position_code=#attributes.position_code#</cfoutput>','medium');"><img src="/images/partner_plus.gif" title="Çalışanı Bir Gruba Ekle" border="0" align="absmiddle"></a></td>
                </td>
            </tr>
        </table>
    </cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
        <tr>
            <th><cf_get_lang dictionary_id="58140.İş Grubu"></th>
            <th width="100"><cf_get_lang dictionary_id="30395.Rol"></th>
            <th width="100"><cf_get_lang dictionary_id="56594.Rol Tipi"></th>
            <th width="60"><cf_get_lang dictionary_id="57756.Durum"></th>
            <th width="90"><cf_get_lang dictionary_id="35379.Grup Hiyerarşi"></th>
            <th width="90"><cf_get_lang dictionary_id="35378.Kişi Hierarchy"></th>
        </tr>
    </thead>
    <tbody>
		<cfif get_workgroups.recordcount>
			<cfoutput query="get_workgroups">
            <tr>
                <td>#workgroup_name#</td>
                <td>#role_head#</td>
                <td>
					<cfif len(ROLE_ID)>	
                        <cfquery name="GET_ROL_NAME" datasource="#dsn#">
                        	SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #ROLE_ID#
                        </cfquery>
                        #GET_ROL_NAME.PROJECT_ROLES#
                    </cfif>
                </td>
                <td><cfif is_real eq 1><cf_get_lang dictionary_id="53847.Asıl"><cfelseif is_real eq 0><cf_get_lang dictionary_id="53551.Vekil"><cfelse><cf_get_lang dictionary_id="58845.Tanımsız"></cfif></td>
                <td>#GROUP_HIERARCHY#</td>
                <td>#HIERARCHY#</td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
            	<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_medium_list>
