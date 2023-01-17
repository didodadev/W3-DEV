<cfif isdefined("attributes.content_main_maxrow") and isnumeric(attributes.content_main_maxrow)>
	<cfset main_max = attributes.content_main_maxrow>
<cfelse>
	<cfset main_max = 5>
</cfif>
<cfquery name="GET_CONTENT" datasource="#DSN#">
	SELECT 
		C.CONT_POSITION,
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,
		C.USER_FRIENDLY_URL,
		C.CONT_SUMMARY,
		C.RECORD_DATE,
		C.COMPANY_CAT,
		C.PRIORITY,
        C.UPDATE_DATE,
        C.CONTENT_PROPERTY_ID,
        CCAT.CONTENTCAT,
        CC.CHAPTER,
		CC.CHAPTER_ID
	FROM 
		CONTENT AS C, 
		CONTENT_CHAPTER AS CC,
		CONTENT_CAT AS CCAT
	WHERE 
		<cfif isdefined("attributes.is_main_content_campaign") and attributes.is_main_content_campaign>
			C.CONTENT_ID IN 
				(SELECT 
					CR.CONTENT_ID 
				FROM 
					CONTENT_RELATION CR,
					#dsn3_alias#.CAMPAIGNS CMP 
				WHERE 
					CMP.CAMP_ID = CR.ACTION_TYPE_ID AND
					CMP.CAMP_STATUS = 1 AND
					CMP.CAMP_STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
					CMP.CAMP_FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
					CR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND 
					CR.ACTION_TYPE = 'CAMPAIGN_ID'
				) 
				AND
		</cfif>
		<cfif isdefined("attributes.chid")>
			C.CONT_POSITION LIKE '%5%' AND CC.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chid#"> AND 
		<cfelseif isdefined("attributes.cat_id")>
			C.CONT_POSITION LIKE '%3%' AND CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#"> AND
		<cfelse>
			C.CONT_POSITION LIKE '%1%' AND
		</cfif>
		<cfif isdefined('attributes.content_property_id') and len(attributes.content_property_id)>
			C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_property_id#"> AND
		</cfif>
		C.STAGE_ID = -2 AND	 
		C.CONTENT_STATUS = 1 AND
		C.CHAPTER_ID = CC.CHAPTER_ID AND 
		CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
		C.SPOT <> 1 AND
		<cfif isdefined("attributes.type") and attributes.type eq 1>
			C.OUTHOR_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> AND
		<cfelseif isdefined("attributes.type") and attributes.type eq 2>
			C.OUTHOR_CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> AND
		<cfelseif isdefined("attributes.type") and attributes.type eq 3>
			C.OUTHOR_PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> AND
		</cfif>
		<cfif isdefined("session.pp.company_category")>
			','+C.COMPANY_CAT+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
			CCAT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
		<cfelseif isdefined("session.ww.consumer_category")>
			','+C.CONSUMER_CAT+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
			CCAT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
		<cfelseif isdefined("session.cp")>
			C.CAREER_VIEW = 1 AND
			CCAT.COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#"> AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#">
		<cfelse>
			INTERNET_VIEW = 1 AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
		</cfif>
	ORDER BY 
		<cfif isdefined('attributes.is_content_main_sort') and attributes.is_content_main_sort eq 1>
            C.RECORD_DATE DESC
        <cfelseif isdefined('attributes.is_content_main_sort') and attributes.is_content_main_sort eq 2>
        	C.UPDATE_DATE DESC
        <cfelse>
        	C.CONT_HEAD
        </cfif>
