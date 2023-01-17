<!--- Meta Tanimlari --->

<cfset url_str = ''>
<cfif len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
<cfif len(attributes.faction_type)><cfset url_str =url_str&'&faction_type=#attributes.faction_type#'></cfif>
<cf_box id="get_meta_desc_" 
	closable="0" 
    collapsed="1" 
    title="#caller.getLang('main','Meta Tanımları',58976)#" 
    add_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_meta_desc&action_id=#attributes.action_id#&action_type=#attributes.action_type#&faction_type=#attributes.faction_type#','','ui-draggable-box-small')"
    box_page="#request.self#?fuseaction=objects.ajax_meta_descriptions&#url_str#"></cf_box>
