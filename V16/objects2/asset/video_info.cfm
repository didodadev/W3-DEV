<cfsetting showdebugoutput="no">
<cfinclude template="query/get_video.cfm">
<div id="aaa">
	<table border="0" width="98%">
		<tr>
			<td class="tableyazi">
				<b><cfoutput>#get_video.asset_name#</cfoutput></b><br /><br />
				<cfif len(get_video.asset_description)>
					&nbsp;&nbsp;&nbsp;<cfoutput>#get_video.ASSET_DESCRIPTION#</cfoutput><br /><br />
				</cfif>
				<cf_get_lang_main no='74.Kategori'>: <cfoutput>#get_video.ASSETCAT#</cfoutput><br />
				<cf_get_lang no='172.Ekleme'>: <cfoutput>#dateFormat(get_video.RECORD_DATE,"dd.mm.yyyy")#</cfoutput><br /><br />
				<cfinclude template="video_options.cfm"><br />
			</td>
		</tr>
	</table>
</div>
