<!--- get_chapter_list.cfm --->
<cfquery name="CHAPTER_LIST" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CONTENT_CHAPTER 
		<cfif isDefined("url.cat")>
		WHERE 
			CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cat#">
		</cfif>
	ORDER BY 
		HIERARCHY 
</cfquery>
