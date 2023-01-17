<cfscript>
	contact_type = "";
	contact_id = "";
	if(len(attributes.company_id))
	{
		contact_type = "comp";
		contact_id = attributes.company_id;
	}
	else if(len(attributes.partner_id))
	{
		contact_type = "p";
		contact_id = attributes.partner_id;
		//par_id = attributes.partner_id;
	}
	else if(len(attributes.consumer_id))
	{
		contact_type = "c";
		contact_id = attributes.consumer_id;
		//con_id = attributes.consumer_id;
	}
	else if(len(attributes.employee_id))
	{
		contact_type = "e";
		contact_id = attributes.employee_id;
		//emp_id = attributes.emp_id;
	}
</cfscript>
<cf_box title="#getLang('','Üye Bilgileri',57575)#">
	<cfinclude template="../../objects/display/contact_simple.cfm">
</cf_box>
<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-5" module_id='27' action_section='G_SERVICE_ID' action_id='#attributes.service_id#'>
<!--- Iliskili Firsatlar --->
<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
	SELECT OPP_NO,OPP_ID FROM OPPORTUNITIES WHERE SERVICE_ID = #attributes.service_id#
</cfquery>
<cf_box id="get_related_services" closable="0" title="#getLang('call',127)#" collapsed="1">
	 <cf_ajax_list>
         <tbody>
            <cfif get_opportunity.recordcount>
                <cfoutput query="get_opportunity">
                <tr>
                    <td><a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#OPP_ID#" class="tableyazi">#OPP_NO#</a></td>
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td><cf_get_lang_main no="72.Kayıt yok">!</td>
                </tr>
            </cfif>
         </tbody>
     </cf_ajax_list>
</cf_box>
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
<cfset x_subs_comp_id="">
<cfif isdefined('x_subs_comp_id') and len(x_subs_comp_id)>
    <cfset x_subs_comp_id =x_subs_comp_id>
</cfif>

<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
    <cf_box
        id="box_systems"
        closable="0"
        box_page="#request.self#?fuseaction=myhome.popupajax_my_company_systems&cpid=#attributes.company_id#&maxrows=#attributes.maxrows#&service_id=#attributes.service_id#&x_subs_comp_id=#x_subs_comp_id#"
        title="#getLang('','Abone',58832)#">
    </cf_box>
</cfif>
<!--- <!---İlişkili İçerikler--->
<cf_get_workcube_content action_type ='SERVICE_ID' action_type_id ='#attributes.service_id#' design='1' company_id='#session.ep.company_id#'> --->

