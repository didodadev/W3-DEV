<cfif isdefined("attributes.content_maxrow") and isnumeric(attributes.content_maxrow)>
	<cfset main_max = attributes.content_maxrow>
<cfelse>
	<cfset main_max = 5>
</cfif>
<cfquery name="GET_CHAPTER_CONTENTS" datasource="#DSN#">
	SELECT <cfif len(main_max)>TOP #main_max#</cfif>
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,
		UFU.USER_FRIENDLY_URL,
		C.CONT_SUMMARY,
		C.PRIORITY,
		C.UPDATE_DATE,
		C.RECORD_DATE,
		C.CONTENT_PROPERTY_ID,
		C.USER_FRIENDLY_URL,
		CC.CONTENTCAT_ID,
		<cfif isdefined('attributes.is_list_category') and len(attributes.is_list_category)>
			CCAT.CONTENTCAT NAME,
		<cfelseif isDefined('attributes.is_list_chapter') and len(attributes.is_list_chapter)>
			CC.CHAPTER NAME,
		<cfelse>
			CP.NAME NAME,
		</cfif>
		C.CHAPTER_ID
	FROM
		CONTENT C
		OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'cntid' 
			AND UFU.ACTION_ID = C.CONTENT_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU,
		CONTENT_CAT CCAT,
		CONTENT_PROPERTY CP,
		CONTENT_CHAPTER CC
	WHERE
		C.CONTENT_PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND 
		CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND		
		C.CONTENT_STATUS = 1 AND 
		C.CHAPTER_ID = CC.CHAPTER_ID AND		
		<cfif isdefined("attributes.is_list_category") and len(attributes.is_list_category)>
		CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_list_category#"> AND
		</cfif>
		<cfif isdefined("attributes.is_list_chapter") and len(attributes.is_list_chapter)>
		CC.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_list_chapter#"> AND
		</cfif>
		<cfif isdefined("attributes.is_list_property") and len(attributes.is_list_property)>
		C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_list_property#"> AND
		</cfif>		
		<cfif isdefined("session.pp.company_category")>
			C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">)
		<cfelseif isdefined("session.ww.consumer_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
		<cfelseif isdefined("session.cp")>
			C.CAREER_VIEW = 1 AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">)
		<cfelse>
			C.INTERNET_VIEW = 1
		</cfif>
	ORDER BY
		C.UPDATE_DATE,
		C.RECORD_DATE
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_chapter_contents.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfset attributes.maxrows = main_max>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif get_chapter_contents.recordcount>	
		<cfif isdefined('attributes.cont_titles') and len(attributes.cont_titles)>
		<div class="container_title"><cfoutput>#attributes.cont_titles#</cfoutput></div>
		</cfif>
			<div class="d-flex flex-wrap list_chapter">		
				<cfoutput query="get_chapter_contents" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<div class="col-md-12 col-12">
						<div class="list_chapter_item">
						<cfif isdefined('attributes.is_cont_image') and attributes.is_cont_image eq 1>
							<cfquery name="GET_IMAGE" datasource="#DSN#">
								SELECT 
									CONTIMAGE_SMALL,
									IMAGE_SERVER_ID
								FROM 
									CONTENT_IMAGE 
								WHERE 
									CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#">  AND
									IMAGE_SIZE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_cont_image_type#">
							</cfquery>
							<div style="background-image: url('/documents/content/#get_image.contimage_small#');" class="list_chapter_item_img">
								<!--- <cf_get_server_file output_file="" output_server="#get_image.image_server_id#" output_type="0" image_width="#attributes.list_content_width#" image_height ="#attributes.list_content_height#" image_link="1" alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#"> --->
							</div>							
						</cfif>
						<div style="background-color:##e7f5ec" class="list_chapter_item_text">
							<cfif isdefined("attributes.is_cont_head") and attributes.is_cont_head eq 1>
								<div class="list_chapter_item_title">
									#cont_head#
								</div>
							</cfif>
							<cfif isdefined('attributes.is_cont_summary') and attributes.is_cont_summary eq 1>
								<div class="list_chapter_item_text">
									#cont_summary#
								</div>
							</cfif>
							<cfif isdefined('attributes.is_cont_continue') and attributes.is_cont_continue eq 1>								
								<div class="list_chapter_item_btn">
									<a href="#USER_FRIENDLY_URL#">daha fazla bilgi</a>
								</div>								
							</cfif>
						</div>
						</div>
					</div>
				</cfoutput>			
			</div>
</cfif>
	<script>
		$(function(){
			$('.list_chapter').slick({
				slidesToShow: 4,
				slidesToScroll: 1,
				dots:false,
				speed: 700,
				responsive: 
				[
					{
					breakpoint: 768,
					settings: {
						slidesToShow: 2
					}
					},
					{
					breakpoint: 480,
					settings: {
						slidesToShow: 1,
					}
					}
				]
			});
		})
	</script>