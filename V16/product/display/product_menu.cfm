<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57657.urun'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='57564.urunler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='58988.aksiyonlar'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='37382.Koşullar'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='37390.fiyat Düzenle'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='37020.fiyat degisimi'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='58258.Maliyet'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang dictionary_id='57583.promosyonlar'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang dictionary_id='37480.vitrin'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang dictionary_id='30104.rekabet'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang dictionary_id='37017.DPL'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang dictionary_id='57529.tanimlar'></cfsavecontent>
<cfif session.ep.our_company_info.workcube_sector is 'tersane'><!--- DPL tanımları için--->
	<cfset f_n_action_list = "product.list_product*0*0*#m_dil_1#,product.list_product*0*0*#m_dil_2#,product.list_catalog_promotion*0*0*#m_dil_3#,product.conditions*0*0*#m_dil_4#,product.collacted_product_prices*0*0*#m_dil_5#,product.list_price_change*0*0*#m_dil_6#,product.list_product_cost*0*0*#m_dil_7#,product.list_promotions*0*0*#m_dil_8#,product.list_product_vision*0*0*#m_dil_9#,product.rivals*0*0*#m_dil_10#,product.list_drawing_parts*0*0*#m_dil_11#,product.list_definition*0*0*#m_dil_12#">
<cfelse>
	<cfset f_n_action_list = "product.list_product*0*0*#m_dil_1#,product.list_product*0*0*#m_dil_2#,product.list_catalog_promotion*0*0*#m_dil_3#,product.conditions*0*0*#m_dil_4#,product.collacted_product_prices*0*0*#m_dil_5#,product.list_price_change*0*0*#m_dil_6#,product.list_product_cost*0*0*#m_dil_7#,product.list_promotions*0*0*#m_dil_8#,product.list_product_vision*0*0*#m_dil_9#,product.rivals*0*0*#m_dil_10#,product.list_definition*0*0*#m_dil_12#">
</cfif>
<cfset menu_module_layer = "product">
<cfinclude template="../../design/module_menu.cfm">



