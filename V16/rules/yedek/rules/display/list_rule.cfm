<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfif len(attributes.search_date1)><cf_date tarih='attributes.search_date1'></cfif>
<cfif len(attributes.search_date2)><cf_date tarih='attributes.search_date2'></cfif>

<cfinclude template="../query/get_content.cfm">
<cfif isdefined("url.chpid") or isdefined("id")>
  <cfinclude template="../query/get_chapter_name.cfm">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_content.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset attributes.is_home = 1>
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
					<td id="search_menu_new" style="display:none;">
						<cfinclude template="list_main_news.cfm">	
					</td>
				</tr>
            </table>
            <cf_box>
                <table class="ajax_list" cellpadding="4" cellspacing="4">
                    <tbody>
                    <cfif get_content.recordcount>
                        <cfoutput query="get_content">
                            <tr>
                                <td>
                                    <a  href="#request.self#?fuseaction=rule.dsp_rule&cntid=#CONTENT_ID#" title="#cont_head#"><h1>#cont_head#</h1></a><br />
                                    <p>#cont_summary#</p><br />
                                    <a  href="#request.self#?fuseaction=rule.dsp_rule&cntid=#CONTENT_ID#" style="float:right; padding:5px;" class="color-header"><img src="images/next20.gif" height="13" /><cf_get_lang_main no='714.Devam'></a>
                                </td>
                            </tr>
                      </cfoutput>
                    <cfelse>
                        <tr>
                            <td height="25" bgcolor="#FFFFCC" class="headbold"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                        </tr>
                     </cfif>
                </table>
			</cf_box>
		</td>
		<td valign="top" width="200">
            <cfsavecontent variable="spottitle"><cf_get_lang no='9.Spotlar'></cfsavecontent>
			<cf_box title="#spottitle#" closable="1"><cfinclude template="spots.cfm"></cf_box>
            <cfsavecontent variable="duyurutitle"><cf_get_lang_main no='706.Duyurular'></cfsavecontent>
			<cf_box title="#duyurutitle#" closable="1"><cfinclude template="notice.cfm"></cf_box>
            <cfsavecontent variable="newtitle"><cf_get_lang no='1.Haberler'></cfsavecontent>
			<cf_box title="#newtitle#"><cfinclude template="last_news.cfm"></cf_box>
		</td>
	</tr>		
</table>
