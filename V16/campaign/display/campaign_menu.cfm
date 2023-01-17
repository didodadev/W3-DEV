<cfsavecontent variable="m_dil_1"><cf_get_lang no='1.kampanyalar'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang no='1.kampanyalar'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='493.hedef kitleler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='535.anketler'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang no='10.sablonlar'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang_main no ='552.Hedefler'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang no ='258.Mail Listesi'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang no='166.Gönderiler'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang no='393.Etkinlikler'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang no='391.Etkinlik Takvimi'></cfsavecontent>

<cfif get_module_user(47)>
	<cfset add_adm_ = "objects.popup_list_templates&module=15&assetcat_id=-15*1*page*#m_dil_7#">
<cfelse>
	<cfset add_adm_ = "">
</cfif>
<cfif fusebox.use_period>
	<cfset f_n_action_list = "campaign.list_campaign*0*0*#m_dil_1#,campaign.list_campaign*0*0*#m_dil_2#,campaign.list_target_markets*0*0*#m_dil_3#,campaign.list_survey*0*0*#m_dil_4#,#add_adm_#,campaign.targets*0*0*#m_dil_8#,campaign.list_maillist*0*0*#m_dil_9#,campaign.list_forwarded_campaign_content*0*0*#m_dil_10#,campaign.list_organization*0*0*#m_dil_11#,campaign.list_organization_agenda*0*0*#m_dil_12#">
<cfelse>
	<cfset f_n_action_list = "campaign.list_survey*0*0*#m_dil_4#,#add_adm_#,campaign.list_maillist*0*0*#m_dil_9#,campaign.list_organization*0*0*#m_dil_11#,campaign.list_organization_agenda*0*0*#m_dil_12#">
</cfif>
<cfset menu_module_layer = "campaign">
<cfinclude template="../../design/module_menu.cfm">
