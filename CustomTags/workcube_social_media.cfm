<!--- 
	Sosyal medya kategorilerinin görüntülenmesini sağlar.
 --->

<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.action_type_id" default="">

<cfset url_address ="&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#">
<cf_box
	id="wrk_get_social_media"
	unload_body="1"
	closable="0"
	title="#caller.getLang('main',1732)#"
	add_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_social_media&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#')"
	box_page="#request.self#?fuseaction=objects.emptypopup_list_social_media#url_address#">
</cf_box>


