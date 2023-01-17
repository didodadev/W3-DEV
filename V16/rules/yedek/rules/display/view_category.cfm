<cfinclude template="../query/get_cat_name.cfm">
<table class="dpm" cellpadding="4" cellspacing="4">	
	<tr>
  		<td valign="top" width="200">
			<cf_box><cfinclude template="search.cfm"></cf_box>
			<cfsavecontent variable="kategori"><cf_get_lang_main no='725.Kategoriler'>/<cf_get_lang_main no='727.Bölümler'></cfsavecontent>
			<cf_box title="#kategori#" closable="1"><cfinclude template="list_cat_chapter_home.cfm"></cf_box>
		</td>
		<td valign="top">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top" id="search_menu_new" style="display:none;">
                        <cfsavecontent variable="aratitle"><cf_get_lang no ='14.İçerik Yönetimi Detaylı Arama'></cfsavecontent>
                        <cf_box title="#aratitle#" closable="1"><cfinclude template="list_main_news.cfm"></cf_box>
                    </td>
                </tr>
            </table>
            <cf_box><cfinclude template="category_news.cfm"></cf_box>
		</td>
		<td width="200" valign="top">
			<cfsavecontent variable="spottitle"><cf_get_lang no='9.Spots'></cfsavecontent>
			<cf_box title="#spottitle#" closable="1"><cfinclude template="spots.cfm"></cf_box>
			<cfsavecontent variable="duyurutitle"><cf_get_lang_main no='706.Duyurular'></cfsavecontent>
			<cf_box title="#duyurutitle#" closable="1"><cfinclude template="last_cat_news.cfm"></cf_box>
		</td>
	</tr>
</table>

