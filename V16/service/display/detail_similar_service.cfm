<cfinclude template="../query/get_service_detail.cfm">
<cfoutput>
	<cfset partner_id=get_service_detail.service_partner_id>
	<cfset consumer_id=get_service_detail.service_consumer_id>
	<cfset employee_id=get_service_detail.service_employee_id>
	<cfset service_id=get_service_detail.service_id>
	<cfinclude template="../query/get_service_task.cfm">
	<cfinclude template="../query/get_service_reply.cfm">
</cfoutput>
<cfsavecontent variable="txt">
<cfif not listfindnocase(denied_pages,'service.upd_service')>
	<cfoutput>
        <a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#';self.close();"><img src="/images/refer.gif" title="<cf_get_lang_main no='359.Detay'>" border="0"></a>
    </cfoutput>	
</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('service',57)# #get_service_detail.service_head#" edit_href="javascript:window.opener.location.href='#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#';self.close();"><!---Başvuru--->
        <cf_flat_list>
            <tr>
                <td class="bold"><cf_get_lang no='84.Başvuru No'></td>
                <td>
                    <cfoutput>#get_service_detail.service_id#</cfoutput> - 
                    <cfif get_service_detail.service_active eq 1>
                        <cf_get_lang_main no='81.Aktif'>
                    <cfelse>
                        <cf_get_lang_main no='82.Pasif'>
                    </cfif>
                </td>
                <td class="bold"><cf_get_lang_main no='73.Öncelik'></td>
                <td>
                    <cfset attributes.priority_id = get_service_detail.priority_id>
                    <cfinclude template="../query/get_priority.cfm">
                    <cfoutput query="get_priority">#priority#</cfoutput>	
                </td>
            </tr>
            <tr>
                <td class="bold"><cf_get_lang no='85.Kayıt Yöntemi'></td>
                <td>
                    <cfset attributes.commethod_id = get_service_detail.commethod_id>
                    <cfinclude template="../query/get_com_method.cfm">
                    <cfoutput>#get_com_method.commethod#</cfoutput>
                </td>
                <td class="bold"><cf_get_lang_main no='74.Kategori'></td>
                <td>
                    <cfset attributes.servicecat_id = get_service_detail.servicecat_id>
                    <cfinclude template="../query/get_service_appcat.cfm">
                    <cfoutput query="get_service_appcat">#servicecat#</cfoutput>
                </td>
            </tr>
            <tr>
                <td class="bold"><cf_get_lang_main no='68.Başlık'></td>
                <td><cfoutput>#get_service_detail.service_head#</cfoutput></td>
                <td class="bold"><cf_get_lang no='53.Alt Durum'></td>
                <td>
                    <cfif len(get_service_detail.service_substatus_id)>
                        <cfset attributes.service_substatus_id = get_service_detail.service_substatus_id>
                        <cfinclude template="../query/get_service_substatus.cfm">
                        <cfoutput query="get_service_substatus">#service_substatus#</cfoutput>
                    </cfif>	
                </td>
            </tr>
            <tr>
                <td class="bold"><cf_get_lang_main no='217.açıklam'></td>
                <td colspan="3"><cfoutput>#get_service_detail.service_detail#</cfoutput></td>
            </tr>
        </cf_flat_list>
    </cf_box>
</div>

 
