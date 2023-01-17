<cfif len(attributes.company_id)>
	<cfscript>
		contact_type = "comp";
		contact_id = attributes.company_id;
	</cfscript>
<cfelseif len(attributes.partner_id)>
	<cfscript>
		contact_type = "p";
		contact_id = attributes.partner_id;
		par_id = attributes.partner_id;
	</cfscript>	
<cfelseif len(attributes.consumer_id)>
	<cfscript>
		contact_type = "c";
		contact_id = attributes.consumer_id;
		con_id = attributes.consumer_id;
	</cfscript>
<cfelseif len(attributes.employee_id)>
	<cfset emp_id=attributes.employee_id>
	<cfscript>
		contact_type = "e";
		contact_id = emp_id;
		attributes.emp_id = emp_id;
	</cfscript>
<cfelse>
	<cfscript>
		contact_type = '';
		contact_id = '';
	</cfscript>
</cfif>
<cfif len(contact_type)>
    <cf_box 
        closable="0" 
        box_page="#request.self#?fuseaction=objects.contact_simple&contact_type=#contact_type#&contact_id=#contact_id#"
        unload_body="1"
        id="contract_" 
        title="#getLang('','Üye Bilgileri',57575)#">
    </cf_box>
</cfif>

<!-- Finansal Özet -->
<cfif get_module_user(16)>
    <cfif isdefined('x_comp_id') and len(x_comp_id)>
        <cfset comp_id =x_comp_id>
    <cfelse>
        <cfset comp_id=session.ep.company_id>
    </cfif>
	<cf_get_workcube_finance_summary action_id="#comp_id#" style="1">
</cfif>
<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
    <cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
	<cfset GET_ACTION_WORKGROUP = getComponent.GET_ACTION_WORKGROUP(action_field : "subscription", action_id : attributes.subscription_id)>
    <div style="display:none;z-index:999;" id="subs_team"></div>
    <cf_box 
        id="workgroup" 
        title="#getLang('campaign',44)#" 
        widget_load="subscriberTeam&action_id=#attributes.subscription_id#&action_field=subscription" 
        lock_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_denied_pages_lock&pages_id=#GET_ACTION_WORKGROUP.WORKGROUP_ID#&act=#attributes.fuseaction#')"
    	lock_href_title="#getLang('','Sayfa Kilidi',58041)#"  
        add_href="javascript:openBoxDraggable('#request.self#?fuseaction=project.popup_add_workgroup&action_id=#attributes.subscription_id#&action_field=subscription')">
    </cf_box>
</cfif>

<cfif isdefined('x_subs_comp_id') and len(x_subs_comp_id)>
    <cfset x_subs_comp_id =x_subs_comp_id>
<cfelse>
    <cfset x_subs_comp_id="">
</cfif>

<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
    <cf_box
        id="box_systems"
        closable="0"
        box_page="#request.self#?fuseaction=myhome.popupajax_my_company_systems&cpid=#attributes.company_id#&maxrows=#attributes.maxrows#&service_id=#attributes.service_id#&x_subs_comp_id=#x_subs_comp_id#"
        title="#getLang('','Abone',58832)#">
    </cf_box>
</cfif>

<!--- Garanti Bilgileri --->
<cfif len(stock_id) and len(pro_serial_no) and get_pro_guaranty.recordcount>
    <cfinclude template="upd_quaranty_service.cfm">
</cfif> 				

<!--- Kalite Kontrol --->
<cfif session.ep.our_company_info.guaranty_followup eq 1>
	<cfsavecontent variable="text"><cf_get_lang dictionary_id='41715.Kalite Kontrol'></cfsavecontent>
    <cfif len(get_service_detail.stock_id)>
		<cfif xml_detail_test_result eq 0>
            <cf_box 
                id="unique_form_test_id"
                 closable="0" 
                 title="#text#" 
                 add_href_size="small" 
                 unload_body="1"
                 add_href="openBoxDraggable('#request.self#?fuseaction=service.popup_add_service_test&service_id=#attributes.service_id#')"
                 box_page="#request.self#?fuseaction=service.list_service_tests&service_id=#attributes.service_id#&type=1">
            </cf_box>
        <cfelse>
            <cf_box 
            	collapsed="0" 
                title="#text#" 
                unload_body="1"
                add_href="#request.self#?fuseaction=prod.popup_add_quality_control_report&process_id=#attributes.service_id#&process_row_id=#attributes.service_id#&process_cat=-2&is_detail=1&pid=#get_service_detail.service_product_id#&stock_id=#get_service_detail.stock_id#"
                box_page="#request.self#?fuseaction=service.list_service_tests&service_id=#attributes.service_id#&type=2">
            </cf_box>
        </cfif>
    <cfelse>
        <cf_box 
        	closable="0" 
            unload_body="1" 
            collapsed="1" 
            title="#text#"
            box_page="#request.self#?fuseaction=service.list_service_tests&service_id=#attributes.service_id#&type=3">
        </cf_box>    
    </cfif>
</cfif>

<cfif not listfindnocase(denied_pages,'service.popup_add_sms_reply') and (session.ep.our_company_info.sms eq 1)> 
    <cf_box 
        closable="0" 
        box_page="#request.self#?fuseaction=service.popup_add_reply&service_id=#service_id#"
        unload_body="1"
        id="reply_" 
        title="#getLang('','SMS Cevaplar',41702)#">
    </cf_box>
</cfif>

<!---İc Talepler--->
<cf_box 
    closable="0" 
    box_page="#request.self#?fuseaction=service.list_internaldemands&service_id=#service_id#"
    unload_body="1"
    id="inter_" 
    title="#getLang('','İç Talepler',41983)#">
</cf_box>

<!--- Varlıklar --->
<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-5" module_id='14' action_section='SERVICE_ID' action_id='#attributes.service_id#'>
<!--- notlar --->
<cf_get_workcube_note company_id="#session.ep.company_id#" module_id='14' action_section='SERVICE_ID' action_id='#attributes.service_id#'>
<!--- Iliskili Olaylar --->
<cf_get_related_events action_section='SERVICE_ID' action_id='#attributes.service_id#' member_id='#contact_id#' member_type='#contact_type#'>
<!--- is Grupları--->
<cfif x_is_show_service_workgroups eq 1 and len(get_service_Detail.workgroup_id)>
	<cf_box closable="0" box_page="#request.self#?fuseaction=service.list_workgroups_emps_ajax&service_id=#attributes.service_id#" collapsed="0" id="wrk_group" title="İş Grubu Çalışanları" add_href="#request.self#?fuseaction=service.popup_add_workgroup_employees&service_id=#service_id#"></cf_box>
</cfif>

