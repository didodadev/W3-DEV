<cfinclude template="../query/get_company_assistance_info_list.cfm">
<cfsavecontent variable="title"><cf_get_lang no='160.Yardımcı Personel Bilgileri'></cfsavecontent>
<cf_box title="#title#">
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cf_grid_list>
    <thead>
        <tr>
            <th width="35"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='158.Ad Soyad'></th>
            <th><cf_get_lang_main no='1085.Pozisyon'></th>
            <th><cf_get_lang no='281.Mal Alımındaki Etkinliği'></th>
            <th><cf_get_lang no='282.Depo İle İlişkileri'></th>
            <th width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_assistance_info&cpid=#attributes.cpid#</cfoutput>');"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_company_assistance_info_list.recordcount>
            <cfoutput query="get_company_assistance_info_list">
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=crm.popup_upd_company_assistance_info&partner_id=#partner_id#')">#company_partner_name# #company_partner_surname#</a></td>
                    <td>#partner_position#</td>
                    <td><cfif len(get_company_assistance_info_list.purchase_authority)>
                        <cfset attributes.purchase_authority_id = get_company_assistance_info_list.purchase_authority>
                        <cfinclude template="../query/get_authority.cfm">#get_authority.authority_name#</cfif>
                    </td>
                    <td><cfif len(get_company_assistance_info_list.depot_relation)>
                        <cfset attributes.depot_relation_id = get_company_assistance_info_list.depot_relation>
                        <cfinclude template="../query/get_relation.cfm">#get_relation.partner_relation#</cfif>
                    </td>
                    <td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=crm.popup_upd_company_assistance_info&partner_id=#partner_id#')"><i class="fa fa-pencil"></i></a></td>
                </tr>
            </cfoutput>
            <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
</cf_box>

