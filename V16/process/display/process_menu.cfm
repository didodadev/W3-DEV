<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57445.is akis yonetimi'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='36293.genel surecler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='36187.Süreçler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='36220.Süreç Grupları'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='36238.Şablonlar'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='36166.is akis tasarimcisi'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='36190.Uyarı Ve Onaylar'></cfsavecontent>
<cfset f_n_action_list = "process.list_process*0*0*#m_dil_1#,process.general_processes*0*0*#m_dil_2#,process.list_process*0*0*#m_dil_3#,process.list_process_groups*0*0*#m_dil_4#,process.list_template*0*0*#m_dil_5#,process.form_add_process*0*0*#m_dil_6#,process.list_warnings*0*0*#m_dil_7#">
<cfset menu_module_layer = "process">
<cfinclude template="../../design/module_menu.cfm">



