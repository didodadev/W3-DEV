<cfquery name="TOPIC" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		FORUM_TOPIC
	WHERE 
		TOPICID = #attributes.TOPICID#
</cfquery>

<cfparam name="attributes.forumid" default="">

<div class="row">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfform enctype="multipart/form-data" method="post" name="upd_topic">
		<input type="Hidden" name="forumid" id="forumid" value="<cfoutput>#topic.forumid#</cfoutput>">
		<input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#topic.topicid#</cfoutput>">
		<input type="Hidden" name="topic_attach" id="topic_attach" value="<cfoutput>#topic.FORUM_TOPIC_FILE#</cfoutput>">
		<input type="Hidden" name="topic_attach_server_id" id="topic_attach_server_id" value="<cfoutput>#topic.FORUM_TOPIC_FILE_SERVER_ID#</cfoutput>">
		<div class="row ui-scroll">
			<cfsavecontent variable="head"><cf_get_lang dictionary_id='61838.?'></cfsavecontent>
			<div class="form-group col col-12">
				<cf_get_lang_main no='217.Açıklama'>
					<textarea class="form-control" id="topics" name="topics" style="height:200px"></textarea>		
				<!--- <cfmodule
				template="/fckeditor/fckeditor.cfm"
				toolbarSet="WRKContent"
				basePath="/fckeditor/"
				instanceName="topics"
				valign="top"
				value="#TOPIC.TOPIC#"
				width="650"
				height="325">--->
			</div>			
			<div class="form-group  col col-12 col-md-12 col-sm-12 col-xs-12">
				<label class="pl-2"><cf_get_lang dictionary_id='57493.Aktif'>
					<input type="checkbox" name="topic_status" id="topic_status" value="1" <cfif topic.topic_status eq 1>checked</cfif>>							
				</label>
				<label><cf_get_lang dictionary_id='35308.Yeni Cevap Kapalı'>
					<input type="Checkbox" name="locked" id="locked" value="1" <cfif topic.locked eq 1>checked</cfif>>							
				</label>
			</div>
		</div>
		<div class="draggable-footer">
			<cf_workcube_buttons is_upd="1" data_action="V16/objects2/forumv2/cfc/forum_data:UPD_TOPIC" next_page="/viewTopic?forumid=" del_action="V16/objects2/forumv2/cfc/forum_data:DEL_TOPIC:#topicid#" del_next_page="/viewTopic?forumid=#topic.forumid#">
		</div>
		</cfform>
	</div>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("title").value.trim() == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cfoutput>#getLang('main',68)#</cfoutput>");
			return false;
		}
		return true;
	}


    document.getElementById("topics").value = "<cfoutput>#TOPIC.TOPIC#</cfoutput>";
</script>
