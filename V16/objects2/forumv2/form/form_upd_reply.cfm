<cfset forumCFC = CreateObject("component","V16.objects2.forumv2.cfc.forum_data")>
<cfset reply = forumCFC.select_reply(replyid:attributes.replyid)>
<cfparam name="attributes.topicid" default="#reply.topicid#">
<cfset reply_ = replace(reply.reply,'<p>','','all')>
<cfset reply_ = replace(reply_,'</p>','','all')>  
<form enctype="multipart/form-data" method="post" name="upd_reply" >
	<div class="row ui-scroll">
		<div class="col-lg-12">
			<input type="Hidden" name="replyid" id="replyid" value="<cfoutput>#replyid#</cfoutput>">
			<input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
			<input type="Hidden" name="forumid" id="forumid" value="<cfoutput>#attributes.forumid#</cfoutput>">
			<input type="Hidden" name="reply_attach" id="reply_attach" value="<cfoutput>#reply.forum_reply_file#</cfoutput>">
			<input type="Hidden" name="reply_attach_server_id" id="reply_attach_server_id" value="<cfoutput>#reply.forum_reply_file_server_id#</cfoutput>">

			<div class="form-group pt-2">
				<textarea class="form-control" id="replys" name="replys" style="height:270px"></textarea>	
				<!--- <cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarset="WRKContent"
					basepath="/fckeditor/"
					instancename="replys"
					valign="top"
					value="#reply.reply#"
					width="100%"
					height="150"> --->
			</div>
		</div>
	</div>
	<div class="draggable-footer">
		<cf_workcube_buttons is_upd="1" data_action="V16/objects2/forumv2/cfc/forum_data:UPD_REPLY" next_page="#site_language_path#/viewTopic?forumid=" del_action="V16/objects2/forumv2/cfc/forum_data:DEL_REPLY:#replyid#" del_next_page="#site_language_path#/viewTopic?forumid=#forumid#">
	</div>
</form>

<script>
    document.getElementById("replys").value = "<cfoutput>#reply_#</cfoutput>";
</script>