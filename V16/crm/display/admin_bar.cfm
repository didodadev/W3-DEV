<cfoutput>
	<ul id="tree">
    	<li><strong>MYS Admin</strong> 
			<ul>
				<cfif not listfindnocase(denied_pages,'crm.my_buyers')>
                    <li><a href="#request.self#?fuseaction=crm.my_buyers"><cf_get_lang no ='181.Müşterilerim'></a></li>
                </cfif>
				<cfif not listfindnocase(denied_pages,'crm.list_branch_transfer')>
                    <li><a href="#request.self#?fuseaction=crm.list_branch_transfer"><cf_get_lang no ='790.Şube Aktarım Listesi'></a></li>
                </cfif>	
				<cfif not listfindnocase(denied_pages,'crm.form_add_member_admin')>
                    <li><a href="#request.self#?fuseaction=crm.form_add_member_admin">CRM Admin</a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_dsp_search_company')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_search_company','project');"><cf_get_lang no ='289.Müşteri Ara'>-<cf_get_lang no ='667.Şubem İle İlişkilendir'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_add_new_ims_code')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_new_ims_code','small');"><cf_get_lang no ='791.IMS Lokasyon Değişikliği'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_dsp_company_boyut_depo_kod_control')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_company_boyut_depo_kod_control','list');"><cf_get_lang no ='675.Boyuta Aktarılmamış Müşteriler'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_add_company_values')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_company_values','small');"><cf_get_lang no ='792.Müşteri Bilgisi İmport'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_add_company_to_boyut')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_company_to_boyut','medium');"><cf_get_lang no ='680.Toplu Müşteri Aktarımı'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_add_chance_position_mission')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_chance_position_mission','project');"><cf_get_lang no ='686.Toplu Pozisyon Görevi Değiştir'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_form_add_change_company_info')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_form_add_change_company_info','project');"><cf_get_lang no ='705.Toplu Müşteri Bilgisi Değiştir'></a></li>
                </cfif>
                <cfif not listfindnocase(denied_pages,'crm.popup_form_add_change_branch_info')>
                    <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_form_add_change_branch_info','project');"><cf_get_lang no ='714.Toplu Şube Bilgisi Aktar'></a></li>
                </cfif>
                <cfif get_module_power_user(52) and not listfindnocase(denied_pages,'crm.branch_managers')>
                    <li><a href="#request.self#?fuseaction=crm.branch_managers"><cf_get_lang no ='793.Şube ve Operasyon Müdürleri'></a></li>
                </cfif>
                <cfif get_module_power_user(52) and not listfindnocase(denied_pages,'crm.branch_transfer_definition')>
                    <li><a href="#request.self#?fuseaction=crm.branch_transfer_definition"><cf_get_lang no ='794.Şube Aktarım Tanımları'></a></li>
                </cfif>
                <cfif get_module_power_user(52) and not listfindnocase(denied_pages,'crm.risk_limit_definition')>
                    <li><a href="#request.self#?fuseaction=crm.risk_limit_definition"><cf_get_lang no ='1032.Üst Risk Limiti Tanımı'></a></li>
                </cfif>
    		</ul>
        </li>
    </ul>
</cfoutput>
