<cfquery name="GET_RESULT" datasource="#DSN#">
	SELECT 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_SUMMARY,
		C.USER_FRIENDLY_URL,
		C.HIT 
	FROM 
		CONTENT C,
		CONTENT_CAT CCAT, 
		CONTENT_CHAPTER CC
	WHERE 
		C.STAGE_ID = -2 AND	 
		C.CONTENT_STATUS = 1 AND
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
            (
               <!--- BK 20131012 6 aya kaldirilsin C.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
				C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
				C.CONT_SUMMARY LIKE '"#attributes.keyword#*"' --->
				<cfif isdefined("is_fulltext_search") and is_fulltext_search eq 1 >
					CONTAINS(C.*,'"#attributes.keyword#*"') 
				<cfelse>
					C.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
					C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
					C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif> 
            )
            AND 
        </cfif>
		C.CHAPTER_ID = CC.CHAPTER_ID AND 
		<cfif isdefined('attributes.block_cont_chap_ids') and len(attributes.block_cont_chap_ids)>
			C.CHAPTER_ID NOT IN (#attributes.block_cont_chap_ids#) AND
		</cfif>
		<cfif isdefined('attributes.block_cont_prop_ids') and len(attributes.block_cont_prop_ids)>
			C.CONTENT_PROPERTY_ID NOT IN (#attributes.block_cont_prop_ids#) AND
		</cfif>
		CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND 
		<cfif isdefined("attributes.content_category") and len(attributes.content_category)>
			CCAT.CONTENTCAT_ID IN (#listsort(attributes.content_category,'numeric')#) AND
		</cfif>
		<cfif isdefined("session.ww.language")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
		<cfelseif isdefined("session.pp.language")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
		<cfelseif isdefined("session.cp")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#"> AND
		</cfif>
		<cfif isdefined("session.pp.company_category")>
			C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
			CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">)
		<cfelseif isdefined("session.ww.consumer_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
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
		<!--- BK 20130114 6 aya kaldırıldı
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			ORDER BY 
			CASE
			WHEN C.CONT_HEAD LIKE '%#attributes.keyword#%' THEN 2
			WHEN C.CONT_SUMMARY LIKE '%#attributes.keyword#%' THEN 1
			WHEN C.USER_FRIENDLY_URL LIKE '%#attributes.keyword#%' THEN 3
			END
		</cfif> --->
</cfquery>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_result.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table style="width:100%"> 
	<tr style="height:20px;">	
		<td colspan="2"><cf_get_lang_main no='676.Arama Sonuçları'></td>
    </tr>
</table>
<cfif get_result.recordcount>
	<table style="width:100%">
		<cfoutput query="get_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">  
			<tr class="color-list">
				<td style="width:20px;"><img src="images/notkalem.gif" title="<cf_get_lang_main no='241.İçerik'>" alt="<cf_get_lang_main no='241.İçerik'>" border="0" /></td> 
				<td colspan="2"><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="label">#cont_head#</a></td>
			</tr>  
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">#cont_summary#</td>
			</tr>     
		</cfoutput> 
	</table>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<table>
			<tr>
				<td>&nbsp;</td>
				<td align="left">
					<cfif isdefined('attributes.keyword')and len(attributes.keyword)>
						<cfset adres_ = "objects2.search_result&keyword=#attributes.keyword#">
					<cfelse>
						<cfset adres_ = "objects2.search_result">
					</cfif>
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#adres_#"> 
				</td>
				<td style="text-align:right;"> 
					<cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
				</td>
			</tr>
		</table>
	</cfif>	
<cfelse>
	<table style="width:100%;">
		<tr>
			<td><cf_get_lang_main no='524.Aradığınız Kriterlere Uygun Kayıt Bulunamadı'>!</td>
		</tr>
	</table>
</cfif>

