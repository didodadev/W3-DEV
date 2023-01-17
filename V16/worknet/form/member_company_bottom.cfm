<cfsavecontent variable="message"><cf_get_lang_main no='1463.Çalışanlar'></cfsavecontent>
<cf_box
	id="list_company_partner"
	unload_body="1"
	closable="0"
	add_href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_company_partner&compid=#url.cpid#"
	title="#message#"
	box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popupajax_my_company_partners&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active=#is_only_active_partners#">
</cf_box>
<cf_box
	id="list_worknet_relation"
	unload_body="1"
	closable="0"
	add_href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=popup_addWorknetRelation&cpid=#attributes.cpid#&form_submitted=1"
	title="Pazaryeri Üyelik Listesi"
	box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popupajax_company_relation_worknet&cpid=#attributes.cpid#">
</cf_box>
<cf_box
	id="product_relation_supplier"
	unload_body="1"
	closable="0"
	add_href=""<!--- #request.self#?fuseaction=objects.popup_list_pars_multiuser&field_comp_id=form1.aaa&select_list=2 --->
	title="Ürünler"
	box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popupajax_product_relation_supplier&cpid=#attributes.cpid#">
</cf_box>
<cfsavecontent variable="message"><cf_get_lang no='54.Adresler/Şubeler'></cfsavecontent>
<cf_box
	id="detail_company_address_branch"
	unload_body="1"
	closable="0"
	add_href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_branch&cpid=#url.cpid#"
	title="#message#"
	box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popupajax_list_company_branchs&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#">
</cf_box>