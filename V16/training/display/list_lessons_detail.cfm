<cfset tg_cfc = createObject('component','V16.training_management.cfc.training_groups')>
<cfset get_lessons = tg_cfc.get_lessons(lesson_id: attributes.lesson_id)>
<cfset get_training_class_group = tg_cfc.get_training_class_group(class_id: attributes.lesson_id)>
<cfset cfc2 = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset cfc3 = createObject('component','V16.training_management.cfc.training_management')>
<cfset GET_HOMEWORK = cfc3.GET_HOMEWORK(lesson_id: attributes.lesson_id)>
<cfset get_asset_by_id = cfc3.get_asset_by_id(lesson_id: attributes.lesson_id)>
<cfset get_user_info = cfc3.get_user_info(userkey: session.ep.userkey)>
<cfset getComponent = createObject("component","V16.objects.cfc.get_list_content_relation")>
<cfset get_content = getComponent.GetContent(action_type : 'CLASS_ID', action_type_id : attributes.lesson_id)>

<cfscript>
	get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
	get_trainers.dsn = dsn;
	get_trainer_names = get_trainers.get_classes
    (
        module_name : fusebox.circuit,
        class_id : attributes.lesson_id
    );
</cfscript>

<cfset cfc = createObject('component','V16.training_management.cfc.training_management')>
<cfset get_training_groups = cfc.get_training_groups(lesson_id: attributes.lesson_id)>
<cfinclude template="../../training_management/query/get_training_group_attenders.cfm">
<cfset get_class_attenders_by_id = cfc.get_class_attenders_by_id(lesson_id: attributes.lesson_id)>

<style>
    .pageMainLayout{padding:0;}
</style>
<!--- <link rel="stylesheet" href="/css/assets/template/intranet/intranetSa.css" type="text/css"> --->
<cfinclude template="../../rules/display/rule_menu.cfm">
<div class="wrapper" style="margin-top:-5px;">
    <div class="col col-12">
	    <cfinclude template="general_training_menu.cfm">
    </div>
