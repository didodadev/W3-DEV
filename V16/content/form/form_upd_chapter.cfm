<cfquery name="GET_CHAPTER" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID,
		#dsn#.Get_Dynamic_Language(CONTENTCAT_ID,'#session.ep.language#','CONTENT_CHAPTER','CHAPTER',NULL,NULL,CHAPTER) AS CHAPTER,
		CHAPTER_ID,
		CONTENT_CHAPTER_STATUS,
		HIERARCHY,
		CHAPTER_IMAGE1,
		SERVER_ID1,
		CHAPTER_IMAGE2,
		SERVER_ID2,
		RECORD_DATE,
		RECORD_MEMBER,
        UPDATE_EMP,
        UPDATE_DATE
	FROM 
		CONTENT_CHAPTER 
	WHERE 
		CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chapter_id#">
</cfquery>
<cfset attributes.contentcat_id = get_chapter.contentcat_id>
<cfquery name="CHAPTER_LIST" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID,
		HIERARCHY,
		CHAPTER
	FROM 
		CONTENT_CHAPTER 
	WHERE 
		CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter.contentcat_id#">
	ORDER BY 
		HIERARCHY 
</cfquery>
<cfinclude template="../query/get_content_cat_name.cfm">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='50582.İçerik Bölümü'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#title# : #get_chapter.chapter#" add_href="#request.self#?fuseaction=content.add_form_chapter" is_blank="0">
        <cfform name="form_chapter" action="#request.self#?fuseaction=content.emptypopup_upd_chapter" method="post" enctype="multipart/form-data">
            <input type="Hidden" name="chapter_id" id="chapter_id" value="<cfoutput>#get_chapter.chapter_id#</cfoutput>">
            <input type="Hidden" name="public_image" id="public_image">
            <input type="Hidden" name="public_image1" id="public_image1">
            <cf_box_elements>
                <div class="col col-5 col-xs-12"> 
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                        <label class="col col-6 col-md-6 col-sm-12 col-xs-12"><input type="checkbox" name="content_chapter_status" id="content_chapter_status" <cfif get_chapter.content_chapter_status eq 0>checked</cfif>><cf_get_lang dictionary_id='57494.Pasif'> </label>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="old_contentcat_id" id="old_contentcat_id" value="<cfoutput>#get_chapter.contentcat_id#</cfoutput>">
                                <input type="hidden" name="contentcat_id" id="contentcat_id" value="">
                                <input type="hidden" name="old_hierarchy" id="old_hierarchy" value="<cfoutput>#get_chapter.hierarchy#</cfoutput>">
                                <input type="hidden" name="hierarchy" id="hierarchy" value="">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57486.Kategori'>/<cf_get_lang dictionary_id='57761.Hiyerarşi'></cfsavecontent>
                                <cfinput type="text" name="contentcat_name" id="contentcat_name" value="#get_content_cat_name.contentcat#" readonly required="yes" message="#message#" style="width:200px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=content.popup_list_hierarchy</cfoutput>&hierarchy=form_chapter.hierarchy&id=form_chapter.contentcat_id&alan=form_chapter.contentcat_name','list');"></span>
                            </div>
                        </div>
                    </div> 	
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12" style="vertical-align:baseline"><cf_get_lang dictionary_id='50564.Üst Bölümler'></label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <cfinclude template="chapter_upd.cfm">
                        </div>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57995.Bölüm'></cfsavecontent>
                                <cfif len(get_chapter.chapter)>
                                    <cfinput type="text" name="chapter_name" id="chapter_name" value="#get_chapter.chapter#" style="width:200px;" required="yes" message="#message#" maxlength="50">
                                <cfelse>
                                    <cfinput type="text" name="chapter_name" id="chapter_name" value="" style="width:200px;" required="yes" message="#message#" maxlength="50">
                                </cfif>
                                <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="CONTENT_CHAPTER" 
                                        column_name="CHAPTER" 
                                        column_id_value="#get_chapter.chapter_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="CHAPTER_ID" 
                                        control_type="0">
                                </span>      
                            </div>
                        </div>
                    </div> 
                    <div class="form-group">
                        <div class="col col-3 col-xs-12"><label><cf_get_lang dictionary_id='30253.Kullanıcı Dostu URL'></label></div>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <cf_publishing_settings fuseaction="content.upd_chapter" event="det" action_type="CHAPTER_ID" action_id="#url.chapter_id#">
                        </div>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'> 1</label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <cfif not len(get_chapter.chapter_image1)>
                                <cf_get_lang dictionary_id='50512.Bölüm Banneri Yok'><br />
                            <cfelse>
                                <cfoutput>                   		  
                                    <cf_get_server_file output_file="content/chapter/#get_chapter.chapter_image1#" output_server="#get_chapter.server_id1#" output_type="0" image_link="1" alt="#getLang('content',6)#" title="#getLang('content',6)#">
                                </cfoutput>
                            </cfif>
                            <input type="hidden" name="image1_old" id="image1_old" value="<cfoutput>#get_chapter.chapter_image1#</cfoutput>">
                            <input type="hidden" name="image1_old_server_id" id="image1_old_server_id" value="<cfoutput>#get_chapter.server_id1#</cfoutput>">
                            <input type="File" name="image1" id="image1"  style="width:200px;">
                        </div>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'> 2</label>
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                            <cfif not len(get_chapter.chapter_image2)>
                                <cf_get_lang dictionary_id='50512.Bölüm Banneri Yok'><br/>
                            <cfelse>
                                <cfoutput>
                                <cf_get_server_file output_file="content/chapter/#get_chapter.chapter_image2#" output_server="#get_chapter.server_id2#" output_type="0" image_link="1" alt="#getLang('content',6)#" title="#getLang('content',6)#">
                                </cfoutput> 
                            </cfif>
                            <input type="hidden" name="image2_old" id="image2_old" value="<cfoutput>#get_chapter.chapter_image2#</cfoutput>">
                            <input type="hidden" name="image2_old_server_id" id="image2_old_server_id" value="<cfoutput>#get_chapter.server_id2#</cfoutput>">
                            <input type="File" name="image2" id="image2" style="width:200px;">
                        </div>
                    </div>
                </div> 
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_chapter" record_emp="record_member">
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=content.emptypopup_del_chapter&chapter_id=#chapter_id#&head=#get_chapter.chapter#&cat=#get_chapter.contentcat_id#'> <!---add_function='control()'--->
            </cf_box_footer>
        </cfform> 
    </cf_box>
</div>