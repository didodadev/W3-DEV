<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.topic_status" default="1">
<cfinclude template="../query/get_topics.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_forum_name.cfm">
<cfif session.ep.admin eq 1>
	<cfset is_update_ = 1>
<cfelseif listlen(GET_FORUM_NAME.ADMIN_POS) and listfindnocase(GET_FORUM_NAME.ADMIN_POS,get_position_id(session.ep.position_code))>
	<cfset is_update_ = 1>
<cfelse>
	<cfset is_update_ = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#topics.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- <img src="css\assets\template\w3-forum\images\logo.png" class="img-fluid " alt="Workcube" width="120"> -->
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

<div class="w3-forum">
    <article class="wrk_frm">
        <div class="container ">
            <div class="row wrk_frm_header mb-4">
			<div class="col-md-1"></div>
                <div class="col-md-2  d-flex justify-content-center align-items-center">
                    <img src="css\assets\template\w3-forum\images\logo.png" class="img-fluid " alt="Workcube" width="120">
                </div>
                <div class="col-md-9 d-flex justify-content-start align-items-center text-md-left text-center">
                    <h2 class="font-raleway-400 wrk_frm_headBaslik w-100">
					<a href="?fuseaction=forum.list_forum">
                    <cfoutput>#session.ep.company_nick#</cfoutput>
                    </a>
					 <span class="font-raleway-800 ">Forum</span></h2>
                </div>
            </div>
            <div class="row">
                <div class="col-md-1 hidden-md-down"></div>
                <div class="col-md-11 col-12">
                	<cfoutput>
						<cfform method="post" action="#request.self#?fuseaction=forum.search">
							<div class="wrk_frm_filtre mt-0">
								<div class="col-12 col-lg-9 col-md-12 wrk_forum_left">
									<div class="row wrk_forum_search">
										<div class="col-md-3 wrk_forum_search_item p-1">
											<div class="form m-0 w-100">
												<input name="keyword" id="keyword" class="form-control w-100" type="search" value="#attributes.keyword#" placeholder="<cfoutput>#getLang("forum",17,"Ne Aramıştınız?")#</cfoutput>">
											</div>
										</div>
										<div class="col-md-3 wrk_forum_search_item wrk_forum_combosearch p-1">
											<select class="custom-select  w-100"  name="forumid" id="forumid">
												<option selected value="0"><cfoutput>#getLang("invoice",278,"Seçim Yapınız")#</cfoutput></option>
												<cfloop query="forums">
													<option value="#forumid#" >#forumname#</option>
												</cfloop>
											</select>
										</div>
										<div class="col-md-2 wrk_forum_search_item wrk_forum_connumber p-1">
											<select class="custom-select  w-100" name="topic_status" id="topic_status">
												<option value="" <cfif attributes.topic_status eq 2>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
												<option value="1" <cfif attributes.topic_status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
												<option value="0" <cfif attributes.topic_status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>	                        
											</select>
										</div>

										<div class="col-md-2 wrk_forum_search_item wrk_forum_connumber p-1">
											<select class="custom-select w-100" name="tarih" id="tarih">
												<option value="1" <cfif isDefined('attributes.tarih') and attributes.tarih eq 1>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
												<option value="2" <cfif isDefined('attributes.tarih') and attributes.tarih eq 2>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
											</select>
										</div>
										<div class="col-md-2 wrk_forum_search_item">
											<div class="row">
												<div class="col-md-6 wrk_forum_search_item p-1">
													<button type="submit" class="btn btn-primary">
												<span class="wrk-search"></span>
											</button>
												</div>
												<div class="col-md-6 wrk_forum_search_item p-1">
													<a name="wrk_search_button"
													  onclick="windowopen('index.cfm?fuseaction=forum.popup_form_add_forum','large')"
													 href="javascript://" class="btn btn-primary wrk-circular-button-add">
														
													</a>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</cfform>
					</cfoutput> 
                    <!-- Forum Bilgileri -->
                    <div class="row wrk_frm_section mt-5">
                        <div class="col-lg-8">
                            <div class="row">
                                <div class="col-md-12">
									<cfset forumNameFirtChar = UCase(left(get_forum_name.forumname,1))> 
                                    <div class="wrk_frm_section_span float-left"><cfoutput>#forumNameFirtChar#</cfoutput></div>
                                    <div class="d-block wrk_frm_section_content">
                                        <h4>
                                            <cfoutput>#get_forum_name.forumname#</cfoutput>
                                        </h4>
                                        <p class="wrk_frm_sect_paragraf">
                                            <cfoutput>#get_forum_name.description#</cfoutput>
                                        </p>
                                        <h6 class="font-raleway-400 text-gray-light wrk_frm_sect_tag">
                                            <span class="text-brand-warning font-raleway-800"><cfoutput>#getLang("forum",31,"Kimler İçin?")#</cfoutput></span>
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
                                        </h6>
                                        <div class="row col-md-12 mt-3">
                                            <cfif len(get_forum_name.admin_pos)>
                                                <cfloop list="#listdeleteduplicates(get_forum_name.admin_pos)#" index="x">
                                                    <cfoutput>
                                                        <div class="col-lg-4 mdpad ">
														<cfif len(get_emp.employee_id[listfind(employees_list,x)])>
																<cfif len(trim(get_emp.photo[listfind(employees_list,x)]))>
																	<cfset resim = "./documents/hr/"&get_emp.photo[listfind(employees_list,x)]>
																<cfelse>
																	<cfset resim="../images/male.jpg">
																</cfif>	
																<img src="#resim#" class="img-fluid wrk_frm_sect_personimg hidden-md-down"
																	alt="Employees"/>
																<a 	href="javascript://" 
																	onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(employees_list,x)]#'});" 
																	class="wrk_frm_sect_personname">
																	#get_emp.employee_name[listfind(employees_list,x)]# 
																	#get_emp.employee_surname[listfind(employees_list,x)]#
																</a>
															</cfif>
                                                        </div>
                                                    </cfoutput>
                                                </cfloop>
                                            </cfif>
                                            <cfif len(get_forum_name.admin_pars)>
                                                <cfloop list="#listdeleteduplicates(get_forum_name.admin_pars)#" index="a">
                                                    <cfoutput>
                                                        <div class="col-lg-4 mdpad ">
														<cfif len(get_partner.partner_id[listfind(partner_list,a)])>
															<cfif len(trim(get_partner.photo[listfind(partner_list,a)]))>
																<cfset resim = "./documents/hr/"&get_partner.photo[listfind(partner_list,a)]>
															<cfelse>
																<cfset resim="../images/male.jpg">
															</cfif>
															<img src="#resim#" class="img-fluid wrk_frm_sect_personimg hidden-md-down"
                                                                 alt="Person"/>
                                                            <a href="javascript://" onclick="windowopen({head:'Profil',page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.partner_id[listfind(partner_list,a)]#'});" class="wrk_frm_sect_personname">
                                                                #get_partner.company_partner_name[listfind(partner_list,a)]# #get_partner.company_partner_surname[listfind(partner_list,a)]#
                                                            </a>
														</cfif>
                                                        </div>
                                                    </cfoutput>
                                                </cfloop>
                                            </cfif>
                                            <cfif len(get_forum_name.admin_cons)>
                                                <cfloop list="#listdeleteduplicates(get_forum_name.admin_cons)#" index="b">
                                                    <cfoutput>
                                                        <div class="col-lg-4 mdpad ">
														<cfif len(get_consumer.consumer_id[listfind(consumer_list,b)])>
															<cfif len(trim(get_consumer.picture[listfind(consumer_list,b)]))>
																<cfset resim = "./documents/hr/"&get_consumer.picture[listfind(consumer_list,b)]>
															<cfelse>
																<cfset resim="../images/male.jpg">
															</cfif>
																<img src="#resim#" class="img-fluid wrk_frm_sect_personimg hidden-md-down"
																	alt="Person"/>
																<a href="javascript://" onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&con_id=#get_consumer.consumer_id[listfind(consumer_list,b)]#'});" class="wrk_frm_sect_personname">
																	#get_consumer.consumer_name[listfind(consumer_list,b)]# #get_consumer.consumer_surname[listfind(consumer_list,b)]#
																</a>
														</cfif>
                                                        </div>
                                                    </cfoutput>
                                                </cfloop>
                                            </cfif>
                                        </div>
                                        <div class="row col-md-12 konu_add_btn mt-3">
                                            <a class="col-md-1 btn-subject-add wrk-circular-button-add d-flex justify-content-center align-items-center hidden-md-down">
                                            </a>										
                                            <a href="javascript://" onclick="windowopen('index.cfm?fuseaction=<cfoutput>forum.popup_form_add_topic&forumid=#attributes.forumid#</cfoutput>','large')" class="col-md-11 font-raleway-600 d-flex align-items-center mdpad"><cfoutput>#getLang("forum",23,"Konu Açmak İçin Tıklayınız")#</cfoutput></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <cfoutput query="get_forum_name">
                        <div class="col-lg-4 col-md-12 wrk_frm_section_sonmesaj  d-flex justify-content-center">
                            <div class="col-lg-10  mdresp float-left">
                                <div class="row">
                                    <div class="col-md-12 mt-2"><i class="wrk-document-with-folded-corner mr-2"></i><cfoutput>#getLang("forum",19,"Konu/Mesaj")#</cfoutput>
                                        <span class="soncevap font-raleway-600"><cfoutput>#get_forum_name.topic_count#/#get_forum_name.reply_count#</cfoutput></span>
                                    </div>
                                    
                                        <cfif len(last_msg_date)>
                                            <div class="col-md-12 mt-2 hidden-md-down">
                                                <i class="wrk-alarm-clock mr-2"></i><cfoutput>#getLang("forum",40,"Son Cevap")#</cfoutput> <span class="soncevap font-raleway-600">#dateformat(date_add('h',session.ep.time_zone,last_msg_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,last_msg_date),timeformat_style)# </span>
                                            </div>
                                        </cfif>
                                        <cfif len(last_msg_userkey)>
                                            <cfset attributes.userkey=last_msg_userkey>
                                                <cfinclude template="../query/get_username.cfm">
												<cfset resimurl = "../images/male.jpg">
                                                    <cfif listfirst(attributes.userkey,"-") is "e">
                                                    <div class="col-md-12 mt-2 hidden-md-down">
													<cfscript>
														if(len(username.photo)){
															resimurl = "./documents/hr/"&username.photo;
														}
													</cfscript>
                                                        <img src="#resimurl#" width="80"
                                                             class="img-fluid wrk_frm_sect_personimg" alt="Person"/>
                                                        <a href="javascript://"
                                                           onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey," -")#'});">
                                                            #username.name# #username.surname#
                                                        </a>
                                                    </div>              
                                                    <cfelseif listfirst(attributes.userkey,"-") is "p">                                                    
                                                    <div class="col-md-12 mt-2 hidden-md-down">
														<cfscript>
															if(len(username.photo)){
																resimurl = "./documents/hr/"&username.photo;
															}
														</cfscript>
                                                        <img src="#resimurl#" width="80"
                                                             class="img-fluid wrk_frm_sect_personimg" alt="Person"/>
                                                        <a href="javascript://"
                                                           onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey," -")#'});">                                                                                                         #username.name# #username.surname#
                                                        </a>
                                                    </div>
                                                    <cfelseif listfirst(attributes.userkey,"-") is "c">
                                                    
                                                    <div class="col-md-12 mt-2 hidden-md-down">
														<cfscript>
															if(len(username.picture)){
																resimurl = "./documents/hr/"&username.picture;
															}
														</cfscript>
                                                        <img src="#resimurl#" width="80"
                                                             class="img-fluid wrk_frm_sect_personimg" alt="Person"/>
                                                        <a href="javascript://"
                                                           onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(attributes.userkey," -")#'});">
                                                            #username.name# #username.surname#
                                                        </a>
                                                    </div>
                                        			</cfif>
                                        </cfif>
                                    
                                </div>
                            </div>
                            <div class="col-lg-2 hidden-md-down ">
								<cfif (len(admin_pos) and listfindnocase(admin_pos,get_position_id(session.ep.position_code))) or session.ep.admin eq 1 or record_emp eq session.ep.userid>
									<a class="wrk-edit fs-30 text-grayblue guncelle"
									 onclick="windowopen('index.cfm?fuseaction=forum.popup_form_upd_forum&forumid=#ForumID#','list')"
									 href="javascript://" data-toggle="tooltip"  data-placement="bottom" title="<cf_get_lang_main no='52.Güncelle'>"></a>
								</cfif>
                              
                            </div>
                        </div>
						</cfoutput>
                        <div class="col-12">
                            <hr class="  mt-3 gray-lighten-12"/>
                        </div>
                    </div>
					<!-- /Forum Bilgileri -->
					<!--  Konu alanları   -->	
					<cfif topics.recordcount>
						<cfoutput query="topics" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
							<div class="row wrk_frm_section mt-3">
								<div class="col-lg-8">
									<div class="row">
										<div class="col-md-12">
											<cfset topicNameFirtChar = UCase(left(topics.title,1))>
											<div class="wrk_frm_section_span_konu float-left">#topicNameFirtChar#</div>
											<div class="d-block wrk_frm_section_content">
												<h5>
													<cfif locked eq 1>
														<img src="V16/forum/images/data/icon_folder_locked.gif" title="<cf_get_lang no='57.Kapalı Konu'>">
													</cfif>
														<a href="#request.self#?fuseaction=forum.view_reply&topicid=#topics.topicid#">#mid(title,1,35)#
													<cfif len(title) gt 35> ... </cfif>
														</a>
												</h5>
												<p class="wrk_frm_sect_paragraf">
													#topics.topic#
												</p>
											
												<div class="col-md-12 wrk_sec_per_tar mdpad p-0">
													#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
												</div>
												<div class="row mt-3">
													<cfset imageurl = "./images/male.jpg">
													<div class="col-lg-4">
														
															<cfset attributes.userkey = userkey>
															<cfinclude template="../query/get_username.cfm">
															
															<cfif listfirst(attributes.userkey,"-") is "e">
															<cfif len(username.name)>
																<cfscript>
																	if(len(username.photo)){
																		resimurl = "./documents/hr/"&username.photo;
																	}
																</cfscript>
																<img src="#resimurl#" class="img-fluid wrk_frm_sect_personimg hidden-md-down" alt="Person"/>
																<a  class="wrk_frm_sect_personname" href="javascript://"  
																	onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#'});" >
																	#username.name# #username.surname#
																</a>
															</cfif>
															<cfelseif listfirst(attributes.userkey,"-") is "p">
															<cfif len(username.name)>
																<cfscript>
																	if(len(username.photo)){
																		resimurl = "./documents/hr/"&username.photo;
																	}
																</cfscript>
																<img src="#resimurl#" class="img-fluid wrk_frm_sect_personimg hidden-md-down" alt="Person"/>
																<a  class="wrk_frm_sect_personname" href="javascript://"  
																	onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#'});"  >
																	#username.name# #username.surname#
																</a>
															</cfif>
															<cfelseif listfirst(attributes.userkey,"-") is "c">
															<cfif len(username.name)>
																<cfscript>
																		if(len(username.picture)){
																			resimurl = "./documents/hr/"&username.picture;
																		}
																</cfscript>
																<img src="#resimurl#" class="img-fluid wrk_frm_sect_personimg hidden-md-down" alt="Person"/>
																<a class="wrk_frm_sect_personname" href="javascript://"  
																	onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&con_id=#listlast(attributes.userkey,"-")#'});"  >
																	#username.name# #username.surname#
																</a>
															</cfif>
															</cfif>
													</div>
													<div class="col-lg-4"></div>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="col-lg-4 wrk_frm_section_sonmesaj  d-flex justify-content-center">
									<div class="col-md-10 float-left">
										<div class="row">
											<div class="col-lg-12 col-md-6 col-sm-12 mdresp_topic mt-2"><i class="wrk-blank-squared-bubble mr-2"></i>
												<cf_get_lang_main no='1242.Cevap'>: 
												<span class="soncevap font-raleway-600">
													#reply_count#
												</span>
											</div>
											<div class="col-lg-12 col-md-6 col-sm-12 mdresp_topic mt-2"><i class="wrk-eye mr-2"></i>
												<cf_get_lang no='38.Okuyan'>: 
												<span class="soncevap font-raleway-600">
													#view_count#
												</span>
											</div>
											<div class="col-md-12 mt-2 hidden-md-down"><i class="wrk-alarm-clock mr-2"></i>
												<cf_get_lang no='40.Son Cevap'>:
												<cfinclude template="../query/get_username.cfm">
													<cfif len(last_reply_date)>
														<span class="soncevap font-raleway-600">
															#dateformat(date_add('h',session.ep.time_zone,last_reply_date),dateformat_style)#&nbsp; #timeformat(date_add('h',session.ep.time_zone,last_reply_date),timeformat_style)# 
														</span>											
													<cfelse>
														<cf_get_lang no='41.Cevap Bulunamadı'>
													</cfif>	
												
											</div>
											<div class="col-md-12 topic_per hidden-md-down mt-2">
												<cfif len(last_reply_date)>
														<cfif listfirst(attributes.userkey,"-") is "e">
															<cfif len(username.name)>
															<img src="assets/images/person.png" width="80" class="img-fluid wrk_frm_sect_personimg" alt="Person"/>
															<a href="javascript://"  onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#'});"  >
																#username.name# #username.surname#
															</a>
															</cfif>
														<cfelseif listfirst(attributes.userkey,"-") is "p">
															<cfif len(username.name)>
															<img src="assets/images/person.png" width="80" class="img-fluid wrk_frm_sect_personimg" alt="Person"/>
															<a href="javascript://"  onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#'});"  >
																#username.name# #username.surname#
															</a>
															</cfif>
														<cfelseif listfirst(attributes.userkey,"-") is "c">
															<cfif len(username.name)>
															<img src="assets/images/person.png" width="80" class="img-fluid wrk_frm_sect_personimg" alt="Person"/>
															<a href="javascript://"  onclick="nModal({head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(attributes.userkey,"-")#'});"  >
																#username.name# #username.surname#
															</a>
															</cfif>
														</cfif>

												<cfelse>
														<a href="javascript://"><cf_get_lang no='41.Cevap Bulunamadı'></a>
												</cfif>
											</div>
										</div>
									</div>
									<div class="col-md-2 hidden-md-down">
										<div class="col-12 wrk_frm_section_sonmesaj_dbtn d-flex justify-content-end">

											<cfif is_update_ eq 1 or record_emp eq session.ep.userid>
												
												<a class="wrk-edit fs-30 text-grayblue guncelle" href="javascript://" 
												onclick="windowopen('index.cfm?fuseaction=forum.popup_form_upd_topic&topicid=#topicid#','large')"
												  title="Güncelle">
												</a>
											</cfif>
										</div>
									</div>
								</div>
								<div class="col-md-12">
									<hr class="  mt-3 gray-lighten-12"/>
								</div>
							</div>
						</cfoutput>
					<cfelse>
						<div class="row">
							<div class="col col-12">
								Kayıt Bulunamadı
							</div>
						</div>	
					</cfif>		
					<!--  /Konu alanları -->
                </div>
            </div>
        </div>
    </article>
</div>