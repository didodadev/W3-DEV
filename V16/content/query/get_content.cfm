<cfif isdefined("attributes.cat") and len(attributes.cat)>
	<cfif listgetat(attributes.cat,1,"-") is "cat">
		<cfset cont_st = "cat">
	<cfelse>
		<cfset cont_st = "ch">
	</cfif>
</cfif>
<cfif not isdefined("attributes.cntid") and (not isdefined("form.mail_c"))>
	<cfquery name="GET_CONTENT" datasource="#DSN#">
		SELECT
			<!---C.CATALOG_ID,--->
			C.CONTENT_ID,
            C.CONT_HEAD,
            C.CONTENT_PROPERTY_ID,
            C.RECORD_DATE,
            C.STAGE_ID,
			C.LANGUAGE_ID,
            C.CONTENT_STATUS,
            C.HIT,
            C.HIT_PARTNER,
            C.HIT_EMPLOYEE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			CA.CONTENTCAT,
			CA.CONTENTCAT_ID,
			CC.CHAPTER
	 	FROM
			CONTENT C, 
			CONTENT_CHAPTER CC,
			CONTENT_CAT CA,
			EMPLOYEES E
		WHERE
			CA.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
			CC.CHAPTER_ID = C.CHAPTER_ID AND
            CA.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
			<cfif isdefined ("attributes.record_member_id") and len(attributes.record_member_id) and len(attributes.record_member)>
                AND C.RECORD_MEMBER=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
            </cfif> 
                AND E.EMPLOYEE_ID = C.RECORD_MEMBER
            <cfif isdefined ("attributes.language_id") and len(attributes.language_id)>
                AND C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">
            </cfif>
			<cfif isDefined("attributes.id")>AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"></cfif>
			<cfif not isDefined("attributes.keyword")>AND CA.CONTENTCAT_ID <> 0</cfif>
			<cfif isdefined("attributes.stage_id") and len(attributes.stage_id)>AND C.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stage_id#"></cfif>
			<cfif isdefined("attributes.status") and attributes.status is 1>AND C.CONTENT_STATUS = 1</cfif>
			<cfif isdefined("attributes.status") and attributes.status is 2>AND C.CONTENT_STATUS = 0</cfif>
			<cfif isdefined("attributes.priority") and len(attributes.priority)>AND C.PRIORITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority#"></cfif>
			<cfif isdefined("attributes.content_property_id") and len(attributes.content_property_id)>
                AND C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_property_id#">
            </cfif>
            <cfif not isDefined("CONT_ST")>AND CA.CONTENTCAT_ID <> 0</cfif>
            <cfif isDefined("CONT_ST") AND CONT_ST IS "CH">
                AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#LISTGETAT(attributes.CAT,2,"-")#">
            <cfelseif isDefined("CONT_ST") AND CONT_ST IS "CAT">
                AND CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#LISTGETAT(attributes.CAT,2,"-")#">
            </cfif>
            <cfif isdefined ("attributes.record_date") and len(attributes.record_date)>
                AND C.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
                AND C.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,attributes.record_date)#">
            </cfif>
			<cfif isdefined("attributes.record_id") and len(attributes.record_id)>AND C.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_id#"></cfif>
			<cfif isdefined("attributes.update_id") and len(attributes.update_id)>AND C.UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.update_id#"></cfif>
			<cfif isdefined("attributes.spot")>AND C.SPOT = 1</cfif>
			<cfif isdefined("attributes.none_tree")>AND C.NONE_TREE = 1</cfif>
			<cfif isdefined("attributes.is_dsp_header")>AND C.IS_DSP_HEADER = 1</cfif>
			<cfif isdefined("attributes.is_dsp_summary")>AND C.IS_DSP_SUMMARY = 1</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                AND (
                       <!---  BK 20131012 6 aya kaldirilsin C.USER_FRIENDLY_URL LIKE '%#attributes.keyword#%' OR 
						C.CONT_HEAD LIKE '%#attributes.keyword#%' OR 
						C.CONT_SUMMARY LIKE '%#attributes.keyword#%' OR --->
						<cfif isdefined("is_fulltext_search") and is_fulltext_search eq 1 >
							CONTAINS(C.*,'"#attributes.keyword#*"') 
						<cfelse>
							C.USER_FRIENDLY_URL LIKE #sql_unicode()#'%#attributes.keyword#%' OR 
							C.CONT_HEAD LIKE #sql_unicode()#'%#attributes.KEYWORD#%' OR 
							C.CONT_SUMMARY LIKE #sql_unicode()#'%#attributes.KEYWORD#%' OR 
							C.CONT_BODY LIKE #sql_unicode()#'%#attributes.KEYWORD#%'
						</cfif>	
                    )
            </cfif>
            <cfif isDefined("attributes.user_friendly_url") and len(attributes.user_friendly_url)>
                AND (C.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.user_friendly_url#%">)
            </cfif>
            <cfif isdefined("attributes.ana_sayfa")>
                AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%1%">
            </cfif>
            <cfif isdefined("attributes.ana_sayfayan")>
                AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%2%">
            </cfif>
            <cfif isdefined("attributes.bolum_basi")>
                AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%3%">
            </cfif>
            <cfif isdefined("attributes.bolum_yan")>
                AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%4%">
            </cfif>
            <cfif isdefined("attributes.ch_bas")>
                AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%5%">
            </cfif>
            <cfif isdefined("attributes.ch_yan")>
                AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%6%">
            </cfif>
            <cfif isdefined("attributes.none_tree")>
                AND C.NONE_TREE = 1
            </cfif>
            <cfif isdefined("attributes.is_viewed")>
                AND C.IS_VIEWED = 1
            </cfif>
			<cfif isdefined("attributes.order_type") and attributes.order_type eq 1>
                ORDER BY C.RECORD_DATE DESC
            <cfelseif isdefined("attributes.order_type") and attributes.order_type eq 2>
                ORDER BY 
                C.PRIORITY ASC ,
                C.RECORD_DATE DESC
            <cfelseif isdefined("attributes.order_type") and attributes.order_type eq 3>
                ORDER BY
                C.HIT DESC
            <cfelseif isdefined("attributes.order_type") and attributes.order_type eq 4>
                ORDER BY
                C.HIT_PARTNER DESC
            <cfelseif isdefined("attributes.order_type") and attributes.order_type eq 5>
                ORDER BY  
                C.HIT_EMPLOYEE DESC
            </cfif>
	</cfquery>
<cfelse>
	<cfquery name="GET_CONTENT" datasource="#DSN#">
		SELECT
			<!---C.CATALOG_ID,--->
			C.SPOT,
			C.IS_VIEWED,
			C.INTERNET_VIEW,
			C.CAREER_VIEW,
			C.EMPLOYEE_VIEW,
			C.COMPANY_CAT,
			C.CONSUMER_CAT,
			C.POSITION_CAT_IDS,
			C.USER_GROUP_IDS,
			C.CONT_POSITION,
			C.NONE_TREE,
			C.CHAPTER_ID,
			C.IS_DSP_HEADER,
			C.IS_DSP_SUMMARY,
			C.CONT_SUMMARY,
			C.USER_FRIENDLY_URL,
			C.VIEW_DATE_START,
			C.VIEW_DATE_FINISH,
			C.PRIORITY,
			C.PROCESS_STAGE,
			C.OUTHOR_EMP_ID,
			C.OUTHOR_PAR_ID,
			C.OUTHOR_CONS_ID,
			C.WRITING_DATE,
			C.WRITE_VERSION,
			C.VERSION_DATE,
			C.CONT_BODY,
			C.UPD_COUNT,
			C.UPDATE_MEMBER,
			C.UPDATE_DATE,
			C.CONTENT_ID,
            C.CONT_HEAD,
            C.CONTENT_PROPERTY_ID,
            C.RECORD_DATE,
            C.STAGE_ID,
			C.LANGUAGE_ID,
            C.CONTENT_STATUS,
            C.HIT,
            C.HIT_PARTNER,
            C.HIT_EMPLOYEE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			CC.CONTENTCAT_ID, 
			CCH.CHAPTER,
			CC.CONTENTCAT
		FROM 
			EMPLOYEES E,
			CONTENT C,
			CONTENT_CAT CC, 
			CONTENT_CHAPTER CCH
		WHERE 
         	C.CHAPTER_ID = CCH.CHAPTER_ID AND 
			CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
			E.EMPLOYEE_ID = C.RECORD_MEMBER AND
            CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
		<cfif isdefined('attributes.record_member_id') and len(attributes.record_member_id) and  isdefined('attributes.record_member') and len(attributes.record_member)>
			AND C.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_member_id#">
		</cfif>    
		<cfif isDefined("attributes.cntid")>
			AND C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
		</cfif>
		ORDER BY 
			C.CONTENT_ID DESC
	</cfquery>
</cfif>
