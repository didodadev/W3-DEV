<cfinclude template="../query/get_company_name.cfm">
<cfset forumCFC = CreateObject("component","V16.forum.cfc.forum").init(dsn = application.systemParam.systemParam().dsn)>
<cfset userinfo = CreateObject("component","V16.forum.cfc.userinfo")>
<cfset FORUM = forumCFC.select(
								keyword		:	"#iif(isdefined('attributes.keyword') and len(attributes.keyword), 'attributes.keyword', DE(''))#",
								forumid		:	"#iif(isdefined('attributes.forumid') and len(attributes.forumid), 'attributes.forumid', DE(''))#",
								status		:	attributes.status,
								tarih		:	"#iif(isdefined('attributes.tarih') and len(attributes.tarih), 'attributes.tarih', DE(''))#",
								startrow	:	attributes.startrow,
								maxrows		:	attributes.maxrows
								)>


<cfoutput query="FORUM">
    <div class="forum_info col col-12">
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

        <div class="col col-12 col-xs-12">
            <div class="col col-1 col-xs-2">		
                <div class="wrk_letter">#forumNameFirstChar#</div>
            </div>
            <div class="col col-10 wrk_content">
                <h3 class="wrk_title">
                    <a href="#request.self#?fuseaction=forum.view_topic&forumid=#Forumid#">#forumName#</a>
                    - <span class="titleDate">#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</span>
                </h3>
                <p class="wrk_desc">#DESCRIPTION#</p>
                <div class="col col-12 col-xs-12 last_message pdn-l-0">
                    
                    <div class="col col-2 col-md-3 col-xs-12 pdn-l-0 message_row">
                        <i class="fa fa-file-text-o"></i>
                        <span class="last_answer">#getLang("forum",19,"Konu/Mesaj")#</span>
                        <span class="last_answer_value">#topic_count#/#reply_count#</b></span>
                    </div>

                    <div class="col col-3 col-md-4 col-xs-12 pdn-l-0 message_row">
                        <div class="message_row">
                        <i class="fa fa-clock-o"></i>
                        <span class="last_answer">#getLang("forum",40,"Son Cevap")#:</span>
                        <cfif len(last_msg_date)>
                            
                            <cfset get_user_info = userinfo.get_user_info(userkey:last_msg_userkey)>
                            
                            <a href="javascript://"  
                                <cfif listfirst(last_msg_userkey,"-") is "e">
                                    onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(last_msg_userkey,"-")#'});"
                                <cfelseif listfirst(last_msg_userkey,"-") is "p">
                                    onclick="nModal({head:'Profil', page:'#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(last_msg_userkey,"-")#'});"
                                <cfelseif listfirst(last_msg_userkey,"-") is "c">
                                    onclick="nModal(head:'Profil',page:'#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(last_msg_userkey,"-")#'});"
                                </cfif>
                            >				
                                <span class="last_answer_value">
                                #get_user_info.name# #get_user_info.surname#
                                </span>
                            </a>
                            - <span class="last_answer_value">#dateformat(date_add('h',session.ep.time_zone,last_msg_date),dateformat_style)#  #timeformat(date_add('h',session.ep.time_zone,last_msg_date),timeformat_style)#</span>
                            
                        <cfelse>
                            <span class="last_answer_value"><i class="sadicon"></i></span>	
                        </cfif>
                        </div>
                    </div>
                    <cfif (len(admin_pos) and listfindnocase(admin_pos,get_position_id(session.ep.position_code))) or session.ep.admin eq 1 or record_emp eq session.ep.userid>
                    <div class="col col-4 col-md-5 col-xs-12 pdn-l-0 message_row">
                        <a href="#request.self#?fuseaction=forum.form_upd_forum&forumid=#forumid#" class="message_row_button">
                            <i class="fa fa-pencil"></i>
                            <span class="last_answer_value">#getLang("main",52)#</span>
                        </a>
                    </div>
                    </cfif>
                </div>
                <div class="col col-12 pdn-l-0">
                    <div class="col col-12 col-xs-12 pdn-l-0">
                        <h6>   
                            <span class="text-brand-warning font-raleway-800"><cf_get_lang no='31.Kimler İçin'>:</span><span class="mobil_text">
                                <cfif forum_emps eq 1>
                                    <cf_get_lang_main no='1463.Çalışanlar'>
                                </cfif>
                                <cfif len(forum_comp_cats)>
                                    <cf_get_lang_main no='1611.Kurumsal Üyeler'> 
                                    <cfset i=1/>
                                    <cfloop list="#listdeleteduplicates(forum_comp_cats)#" index="v">
                                        <cfif i LE 3>
                                            #get_company_cats.companycat[listfind(comp_cat_list,v)]#,
                                        </cfif>
                                        <cfset i = i+1/>
                                    </cfloop>
                                </cfif>			
                                <cfif len(forum_cons_cats)>
                                    <cf_get_lang_main no='1609.Bireysel Üyeler'>
                                    <cfset i=1/>
                                    <cfloop list="#listdeleteduplicates(forum_cons_cats)#" index="y">
                                        <cfif i LE 3>
                                            #get_consumer_cats.conscat[listfind(cons_cat_list,y)]#,
                                            
                                        </cfif>
                                        <cfset i=i+1/>
                                    </cfloop>
                                </cfif>				
                            </span>
                        </h6>
                    </div>
                </div>
                <ul class="wrk_mod_list">
                    <cfif len(admin_pos)>
                        <cfloop list="#listdeleteduplicates(admin_pos)#" index="x">

                            <cfif len(get_emp.employee_id[listfind(employees_list,x)])>
                                <a href="javascript://" onclick="nModal({head:'Profil',page :'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(employees_list,x)]#'});">
                                <li class="wrk_mod">
                                    <cfif len(trim(get_emp.photo[listfind(employees_list,x)])) and FileExists("./documents/hr/" & get_emp.photo[listfind(employees_list,x)])>
                                        <cfset resim = "./documents/hr/"&get_emp.photo[listfind(employees_list,x)]>
                                    <cfelse>
                                        <cfset resim="../images/male.jpg">
                                    </cfif>		
                                    <img src="#resim#"
                                        class="img-fluid wrk_user_img hidden-md-down"
                                        alt="emp"/>
                                        #get_emp.employee_name[listfind(employees_list,x)]#
                                        #get_emp.employee_surname[listfind(employees_list,x)]#
                                </li>
                                </a>
                            </cfif>
                            <!---<cfif listlast(admin_pos,',') neq x>,</cfif>--->
                        </cfloop>
                    </cfif>	
                    <cfif len(admin_pars)>
                        <cfloop list="#listdeleteduplicates(admin_pars)#" index="a">
                            <cfif len(get_partner.partner_id[listfind(partner_list,a)])>
                                <cfif len(trim(get_partner.photo[listfind(partner_list,x)])) and FileExists("./documents/hr/" & get_partner.photo[listfind(partner_list,x)])>
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
                            <!---<cfif listlast(admin_pars,',') neq a>,</cfif>--->
                            </cfif>
                        </cfloop>
                    </cfif>	
                    <cfif len(admin_cons)>
                        <cfloop list="#listdeleteduplicates(admin_cons)#" index="b">
                        <cfif len(get_consumer.consumer_id[listfind(consumer_list,b)])>
                            <li class="wrk_mod">
                                <cfif len(trim(get_consumer.picture[listfind(consumer_list,b)])) and FileExists("./documents/hr/" & get_consumer.picture[listfind(consumer_list,b)])>
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
                            <!---<cfif listlast(admin_cons,',') neq b>,</cfif>--->
                            </cfif>
                        </cfloop>
                    </cfif>	
                </ul>
            </div>
        </div>	
    </div>
</cfoutput>