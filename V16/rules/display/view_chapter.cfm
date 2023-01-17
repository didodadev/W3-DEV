<cfinclude template="../query/get_chapter_name.cfm">

<cfinclude template="rule_menu.cfm">  
<cfset getComponent = createObject('component','V16.rules.cfc.get_chapter_news')>
<cfset get_chapter_news_5 = getComponent.get_chapter_news(cont_pos_id:5)>
<cfset get_chapter_news_6 = getComponent.get_chapter_news(cont_pos_id:6)>
<cfset get_chapter_news_spot = getComponent.get_chapter_news(spot:1)>
<cfset get_chapter = getComponent.get_chapter(chapter_id:attributes.chapter_id)>
<cfset get_category = getComponent.get_category(category_id:attributes.contentcat_id)>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <div class="col col-2 col-xs-12">
        <cf_box class="clever" style="margin:-5px 1px!important">
            <ul class="menuDropdown lit_list">
                <div class="menuDropdownItem lit_list_item">
                    <cfinclude template="list_cat_chapter_home.cfm">
                </div>
            </ul>
        </cf_box>
    </div>

    <div id="forum" class="col col-7 col-md-7 col-sm-7 col-xs-12">
        <cfinclude template="chapter_news.cfm">
    </div>

    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
        <cfif get_chapter_news_spot.recordcount>
            <div class="flex-col" style="padding-bottom:5px;">
                <cf_box class="clever" style="padding: 20px 30px; margin: -5px 1px;">
                    <div class="ui-info-text blog_item_spot">
                        <cfoutput query="get_chapter_news_spot" maxrows="1">
                            <cfset get_chapter_spot_img=getComponent.get_chapter_news_img(content_id:content_id)>
                            <cfif get_chapter_spot_img.recordcount>
                                <div class="blog_item_img">
                                    <img src="#file_web_path#content/#get_chapter_spot_img.contimage_small#">
                                </div>
                            </cfif>
                            <div class="blog_item_text">
                                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
                                <p>#Left(cont_summary, 90)#...</p>
                            </div>
                        </cfoutput>
                    </div>
                </cf_box>
            </div>
        </cfif>
        <cfif get_chapter_news_6.recordcount>
            <cf_box class="clever" style="padding: 20px 30px; margin: -5px 1px;">
                <div class="ui-info-text">
                    <cfoutput query="get_chapter_news_6">
                        <div class="blog_item" style="box-shadow:none;border-bottom: 4px dashed ##ddd;">
                            <div class="blog_item_text" style="background-color:none;border-radius:none">
                                <a class="title" href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
                                <p> #Left(cont_summary, 90)#...</p>
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
                    </cfoutput>
                </div>
            </cf_box>	
            <cfelse>
                <cf_box class="clever" style="margin: -5px 1px;">
                    <div class="ui-infoitext">
                            <div class="blog_item_text">
                                <p class="title"><cf_get_lang dictionary_id='40487.Next to Section'> <cf_get_lang dictionary_id='57484.No record'>!</p>
                            </div>
                    </div>
                </cf_box>
        </cfif>
    </div>
</div>
