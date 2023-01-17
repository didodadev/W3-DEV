dateformat_style
    <cfinvoke component="V16.worknet.cfc.get_social_media" method="upd_social_media">
        <cfinvokeargument name="sid" value="#attributes.sid#">
        <cfinvokeargument name="dsn" value="#dsn#">
        <cfinvokeargument name="process_stage" value="#attributes.process_stage#">
    </cfinvoke>
    <cf_workcube_process 
                is_upd='1' 
                data_source='#dsn#' 
                old_process_line='0'
                process_stage='#attributes.process_stage#'
                record_member='#session.ep.userid#' 
                record_date='#now()#' 
                action_page='#request.self#?fuseaction=worknet.upd_social_media&sid=#attributes.sid#' 
                action_id='#attributes.sid#'>

	<script type="text/javascript">	
        window.location.href='<cfoutput>#request.self#?fuseaction=worknet.list_social_media&event=upd&sid=#attributes.sid#</cfoutput>';
    </script>
    
<cfelseif isdefined('attributes.is_delete')>
	<cfinvoke component="V16.worknet.cfc.get_social_media" method="delete_social_media">
        <cfinvokeargument name="sid" value="#attributes.sid#">
        <cfinvokeargument name="dsn" value="#dsn#">
    </cfinvoke>
    
	<script type="text/javascript">	
        window.location.href='<cfoutput>#request.self#?fuseaction=worknet.list_social_media</cfoutput>';
    </script>
</cfif>
<cfquery name="get_social_media_info"  datasource="#dsn#"> 
	SELECT 
    	SID, 
        SOCIAL_MEDIA_ID, 
        SOCIAL_MEDIA_CONTENT, 
        PUBLISH_DATE, 
        USER_NAME, 
        SITE, 
        RECORD_DATE, 
        UPDATE_EMP, 
        PROCESS_ROW_ID, 
        UPDATE_DATE, 
        COMMENT_URL, 
        USER_ID
    FROM 
    	SOCIAL_MEDIA_REPORT 
    WHERE 
    	SID = #attributes.sid#
</cfquery>
<cfquery name="get_social_media_comment" datasource="#dsn#">
	SELECT 
		SC.USER_NAME AS USER_NAME,
		SC.SOCIAL_MEDIA_COMMENT_CONTENT AS SOCIAL_MEDIA_COMMENT_CONTENT,
		SC.PUBLISH_DATE AS PUBLISH_DATE,
		SR.SITE AS SITE,
		SC.USER_ID AS USER_ID
	FROM 
		SOCIAL_MEDIA_COMMENT SC,SOCIAL_MEDIA_REPORT SR 
	WHERE 
		SC.SOCIAL_MEDIA_ID=SR.SOCIAL_MEDIA_ID
											 	AND
		SR.SID=#attributes.sid#
</cfquery>
<cfquery name="get_process_types" datasource="#dsn#">
	SELECT
		PTR.STAGE AS STAGE,
		PTR.PROCESS_ROW_ID AS ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%worknet.list_social_media%">
	ORDER BY
		ROW_ID ASC
</cfquery>
<style>
	.border{
		border: 1px solid #eef1f5;
		height: 1px;
		width: 100%;
		margin: 15px 0;
	}
