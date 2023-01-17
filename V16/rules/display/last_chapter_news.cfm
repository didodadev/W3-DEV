<!--- Haberler --->			
<cfinclude template="../query/get_last_chapter_news.cfm">
<table>
	<cfoutput query="GET_LAST_CHAPTER_NEWS">
	<tr>
		<td><img src="/images/arrow_blue.gif"  align="absmiddle"> <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#GET_LAST_CHAPTER_NEWS.CONTENT_ID#" class="tableyazi">#GET_LAST_CHAPTER_NEWS.cont_head#</a></td>
	</tr>
	</cfoutput>
</table>
<!--- Haberler --->		