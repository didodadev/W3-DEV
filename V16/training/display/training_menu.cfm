<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='7.egitim'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='3.Ajanda'></cfsavecontent>
<!---<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='68.Konu'></cfsavecontent>---> <!---katalog olarak değiştirildi--->
<cfsavecontent variable="m_dil_3">Katalog</cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='639.testler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang_main no='7.Eğitim'></cfsavecontent>
<!---<cfsavecontent variable="m_dil_6"><cf_get_lang no ='112.Yıllık Talepler'></cfsavecontent>---> <!---kaldirildi--->
<cfsavecontent variable="m_dil_7"><cf_get_lang no ='93.Eğitim Talepleri'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang no ='114.Eğitim Duyuruları'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang_main no='723.sonuclar'></cfsavecontent>
<!---<cfsavecontent variable="m_dil_10"><cf_get_lang no ='93.Talep Edilen Eğitimler'></cfsavecontent>---> <!---kaldirildi--->
<cfsavecontent variable="m_dil_11"><cf_get_lang no ='79.Eğitim Önerileri'></cfsavecontent>
<!---<cfset f_n_action_list = "training.list_class_agenda*0*0*#m_dil_1#,training.list_class_agenda*0*0*#m_dil_2#,training.list_training_subjects*0*0*#m_dil_3#,training.list_quizs*0*0*#m_dil_4#,training.list_class*0*0*#m_dil_5#,training.list_class_request*0*0*#m_dil_6#,training.list_one_class_request*0*0*#m_dil_7#,training.list_class_announce*0*0*#m_dil_8#,training.list_results*0*0*#m_dil_9#,training.list_class_valid*0*0*#m_dil_10#,training.list_training_recommendations*0*0*#m_dil_11#">--->
<cfset f_n_action_list = "training.list_class_agenda*0*0*#m_dil_1#,training.list_class_agenda*0*0*#m_dil_2#,training.list_training_subjects*0*0*#m_dil_3#,training.list_quizs*0*0*#m_dil_4#,training.list_class*0*0*#m_dil_5#,training.list_one_class_request*0*0*#m_dil_7#,training.list_class_announce*0*0*#m_dil_8#,training.list_results*0*0*#m_dil_9#,training.list_training_recommendations*0*0*#m_dil_11#">
<cfset menu_module_layer = "training">
<cfinclude template="../../design/module_menu.cfm">
