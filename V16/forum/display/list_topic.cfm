<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset forumCFC = CreateObject("component","V16.forum.cfc.forum").init(dsn = application.systemParam.systemParam().dsn)>
<cfset topicCFC = CreateObject("component","V16.forum.cfc.topic").init(dsn = application.systemParam.systemParam().dsn)>
<cfset replyCFC = CreateObject("component","V16.forum.cfc.reply").init(dsn = application.systemParam.systemParam().dsn)>
<cfset userinfo = CreateObject("component","V16.forum.cfc.userinfo")>

<cfinclude template="../query/get_forum_name.cfm">

<cfif session.ep.admin eq 1>
	<cfset is_update_ = 1>
<cfelseif listlen(GET_FORUM_NAME.ADMIN_POS) and listfindnocase(GET_FORUM_NAME.ADMIN_POS,get_position_id(session.ep.position_code))>
	<cfset is_update_ = 1>
<cfelse>
	<cfset is_update_ = 0>
</cfif>

<cfset TOPICS = topicCFC.select(
							forumid:attributes.forumid,
							startrow:1,
							maxrows:20
							)>

        <cfif get_forum_name.recordcount>
			<cfset employees_list="">
			<cfset cons_cat_list="">
			<cfset comp_cat_list="">
			<cfset partner_list="">
			<cfset consumer_list ="">
			<cfoutput query="get_forum_name">
			<cfif len(admin_pos) and not listfind(employees_list,admin_pos,',')>
				<cfset employees_list = listappend(employees_list,admin_pos,',')>
			</cfif>	
			<cfif len(forum_cons_cats) and not listfind(cons_cat_list,forum_cons_cats,',')>
				<cfset cons_cat_list = listappend(cons_cat_list,forum_cons_cats,',')>
			</cfif>
			<cfif len(forum_comp_cats) and not listfind(comp_cat_list,forum_comp_cats,',')>
				<cfset comp_cat_list = listappend(comp_cat_list,forum_comp_cats,',')>
			</cfif>
			<cfif len(admin_pars) and not listfind(partner_list,admin_pars,',')>
				<cfset partner_list = listappend(partner_list,admin_pars,',')>
			</cfif>	
			<cfif len(admin_cons) and not listfind(consumer_list,admin_cons,',')>
				<cfset consumer_list = listappend(consumer_list,admin_cons,',')>
			</cfif>											
			</cfoutput>	
			<cfif len(employees_list)>
				<cfset employees_list = listsort(listdeleteduplicates(employees_list),'numeric','ASC',',')>
				<cfquery name="get_emp" datasource="#dsn#">
					SELECT 
						EP.POSITION_ID,
						EP.EMPLOYEE_ID,
						EP.EMPLOYEE_NAME,
						EP.EMPLOYEE_SURNAME,
						E.PHOTO
					FROM
						EMPLOYEE_POSITIONS EP JOIN EMPLOYEES E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
					WHERE
						EP.EMPLOYEE_ID IS NOT NULL AND
						EP.POSITION_ID IN (#employees_list#) AND
						EP.POSITION_STATUS = 1
					ORDER BY
						EP.POSITION_ID
				</cfquery>
				<cfset employees_list= listsort(listdeleteduplicates(valuelist(get_emp.position_id,',')),'numeric','ASC',',')>	
			</cfif>
			<cfif len(cons_cat_list)>
				<cfset cons_cat_list = listsort(listdeleteduplicates(cons_cat_list),'numeric','ASC',',')>
				<cfquery name="get_consumer_cats" datasource="#dsn#">
					SELECT 
						CONSCAT_ID,
						CONSCAT
					FROM 
						CONSUMER_CAT
					WHERE
						CONSCAT_ID IN (#cons_cat_list#)
					ORDER BY
						CONSCAT
				</cfquery>
				<cfset cons_cat_list= listsort(listdeleteduplicates(valuelist(get_consumer_cats.conscat_id,',')),'numeric','ASC',',')>				
			    </cfif>
			    <cfif len(comp_cat_list)>
				<cfset comp_cat_list = listsort(listdeleteduplicates(comp_cat_list),'numeric','ASC',',')>
				<cfquery name="get_company_cats" datasource="#dsn#">
					SELECT
						COMPANYCAT_ID,
						COMPANYCAT
					FROM
						COMPANY_CAT
					WHERE
						COMPANYCAT_ID IN (#comp_cat_list#)
					ORDER BY 
						COMPANYCAT_ID
				</cfquery>	
				<cfset comp_cat_list= listsort(listdeleteduplicates(valuelist(get_company_cats.companycat_id,',')),'numeric','ASC',',')>							
			</cfif>
			<cfif len(partner_list)>
				<cfset partner_list = listsort(listdeleteduplicates(partner_list),'numeric','ASC',',')>
				<cfquery name="get_partner" datasource="#dsn#">
					SELECT
						PARTNER_ID,
						COMPANY_PARTNER_NAME,
						COMPANY_PARTNER_USERNAME,
						COMPANY_PARTNER_SURNAME,
						PHOTO
					FROM
						COMPANY_PARTNER
					WHERE
						PARTNER_ID IS NOT NULL AND
						COMPANY_PARTNER_STATUS = 1 AND
						PARTNER_ID IN (#partner_list#)
					ORDER BY
						PARTNER_ID
				</cfquery>
				<cfset partner_list= listsort(listdeleteduplicates(valuelist(get_partner.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(consumer_list)>
				<cfset consumer_list= listsort(listdeleteduplicates(consumer_list),'numeric','ASC',',')>
				<cfquery name="get_consumer" datasource="#dsn#">
					SELECT
						CONSUMER_ID,
						CONSUMER_NAME,
						CONSUMER_USERNAME,
						CONSUMER_SURNAME
						PICTURE
					FROM
						CONSUMER
					WHERE
						CONSUMER_STATUS = 1 AND
						CONSUMER_ID IN (#consumer_list#)
					ORDER BY 
						CONSUMER_ID
				</cfquery>
				<cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
        </cfif>    

<cfinclude template="../query/get_company_name.cfm">

<cfinclude template="../../rules/display/rule_menu.cfm">
<!--- <cfinclude template="../display/module_header.cfm"> --->

<section>
	<div class="wrapper" id="forum">
		<div class="blog_title">
			<i class="fa fa-archive"></i>
			Güncel Tartışmalar
		</div>
		<div class="forum_item flex-row">
			<cfoutput>
			<cfset forumNameFirstChar = UCase(left(get_forum_name.forumname,1))> 
				<div class="forum_item_avatar">		
					<i>#forumNameFirstChar#</i>
				</div>
				<div class="forum_item_message">
					<div class="forum_item_message_title">
						<a class="general" href="javacsript://">
							#get_forum_name.forumname#
							<span>#dateformat(date_add('h',session.ep.time_zone,get_forum_name.record_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,get_forum_name.record_date),timeformat_style)#</span>
						</a>
						<cfif (len(get_forum_name.admin_pos) and listfindnocase(get_forum_name.admin_pos,get_position_id(session.ep.position_code))) or session.ep.admin eq 1 or get_forum_name.record_emp eq session.ep.userid>	
							<a class="icon" title="Düzenle" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=forum.form_upd_forum&forumid=#attributes.forumid#')">
								<i class="fa fa-pencil"></i>
							</a>
						</cfif>
						<cfif get_forum_name.STATUS eq 1>
							<a class="icon" title="Konu Ekle" href="javascript://" onclick="$.showArea('new_topic_content')">
								<i class="fa fa-plus"></i>
							</a>
						</cfif>
					</div>
					<!--- <cfif get_forum_name.STATUS eq 0>
						<div class="col col-6 col-xs-12 closeTopic pdn-r-0 flt-r txt-r">
							<span><i class="fa fa-lock"></i><cf_get_lang no='57.Kapalı Konu'></p>
						</div>
					</cfif> --->
					<div class="forum_item_message_content"><p>#get_forum_name.description#</p></div>
					<!--- <div class="forum_item_subject">
							<i class="fa fa-file-text-o"></i>
							<span class="last_answer">#getLang("forum",19,"Konu/Mesaj")#</span>
							<span class="last_answer_value"><b>#get_forum_name.topic_count#/#get_forum_name.reply_count#</b></span>
					</div> --->
					<div class="new_topic">									
						<div style="display:none;" class="new_topic_content" id="new_topic_content">
					
							<cfform name="add_topic" id="add_topic" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_add_topic">
								<div class="ui-form-list ui-form-block">
									<input type="hidden" name="forumname" value="<cfoutput>#get_forum_name.forumname#</cfoutput>">
									<input type="hidden" name="forumid" value="<cfoutput>#attributes.forumid#</cfoutput>">
									<div class="form-group">
									
										<cfmodule
											template="/fckeditor/fckeditor.cfm"
											toolbarSet="WRKContent"
											basePath="/fckeditor/"
											instanceName="topic"
											valign="top"
											value=""
											width="650"
											height="150">
					
									</div>
								</div>
								<div class="ui-form-list flex-list flex-start">
									<div class="form-group">
										<label ><cf_get_lang no='56.Cevapları Mail Gönder'>
											<input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>">												
										</label>
									</div>	
									<div class="form-group">
										<label ><cf_get_lang no='66.Yeni Cevap Kapalı'>
										<input type="Checkbox" name="locked" id="locked" value="1">											
										</label>
									</div>			
									<div class="form-group">
										<label ><cf_get_lang_main no='81.Aktif'>
										<input type="checkbox" name="topic_status" id="topic_status" value="1" checked>											
										</label>
									</div>			
									<div class="form-group">
										<label ><cf_get_lang no='71.Forum Yöneticisine Mail Gönder'>
										<input type="checkbox" name="email" id="email" value="1">											
										</label>
									</div>			
									<div class="form-group">
										<div class="fileButtonArea">
											<div class="input-file-container txt-r"> 													 
												<input class="input-file" id="attach_topic_file1" name="attach_topic_file1" type="file" hidden>
												<!--- <label tabindex="0" for="attach_topic_file" class="input-file-trigger">Dosya Ekle</label> --->
												<label tabindex="0" for="attach_topic_file1" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left file-button-upload"><i class="fa fa-cloud-upload"></i>Dosya Yükle</label>
											</div>
										</div>
									</div>
									<div class="form-group">
										<input type="submit" id="forum_share_button" class="forum_share_button" value="<cfoutput>#getLang('assetcare',526)#</cfoutput>">
									</div>
									<div class="form-group">
										<div id="forum_button_message" class="forum_button_message">
																
										</div>
									</div>			
								</div>
							</cfform>
						</div>
					</div>
					<div class="forum_item_cat">
						<p>#getLang("forum",40,"Son Cevap")#</p>
						<cfif len(get_forum_name.last_msg_date)>
										
							<cfset get_user_info = userinfo.get_user_info(userkey:get_forum_name.last_msg_userkey)>
							<a href="javascript://"  
								<cfif listfirst(get_forum_name.last_msg_userkey,"-") is "e">
									onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(get_forum_name.last_msg_userkey,"-")#', 'warning_modal')"
								<cfelseif listfirst(get_forum_name.last_msg_userkey,"-") is "p">
									onclick="cfmodal('#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(get_forum_name.last_msg_userkey,"-")#', 'warning_modal')"
								<cfelseif listfirst(get_forum_name.last_msg_userkey,"-") is "c">
									onclick="cfmodal('#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(get_forum_name.last_msg_userkey,"-")#', 'warning_modal')"
								</cfif>>				
								<span>
									<i>
										#get_user_info.name# #get_user_info.surname# -
										#dateformat(date_add('h',session.ep.time_zone,get_forum_name.last_msg_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,get_forum_name.last_msg_date),timeformat_style)#
									</i>
								</span>
							</a>
							
							
						<cfelse>
							<span><i class="fa fa-frown-o"></i></span>	
						</cfif>
				</div>
					<div class="forum_item_user">
						<p>Moderasyon</p>
						<ul>
							<cfif len(get_forum_name.admin_pos)>
								<cfloop list="#listdeleteduplicates(get_forum_name.admin_pos)#" index="x">
									<cfif len(get_emp.employee_id[listfind(employees_list,x)])>
										<li>
											<a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(employees_list,x)]#', 'warning_modal');">
												<cfif len(trim(get_emp.photo[listfind(employees_list,x)])) and FileExists("#upload_folder#/hr/#get_emp.photo[listfind(employees_list,x)]#")>
													<cfset resim = "./documents/hr/"&get_emp.photo[listfind(employees_list,x)]>
													<img src="#resim#"
														class="img-fluid wrk_user_img hidden-md-down"
														alt="emp" />	
												<cfelse>
													<span class="color-#Left(get_emp.employee_name[listfind(employees_list,x)], 1)#">#Left(get_emp.employee_name[listfind(employees_list,x)], 1)##Left(get_emp.employee_surname[listfind(employees_list,x)], 1)#</span>
												</cfif>	
												<i>#get_emp.employee_name[listfind(employees_list,x)]# #get_emp.employee_surname[listfind(employees_list,x)]#</i>
											</a>
										</li>
									</cfif>
									<!---<cfif listlast(admin_pos,',') neq x>,</cfif>--->
								</cfloop>
							</cfif>	
							<cfif len(get_forum_name.admin_pars)>
								<cfloop list="#listdeleteduplicates(get_forum_name.admin_pars)#" index="a">
									<cfif len(get_partner.partner_id[listfind(partner_list,a)])>
										<li>
											<a href="javascript://" onclick="nModal(head:'Profil', page: '#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.partner_id[listfind(partner_list,a)]#'});" class="wrk_user_name mobil_text">
												<cfif len(trim(get_partner.photo[listfind(partner_list,a)])) and FileExists("#upload_folder#/hr/#get_partner.photo[listfind(partner_list,a)]#")>
													<cfset resim = "./documents/hr/"&get_partner.photo[listfind(partner_list,x)]>
													<img src="#resim#"
														class="img-fluid wrk_user_img hidden-md-down"
													alt="partner" />
												<cfelse>
													<span class="color-#Left(get_partner.company_partner_name[listfind(partner_list,a)], 1)#">#Left(get_partner.company_partner_name[listfind(partner_list,a)], 1)##Left(get_partner.company_partner_surname[listfind(partner_list,a)], 1)#</span>
												</cfif>
												<i>#get_partner.company_partner_name[listfind(partner_list,a)]# #get_partner.company_partner_surname[listfind(partner_list,a)]#</i>
											</a>
										</li>
										<!---<cfif listlast(admin_pars,',') neq a>,</cfif>--->
									</cfif>
								</cfloop>
							</cfif>	
							<cfif len(get_forum_name.admin_cons)>
								<cfloop list="#listdeleteduplicates(get_forum_name.admin_cons)#" index="b">
									<cfif len(get_consumer.consumer_id[listfind(consumer_list,b)])>
										<li>
											<a href="javascript://"  onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&con_id=#get_consumer.consumer_id[listfind(consumer_list,b)]#'});" class="wrk_user_name mobil_text">
												<cfif len(trim(get_consumer.picture[listfind(consumer_list,b)])) and FileExists("#upload_folder#/hr/#get_consumer.picture[listfind(consumer_list,b)]#")>
													<cfset resim = "./documents/hr/"&get_consumer.picture[listfind(consumer_list,b)]>
													<img src="#resim#"
														class="img-fluid wrk_user_img hidden-md-down"
														alt="consumer"/>
												<cfelse>
													<span class="color-#Left(get_consumer.consumer_name[listfind(consumer_list,b)], 1)#">#Left(get_consumer.consumer_name[listfind(consumer_list,b)], 1)##Left(get_consumer.consumer_surname[listfind(consumer_list,b)], 1)#</span>
												</cfif>
												<i>#get_consumer.consumer_name[listfind(consumer_list,b)]# #get_consumer.consumer_surname[listfind(consumer_list,b)]#</i>
											</a>
										</li>
										<!---<cfif listlast(admin_cons,',') neq b>,</cfif>--->
									</cfif>
								</cfloop>
							</cfif>	
						</ul>
					</div>
					<div class="forum_item_cat">
						<p><cf_get_lang no='31.Kimler İçin'></p> 
							<span>
								<cfif get_forum_name.forum_emps eq 1>
									<i><cf_get_lang_main no='1463.Çalışanlar'></i>
								</cfif>
								<cfif len(get_forum_name.forum_comp_cats)>
									<i><cf_get_lang_main no='1611.Kurumsal Üyeler'></i>
										<cfset i=1/>
											<cfloop list="#listdeleteduplicates(get_forum_name.forum_comp_cats)#" index="v">
												<cfoutput>
													<cfif i LE 3>
														<i>#get_company_cats.companycat[listfind(comp_cat_list,v)]#</i>
													</cfif>
													<cfset i=i+1/>
												</cfoutput>
												<!---<cfif listlast(forum_comp_cats,',') neq v>,</cfif>--->
											</cfloop>
								</cfif>
								<cfif len(get_forum_name.forum_cons_cats)>
									<i><cf_get_lang_main no='1609.Bireysel Üyeler'></i>
										<cfset i=1/>
											<cfloop list="#listdeleteduplicates(get_forum_name.forum_cons_cats)#" index="y">
												<cfoutput>
													
													<cfif i LE 3>
														<i>#get_consumer_cats.conscat[listfind(cons_cat_list,y)]#</i>
													
													</cfif>
													<cfset i=i+1/>
												</cfoutput>
												<!---<cfif listlast(forum_cons_cats,',') neq y>,</cfif>--->
											</cfloop>
								</cfif>			
							</span>
					</div>
						
				
			</cfoutput>
		
		<cfif topics.recordcount>
				<cfoutput query="topics" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
						<div class="forum_item_wrapper flex-row">
							<cfset get_user_info = userinfo.get_user_info(userkey:topics.USERKEY)>
							<div class="forum_item_avatar">
								<cfif len(get_user_info.photo) and FileExists("#upload_folder#/hr/#get_user_info.photo#")>
									<img src="./documents/hr/#get_user_info.photo#" class="" alt="Person"/>
								<cfelse>	
									<i style="color:##fff">#Left(get_user_info.name, 1)##Left(get_user_info.surname, 1)#</i>
								</cfif>
							</div>
							<div class="forum_item_message">
								<div class="forum_item_message_title">
									<!--- <a href="javascript://"  
										<cfif listfirst(topics.USERKEY,"-") is "e">
											onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(topics.USERKEY,"-")#'});"
										<cfelseif listfirst(topics.USERKEY,"-") is "p">
											onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(topics.USERKEY,"-")#'});"
										<cfelseif listfirst(topics.USERKEY,"-") is "c">
											onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(topics.USERKEY,"-")#'});"
										</cfif>
									> --->
									<h3>#get_user_info.name# #get_user_info.surname# <span>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)# 
										
									</span></h3>
									<cfif is_update_ eq 1 or record_emp eq session.ep.userid>
										<a class="icon" title="Konu Düzenle" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=forum.form_upd_topic&topicid=#topicid#')">
											<i class="fa fa-pencil"></i>
										</a>
									</cfif>
									<cfif locked neq 1 and TOPIC_STATUS neq 0 and get_forum_name.STATUS neq 0>
										<a class="icon" title="Cevap ver" href="javacsript://" onclick="$.showArea('reply_panel_#topics.topicid#');">
											<i class="fa fa-mail-reply"></i>
										</a>
									</cfif>
								</div>
								<div class="forum_item_message_content">
									<p>#topics.topic#</p>
									<cfif len(topics.FORUM_TOPIC_FILE)>
										<div class="downloadForumFile"><cfif len(topics.FORUM_TOPIC_REAL_FILE)>#topics.FORUM_TOPIC_REAL_FILE#<cfelse><cfoutput>#topics.FORUM_TOPIC_FILE#</cfoutput></cfif><cf_get_server_file output_file="forum#dir_seperator##topics.FORUM_TOPIC_FILE#" output_server="#topics.FORUM_TOPIC_FILE_SERVER_ID#" output_type="6" image_link="1"></div>
									</cfif>
								</div>
								<!--- <div class="forum_item_cat">
									<p>#getLang("forum",40)#</p>			
									<!--- <div class="col col-2 col-xs-12 pdn-l-0 message_row">
										<i class="fa fa-commenting-o"></i>
										<span class="last_answer">#getLang("main",1242)#:</span>
										<span class="last_answer_value"><b>#reply_count#</b></span>
									</div>	 --->
									<span>
										<cfif len(last_reply_date)>
											<i>#get_user_info.name# #get_user_info.surname# - #dateformat(date_add('h',session.ep.time_zone,last_reply_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,last_reply_date),timeformat_style)#</i>											
										<cfelse>
											<i class="fa fa-frown-o"></i>
										</cfif>
									</span>
								</div> --->
								<div class="reply_messages" id="reply_panel_#topics.topicid#" style="display:none;">
									<cfif locked eq 0>
										<cfform name="add_reply" id="add_reply" method="post" class="post-form" enctype="multipart/form-data" action="#request.self#/index.cfm?fuseaction=forum.emptypopup_add_reply">
											<input type="hidden" name="first_hie" id="first_hie" value="">
											<input type="hidden" name="forumid" value="#FORUMID#">
											<input type="hidden" name="topicid" value="#TOPICID#">
											<div class="ui-form-list ui-form-block">
												<div class="form-group">
													<cfmodule
														template="/fckeditor/fckeditor.cfm"
														toolbarSet="WRKContent"
														basePath="/fckeditor/"
														instanceName="reply_#topics.topicid#"
														valign="top"
														value=""
														width="650"
														height="150">
												</div>
											</div>
											<div class="ui-form-list-btn">
												<div>
													<!--- <div class="col col-8 flt-l forum_button_message" id="reply_result"></div> --->
													<input type="submit" value="#getLang('assetcare',526)#">
												</div>
											</div>
										</cfform>
									</cfif>
								</div>
								<cfset HIERARCHY = "">
								<cfset REPLIES = replyCFC.select(topicid:topics.topicid,startrow:1,maxrows:4)><!--- maks. 4 kayıt listele --->
								<cfif REPLIES.recordcount>
									<cfset HIERARCHY = REPLIES.HIERARCHY>
									<div class="topic_messages last_message" id="topic_messages_#topics.topicid#">
										<cfloop query="#REPLIES#">
											<cfset get_user_info = userinfo.get_user_info(userkey:REPLIES.userkey)>
											<div class="topic_message flex-row">
												<div class="forum_item_avatar">
													<cfif len(get_user_info.photo) and FileExists("./documents/hr/#get_user_info.photo#")>
														<img src="./documents/hr/#get_user_info.photo#" class="img-fluid wrk_user_img " alt="Person"/>
													<cfelse>
														<i style="color:##fff">#Left(get_user_info.name, 1)##Left(get_user_info.surname, 1)#</i>
													</cfif>
												</div>
												<div class="forum_item_message">
													<div class="forum_item_message_title">
														<h3 
															<!--- <cfif listfirst(REPLIES.userkey,"-") is "e">
																onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(REPLIES.userkey,"-")#'});"
															<cfelseif listfirst(REPLIES.userkey,"-") is "p">
																onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(REPLIES.userkey,"-")#'});"
															<cfelseif listfirst(REPLIES.userkey,"-") is "c">
																onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(REPLIES.userkey,"-")#'});"
															</cfif> --->
													>
														#get_user_info.name# #get_user_info.surname#
														<span>#dateformat(date_add('h',session.ep.time_zone,REPLIES.UPDATE_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,REPLIES.UPDATE_DATE),timeformat_style)#
															-
															<cfif REPLIES.record_emp eq session.ep.userid>
																<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=forum.form_upd_reply&forumid=#attributes.forumid#&topicid=#topics.topicid#&replyid=#REPLIES.replyid#')">
																	#getLang("main",52)#
																</a>
															</cfif> 
														</span>
																		
													</h3>
													</div>
													
													<div class="forum_item_message_content" id="#REPLIES.replyid#">
														#REPLIES.REPLY#
													</div>
															
												</div>
											</div>		
										</cfloop>
										<cfif REPLIES.QUERY_COUNT gt 4>
										<div class="more_data_parent">
											<div class="more_data" id="more_data">
												<a href="javascript://" onclick="$.moreData(#topics.topicid#,5)"><cf_get_lang dictionary_id="48384.Daha fazla göster"></a>
											</div>
										</div>	
										</cfif>
									</div>
								</cfif>
							</div>	
								<!--- <div class="col col-6 col-xs-12 closeTopic pdn-r-0 flt-r txt-r">
									<cfif locked eq 1 or TOPIC_STATUS eq 0 or get_forum_name.STATUS eq 0>
										<span><i class="fa fa-lock"></i><cf_get_lang no='57.Kapalı Konu'></p>
									</cfif>
								</div> --->
						</div>
				</cfoutput>		
				</div>		
			</div>
		</cfif>	
	</div>
</section>


<!--- <section class="intranet_section col col-12 col-md-12 col-xs-12">
	<div class="wrkListContent">
		<div class="row">
			<div class="box-content">
				<div class="col col-12 forum_content pdn-l-0 pdn-r-0">
					<!--- forum info --->
					<div class="forum_info col col-12">
					
						<cfoutput>
							<cfset forumNameFirstChar = UCase(left(get_forum_name.forumname,1))> 
							<div class="col col-12 col-xs-12">
								<div class="col col-1 col-xs-2">		
									<div class="wrk_letter">#forumNameFirstChar#</div>
								</div>
								<div class="col col-10 wrk_content pdn-r-0">
									<h3 class="wrk_title">
										#get_forum_name.forumname#
										- <span class="titleDate">#dateformat(date_add('h',session.ep.time_zone,get_forum_name.record_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,get_forum_name.record_date),timeformat_style)#</span>
									</h3>
									<cfif get_forum_name.STATUS eq 0>
										<div class="col col-6 col-xs-12 closeTopic pdn-r-0 flt-r txt-r">
											<span><i class="fa fa-lock"></i><cf_get_lang no='57.Kapalı Konu'></p>
										</div>
									</cfif>
									<p class="wrk_desc">#get_forum_name.description#</p>
									<div class="col col-12 col-xs-12 last_message pdn-l-0">
									
										<div class="col col-2 col-md-3 col-xs-12 pdn-l-0 message_row">
											<i class="fa fa-file-text-o"></i>
											<span class="last_answer">#getLang("forum",19,"Konu/Mesaj")#</span>
											<span class="last_answer_value"><b>#get_forum_name.topic_count#/#get_forum_name.reply_count#</b></span>
										</div>
										<div class="col col-3 col-md-3 col-xs-12 pdn-l-0 message_row">
											<i class="fa fa-clock-o"></i>
											<span class="last_answer">#getLang("forum",40,"Son Cevap")#:</span>
											<cfif len(get_forum_name.last_msg_date)>
															
												<cfset get_user_info = userinfo.get_user_info(userkey:get_forum_name.last_msg_userkey)>
												<a href="javascript://"  
													<cfif listfirst(get_forum_name.last_msg_userkey,"-") is "e">
														onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(get_forum_name.last_msg_userkey,"-")#'});"
													<cfelseif listfirst(get_forum_name.last_msg_userkey,"-") is "p">
														onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(get_forum_name.last_msg_userkey,"-")#'});"
													<cfelseif listfirst(get_forum_name.last_msg_userkey,"-") is "c">
														onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(get_forum_name.last_msg_userkey,"-")#'});"
													</cfif>
												>				
													<span class="last_answer_value">
													#get_user_info.name# #get_user_info.surname#
													</span>
												</a>
												- <span class="last_answer_value">#dateformat(date_add('h',session.ep.time_zone,get_forum_name.last_msg_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,get_forum_name.last_msg_date),timeformat_style)#</span>
												
											<cfelse>
												<span class="last_answer_value"><i class="sadicon"></i></span>	
											</cfif>
										</div>
										<div class="col col-6 col-xs-12">
											<cfif (len(get_forum_name.admin_pos) and listfindnocase(get_forum_name.admin_pos,get_position_id(session.ep.position_code))) or session.ep.admin eq 1 or get_forum_name.record_emp eq session.ep.userid>	
												<div class="col col-3 col-md-4 col-xs-12 pdn-l-0 message_row">
													<a href="#request.self#?fuseaction=forum.form_upd_forum&forumid=#attributes.forumid#" class="message_row_button">
														<i class="fa fa-pencil"></i>
														<span class="last_answer_value">#getLang("main",52)#</span>
													</a>
												</div>
											</cfif>
											<div class="col col-5 col-md-6 col-xs-12 pdn-l-0 message_row">
											<cfif get_forum_name.STATUS eq 1>
												<a href="javascript://" onclick="$.showArea('new_topic_content')" class="message_row_button">
													<i class="fa fa-plus"></i>
													<span class="last_answer_value"><cf_get_lang dictionary_id="55016"></span>
												</a>
											</cfif>
											</div>
										</div>
									</div>
									<div class="col col-12 pdn-l-0 pdn-r-0 new_topic">									
										<div class="col col-12 new_topic_content pdn-l-0 pdn-r-0" id="new_topic_content">

											<cfform name="add_topic" id="add_topic" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_add_topic">
												<div class="row">
													<div class="col col-12 pdn-l-0 pdn-r-0">
														<input type="hidden" name="forumname" value="<cfoutput>#get_forum_name.forumname#</cfoutput>">
														<input type="hidden" name="forumid" value="<cfoutput>#attributes.forumid#</cfoutput>">
														<div class="form-group">
														
															<cfmodule
																template="/fckeditor/fckeditor.cfm"
																toolbarSet="WRKContent"
																basePath="/fckeditor/"
																instanceName="topic"
																valign="top"
																value=""
																width="650"
																height="150">

														</div>
														<div class="col col-12 pdn-l-0">
															<div class="col col-9 col-xs-12 pdn-l-0">
															
																<div class="form-inline">
																	<div class="form-group col-xs-12">
																		<label class="container"><cf_get_lang no='56.Cevapları Mail Gönder'>
																		<input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>">
																		<span class="checkmark"></span>
																		</label>
																	</div>
																	<div class="form-group col-xs-12">
																		<label class="container"><cf_get_lang no='66.Yeni Cevap Kapalı'>
																		<input type="Checkbox" name="locked" id="locked" value="1">
																		<span class="checkmark"></span>
																		</label>
																	</div>
																	<div class="form-group col-xs-12">
																		<label class="container"><cf_get_lang_main no='81.Aktif'>
																		<input type="checkbox" name="topic_status" id="topic_status" value="1" checked>
																		<span class="checkmark"></span>
																		</label>
																	</div>
																	<div class="form-group col-xs-12">
																		<label class="container"><cf_get_lang no='71.Forum Yöneticisine Mail Gönder'>
																		<input type="checkbox" name="email" id="email" value="1">
																		<span class="checkmark"></span>
																		</label>
																	</div>
																	<div class="form-group col-xs-12">
																		<div class="fileButtonArea">
																			<div class="input-file-container txt-r">  
																				<input class="input-file" id="attach_topic_file" name="attach_topic_file" type="file">
																				<label tabindex="0" for="attach_topic_file" class="input-file-trigger">Dosya Ekle</label>
																			</div>
																		</div>
																	</div>
																</div>

															</div>
															<div class="col col-3 col-xs-12 pdn-r-0">

																<div id="forum_button_message" class="forum_button_message col col-8">
														
																</div>
																<div class="col col-4 pdn-r-0 txt-r forum_button">
																	<input type="submit" id="forum_share_button" class="forum_share_button" value="<cfoutput>#getLang('assetcare',526)#</cfoutput>">
																</div>

															</div>
														</div>
													</div>
													
												</div>
											</cfform>

										</div>
									</div>
									<div class="col col-12 pdn-l-0">
										<div class="col col-12 col-xs-12 pdn-l-0">
											<h6>   
												<span class="text-brand-warning font-raleway-800"><cf_get_lang no='31.Kimler İçin'>:</span><span class="mobil_text">
													<cfif get_forum_name.forum_emps eq 1>
														<cf_get_lang_main no='1463.Çalışanlar'>
													</cfif>
													<cfif len(get_forum_name.forum_comp_cats)>
														<cf_get_lang_main no='1611.Kurumsal Üyeler'>
															<cfset i=1/>
																<cfloop list="#listdeleteduplicates(get_forum_name.forum_comp_cats)#" index="v">
																	<cfoutput>
																		<cfif i LE 3>
																			#get_company_cats.companycat[listfind(comp_cat_list,v)]#
																		</cfif>
																		<cfset i=i+1/>
																	</cfoutput>
																	<!---<cfif listlast(forum_comp_cats,',') neq v>,</cfif>--->
																</cfloop>
													</cfif>
													<cfif len(get_forum_name.forum_cons_cats)>
														<cf_get_lang_main no='1609.Bireysel Üyeler'>
															<cfset i=1/>
																<cfloop list="#listdeleteduplicates(get_forum_name.forum_cons_cats)#" index="y">
																	<cfoutput>
																		
																		<cfif i LE 3>
																			#get_consumer_cats.conscat[listfind(cons_cat_list,y)]#
																		
																		</cfif>
																		<cfset i=i+1/>
																	</cfoutput>
																	<!---<cfif listlast(forum_cons_cats,',') neq y>,</cfif>--->
																</cfloop>
													</cfif>			
												</span>
											</h6>
										</div>
									</div>
									<div class="col col-6 col-xs-12 pdn-l-0 pdn-r-0">
										<ul class="wrk_mod_list">
											<cfif len(get_forum_name.admin_pos)>
												<cfloop list="#listdeleteduplicates(get_forum_name.admin_pos)#" index="x">
													<cfif len(get_emp.employee_id[listfind(employees_list,x)])>
														<a href="javascript://" onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(employees_list,x)]#'});">
														<li class="wrk_mod">
															<cfif len(trim(get_emp.photo[listfind(employees_list,x)])) and FileExists("#upload_folder#/hr/#get_emp.photo[listfind(employees_list,x)]#")>
																<cfset resim = "./documents/hr/"&get_emp.photo[listfind(employees_list,x)]>
																<img src="#resim#" class="img-fluid wrk_user_img hidden-md-down" alt="emp"/>
															<cfelse>
																<span class="avatextCt forumusers color-#Left(get_emp.employee_name[listfind(employees_list,x)], 1)#"><small class="avatext forumusers">#Left(get_emp.employee_name[listfind(employees_list,x)], 1)##Left(get_emp.employee_surname[listfind(employees_list,x)], 1)#</small></span>
															</cfif>		
															<label class="wrk_mod_Label">#get_emp.employee_name[listfind(employees_list,x)]# #get_emp.employee_surname[listfind(employees_list,x)]#</label>
														</li>
														</a>
													</cfif>
												</cfloop>
											</cfif>	
											<cfif len(get_forum_name.admin_pars)>
												<cfloop list="#listdeleteduplicates(get_forum_name.admin_pars)#" index="a">
													<cfif len(get_partner.partner_id[listfind(partner_list,a)])>
														<li class="wrk_mod">
															<cfif len(trim(get_partner.photo[listfind(partner_list,x)])) and FileExists("#upload_folder#/hr/#get_partner.photo[listfind(partner_list,x)]#")>
																<cfset resim = "./documents/hr/"&get_partner.photo[listfind(partner_list,x)]>
																<img src="../images/male.jpg" class="img-fluid wrk_user_img hidden-md-down" alt="partner"/>
															<cfelse>
																<span class="avatextCt forumusers color-#Left(get_partner.company_partner_name[listfind(partner_list,a)], 1)#"><small class="avatext forumusers">#Left(get_partner.company_partner_name[listfind(partner_list,a)], 1)##Left(get_partner.company_partner_surname[listfind(partner_list,a)], 1)#</small></span>
															</cfif>
															<a href="javascript://" onclick="nModal(head:'Profil', page: '#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.partner_id[listfind(partner_list,a)]#'});" class="wrk_user_name mobil_text">
																<label class="wrk_mod_Label">#get_partner.company_partner_name[listfind(partner_list,a)]# #get_partner.company_partner_surname[listfind(partner_list,a)]#</label>
															</a>
														</li>
													</cfif>
												</cfloop>
											</cfif>	
											<cfif len(get_forum_name.admin_cons)>
												<cfloop list="#listdeleteduplicates(get_forum_name.admin_cons)#" index="b">
												<cfif len(get_consumer.consumer_id[listfind(consumer_list,b)]) and FileExists("#upload_folder#/hr/#get_consumer.picture[listfind(consumer_list,b)]#")>
													<li class="wrk_mod">
														<cfif len(trim(get_consumer.picture[listfind(consumer_list,b)]))>
															<cfset resim = "./documents/hr/"&get_consumer.picture[listfind(consumer_list,b)]>
															<img src="#resim#" class="img-fluid wrk_user_img hidden-md-down" alt="consumer"/>
														<cfelse>
															<span class="avatextCt forumusers color-#Left(get_consumer.consumer_name[listfind(consumer_list,b)], 1)#"><small class="avatext forumusers">#Left(get_consumer.consumer_name[listfind(consumer_list,b)], 1)##Left(get_consumer.consumer_surname[listfind(consumer_list,b)], 1)#</small></span>
														</cfif>
														<a href="javascript://"  onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&con_id=#get_consumer.consumer_id[listfind(consumer_list,b)]#'});" class="wrk_user_name mobil_text">
															<label class="wrk_mod_Label">#get_consumer.consumer_name[listfind(consumer_list,b)]# #get_consumer.consumer_surname[listfind(consumer_list,b)]#</label>
														</a>
													</li>
													</cfif>
												</cfloop>
											</cfif>	
										</ul>
									</div>
									
								</div>
							</div>
						</cfoutput>
						
					</div>		
					<!--- forum info --->	
					<!--  Forum Topic   -->			
					<div class="forum_all_topic col col-12">
							<cfif topics.recordcount>
							<cfoutput query="topics" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
								
								<div class="forum_topic col col-12">
									<div class="col col-12 user_panel pdn-l-0 pdn-r-0">
										<cfset get_user_info = userinfo.get_user_info(userkey:topics.USERKEY)>
										<div class="col col-6 col-xs-12 user_info pdn-l-0">
										<cfif len(get_user_info.photo) and FileExists("#upload_folder#/hr/#get_user_info.photo#")>
											<img src="./documents/hr/#get_user_info.photo#" width="80" class="img-fluid wrk_user_img " alt="Person"/>
										<cfelse>	
											<span class="avatextCt forumuserss color-#Left(get_user_info.name, 1)#"><small class="avatext forumuserss">#Left(get_user_info.name, 1)##Left(get_user_info.surname, 1)#</small></span>
										</cfif>
											<a href="javascript://"  
												<cfif listfirst(topics.USERKEY,"-") is "e">
													onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(topics.USERKEY,"-")#'});"
												<cfelseif listfirst(topics.USERKEY,"-") is "p">
													onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(topics.USERKEY,"-")#'});"
												<cfelseif listfirst(topics.USERKEY,"-") is "c">
													onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(topics.USERKEY,"-")#'});"
												</cfif>
											>				
												<span class="last_answer_value">
												#get_user_info.name# #get_user_info.surname#
												</span>
											</a>
											- 
											<span>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</span>
										</div>	
										<div class="col col-6 col-xs-12 closeTopic pdn-r-0 flt-r txt-r">
											<cfif locked eq 1 or TOPIC_STATUS eq 0 or get_forum_name.STATUS eq 0>
												<span><i class="fa fa-lock"></i><cf_get_lang no='57.Kapalı Konu'></p>
											</cfif>
										</div>
										
									</div>
									
									<div class="col col-12 topic_panel pdn-r-0">
										<p>#topics.topic#</p>
										<cfif len(topics.FORUM_TOPIC_FILE)>
											<div class="downloadForumFile"><cfif len(topics.FORUM_TOPIC_REAL_FILE)><cfoutput>#topics.FORUM_TOPIC_REAL_FILE#</cfoutput><cfelse><cfoutput>#topics.FORUM_TOPIC_FILE#</cfoutput></cfif><cf_get_server_file output_file="forum#dir_seperator##topics.FORUM_TOPIC_FILE#" output_server="#topics.FORUM_TOPIC_FILE_SERVER_ID#" output_type="6" image_link="1"></div>
										</cfif>
									</div>

									<div class="col col-12 topic_info last_message pdn-r-0">			
										<div class="col col-2 col-xs-12 pdn-l-0 message_row">
											<i class="fa fa-commenting-o"></i>
											<span class="last_answer">#getLang("main",1242)#:</span>
											<span class="last_answer_value"><b>#reply_count#</b></span>
										</div>	
										<div class="col col-3 col-xs-12 pdn-l-0 message_row">
											<i class="fa fa-clock-o"></i>
											<span class="last_answer">#getLang("forum",40)#:</span>
											<span class="last_answer_value">
												<cfif len(last_reply_date)>
													<b>#dateformat(date_add('h',session.ep.time_zone,last_reply_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,last_reply_date),timeformat_style)#</b>											
												<cfelse>
													<i class="sadicon"></i>
												</cfif>
											</span>
										</div>
										<cfif is_update_ eq 1 or record_emp eq session.ep.userid>
										<div class="col col-1 col-xs-12 pdn-l-0 message_row">
											<a href="#request.self#?fuseaction=forum.form_upd_topic&topicid=#topicid#">
											<i class="fa fa-pencil"></i>
											<span class="last_answer_value">#getLang("main",52)#</span>
											</a>
										</div>
										</cfif>
										<cfif locked neq 1 and TOPIC_STATUS neq 0 and get_forum_name.STATUS neq 0>
										<div class="col col-3 col-xs-12 pdn-l0 message_row">
											<a href="javacsript://" onclick="$.showArea('reply_panel_#topics.topicid#');">
												<i class="fa fa-mail-reply"></i>
												<span class="last_answer_value"><cf_get_lang dictionary_id='53635'></span>
											</a>
										</div>
										</cfif>
									</div>
									<div class="col col-12" id="reply_panel_#topics.topicid#" style="display:none;">
										<cfif locked eq 0>
											<cfform name="add_reply" id="add_reply" method="post" class="post-form" enctype="multipart/form-data" action="#request.self#/index.cfm?fuseaction=forum.emptypopup_add_reply">
												<input type="hidden" name="first_hie" id="first_hie" value="">
												<input type="hidden" name="forumid" value="#FORUMID#">
												<input type="hidden" name="topicid" value="#TOPICID#">
												<div class="col col-12 topic_add_message pdn-l-0">
													<div class="form-group">
														<cfmodule
															template="/fckeditor/fckeditor.cfm"
															toolbarSet="WRKContent"
															basePath="/fckeditor/"
															instanceName="reply_#topics.topicid#"
															valign="top"
															value=""
															width="650"
															height="150">
													</div>
												</div>
												<div class="col col-12 pdn-l-0">
													<div class="col col-3 col-xs-12 pdn-r-0 txt-r flt-r">
														<div class="col col-8 flt-l forum_button_message" id="reply_result"></div>
														<div class="col col-4 pdn-r-0 flt-r forum_button">
															<input type="submit" value="#getLang('assetcare',526)#">
														</div>
													</div>
												</div>
											</cfform>
										</cfif>
									</div>
									<cfset HIERARCHY = "">
									<cfset REPLIES = replyCFC.select(topicid:topics.topicid,startrow:1,maxrows:4)><!--- maks. 4 kayıt listele --->
									<cfif REPLIES.recordcount>
										<cfset HIERARCHY = REPLIES.HIERARCHY>
										<div class="col col-12 topic_messages last_message" id="topic_messages_#topics.topicid#">
											<cfloop query="#REPLIES#">
												<cfset get_user_info = userinfo.get_user_info(userkey:REPLIES.userkey)>
												<cfif len(get_user_info.photo) and FileExists("./documents/hr/#get_user_info.photo#")>
													<cfset resimurl = "./documents/hr/#get_user_info.photo#">
												<cfelse>
													<cfset resimurl = "../images/male.jpg">
												</cfif>
												<div class="topic_message col col-12 pdn-l-0">
													<div class="col col-1 col-xs-2 user_photo pdn-l-0">
														<img src="#resimurl#" width="30" class="img-fluid wrk_user_img " alt="Person"/>
													</div>
													<div class="col col-11 col-xs-10 user_message pdn-l-0 ">
														<div class="col col-12 user_info">
															<div class="col col-2 col-xs-12 message_row pdn-l-0">
															<a href="javascript://"  
																<cfif listfirst(REPLIES.userkey,"-") is "e">
																	onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(REPLIES.userkey,"-")#'});"
																<cfelseif listfirst(REPLIES.userkey,"-") is "p">
																	onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(REPLIES.userkey,"-")#'});"
																<cfelseif listfirst(REPLIES.userkey,"-") is "c">
																	onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(REPLIES.userkey,"-")#'});"
																</cfif>
															>				
																<span class="last_answer_value">
																#get_user_info.name# #get_user_info.surname#
																</span>
															</a>
																<span class="">- #dateformat(date_add('h',session.ep.time_zone,REPLIES.UPDATE_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,REPLIES.UPDATE_DATE),timeformat_style)#</span>
															</div>
														
															<cfif REPLIES.record_emp eq session.ep.userid>
																<div class="col col-6 col-xs-12 pdn-l-0 message_row">
																	<a href="#request.self#?fuseaction=forum.form_upd_reply&forumid=#attributes.forumid#&topicid=#topics.topicid#&replyid=#REPLIES.replyid#">
																	<i class="fa fa-pencil"></i>
																	<span class="last_answer_value">#getLang("main",52)#</span>
																	</a>
																</div>
															</cfif>
														
														</div>
														<div class="col col-12 message_content">
															#REPLIES.REPLY#
														</div>
													</div>
												</div>
											</cfloop>
											<cfif REPLIES.QUERY_COUNT gt 4>
											<div class="col col-12 pdn-l-0 more_data_parent">
												<div class="col col-11 offset-1 more_data" id="more_data">
													<a href="javascript://" onclick="$.moreData(#topics.topicid#,5)"><cf_get_lang dictionary_id="48384.Daha fazla göster"></a>
												</div>
											</div>	
											</cfif>
										</div>
									</cfif>
								</div>
							</cfoutput>		
							</cfif>
					<!--  Forum Topic -->			
				</div>
			</div>		
		</div>	
	<div>
</section> --->

<script>
	///Bu alan, forum master a aktarıldıktan sonra intranet.js dosyasına openArea fonksiyon adıyla taşınacak.
	$(function(){
		
		var AjaxRequest = function(url,data,loadingArea,loadingMessage){
			var answer = null;
			if(loadingArea != ''){
				$("#"+loadingArea+"").html('<div id="divPageLoad"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></div>');
			}
			$.ajax({
				async: false,//true
				type: "POST",
				enctype: 'multipart/form-data',
				url: url,
				data: data,
				dataType: "JSON",
				processData: false,
				cache: false,
				timeout: 600000,
				success: function (response) {
					answer = response;
					$("#"+loadingArea+"").html("");
					if(loadingMessage != ''){
						$("#"+loadingMessage+"").html("");
					}
				},
				error: function (e) {

				}
			});

			return answer;

		}
		
		$.showArea = function(divid){
			$("#"+divid+"").slideToggle();
		}

        $("#forum_share_button").click(function (event) {

			var topicValue = decodeURIComponent(CKEDITOR.instances['topic'].getData());
			$("textarea[name=topic]").val(topicValue);

			if($.trim(topicValue) != ''){
				event.preventDefault();
				var formElement = $('form[name = add_topic]');
				var form = formElement[0];
				var url = formElement.attr("action") + "&isAjax=1";
				$("#forum_button_message").html('<div id="divPageLoad"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></div>');
				
				var data = new FormData(form);

				$(this).prop("disabled", true);

				$.ajax({
					type: "POST",
					enctype: 'multipart/form-data',
					url: url,
					data: data,
					dataType: "JSON",
					processData: false,
					contentType: false,
					cache: false,
					timeout: 600000,
					success: function (response) {
						$(this).prop("disabled", false);
						$("#forum_button_message").text(response.MESSAGE);
						if(response.STATUS){
							location.reload();
						}
					},
					error: function (e) {

						$("#forum_button_message").text(e.responseText);
						$(this).prop("disabled", false);

					}
				});
			
			}else{
				alert("<cf_get_lang dictionary_id='33337'>");
			}
            
			return false;
        });
		
		///Bu alan, forum master a aktarıldıktan sonra intranet.js dosyasına aktarılacak
		var fileInput  = document.querySelector( ".input-file" ),  
			button     = document.querySelector( ".file-button-upload" ),
			the_return = document.querySelector(".file-return");
			
		button.addEventListener( "keydown", function( event ) {  
			if ( event.keyCode == 13 || event.keyCode == 32 ) {  
				fileInput.focus();  
			}  
		});
		button.addEventListener( "click", function( event ) {
			fileInput.focus();
			return false;
		});  
		fileInput.addEventListener( "change", function( event ) {  
			the_return.innerHTML = this.value;  
		});

		$(".send_btn").attr('disabled',true); 
		$(".send_btn").css('background-color','#b3d0a6'); 

		$("form.post-form").submit(function(){
			
			var url = $(this).attr("action") + "&isAjax=1";
			var textarea = $(this).find("textarea");
			var ckValue = decodeURIComponent(CKEDITOR.instances[textarea.attr("name")].getData());
			textarea.val(ckValue);
			console.log(ckValue);
			var data = $(this).serialize();
			
			if($.trim(textarea.val()) != ''){
				$(this).find("input[type=submit]").val("<cf_get_lang dictionary_id='57705'>").prop("disabled",true);
				var response = AjaxRequest(url,data,"reply_result","reply_result");
				if(response.STATUS){
					
					location.reload();
					//var data = AjaxRequest(url,data);

				}else alert(response.MESSAGE);
			}else{
				alert("<cfoutput>#getLang('forum',45)#</cfoutput>");
			}

			return false;

		});
		/*JSON veriyi html giydirir - Daha Fazla Göster(5)*/
		function dataList(topicid,responseData,responseCount){
			if(responseCount > 0){
				for(var i = 1; i <= responseCount; i++){
					$("<div>").addClass("topic_message flex-row").append(
						$("<div>").addClass("forum_item_avatar").append(
							((responseData[i].USERINFO.PHOTO.includes("documents/hr")) ? $("<img>").attr({"src":responseData[i].USERINFO.PHOTO,"alt":"Person"}).addClass("img-fluid wrk_user_img ") : $("<i>").text(responseData[i].USERINFO.PHOTO))													
						),
						$("<div>").addClass("forum_item_message").append(
							$("<div>").addClass("forum_item_message_title").append(
								$("<h3>").text(responseData[i].USERINFO.NAME + " " + responseData[i].USERINFO.SURNAME).append(
									$("<span>").addClass("last_answer_value").text(responseData[i].REPLYDATE + " - ").append(
										$("<a>").attr({"href":"<cfoutput>#request.self#?fuseaction=forum.form_upd_reply&forumid=#attributes.forumid#&topicid="+topicid+"&replyid="+responseData[i].REPLYID+"</cfoutput>"}).text('<cfoutput>#getLang("main",52)#</cfoutput>'),
									),
								),
							),
							$("<div>").addClass("forum_item_message_content").append(
								$("<p>").html(responseData[i].REPLY)
							),
						)
					)
					.appendTo("#topic_messages_" + topicid);
				}
			}
		}

		$.moreData = function(topicid,startrow){
			var url = "V16/forum/query/get_replies.cfm";
			data = "forumid=" + "<cfoutput>#attributes.forumid#</cfoutput>" + "&topicid=" + topicid + "&startrow=" + startrow;
			var response = AjaxRequest(url,data,"more_data");

			if(response.STATUS){
				dataList(topicid,response.DATA,response.COUNT);
				$("#topic_messages_" + topicid + " .more_data_parent").remove();
				$("#topic_messages_" + topicid).append('<div class="more_data_parent"><div class="more_data" id="more_data"><a href="javascript://" onclick="$.moreData('+ topicid +','+ (startrow + response.COUNT) +')"><cf_get_lang dictionary_id="48384"></a></div></div>')
			}else{
				alert('<cf_get_lang dictionary_id="55013">');
			}
			return false;
		}

	});


</script>