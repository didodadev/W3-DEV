<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='9.Forum'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='716.forumlar'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang no='3.forum ac'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='492.detayli arama'></cfsavecontent>
<cfset f_n_action_list = "forum.list_forum*0*0*#m_dil_1#,forum.welcome*0*0*#m_dil_2#,forum.form_add_forum*0*0*#m_dil_3#,forum.advanced_search*0*0*#m_dil_4#">
<cfset menu_module_layer = "forum">
<cfinclude template="../../design/module_menu.cfm">


