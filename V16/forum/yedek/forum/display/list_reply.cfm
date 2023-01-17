<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.special_definition" default="">
<cfparam name="attributes.topic_status" default="1">
<cfinclude template="../query/get_head_topic.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_replies.cfm">
<cfinclude template="../query/add_topic_count.cfm">
<cfinclude template="../query/get_email_alert.cfm">

			<cfset employees_list="">
			<cfset cons_cat_list="">
			<cfset comp_cat_list="">
			<cfset partner_list="">
			<cfset consumer_list ="">
			<cfoutput query="head_topic">
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
						COMPANY_PARTNER_SURNAME
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

<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 8
</cfquery>
<cfif session.ep.admin eq 1>
	<cfset is_update_ = 1>
<cfelseif listlen(head_topic.admin_pos) and listfindnocase(head_topic.admin_pos,get_position_id(session.ep.position_code))>
	<cfset is_update_ = 1>
<cfelse>
	<cfset is_update_ = 0>
</cfif>
    <div class="w3-forum">
    <article class="wrk_frm">
        <div class="container">
            <!-- header-->
            <cfinclude template="../query/get_company_name.cfm">
            <div class="row wrk_frm_header mb-4">

                <div class="col-md-1"></div>            
                <div class="col-md-2  d-flex justify-content-center align-items-center">
                    <img src="css\assets\template\w3-forum\images\logo.png" class="img-fluid " alt="Workcube" width="120">
                </div>
                <div class="col-md-9 d-flex justify-content-start align-items-center text-md-left text-center">
                    <h2 class="font-raleway-400 wrk_frm_headBaslik w-100">
                    <a href="?fuseaction=forum.list_forum">
                    <cfoutput>#session.ep.COMPANY_NICK#</cfoutput>
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
													 href="javascript://" class="btn btn-primary wrk-circular-button-add margin-l">
														
													</a>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</cfform>
				 </cfoutput>



                    <cfoutput query="head_topic">
                    	<cfset attributes.userkey = userkey>
                            <cfparam name="attributes.page" default=1>
                            <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
                            <cfparam name="attributes.totalrecords" default='#replies.recordcount#'>
                            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                        <div class="row wrk_frm_section mt-5">
                            <div class="col-lg-8">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="wrk_frm_section_span float-left">B</div>
                                        <div class="d-block wrk_frm_section_content">
                                            
                                            <h4 class="text-gray-light">
                                                Forum: <cfoutput>#head_topic.forumname#</cfoutput>
                                            </h4>
                                            <h4 >#REReplaceNoCase(head_topic.title, '<(.|\n)*?>', '', 'ALL')#</h4>
                                            <p class="wrk_frm_sect_paragraf">
                                                    #head_topic.topic# 
                                            </p>   
                                        
                                            <h6 class="font-raleway-400 text-gray-light wrk_frm_sect_tag">
                                                <span class="text-brand-warning font-raleway-800"><cfoutput>#getLang("forum",31,"Kimler İçin?")#</cfoutput></span>
                                                <cfif head_topic.forum_emps eq 1>
                                                    <cf_get_lang_main no='1463.Çalışanlar'>
                                                </cfif>
                                                <cfif len(head_topic.forum_comp_cats)>
                                                    <cf_get_lang_main no='1611.Kurumsal Üyeler'>
                                                        <cfset i=1/>
                                                            <cfloop list="#listdeleteduplicates(head_topic.forum_comp_cats)#" index="v">
                                                                <cfoutput>
                                                                    <cfif i LE 3>
                                                                        #get_company_cats.companycat[listfind(comp_cat_list,v)]#
                                                                    </cfif>
                                                                    <cfset i=i+1/>
                                                                </cfoutput>
                                                                <!---<cfif listlast(forum_comp_cats,',') neq v>,</cfif>--->
                                                            </cfloop>
                                                </cfif>
                                                <cfif len(head_topic.forum_cons_cats)>
                                                    <cf_get_lang_main no='1609.Bireysel Üyeler'>
                                                        <cfset i=1/>
                                                            <cfloop list="#listdeleteduplicates(head_topic.forum_cons_cats)#" index="y">
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
                                                <cfif len(head_topic.admin_pos)>
                                                    <cfloop list="#listdeleteduplicates(head_topic.admin_pos)#" index="x">
                                                        <cfoutput>
                                                        <div class="col-lg-4 mdpad ">
															<cfif len(trim(get_emp.photo[listfind(employees_list,x)]))>
																<cfset resim = "./documents/hr/"&get_emp.photo[listfind(employees_list,x)]>
															<cfelse>
																<cfset resim="../images/male.jpg">
															</cfif>	
                                                            <img src="#resim#" class="img-fluid wrk_frm_sect_personimg hidden-md-down"
                                                                 alt="Employees"/>
                                                            <a 	href="javascript://" 
																onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(employees_list,x)]#'});" 
																class="wrk_frm_sect_personname">
																#get_emp.employee_name[listfind(employees_list,x)]# 
																#get_emp.employee_surname[listfind(employees_list,x)]#
															</a>
                                                        </div>
                                                    </cfoutput>
                                                    </cfloop>
                                                </cfif>
                                                <cfif len(head_topic.admin_pars)>
                                                    <cfloop list="#listdeleteduplicates(head_topic.admin_pars)#" index="a">
                                                        <cfoutput>
                                                        <div class="col-lg-4 mdpad ">
															<cfif len(trim(get_partner.photo[listfind(partner_list,a)]))>
																<cfset resim = "./documents/hr/"&get_partner.photo[listfind(partner_list,a)]>
															<cfelse>
																<cfset resim="../images/male.jpg">
															</cfif>
															<img src="#resim#" class="img-fluid wrk_frm_sect_personimg hidden-md-down"
                                                                 alt="Person"/>
                                                            <a href="javascript://" onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.partner_id[listfind(partner_list,a)]#'});" class="wrk_frm_sect_personname">
                                                                #get_partner.company_partner_name[listfind(partner_list,a)]# #get_partner.company_partner_surname[listfind(partner_list,a)]#
                                                            </a>
                                                        </div>
                                                    </cfoutput>
                                                    </cfloop>
                                                </cfif>
                                                <cfif len(head_topic.admin_cons)>
                                                    <cfloop list="#listdeleteduplicates(head_topic.admin_cons)#" index="b">
                                                         <cfoutput>
                                                        <div class="col-lg-4 mdpad ">
														<cfif len(trim(get_consumer.picture[listfind(consumer_list,b)]))>
															<cfset resim = "./documents/hr/"&get_consumer.picture[listfind(consumer_list,b)]>
														<cfelse>
															<cfset resim="../images/male.jpg">
														</cfif>
                                                            <img src="#resim#" class="img-fluid wrk_frm_sect_personimg hidden-md-down"
                                                                 alt="Person"/>
                                                            <a href="javascript://" onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_con_det&con_id=#get_consumer.consumer_id[listfind(consumer_list,b)]#'});" class="wrk_frm_sect_personname">
                                                                #get_consumer.consumer_name[listfind(consumer_list,b)]# #get_consumer.consumer_surname[listfind(consumer_list,b)]#
                                                            </a>
                                                        </div>
                                                    </cfoutput>
                                                    </cfloop>
                                                </cfif>
                                            </div>
                                            <div class="row col-md-12 konu_add_btn mt-3">
                                                <a class="col-md-1 btn-subject-add wrk-circular-button-add d-flex justify-content-center align-items-center hidden-md-down">
                                                </a>
                                                <a href="javascript://" 
                                                onclick="windowopen('index.cfm?fuseaction=<cfoutput>forum.popup_form_add_reply&topicid=#attributes.topicid#</cfoutput>','large')" class="col-md-11 font-raleway-600 d-flex align-items-center mdpad"><cfoutput>#getLang("forum",73,"Son Cevap Ver")#</cfoutput></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        
                            <div class="col-lg-4 col-md-12 wrk_frm_section_sonmesaj  d-flex justify-content-center">
                                <div class="col-lg-10  mdresp float-left">
                                    <div class="row">
                                        <div class="col-md-12 mt-2"><i class="wrk-document-with-folded-corner mr-2"></i><cfoutput>#getLang("forum",19,"Konu/Mesaj")#</cfoutput>
                                            <span class="soncevap font-raleway-600">#topic_count#/#reply_count#</span>
                                        </div>
                                        
                                            <cfif len(last_msg_date)>
                                                <div class="col-md-12 mt-2 hidden-md-down">
                                                    <i class="wrk-alarm-clock mr-2"></i><cfoutput>#getLang("forum",40,"Son Cevap")#</cfoutput>  <span class="soncevap font-raleway-600">#dateformat(date_add('h',session.ep.time_zone,last_msg_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,last_msg_date),timeformat_style)# </span>
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
                                                           onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey," -")#'});">
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
                                                            onclick="nModal({head:'Profil',page :'#request.self#?fuseactionobjects.popup_par_det&par_id=#listlast(attributes.userkey," -")#'});">
                                                               #username.name# #username.surname#
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
                                                            onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(attributes.userkey," -")#'});">
                                                                #username.name# #username.surname#
                                                            </a>
                                                        </div>
                                                        </cfif>
                                            </cfif>
                                        
                                    </div>
                                </div>
                                <div class="col-lg-2 hidden-md-down ">
                                    <cfif (len(admin_pos) and listfindnocase(admin_pos,get_position_id(session.ep.position_code))) or session.ep.admin eq 1 or record_emp eq session.ep.userid>
                                        
                                        <a class="wrk-edit fs-30 text-grayblue guncelle" href="javascript://" 
												onclick="windowopen('index.cfm?fuseaction=forum.popup_form_upd_topic&topicid=#topicid#','large')"
												  title="Güncelle">
										</a>
                                        
                                    </cfif>
                                    <cfif len(head_topic.FORUM_TOPIC_FILE)>
                                            <a class="fs-30 text-grayblue guncelle" href="javascript://" 
                                            onclick="windowopen('#file_web_path#forum/#head_topic.FORUM_TOPIC_FILE#','large')">
                                            <i style="font-size:20px" class="fa fa-paperclip" aria-hidden="true"></i></a>
                                    </cfif> 
                                </div>
                            </div>
                            <div class="col-12">
                                <hr class="  mt-3 gray-lighten-12"/>
                            </div>
                        </div>
                        <cfset tr_topic=topic>
                    </cfoutput>
                    <cfif replies.recordcount>
                        <cfset user_reply_list = ValueList(replies.userkey,',')>
                            <cfif len(user_reply_list)>
                                <cfset user_reply_list = listsort(listdeleteduplicates(user_reply_list),'TEXT','ASC',',')>
                                <cfquery name="USER_REPLY_COUNT" datasource="#DSN#">
                                    SELECT 
                                        COUNT(REPLYID) TOTAL,			
                                        RECORD_EMP
                                    FROM 
                                        FORUM_REPLYS
                                    WHERE 
                                        <cfloop from="1" to="#listlen(user_reply_list,',')#" index="i_"> 
                                            USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(user_reply_list,i_,',')#">
                                            <cfif listlen(user_reply_list,',') neq i_> OR </cfif> 
                                        </cfloop>
                                    GROUP BY 
                                        RECORD_EMP
                                </cfquery>
                                <cfoutput query="user_reply_count">
                                    <cfset 'emp_count#record_emp#' = TOTAL ><!--- userkey string ifade içerdigi için record_emp atandı.20081028MA --->
                                </cfoutput>
                            </cfif>	
                            <cfset ind = 0>
                            <cfset main_reply = 1>
                            <cfoutput query="replies" >
                                <cfset attributes.userkey = userkey>
		                        <cfinclude template="../query/get_username.cfm">
                                <form name="print_form#ind#" >
                                        <cfset cont = reply>
                                        <cfset cont = ReplaceList(cont,'#chr(39)#','')>
                                        <cfset cont = ReplaceList(cont,'#chr(10)#','')>
                                        <cfset cont = ReplaceList(cont,'#chr(13)#','')>
                                        <cfif listlen(hierarchy,'.') eq 1 and currentrow neq 1>
                                            <cfset main_reply = main_reply + 1>
                                        </cfif>  
                                    <div class="row wrk_frm_comments d-flex justify-content-center align-items-center my-3">
                                        <div class="col-md-4 left d-flex justify-content-center align-items-center">
                                                            <cfset resimurl = "../images/male.jpg">
                                                            <cfif listfirst(attributes.userkey,"-") is "e">
                                                            <cfif len(username.name)>    
                                                                <cfscript>
                                                                    if(len(username.photo)){
                                                                        resimurl = "./documents/hr/"&username.photo;
                                                                    }
                                                                </cfscript>
                                                                <div class="col-lg-4 imageperson text-center hidden-md-down">
                                                                    <img src="#resimurl#" class="img-fluid" alt="Person" />
                                                                </div>

                                                                <div class="col-lg-8 infoperson">
                                                                    <div class="per_info ">
                                                                        <a href="javascript://" class="wrk_frm_sect_personname"
                                                                            onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#'});">
                                                                            #username.name# #username.surname#
                                                                        </a>
                                                                    </div>
                                                            </cfif>
                                                            <cfelseif listfirst(attributes.userkey,"-") is "p">
                                                                <cfif len(username.name)>
                                                                <cfscript>
                                                                    if(len(username.photo)){
                                                                        resimurl = "./documents/hr/"&username.photo;
                                                                    }
                                                                </cfscript>
                                                                    
                                                                <div class="col-lg-4 imageperson text-center hidden-md-down">
                                                                    <img src="#resimurl#" class="img-fluid " alt="Person" />
                                                                </div>

                                                                <div class="col-lg-8 infoperson">
                                                                    <div class="per_info ">        
                                                                        <a href="javascript://" class="wrk_frm_sect_personname"
                                                                            onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_con_det&con_id=#listlast(attributes.userkey,"-")#'});">
                                                                            #username.name# #username.surname#
                                                                        </a>
                                                                    </div>
                                                            </cfif>    
                                                            <cfelseif listfirst(attributes.userkey,"-") is "c">
                                                                <cfif len(username.name)>
                                                                <cfscript>
                                                                    if(len(username.picture)){
                                                                        resimurl = "./documents/hr/"&username.picture;
                                                                    }
                                                                </cfscript>

                                                                <div class="col-lg-4 imageperson text-center hidden-md-down">
                                                                    <img src="#resimurl#" class="img-fluid " alt="Person" />
                                                                </div>
                                                                
                                                                
                                                                <div class="col-lg-8 infoperson">
                                                                    <div class="per_info ">
                                                                        <a  href="javascript://" class="wrk_frm_sect_personname"
                                                                            onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#'});">
                                                                            #username.name# #username.surname#
                                                                        </a>
                                                                    </div>
                                                                </cfif>
                                                            </cfif>
                                                
                                                <div class="per_tar">
                                                    <span><i class="wrk-clock mr-1"></i>
                                                    #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#
                                
                                                    </span>
                                                </div>
                                                </div>
                                           
                                        </div>
                                        <div class="col-md-8 right">
                                            <div class="comment_text">
                                                <p>
                                                    #reply#
                                                </p>
                                            </div>
                                            <div class="comments_icon">
                                                <ul>
                                                    <cfif is_update_ eq 1 or record_emp eq session.ep.userid>
                                                    <li>         
                                                        <a href="javascript://" onclick="windowopen('index.cfm?fuseaction=forum.popup_form_upd_reply&replyid=#replyid#&topicid=#topicid#','large')" title="<cf_get_lang no='60.Cevap Düzenle'>" class="wrk-edit"></a>
                                                    </li>
                                                    </cfif>
                                                    <li>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&editor_name=print_form#ind#.forum_Message&editor_header=print_form#ind#.forum_Subject&editor_From=print_form#ind#.forum_From&email=#username.email#','list');"  title="<cf_get_lang_main no='63.Mail Gönder'>" class="wrk-envelope-2"></a>
                                                    </li>
                                                    
                                                    <cfif head_topic.locked neq 1>
                                                        <li><a href="javascript://" 
                                                        onclick="windowopen('index.cfm?fuseaction=<cfoutput>forum.popup_form_add_reply&topicid=#attributes.topicid#</cfoutput>','large')"
                                                        title="<cf_get_lang_main no='1242.Cevap Ver'>" class="wrk-speech-bubble"></a></li>
                                                    </cfif>

                                                    <!--<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_editor&editor_name=print_form#ind#.forum_Reply&editor_header=print_form#ind#.forum_Date&editor_Forum=print_form#ind#.forum_Forum&title1=Tarih&title2=','list');"><img src="/images/messenger3.gif" title="<cf_get_lang_main no='62.Yazdır'>"></a>-->
                                                   
                                                   <!-- SHARE BUTONU-LİNK OLMADIĞI İÇİN GİZLENDİ
                                                   <li><a href="##" class="wrk-share"></a></li> 
                                                   -->
                                                    <cfif len(forum_reply_file)>
                                                     <li> 
                                                     <!-- güncellenecek svg icon bu linkte http://betacatalyst/index.cfm?fuseaction=forum.view_reply&topicid=1 -->   
                                                     <a href="javascript://"  onclick="windowopen('#file_web_path#forum/#forum_reply_file#','large')"><i style="font-size:18px" class="fa fa-paperclip" aria-hidden="true"></i></a></li>
                                                    </cfif> 

                                                </ul>
                                            
                                                                                              

                                            </div>
                                        </div>                                    
                                        <div class="col-md-12 mt-3">
                                            <hr class="gray-lighten-12" />
                                        </div>
                                    </div>
                                </form>   
                            </cfoutput>

                    <cfelse>
                       <div class="row">
                            <div class="col col-12">
                                Kayıt Bulunamadı
                            </div>
                        </div>
                    </cfif>
                </div>
            </div>
        </div>   
        </div>
        </div>
    </article>
</div>