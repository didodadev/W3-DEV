<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57449.satinalma'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='38489.teklifler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='38491.siparisler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='58057.Toplu'><cf_get_lang dictionary_id='38492.Sipariş Ver'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='57564.urunler'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='58166.Stoklar'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='38494.ic talepler'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang dictionary_id='38721.satınalma talepleri'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang dictionary_id='38529.Uyelerim'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang dictionary_id='38495.satinalma kosullari'></cfsavecontent>

<cfif get_module_user(5)>
	<cfset add_adm_ = "product.conditions*0*0*#m_dil_9#">
<cfelse>
	<cfset add_adm_ = "">
</cfif>

<cfset f_n_action_list = "purchase.list_order*0*0*#m_dil_1#,purchase.list_internaldemand*0*0*#m_dil_7#,purchase.list_purchasedemand*0*0*#m_dil_10#,purchase.list_offer*0*0*#m_dil_2#,purchase.list_order*0*0*#m_dil_3#,purchase.add_order_product_all_criteria*0*0*#m_dil_4#,purchase.list_product*0*0*#m_dil_5#,purchase.list_stocks*0*0*#m_dil_6#,myhome.my_companies*0*0*#m_dil_8#,#add_adm_#">
<cfset menu_module_layer = "purchase">
<cfinclude template="../../design/module_menu.cfm">


