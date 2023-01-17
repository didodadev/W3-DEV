<cfquery name="GET_CHAPTER_NAMES" datasource="#dsn#">
	SELECT
		*
	FROM
		CONTENT_CHAPTER
	WHERE
		CONTENTCAT_ID = #attributes.CONTENTCAT_ID#
	ORDER BY 
		HIERARCHY
</cfquery>
