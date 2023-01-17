<cfif isdefined("attributes.content_main_maxrow") and isnumeric(attributes.content_main_maxrow)>
	<cfset max_ = attributes.content_main_maxrow>
<cfelse>
	<cfset max_ = 5>
</cfif>
<cfquery name="GET_CONTENT" datasource="#DSN#" maxrows="#max_#">
	SELECT 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,
		C.USER_FRIENDLY_URL,
		C.CONT_SUMMARY,
		C.PRIORITY
	FROM 
		CONTENT_RELATION CCR,
		CONTENT C
	WHERE 
		CCR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		<cfif isdefined("session.pp.company_category")>
			C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
		<cfelseif isdefined("session.ww.consumer_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
		<cfelseif isdefined("session.cp")>
			C.CAREER_VIEW = 1  AND
		<cfelse>
			C.INTERNET_VIEW = 1  AND
		</cfif>     
		CCR.CONTENT_ID = C.CONTENT_ID AND
		CCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		CCR.ACTION_TYPE = 'CAMPAIGN_ID'
</cfquery>
<cfif get_content.recordcount>
	<cfoutput query="get_content">
		<table align="center" cellpadding="2" cellspacing="2" style="width:99%;">
			<cfif isdefined("attributes.is_content_main_image") and attributes.is_content_main_image eq 1>
				<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
					SELECT CONTIMAGE_SMALL, IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content.content_id#"> AND IMAGE_SIZE = 0
				</cfquery>
				<cfif get_image_cont.recordcount>
					<cfif isdefined("attributes.content_main_image_width") and len(attributes.content_main_image_width)>
						<cfset main_image_width = attributes.content_main_image_width>
					</cfif>
					<cfif isdefined("attributes.content_main_image_height") and len(attributes.content_main_image_height)>
						<cfset main_image_height = attributes.content_main_image_height>
					</cfif>
					<tr>
						<td rowspan="4" style="vertical-align:top;">
							<cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" image_width="#main_image_width#" image_height="#main_image_height#" output_type="0" alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#">
						</td>
					</tr>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.is_content_main_header") and attributes.is_content_main_header eq 1>
			<tr> 
				<td><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="headbold">#cont_head#</a></td>
			</tr>
			</cfif>
			<cfif isdefined("attributes.is_content_main_summary") and attributes.is_content_main_summary eq 1>
				<tr> 
					<td>#cont_summary#</td>
				</tr>
			</cfif>
			<cfif isdefined("attributes.is_content_main_body") and attributes.is_content_main_body eq 1>
				<tr> 
					<td>#cont_body#</td>
				</tr>
			</cfif>
			<cfif isdefined("attributes.is_content_devam") and attributes.is_content_devam eq 1>
				<tr> 
					<td><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="tableyazi"> <cf_get_lang_main no='714.Devam'></a><br/></td>
				</tr>
			</cfif>
		</table>
	</cfoutput>	
</cfif>
