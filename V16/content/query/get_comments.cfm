<cfif isdefined("attributes.cat") and len(attributes.cat)>
	<cfif listgetat(attributes.cat,1,"-") is "cat">
		<cfset cont_st = "cat">
	<cfelse>
		<cfset cont_st = "ch">
	</cfif>
</cfif>

<cfquery name="GET_COMMENTS" datasource="#DSN#">
	SELECT 
		CC.CONTENT_COMMENT_POINT,
		CC.CONTENT_ID,
		CC.STAGE_ID,
		CC.RECORD_DATE,
		CC.NAME,
		CC.SURNAME,
		CC.CONTENT_COMMENT_ID,
		C.CONT_HEAD 
	FROM
		CONTENT C,
		CONTENT_CAT CA,
		CONTENT_COMMENT CC,
		CONTENT_CHAPTER CH
		
	WHERE 
		CA.CONTENTCAT_ID = CH.CONTENTCAT_ID AND 
		CH.CHAPTER_ID = C.CHAPTER_ID AND
		C.CONTENT_ID = CC.CONTENT_ID
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND (C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR CC.CONTENT_COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
		</cfif>
		<cfif not isDefined("cont_st")>
			AND CA.CONTENTCAT_ID <> 0
			</cfif>							
			<cfif isDefined("cont_st") and cont_st is "ch">
			AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.cat,2,"-")#">
			<cfelseif isDefined("cont_st") and cont_st is "cat">
			AND CH.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.cat,2,"-")#">
		</cfif>
	ORDER BY 
		CC.RECORD_DATE DESC
</cfquery>
