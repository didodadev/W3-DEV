<cfquery name="GET_CONTENT_CAT" datasource="#dsn#">
    SELECT <cfif isdefined('attributes.max_contentcat_num') and len(attributes.max_contentcat_num)>TOP #attributes.max_contentcat_num#</cfif>
        CCAT.CONTENTCAT_ID,
        CCAT.CONTENTCAT,
        UFU.USER_FRIENDLY_URL
    FROM 
        CONTENT_CAT CCAT
        OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'CONTENTCAT_ID' 
			AND UFU.ACTION_ID = CCAT.CONTENTCAT_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU
    WHERE     
        CCAT.CONTENTCAT_ID <> 0 
</cfquery>

<div>
	<h1>
		<cfif isDefined("attributes.content_menu_header") and len(attributes.content_menu_header)>
			<cf_get_lang dictionary_id='#attributes.content_menu_header#'>
		</cfif>
	</h1>
	<ul>
        <cfoutput query="get_content_cat">   
		<li>
			<a href="#USER_FRIENDLY_URL#">#contentcat# </a>
		</li>
	</cfoutput>
	</ul>
</div>