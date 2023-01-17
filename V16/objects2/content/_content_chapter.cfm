<cfquery name="GET_CONTENT" DATASOURCE="#DSN#" maxrows="5"> 
	SELECT DISTINCT
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,
		C.USER_FRIENDLY_URL,
		C.CONT_SUMMARY, 
		CH.HIT CH_HIT 		
	FROM
		CONTENT C, 
		CONTENT_CHAPTER CH,
		CONTENT_CAT CCAT	 
	WHERE 
		C.STAGE_ID = -2 AND 
		C.CONTENT_STATUS = 1 AND
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		C.CONT_POSITION LIKE '%5%' AND 
		CH.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chid#"> AND 
		C.NONE_TREE = 0 AND 
		CH.CONTENTCAT_ID = CCAT.CONTENTCAT_ID AND 
		<cfif isdefined("session.pp.company_category")>
			C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">)
		<cfelseif isdefined("session.ww.company_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.company_category#,%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
		<cfelseif isdefined("session.cp")>
			CAREER_VIEW = 1 AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">)
		<cfelse>
			INTERNET_VIEW = 1  AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
		</cfif>
	ORDER BY 
		C.CONTENT_ID DESC
</cfquery>	
	
<cfif get_content.recordcount eq 1>
	<cfoutput query="get_content"> 
		<table width="100%">
			<tr>			
				<td class="headbold">#cont_head#</td>
			</tr>
			<tr>			
				<td colspan="2" class="formbold">#cont_summary#</td>
			</tr>		
			<cfset url.cid = get_content.content_id>
			<cfset attributes.cid = get_content.content_id>
			<tr>
				<td><cfloop list="#employee_url#" delimiters=";" index="mm">
						#replace(cont_body,"src=""http://#mm#","src=""")#
					</cfloop>
				</td>
			</tr>
		</table>	
	</cfoutput>
<cfelse>
	<cfoutput query="get_content"> 
		<table width="100%">
			<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
				SELECT CONTIMAGE_SMALL, IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content.content_id#"> AND IMAGE_SIZE = 0
			</cfquery>
			<cfif get_image_cont.recordcount>
			<tr>
				<td rowspan="4" valign="top">
					<cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" image_width="75" imageheight="75" output_type="0" alt="#getLang('main',668)#" title="#getLang('main',668)#">
				</td>
			</tr>
			</cfif>
			<tr>			
				<td class="headbold">#cont_head#</td>
			</tr>
			<tr>			
				<td>#cont_summary#</td>
			</tr>		
			<tr> 
				<td>><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="tableyazi"><cf_get_lang_main no='714.Devam'></a><br/><br/></td>
			</tr>
		</table>	
	</cfoutput>
</cfif>

<cfset hit = 0>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_CHAPTER" datasource="#DSN#" maxrows="1" blockfactor="1"> 
			SELECT 
				HIT 
			FROM 
				CONTENT_CHAPTER
			WHERE 
				CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chid#">					  
		</cfquery>
		<cfif isdefined("get_content.ch_hit")>
			<cfif len(get_content.ch_hit)>
				<cfset hit = get_content.ch_hit + 1>
			<cfelseif isnumeric(get_content.ch_hit)>
				<cfset hit = get_content.ch_hit + 1>
			<cfelse>
				<cfset hit = 1>
			</cfif>
		<cfelse>
			<cfif get_chapter.hit eq "">
				<cfset hit =1>
			<cfelse>
				<cfset hit =get_chapter.hit+1>
			</cfif>
		</cfif>
		<cfquery name="HIT_UPDATE" datasource="#dsn#">
			UPDATE 
				CONTENT_CHAPTER 
			SET 
				HIT = #hit#
			WHERE 
				CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chid#">					  
		</cfquery>
	</cftransaction>
</cflock>
