
<cf_catalystHeader>

<cfset get_product_list_action = createObject("component", "V16.product.cfc.get_product")/>
<cfset get_product_list_action.dsn1 = dsn1>
<cfset get_product_list_action.dsn_alias = dsn_alias>
<cfset 	GET_PRODUCT = get_product_list_action.get_product_(pid : attributes.pid) />

<div class="col col-12"><!--- Kalite Kontrol Tipleri --->
<cf_box id="quality_control_cat_type" title="#getLang('','Ürün Kalite Kontrol Tanımları	','60298')#" closable="0" refresh="1" box_page="#request.self#?fuseaction=product.list_quality_control_types&product_id=#attributes.pid#"></cf_box>
<!--- Kalite Kontrol Parametreleri --->
<cf_box id="quality_control_parameter" title="#getLang('','Parti - Örneklem Miktarları','64047')#" closable="0" refresh="1" box_page="#request.self#?fuseaction=product.popupajax_product_quality_parameters&product_id=#attributes.pid#"></cf_box>
<!--- Uye Muayene Seviyeleri --->
<cfsavecontent variable="mil_message"><cf_get_lang dictionary_id='63478.Müşteri ve Tedarikçiye Özel Kontrol Seviyeleri'></cfsavecontent>
<cf_box id="member_inspection_levels" title="#mil_message#" closable="0" refresh="1" box_page="#request.self#?fuseaction=product.popupajax_product_member_inspection_level&product_id=#attributes.pid#"></cf_box>
</div>