</style>
<cf_catalystHeader>
<div class="row">
	<div class="col col-9 col-xs-12 uniqueRow">
    	<div class="row formContent">
            <cfif get_social_media_info.SITE is 'youtube'>
                <div class="row ListContent">
                    <div class="col col-12">
                        <object style="height:490px; width: 440px;" align="top">
                            <param name="movie" value="http://www.youtube.com/v/<cfoutput>#get_social_media_info.SOCIAL_MEDIA_ID#</cfoutput>?version=3&feature=player_detailpage">
                            <param name="allowFullScreen" value="true">
                            <param name="allowScriptAccess" value="always">
                            <embed src="http://www.youtube.com/v/<cfoutput>#get_social_media_info.SOCIAL_MEDIA_ID#</cfoutput>?version=3&feature=player_detailpage" type="application/x-shockwave-flash" allowfullscreen="false" allowScriptAccess="always" width="540" height="200">
                        </object>
                    </div>
                </div>
            </cfif>
            <div class="row">
                <cfform name="upd_social_media" method="post" action="">
                    <input type="hidden" name="sid" id="sid" value="<cfoutput>#attributes.sid#</cfoutput>">
                    <cfoutput>
                        <div class="row">
                            <div class="col col-12">
                                <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
                                <cfif get_social_media_info.site is 'twitter'>
                                    <div class="pull-left margin-right-10">
										<div class="circleBox color-Twitter">
											<i class="fa fa-twitter"></i>
										</div>
									</div>
                                <cfelseif get_social_media_info.site is 'FRIENDFEED'>
                                     <div class="pull-left margin-right-10">
										<div class="circleBox color-B">
											<i class="fa fa-users"></i>
										</div>
									</div>
                                <cfelseif get_social_media_info.site is 'google plus'> 
                                     <div class="pull-left margin-right-10">
										<div class="circleBox color-GooglePlus">
											<i class="fa fa-google-plus"></i>
										</div>
									</div>
                                <cfelseif get_social_media_info.site is 'facebook'> 
                                  	 <div class="pull-left margin-right-10">
										<div class="circleBox color-Facebook">
											<i class="fa fa-facebook"></i>
										</div>
									</div>
                                <cfelseif get_social_media_info.site is 'youtube'> 
                                     <div class="pull-left margin-right-10">
										<div class="circleBox color-YouTube">
											<i class="fa fa-youtube"></i>
										</div>
									</div>	
                                </cfif>
                                <cfif len(get_social_media_info.COMMENT_URL)><p><a href="#get_social_media_info.COMMENT_URL#" target="_blank">#get_social_media_info.COMMENT_URL#</a><br /></cfif>#get_social_media_info.SOCIAL_MEDIA_CONTENT#</p>
                            </div>
                        </div>
                        <div class="border"></div>
                        <div class="row">
                            <label class="col col-2 col-md-4 col-sm-6 col-xs-6 bold"><cf_get_lang no="84 .yayin tarihi"></label>
                            <div class="col col-10 col-md-8 col-sm-6 col-xs-6">#dateformat(get_social_media_info.publish_date,dateformat_style)#</div>
                        </div>
                        <div class="row">
                            <label class="col col-2 col-md-4 col-xs-6 bold"><cf_get_lang_main no="139 .kullanici adi"></label>
                            <div class="col col-10 col-md-8 col-xs-6">
                                <cfif get_social_media_info.SITE eq 'twitter'>
                                    <a href="http://twitter.com/#get_social_media_info.USER_NAME#" class="tableyazi">
                                <cfelseif get_social_media_info.SITE eq 'friendfeed'> 
                                    <a href="https://friendfeed.com/#get_social_media_info.USER_ID#" class="tableyazi"> 
                                <cfelseif get_social_media_info.SITE eq 'facebook'>  
                                    <a href="http://www.facebook.com/#get_social_media_info.USER_ID#" class="tableyazi"> 
                                <cfelseif get_social_media_info.SITE eq 'google plus'> 
                                    <a href="https://plus.google.com/#get_social_media_info.USER_ID#" class="tableyazi">
                                <cfelseif get_social_media_info.SITE eq 'youtube'>
                                    <a href="https://www.youtube.com/#get_social_media_info.USER_ID#" class="tableyazi">
                                </cfif>#get_social_media_info.USER_NAME#</a>
                            </div>
                        </div>
                        <cfif len(get_social_media_info.update_emp)>
                            <div class="row">
                                <label class="col col-2 col-md-4 col-sm-6 col-xs-12 bold"><cf_get_lang_main no='291.Güncelleme'></label>
                                <div class="col col-10 col-md-8 col-sm-6 col-xs-12">
                                    #get_emp_info(get_social_media_info.update_emp,0,0)#&nbsp;#dateformat(get_social_media_info.update_date,"dd/mm/yyyy")#
                                </div>
                            </div>
                        </cfif>
                        <div class="row formContentFooter socialFooter" >	
							<div class="col col-12 form-inline">
                           		<div class="form-group">
									<div class="input-group">
										<cf_workcube_process is_upd='0' select_value='#get_social_media_info.process_row_id#' process_cat_width='90' is_detail='1'>   
									</div>
								</div>
								<div class="form-group text-right">
									<cfif get_social_media_info.SITE is 'facebook'> 
											<input type="button" class="btn red-pink" value="<cf_get_lang_main no='1744.Cevapla'>" name="answer" id="answer" onclick="face_go()">
										<cfelseif get_social_media_info.SITE is 'FRIENDFEED'>
											<input type="button" class="btn red-pink" value="<cf_get_lang_main no='1744.Cevapla'>" name="answer" id="answer" onclick="friend_go()">
										<cfelseif get_social_media_info.SITE is 'GOOGLE PLUS'>
											<input type="button" class="btn red-pink" value="<cf_get_lang_main no='1744.Cevapla'>" name="answer" id="answer" onclick="googlep_go()">
										<cfelseif get_social_media_info.SITE is 'youtube'>
											<input type="button" class="btn red-pink" value="<cf_get_lang_main no='1744.Cevapla'>" name="answer" id="answer" onclick="youtube_go()">
										<cfelse>
											<input type="button" class="btn red-pink" name="answer" id="answer" value="<cf_get_lang_main no='1744.Cevapla'>"  onClick="windowopen('#request.self#?fuseaction=worknet.popup_form_add_social_media_comment&sid=#attributes.sid#','small');">
									</cfif>
								</div>
								<div class="form-group">
                                    <cf_workcube_buttons is_upd='1' is_delete='0' delete_page_url='#request.self#?fuseaction=worknet.list_social_media&event=upd&sid=#attributes.sid#&is_delete=1'>
								</div>
                            </div>
                        </div>
                    </cfoutput>
                </cfform>
            </div>
     	</div>
        <div class="row">
            <cfif get_social_media_comment.recordcount neq 0>	
                <cf_box title="Yorumlar">
                    <cfoutput query="get_social_media_comment">
                        <div class="row">
                            <div class="row">
                                <label class="col col-12">#SOCIAL_MEDIA_COMMENT_CONTENT#</label>
                            </div>
                            <div class="row">
                                <label class="col col-2 col-md-4 col-sm-6 col-xs-6 bold"><cf_get_lang no="84 .yayin tarihi"></label>
                                <div class="col col-10 col-md-8 col-sm-6 col-xs-6">#dateformat(PUBLISH_DATE,dateformat_style)#</div>
                            </div>
                            <div class="row">
                                <label class="col col-2 col-md-4 col-sm-6 col-xs-6 bold"><cf_get_lang_main no="139 .kullanici adi"></label>
                                <div class="col col-10 col-md-8 col-sm-6 col-xs-6">
                                    <cfif SITE eq 'friendfeed' > 
                                        <a href="https://friendfeed.com/#USER_ID#" class="tableyazi" target="social_media_user" > 
                                    <cfelseif SITE eq 'facebook' >  
                                        <a href="http://www.facebook.com/#USER_ID#" class="tableyazi" target="social_media_user"> 
                                    <cfelseif SITE eq 'google plus'> 
                                        <a href="https://plus.google.com/#USER_ID#" class="tableyazi" target="social_media_user">
                                    <cfelseif SITE eq 'youtube'>
                                        <a href="http://www.youtube.com/#USER_ID#" class="tableyazi" target="social_media_user">
                                    </cfif>#USER_NAME#</a>
                                </div>
                            </div>
                            <div class="border"></div>
                        </div>
                    </cfoutput>
                </cf_box> 
            </cfif>
        </div>
    </div>
    <div class="col col-3 col-xs-12 uniqueRow">
		<cfif get_social_media_info.SITE is 'youtube'> 
			<cf_get_workcube_note action_section='social_media' action_id="#attributes.sid#">
			<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-23" module_id='37' action_section='social_media' action_id='#attributes.sid#'>
		</cfif>
    </div>
</div>
<script type="text/javascript">                              
    function face_go()
    {
        <cfif  #get_social_media_info.SITE# EQ 'facebook'>
        window.open('<cfoutput>http://www.facebook.com/#listgetat(get_social_media_info.SOCIAL_MEDIA_ID,2,'_')#</cfoutput>','');
        </cfif>
    }
    function friend_go()
    {
        window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
    }
    function googlep_go()
    {
        window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
    }
    function youtube_go()
    {
        window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
    }
</script>	
