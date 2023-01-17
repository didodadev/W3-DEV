<cfparam name="attributes.search_words" default="">
<cfquery name="get_social_media_site" datasource="#dsn#">
	SELECT DISTINCT(SITE) AS SITE FROM SOCIAL_MEDIA_REPORT
</cfquery>
<cfquery name="get_social_media_words" datasource="#dsn#">
	SELECT WORD_ID,WORD FROM SOCIAL_MEDIA_SEARCH_WORDS
</cfquery>
<cfquery name="get_process_types" datasource="#dsn#">
	SELECT
		PTR.STAGE AS STAGE,
		PTR.PROCESS_ROW_ID AS ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%worknet.list_social_media%">
	ORDER BY
		ROW_ID ASC
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
<cfelse>
	<cfset attributes.startdate = date_add('d',-1,createodbcdatetime('#(now())#'))>
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate = date_add('d',1,attributes.startdate)>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("attributes.form_submit")>
	<cfquery name="get_social_media_result" datasource="#dsn#">
		WITH CTE1 AS (	
			SELECT 
				SOC.SID,
				SOC.SOCIAL_MEDIA_ID,
				SUBSTRING(SOC.SOCIAL_MEDIA_CONTENT,1,100) AS SOCIAL_MEDIA_CONTENT,
				SOC.PUBLISH_DATE,
				SOC.IMAGE,
				SOC.USER_NAME,
				SOC.SEARCH_KEY,
				SOC.SITE,
				SOC.RECORD_DATE,
				SOC.RECORD_EMP,
				SOC.RECORD_IP,
				SOC.UPDATE_EMP,
				SOC.PROCESS_ROW_ID AS PROCESS,
				SOC.UPDATE_DATE,
				SOC.UPDATE_IP,
				SOC.COMMENT_URL,
				SOC.LANGUAGE,
				SOC.USER_ID,
				PRO.PROCESS_ROW_ID ,
				PRO.STAGE AS STAGE
			FROM 
				SOCIAL_MEDIA_REPORT SOC,
				PROCESS_TYPE_ROWS PRO
			WHERE
					SOC.PROCESS_ROW_ID = PRO.PROCESS_ROW_ID 
				<cfif isdefined("attributes.site_name") and len(attributes.site_name)>
					AND SOC.SITE LIKE '%#attributes.site_name#%'
				</cfif>
				<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
					AND SOC.PROCESS_ROW_ID =#attributes.process_stage#
				</cfif>
				<cfif isdefined("attributes.search_words") and len(attributes.search_words)>
					AND SOC.SEARCH_KEY= (SELECT WORD FROM SOCIAL_MEDIA_SEARCH_WORDS WHERE WORD_ID=#attributes.search_words#)
				</cfif>
				<cfif isdefined("attributes.language") and len(attributes.language)>
					AND SOC.LANGUAGE= '#attributes.language#'
				</cfif>
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
					AND
					((SOC.PUBLISH_DATE >= #attributes.startdate# AND SOC.PUBLISH_DATE < #DATEADD("d",1,attributes.finishdate)#) OR PUBLISH_DATE IS NULL)
				</cfif>		
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					AND (  
							SOC.SITE LIKE '%#attributes.keyword#%' OR
							SOC.SOCIAL_MEDIA_CONTENT LIKE '%#attributes.keyword#%'
						)
				</cfif>
				),
				CTE2 AS (
					SELECT
						CTE1.*,
						ROW_NUMBER() OVER (ORDER BY PUBLISH_DATE  DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
					FROM
						CTE1
				)
				SELECT
					CTE2.*
				FROM
					CTE2
				WHERE
					RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)	
	</cfquery>	
	<cfparam name="attributes.totalrecords" default="#get_social_media_result.QUERY_COUNT#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<div class="row">
    <cfinclude template="../../rules/display/rule_menu.cfm">
</div>
<cfform name="form" method="post" action="#request.self#?fuseaction=worknet.list_social_media">
    <cf_big_list_search title="#getLang('main',1732)#">
        <cf_big_list_search_area>
            <div class="row">
                <div class="col col-12 form-inline">
                    <div class="form-group">
                        <input type="hidden" name="form_submit" id="form_submit" value="1">
                        <input type="text" name="keyword" id="keyword" style="width:80px;" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cfoutput>#getLang('main',48)#</cfoutput>">
                    </div>
                     <div class="form-group">
                        <select name="process_stage">
                            <option value=""><cf_get_lang_main no="70.aşama"></option>
                            <cfoutput query="get_process_types">
                                <option value="#get_process_types.ROW_ID#" <cfif isdefined("attributes.process_stage") and attributes.process_stage eq row_id>selected</cfif>>#get_process_types.stage#</option>
                            </cfoutput>
                        </select>
                    </div>
                     <div class="form-group">
                        <select name="site_name">
                            <cfoutput query="get_social_media_site">
                                <option value="#SITE#" <cfif isdefined("attributes.site_name") and attributes.site_name is SITE>selected</cfif>>#SITE#</option>
                            </cfoutput>
                        </select>
                    </div>
                     <div class="form-group">
                        <select name="language">
                            <option value=""><cf_get_lang_main no='1584.Dil'></option>
                            <option value="tr" <cfif isdefined("attributes.language") and attributes.language is 'tr'>selected</cfif>>tr</option>
                            <option value="ar" <cfif isdefined("attributes.language") and attributes.language is 'ar'>selected</cfif>>ar</option>
                            <option value="bg" <cfif isdefined("attributes.language") and attributes.language is 'bg'>selected</cfif>>bg</option>
                            <option value="cs" <cfif isdefined("attributes.language") and attributes.language is 'cs'>selected</cfif>>cs</option>
                            <option value="de" <cfif isdefined("attributes.language") and attributes.language is 'de'>selected</cfif>>de</option>
                            <option value="el" <cfif isdefined("attributes.language") and attributes.language is 'el'>selected</cfif>>el</option>
                            <option value="en" <cfif isdefined("attributes.language") and attributes.language is 'en'>selected</cfif>>en</option>
                            <option value="es" <cfif isdefined("attributes.language") and attributes.language is 'es'>selected</cfif>>es</option>
                            <option value="fr" <cfif isdefined("attributes.language") and attributes.language is 'fr'>selected</cfif>>fr</option>
                            <option value="hi" <cfif isdefined("attributes.language") and attributes.language is 'hi'>selected</cfif>>hi</option>
                            <option value="it" <cfif isdefined("attributes.language") and attributes.language is 'it'>selected</cfif>>it</option>
                            <option value="ja" <cfif isdefined("attributes.language") and attributes.language is 'ja'>selected</cfif>>ja</option>
                            <option value="la" <cfif isdefined("attributes.language") and attributes.language is 'la'>selected</cfif>>la</option>
                            <option value="nl" <cfif isdefined("attributes.language") and attributes.language is 'nl'>selected</cfif>>nl</option>
                            <option value="no" <cfif isdefined("attributes.language") and attributes.language is 'no'>selected</cfif>>no</option>
                            <option value="pl" <cfif isdefined("attributes.language") and attributes.language is 'pl'>selected</cfif>>pl</option>
                            <option value="pt" <cfif isdefined("attributes.language") and attributes.language is 'pt'>selected</cfif>>pt</option>
                            <option value="ro" <cfif isdefined("attributes.language") and attributes.language is 'ro'>selected</cfif>>ro</option>
                            <option value="ru" <cfif isdefined("attributes.language") and attributes.language is 'ru'>selected</cfif>>ru</option>
                            <option value="sv" <cfif isdefined("attributes.language") and attributes.language is 'sv'>selected</cfif>>sv</option>
                            <option value="uk" <cfif isdefined("attributes.language") and attributes.language is 'uk'>selected</cfif>>uk</option>
                            <option value="zh" <cfif isdefined("attributes.language") and attributes.language is 'zh'>selected</cfif>>zh</option>
                        </select>
                    </div>
                     <div class="form-group">
                        <div class="input-group x-11">
                        	<cfsavecontent variable="message"><cf_get_lang_main no='243.başlama girmelisiniz'></cfsavecontent> 
                            <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group x-11">
                        	<cfsavecontent variable="message"><cf_get_lang no='138.bitiş girmelisiniz'></cfsavecontent> 
                       		<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate" max_date="#dateformat(now(),'yyyymmdd')#"> </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <select name="search_words" id="search_words">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="get_social_media_words">
                                <option value="#WORD_ID#" <cfif isdefined("attributes.search_words") and attributes.search_words eq WORD_ID>selected</cfif>>#WORD#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group x-3_5">
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button>
                    </div>
                </div>
            </div>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
            <th style="width:20px"><cf_get_lang_main no="75.no"></th>
            <th class="header_icn_text"><cf_get_lang no="297.Avatar"></th>
            <th><cf_get_lang_main no="1732.Sosyal Medya"></th>
            <th><cf_get_lang no="298.Keyword"></th>
            <th><cf_get_lang_main no="139.Kullanıcı Adı"></th>
            <th><cf_get_lang_main no="1584.Dil"></th>
            <th><cf_get_lang_main no="241.İçerik"></th>
            <th><cf_get_lang_main no="70.aşama"></th>
            <th><cf_get_lang_main no="330.Tarih"></th>
            <cfif isdefined("attributes.form_submit")><cfif get_social_media_result.recordcount> <th class="header_icn_none"></th></cfif></cfif>
        </tr>
    </thead>
    <tbody>
		<cfif isdefined("attributes.form_submit")>	
            <cfif get_social_media_result.recordcount>
                <cfoutput query="get_social_media_result">	
                    <tr>
                        <td>#currentrow+((attributes.page-1)*attributes.maxrows)#</td>
                        <td style="width:50px; height:50px; text-align:center"><img src="#Image#" align="left" width="50" height="50"></td>
                        <td>#SITE#</td>
                        <td>#SEARCH_KEY#</td>
                        <td><cfif SITE eq 'twitter'> <a href="http://twitter.com/#USER_NAME#" class="tableyazi" target="social_media_user">
                            <cfelseif SITE eq 'friendfeed' > <a href="https://friendfeed.com/#USER_ID#" class="tableyazi" target="social_media_user" > 
                            <cfelseif SITE eq 'facebook' >  <a href="http://www.facebook.com/#USER_ID#" class="tableyazi" target="social_media_user"> 
                            <cfelseif SITE eq 'google plus'>  <a href="https://plus.google.com/#USER_ID#" class="tableyazi" target="social_media_user">
                            <cfelseif SITE eq 'youtube'><a href="https://www.youtube.com/#USER_ID#" class="tableyazi" target="social_media_user">
                            </cfif>#USER_NAME#</a>
                        </td>
                        <td>#language#</td>
                        <td>#REPLACE(REPLACE(replace(social_media_content,"a href="," ","ALL"),"img src="," ","all"),"a rel","","ALL")#</td>
                        <td>#STAGE#</td>		
                        <td>#dateformat(PUBLISH_DATE,dateformat_style)#</td>
                        <!-- sil -->
                        <td><a href="#request.self#?fuseaction=worknet.list_social_media&event=upd&sid=#get_social_media_result.sid#"><img src="/images/update_list.gif" border="0"></a></td>		
                        <!-- sil -->	
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>   
        <cfelse>
            <tr>
                <td colspan="9"><cf_get_lang_main no='289.Filtre Ediniz'>!</td>
           </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_string = ''>
	<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
		<cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
	</cfif>
	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
		<cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
	</cfif>
	<cfif isdefined("attributes.site_name") and len(attributes.site_name)>
		<cfset url_string = '#url_string#&site_name=#attributes.site_name#'>
	</cfif>
	<cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
		<cfset url_string = '#url_string#&form_submit=1'>
	</cfif>
	<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
		<cfset url_string = '#url_string#&process_stage=#attributes.process_stage#'>
	</cfif>
	<cfif isdefined("attributes.search_words") and len(attributes.search_words)>
		<cfset url_string = '#url_string#&search_words=#attributes.search_words#'>
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
	</cfif>
	<cfif isdefined("attributes.language") and len(attributes.language)>
		<cfset url_string = '#url_string#&language=#attributes.language#'>
	</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="worknet.list_social_media&#url_string#">
			
</cfif>

