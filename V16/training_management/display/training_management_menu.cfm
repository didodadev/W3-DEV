<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='28.Egitim Yonetimi'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='3.Ajanda'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='241.İçerik'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='7.Eğitim'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no='1.Sınıf'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang no='400.Talepler'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang_main no='706.Duyurular'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang no='401.Biten Eğitim'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang no='118.Eğitimciler'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang_main no='846.Maliyet'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang_main no='1398.soru'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang_main no='1414.testler'></cfsavecontent>
<cfsavecontent variable="m_dil_16"><cf_get_lang_main no='1971.Formlar'></cfsavecontent>
<cfsavecontent variable="m_dil_14"><cf_get_lang no='68.eğitim önerileri'></cfsavecontent>
<cfsavecontent variable="m_dil_13"><cf_get_lang_main no='117.Tanımlar'></cfsavecontent>
<!---<cfsavecontent variable="m_dil_15"><cf_get_lang_main no='68.Konu'></cfsavecontent>--->
<cfsavecontent variable="m_dil_15">Katalog</cfsavecontent>
<cfset f_n_action_list = "training_management.list_class_agenda*0*0*#m_dil_1#,training_management.list_class_agenda*0*0*#m_dil_2#,training_management.list_content*0*0*#m_dil_3#,training_management.list_training_subjects*0*0*#m_dil_15#,training_management.list_class*0*0*#m_dil_4#,training_management.list_training_groups*0*0*#m_dil_5#,training_management.list_class_requests*0*0*#m_dil_6#,training_management.list_class_announcements*0*0*#m_dil_7#,training_management.list_class_finished*0*0*#m_dil_8#,training_management.list_trainers*0*0*#m_dil_9#,training_management.list_training_management_cost*0*0*#m_dil_10#,training_management.list_questions*0*0*#m_dil_11#,training_management.list_quizs*0*0*#m_dil_12#,training_management.list_detail_survey_report&action_type=9*0*0*#m_dil_16#,training_management.list_training_recommendations*0*0*#m_dil_14#,training_management.definitions*0*0*#m_dil_13#">
<cfset menu_module_layer = "training_management">
<cfinclude template="../../design/module_menu.cfm">

