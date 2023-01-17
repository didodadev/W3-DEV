<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
Description :   
    Document Template 
Parameters :
    action_section  .-.- > olay bağlanan hareket adı						      'required
    action_id       .-.- > olay bağlanan hakeket id'si							  'required
	company_id       .-.- > şirket id 'si gerek duyulunca kullanılır 			  'not required
	member_id       .-.- > Uye id 'sine gerek duyulunca kullanılır 			  'not required
	member_type       .-.- > Uye type bilgisine gerek duyulunca kullanılır 			  'not required
	design_id       .-.- > design type for use area  'not required
	action_project_id -.-.-> iliskili proje id				'not required		 
	
Syntax :
	<cf_get_related_events action_section='<coloum name>' action_id='<integer value>'>
Sample :
	<cf_get_related_events action_section='project_id' action_id='#attributes.cntid#'>	
	
	created Yunus Özay 20040716
	modified Emin Yasarturk 20130729 (Ajax yapisina cevrildi)
 --->

<cfparam name="attributes.design_id" default="1">
<cfif attributes.design_id is 0>
	#caller.getLang('main',2236)#	<!---design "0" için işlem yapılmadı--->
<cfelse>
	<cfif isdefined('attributes.member_id') and len(attributes.member_id) and isdefined('attributes.member_type') and len(attributes.member_type)>
        <cfset add_ = '&member_id=#attributes.member_id#&member_type=#attributes.member_type#'>
    <cfelse>
        <cfset add_ = ''>
    </cfif>
    <cfif isdefined("attributes.action_project_id")>
        <cfset info_= '&project_id=#attributes.action_project_id#'>
    <cfelse>
        <cfset info_ = ''>
    </cfif>
	<cfset url_str = ''>
    <cfif isdefined("attributes.action_section") and len(attributes.action_section)><cfset url_str =url_str&'&action_section=#attributes.action_section#'></cfif>
	<cfif isdefined("attributes.action_id") and len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfset url_str =url_str&'&company_id=#attributes.company_id#'></cfif>
	<cfif len(attributes.design_id)><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
    <cf_box 
		id="get_related_events_" 
		closable="0" collapsed="1" 
		add_href_size="project" 
		title="#caller.getLang('','Takvim','32138')#- #caller.getLang('','Ajanda','57415')#" 
		info_href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_events&action_id=#attributes.action_id#&action_section=#attributes.action_section##add_#','','ui-draggable-box-medium')" 
		box_page="#request.self#?fuseaction=objects.ajax_related_events&#url_str#"
		add_href="#request.self#?fuseaction=agenda.view_daily&event=add&action_id=#attributes.action_id#&action_section=#attributes.action_section##add_#&action_project_id=#info_#"
		>
	</cf_box> 
	<!--- Iliskili Olaylar --->
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
