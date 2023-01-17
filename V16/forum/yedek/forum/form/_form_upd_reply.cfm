<cfinclude template="../query/get_head_topic.cfm">
<cfif head_topic.locked eq 1>
	<cflocation url="#request.self#?fuseaction=forum.list_forum" addtoken="No">
</cfif>
<cfinclude template="../query/get_reply.cfm">
<cfif len(reply.topicid)>
	<cfset attributes.topicid = reply.topicid>
<cfelse>
	<cfset attributes.topicid = attributes.topicid>
</cfif>
<cfinclude template="../query/get_email_alert.cfm">
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=forum.form_add_reply&topicid=#attributes.topicid#</cfoutput>"><img src="/images/plus1.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>"></cfsavecontent>
<cf_form_box title="#getLang('forum',60)#" right_images="#img#">
 <cfform enctype="multipart/form-data" method="post" name="upd_reply"  action="#request.self#?fuseaction=forum.emptypopup_upd_reply">
	<input type="Hidden" name="replyid" id="replyid" value="<cfoutput>#replyid#</cfoutput>">
	<input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
	<input type="Hidden" name="reply_attach" id="reply_attach" value="<cfoutput>#reply.FORUM_REPLY_FILE#</cfoutput>">
	<input type="Hidden" name="reply_attach_server_id" id="reply_attach_server_id" value="<cfoutput>#reply.FORUM_REPLY_FILE_SERVER_ID#</cfoutput>">
	<cf_area>
		<table>
			<cfoutput>
				<cfloop from="1" to="16" index="i">
					<tr>
						<td><input type="Radio" value="#i#" name="ImageID" id="ImageID" <cfif reply.ImageID eq i>checked</cfif>><img src="/forum/images/data/icon#i#.gif"></td>
					</tr>
				</cfloop>
			</cfoutput>
		</table>
	</cf_area>
	<cf_area>
		<table>
			<tr>
				<td colspan="2">
				 <cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarSet="WRKContent"
					basePath="/fckeditor/"
					instanceName="reply"
					valign="top"
					value="#reply.reply#"
					width="600"
					height="300">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='103.Dosya Ekle'> <input type="file" name="attach_reply_file" id="attach_reply_file" style="width:400px;"></td>
				<td><input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>"<cfif listfindnocase(valuelist(email_alert.email_emps),session.ep.userid)>checked</cfif>><cf_get_lang no='56.Cevapları Mail Gönder'></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='56.Belge'> 
					<cfif len(reply.FORUM_REPLY_FILE)>
						<cfoutput><a href="javascript://" onClick="windowopen('#file_web_path#forum/#reply.FORUM_REPLY_FILE#','large')"><img src="/images/asset.gif" border="0" title="<cf_get_lang no='29.Belgeyi Gör'>" align="absmiddle"></cfoutput></a>
						<input type="Checkbox" name="delete" id="delete" value="">
						<cf_get_lang no='61.Eski Belgeyi Sil'>
					<cfelse>
						<cf_get_lang no='62.Ekli Belge Yok'>
					</cfif>
				</td>
				<td>
					<input type="checkbox" name="is_active" id="is_active" <cfif reply.is_active eq 1>checked</cfif> value="1">
					<cf_get_lang_main no='81.Aktif'>
				</td>
			</tr>
		</table>
	</cf_area>	
	<cf_form_box_footer>
	<cf_record_info query_name="reply">
		<cf_workcube_buttons 
			is_upd='1'  
			delete_page_url='#request.self#?fuseaction=forum.emptypopup_del_reply&replyid=#attributes.replyid#&topicid=#attributes.topicid#'>
	</cf_form_box_footer>
 </cfform>
</cf_form_box>
