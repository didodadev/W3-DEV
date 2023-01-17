<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57679.POS'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='36020.Stok Export'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='36008.Satış İmport'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='36033.Fiyat Değişim Export'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='36031.ACNielsen'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='36108.Promosyon Belgesi'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='36109.Devir Sayım'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang dictionary_id='58156.Diğer'></cfsavecontent>
<cfset f_n_action_list = "pos.welcome*0*0*#m_dil_1#,pos.list_stock_export*0*0*#m_dil_2#,pos.list_sales_import*0*0*#m_dil_3#,pos.list_price_change_genius*0*0*#m_dil_4#,pos.list_acnielsen*0*0*#m_dil_5#,pos.list_genius_promosyon*0*0*#m_dil_6#,pos.list_sayim*0*0*#m_dil_7#<!---,pos.list_acnielsen*0*0*#m_dil_8#--->">
<cfset menu_module_layer = "pos">
<cfinclude template="../../design/module_menu.cfm">



