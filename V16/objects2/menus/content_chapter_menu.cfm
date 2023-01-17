<cfquery name="GET_CHAPTER" datasource="#DSN#">
	SELECT <cfif isdefined('attributes.max_contentchapt_num') and len(attributes.max_contentchapt_num)>TOP #attributes.max_contentchapt_num#</cfif>
		CH.CHAPTER, 
		CH.CHAPTER_ID, 
		CC.CONTENTCAT_ID, 
		CC.CONTENTCAT,
		UFU.USER_FRIENDLY_URL 
	FROM 
		CONTENT_CAT CC, 
		CONTENT_CHAPTER CH
		OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'CHAPTER_ID' 
			AND UFU.ACTION_ID = CH.CHAPTER_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU 
	WHERE 	
		CH.CONTENT_CHAPTER_STATUS = 1 AND		
		CC.CONTENTCAT_ID = CH.CONTENTCAT_ID AND				
		CC.CONTENTCAT_ID IN (
								SELECT 
									CH.CONTENTCAT_ID 
								FROM 
									CONTENT_CHAPTER CH, 
									CONTENT C
								WHERE                                      
									CH.CHAPTER_ID = C.CHAPTER_ID
							)		
	ORDER BY 
		CH.HIERARCHY
</cfquery>

<div>
	<h1>
		<cfif isDefined("attributes.chapter_menu_header") and len(attributes.chapter_menu_header)>
			<cf_get_lang dictionary_id='#attributes.chapter_menu_header#'>
		</cfif>
	</h1>
	<ul>
	<cfoutput query="get_chapter">
		<li>
			<a href="#USER_FRIENDLY_URL#">#chapter#</a>
		</li>
	</cfoutput>
	</ul>
</div>