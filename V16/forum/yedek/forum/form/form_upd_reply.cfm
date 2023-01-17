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
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 8
</cfquery>
<cfquery name="GET_WORK" datasource="#DSN#">
	SELECT WORK_ID, WORK_HEAD FROM PRO_WORKS WHERE FORUM_REPLY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#reply.replyid#">
</cfquery>
<cfsavecontent variable="img">

</cfsavecontent>


<cf_form_box title="#getLang('forum',60)# ( #head_topic.forumname# - #head_topic.title# )" right_images="#img#">
<cfform enctype="multipart/form-data" method="post" name="upd_reply" action="#request.self#?fuseaction=forum.emptypopup_upd_reply">
	<input type="Hidden" name="replyid" id="replyid" value="<cfoutput>#replyid#</cfoutput>">
	<input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
	<input type="Hidden" name="reply_attach" id="reply_attach" value="<cfoutput>#reply.forum_reply_file#</cfoutput>">
	<input type="Hidden" name="reply_attach_server_id" id="reply_attach_server_id" value="<cfoutput>#reply.forum_reply_file_server_id#</cfoutput>">
	
	
	<div class="w3-forum-form">
        <div class="row">   
            <div class="container formContent">
                <div class="row">
                    <div class="col col-5 col-md-8 col-xs-12">

						<div class="form-group">	
							<div class="col col-12 col-xs-12">
							<div class="input-group">
								 <cfmodule
										template="/fckeditor/fckeditor.cfm"
										toolbarset="WRKContent"
										basepath="/fckeditor/"
										instancename="reply"
										valign="top"
										value="#reply.reply#"
										width="100%"
										height="300">
								</div>
							</div>
						</div>

						<div class="form-group">
							<label class="col col-6 col-xs-12 ">
								<input type="checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>"<cfif listfindnocase(valuelist(email_alert.email_emps),session.ep.userid)>checked</cfif>>
								<cf_get_lang no='56.Cevapları Mail Gönder'>
								
							</label>
							<label  class="col col-6 col-xs-12">
									<input type="checkbox" name="is_active" id="is_active" <cfif reply.is_active eq 1>checked</cfif> value="1">
									<cf_get_lang_main no='81.Aktif'>
							</label>
							
						</div>

						<div class="form-group">
							<label class="col col-3 col-xs-12">
								<cf_get_lang_main no='103.Dosya Ekle'>
							</label>
							<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="file" name="attach_reply_file" id="attach_reply_file">
								</div>
							</div>
						</div>

						<div class="form-group">
							<label class="col col-3 col-xs-12">
								<cf_get_lang no='5.Özel Tanım'>
							</label>
							<div class="col col-9 col-xs-12">
							<div class="input-group">
								  <select name="special_definition" id="special_definition" style="width:142px">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfoutput query="get_special_definition">
											<option value="#special_definition_id#" <cfif reply.special_definition_id eq special_definition_id>selected</cfif>>#special_definition#</option>
										</cfoutput>
									</select> 
									</div>      
							</div>
						</div>

						<div class="form-group">
							<label class="col col-3 col-xs-12">
									<cf_get_lang no='21.İlişkili İş'>
							</label>
							<div class="col col-9 col-xs-12 ">
									<div class="input-group">
									
									 <input type="hidden" name="work_id" id="work_id" value="<cfif get_work.recordcount><cfoutput>#get_work.work_id#</cfoutput></cfif>">
									<input type="text" name="work_head" id="work_head" style="width:125px;" value="<cfif get_work.recordcount><cfoutput>#get_work.work_head#</cfoutput></cfif>">
									<span class="input-group-addon icom-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=upd_reply.work_id&field_name=upd_reply.work_head','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
									</div>
							</div>
						</div>

						<div class="form-group">
							<label  class="col col-3 col-xs-12">
									<cf_get_lang_main no='56.Belge'> 
							</label>
							<div class="col col-9 col-xs-12">
							<div class="input-group">
								<cfif len(reply.forum_reply_file)>
									<cfoutput><a href="javascript://" onclick="windowopen('#file_web_path#forum/#reply.forum_reply_file#','large')"><img src="/images/asset.gif" border="0" title="<cf_get_lang no='29.Belgeyi Gör'>" align="absmiddle"></cfoutput></a>
									<input type="checkbox" name="delete" id="delete" value="">
									<cf_get_lang no='61.Eski Belgeyi Sil'>
								<cfelse>
									<cf_get_lang no='62.Ekli Belge Yok'>
								</cfif>    
							</div>   
							</div>
						</div>

						<div class="col col-12">
								<cf_form_box_footer>
									<cf_record_info query_name="reply">
										<cf_workcube_buttons 
											is_upd='1'  
											delete_page_url='#request.self#?fuseaction=forum.emptypopup_del_reply&replyid=#attributes.replyid#&topicid=#attributes.topicid#'>
								</cf_form_box_footer>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</cfform>
</cf_form_box>
