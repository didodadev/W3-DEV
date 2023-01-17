<cfparam name="attributes.style" default="1">
<cfset url_str = ''>
<cfif isDefined("attributes.action_id")>
	<cfparam name="href" type="string" default="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_branch&cpid=#attributes.action_id#')">
    <cfif len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfelseif isdefined("attributes.action_id_2")>
	<cfparam name="href" type="string" default="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_branch&cid=#attributes.action_id_2#')">
    <cfif len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
</cfif>

<!--- Sube Iliskisi --->
<cf_box
	id="get_branch_1"
	title="#caller.getLang('main',483)#"
	collapsed="#iif(attributes.style,1,0)#"
	closable="0"
	add_href="#href#"
    add_href_size="medium"
    box_page="#request.self#?fuseaction=objects.ajax_member_branch&#url_str#"></cf_box>
