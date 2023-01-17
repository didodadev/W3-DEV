<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='39.Satış Planlama'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='355.Satış Bölgeleri'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='391.Satış Takımlari'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='749.Satış Planlari'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang_main no='777.Satis Kotalari'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang_main no='552.Hedefler'></cfsavecontent>
<cfset f_n_action_list = "salesplan.list_plan*0*0*#m_dil_1#,salesplan.list_plan*0*0*#m_dil_2#,salesplan.list_sales_team*0*0*#m_dil_3#,salesplan.list_sales_plan_quotas*0*0*#m_dil_4#,salesplan.list_sales_quotas*0*0*#m_dil_5#,salesplan.targets*0*0*#m_dil_6#">
<cfset menu_module_layer = "salesplan">
<cfinclude template="../../design/module_menu.cfm">


