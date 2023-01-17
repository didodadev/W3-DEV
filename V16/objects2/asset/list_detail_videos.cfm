<cfparam name="attributes.search_assetcat_id" default="">
<cfparam name="attributes.search_type" default="">
<cfparam name="attributes.keyword" default="" />
<cfparam name="attributes.add_member" default="" />
<cfparam name="attributes.record_date" default="" />
<cfif len(attributes.record_date)>
	<cf_date tarih="attributes.record_date">
</cfif>
<cfif isdefined("attributes.asset_maxrows") and len(attributes.asset_maxrows)>
	<cfset asset_maxrows = #attributes.asset_maxrows#>
<cfelse>
	<cfset asset_maxrows = 5>
</cfif>
<cfquery name="GET_ASSET_VIDEOS" datasource="#DSN#">
	SELECT
		ASSET.MODULE_NAME,
		ASSET.ACTION_SECTION,
		ASSET.ACTION_ID,
		ASSET.ASSET_ID,
		ASSET.ASSET_NAME,
		ASSET.ASSET_DETAIL,
		ASSET.ASSET_FILE_NAME,
		ASSET.ASSET_FILE_PATH_NAME,
		ASSET.ASSET_FILE_SERVER_ID,
		ASSET.UPDATE_DATE,
		ASSET.RECORD_EMP,
		ASSET.RECORD_PUB,
		ASSET.RECORD_PAR,
		ASSET_CAT.ASSETCAT,
		ASSET_CAT.ASSETCAT_PATH,
		ASSET.ASSETCAT_ID,
		ASSET_SITE_DOMAIN.SITE_DOMAIN
	FROM 
		ASSET,
		ASSET_CAT,
		ASSET_SITE_DOMAIN
	WHERE
		ASSET.IS_INTERNET = 1 AND
		ASSET_SITE_DOMAIN.ASSET_ID = ASSET.ASSET_ID AND
		ASSET_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		<cfif isdefined("session.ww.userid")>
			ASSET_CAT.IS_INTERNET = 1 AND 
		<cfelseif  isdefined("session.pp.userid")>
			ASSET_CAT.IS_EXTRANET = 1 AND 
		<cfelse>
			ASSET_CAT.IS_INTERNET = 1 AND 
		</cfif>
		<cfif isdefined("attributes.is_asset_catid") and len(attributes.is_asset_catid)>
			ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_asset_catid#"> AND
		</cfif>
		<cfif isdefined("attributes.search_assetcat_id") and len(attributes.search_assetcat_id)>
			ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_asset_catid#"> AND
		</cfif>
		ASSET.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">  AND
		ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.flv%">
        <cfif attributes.keyword neq "">
        	AND (ASSET.ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            OR ASSET.ASSET_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
            ASSET.ASSET_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) 
        </cfif>
        <cfif isdefined("attributes.record_date") and len(attributes.record_date)>
			AND ASSET.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
		</cfif>
	ORDER BY
		ASSET.RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_asset_videos.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='10'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellspacing="1" cellpadding="10" width="100%" border="0" align="center">
	<cfif get_asset_videos.recordcount>
		<cfoutput query="get_asset_videos" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	  	<cfif ListLast(get_asset_videos.asset_file_name,'.') is 'flv'>
			<cfif ((currentrow mod attributes.asset_mode eq 1)) or (currentrow eq 1)>
				<tr>
			</cfif>
			<td>
				<table class="color-row" width="100%">
					<tr>
						<td width="85" rowspan="5" align="left">
							<cfset file_server_id = asset_file_server_id>
							<cfset file_name = asset_file_name>
							<cfset url_ = "#assetcat_path#">
							<cfset path = "#upload_folder#asset#dir_seperator##dir_seperator#">
							<cfif listlen(file_name,'.') eq 2>			
							   <cfset extention = ucase(listlast(file_name,'.'))>
							   <cfset dosya_ad = listfirst(file_name,'.')>
							<cfelse>
							   <cfset extention = 'incorrect'>	
							   <cfset dosya_ad = file_name>	
							</cfif>
							<cfif extention is 'FLV'>
								<cfif FileExists('#upload_folder#thumbnails#dir_seperator##dosya_ad#.jpg')>
									<cfset image_file = "thumbnails/#dosya_ad#.jpg">
								<cfelse>
									<cfset image_file = "thumbnails/thumbnail_standart_video.jpg">
								</cfif>
							<cfelseif listfindnocase(extention_list,'#extention#')>
								<cfset image_file = "settings/#listgetat(image_list,listfindnocase(extention_list,'#extention#'))#">
							<cfelse>
								<cfset image_file = "thumbnails/undefined.jpg">
							</cfif>
							<cfif find(".flv", file_name)>
								<cfif len(asset_file_path_name)>
									<cfset my_path_name_ = #asset_file_path_name#>
							  	<cfelse>
									<cfset my_path_name_ = '/documents/#url_#/#file_name#'>
							  	</cfif>
							  	<a href="#request.self#?fuseaction=objects2.detail_video&video_id=#asset_id#">
									<cf_get_server_file output_file="#url_#/#file_name#" output_server="#file_server_id#" output_type="2" image_link="0" image_width="75" image_height="75" small_image="/documents/#image_file#"  alt="#getLang('objects2',1655)#" title="#getLang('objects2',1655)#">
							  	</a>
							<cfelse>
								<cf_get_server_file output_file="#url_#/#file_name#" output_server="#file_server_id#" output_type="2" image_link="1" small_image="/documents/#image_file#" alt="#getLang('objects2',1655)#" title="#getLang('objects2',1655)#">
							</cfif>
					  	</td>
					</tr>
					<cfif attributes.is_asset_name eq 1>
						<tr valign="top">
							<td><a href="#request.self#?fuseaction=objects2.detail_video&video_id=#asset_id#">#asset_name#</a></td>
						</tr>
					</cfif>
					<cfif attributes.is_asset_detail eq 1>
						<tr valign="top">
							<td>#asset_detail#</td>
						</tr>
					</cfif>
					<cfif attributes.is_asset_date eq 1>
						<tr valign="top">
							<td>#dateformat(update_date,'dd/mm/yyyy')# #timeformat(update_date,'HH:MM')#</td>
						</tr>
					</cfif>
					<cfif attributes.is_asset_uye eq 1>
						<tr valign="top">
							<td>Üye : 
								<cfif len(get_asset_videos.record_emp)>
									#get_emp_info(get_asset_videos.record_emp,0,0)# 
								<cfelseif len(get_asset_videos.record_pub)>
									#get_cons_info(get_asset_videos.record_pub,0,0)#
								<cfelseif len(get_asset_videos.record_par)>
									#get_par_info(get_asset_videos.record_par,0,-1,0)#
								</cfif>
							</td>
						</tr>
					</cfif>
				</table>
			</td>
			<cfif ((currentrow mod attributes.asset_mode eq 0)) or (currentrow eq recordcount)>
				</tr>
			</cfif>	
		</cfif>
	  	</cfoutput> 
	<cfelse>
		<tr> 
			<td><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
	  	</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined('attributes.is_asset_catid') and len(attributes.is_asset_catid)>
		<cfset url_str = "#url_str#&is_asset_catid=#attributes.is_asset_catid#">
	</cfif>
	<cfif isdefined('attributes.search_assetcat_id') and len(attributes.search_assetcat_id)>
		<cfset url_str = "#url_str#&search_assetcat_id=#attributes.search_assetcat_id#">
	</cfif> 
	<cfif isdefined('attributes.add_member') and len(attributes.add_member)>
		<cfset url_str = "#url_str#&add_member=#attributes.add_member#">
	</cfif>
	<cfif isdefined('attributes.record_date') and len(attributes.record_date)>
		<cfset url_str = "#url_str#&record_date=#dateformat(attributes.record_date,'dd/mm/yyyy')#">
	</cfif> 
	<table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
		<tr>
			<td>
				<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects2.list_videos#url_str#">
			</td>
			<td class="tableyazi" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
	<br/>
</cfif>

