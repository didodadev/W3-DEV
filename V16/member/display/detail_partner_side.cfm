<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cf_box 
	id="box_photo" 
    title="#getLang('','Fotoğraf',30243)#" 
    closable="0" 
    collapsed="#iif(attributes.style,1,0)#"
	box_page="#request.self#?fuseaction=#fusebox.circuit#.form_photo_ajax&pid=#attributes.pid#">
</cf_box>
<cf_get_workcube_note action_section='PARTNER_ID' action_id='#url.pid#'>
<cf_get_workcube_asset asset_cat_id="-9" module_id='4' action_section='PARTNER_ID' action_id='#attributes.pid#'>
<cf_get_member_analysis action_type='MEMBER' company_id='#get_partner.company_id#' partner_id='#attributes.pid#'>
<cf_get_workcube_domain action_type='PARTNER' action_id='#attributes.pid#'>
<!---<cfinclude template="list_customer_cards.cfm">--->
<cfif isDefined("attributes.cid") and Len(attributes.cid)>
	<cfparam name="attributes.action_type" default="CONSUMER_ID">
	<cfparam name="attributes.action_id" default="#attributes.cid#">
<cfelse>
	<cfparam name="attributes.action_type" default="PARTNER_ID">
	<cfparam name="attributes.action_id" default="#attributes.pid#">
</cfif>
<cf_box 
	id="box_card_no" 
    title="#getLang('','Kart No',30233)#" 
    closable="0" 
    add_href="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.popup_detail_customer_cards&action_id=#attributes.action_id#&action_type_id=#attributes.action_type#')"
    box_page="#request.self#?fuseaction=#fusebox.circuit#.card_no_ajax&pid=#attributes.pid#">
</cf_box>
<cf_box
    id="workcube_barcode_info"
    closable="0"
    title="#getLang('','Çalışan Bilgisi',30287)#"
    body_style="text-align:center;"
    box_page="#request.self#?fuseaction=objects.emptypopup_show_barcode_ajax&pid=#attributes.pid#">
</cf_box>
<!--- SOSYAL MEDYA --->
<cf_workcube_social_media action_type='Employee_id' action_type_id ='#attributes.pid#'>