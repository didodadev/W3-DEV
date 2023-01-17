<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.topic_status" default="1">
<cfparam name="attributes.tarih" default="1">
<cfinclude template="../query/get_forumlist.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!--
<link href="css\assets\template\w3-forum\style.css"/>
-->
 <link rel="stylesheet" type="text/css" href="css/assets/template/w3-intranet/style.css?57867687686">
<div class="w3-forum">
<article class="wrk_frm">
	<div class="container">
		<!---<div class="row wrk_frm_header mb-4">
			<div class="col-md-2  d-flex justify-content-center align-items-center">
				<img src="css\assets\template\w3-forum\images\logo.png" class="img-fluid " alt="Workcube" width="120">
			</div>
			<div class="col-md-10 d-flex justify-content-start align-items-center text-md-left text-center">
				<h2 class="font-raleway-400 wrk_frm_headBaslik w-100">
					<a href="?fuseaction=forum.list_forum">
						<cfoutput>#session.ep.COMPANY_NICK#</cfoutput>
					</a>
					<span class="font-raleway-800 ">Forum</span></h2>
			</div>
		</div>
		--->
		<div class="w3-intranet">
    		<div class="container-fluid ">
				<cfinclude template="../../rules/display/rule_menu.cfm">
			</div>
		</div>
		<div class="row">
			<div class="col-md-1 hidden-md-down"></div>
			<div class="col-md-11 col-12">
				<!-- Filte BAŞLANGIÇ -->		
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
											<cfloop query="forumlist">
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
											<div class="col-md-6 wrk_forum_search_item wrk_forum_searchbtn p-1">
												<button type="submit" class="btn btn-primary">
											<span class="wrk-search"></span>
										</button>
											</div>
											<div class="col-md-6 wrk_forum_search_item wrk_forum_searchbtn p-1">
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
		</div>
	</div>

	<div class="row wrk_frm_sectBaslik mt-3">
					<div class="col-lg-7 col-12 my-auto font-raleway-800"><cf_get_lang_main no='9.Forum'></div>
					<div class="col-2 m-auto font-raleway-800 text-center hidden-md-down "><cf_get_lang_main no='68.Konu'>/<cf_get_lang_main no='131.Mesaj'></div>
					<div class="col-3 m-auto font-raleway-800 text-center hidden-md-down"><cf_get_lang no='28.Son Mesaj Tarihi'></div>
					<div class="col-12 m-auto font-raleway-800 text-gray">
						<hr class="mt-1 gray-lighten-12"/>
					</div>
	</div>
			<cfif forumlist.recordcount>
			<cfset employees_list="">
			<cfset cons_cat_list="">
			<cfset comp_cat_list="">
			<cfset partner_list="">
			<cfset consumer_list ="">
			<cfoutput query="forumlist">
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
			<cfoutput query="forumlist">
			<div class="row workcube_section mt-2">
				<cfset attributes.forumid = forumid>
				<div class="col-lg-7">
						<cfset forumNameFirstChar= UCase(left(forumName,1))>
						<div class="wrk_letter float-left">#forumNameFirstChar#</div>
						<div class="d-block wrk_content">
							<h4 class="wrk_title"><a href="#request.self#?fuseaction=forum.view_topic&forumid=#Forumid#">#forumName#</a></h4>
							<p class="wrk_desc">#DESCRIPTION#</p>
							<h6 class="font-raleway-400 text-gray-light wrk_who">   
								<span class="mobil_title d-inline-block font-raleway-600 text-brand-warning mr-2"><cf_get_lang no='31.Kimler İçin'></span><span class="mobil_text">
									<cfif forum_emps eq 1>
										<cf_get_lang_main no='1463.Çalışanlar'>
									</cfif>
									<cfif len(forum_comp_cats)>
										<cf_get_lang_main no='1611.Kurumsal Üyeler'> 
										<cfset i=1/>
										<cfloop list="#listdeleteduplicates(forum_comp_cats)#" index="v">
												<cfif i LE 3>
													#get_company_cats.companycat[listfind(comp_cat_list,v)]#
												</cfif>
												<cfset i = i+1/>
												
										<!---<cfif listlast(forum_comp_cats,',') neq v>,</cfif>--->
									</cfloop>
									</cfif>			
									<cfif len(forum_cons_cats)>
										<cf_get_lang_main no='1609.Bireysel Üyeler'>
										<cfset i=1/>
										<cfloop list="#listdeleteduplicates(forum_cons_cats)#" index="y">
												<cfif i LE 3>
													#get_consumer_cats.conscat[listfind(cons_cat_list,y)]#
													
												</cfif>
												<cfset i=i+1/>
												
											<!---<cfif listlast(forum_cons_cats,',') neq y>,</cfif>--->
										</cfloop>
									</cfif>				
								</span>
							</h6>
							<ul class="wrk_mod_list">
							<li class="wrk_mod"><span class="mobil_title">Yöneticiler: </span></li>

							<cfif len(admin_pos)>
							<cfloop list="#listdeleteduplicates(admin_pos)#" index="x">

							<cfif len(get_emp.employee_id[listfind(employees_list,x)])>
							<cfif len(get_emp.employee_name[listfind(employees_list,x)])>
							<li class="wrk_mod">
									<cfif len(trim(get_emp.photo[listfind(employees_list,x)]))>
										<cfset resim = "./documents/hr/"&get_emp.photo[listfind(employees_list,x)]>
									<cfelse>
										<cfset resim="../images/male.jpg">
									</cfif>				
									<img src="#resim#"
										 class="img-fluid wrk_user_img hidden-md-down"
										 alt="emp"/>
									<a href="javascript://" onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(employees_list,x)]#'});" class="wrk_user_name mobil_text">
										#get_emp.employee_name[listfind(employees_list,x)]#
										#get_emp.employee_surname[listfind(employees_list,x)]#
										
									</a>
								</li>
								</cfif>
								</cfif>
								<!---<cfif listlast(admin_pos,',') neq x>,</cfif>--->
							</cfloop>
						</cfif>	
						<cfif len(admin_pars)>
							<cfloop list="#listdeleteduplicates(admin_pars)#" index="a">
								<cfif len(get_partner.partner_id[listfind(partner_list,a)])>
								<cfif len(get_partner.company_partner_name[listfind(partner_list,a)])>
									<cfif len(trim(get_partner.photo[listfind(partner_list,x)]))>
										<cfset resim = "./documents/hr/"&get_partner.photo[listfind(partner_list,x)]>
									<cfelse>
										<cfset resim="../images/male.jpg">
									</cfif>
								
								<li class="wrk_mod">
									<img src="../images/male.jpg"
										 class="img-fluid wrk_user_img hidden-md-down"
										 alt="partner"/>
									<a href="javascript://" onclick="nModal(head:'Profil', page: '#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.partner_id[listfind(partner_list,a)]#'});" class="wrk_user_name mobil_text">
									#get_partner.company_partner_name[listfind(partner_list,a)]# #get_partner.company_partner_surname[listfind(partner_list,a)]#
									</a>
								</li>
								</cfif>
								<!---<cfif listlast(admin_pars,',') neq a>,</cfif>--->
								</cfif>
							</cfloop>
						</cfif>	
						<cfif len(admin_cons)>
							<cfloop list="#listdeleteduplicates(admin_cons)#" index="b">
							<cfif len(get_consumer.consumer_id[listfind(consumer_list,b)])>
							<cfif len(get_consumer.consumer_name[listfind(consumer_list,b)])>
								<li class="wrk_mod">
									<cfif len(trim(get_consumer.picture[listfind(consumer_list,b)]))>
										<cfset resim = "./documents/hr/"&get_consumer.picture[listfind(consumer_list,b)]>
									<cfelse>
										<cfset resim="../images/male.jpg">
									</cfif>
									<img src="#resim#"
										 class="img-fluid wrk_user_img hidden-md-down"
										 alt="consumer"/>
									<a href="javascript://"  onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&con_id=#get_consumer.consumer_id[listfind(consumer_list,b)]#'});" class="wrk_user_name mobil_text">
									#get_consumer.consumer_name[listfind(consumer_list,b)]# #get_consumer.consumer_surname[listfind(consumer_list,b)]#
									</a>
								</li>
								</cfif>
								<!---<cfif listlast(admin_cons,',') neq b>,</cfif>--->
								</cfif>
							</cfloop>
						</cfif>	
							</ul>
						</div>
					</div>
					<div class="col-lg-2 wrk_topic font-raleway-600 ">
						<span class="mobil_title">Konu/Mesaj: </span><span class="mobil_text">#topic_count#/#reply_count#</span>
					</div>
					<div class="col-lg-3 wrk_lastpost d-flex justify-content-center">
						<div class="wrk_section_sonmesaj_text ">	
						<cfif len(last_msg_userkey)>
							<cfset attributes.userkey = last_msg_userkey>
							<cfinclude template="../query/get_username.cfm">
							<cfset resimurl = "../images/male.jpg">
							<cfif listfirst(attributes.userkey,"-") is "e">								
								<div class="float-left hidden-md-down mr-2">
									<cfscript>
										if(len(username.photo)){
											resimurl = "./documents/hr/"&username.photo;
										}
									</cfscript>
									<img src="#resimurl#" width="80" class="img-fluid wrk_user_img " alt="Person"/>
								</div>
									<a href="javascript://"  
									onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#'});">
										<span class="mobil_title">
											Son Gönderen: 
										</span>
										<span class="mobil_text ">
										#username.name# #username.surname#
										</span>
										<br class="hidden-md-down">
									</a>
							<cfelseif listfirst(attributes.userkey,"-") is "p">

								<div class="float-left hidden-md-down mr-2">
									<cfscript>
										if(len(username.photo)){
											resimurl = "./documents/hr/"&username.photo;
										}
									</cfscript>
									<img src="#resimurl#" width="80" class="img-fluid wrk_user_img " alt="Person">
								</div>
									<a href="javascript://"  
										onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#'});">
										<span class="mobil_title">
											Son Gönderen :
										</span>
										<span class="mobil_text">
											#username.name# #username.surname#
										</span>
										<br class="hidden-md-down">
									</a>
							<cfelseif listfirst(attributes.userkey,"-") is "c">

								<div class="float-left hidden-md-down mr-2">
								<cfscript>
										if(len(username.picture)){
											resimurl = "./documents/hr/"&username.picture;
										}
								</cfscript>
									<img src="#resimurl#" width="80" class="img-fluid wrk_user_img " alt="Person">
								</div>
									<a href="javascript://"  
									onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(attributes.userkey,"-")#'});">
									<span class="mobil_title">
										Son Gönderen :
									</span>

									<span class="mobil_text">
										#username.name# #username.surname#
									</span>
									<br class="hidden-md-down"></a>
							</cfif>
						</cfif>
						<cfif len(last_msg_date)>
							<span class="mobil_text fs-12 text-gray">#dateformat(date_add('h',session.ep.time_zone,last_msg_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,last_msg_date),timeformat_style)# </span>
						</cfif>	
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
		</div>
		
</article>
</div>