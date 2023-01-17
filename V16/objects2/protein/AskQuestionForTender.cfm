<cfset tenderCFC = CreateObject("component","V16.objects2.protein.data.tender_data")>
<cfparam name="attributes.forumid" default="">
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.maxrows" default="#session_base.maxrows#">
<cfset TOPICS = tenderCFC.select_topic(
							offer_id:attributes.offer_id,
							startrow:1,
							maxrows:20,
                            is_sub:0
							)>
<section>
    <div class="wrapper font-weight-bold">
        <div id="forum">
            <div class="forum_item flex-row">
                <div class="forum_item_message">
                    <div class="forum_item_message_content"><p>İhale ile ilgili sorularınızı belirtin.</p></div>
                    <div class="new_topic">									
                        <div class="new_topic_content" id="new_topic_content">						
                            <cfform name="add_topic" id="add_topic" method="post" enctype="multipart/form-data">
                                <div class="ui-form-list ui-form-block">
                                    <input type="hidden" name="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">
                                    <input type="hidden" name="is_sub" value="0">
                                    <div class="form-group">
                                        <textarea name="topic" id="topic" class="form-control"></textarea>					
                                    </div>
                                </div>
                                <div class="row">										
                                    <div class="form-group col-sm-12 col-md-12 col-lg-12 col-xl-12">
                                        <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/tender_data:ADD_TOPIC" next_page="#site_language_path#/tenderDetail?offer_id=">												
                                    </div>
                                    <div class="form-group">
                                        <div id="forum_button_message" class="forum_button_message">                   
                                        </div>
                                    </div>
                                </div>
                            </cfform>
                        </div>
                    </div>
                    <cfif topics.recordcount>
                        <cfoutput query="topics" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
                            <div class="forum_item_wrapper flex-row">
                                <cfset get_user_info = tenderCFC.get_user_info(userkey:topics.USERKEY)>
                                <div class="forum_item_avatar">
                                    <cfif len(get_user_info.photo) and FileExists("/hr/#get_user_info.photo#")>
                                        <img src="./documents/hr/#get_user_info.photo#" class="" alt="Person"/>
                                    <cfelse>	
                                        <i style="color:##fff;font-size:15px">#Left(get_user_info.name, 1)##Left(get_user_info.surname, 1)#</i>
                                    </cfif>
                                </div>
                                <div class="forum_item_message">
                                    <div class="forum_item_message_title">
                                        <h3>#get_user_info.name# #get_user_info.surname# <span>#dateformat(date_add('h',session_base.time_zone,record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session_base.time_zone,record_date),"HH:MM")#</span></h3>
                                        <a class="icon" title="Cevap ver" href="javascript://" onclick="showArea('reply_panel_#topics.QUESTION_ID#');">
                                            <i class="fa fa-mail-reply"></i>
                                        </a>
                                    </div>
                                    <div class="forum_item_message_content">
                                        <p>#topics.MESSAGE#</p>
                                    </div>
                                    <div class="reply_messages" id="reply_panel_#topics.QUESTION_ID#" style="display:none;">
                                        <cfform name="add_reply" id="add_reply" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="offer_id" value="#attributes.offer_id#">
                                            <input type="hidden" name="reply_id" value="#QUESTION_ID#">
                                            <input type="hidden" name="is_sub" value="1">
                                            <div class="ui-form-list ui-form-block">
                                                <div class="form-group">
                                                    <textarea name="topic" id="reply_#topics.QUESTION_ID#" class="form-control"></textarea>
                                                </div> 
                                            </div>
                                            <div class="ui-form-list-btn">
                                                <div>
                                                    <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/tender_data:ADD_TOPIC" next_page="#site_language_path#/tenderDetail?offer_id=">   
                                                </div>
                                            </div>
                                        </cfform>
									</div>
                                    <cfset REPLIES = tenderCFC.select_topic(reply_id:topics.question_id, offer_id:attributes.offer_id, startrow:1, maxrows:20, is_sub:1)>
                                    <cfif REPLIES.recordcount>
										<div class="topic_messages last_message" id="topic_messages_#question_id#">
											<cfloop query="#REPLIES#">
												<cfset get_user_info = tenderCFC.get_user_info(userkey:REPLIES.userkey)>
												<div class="topic_message flex-row d-flex">
													<div class="forum_item_avatar">
														<cfif len(get_user_info.photo) and FileExists("./documents/hr/#get_user_info.photo#")>
															<img src="./documents/hr/#get_user_info.photo#" class="img-fluid wrk_user_img " alt="Person"/>
														<cfelse>
															<i style="color:##fff;font-size:15px;">#Left(get_user_info.name, 1)##Left(get_user_info.surname, 1)#</i>
														</cfif>
													</div>
													<div class="forum_item_message">
														<div class="forum_item_message_title">
															<h3>
                                                                #get_user_info.name# #get_user_info.surname#
                                                                <span>#dateformat(date_add('h',session_base.time_zone,REPLIES.RECORD_DATE),'dd/mm/yyy')# #timeformat(date_add('h',session_base.time_zone,REPLIES.RECORD_DATE),'HH:MM')#</span>		
                                                            </h3>
														</div>
														<div class="forum_item_message_content">
															<label>#REPLIES.MESSAGE#</label>
														</div>	
													</div>
												</div>		
											</cfloop>
										</div>
									</cfif>
                                </div>		
                            </div>
                        </cfoutput>
                    <cfelse>
                    </cfif>
                </div>
            </div>

        </div>

    </div>
</section>
<script>
    var edit = $("#new_topic_content textarea").attr("id");
    ClassicEditor.create(document.querySelector("#"+edit+"")).catch(error => {
        console.error(error);
    });

    <cfoutput query="topics">	
        var edit = $("##reply_panel_#question_id# textarea").attr("id");
        ClassicEditor.create(document.querySelector("##"+edit+"")).catch(error => {
            console.error(error);
        });
    </cfoutput>

    function showArea(divid){        
        $("#"+divid+"").slideToggle();
    }

</script>