<cfparam  name="attributes.cnt_relation_detail_page" default="">
<cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
	<cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
	<cfset session_base = evaluate('session.ww')>
<cfelse>
	<cfset session_base = evaluate('session.qq')>
</cfif> 
<cfquery name="GET_RIGHT_CONT" datasource="#DSN#">
	SELECT
		C.CONT_HEAD,
	   	C.CONTENT_ID,
	   	C.CONT_SUMMARY,
		C.CONT_BODY,		
		C.PRIORITY,
		UFU.USER_FRIENDLY_URL
	FROM 
		CONTENT_RELATION RC, 
       	CONTENT C
		OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'cntid' 
			AND UFU.ACTION_ID = c.CONTENT_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU,
	   	CONTENT_CHAPTER CH,
	  	CONTENT_CAT CC
	WHERE 
		C.CONTENT_STATUS = 1 AND
		C.CHAPTER_ID = CH.CHAPTER_ID AND
	  	CH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
	  	CC.CONTENTCAT_ID <> 0 AND
	  	STAGE_ID = -2 AND
	  	RC.ACTION_TYPE = 'CONTENT_ID' AND
		RC.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#"> AND
		RC.CONTENT_ID = C.CONTENT_ID AND
	  	<cfif isdefined("session.pp.company_category")>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			C.COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session_base.company_category#%"> AND
            CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">)
	  	<cfelseif isdefined("session.ww.company_category")>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			C.CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session_base.company_category#%"> AND
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">)
		<cfelseif isdefined("session.cp")>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			CAREER_VIEW = 1  AND
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">)
	  	<cfelse>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			INTERNET_VIEW = 1
	  	</cfif>
	ORDER BY
		C.RECORD_DATE DESC
</cfquery>
<cfif isdefined("attributes.list_content_width") and isnumeric(attributes.list_content_width)>
	<cfset my_image_width = attributes.list_content_width>
<cfelse>
	<cfset my_image_width = 350>
</cfif>
<cfif isdefined("attributes.list_content_height") and isnumeric(attributes.list_content_height)>
	<cfset my_image_height = attributes.list_content_height>
<cfelse>
	<cfset my_image_height = 200>
</cfif>
<cfif get_right_cont.recordcount>
	<cfif len(attributes.cnt_relation_cnt_maxrows)>
		<cfset cnt_relation_maxrows = #attributes.cnt_relation_cnt_maxrows#>
	<cfelse>
		<cfset cnt_relation_maxrows = ''>
	</cfif>
	<cfif attributes.cnt_relation_image_view eq 1>
		<div class="list_chapter-type2">
			<cfoutput query="get_right_cont" maxrows="#cnt_relation_maxrows#">
				<div class="list_chapter_item-type2" style="background-color:rgba(10,187,135,.1);">
					<cfquery name="GET_CONTENT_RELATION_IMAGE" datasource="#DSN#" maxrows="1">
						SELECT CONTIMAGE_SMALL, IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_right_cont.content_id#"> AND IMAGE_SIZE = 0
					</cfquery>
					<cfif get_content_relation_image.recordcount>
					<div class="list_chapter_item-type2_img" style="background-image:url('/documents/content/#get_content_relation_image.contimage_small#')"></div>
					</cfif>
					<cfif isDefined("attributes.cnt_relation_cnt_summary") and attributes.cnt_relation_cnt_summary eq 1>
						<div class="list_chapter_item-type2_text" style="border-bottom:1px solid rgba(0,0,0,.125);">
							<cfif isdefined("attributes.is_list_content_header") and attributes.is_list_content_header eq 1>
								<div class="list_chapter_item-type2_title">
									#cont_head#
								</div>											
							</cfif>	
							<p>#cont_summary#</p>
							<cfif isDefined("attributes.content_detail_page_btn") and attributes.content_detail_page_btn eq 1>
								<div class="list_chapter_item-type2_btn">
									<cfset detail_link = len(USER_FRIENDLY_URL)?"#USER_FRIENDLY_URL#":"#attributes.cnt_relation_detail_page#/#CONTENT_ID#">
									<a href="#site_language_path#/#detail_link#"><cf_get_lang dictionary_id='47032.More'></a>
								</div>
							</cfif>
						</div>
					</cfif>
				</div>
			</cfoutput>
		</div>
	<cfelse>
		<div class="list_chapter-type2">
			<cfoutput query="get_right_cont" maxrows="#cnt_relation_maxrows#">
				<div class="list_chapter_item-type2" style="background-color:rgba(10,187,135,.1);">
					<cfquery name="GET_CONTENT_RELATION_IMAGE" datasource="#DSN#" maxrows="1">
						SELECT CONTIMAGE_SMALL, IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_right_cont.content_id#"> AND IMAGE_SIZE = 0
					</cfquery>
					<cfif isdefined("attributes.cnt_relation_cnt_image") and attributes.cnt_relation_cnt_image eq 1 and get_content_relation_image.recordcount>
							<div class="list_chapter_item-type2_img" style="background:url('/documents/content/#get_content_relation_image.contimage_small#')"></div>
					</cfif>	
					<cfif isDefined("attributes.cnt_relation_cnt_summary") and attributes.cnt_relation_cnt_summary eq 1>
						<div class="list_chapter_item-type2_text" style="border-bottom:1px solid rgba(0,0,0,.125);">
							<p>#cont_summary#</p>
							<cfif isdefined("attributes.is_list_content_header") and attributes.is_list_content_header eq 1>
								<div class="list_chapter_item-type2_title">
									#cont_head#
								</div>											
							</cfif>
							<cfif isDefined("attributes.content_detail_page_btn") and attributes.content_detail_page_btn eq 1>
								<div class="list_chapter_item-type2_btn">
									<a href="#site_language_path#/#USER_FRIENDLY_URL#"><cf_get_lang dictionary_id='47032.More'></a>
								</div>
							</cfif>
						</div>
					</cfif>					
				</div>
			</cfoutput>
		</div>
	</cfif>
<cfelse>
	<cfset widget_live = "die">
</cfif>
<script>
	$('.list_chapter-type2').parent('.card-body').addClass('list_chapter-type2-card_body');
</script>
