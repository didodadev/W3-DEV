<cfinclude template="form_upd_emp_std.cfm">
<cfset attributes.xml_in_out = xml_in_out>
<cfsavecontent variable="title"><cf_get_lang dictionary_id ='56122.Giriş Çıkışlar'></cfsavecontent>
<cfif attributes.xml_in_out eq 1>
	<cfset add_href = "javascript:openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=addIn&employee_id=#attributes.employee_id#')">
<cfelse>
	<cfset add_href = "">
</cfif>
<cfif not isDefined("attributes.isAjax")><!--- Organizasyon Yönetimi sayfasında gözükmemesi için --->
    <cf_box
        id="emp_in_outs" 
        closable="0" 
        title="#title#" 
        collapsed="0"
        add_href="#add_href#" 
        add_href_size="medium"
        box_page="#request.self#?fuseaction=hr.list_multi_in_out_ajax&employee_id=#attributes.employee_id#">
    </cf_box>
</cfif>
<!---<cfinclude template="list_multi_in_out.cfm">--->
<cfset attributes.employee_id = emp_id>
<cfset attributes.position_code = "">
<cfset add_href = "openBoxDraggable('#request.self#?fuseaction=hr.popup_add_position_change_history&employee_id=#attributes.employee_id#')">
<cfsavecontent variable="title"><cfoutput>#getLang('report',428)#</cfoutput></cfsavecontent>
<cfif not isDefined("attributes.isAjax")><!--- Organizasyon Yönetimi sayfasında gözükmemesi için --->
    <cf_box 
        id="position_history" 
        closable="0" 
        unload_body="1" 
        collapsed="1" 
        title="#title#" 
        add_href="#add_href#"
        add_href_size="medium"
        box_page="#request.self#?fuseaction=hr.list_position_change_history&employee_id=#attributes.employee_id#">
    </cf_box>
</cfif>    
<!---<cfinclude template="list_position_change_history.cfm">--->
<cfif not isDefined("attributes.isAjax")><!--- Organizasyon Yönetimi sayfasında gözükmemesi için --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29818.İş Grupları"></cfsavecontent>
    <cf_box 
        id="position_work" 
        closable="0" 
        unload_body="1" 
        collapsed="1" 
        title="#message#"
        box_page="#request.self#?fuseaction=hr.upd_position_work_groups&employee_id=#attributes.employee_id#">
    </cf_box>
</cfif>    
<!---<cfinclude template="../form/upd_position_work_groups.cfm">--->
