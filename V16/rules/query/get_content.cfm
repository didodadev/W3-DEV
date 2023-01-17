<!---Kendi pozisyonunuzun erişim yetkilerini kontrol edip aşamanızın 'yayın' olacak şekilde seçili olmasını sağlayınız.--->
<cfif isdefined("attributes.cat") and len(attributes.cat)>
	<cfif listgetat(attributes.cat,1,"-") is "cat">
		<cfset cont_st = "cat">
	<cfelse>
		<cfset cont_st = "ch">
	</cfif>
</cfif>
<cfquery name="GET_MY_POSITION_CAT_USER_GROUP" datasource="#DSN#">
	SELECT POSITION_CAT_ID,USER_GROUP_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="GET_CONTENT" datasource="#DSN#">
	SELECT 
		CCH.CONTENTCAT_ID, 
		CCH.CHAPTER,
		CC.CONTENTCAT, 
		C.CONTENT_ID,
		C.POSITION_CAT_IDS,
		C.UPDATE_MEMBER,
		C.UPD_COUNT,
		C.UPDATE_DATE,
		C.EMPLOYEE_VIEW,
		C.INTERNET_VIEW,
		C.CONT_HEAD,
		C.NONE_TREE,
		C.PRIORITY,
		C.RECORD_MEMBER,
		C.RECORD_DATE,
		C.CONT_SUMMARY,
		C.CONT_BODY,
		C.CONT_SUMMARY,
		C.CONT_POSITION,
		C.CONSUMER_CAT,
		C.COMPANY_CAT,
		C.HIT_EMPLOYEE,
		C.CONTENT_PROPERTY_ID,
		C.CHAPTER_ID,
		C.IS_DSP_HEADER,
		C.IS_DSP_SUMMARY,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_EMAIL,
		E.EMPLOYEE_ID,
		C.HIT_PARTNER,
		C.HIT_EMPLOYEE,
		C.HIT,
		CP.NAME,
		C.RECORD_MEMBER AS RECORD_EMP,
		C.UPDATE_MEMBER AS UPDATE_EMP,
		C.RECORD_DATE,
		C.UPDATE_DATE
	  FROM 
		EMPLOYEES E,
		CONTENT C,
		CONTENT_CAT CC, 
		CONTENT_PROPERTY CP, 
		CONTENT_CHAPTER CCH
	WHERE 	
    	<!---CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)--->
		1 = 1
        <cfif isDefined("attributes.training") and attributes.training eq 1>
            AND CC.IS_TRAINING = 1
        </cfif>
		<cfif isdefined("attributes.cntid") and len(attributes.cntid)>
            <cfif listlen(attributes.cntid) eq 1>
            	AND C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
            <cfelse>
            	AND C.CONTENT_ID IN (#attributes.cntid#)
            </cfif>
        <cfelseif isdefined("attributes.chapter") and len(attributes.chapter)>
            AND CCH.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter#">
        <cfelseif isdefined("attributes.cont_catid") and len(attributes.cont_catid)>
            AND CCH.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cont_catid#">
        </cfif>
		AND
		(
            C.EMPLOYEE_VIEW = 1 OR
            ','+C.POSITION_CAT_IDS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.position_cat_id#,%">
            <cfif len(get_my_position_cat_user_group.user_group_id)>
                OR ','+C.USER_GROUP_IDS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.user_group_id#,%">
            </cfif>
		) AND
		E.EMPLOYEE_ID = C.RECORD_MEMBER AND	
		C.CHAPTER_ID = CCH.CHAPTER_ID AND
		CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND 
		C.STAGE_ID IN (-2,1)
		<cfif not isDefined("attributes.keyword")>AND CC.CONTENTCAT_ID <> 0</cfif>
		<cfif isdefined("attributes.status") and attributes.status is 1>AND C.CONTENT_STATUS = 1</cfif>
		<cfif isdefined("attributes.status") and attributes.status is 2>AND C.CONTENT_STATUS = 0</cfif>
		<cfif isdefined("attributes.priority") and len(attributes.priority)>AND C.PRIORITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.priority#"></cfif>
		<cfif isdefined("attributes.chapter") and len(attributes.chapter)>AND CCH.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter#"></cfif>
		<cfif isdefined("attributes.cat") and len(attributes.cat)>AND CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#"></cfif>
		<cfif isdefined("attributes.content_property_id") and len(attributes.content_property_id)>AND C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_property_id#"></cfif>
		<cfif not isDefined("CONT_ST")>AND CC.CONTENTCAT_ID <> 0</cfif>
		<cfif isdefined("attributes.search_date1") and len(attributes.search_date1)>
			AND C.RECORD_DATE >= #attributes.search_date1#
			AND C.RECORD_DATE < #DATEADD("d",1,attributes.search_date1)#
		</cfif>
		<cfif isdefined("attributes.search_date2") and len(attributes.search_date2)>
			AND C.UPDATE_DATE >= #attributes.search_date2#
			AND C.UPDATE_DATE < #DATEADD("d",1,attributes.search_date2)#
		</cfif>
		<cfif isdefined("attributes.record_id") and len(attributes.record_id)>AND C.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_id#"></cfif>
		<cfif isdefined("attributes.upd_id") and len(attributes.upd_id)>AND C.UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#"></cfif>
		<cfif isdefined("attributes.spot")>AND C.SPOT = 1</cfif>
		<cfif isdefined("attributes.none_tree")>AND C.NONE_TREE = 1</cfif>
		<cfif isdefined("attributes.keyword1") and len(attributes.keyword1)>
			AND C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword1#%">			
		</cfif>
		<cfif not(isdefined("attributes.cntid") and len(attributes.cntid))>
			AND C.CONTENT_PROPERTY_ID = CP.CONTENT_PROPERTY_ID 
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            AND
            (
				<cfif isdefined("is_fulltext_search") and is_fulltext_search eq 1 >
					CONTAINS(C.*,'"#attributes.keyword#*"') OR
					CC.CONTENTCAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					CCH.CHAPTER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				<cfelse>
					C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					C.CONT_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					CC.CONTENTCAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					CCH.CHAPTER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
			)
		</cfif>
		<cfif isdefined("attributes.ana_sayfa") and len(attributes.ana_sayfa)>
			AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ana_sayfa#%">
		</cfif>
		<cfif isdefined("attributes.ana_sayfayani") and len(attributes.ana_sayfayani)>
			AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ana_sayfayani#%">
		</cfif>
		<cfif isdefined("attributes.kategori_basi") and len(attributes.kategori_basi)>
			AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.kategori_basi#%">
		</cfif>
		<cfif isdefined("attributes.kategori_yani") and len(attributes.kategori_yani)>
			AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.kategori_yani#%">
		</cfif>
		<cfif isdefined("attributes.ch_bas") and len(attributes.ch_bas)>
			AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ch_bas#%">
		</cfif>
		<cfif isdefined("attributes.ch_yan") and len(attributes.ch_yan)>
			AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ch_yan#%">
		</cfif>
	ORDER BY 
		C.UPDATE_DATE DESC
</cfquery>