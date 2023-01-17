<cfquery name="GET_HOMEPAGE_NEWS" datasource="#DSN#" maxrows="10">
	SELECT 
		CCH.CONTENTCAT_ID, 
		CCH.CHAPTER,
		CC.CONTENTCAT, 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.PRIORITY,
		C.COMPANY_CAT,
		C.RECORD_MEMBER,
		C.RECORD_DATE,
		C.CONT_SUMMARY,
		C.CONT_POSITION,
		C.CONSUMER_CAT,
		C.COMPANY_CAT,
		C.CONTENT_PROPERTY_ID,
		C.CHAPTER_ID,
		C.IS_DSP_SUMMARY		
	  FROM 
		CONTENT C ,
		CONTENT_CAT CC, 
		CONTENT_CHAPTER CCH
	  WHERE 	
		C.EMPLOYEE_VIEW = 1 AND 
		C.CHAPTER_ID = CCH.CHAPTER_ID AND
		CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND 
		CC.LANGUAGE_ID = '#SESSION.EP.LANGUAGE#' AND 
		C.STAGE_ID = -2 AND 
		C.CONTENT_STATUS = 1
	<cfif not isdefined("attributes.is_from_rule")>
		AND CAST(C.CONT_POSITION AS CHAR(6)) LIKE '%1%'
	</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			<cfif isdefined("is_fulltext_search") and is_fulltext_search eq 1 >
				<!--- BK 20131012 6 aya kaldirilsin C.CONT_SUMMARY LIKE '%#attributes.keyword#%' OR
				C.CONT_BODY LIKE '%#attributes.keyword#%' OR
				C.CONT_HEAD LIKE '%#attributes.keyword#%' OR--->			
				CONTAINS(C.*,'"#attributes.keyword#*"') OR
				CC.CONTENTCAT LIKE '%#attributes.keyword#%' OR
				CCH.CHAPTER LIKE '%#attributes.keyword#%'
			<cfelse>
				C.CONT_SUMMARY LIKE '%#attributes.keyword#%' OR
				C.CONT_BODY LIKE '%#attributes.keyword#%' OR
				C.CONT_HEAD LIKE '%#attributes.keyword#%' OR
				CC.CONTENTCAT LIKE '%#attributes.keyword#%' OR
				CCH.CHAPTER LIKE '%#attributes.keyword#%'
			</cfif>
		)
		</cfif>
	 ORDER BY 
		C.PRIORITY ASC,
		C.UPDATE_DATE DESC	
</cfquery>