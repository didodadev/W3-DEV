<cfif isdefined("attributes.content_maxrow") and isnumeric(attributes.content_maxrow)>
	<cfset main_max = attributes.content_maxrow>
<cfelse>
	<cfset main_max = 5>
</cfif>
<cfquery name="GET_VIDEOS" datasource="#DSN#">
	SELECT <cfif len(main_max)>TOP #main_max#</cfif>		
		ASSET.ASSET_ID,
		ASSET.ASSET_NAME,
		ASSET.ASSET_DETAIL,
		ASSET.ASSET_DESCRIPTION,
		ASSET.ASSET_FILE_NAME,		
		ASSET.UPDATE_DATE,
		ASSET.EMBEDCODE_URL,
		ASSET.RECORD_EMP,
		ASSET.RECORD_PUB,
		ASSET.RECORD_PAR,
		ASSET.ASSET_STAGE,
		ASSET.PROPERTY_ID,	
		ASSET.ASSETCAT_ID,
		ASSET.MODULE_NAME,
		ASSET.ACTION_SECTION,
		ASSET.PRODUCT_ID,
		ASSET.MAIL_CC_ID
	FROM 
		ASSET,
		ASSET_CAT
	WHERE		
		ASSET.IS_INTERNET = 1 AND 
		ASSET.EMBEDCODE_URL IS NOT NULL AND				
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID 		
		<cfif isdefined("attributes.is_asset_catid") and len(attributes.is_asset_catid)>
			AND ASSET_CAT.ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_asset_catid#" list="true">)
		</cfif>	
		<cfif isdefined("attributes.is_asset_type_id") and len(attributes.is_asset_type_id)>
			AND ASSET.PROPERTY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_asset_type_id#" list="true">)
		</cfif>	
		<cfif isdefined("attributes.product_id") and len(attributes.product_id) and listLen(attributes.product_id) eq 1>			
			AND ASSET.PRODUCT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#" list="yes">)
		</cfif>	
	ORDER BY
		ASSET.RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_videos.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfset attributes.maxrows = main_max>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfswitch expression="#attributes.is_video_theme#">
	<cfcase value="1">
		<cfif get_videos.recordcount>		
			<section>
				<div class="container_type3">					
					<div class="list_video">						
						<div class="list_video_animate" style="height: fit-content;">
							<cfoutput query="get_videos" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<div class="list_video_slide">								
									<div class="d-flex flex-wrap justify-content-center align-items-center">									
										<div class="col-lg-6 col-12">																					
											<!--- <iframe width="100%" height="250px" src="#embedcode_url#" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe> --->
											<div class="list_video_img" style="height:auto;">
												<img src="/documents/thumbnails/middle/#ASSET_FILE_NAME#" width="100%" style="height:auto;">
												<a href="#embedcode_url#" class="list_video_link" target="_blank">
													<i class="fab fa-youtube"></i>
												</a>
											</div> 
										</div>
										<div class="col-lg-6 col-12 py-4">
											<div class="list_video_text" style="height:auto;">
												<cfif isdefined("attributes.video_description") and attributes.video_description eq 1>
													<p>#ASSET_DESCRIPTION#</p>
												</cfif>
												<cfif isdefined("attributes.video_name") and attributes.video_name eq 1>
													<span>#asset_name#</span>
												</cfif>
												<cfif isdefined("attributes.is_content_outhor") and attributes.is_content_outhor eq 1>
													<em><cfif len(get_videos.RECORD_EMP)>
														#get_emp_info(get_videos.RECORD_EMP,0,0)#
													<cfelseif len(get_videos.RECORD_PUB)>
														#get_cons_info(get_videos.RECORD_PUB,0,0)#
													<cfelseif len(get_videos.RECORD_PAR)>
														#get_par_info(get_videos.RECORD_PAR,1,0,0)#			
													</cfif></em>
												</cfif>								
											</div>
										</div>								
									</div>							
								</div>
							</cfoutput>				
						</div>					
					</div>				
				</div>
			</section>		
		</cfif>
		<script>
			$(function(){
				$('.list_video_animate').slick({
					slidesToShow: 1,
					dots:false,
					infinite:false,
					speed: 700,
				});
			})
		</script>
	</cfcase>
	<cfcase value="2">
		<cfoutput>
			<cfif isDefined("attributes.video_block_title") and len(attributes.video_block_title)>
				<div class="list_video_head">
					#attributes.video_block_title#
				</div>
			</cfif>	
		</cfoutput>
		<div class="list_video list_video-type2">
			<cfoutput query="get_videos" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">								
				<div class="col-md-4 col-12">
					<div class="list_video_item">
						<div class="list_video_item_video">
							<!--- <iframe width="100%" height="200px" src="#embedcode_url#" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>																 --->
							<div style="background-image:url('/documents/thumbnails/middle/#ASSET_FILE_NAME#')" class="list_video_img">
								<a href="#embedcode_url#" class="list_video_link">
									<i class="fab fa-youtube"></i>
								</a>
							</div> 
						</div>
						<div class="list_video_item_text">
							#ASSET_DESCRIPTION#								
						</div>
						<div class="list_video_item_author">
							<cfif len(get_videos.MAIL_CC_ID)>
								#get_emp_info(get_videos.MAIL_CC_ID,0,0)#							
							<cfquery name="POSITION" datasource="#DSN#">
								SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_videos.MAIL_CC_ID#">
							</cfquery>
								<p>#POSITION.POSITION_NAME#</p>
							</cfif>								
						</div>
					</div>								
				</div>				
			</cfoutput>
		</div>
		<script>
			$(function(){
				$('.list_video-type2').slick({
					slidesToShow:3,
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
	</cfcase>
</cfswitch>

