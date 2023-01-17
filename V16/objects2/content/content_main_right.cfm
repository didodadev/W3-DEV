<cfif isdefined("attributes.content_main_right_maxrow") and isnumeric(attributes.content_main_right_maxrow)>
	<cfset max_ = attributes.content_main_right_maxrow>
<cfelse>
	<cfset max_ = 5>
</cfif>
<cfquery name="GET_CONTENT_MAIN_RIGHTS" datasource="#DSN#" maxrows="#max_#">
	SELECT
		C.CONT_BODY,
		C.CONT_HEAD,
		C.CONTENT_ID,
		C.USER_FRIENDLY_URL,
		C.PRIORITY,
		C.CONT_SUMMARY
	FROM 
		CONTENT C,
		CONTENT_CAT CC,
		CONTENT_CHAPTER CH
	WHERE 	
		<cfif isdefined("url.chid")>
			CH.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chid#"> AND C.CONT_POSITION LIKE '%6%' AND 
		<cfelseif isdefined("url.cat_id")>
			CH.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cat_id#"> AND C.CONT_POSITION LIKE '%4%' AND
		<cfelse>
			C.CONT_POSITION LIKE '%2%' AND
		</cfif>
		C.STAGE_ID = -2 AND	
		C.SPOT <> 1 AND
		<cfif max_ eq 5>
			C.PRIORITY <> 0 AND
		</cfif>
		<cfif isdefined("attributes.content_main_right_maxrow") and isnumeric(attributes.content_main_right_maxrow) and isdefined('attributes.content_ids')>
			C.CONTENT_ID IN (#attributes.content_ids#) AND
		</cfif> 
		CH.CONTENTCAT_ID = CC.CONTENTCAT_ID  AND
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		<cfif isdefined("session.pp.company_category")>
			','+C.COMPANY_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
		<cfelseif isdefined("session.ww.consumer_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">) AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
		<cfelseif isdefined("session.cp")>
			CAREER_VIEW = 1 AND
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">) AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#">
		<cfelse>
			INTERNET_VIEW = 1  AND
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">) AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
		</cfif>
	ORDER BY 
    	C.PRIORITY ASC
</cfquery>

<cfif get_content_main_rights.recordcount>
	<table style="width:100%">
  		<cfoutput query="get_content_main_rights"> 
			<cfif isdefined("attributes.is_content_main_right_header") and attributes.is_content_main_right_header eq 1>
				<tr>
					<td class="headbold"><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="headbold" title="#cont_head#">#cont_head#</a></td>
				</tr>
			</cfif>
			<cfif isdefined("attributes.is_content_main_right_image") and attributes.is_content_main_right_image eq 1>
				<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
					SELECT CONTIMAGE_SMALL, IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#"> AND IMAGE_SIZE = 0
				</cfquery>
				<cfif get_image_cont.recordcount>
					<tr>
						<td><cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" image_width="75" imageheight="75" output_type="0" title="#cont_head#"></td>
					</tr>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.is_content_main_right_summary") and attributes.is_content_main_right_summary eq 1>
				<tr>		
					<td>#cont_summary#<br/><br/></td>	
				</tr>
			</cfif>
		</cfoutput>
	</table>
	<table><tr><td><br /></td></tr></table>
</cfif>
