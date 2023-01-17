<cfset intranet = createObject('component','cfc.intranet')>
<cfset trainingSec = intranet.trainingSec()>
<cfset trainingClass = intranet.trainingClass(top:6)>
<cfset trainingAgenda = intranet.trainingClass(top:3)>
<cfset trainingAnounce = intranet.trainingAnounce()>
<cfparam name="attributes.keyword" default="">
<cfset cfc = createObject("component","V16.training_management.cfc.training_groups")>
<cfset cfc3 = createObject("component","V16.training_management.cfc.training_management")>
<cfset training_group ="#cfc.get_training_group(train_group_id: attributes.train_group_id)#">
<cfset training_group_class ="#cfc.GET_TRAININGS(train_group_id: attributes.train_group_id)#">
<cfset attenders ="#cfc.get_training_group_attenders(train_group_id: attributes.train_group_id)#">
<cfset attenders_count ="#cfc.get_training_group_attenders_count(train_group_id: attributes.train_group_id)#">
<cfset cfc2 = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset getComponent = createObject("component","V16.objects.cfc.get_list_content_relation")>
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
                                    <span><cfif isDefined("training_group.BRANCH_NAME") and len(training_group.BRANCH_NAME)>#training_group.BRANCH_NAME#</cfif> / <cfif isDefined("training_group.BRANCH_NAME") and len(training_group.BRANCH_NAME)>#training_group.DEPARTMENT_HEAD#</cfif></span>
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
                                            <i class="fa fa-users" style="color:##ff9800;"></i><a href="<cfoutput>#request.self#?</cfoutput>fuseaction=training.list_training_groups&event=det&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>"><cf_get_lang dictionary_id='32139.Eğitimciler'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='57590.Katılımcılar'> <cf_get_lang dictionary_id='30467.Listesi'> </a>
                                        </p>
                                    </div>
                                </p>
                            </div>
                    </cfoutput>
                </div>
            </div>
        </cfif>  

        <cfset cfc2 = createObject('component','V16.training_management.cfc.training_groups')>
        <cfset train_subjects = cfc2.get_training_group_subjects(train_group_id:attributes.train_group_id)>
        
        <div class="training_contents" style="margin: 0 -5px 0 -5px;">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='46049.Müfredat'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">
                        <table style="table-layout: fixed;">
                            <tbody>
                                <cfif train_subjects.recordcount>
                                    <cfoutput query="train_subjects" maxrows="5">
                                        <tr>
                                            <td style="word-wrap: break-word;white-space: normal;">
                                                <cfset attributes.sec_id = train_subjects.TRAINING_SEC_ID>
                                                <cfinclude template="../../training_management/query/get_training_sec_names.cfm">
                                                <div class="training_items_head">
                                                    <a href="#request.self#?fuseaction=training.curriculum&event=det&train_id=#TRAIN_ID#">#train_head#</a>
                                                </div>
                                                <div class="training_items_cat">
                                                    #GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#
                                                </div>
                                            </td>
                                        </tr>
                                    </cfoutput>
                                <cfelse>
                                    <cf_get_lang dictionary_id='57484.Kayıt Yok'>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                    <div class="training_items_bottom_btn">
                        <a href="<cfoutput>#request.self#?</cfoutput>fuseaction=training.curriculum&form_submitted=1">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
                    </div>
                </cf_box>
            </div> <!--- Müfredat --->
                
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='63579.Öne Çıkan İçerikler'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">                    
                        <table style="table-layout: fixed;">
                            <tbody>
                                <cfif training_group_class.recordcount>
                                    <cfloop query="training_group_class">
                                        <cfset get_content = getComponent.GetContent(action_type : 'CLASS_ID', action_type_id : training_group_class.class_id)>
                                        <cfoutput query="get_content" group="content_id" maxrows="5">
                                            <tr>
                                                <cfset get_content_image = getComponent.get_content_image(content_id : content_id)>
                                                <td style="word-wrap: break-word;white-space: normal;">
                                                    <cfif len(get_content_image.PHOTO)>
                                                        <img src="documents/content/#get_content_image.PHOTO#" style="width:100%" height="150px">
                                                    </cfif>
                                                    <div class="training_items_head">
                                                        <a href="#request.self#?fuseaction=training.content&event=det&cntid=#content_id#">#CONT_HEAD#</a>
                                                    </div>
                                                    <div class="training_items_cont_sum">
                                                        #CONT_SUMMARY#
                                                    </div>
                                                    <div class="training_items_cat">
                                                        #CONTENTCAT#/#CHAPTER#
                                                    </div>
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    </cfloop>
                                <cfelse>
                                    <cf_get_lang dictionary_id='57484.Kayıt Yok'>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                    <div class="training_items_bottom_btn">
                        <a href="<cfoutput>#request.self#?fuseaction=training.content&train_group_id=#attributes.train_group_id#</cfoutput>">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
                    </div>
                </cf_box>
            </div> <!--- Öne Çıkan İçerik --->

            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='63643.Ödevler'> - <cf_get_lang dictionary_id='63644.Çalışmalar'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">
                        <table style="table-layout: fixed;">
                            <tbody>
                                <cfif training_group_class.recordcount>
                                    <cfloop query="training_group_class">
                                        <cfset GET_HOMEWORK = cfc3.GET_HOMEWORK(lesson_id: training_group_class.class_id)>
                                        <cfoutput query="GET_HOMEWORK" maxrows="5">
                                            <div class="protein-table training_items" style="border-bottom: 2px dashed ##eee; padding:10px 0 10px 0;">
                                                <div class="homewrk">
                                                    #homework#
                                                </div>
                                                <div class="homewrk_class">
                                                    <cfset class = cfc3.GET_CLASS_F(class_id: GET_HOMEWORK.lesson_id)>
                                                    #class.class_name#
                                                </div>
                                                <div class="homewrk_row">
                                                    <cf_get_lang dictionary_id='61890.Son Tarih'>
                                                    #dateformat(delivery_date, dateformat_style)# -
                                                    #timeformat(delivery_date, timeformat_style)#
                                                    <cfif DateCompare(delivery_date, now()) eq -1>
                                                        <cfscript>
                                                            totalMinutes = datediff("n", delivery_date, now());
                                                            days = int(totalMinutes /(24 * 60)) ;
                                                            minutesRemaining = totalMinutes - (days * 24 * 60);
                                                            hours = int(minutesRemaining / 60);
                                                            minutes = minutesRemaining mod 60;
                                                        </cfscript>
                                                        <span class="bold" style="color:red;">#days & ' #getLang('','Gün',57490)# ' & hours & ' #getLang('','Saat',57491)# '# <cf_get_lang dictionary_id='39657.Gecikme'></span><br>
                                                    </cfif>
                                                    <cfset deliveries = cfc3.GET_HOMEWORK_DELIVERIES(homework_id: GET_HOMEWORK.homework_id)>
                                                    <cfif len(deliveries.DELIVERY_DATE)>
                                                        <span class="bold" style="color:##1dba5c;">
                                                            <cf_get_lang dictionary_id='47688.Teslim Edildi'>
                                                        </span>
                                                        <!--- <cfif get_trainer_names.T_ID eq session.ep.userid and session.ep.userkey contains 'e'>
                                                            <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training.lesson&lesson_id=#attributes.lesson_id#&homework_id=#GET_HOMEWORK.homework_id#&event=addHomeworkAnswer','add_answer_box','ui-draggable-box-medium')">
                                                                <cf_get_lang dictionary_id='37495.Puan Ver'>
                                                            </a>
                                                        </cfif> --->
                                                    <cfelse>
                                                        <a href="javascript://" style="color:##d03232;" onclick="openBoxDraggable('#request.self#?fuseaction=training.lesson&lesson_id=#GET_HOMEWORK.lesson_id#&homework_id=#GET_HOMEWORK.homework_id#&event=addHomeworkAnswer','add_answer_box','ui-draggable-box-medium')">
                                                            <cf_get_lang dictionary_id='44630.Ekle'>
                                                        </a>
                                                    </cfif>
                                                </div>
                                            </div>
                                        </cfoutput>
                                    </cfloop>
                                <cfelse>
                                    <cf_get_lang dictionary_id='57484.Kayıt Yok'>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                    <div class="training_items_bottom_btn">
                        <a href="javascrip://">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
                    </div>
                </cf_box>
            </div> <!--- Ödevler - Çalışmalar --->
            
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='58063.Dersler'>-<cf_get_lang dictionary_id='57415.Ajanda'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">
                        <table style="table-layout: fixed;">
                            <tbody>
                                <cfif training_group_class.recordcount>
                                    <cfoutput query="training_group_class">
                                        <cfif DateCompare(now(),finish_date) eq 0 or DateCompare(now(),finish_date) eq -1>
                                            <tr>
                                                <td style="word-wrap: break-word;white-space: normal;">
                                                    <cfif is_active>
                                                        <div class="training_items_agenda">
                                                            <div class="training_items_agenda_left">
                                                                <div class="training_items_date">
                                                                    <div class="training_items_date_d">
                                                                        #dateFormat(start_date, 'dd')#
                                                                    </div>
                                                                    <div class="training_items_date_m">
                                                                        #monthAsString(month(start_date),"tr")#
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="training_items_agenda_right">
                                                                <div class="training_items_h">
                                                                    #dateFormat(start_date, 'HH:mm')# - #dateFormat(finish_date, 'HH:mm')#
                                                                </div>
                                                                <div class="training_items_class_name">
                                                                    <a href="#request.self#?fuseaction=training.lesson&event=det&lesson_id=#class_id#">#class_name#</a>
                                                                </div>
                                                                <div class="training_items_loc">
                                                                    <cfif is_internet>
                                                                        <span class="ctl-whiteboard"></span><cf_get_lang dictionary_id='30015.Online'>
                                                                    <cfelse>
                                                                        <span class="ctl-professor"></span><cf_get_lang dictionary_id='63589.Sınıf Eğitimi'>
                                                                    </cfif>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                <cfelse>
                                    <cf_get_lang dictionary_id='57484.Kayıt Yok'>
                                </cfif>
                            </tbody>
                        </table>
                    </div>
                    <div class="training_items_bottom_btn">
                        <a href="<cfoutput>#request.self#?</cfoutput>fuseaction=training.lesson">> <cf_get_lang dictionary_id='58932.Aylık'><cf_get_lang dictionary_id='57415.Ajanda'></a>
                    </div>
                </cf_box><!--- Dersler - Ajanda --->
                <!--- Rastgele Soru --->
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='64042.Alıştırma Yap'></a>
                            </span>
                        </div>
                    </div>
                    <div id="random_question"></div>
                </cf_box>
                <!--- //Rastgele Soru --->
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.list_training_groups&event=randomQuestion&train_group_id=#attributes.train_group_id#</cfoutput>', 'random_question');
</script>