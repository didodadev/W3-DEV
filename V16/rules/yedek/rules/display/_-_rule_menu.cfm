<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='6.Literatür'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang no='2.Konular'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='560.organizayon'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='2021.is gruplari'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no='8.kimkimdir'></cfsavecontent>

<cfset f_n_action_list = "rule.welcome*0*0*#m_dil_1#,rule.list_rule*0*0*#m_dil_2#,rule.organization*0*0*#m_dil_3#,rule.workgroup*0*0*#m_dil_4#,rule.list_hr*0*0*#m_dil_5#">
<cfset menu_module_layer = "rule">
<cfinclude template="../../design/module_menu.cfm">



