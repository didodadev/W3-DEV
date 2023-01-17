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
<cfif isdefined("attributes.list_start_date") and isdate(attributes.list_start_date)>
	<cf_date tarih = "attributes.list_start_date">
</cfif>
<cfif isdefined("attributes.list_finish_date") and isdate(attributes.list_finish_date)>
	<cf_date tarih = "attributes.list_finish_date">
</cfif>
<cfif isdefined("attributes.list_content_maxrow") and isnumeric(attributes.list_content_maxrow)>
	<cfset max_ = attributes.list_content_maxrow>
<cfelse>
	<cfset max_ = 5>
</cfif>
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
<cfquery name="GET_CONTENT_LIST" datasource="#DSN#">
	SELECT <cfif len(max_)>TOP #max_#</cfif>
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,		
		C.CONT_SUMMARY,
		C.PRIORITY,
		C.RECORD_DATE,
		C.RECORD_MEMBER,
		C.UPDATE_MEMBER,
		C.UPDATE_DATE,
		OUTHOR_EMP_ID,
		OUTHOR_CONS_ID,
		OUTHOR_PAR_ID,
        CC.CHAPTER,
		CCAT.CONTENTCAT_ID,
		UFU.USER_FRIENDLY_URL
	FROM 
		CONTENT AS C
		OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'cntid' 
			AND UFU.ACTION_ID = c.CONTENT_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU, 
		CONTENT_CHAPTER AS CC,
		<cfif isdefined('attributes.header') and len(attributes.header)>
			META_DESCRIPTIONS MD,
		</cfif>
		CONTENT_CAT AS CCAT
	WHERE
		<cfif isdefined("attributes.list_start_date") and len(attributes.list_start_date)>
			C.VIEW_DATE_START >= #createodbcdatetime(attributes.list_start_date)# AND 
		</cfif>
		<cfif isdefined("attributes.list_finish_date") and len(attributes.list_finish_date)>
			C.VIEW_DATE_FINISH <= #createodbcdatetime(attributes.list_finish_date)# AND
		</cfif>
		<cfif isdefined("attributes.list_content_cat_id") and len(attributes.list_content_cat_id)>
			CC.CONTENTCAT_ID IN (<cfqueryparam value="#attributes.list_content_cat_id#" cfsqltype="cf_sql_integer" list="true">) AND
		</cfif>
		<cfif isdefined("attributes.list_content_chapter_id") and len(attributes.list_content_chapter_id)>
			CC.CHAPTER_ID IN (<cfqueryparam value="#attributes.list_content_chapter_id#" cfsqltype="cf_sql_integer" list="true">) AND
		</cfif>
		<cfif isdefined("attributes.list_content_type_id") and len(attributes.list_content_type_id)>
			C.CONTENT_PROPERTY_ID IN (<cfqueryparam value="#attributes.list_content_type_id#" cfsqltype="cf_sql_integer" list="true">) AND
		</cfif>
		<cfif isdefined("url.cat_id") and len(url.cat_id)>
			CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cat_id#"> AND
		</cfif>
		<cfif isdefined("url.chid") and len(url.chid)>
			C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chid#"> AND
		</cfif>
		<cfif isdefined('attributes.header') and len(attributes.header)>
			C.CONTENT_ID = MD.ACTION_ID AND
			MD.ACTION_TYPE = 'CONTENT_ID' AND
			','+MD.META_KEYWORDS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.header#%"> AND
		</cfif>
		C.STAGE_ID = -2 AND	 
		C.CONTENT_STATUS = 1 AND
		INTERNET_VIEW = 1 AND
		C.CHAPTER_ID = CC.CHAPTER_ID AND 
		CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND		
		<cfif isDefined("attributes.is_contents_area") and attributes.is_contents_area eq 1>
			C.CONT_POSITION LIKE '%1%' AND
		</cfif>
		<cfif isDefined("attributes.is_contents_area") and attributes.is_contents_area eq 2>
			C.SPOT = 1 AND
		</cfif>
		<cfif isDefined("attributes.is_contents_area") and attributes.is_contents_area eq 3>
			C.CONT_POSITION LIKE '%3%' AND
		</cfif>
		<cfif isDefined("attributes.is_contents_area") and attributes.is_contents_area eq 4>
			C.CONT_POSITION LIKE '%5%' AND
		</cfif>
		<cfif isDefined("attributes.is_contents_area") and attributes.is_contents_area eq 5>
			C.CONT_POSITION LIKE '%4%' AND
		</cfif>
		<cfif isDefined("attributes.is_contents_area") and attributes.is_contents_area eq 6>
			C.CONT_POSITION LIKE '%6%' AND
		</cfif>
		<cfif isdefined("session.pp.company_category")>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			','+C.COMPANY_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session_base.company_category#%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">)
		<cfelseif isdefined("session.ww.consumer_category")>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			','+C.CONSUMER_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session_base.consumer_category#%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
		<cfelseif isdefined("session.cp")>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			C.CAREER_VIEW = 1 AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">)
		<cfelse>
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND			
		</cfif>
		1 = 1
	ORDER BY 
		<cfif isdefined('attributes.is_content_main_sort') and attributes.is_content_main_sort eq 1>
			C.UPDATE_DATE DESC,
			C.PRIORITY
		<cfelse>
			C.RECORD_DATE DESC
		</cfif>
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_content_list.recordcount#'>
<cfparam name="attributes.page" default='1'>
<!---<cfparam name="attributes.maxrows" default='#max_#'>--->
<cfset attributes.maxrows = max_>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif get_content_list.recordcount>
	<cfif isdefined("attributes.type_content") and attributes.type_content eq 1>
		<div class="list_content">
			<cfoutput query="get_content_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">								
				<div class="col-lg-4 col-md-6 col-12">
					<div class="card list_content_item">
						<cfif isdefined("attributes.is_list_content_image") and attributes.is_list_content_image eq 1>
							<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
								SELECT CONTIMAGE_SMALL,IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_list.content_id#"> AND IMAGE_SIZE = 0
							</cfquery>
							<cfif get_image_cont.recordcount>

									<img class="card-img-top" src="/documents/content/#get_image_cont.contimage_small#" style="max-width:#my_image_width#; max-height:#my_image_height#;">	<!--- <cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" image_width="#my_image_width#" image_height="#my_image_height#" output_type="0" alt="#getLang('main',668)#" title="#getLang('main',668)#"> --->
							
							</cfif>
						</cfif>
						<div class="card-body px-0" style="max-width:#my_image_width#;">
						<cfif isdefined("attributes.is_list_content_header") and attributes.is_list_content_header eq 1>
							<div class="list_content_item_title">
								#cont_head#
							</div>
						</cfif>
						<cfif isdefined("attributes.is_list_content_summary") and attributes.is_list_content_summary eq 1>
							<div class="list_content_item_text" id="list_content_item_text">									
								<cfset cont_sum= left(cont_summary,400)> 
								<p>#cont_sum#...</p> 
							</div>
						</cfif>							
						<cfif isdefined("attributes.is_list_content_continue") and attributes.is_list_content_continue eq 1>
							<div class="list_content_item_btn">									
								<a href="#USER_FRIENDLY_URL#"><cf_get_lang dictionary_id='47032.More'></a>																
							</div>
						</cfif>						
						<cfif isdefined("attributes.is_list_content_record_info") and attributes.is_list_content_record_info eq 1>
							<div class="list_content_record_member">
								<cfif len(update_member)>#dateformat(record_date,'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,update_date),'HH:MM')#) - #get_emp_info(update_member,0,0)#<cfelse>#dateformat(record_date,'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,record_date),'HH:MM')#) - #get_emp_info(record_member,0,0)#</cfif>
							</div>
						</cfif>
					</div>
					</div>
				</div>				
			</cfoutput>
		</div>
	<cfelseif isdefined("attributes.type_content") and attributes.type_content eq 2>
		<div class="list_content list_content-type2 ">
			<cfoutput query="get_content_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">								
				<div class="col-md-4 col-12">
					<div class="list_content_item">
						<cfif isdefined("attributes.is_list_content_image") and attributes.is_list_content_image eq 1>
							<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
								SELECT CONTIMAGE_SMALL,IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_list.content_id#"> AND IMAGE_SIZE = 0
							</cfquery>
							<cfif get_image_cont.recordcount>
								<div class="list_content_item_img">
									<img src="/documents/content/#get_image_cont.contimage_small#" style="width:#my_image_width#; height:#my_image_height#;">	<!--- <cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" image_width="#my_image_width#" image_height="#my_image_height#" output_type="0" alt="#getLang('main',668)#" title="#getLang('main',668)#"> --->
								</div>
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_list_content_header") and attributes.is_list_content_header eq 1>
							<div class="list_content_item_title">
								#cont_head#
							</div>
						</cfif>
						<cfif isdefined("attributes.is_list_content_summary") and attributes.is_list_content_summary eq 1>
							<div class="list_content_item_text" id="list_content_item_text">									
								<cfset cont_sum= left(cont_summary,400)> 
								<p>#cont_sum#...</p> 
							</div>
						</cfif>							
						<cfif isdefined("attributes.is_list_content_continue") and attributes.is_list_content_continue eq 1>
							<div class="list_content_item_btn">								
								<a href="#USER_FRIENDLY_URL#"><cf_get_lang dictionary_id='47032.More'></a>																
							</div>
						</cfif>						
						<cfif isdefined("attributes.is_list_content_record_info") and attributes.is_list_content_record_info eq 1>
							<div class="list_content_record_member">
								<cfif len(update_member)>#dateformat(record_date,'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,update_date),'HH:MM')#) - #get_emp_info(update_member,0,0)#<cfelse>#dateformat(record_date,'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,record_date),'HH:MM')#) - #get_emp_info(record_member,0,0)#</cfif>
							</div>
						</cfif>
					</div>
				</div>				
			</cfoutput>
		</div>
	<cfelse>
		<div class="list_content list_content-type3">
			<cfoutput query="get_content_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">								
				<div class="col-md-6 col-12">
					<div class="list_content_item">
						<cfif isdefined("attributes.is_list_content_image") and attributes.is_list_content_image eq 1>
							<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
								SELECT CONTIMAGE_SMALL,IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_list.content_id#"> AND IMAGE_SIZE = 0
							</cfquery>
							<cfif get_image_cont.recordcount>
								<div style="background-image: url('/documents/content/#GET_IMAGE_CONT.contimage_small#');" class="list_content_item_img"></div>
							</cfif>
						</cfif>
						<cfif isdefined("attributes.is_list_content_header") and attributes.is_list_content_header eq 1>
							<div class="list_content_item_title">
								#cont_head#
							</div>
						</cfif>
						<cfif isdefined("attributes.is_list_content_summary") and attributes.is_list_content_summary eq 1>
							<div class="list_content_item_text" id="list_content_item_text">									
								<cfset cont_sum= left(cont_summary,400)> 
								<p>#cont_sum#...</p> 
							</div>
						</cfif>							
						<cfif isdefined("attributes.is_list_content_continue") and attributes.is_list_content_continue eq 1>
							<div class="list_content_item_btn3">															
								<a href="#USER_FRIENDLY_URL#"><i class="fas fa-caret-right"></i><cf_get_lang dictionary_id='47032.More'></a>																
							</div>
						</cfif>						
						<cfif isdefined("attributes.is_list_content_record_info") and attributes.is_list_content_record_info eq 1>
							<div class="list_content_record_member">
								<cfif len(update_member)>#dateformat(record_date,'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,update_date),'HH:MM')#) - #get_emp_info(update_member,0,0)#<cfelse>#dateformat(record_date,'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,record_date),'HH:MM')#) - #get_emp_info(record_member,0,0)#</cfif>
							</div>
						</cfif>
					</div>
				</div>				
			</cfoutput>
		</div>
	</cfif>
</cfif>

<script>
	$(function(){
		$('.list_content-type3').slick({
			slidesToShow: 2,
			slidesToScroll: 1,
			dots:false,
			speed: 700,
			responsive: 
			[
				{
				breakpoint: 821, //820 breakpoint for iPad Air tablet
				settings: {
					slidesToShow: 1
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