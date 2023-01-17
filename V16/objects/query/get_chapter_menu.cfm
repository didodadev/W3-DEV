<cfquery name="GET_CHAPTER_MENU" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		CONTENT_CHAPTER
 	<cfif isDefined("attributes.cont_catid") and len(attributes.cont_catid)>
	WHERE 
		CONTENTCAT_ID = #attributes.cont_catid#
	</cfif>
	ORDER BY 
		HIERARCHY
</cfquery>
