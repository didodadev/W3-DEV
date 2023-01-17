<cfif get_chapter_news_5.recordcount>
    <cf_box class="clever" style="padding: 20px 30px; margin: -5px 1px;">
        <div class="portHeadLight">	
            <div class="portHeadLightTitle">
                <span>
                    <a href="javascript://"><cfoutput>#get_category.contentcat# / #get_chapter.chapter#</cfoutput></a>
                </span> 
            </div>
        </div>
            <div class="ui-info-text">
                <div class="blog_detail_content">
                    <cfoutput query="get_chapter_news_5">
                        <cfset get_chapter_news_img=getComponent.get_chapter_news_img(content_id:content_id)>
                        <cfif get_chapter_news_img.recordcount>
                            <div class="blog_item" style="box-shadow:none; border-bottom: 4px dashed ##ddd;">
                                <div class="blog_item_img">
                                    <img src="#file_web_path#content/#get_chapter_news_img.contimage_small#" style="height:100px!important">
                                </div>
                
                                <div class="blog_item_text" style="background-color:none; border-radius:none;">
                                    <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
                                    <p class="padding-bottom-5">#Left(cont_summary, 90)#...</p>
                                    <div class="blog_detail_bottom pl-0" style="border:none;padding-left:0!important">
                                        <cfset date = date_add('h',session.ep.time_zone,record_date)>
                                        <cfset member="#record_member#">
                                        <cfif len(update_date)>
                                            <cfset date = date_add('h',session.ep.time_zone,update_date)>
                                            <cfset member="#update_member#">
                                        </cfif>
                                        <div class="ui-row">
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <p class="title">
                                                    <i class="wrk-uF0002"></i> #get_emp_info(member,0,1)# -  #Dateformat(date,dateformat_style)# #Timeformat(date,timeformat_style)#
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <cfelse>
                            <div class="blog_item" style="box-shadow:none;border-bottom: 4px dashed ##ddd;">
                                <div class="blog_item_text" style="background-color:none;border-radius:none">
                                    <a class="title" href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
                                    <p class="padding-bottom-5">#Left(cont_summary, 90)#...</p>
                                    <div class="blog_detail_bottom pl-0" style="border:none;padding-left:0!important">
                                        <cfset date = date_add('h',session.ep.time_zone,record_date)>
                                        <cfset member="#record_member#">
                                        <cfif len(update_date)>
                                            <cfset date = date_add('h',session.ep.time_zone,update_date)>
                                            <cfset member="#update_member#">
                                        </cfif>
                                        <div class="ui-row">
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <p class="title">
                                                    <i class="wrk-uF0002"></i> #get_emp_info(member,0,1)# -  #Dateformat(date,dateformat_style)# #Timeformat(date,timeformat_style)#
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </cfoutput>
                </div>
            </div>
    </cf_box>
    <div class="blog_detail flex-col">
        
    </div>
<cfelse>
    <cf_box class="clever" style="padding: 20px 30px; margin: -5px 1px;">
        <div class="portHeadLight">	
            <div class="portHeadLightTitle">
                <span>
                    <a href="javascript://"><cfoutput>#getLang('','',57484)#</cfoutput></a>
                </span> 
            </div>
        </div>
        <div class="ui-info-text">
            <p><cf_get_lang dictionary_id='57484.No record'>!</p>
        </div>
    </cf_box>
</cfif>