</div>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_lessons.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="wrapper">
    <div id="wiki" class="col col-9 col-md-12 col-sm-12 col-xs-12"  style="padding:0 5px !important">
        <cfif get_lessons.recordcount>
            <cfoutput query="get_lessons" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <div class="forum_item flex-col" style="0px 1px 15px 1px rgb(39 39 39 / 8%)">      
                    <div class="reply_item">
                        <div class="row">            
                            <div class="col col-4 col-md-12 col-sm-12 col-xs-12">
                                <div class="training_items">
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
                                                <cfset date = date_add('h',session.ep.time_zone,start_date)> <br>
                                                #Dateformat(date,dateformat_style)# #Timeformat(date,timeformat_style)#                                        
                                            </div>                                  
                                            <div class="training_items_loc">
                                                <cfif ONLINE>
                                                    <span class="ctl-whiteboard"></span><a href="#TRAINING_LINK#" target="_blank"><cf_get_lang dictionary_id='30015.Online'></a>
                                                <cfelse>
                                                    <span class="ctl-professor"></span><cf_get_lang dictionary_id='63589.Sınıf Eğitimi'>
                                                </cfif> 
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                                <div class="syllabus_name">
                                    <a href="<!--- #request.self#?fuseaction=training.curriculum&event=det&train_id=#TRAIN_ID# --->" style="color:##000">
                                        #CLASS_NAME#
                                    </a>                              
                                    <p class="bold">#CLASS_TARGET#</p>
                                </div>
                                <div class="syllabus_cat">
                                    <p class="bold">
                                        <i class="wrk-uF0022" style="color:##ef0000"></i>
                                        <span>
                                            <cfif len(get_lessons.TRAINING_ID)>
                                                <cfset train = cfc2.GET_TRAINING_SUBJECT(TRAIN_ID: get_lessons.TRAINING_ID)>
                                                #train.train_head# /
                                            </cfif>
                                            <cfset get_training_cat = cfc2.get_training_cat()>
                                            <cfset get_training_sec = cfc2.get_training_sec()>
                                            <cfloop query="get_training_cat">
                                                <cfif get_training_cat.training_cat_id eq get_lessons.training_cat_id>
                                                    #TRAINING_CAT#
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop> / 
                                            <cfloop query="get_training_sec">
                                                <cfif get_training_sec.training_sec_id eq get_lessons.training_sec_id>
                                                    #SECTION_NAME#
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                        </span>
                                        <i class="wrk-uF0220" style="color:##d39241;"></i>
                                        <span>
                                            <cf_get_lang dictionary_id='46652.Maksimum Katılımcı'>: 
                                            <cfif len(max_participation)>#max_participation#<cfelse>0</cfif>
                                        </span>
                                        <span>
                                            <cf_get_lang dictionary_id='30916.Eğitim Yeri'>: 
                                            <cfif len(class_place)><a target="_blank" href="<cfif len(TRAINING_LINK)>#TRAINING_LINK#<cfelse>javascript://</cfif>">#class_place#</a><cfelse>0</cfif>
                                        </span>
                                    </p>
                                </div>
                            </div> 
                        </div>  
                    </div>                   
                </div>
            </cfoutput>
            <div class="cont" style="margin:0 -5px 0 -5px;">
            <div class="col col-4 col-md-12 col-sm-12 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='58045.İçerikler'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">
                        <table style="table-layout: fixed;">
                            <tbody>
                                <cfoutput query="get_content">
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
                            </tbody>
                        </table>
                    </div>
                    <div class="training_items_bottom_btn">
                        <a href="<cfoutput>#request.self#?fuseaction=training.content&lesson_id=#attributes.lesson_id#</cfoutput>"> <cf_get_lang dictionary_id='36496.Tamamı'></a>
                    </div>
                </cf_box>
            </div>
            <div class="col col-4 col-md-12 col-sm-12 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='57568.Belgeler'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">
                        <div class="asset_list">                            
                            <table style="table-layout: fixed;">
                                <tbody>
                                    <cfoutput query="get_asset_by_id">
                                        <cfif get_asset_by_id.recordcount>
                                            <tr>
                                                <cfif len(#EMBEDCODE_URL#)>
                                                <td style="word-wrap: break-word;white-space: normal;">
                                                    <img src="css/assets/icons/catalyst-icon-svg/google-docs.svg" width="30px" height="40px"><a href="#EMBEDCODE_URL#" target="_blank">#ASSET_NAME#</a>
                                                </td>
                                            <cfelse>
                                                <td style="word-wrap: break-word;white-space: normal;">
                                                    <img src="css/assets/icons/catalyst-icon-svg/PDF.svg" width="30px" height="40px"><a href="#request.self#?fuseaction=objects.popup_download_file&file_name=training/#ASSET_FILE_NAME#&file_control=asset.form_upd_asset&asset_id=#ASSET_ID#&assetcat_id=#ASSETCAT_ID#">#ASSET_NAME#</a>
                                                </td>
                                            </cfif>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </tbody>
                            </table>
                        </div>
                    </div>                    
                    <div class="training_items_bottom_btn d-flex flex-end">
                        <a href="javascript://" style="color:#d03232" onclick="windowopen('<cfoutput>#request.self#?fuseaction=asset.list_asset&event=add&module=training&module_id=34&action=CLASS_ID&action_id=#attributes.lesson_id#&asset_cat_id=-6&action_type=0</cfoutput>','page')"><cf_get_lang dictionary_id='44630.Ekle'></a>
                    </div>
                </cf_box>
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='57467.Not'></a>
                            </span>
                        </div>
                    </div>
                    <div class="protein-table training_items">
                        <table style="table-layout: fixed;">
                            <tbody>
                                <!--- <cfoutput query="get_content">
                                    <tr>
                                        <td style="word-wrap: break-word;white-space: normal;">
                                            
                                        </td>
                                    </tr>
                                </cfoutput> --->
                            </tbody>
                        </table>
                    </div>
                    <div class="training_items_bottom_btn d-flex flex-end">
                        <a href="javascript://" style="color:#d03232"><cf_get_lang dictionary_id='57461.Kaydet'></a>
                    </div>
                </cf_box>
            </div>
            <div class="col col-4 col-md-12 col-sm-12 col-xs-12">
                <cf_box class="clever" scroll="0">
                    <div class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span>
                                <a href="javascript://"><cf_get_lang dictionary_id='63643.Ödevler'> - <cf_get_lang dictionary_id='63644.Çalışmalar'></a>
                            </span>
                        </div>
                    </div>
                    <cfoutput query="GET_HOMEWORK" maxrows="5">
                        <div class="protein-table training_items" style="border-bottom: 2px dashed ##eee; padding:10px 0 10px 0;">
                            <div class="homewrk">
                                #homework# 
                            </div>
                            <div class="homewrk_class">
                                <cfset class = cfc3.GET_CLASS_F(class_id: lesson_id)>
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
                                <cfloop query="get_class_attenders_by_id">
                                    <cfif get_class_attenders_by_id.emp_id eq session.ep.userid>
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
                                            <a href="javascript://" style="color:##d03232;" onclick="openBoxDraggable('#request.self#?fuseaction=training.lesson&lesson_id=#attributes.lesson_id#&homework_id=#GET_HOMEWORK.homework_id#&event=addHomeworkAnswer','add_answer_box','ui-draggable-box-medium')">
                                                <cf_get_lang dictionary_id='44630.Ekle'>
                                            </a>
                                        </cfif>
                                    </cfif>
                                </cfloop>
                            </div>
                        </div>
                    </cfoutput>
                    <div class="training_items_bottom_btn">
                        <a href="javascript://">> <cf_get_lang dictionary_id='31140.Tüm'> <cf_get_lang dictionary_id='63643.Ödevler'></a>
                    </div>
                </cf_box>
            </div>
        </div>
        <cfelse>
            <cf_box>
                <p class="text"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></p>
            </cf_box>
        </cfif>
    </div>
    <!--- Yan Taraf --->
    <div class="col col-3 col-md-12 col-sm-12 col-xs-12" style="margin-top:-5px">
        <cfinclude template="list_lessons_detail_trainers.cfm"> <!--- Eğitimciler --->
        <cfinclude template="list_lessons_detail_attenders.cfm"> <!--- Katılımcılar --->
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
<script type="text/javascript">
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.lesson&event=randomQuestion&lesson_id=#attributes.lesson_id#</cfoutput>', 'random_question');
</script>