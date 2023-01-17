<cfset intranet = createObject('component','cfc.intranet')>
<cfset forumCounts = intranet.forumCounts()>
<cfset lastReplys = intranet.lastReplys()>
<cfset trainingSec = intranet.trainingSec()>
<cf_xml_page_edit fuseact='rule.welcome'>
<cfset attributes.is_home = 1>
<!--- <link rel="stylesheet" href="/css/assets/template/intranet/intranet.css" type="text/css"> --->
<cfinclude template="rule_menu.cfm">
    <div id="forum" class="col col-4 col-md-4 col-sm-4 col-xs-12">
        <div class="blog_detail_margin_left">
            <div class="blog_detail flex-col">
                <div class="blog_detail_top"><h1 class="blog_detail_content_title"><cfoutput>#getLang('myhome','Taze İçerik',30779)#</cfoutput></h1></div>
                <div class="blog_detail_content">
                    <cfinclude template="spots.cfm">
                </div>
            </div>
        </div>
    </div>
    <div id="forum" class="col col-4 col-md-4 col-sm-4 col-xs-12">
        <div class="blog_detail flex-col">
            <div class="blog_detail_top"><h1 class="blog_detail_content_title" style="color:#009688!important"><cf_get_lang dictionary_id='63443.Güncel Tartışmalar'></h1></div>
            <div class="blog_detail_content">
                <div class="blog_count">
                    <div class="count_item">
                        <p><cfoutput>#forumCounts.forumCount#</cfoutput></p>
                        <span><cfoutput>#getLang('main','Forum',57421)#</cfoutput></span>
                    </div>
                    <div class="count_item">
                        <p><cfoutput>#forumCounts.topicCount#</cfoutput></p>
                        <span><cfoutput>#getLang('main','Konu',57480)#</cfoutput></span>
                    </div>
                    <div class="count_item">
                        <p><cfoutput>#forumCounts.replyCount#</cfoutput></p>   
                        <span><cfoutput>#getLang('main','Cevap',58654)#</cfoutput></span>
                    </div>
                </div> 
                <cfoutput query="lastReplys">
                    <div class="reply_item reply_item_extra">
                        <!--- <div class="reply_item_user">
                            <span class="color-#Left(EMPLOYEE_NAME, 1)#">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</span>
                        </div> --->
                        <p class="name">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# <span>#REC_DATE#</span></p>
                        <p class="text">#LEFT(REReplaceNoCase(REPLY, "<[^><]*>", '', 'ALL'),140)#...</p>
                        <a class="read_more" href="#request.self#?fuseaction=forum.view_topic&forumid=#FORUMID#"><i class="fa fa-lightbulb-o"></i>Fikrini Paylaş</a>
                        <!--- <p class="topic">#TOPIC#</p>   --->
                    </div>
                </cfoutput>
            </div>
        </div>
    </div>
    <div id="forum" class="col col-4 col-md-4 col-sm-4 col-xs-12">
        <div class="blog_detail_margin_right">
            <div class="blog_detail flex-col">
                <div class="blog_detail_top"><h1 class="blog_detail_content_title" style="color: #E91E63!important"><cfoutput>#getLang('training','Müfredat',46049)#</cfoutput></h1></div>
                <div class="blog_detail_content">              
                    <div class="blog_count">
                        <div class="count_item">
                            <p><cfoutput>#trainingSec.recordcount#</cfoutput></p>
                            <span><cfoutput>#getLang('main','Eğitim',57419)#</cfoutput></span>
                        </div>
                    </div>
                    <div class="training_fixed">
                    </div>
                    <cfoutput query="trainingSec">
                        <div class="blog_item" style="box-shadow:none; border-bottom: 3px dashed ##ddd;">
                            <div class="blog_item_text" style="background-color:none; border-radius:none;">
                                <a class="title" href="#request.self#?fuseaction=training.curriculum&event=det&train_id=#TRAIN_ID#">#TRAIN_HEAD#</a>
                                <p class="padding-bottom-5">#TRAIN_OBJECTIVE#</p>
                            </div>
                        </div>
                    </cfoutput>   
                </div>
            </div>
        </div>
    </div> 