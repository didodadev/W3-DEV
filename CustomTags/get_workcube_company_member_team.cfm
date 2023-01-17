<!--- modified Emin Yasarturk 20130729 (Ajax yapisina cevrildi) --->
<cfset url_str = ''>
<cfif isDefined("attributes.action_id")>
	<cfparam name="title" type="string" default="#caller.getLang('member',61)#"> <!--- Kurumsal Uye Ekibi --->
	<cfparam name="href" type="string" default="openBoxDraggable('#request.self#?fuseaction=member.popup_form_upd_worker&company_id=#attributes.action_id#')">
	<cfif len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfelseif isdefined("attributes.action_id_2")>
	<cfparam name="title" type="string" default="#caller.getLang('member',426)#"> <!--- Bireysel Uye Ekibi --->
    <cfparam name="href" type="string" default="openBoxDraggable('#request.self#?fuseaction=member.popup_form_upd_worker&consumer_id=#attributes.action_id_2#')">
	<cfif len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
</cfif>
<cf_box	id="get_member"	title="#title#"	collapsed="#iif(attributes.style,1,0)#"	closable="0" add_href="#href#" box_page="#request.self#?fuseaction=objects.ajax_company_member_team&#url_str#"></cf_box>
