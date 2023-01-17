<cfsetting showdebugoutput="no">
<div id="my_video_comment_add">
	<cfif isdefined('session.pp.userid') or isdefined('session.ww.userid')>
		<cfform name="add_video_comment" action="#request.self#?fuseaction=objects2.emptypopup_add_video_comment">
		<input type="hidden" name="video_id" id="video_id" value="<cfoutput>#attributes.video_id#</cfoutput>">
		<table cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr>
				<td><textarea name="video_comment" id="video_comment" style=" width:300px; height:75px;"></textarea></td>
			</tr>
			<tr>
			  <td height="30">
				 <input type="button" value="<cf_get_lang_main no ='170.Ekle'>" onClick="my_video_comment();">
			  </td>
			</tr>
		</table>
		<div id="show_message_"></div>
		</cfform>
		<script type="text/javascript">
			function my_video_comment()
			{
				if(document.getElementById("video_comment").value == '')
				{
					alert("lütfen Açıklama Yazınız!");
					return false;
				}
				 AjaxFormSubmit('add_video_comment','show_message_','1','Kaydediliyor..','Kaydedildi','<cfoutput>#request.self#?fuseaction=objects2.emptypopup_list_video_comments&video_id=#attributes.video_id#</cfoutput>','SHOW_LIST_PAGE')
			}
		</script>
	<cfelse>
		<table cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>aaaYorum yapmak için üye girişi yapmalısınız!</td>
			</tr>
		</table>
	</cfif>
</div>
