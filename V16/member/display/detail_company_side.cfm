<cfif (get_company.ispotantial eq 0) and get_module_user(16) and isdefined('xml_finance_summary') and xml_finance_summary eq 1>
	<cfif isdefined("attributes.cid")>
		<cf_get_workcube_finance_summary action_id_2="#attributes.cid#" style="1">
	<cfelseif isdefined("attributes.cpid")>
		<cf_get_workcube_finance_summary action_id="#attributes.cpid#" style="1">
	</cfif>
</cfif>

<cfif isdefined('xml_company_member_team') and xml_company_member_team eq 1><!---Kurumsal Uye Ekibi --->
	<cfif isdefined("attributes.cid")>
		<cf_get_workcube_company_member_team action_id_2="#attributes.cid#" style="1">
	<cfelseif isdefined("attributes.cpid")>
		<cf_get_workcube_company_member_team action_id="#attributes.cpid#" style="1">
	</cfif>
</cfif>

<cfif isdefined('xml_branch_related') and xml_branch_related eq 1><!--- Sube Iliskisi --->
	<cfif isdefined("attributes.cid")>
		<cf_get_workcube_member_branch action_id_2="#attributes.cid#" style="1">
	<cfelseif isdefined("attributes.cpid")>
		<cf_get_workcube_member_branch action_id="#attributes.cpid#" style="1">
	</cfif>
</cfif>

<cfif  GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1>
	<cfsavecontent variable="text"><cf_get_lang no='2.Markalarım'></cfsavecontent>
	<cf_box id="brands" title="#text#" widget_load="watalogBrands&cpid=#attributes.cpid#" add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.form_brands&cpid=#attributes.cpid#','body_brands',0,'Loading..')"></cf_box>
</cfif>
<cfif isdefined('xml_note') and xml_note eq 1><!--- Notlar --->
	<cf_get_workcube_note action_section='COMPANY_ID' action_id='#attributes.cpid#' style="1">
</cfif>

<cfif isdefined('xml_document') and xml_document eq 1><!--- Belgeler --->
	<cf_get_workcube_asset asset_cat_id="-9" module_id='4' action_section='COMPANY_ID' action_id='#attributes.cpid#'>
</cfif>

<cfif isdefined('xml_content') and xml_content eq 1><!--- Iliskili Icerikler --->
	<cf_get_workcube_content action_type ='COMPANY_ID' action_type_id ='#attributes.cpid#' style='0' design='0'>
</cfif>
<!--- ERP > satınalma,satış --->
<cfif (get_module_user(11) or get_module_user(12)) and isdefined('xml_bank_and_creditcard') and xml_bank_and_creditcard eq 1> 
	<!--- Banka Hesaplari --->
	<cf_get_workcube_bank_account action_type='COMPANY' action_id="#attributes.cpid#">
	<!--- Kredi Kartlari --->
	<cf_get_workcube_list_credit_cards action_id ='#attributes.cpid#' style='0' design='0'>
</cfif>

<!--- SOSYAL MEDYA --->
<cf_workcube_social_media action_type='COMPANY_ID' action_type_id ='#attributes.cpid#'>

<!--- BARKOD --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30139.Kurumsal Üye Bilgileri'></cfsavecontent>
<cf_box
    id="workcube_barcode_info"
    closable="0"
    title="#message#"
    body_style="text-align:center;"
    box_page="#request.self#?fuseaction=objects.emptypopup_show_barcode_ajax&company_id=#attributes.cpid#">
</cf_box>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='30311.Coğrafi Koordinatlar'></cfsavecontent>
<cfif len(get_company.coordinate_1) and len(get_company.coordinate_2)>
    <cf_box
        id="workcube_barcode_geo"
        closable="0"
        title="#message#"
        body_style="text-align:center;"
        box_page="#request.self#?fuseaction=objects.emptypopup_show_barcode_geo&company_id=#attributes.cpid#">
    </cf_box>
</cfif>
<cfparam name="attributes.action_type" default="COMPANY_ID">
<cfparam name="attributes.action_id" default="#attributes.cPid#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='62535.Sadakat Kart-Cüzdan'></cfsavecontent>
<cf_box 
	id="box_card_no" 
    title="#title#" 
    closable="0" 
    add_href="openBoxDraggable('#request.self#?fuseaction=#iif(fusebox.circuit is 'crm',DE('member'),'fusebox.circuit')#.popup_detail_customer_cards&action_id=#attributes.action_id#&action_type_id=#attributes.action_type#')"
    box_page="#request.self#?fuseaction=#iif(fusebox.circuit is 'crm',DE('member'),'fusebox.circuit')#.card_no_ajax&pid=#attributes.cpid#">
</cf_box>
