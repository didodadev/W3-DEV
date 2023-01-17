<cfquery name="GET_CHAPTER_NAME" datasource="#DSN#">
	SELECT 
		CHAPTER,
		CONTENTCAT_ID 
	FROM 
		CONTENT_CHAPTER
	WHERE 
		CHAPTER_ID = <cfif isdefined("url.chpid")>#url.chpid#<cfelseif isdefined("url.id")>#url.id#<cfelseif isdefined("attributes.chpid")>#attributes.chpid#</cfif>
</cfquery>
