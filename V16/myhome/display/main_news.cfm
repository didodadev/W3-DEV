<cfinclude template="../query/get_homepage_news.cfm">
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-list">
		<td height="22" class="txtboldblue">
			<a href="javascript://" onclick="gizle_goster_img('main_news_img1','main_news_img2','main_news_menu');"><img src="/images/listele_down.gif" title="<cf_get_lang dictionary_id='30873.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="main_news_img1" style="display:;cursor:pointer;"></a>
			<a href="javascript://" onclick="gizle_goster_img('main_news_img1','main_news_img2','main_news_menu');"><img src="/images/listele.gif" title="<cf_get_lang dictionary_id='31094.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="main_news_img2" style="display:none;cursor:pointer;"></a>
			<cf_get_lang dictionary_id='30779.WorkCube Taze İçerik'>
		</td>
	</tr>
	<tr class="color-row" id="main_news_menu">
		<td>
			<cfif get_homepage_news.recordcount>
			<table width="99%" border="0" align="center">
				<cfoutput query="get_homepage_news">
					<tr>
						<td width="5"><img src="/images/listele.gif" align="absmiddle"></td>
						<td><a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#CONTENT_ID#" class="formbold">#cont_head#</a></td>
					</tr>
					<tr>
						<td></td>
						<td> &nbsp;#cont_summary# </td>
					</tr>
				</cfoutput>
			</table>
		</td>
		<cfelse>
		<td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		</cfif>
	</tr>
</table>
<br/>
