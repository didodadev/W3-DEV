<cfparam name="attributes.asset_thumbnail" default="1">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isDefined('attributes.asset_stage') and len(attributes.asset_stage)>
	<cfset url_str = "#url_str#&asset_stage=#attributes.asset_stage#">
</cfif>
<cfif isdefined("assetcat_id")>
	<cfset url_str = "#url_str#&assetcat_id=#assetcat_id#">
<cfelse>
	<cfset attributes.assetcat_id = 0>
	<cfset assetcat_id = 0>
	<cfset url_str = "#url_str#&assetcat_id=0">
</cfif>
<cfif isdefined("property_id")>
	<cfset url_str = "#url_str#&property_id=#attributes.property_id#">
</cfif>
<cfquery name="GET_ASSETS" datasource="#DSN#">
    SELECT
        ASSET.MODULE_NAME,
        ASSET.ACTION_SECTION,
        ASSET.ACTION_ID,
        ASSET.ASSET_ID,
        ASSET.ASSET_NAME,
        ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_FILE_PATH_NAME,
        ASSET.ASSET_FILE_SERVER_ID,
        ASSET.ASSET_FILE_SIZE,
        ASSET.UPDATE_DATE,
        ASSET.UPDATE_EMP,
        ASSET.UPDATE_PAR,
        ASSET_CAT.ASSETCAT,
        ASSET_CAT.ASSETCAT_PATH,
        ASSET_DESCRIPTION AS DETAIL,
        ASSET_DETAIL AS DESCRIPTION,
        ASSET.ASSETCAT_ID,
        ASSET.PROPERTY_ID,
        ASSET.RECORD_DATE,
        ASSET_SITE_DOMAIN.SITE_DOMAIN
    FROM 
        ASSET,
        ASSET_CAT,
        ASSET_SITE_DOMAIN
    WHERE
        ASSET.IS_INTERNET = 1 AND
        ASSET_SITE_DOMAIN.ASSET_ID = ASSET.ASSET_ID AND
        ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
        ASSET_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
        <cfif isdefined("session.ww.userid")>
            AND ASSET_CAT.IS_INTERNET = 1
        <cfelseif isdefined("session.pp.userid")>
            AND ASSET_CAT.IS_EXTRANET = 1
        <cfelse>
            AND ASSET_CAT.IS_INTERNET = 1
        </cfif>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
            AND
            (
                ASSET.ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                OR
                ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            )
        </cfif>
		<cfif isDefined("attributes.asset_stage") and len(attributes.asset_stage)>
            AND ASSET.ASSET_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_stage#">
        </cfif>
        <cfif isDefined("attributes.asset_category") and len(attributes.asset_category)>
            AND ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_category#">
        </cfif>
        <cfif isDefined("attributes.property_id") and Len(attributes.property_id)>
            AND ASSET.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_id#">
        </cfif>
        <cfif isDefined("attributes.asset_document_type") and Len(attributes.asset_document_type)>
            AND ASSET.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_document_type#">
        </cfif>
        AND ASSET.ASSET_ID NOT IN (SELECT ASSET_ID FROM ASSET_RELATED) 
	UNION 
    SELECT
        ASSET.MODULE_NAME,
        ASSET.ACTION_SECTION,
        ASSET.ACTION_ID,
        ASSET.ASSET_ID,
        ASSET.ASSET_NAME,
        ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_FILE_PATH_NAME,
        ASSET.ASSET_FILE_SERVER_ID,
        ASSET.ASSET_FILE_SIZE,
        ASSET.UPDATE_DATE,
        ASSET.UPDATE_EMP,
        ASSET.UPDATE_PAR,
        ASSET_CAT.ASSETCAT,
        ASSET_CAT.ASSETCAT_PATH,
        ASSET_DESCRIPTION AS DETAIL,
        ASSET_DETAIL AS DESCRIPTION,
        ASSET.ASSETCAT_ID,
        ASSET.PROPERTY_ID,
        ASSET.RECORD_DATE,
        ASSET_SITE_DOMAIN.SITE_DOMAIN
    FROM 
        ASSET,
        ASSET_CAT,
        ASSET_SITE_DOMAIN
    WHERE
        ASSET.IS_INTERNET = 1 AND
        ASSET_SITE_DOMAIN.ASSET_ID = ASSET.ASSET_ID AND
        ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
        ASSET_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> 	
        <cfif isdefined("session.ww.userid")>
            AND ASSET_CAT.IS_INTERNET = 1
        <cfelseif isdefined("session.pp.userid")>
            AND ASSET_CAT.IS_EXTRANET = 1
        <cfelse>
            AND ASSET_CAT.IS_INTERNET = 1
        </cfif>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
            AND
            (
                ASSET.ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                OR
                ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            )
        </cfif>
		<cfif isDefined("attributes.asset_stage") and len(attributes.asset_stage)>
            AND ASSET.ASSET_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_stage#">
        </cfif>
        <cfif isDefined("attributes.asset_category") and len(attributes.asset_category)>
            AND ASSET.ASSETCAT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_category#">
        </cfif>
        <cfif isDefined("attributes.property_id") and Len(attributes.property_id)>
            AND ASSET.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_id#">
        </cfif>
        <cfif isDefined("attributes.asset_document_type") and Len(attributes.asset_document_type)>
            AND ASSET.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_document_type#">
        </cfif>
        AND ASSET.ASSET_ID IN (	SELECT DISTINCT 
                                    ASSET_ID 
                                FROM 
                                    ASSET_RELATED
                                WHERE
                                    (ASSET_RELATED.ALL_PEOPLE = 1 OR
                                    <cfif isdefined("session.pp.userid")>
                                        ASSET_RELATED.COMPANY_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_category#">
                                    <cfelseif isdefined("session.ww.userid")>
                                        ASSET_RELATED.CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.consumer_category#">
                                    <cfelseif isdefined("session.cp")>
                                        ASSET_RELATED.ALL_CAREER = 1
                                    <cfelse>
                                        ASSET_RELATED.ALL_INTERNET = 1				
                                    </cfif>	))  
    ORDER BY
        ASSET.RECORD_DATE DESC  
