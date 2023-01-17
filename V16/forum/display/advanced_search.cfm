<cfinclude template="../query/get_forums.cfm">
<cf_form_box title="#getLang('forum',7)#">
<cfform method="post" action="#request.self#?fuseaction=forum.search">
	<table>
		<tr>
			<td width="150"><cf_get_lang no='8.Aranacak Kelime'></td>
			<td colspan="2">
				<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang no='8.Aranacak Kelime'></cfsavecontent>
				<cfinput type="text" name="keyword" style="width:300px;" required="yes" message="#message#">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='9.Hangi Forumda'></td>
			<td colspan="2">
            	<select name="forumid" id="forumid" style="width:300px;">
					<option value="0" selected><cf_get_lang_main no='669.Hepsi'> 
					<cfoutput query="forums">
						<option value="#forumid#">#forumname# 
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='10.Sadece Konu Başlıklarında'></td>
			<td><input type="checkbox" name="topichead" id="topichead" value="1">
		</tr>
	</table>
	<cf_form_box_footer>
	<table style="text-align:right;">
		<tr>
			</td>
			<td  style="text-align:right;"><input type="submit" value="<cf_get_lang_main no='153.Ara'>">
			&nbsp;<input type="reset" value="<cf_get_lang_main no='522.Temizle'>"></td>
		</tr>
	</table>
	</cf_form_box_footer>
</cfform>
</cf_form_box>
