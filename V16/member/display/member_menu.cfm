<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57760.uye yonetimi'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='29408.kurumsal uyeler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='29409.kurumsal uye ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='29406.bireysel uyeler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='29407.bireysel uye ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='29913.Uye Analiz Formlari'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='58009.pdks'></cfsavecontent>
<cfset f_n_action_list = "member.welcome*0*0*#m_dil_1#,member.form_list_company*0*0*#m_dil_2#,member.form_add_company*0*0*#m_dil_3#,member.consumer_list*0*0*#m_dil_4#,member.form_add_consumer*0*0*#m_dil_5#,member.list_analysis*0*0*#m_dil_6#,member.list_emp_pdks*0*0*#m_dil_7#">
<cfset menu_module_layer = "member">
<cfinclude template="../../design/module_menu.cfm">


