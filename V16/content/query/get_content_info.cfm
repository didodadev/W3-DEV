<cfquery name="GET_CONTENT" datasource="#dsn#">
	SELECT 
		CONTENT_ID,
		CONT_HEAD,
		RECORDDATE
		<cfif #isDefined("URL.CNTID")#>,
		CONT_SUMMARY,
		CONT_BODY</cfif> 
	FROM 
		CONTENT
		<cfif #isDefined("URL.CHPID")#>
	WHERE 
		CHAPTER_ID = #URL.CHPID#
		</cfif>
</cfquery>
