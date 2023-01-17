<cfset attributes.upd_id = url.ship_id>
<cfinclude template="../query/get_upd_purchase.cfm">
<cfif not get_upd_purchase.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse> 
<cf_catalystHeader>
<cfset attributes.ship_id=url.ship_id>
<div class="row">
    <div class="col col-9 col-xs-12">
        <!--- Karşılama Raporu--->
        <cf_box title="#getlang('main',2782)#"box_page = "#request.self#?fuseaction=objects.popup_associated_tables&ship_id=#attributes.ship_id#&is_purchase=1" closable="0" ></cf_box>
        <!--- Değerlendirme Formları--->    
        <cf_get_workcube_form_generator action_type='17' related_type='17' action_type_id='#attributes.ship_id#' design='1'>
    </div>
    <div class="col col-3 col-xs-12">
        <!--Belgeler-->
        <cf_get_workcube_asset period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_ID' action_id='#url.ship_id#'>
        <!--Notlar-->
        <cf_get_workcube_note period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_ID' action_id='#url.ship_id#'>
    </div>
</div>
</cfif>
