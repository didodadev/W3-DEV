<cfparam name="attributes.keyword" default="">
<cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>

<cfset cfc = createObject("component","V16.training_management.cfc.training_groups")>
<cfset training_group ="#cfc.get_training_group(train_group_id: attributes.train_group_id)#">
<cfset training_group_class ="#cfc.GET_TRAININGS(train_group_id: attributes.train_group_id)#">
<cfset attenders ="#cfc.get_training_group_attenders(train_group_id: attributes.train_group_id)#">
<cfset attenders_count ="#cfc.get_training_group_attenders_count(train_group_id: attributes.train_group_id)#">
<cfif training_group_class.recordcount>
    <cfscript>
        get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
        get_trainers.dsn = dsn;
        get_trainer_names = get_trainers.get_class_trainers(
            class_id : training_group_class.class_id
        );
    </cfscript>
</cfif>
<style>
    .pageMainLayout{padding:0;}    
</style>
<cfinclude template="../../rules/display/rule_menu.cfm">
<div class="wrapper" style="margin-top:-25px;">
    <div class="col col-12">
	    <cfinclude template="general_training_menu.cfm">
    </div>
</div>

<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfif isDefined("attributes.train_group_id") and len(attributes.train_group_id)>
            <div class="forum_item flex-col">
                <div class="reply_item">
                    <cfoutput>
                        <div class="training_item_bg_img" style="background-image: linear-gradient(to right, ##054128 , ##3d7e5e ,##054128);">
                            <div class="training_item_bg_img_txt">
                                <p>#training_group.GROUP_HEAD#</p>
                            </div>
                        </div>
                        <p class="text bold">#training_group.GROUP_DETAIL#</p>
                        <div class="syllabus_cat">
                            <p class="bold"> 
                                <i class="wrk-uF0220" style="color:##d39241;"></i>
                                <span>#training_group.BRANCH_NAME# / #training_group.DEPARTMENT_HEAD#</span>
                                <i class="wrk-uF0022" style="color:##ef0000"></i>
                                <span>#training_group.QUOTA# / #attenders_count.recordcount#</span>  
                                <i class="wrk-uF0199" style="color:##4cb355;"></i>
                                <span>
                                    <cfif session.ep.language eq 'eng'>
                                        <cfset userLanguage = 'en'>
                                    <cfelseif session.ep.language eq 'arb'>
                                        <cfset userLanguage = 'ar'>
                                    <cfelseif session.ep.language eq 'rus'>
                                        <cfset userLanguage = 'ru'>
                                    <cfelseif session.ep.language eq 'ukr'>
                                        <cfset userLanguage = 'uk'>
                                    <cfelse>
                                        <cfset userLanguage = session.ep.language>
                                    </cfif>
                                    #lsdateformat(training_group.start_date,'dd mmmm yyyy', userLanguage)# -
                                    #lsdateformat(training_group.FINISH_DATE,'dd mmmm yyyy', userLanguage)# 
                                </span>
                                <div class="syllabus_catr">
                                    <p class="bold">
                                        <cfif training_group_class.recordcount>
                                            <cfloop query="training_group_class">
                                                <cfset get_trainer_names = get_trainers.get_class_trainers(class_id: "#class_id#")>
                                                <cfif session.ep.userid eq get_trainer_names.EMP_ID>
                                                    <i class="fa fa-pencil" style="color:##ff9800;"></i><a target="_blank" href="<cfoutput>#request.self#?</cfoutput>fuseaction=training_management.list_training_groups&event=upd&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>"><span style="color:##555"><cf_get_lang dictionary_id='63676.Yönet'></span></a>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                        </cfif>
                                            <i class="fa fa-comments" style="color:##ff9800;"></i><span title="<cf_get_lang dictionary_id='63675.Coming Soon'>" style="color:##555"><cf_get_lang dictionary_id='62192.ChatFlow'></span>
                                            <i class="fa fa-users" style="color:##ff9800;"></i><a href="<cfoutput>#request.self#?</cfoutput>fuseaction=training.list_training_groups&event=upd&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>"><cf_get_lang dictionary_id='57653.İçerik'>, <cf_get_lang dictionary_id='63657.Ödev'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='32138.Takvim'></a>
                                    </p>
                                </div>
                            </p>
                        </div>
                    </cfoutput>
                </div>
            </div>
        </cfif>

        <cfset cfc2 = createObject('component','V16.training_management.cfc.trainingcat')>
        <cfset get_trainings = cfc2.GET_TRAININGS()>

        <div class="training_contents" style="margin: 0 -5px 0 -5px;">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='32139.Eğitimciler'></a>
                            </span>
                        </div>
                    </div>
                    <ul class="ui-list_type2" style="margin-top:10px">
                        <cfif training_group_class.recordcount>
                            <cfoutput query="training_group_class">
                                <cfscript>
                                    get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
                                    get_trainers.dsn = dsn;
                                    get_trainer_names = get_trainers.get_class_trainers(
                                        class_id : training_group_class.class_id
                                    );
                                </cfscript>
                                <cfloop query="get_trainer_names">
                                    <li>
                                        <div class="ui-list-img">
                                            <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_trainer_names.EMP_ID)>
                                            <cfif len(employee_photo.photo)>
                                                <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                            <cfelseif employee_photo.sex eq 1>
                                                <cfset emp_photo ="images/male.jpg">
                                            <cfelse>
                                                <cfset emp_photo ="images/female.jpg">
                                            </cfif>
                                            <img src='#emp_photo#' />
                                        </div>
                                        <div class="ui-list-text">
                                            <span class="name">#get_trainer_names.trainer#</span>
                                            <span class="title">#get_trainer_names.POSITION_CAT#</span>
                                            <span class="title"><span class="bold"><cf_get_lang dictionary_id='46015.Ders'>: </span> #get_trainer_names.CLASS_NAME#</span>
                                            <ul class="contact-list">                                   
                                                <li><a href="javascript://"><i class="fa fa-envelope-open-o"></i></a></li>
                                                <li><a href="javascript://"><i class="fa fa-user-o"></i></a></li>
                                                <li><a href="javascript://"><i class="fa fa-comment-o"></i></a></li>
                                            </ul>
                                        </div>
                                    </li>                           
                                </cfloop>
                            </cfoutput>
                        <cfelse>
                            <cf_get_lang dictionary_id='30935.Eğitimci'><cf_get_lang dictionary_id='58981.Kayıtlı Değil'>
                        </cfif>
                    </ul>          
                    <!--- <div class="training_items_bottom_btn">
                        <a href="javascript://">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
                    </div> --->
                </cf_box>
            </div> <!--- Eğitimciler --->

            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='57590.Katılımcılar'></a>
                            </span>
                        </div>
                    </div>
                    <ul class="ui-list_type2" style="margin-top:10px">
                        <cfinclude template="../../training_management/query/get_training_group_attenders.cfm">
                        <cfif get_attender_emps.recordcount>
                            <cfloop query="get_attender_emps">
                                <cfif len(get_attender_emps.K_ID)>
                                    <cfset empInfo ="#getComponent.GET_EMP_NAME(EMPLOYEE_ID: K_ID)#">
                                    <cfoutput query="empInfo">
                                        <li>
                                            <div class="ui-list-img">
                                                <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_attender_emps.K_ID)>
                                                <cfif len(employee_photo.photo)>
                                                    <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                                <cfelseif employee_photo.sex eq 1>
                                                    <cfset emp_photo ="images/male.jpg">
                                                <cfelse>
                                                    <cfset emp_photo ="images/female.jpg">
                                                </cfif>
                                                <img src='#emp_photo#' />
                                            </div>
                                            <div class="ui-list-text">
                                                <span class="name"> #empInfo.EMPLOYEE_NAME# #empInfo.EMPLOYEE_SURNAME#</span>
                                                <!--- <span class="title"><span class="bold"><cf_get_lang dictionary_id='46015.Ders'>: </span> #get_attender_emps.CLASS_NAME#</span> --->
                                                <ul class="contact-list">
                                                    <li><a href="javascript://"><i class="fa fa-envelope-open-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-user-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-comment-o"></i></a></li>
                                                </ul>
                                            </div>
                                        </li>
                                    </cfoutput>
                                </cfif>
                            </cfloop>
                            <cfloop query="get_attender_pars">
                                <cfif len(get_attender_pars.K_ID)>
                                    <cfset parInfo ="#getComponent.GET_COMPANY_PARTNER(partner_id: K_ID)#">
                                    <cfoutput query="parInfo">
                                        <li>
                                            <div class="ui-list-img">
                                                <cfset PARTNER_PHOTO = getComponent.PARTNER_PHOTO(partner_id:get_attender_pars.K_ID)>
                                                <cfif len(PARTNER_PHOTO.photo)>
                                                    <cfset emp_photo ="../../documents/hr/#PARTNER_PHOTO.PHOTO#">
                                                <cfelseif PARTNER_PHOTO.sex eq 1>
                                                    <cfset emp_photo ="images/male.jpg">
                                                <cfelse>
                                                    <cfset emp_photo ="images/female.jpg">
                                                </cfif>
                                                <img src='#emp_photo#' />
                                            </div>
                                            <div class="ui-list-text">
                                                <span class="name"> #parInfo.COMPANY_PARTNER_NAME# #parInfo.COMPANY_PARTNER_SURNAME#</span>
                                                <!--- <span class="title">Sanatçı</span> --->                              
                                                <ul class="contact-list">
                                                    <li><a href="javascript://"><i class="fa fa-envelope-open-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-user-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-comment-o"></i></a></li>
                                                </ul>
                                            </div>
                                        </li>
                                    </cfoutput>
                                </cfif>
                            </cfloop>
                            <cfloop query="get_attender_cons">
                                <cfif len(get_attender_cons.K_ID)>
                                    <cfset conInfo ="#getComponent.GET_CONSUMER(consumer_id: K_ID)#">
                                    <cfoutput query="conInfo">
                                        <li>
                                            <div class="ui-list-img">
                                                <cfset CONSUMER_PHOTO = getComponent.CONSUMER_PHOTO(consumer_id:get_attender_cons.K_ID)>
                                                <cfif len(CONSUMER_PHOTO.PICTURE)>
                                                    <cfset emp_photo ="../../documents/hr/#CONSUMER_PHOTO.PHOTO#">
                                                <cfelseif CONSUMER_PHOTO.sex eq 1>
                                                    <cfset emp_photo ="images/male.jpg">
                                                <cfelse>
                                                    <cfset emp_photo ="images/female.jpg">
                                                </cfif>
                                                <img src='#emp_photo#' />
                                            </div>
                                            <div class="ui-list-text">
                                                <span class="name"> #conInfo.CONSUMER_NAME# #conInfo.CONSUMER_SURNAME#</span>
                                                <!--- <span class="title">Sanatçı</span> --->
                                                <ul class="contact-list">                                   
                                                    <li><a href="javascript://"><i class="fa fa-envelope-open-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-user-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-comment-o"></i></a></li>
                                                </ul>
                                            </div>
                                        </li>
                                    </cfoutput>
                                </cfif>
                            </cfloop>
                            <cfloop query="get_attender_grps">
                                <cfif len(get_attender_grps.K_ID)>
                                    <cfset grpInfo ="#getComponent.GET_CONSUMER(consumer_id: K_ID)#">
                                    <cfoutput query="grpInfo">
                                        <li>
                                            <div class="ui-list-img">
                                                <cfset CONSUMER_PHOTO = getComponent.CONSUMER_PHOTO(consumer_id:get_attender_grps.K_ID)>
                                                <cfif len(CONSUMER_PHOTO.PICTURE)>
                                                    <cfset emp_photo ="../../documents/hr/#CONSUMER_PHOTO.PHOTO#">
                                                <cfelseif CONSUMER_PHOTO.sex eq 1>
                                                    <cfset emp_photo ="images/male.jpg">
                                                <cfelse>
                                                    <cfset emp_photo ="images/female.jpg">
                                                </cfif>
                                                <img src='#emp_photo#' />
                                            </div>
                                            <div class="ui-list-text">
                                                <span class="name"> #grpInfo.CONSUMER_NAME# #grpInfo.CONSUMER_SURNAME#</span>
                                                <!--- <span class="title">Sanatçı</span> --->
                                                <ul class="contact-list">                                   
                                                    <li><a href="javascript://"><i class="fa fa-envelope-open-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-user-o"></i></a></li>
                                                    <li><a href="javascript://"><i class="fa fa-comment-o"></i></a></li>
                                                </ul>
                                            </div>
                                        </li>
                                    </cfoutput>
                                </cfif>
                            </cfloop>
                        <cfelse>
                            <cf_get_lang dictionary_id='29780.Katılımcı'><cf_get_lang dictionary_id='58981.Kayıtlı Değil'>
                        </cfif>
                    </ul>
                    <!--- <div class="training_items_bottom_btn">
                        <a href="javascript://">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
                    </div> --->
                </cf_box>
            </div> <!--- Katılımcılar --->

            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='46306.Mazeretliler'></a>
                            </span>
                        </div>
                    </div>
                    <ul class="ui-list_type2" style="margin-top:10px">
                        <cfset attenders ="#cfc.get_training_group_attenders(train_group_id: attributes.train_group_id)#">
                        <cfif attenders.recordcount>
                            <cfloop query="attenders">
                                <cfif len(emp_id)>
                                    <cfset empInfo ="#cfc.EMP_NAME(EMPLOYEE_ID: emp_id)#">
                                    <cfoutput query="empInfo">                     
                                        <cfif attenders.joined eq 2>
                                            <li>
                                                <div class="ui-list-img">
                                                    <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:attenders.emp_id)>
                                                    <cfif len(employee_photo.photo)>
                                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                                    <cfelseif employee_photo.sex eq 1>
                                                        <cfset emp_photo ="images/male.jpg">
                                                    <cfelse>
                                                        <cfset emp_photo ="images/female.jpg">
                                                    </cfif>
                                                    <img src='#emp_photo#' />
                                                </div>
                                                <div class="ui-list-text">
                                                    <span class="name"> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</span>
                                                    <span class="title"><span class="bold"><cf_get_lang dictionary_id='46015.Ders'>: </span> #attenders.CLASS_NAME#</span>
                                                    <ul class="contact-list">                                   
                                                <ul class="contact-list">                                   
                                                    <ul class="contact-list">                                   
                                                <ul class="contact-list">                                   
                                                    <ul class="contact-list">                                   
                                                <ul class="contact-list">                                   
                                                    <ul class="contact-list">                                   
                                                <ul class="contact-list">                                   
                                                    <ul class="contact-list">                                   
                                                        <li><a href="javascript://"><i class="fa fa-envelope-open-o"></i></a></li>
                                                        <li><a href="javascript://"><i class="fa fa-user-o"></i></a></li>
                                                        <li><a href="javascript://"><i class="fa fa-comment-o"></i></a></li>
                                                    </ul>
                                                </div>
                                            </li>
                                        </cfif>
                                    </cfoutput>
                                </cfif>
                            </cfloop>
                        <cfelse>
                            <cf_get_lang dictionary_id='40347.Mazeretli'><cf_get_lang dictionary_id='29780.Katılımcı'><cf_get_lang dictionary_id='58546.Yok'>
                        </cfif>
                    </ul>
                    <!--- <div class="training_items_bottom_btn">
                        <a href="javascript://">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
                    </div> --->
                </cf_box>
            </div> <!--- Mazeretliler --->
        </div>
    </div>
</div>