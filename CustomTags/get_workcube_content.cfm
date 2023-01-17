<!--- Örnek kullanım
<cf_get_workcube_content action_type ='PROJECT_ID' action_type_id ='#attributes.id#' design='1'>
parametreler 
action_type : İçerik ile ilişkili alan adı *gerekli*
action_type_id : ilişkili içerik id'si *gerekli*
design : 1 listeleme 0 başlık  *gerekli*
is_add_upd : istenilen alanın göstermek (1) veya  göstermemek (0) için kullanılıyor ör: <cfif attributes.is_add_upd eq 0>istenmeyen alan</cfif> 
 --->
<cfparam name="attributes.action_type_id" default=""> 
<cfparam name="attributes.width" default="">
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.company_id" default="#session.ep.company_id#">
<cfparam name="attributes.style" default="1">
<cfparam name="attributes.design" default="1">
<cfparam name="attributes.is_add_upd" default="1">
<cfparam name="attributes.margin_right" default="0">
<cfparam name="attributes.draggable" default="">
<cfparam name="attributes.come_project" default="0"><!----proje detayından geliyorsa---->
<cfparam name="keyword" default="">
<cfset dsn = caller.dsn>

<cfset url_address ="&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#&company_id=#attributes.company_id#&design=#attributes.design#&style=#attributes.style#&is_add_upd=#attributes.is_add_upd#&come_project=#attributes.come_project#">
<cfset wiki = "">
<cfif attributes.action_type neq 'train_id'>
	<cfset wiki = "#request.self#?fuseaction=help.wiki&form_submitted=1&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#&keyword=#iif( isdefined('attributes.keyword') and len(attributes.keyword),DE('##attributes.keyword##'),DE(''))#">
</cfif>
<!--- Icerikler --->
<cfset info_href_ = "javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_content_relation&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#');">
<cf_box
	id="wrk_get_content"
	info_title="#caller.getLang('main',"İlişkilendir", 57909)#"
	title="#caller.getLang('main',"İçerikler",58045)#" 
	add_href="#request.self#?fuseaction=content.list_content&event=add&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#" 
    info_href="#info_href_#"
	info_href_size="list"
	wiki="#wiki#"
    closable="0"
	box_page="#request.self#?fuseaction=objects.emptypopup_list_content_relation#url_address#"
	>
</cf_box>
