<cfset forumCFC = CreateObject("component","V16.objects2.forumv2.cfc.forum_data")>
<cfset GET_COMP_CONS_CAT=forumCFC.GET_COMP_CONS_CAT()/>
<cfif isDefined("session.ww.userid")>
	<cfset cat_id = GET_COMP_CONS_CAT.consumer_cat_id>
<cfelseif isDefined("session.pp.userid")>
	<cfset cat_id = GET_COMP_CONS_CAT.companycat_id>
</cfif>
<cfparam  name="attributes.status" default="1">
<cfparam  name="attributes.startrow" default="1">
<cfparam  name="attributes.maxrows" default="#session_base.maxrows#">
<cfparam  name="attributes.keyword" default="">
<cfparam  name="attributes.forumid" default="0">
<cfparam  name="attributes.tarih" default="1">

<cfset FORUM = forumCFC.select_forum(
								
								startrow	:	attributes.startrow,
								maxrows		:	attributes.maxrows
								)>

<!--- <div class="row d-flex justify-content-center mb-2 mr-5 pr-2">
	<div class="col-12">
		<span class="btn btn-color-5 float-right " onclick="openBoxDraggable('widgetloader?widget_load=addForum&isbox=1')"><i class="far fa-plus-square"></i> <cf_get_lang dictionary_id='55017.Forum Ekle'></span>  		
	</div>
</div>  --->

	<div id="forum">			
			<cfif FORUM.recordcount>
				<cfoutput query="FORUM">
					<cfset attributes.forumid = forumid>
					<cfset forumNameFirstChar= UCase(left(forumName,1))>
		
					<cfset employees_list="">
					<cfset cons_cat_list="">
					<cfset comp_cat_list="">
					<cfset partner_list="">
					<cfset consumer_list ="">
						
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
						
                        
						<div class="forum_item flex-row">
							<div class="forum_item_avatar2" id="#forumid#">
								<i>#forumNameFirstChar#</i>
							</div>
							<div class="forum_item_message">
								<div class="forum_item_message_title">
									<a class="general" href="#site_language_path#/viewTopic?forumid=#Forumid#">#forumName# <span>#dateformat(date_add('h',session_base.time_zone,record_date),'dd/mm/yyyy')#  #timeformat(date_add('h',session_base.time_zone,record_date),"HH:MM")#</span></a>
									<!--- <cfif (len(admin_pars)) or record_emp eq session_base.userid>
										<a class="icon" title="Düzenle" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=updateForum&isbox=1&forumid=#forumid#')">
											<i class="fa fa-pencil"></i>											
										</a>
									</cfif> --->
								</div>
								<div class="forum_item_message_content">
									<p>#DESCRIPTION#</p>
								</div>
							
								<div class="forum_item_cat">
									<p><cf_get_lang dictionary_id='55006.Son Cevap'></p>
									<cfif len(last_msg_date)>											
										<cfset get_user_info = forumCFC.get_user_info(userkey:last_msg_userkey)>									
										<span>
											<i>
												#get_user_info.name# #get_user_info.surname# - 
												#dateformat(date_add('h',session_base.time_zone,last_msg_date),'dd/mm/yyyy')#  #timeformat(date_add('h',session_base.time_zone,last_msg_date),"HH:MM")#</i>
											</i>
										</span>										
									<cfelse>
										<span><i class="fa fa-frown-o" title="Cevap Yok"></i></span>	
									</cfif>
								</div> 
								<div class="forum_item_user">
									<p>Moderasyon</p>
									<ul>
										<cfif len(admin_pos)>
											<cfloop list="#listdeleteduplicates(admin_pos)#" index="x">
												<cfif len(get_emp.employee_id[listfind(employees_list,x)])>
													<li>
														<a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(employees_list,x)]#', 'warning_modal');">
															<cfif len(trim(get_emp.photo[listfind(employees_list,x)])) and FileExists("/hr/#get_emp.photo[listfind(employees_list,x)]#")>
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
											</cfloop>
										</cfif>	
										<cfif len(admin_pars)>
											<cfloop list="#listdeleteduplicates(admin_pars)#" index="a">
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
												</cfif>
											</cfloop>
										</cfif>	
										<cfif len(admin_cons)>
											<cfloop list="#listdeleteduplicates(admin_cons)#" index="b">
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
												</cfif>
											</cfloop>
										</cfif>	
									</ul>
								</div>								
							</div>
						</div>					
				</cfoutput>		
		<cfelse>
			<div class="row">
				<div class="alert-bar col col-12">
					<i></i>
					<p><cfoutput>#getLang("asset",60)#</cfoutput></p>
				</div>
			</div>
		</cfif>
	</div>

<script>
	$(function(){
		elements = [<cfloop query="forum"><cfoutput>"#forumid#"</cfoutput>,</cfloop>];
		for(i=0;i<elements.length;i++){
			var colors = ["#4db6ac","#f6bf26","#e06055","#b39ddb","#009688","#607D8B","#8D6E63","#4fc3f7","#aed581","#FF7043","#1abc9c", "#2ecc71", "#3498db", "#9b59b6", "#34495e", "#16a085", "#27ae60", "#2980b9", "#8e44ad", "#2c3e50", "#f1c40f", "#e67e22", "#e74c3c", "#ecf0f1", "#95a5a6", "#f39c12", "#d35400", "#c0392b", "#bdc3c7", "#7f8c8d"];
			var getRandom = colors[Math.floor(Math.random() * colors.length)];
			$("#"+elements[i]).css("background-color",getRandom);
			$("#"+elements[i]).parent().find('.forum_item_message_title a').eq(1).css("background-color",getRandom);
			// document.getElementById(elements[i]).style.backgroundColor= getRandom;
		}
	});
</script>