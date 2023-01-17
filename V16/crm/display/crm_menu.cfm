<cfsavecontent variable="m_dil_1"><cf_get_lang no='186.Müşteri Bilgi Yönetimi'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='1261.Müşteriler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang no='183.Müşteri Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='1731.Tedarikçiler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no='534.Tedarikçi Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang no='181.Müşterilerim'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang no='182.Detaylı Müşteri Arama'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang_main no='117.Tanımlar'></cfsavecontent>
<cfset f_n_action_list = "crm.welcome*0*0*#m_dil_1#,crm.form_search_company*0*0*#m_dil_2#,crm.form_add_company*0*0*#m_dil_3#,crm.list_supplier*0*0*#m_dil_4#,crm.form_add_supplier*0*0*#m_dil_5#,crm.my_buyers*0*0*#m_dil_6#,crm.detail_search*0*0*#m_dil_7#,crm.list_definition*0*0*#m_dil_8#">
<cfset menu_module_layer = "crm">
<cfinclude template="../../design/module_menu.cfm">