</cfquery>

<cfif isdefined("attributes.asset_maxrow") and len(attributes.asset_maxrow)>
	<cfparam name="attributes.maxrow" default='#attributes.asset_maxrow#'>
<cfelse>
	<cfparam name="attributes.maxrow" default='#session_base.maxrows#'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default=#get_assets.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<cfif attributes.asset_thumbnail eq 2>
	<cfinclude template="thumbnail.cfm">
<cfelse>
	<table align="center" cellpadding="0" cellspacing="0" style="width:100%">
		<tr style="height:25px;" > 
			<td>
            	<cfform name="search_asset" action="#request.self#?fuseaction=objects2.list_assets" method="post">
				<input type="hidden" name="asset_stage" id="asset_stage"  value="<cfif isDefined('attributes.asset_stage') and len(attributes.asset_stage)><cfoutput>#attributes.asset_stage#</cfoutput></cfif>">              
				<table style="text-align:right;">	                
					<tr>
						<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
						<td>
							<cfquery name="GET_CONTENT_PROPERTY" datasource="#dsn#">
								SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY ORDER BY NAME
							</cfquery>							
							<select name="property_id" id="property_id">
								<option value=""><cf_get_lang_main no='655.Döküman Tipleri'>
								<cfoutput query="get_content_property">
									<option value="#content_property_id#"<cfif isDefined("attributes.property_id") and (content_property_id eq attributes.property_id)> selected</cfif>>#name#
								</cfoutput>
							</select>				
				  		</td>
				  		<td>
					  		<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					  		<cfinput type="text" name="maxrow" id="maxrow" value="#attributes.maxrow#" required="yes" validate="integer" range="1,200" message="#message#" maxlength="3" style="width:25px;">
				  		</td>
				  		<td><cf_wrk_search_button is_excel="0"></td>
				  	</tr>
                </table>
				</cfform>
			</td>
		</tr>
	</table>
	
	<table cellspacing="1" cellpadding="2" border="0" align="center" style="width:100%">
		<tr class="color-header" style="height:22px;"> 
			<td class="form-title" style="width:15px;"></td>
		  	<td class="form-title"><cf_get_lang_main no='1655.Varlık'></td>
		  	<td class="form-title" style="width:120px;"><cf_get_lang_main no='74.Kategori'></td>
		  	<td class="form-title" style="width:100px;"><cf_get_lang no='382.Doküman Tipi'></td>
		  	<td class="form-title" style="width:100px;"><cf_get_lang_main no ='1182.Format'></td>
		  	<td class="form-title" style="width:120px;"><cf_get_lang_main no='71.Kayıt'></td>
		</tr>
		<cfif get_assets.recordcount>
			<cfoutput query="get_assets" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
				<cfif assetcat_id gte 0>
				   <cfset url_ = "#file_web_path#asset/#assetcat_path#/">
				   <cfset path = "#upload_folder#asset#dir_seperator##assetcat_path##dir_seperator#">
				<cfelse>
				   <cfset url_ = "#file_web_path#/#assetcat_path#/">
				   <cfset path = "#upload_folder##assetcat_path##dir_seperator#">
				</cfif>			  
				<cfset file_path = '#path##asset_file_name#'>
				<cfset rm = '#chr(13)#'>
				<cfset desc = ReplaceList(description,rm,'')>
				<cfset rm = '#chr(10)#'>
				<cfset desc = ReplaceList(desc,rm,'')>
				<cfif desc is ''><cfset desc = 'image'></cfif>
				<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">		   
					<td>
					<cfif not isDefined("attributes.asset_archive")>
						<cfif assetcat_id gte 0>
							<cfset file_add_ = "asset/">
						<cfelse>
							<cfset file_add_ = "">
						</cfif>
						<cf_get_server_file output_file="#file_add_##assetcat_path#/#asset_file_name#" output_server="#asset_file_server_id#" output_type="2" small_image="objects2/image/download1.jpg" image_link="1" alt="#asset_name#" title="#asset_name#">
					</cfif>
					</td>
					<td>
						<cfset ext=lcase(listlast(asset_file_name, '.')) />
						<cfif ext eq "flv"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects2.popup_flvplayer&video_id=#asset_id#&video=/documents/#file_add_##assetcat_path#/#asset_file_name#','video');" class="tableyazi" title="#asset_name#">#asset_name#</a><cfelse>#asset_name#</cfif>
			  		</td>
			  		<td>#assetcat#</td>
					<cfset property = #property_id#>
					<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
						SELECT 
							NAME
						FROM 
							CONTENT_PROPERTY
							<cfif len(property) and (property gt 0)>
								WHERE  
									CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property#">
							</cfif>								 
					</cfquery>
			 		<td><cfif len(property) and (property gt 0)>#get_content_property.name#</cfif></td>
					<cfif FindNoCase(".",asset_file_name)>
						<cfset last_3 = Mid(asset_file_name, FindNoCase(".",asset_file_name), Len(asset_file_name)-FindNoCase(".",asset_file_name)+1 )>
				  	<cfelse>
						<cfset last_3 = "">
				  	</cfif>
				  	<td>#last_3# (#asset_file_size# kb.)</td>
				  	<td>&nbsp;#dateformat(update_date,'dd/mm/yyyy')# #timeformat(update_date,'HH:MM')#</td>
				</tr>
			</cfoutput> 
		<cfelse>
			<tr class="color-row"> 
				<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</table>
	<cfif attributes.totalrecords gt attributes.maxrow>
		<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%; height:35px;">
			<tr>
				<td>
					<cf_pages page="#attributes.page#"
						maxrows="#attributes.maxrow#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="objects2.list_assets#url_str#">
				</td>
				<!-- sil --><td colspan="5"  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage# </cfoutput></td><!-- sil -->
		  	</tr>
		</table>
		<br/>
	</cfif>
</cfif>


	