</cfquery>
<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT
		ASSET.ASSET_ID,
		ASSET.ACTION_ID,
		ASSET.MODULE_NAME,
		ASSET.ASSET_FILE_NAME,
		ASSET.ASSET_FILE_REAL_NAME,
		CP.NAME,
		ASSET_CAT.ASSETCAT_PATH
	FROM
		ASSET,
		CONTENT_PROPERTY AS CP,
		ASSET_CAT
	WHERE
		ASSET.ASSET_ID IN (SELECT ASSET_ID FROM ASSET_SITE_DOMAIN WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#">) AND
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND
		ASSET.ACTION_SECTION = 'CONTENT_ID' AND
		ASSET.IS_INTERNET = 1
	ORDER BY
		ASSET.ACTION_ID
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_content.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.max" default='#main_max#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.max)+1>

<cfif isdefined("attributes.is_main_content_chapter") and attributes.is_main_content_chapter eq 1>
	<cfset group_ = "CHAPTER">
<cfelse>
	<cfset group_ = "CONTENT_ID">
</cfif>

<table align="center" cellpadding="2" cellspacing="2" style="width:100%">
	<cfif get_content.recordcount>
		<cfoutput query="get_content" startrow="#attributes.startrow#" maxrows="#attributes.max#" group="#group_#">
            <cfif isdefined('attributes.is_content_main_date') and attributes.is_content_main_date eq 1>
                <td class="headbold">
					<table style="width:200px;">
                        <tr>
							<td class="txtbold" style="width:70px;"><cf_get_lang no ='784.Yayın Tarihi'></td>
                            <td>: #dateformat(update_date,'dd/mm/yyyy')#</td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
                            <td>: #contentcat#</td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang_main no ='583.Bölüm'></td>
                            <td>: #chapter#</td>
                        </tr>
                        <cfif attributes.is_content_main_type eq 1>
                            <cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
                                SELECT CONTENT_PROPERTY_ID,NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_property_id#">
                            </cfquery>
                        </cfif>
                        <tr>
                            <td class="txtbold"><cfif isdefined('attributes.is_content_main_type') and attributes.is_content_main_type eq 1><cf_get_lang_main no ='218.Tip'></cfif></td>
                            <td><cfif attributes.is_content_main_type eq 1>: <cfif get_content_property.recordcount>#get_content_property.name#</cfif></cfif></td>
                        </tr>
                    </table>
                </td>
            </cfif>
            <cfset my_width_ = 100/attributes.content_main_mode>
			<td style="vertical-align:top">
				<table border="0">
					<cfif isdefined("attributes.is_content_main_image") and attributes.is_content_main_image eq 1>
						<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
							SELECT CONTIMAGE_SMALL, IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content.content_id#"> AND IMAGE_SIZE = 0
						</cfquery>
						<cfif get_image_cont.recordcount>
							<cfif isdefined('attributes.content_main_image_width') and len(attributes.content_main_image_width) and attributes.content_main_image_width neq 0>
                                <cfset main_image_width = attributes.content_main_image_width>
                            <cfelse>
                                <cfset main_image_width = ''>
                            </cfif>
                            <cfif isdefined('attributes.content_main_image_height') and len(attributes.content_main_image_height) and attributes.content_main_image_height neq 0>
                                <cfset main_image_height = attributes.content_main_image_height>
                            <cfelse>
                                <cfset main_image_height = ''>
                            </cfif>
                            <tr>
                                <td colspan="2" <cfif isdefined('attributes.is_main_image_position') and attributes.is_main_image_position eq 0> width="#my_width_#%"<cfelseif attributes.is_main_image_position eq 1>rowspan="4" valign="top" style="width:75px;"</cfif>>
                                    <cfif len(main_image_width) or len(main_image_height)>
                                        <cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" image_width="#main_image_width#" image_height="#main_image_height#" output_type="0" title="#cont_head#" alt="#cont_head#">
                                    <cfelse>
                                        <cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" output_type="0" title="#cont_head#" alt="#cont_head#">
                                    </cfif>
                                </td>
                            </tr>
                        </cfif>
                    </cfif>
					<cfif isdefined("attributes.is_main_content_campaign") and attributes.is_main_content_campaign>
						<cfquery name="GET_CAMP" datasource="#DSN#">
							SELECT
								ACTION_TYPE_ID
							FROM
								CONTENT_RELATION
							WHERE
								ACTION_TYPE = 'CAMPAIGN_ID' AND
								CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content.content_id#">
						</cfquery>
					</cfif>
					<cfif isdefined("attributes.is_content_main_header") and attributes.is_content_main_header eq 1>
					<tr> 
						<td colspan="2" class="headbold">
							<cfif isdefined("attributes.is_main_content_campaign") and attributes.is_main_content_campaign>
								<a href="#request.self#?fuseaction=objects2.dsp_campaign&camp_id=#get_camp.action_type_id#" class="headbold" title="#cont_head#"> #cont_head#</a>
							<cfelse>
								<a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="headbold" title="#cont_head#"> #cont_head#</a>
							</cfif>
						</td>
					</tr>
					</cfif>
					<cfif isdefined("attributes.is_content_main_summary") and attributes.is_content_main_summary eq 1>
						<tr> 
							<td colspan="2" class="contsum">#cont_summary#</td>
						</tr>
					</cfif>
					<cfif isdefined("attributes.is_content_devam") and attributes.is_content_devam eq 1>
						<tr> 
							<td><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="tableyazi"> <cf_get_lang_main no='714.Devam'></a></td>
							<cfif isdefined('attributes.is_content_record_date') and attributes.is_content_record_date eq 1>
								<td align="right" style="width:30%"><font class="txtbold"><cf_get_lang no ='784.Yayın Tarihi'> : </font>#dateformat(record_date,'dd/mm/yyyy')#<br/></td>
							<cfelse>
								<td></td>
							</cfif>
						</tr>
					</cfif>
				</table>
			</td>
			<cfif isdefined('attributes.is_content_asset') and attributes.is_content_asset eq 1>
				<cfquery name="GET_ASS" dbtype="query">
					SELECT 
						*
					FROM
						GET_ASSET
					WHERE
						ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#">
				</cfquery>
				<td style="width:82px;"><cfif len(get_ass.asset_id)><a href="/documents/#get_ass.module_name#/#get_ass.asset_file_name#" title="PDF Link" ><img width="33" height="33" border="0" src="../../documents/content/Image/pdf_icon.png" title="<cf_get_lang_main no ='1936.PDF'> <cf_get_lang no ='1669.Link'>" alt="<cf_get_lang_main no ='1936.PDF'> <cf_get_lang no ='1669.Link'>"/></a></cfif></td>
			<cfelse>
				<td style="width:15px;">&nbsp;</td>
			</cfif>
			<cfif ((currentrow mod attributes.content_main_mode eq 0)) or (currentrow eq recordcount)></tr></cfif>
            <cfif (isdefined('attributes.is_content_main_date') and attributes.is_content_main_date eq 1) or (isdefined('attributes.is_content_record_date') and attributes.is_content_record_date eq 1)>
                <tr>
                    <td colspan="3"><hr style="height:0.1px; width:97%; text-align:left" color="cccccc" /></td>
                </tr>
            </cfif>
        </cfoutput>	
        <tr>
            <td>
                <br />
            </td>
        </tr>
	</cfif>
</table>
<cfif isdefined("attributes.is_main_content_campaign") and attributes.is_main_content_campaign>
	<a href="/tum_kampanyalar" class="all_campaigns"></a>
</cfif>
<cfif attributes.totalrecords gt attributes.max>
	<cfset url_str = "">
	<cfif isdefined('attributes.cat_id') and len(attributes.cat_id)>
		<cfset url_str = "#url_str#&cat_id=#attributes.cat_id#">
	</cfif>
	<cfif isdefined('attributes.chid') and len(attributes.chid)>
		<cfset url_str = "#url_str#&chid=#attributes.chid#">
	</cfif>
	<table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
		<tr>
			<td>
				<cf_pages page="#attributes.page#"
				maxrows="#attributes.max#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction##url_str#">
			</td>
			<td align="right" class="tableyazi" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
	<br/>
</cfif>
