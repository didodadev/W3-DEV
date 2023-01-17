<cfparam name="attributes.style" default="1">
<cfset dsn = caller.dsn>
<cfset index_folder=caller.index_folder>
<cfset dir_seperator=caller.dir_seperator>
<!--- Kredi Kartlari --->
<cfif isdefined('attributes.action_id')>
	<cf_xml_page_edit fuseact="member.detail_company" is_multi_page="1">
    <cf_box
		id="list_credit_cart"
		unload_body="1"
		closable="0"
		title="#caller.getLang('member',64)#"
        add_href="openBoxDraggable('#request.self#?fuseaction=#iif(caller.fusebox.circuit is 'crm',DE('member'),'caller.fusebox.circuit')#.popup_add_credit_card&comp_id=#attributes.action_id#&xml_same_credit_card_control=#xml_same_credit_card_control#&xml_deactivate_other_credit_cards=#xml_deactivate_other_credit_cards#')"
        box_page="#request.self#?fuseaction=#iif(caller.fusebox.circuit is 'crm',DE('member'),'caller.fusebox.circuit')#.emptypopupajax_company_credit_cards&cpid=#attributes.action_id#&xml_passive_cc=#xml_passive_credit_cards#&xml_cc_relation_control=#xml_credit_card_relation_control#&xml_same_credit_card_control=#xml_same_credit_card_control#&xml_deactivate_other_credit_cards=#xml_deactivate_other_credit_cards#">
    </cf_box>
<cfelseif isdefined('attributes.action_id_2')>
	<cf_xml_page_edit fuseact="member.form_add_consumer">
    <cf_box
		id="list_credit_cart"
		unload_body="1"
		closable="0"
		title="#caller.getLang('member',64)#"
        add_href="openBoxDraggable('#request.self#?fuseaction=#iif(caller.fusebox.circuit is 'crm',DE('member'),'caller.fusebox.circuit')#.popup_add_credit_card&cons_id=#attributes.action_id_2#&xml_same_credit_card_control=#xml_same_credit_card_control#&xml_deactivate_other_credit_cards=#xml_deactivate_other_credit_cards#')"
        box_page="#request.self#?fuseaction=#iif(caller.fusebox.circuit is 'crm',DE('member'),'caller.fusebox.circuit')#.emptypopupajax_consumer_credit_cards&cons_id=#attributes.action_id_2#&xml_passive_cc=#xml_passive_credit_cards#&xml_cc_relation_control=#xml_credit_card_relation_control#&xml_same_credit_card_control=#xml_same_credit_card_control#&xml_deactivate_other_credit_cards=#xml_deactivate_other_credit_cards#">
    </cf_box>
</cfif>
