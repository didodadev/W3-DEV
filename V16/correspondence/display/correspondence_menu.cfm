<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='47.Yazismalar'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='47.Yazismalar'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='1386.Ic Talep'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang no='5.Ödeme Talebi'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no='31.Varlık Talebi'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang no='138.Personel Talebi'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang_main no='1884.CubeMail'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang no="260.Exchange Server Mail"></cfsavecontent>
<cfif get_module_user(39)>
	<cfset add_adm_ = "correspondence.cubemail*3*0*#m_dil_7#">
<cfelse>
	<cfset add_adm_ = "">
</cfif>
<cfset f_n_action_list = "correspondence.welcome*0*0*#m_dil_1#,correspondence.list_correspondence*0*0*#m_dil_2#,correspondence.list_internaldemand*0*0*#m_dil_3#,correspondence.add_payment_actions&act_type=2&correspondence_info=1*0*0*#m_dil_4#,correspondence.add_assetp_demand*0*0*#m_dil_5#,correspondence.from_add_personel_requirement_form*0*0*#m_dil_6#,#add_adm_#,correspondence.exchangemail*0*0*#m_dil_8#">
<cfset menu_module_layer = "correspondence">
<cfinclude template="../../design/module_menu.cfm">


