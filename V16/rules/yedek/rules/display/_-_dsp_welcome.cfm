<cf_xml_page_edit fuseact='rule.welcome'>
<cfset attributes.is_home = 1>
<table class="dpm" cellpadding="4" cellspacing="4">	
	<tr>
  		<td valign="top" width="200">
        	<cf_box><cfinclude template="search.cfm"></cf_box>
            <cfsavecontent variable="kategori"><cf_get_lang_main no='725.Kategoriler'>/<cf_get_lang_main no='727.Bölümler'></cfsavecontent>
            <!---<cfinclude template="list_cat_chapter_home.cfm">--->
            <cf_box 
                id="cat_chapter" 
                title="#kategori#" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=rule.list_cat_chapter_home">
            </cf_box>
		</td>
		<td valign="top">
            <cfinclude template="../query/get_homepage_news.cfm">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" id="search_menu_new" style="display:none;">
						<cfsavecontent variable="aratitle"><cf_get_lang no ='14.İçerik Yönetimi Detaylı Arama'></cfsavecontent>
						<cf_box 
                        	title="#aratitle#" 
                            closable="1" 
                            box_page="#request.self#?fuseaction=rule.list_main_news">
                        	<!---<cfinclude template="list_main_news.cfm">--->
                        </cf_box>
					</td>
				</tr>
			</table>
			<cf_box>
            	<table class="ajax_list" cellpadding="4" cellspacing="4">
                    <tbody>
                        <cfoutput query="get_homepage_news">
                            <cfform name="list_main_cont" action="" method="post">
                                <tr>
                                    <td>
                                    <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#" title="#cont_head#"><h1>#cont_head#</h1></a><br />
                                    <cfif is_dsp_summary eq 0>
                                        <p>#cont_summary#</p><br />
                                    </cfif>
                                    <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#" style="float:right; padding:5px;" class="color-header"><img src="images/next20.gif" height="13" /><cf_get_lang_main no='714.Devam'></a>
                                    </td>
                                 </tr>
                            </cfform>
                        </cfoutput>
                    </tbody>
                </table>
            </cf_box>
		</td>
		<td valign="top" width="200">
            <cfsavecontent variable="spottitle"><cf_get_lang no='9.Spotlar'></cfsavecontent>
			<!---<cfinclude template="spots.cfm">--->
            <cf_box 
                id="spot_" 
                title="#spottitle#" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=rule.spots">
            </cf_box>
            <cfsavecontent variable="duyurutitle"><cf_get_lang_main no='706.Duyurular'></cfsavecontent>
            <!---<cfinclude template="notice.cfm">--->
            <cf_box 
                id="notice_" 
                title="#duyurutitle#" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=rule.notice">
            </cf_box>
            <cfsavecontent variable="newtitle"><cf_get_lang no='1.Haberler'></cfsavecontent>
			<!---<cfinclude template="last_news.cfm">--->
            <cf_box 
                id="new_title" 
                title="#newtitle#" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=rule.last_news">
            </cf_box>
		</td>
	</tr>
</table>

