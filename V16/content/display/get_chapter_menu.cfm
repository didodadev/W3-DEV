<cfquery name="GET_CHAPTER_MENU" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CONTENT_CHAPTER
	<cfif isDefined("attributes.cont_catid")>
		WHERE 
			CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cont_catid#">
	</cfif>
	ORDER BY 
		HIERARCHY
	</cfquery>

