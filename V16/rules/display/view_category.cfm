<cfinclude template="../query/get_cat_name.cfm">
<cfinclude template="rule_menu.cfm">
<!--- <div id="forum" class="col col-2 col-md-2 col-sm-4 col-xs-12">
	<!--- <cf_box><cfinclude template="search.cfm"></cf_box> --->
	<cfsavecontent variable="kategori">Kategori / Bölüm</cfsavecontent>
		<div class="blog_detail flex-col">
			<div class="blog_detail_top"><h1 class="blog_detail_content_title"><cfoutput>#kategori#</cfoutput></h1></div>
			<div class="blog_detail_content">
				<cfinclude template="list_cat_chapter_home.cfm">
			</div>
		</div>	
</div> --->
<div id="forum" class="col col-8 col-md-8 col-sm-8 col-xs-12">
	<div class="blog_detail flex-col">
		<div class="blog_detail_top"><h1 class="blog_detail_content_title"><cfoutput>#GET_CAT_NAME.CONTENTCAT#</cfoutput></h1></div>
		<div class="blog_detail_content">
			<cfinclude template="category_news.cfm">
		</div>
	</div>	
</div>
<div id="forum" class="col col-4 col-md-4 col-sm-4 col-xs-12">
	<cfset getComponent = createObject('component','V16.rules.cfc.get_chapter_news')>
	<cfset get_chapter_news_spot = getComponent.get_chapter_news(spot:1)>
	<cfif get_chapter_news_spot.recordcount>
		<cfoutput query="get_chapter_news_spot" maxrows="1">
			<div class="blog_item blog_item_spot">
				<div class="blog_item_img">
					<div class="spot"><cf_get_lang dictionary_id='32977.Spot'></div>
					<cfset get_chapter_spot_img=getComponent.get_chapter_news_img(content_id:content_id)>
					<cfif get_chapter_spot_img.recordcount>
						<img src="#file_web_path#content/#get_chapter_spot_img.contimage_small#">
					</cfif>
				</div>
				<div class="blog_item_text">
					<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
					<p>#Left(cont_summary, 90)#...</p>
				</div>
			</div>
		</cfoutput>
	<cfelse>
		<div class="blog_item">
			<div class="blog_item_text">
				<p class="title"><cf_get_lang dictionary_id='32977.Spot'> <cf_get_lang dictionary_id='57484.No record'>!</p>
			</div>
		</div>
	</cfif>
	<div class="blog_detail flex-col blog_detail_reply">
		<h1>İlişkili İçerikler</h1>
		<cfset get_chapter_news_4 = getComponent.get_chapter_news(cont_pos_id:4)>
        <cfif get_chapter_news_4.recordcount>
            <cfoutput query="get_chapter_news_4">
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
        <cfelse>
            <div class="blog_item" style="box-shadow:none;border-bottom: 4px dashed ##ddd;">
                <div class="blog_item_text" style="background-color:none;border-radius:none">
                    <p class="title">Kategori Yanı Kayıt Yok!</p>
                </div>
            </div>
               
        </cfif>
    </div>	
</div>
			
	
		
