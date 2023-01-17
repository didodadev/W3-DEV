<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='23.Ayarlar'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='281.Parametreler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='737.Sistem Yönetimi'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='739.Güvenlik'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang_main no='724.Site Tasarimi'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang no='1478.Dönem Başı Geçiş İşlemleri'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang_main no='1876. Aktarimlar'></cfsavecontent>
<cfsavecontent variable="menu_settings_site_div">
<div id="menu_settings_site" class="menus2_show" style="position:absolute; margin-left:-5px; width:150px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_settings_site','','show');" onmouseout="workcube_showHideLayers('menu_settings_site','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" width="100%" onmouseover="workcube_showHideLayers('menu_settings_site','','show');">
    <tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=settings.list_main_menu';">
        <td>&nbsp;<cf_get_lang_main no='1874.Siteler'></td>
    </tr>	
    <tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=settings.list_site_layouts';">
        <td>&nbsp;<cf_get_lang no ='1456.Sayfalar'></td>
    </tr>	
    <tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=settings.form_add_object_design';">
        <td>&nbsp;<cf_get_lang no ='2451.Tasarımlar'></td>
    </tr>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfset f_n_action_list = "settings.welcome*0*0*#m_dil_1#,settings.welcome*0*0*#m_dil_2#,settings.management*0*0*#m_dil_3#,settings.security*0*0*#m_dil_4#,settings.list_main_menu*2*menu_settings_site*#m_dil_5#,settings.system_transfers*0*0*#m_dil_7#,settings.db_admin*0*0*#m_dil_6#">
<cfset menu_module_layer = "settings">
<cfinclude template="../../design/module_menu.cfm">
