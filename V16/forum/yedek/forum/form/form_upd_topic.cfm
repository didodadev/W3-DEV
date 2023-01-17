<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_topic.cfm">
<cfif session.ep.admin eq 1>
	<cfset is_update_ = 1>
<cfelseif len(forums.ADMIN_POS) and listfindnocase(forums.ADMIN_POS,get_position_id(session.ep.position_code))>
	<cfset is_update_ = 1>
<cfelse>
	<cfset is_update_ = 0>    
</cfif> 
<cfparam name="attributes.forumid" default="">
<cfsavecontent variable="img">
<div class="w3-forum w3-forum-form">
	<a class="wrk-circular-button-add" title="<cf_get_lang_main no='170.Ekle'>" href="<cfoutput>#request.self#?fuseaction=forum.form_add_topic&forumid=#attributes.forumid#</cfoutput>"></a>
</div>
</cfsavecontent>
<cf_form_box title="#getLang('forum',53)#" right_images="#img#">
<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_upd_topic" method="post" name="upd_topic">
<input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
<input type="Hidden" name="topic_attach" id="topic_attach" value="<cfoutput>#topic.FORUM_TOPIC_FILE#</cfoutput>">
<input type="Hidden" name="topic_attach_server_id" id="topic_attach_server_id" value="<cfoutput>#topic.FORUM_TOPIC_FILE_SERVER_ID#</cfoutput>">
 <div class="w3-forum-form">
        <div class="row">   
            <div class="container formContent">
                <div class="row">
                    <div class="col col-5 col-md-8 col-xs-12">
                    
                                <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                        <cf_get_lang no='65.Forum Adı'>*
                                    </label>
                                    <div class="col col-9 col-xs-12">
                                           	<select name="forumid" id="forumid" style="width:583px;">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="forums">
													<option value="#forumid#" <cfif forumid eq topic.forumid>selected</cfif>>#forumname# 
												</cfoutput>
											</select>
                                    </div>
                                </div>

                                 <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                        <cf_get_lang_main no='68.Başlık'>*
                                    </label>
                                    <div class="col col-9 col-xs-12">
                                           	<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='68.Başlık'></cfsavecontent>
											<cfinput type="Text" name="title"  style="width:583px;" value="#topic.title#" message="#message#" required="yes" maxlength="150">
                                    </div>
                                </div>

                                 <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                       
                                    </label>
                                    <div class="col col-9 col-xs-12">
                                           <cfmodule
												template="/fckeditor/fckeditor.cfm"
												toolbarSet="WRKContent"
												basePath="/fckeditor/"
												instanceName="topic"
												valign="top"
												value="#TOPIC.TOPIC#"
												width="100%"
												height="325">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col col-12">
                                    <div class="col col-3 col-xs-12">
                                        <input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>" <cfif listfindnocase(topic.email_emps,session.ep.userid) neq 0>checked</cfif>><cf_get_lang no='56.Cevapları Mail Gönder'>
                                    </div>
                                     <div class="col col-3 col-xs-12">
                                         <input type="Checkbox" name="locked" id="locked" value="1" <cfif topic.locked eq 1>checked</cfif>><cf_get_lang no='66.Yeni Cevaba Kapalı'>
                                    </div>
                                     <div class="col col-2 col-xs-12">
                                     	<input type="checkbox" name="topic_status" id="topic_status" value="1" <cfif topic.topic_status eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'>
                                    </div>   
                                    </div>
                                </div>


                                 <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                       <cf_get_lang_main no='103.Dosya Ekle'>
                                    </label>
                                    <div class="col col-9 col-xs-12 input-group">
                                        <input type="file" name="attach_topic_file" id="attach_topic_file">
                                    </div>
                                </div>

								<div class="form-group">
									<label class="col col- 3 col-xs-12">
										<cf_get_lang_main no='156.Belgeler'>
									</label>
									<div class="col col-9 col-xs-12 input-group">
											<cfif len(topic.FORUM_TOPIC_FILE)>
												<a href="javascript://" onClick="<cfoutput>windowopen('#file_web_path#forum/#topic.FORUM_TOPIC_FILE#','large')</cfoutput>"><img src="/images/asset.gif" border="0" title="<cf_get_lang no='29.Belgeyi Gör'>" align="absmiddle"></a>
												<input type="Checkbox" name="delete" id="delete" value="">
												<cf_get_lang no='61.Eski Belgeyi Sil'>
											<cfelse>
												<cf_get_lang no='62.Ekli Belge Yok'>
											</cfif>
									</div>
								</div>

                                <div class="form-group">
                                    <div class="col col-12">
                                        	<cf_form_box_footer>
												<cf_record_info query_name="topic">
															<cfif is_update_ eq 1 or topic.record_emp eq session.ep.userid> 
																<cf_workcube_buttons type_format="1" 
																	is_upd='1' 
																	delete_page_url='#request.self#?fuseaction=forum.emptypopup_del_topic&topicid=#attributes.topicid#' 
																	add_function='kontrol()'>
															</cfif>  
											</cf_form_box_footer>
                                    </div>
                                </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_topic.forumid.value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='65.Forum Adı'>");
			return false;
		}
	}
</script>
