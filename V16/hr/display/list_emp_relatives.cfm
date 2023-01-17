<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'hr.employee_relative')>
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
    <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
		<cfset totalValues = structNew()>
		<cfset totalValues = {
				total_offtime : 0
			}>
<cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
	<cfset url_str="#url_str#&comp_id=#attributes.comp_id#">
</cfif>
		<cfset action_list_id = replace(attributes.action_list_id,";",",","all")>
		<cf_workcube_general_process
			mode = "query"
			general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
			general_paper_no = "#attributes.general_paper_no#"
			general_paper_date = "#attributes.general_paper_date#"
			action_list_id = "#action_list_id#"
			process_stage = "#attributes.process_stage#"
			general_paper_notice = "#attributes.general_paper_notice#"
			responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
			responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
			action_table = 'EMPLOYEES_RELATIVES'
			action_column = 'RELATIVE_ID'
			action_page = '#request.self#?fuseaction=hr.employee_relative'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>
<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:'wrk')>
<cfelse>
    <cfset attributes.employee_id = attributes.employee_id>
</cfif>
<cfinclude template="../query/get_relatives.cfm">
<cf_box title="#getLang('','Çalışan Yakınları',31276)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#employee_id#&action_row_id=0&print_type=173">
    <cf_box_elements>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='55693.Yakınlık'></th>
                    <th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                    <th><cf_get_lang dictionary_id='58627.Kimlik No'></th>
                    <th><cf_get_lang dictionary_id='57419.Eğitim'></th>
                    <th><cf_get_lang dictionary_id='58445.İş'></th>
                    <th><cf_get_lang dictionary_id='58560.İndirim'></th>
                    <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th width="20"><a href="javascript://" onclick="javascript:openBoxDraggable(<cfoutput>'#request.self#?fuseaction=hr.employee_relative&employee_id=#attributes.employee_id#&draggable=1','relatives'</cfoutput>);"><i class="fa fa-plus" title="Ekle"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_relatives.recordcount>
                <cfoutput query="get_relatives">
                    <cfif relative_level eq 1><cfsavecontent variable="relative_type"><cf_get_lang dictionary_id='31327.Baba'></cfsavecontent>
                        <cfelseif relative_level eq 2><cfsavecontent variable="relative_type"><cf_get_lang dictionary_id='31328.Anne'></cfsavecontent>
                        <cfelseif relative_level eq 3><cfsavecontent variable="relative_type"><cf_get_lang dictionary_id='55275.Eşi'></cfsavecontent>
                        <cfelseif relative_level eq 4><cfsavecontent variable="relative_type"><cf_get_lang dictionary_id='55253.Oğlu'></cfsavecontent>
                        <cfelseif relative_level eq 5><cfsavecontent variable="relative_type"><cf_get_lang dictionary_id='55234.Kızı'></cfsavecontent>
                        <cfelseif relative_level eq 6><cfsavecontent variable="relative_type"><cf_get_lang dictionary_id='56360.Kardeşi'></cfsavecontent>
                    </cfif>
                    <tr>
                        <td>
                            <cfif isDefined("relative_url_string") and len(relative_url_string)>
                                <a href="javascript://" onClick="add_pos('#name#','#surname#','#relative_name#','#relative_id#','#relative_type#','#DateFormat(birth_date,dateformat_style)#','#birth_place#','#tc_identy_no#','#sex#')">#name# #surname#</a>
                            <cfelse>
                                #name# #surname#
                            </cfif>
                        </td>
                        <td>#relative_type#</td>
                        <td>#DateFormat(birth_date,dateformat_style)#</td>
                        <td>#tc_identy_no#</td>
                        <td><cfif education_status eq 1><cf_get_lang dictionary_id='56363.Öğrenci'><cfelse><cf_get_lang dictionary_id='56364.Okumuyor'></cfif></td>
                        <td><cfif work_status eq 1><cf_get_lang dictionary_id='55755.Çalışıyor'><cfelse><cf_get_lang dictionary_id='56365.Çalışmıyor'></cfif></td>
                        <td><cfif discount_status eq 1><cf_get_lang dictionary_id='29492.Kullanıyor'><cfelse><cf_get_lang dictionary_id='29493.Kullanmıyor'></cfif></td>
                        <td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
                        <td width="15" align="center"><cfif attributes.fuseaction neq '#fusebox.circuit#.employee_relative_ssk'>
                            <cfif fusebox.circuit eq 'myhome'>
                                <cfset RELATIVE_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:RELATIVE_ID,accountKey:'wrk')>
                                <cfset employee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:'wrk')>
                                
                            <cfelse>
                                <cfset RELATIVE_ID_ = RELATIVE_ID>
                                <cfset employee_id_ = employee_id>
                            </cfif>
                            <!--- <a href="#request.self#?fuseaction=#fusebox.circuit#.employee_relative#ssk_ek#&event=upd#relative_url_string#&employee_id=#employee_id_#&relative_id=#RELATIVE_ID_#"><i class="fa fa-pencil" align="absmiddle" border="0"></i></a></cfif> --->
                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.employee_relative<cfif isDefined("ssk_ek")>#ssk_ek#</cfif>&event=upd<cfif isDefined("relative_url_string")>#relative_url_string#</cfif>&employee_id=#employee_id_#&relative_id=#RELATIVE_ID_#&draggable=1', 'upd_relatives_box')"><i class="fa fa-pencil" align="absmiddle" border="0"></i></a></cfif>
                        </td>
                    </tr>
                </cfoutput>
                <cfelse>
                <tr><td colspan="9"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td></tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box_elements>
</cf_box>