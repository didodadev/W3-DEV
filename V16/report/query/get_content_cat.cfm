<!--- <cfquery name="GET_CONTENT_CAT" datasource="#dsn#">
	SELECT 
		CONTENTCAT_ID, 
		CONTENTCAT 
	FROM 
		CONTENT_CAT 
	WHERE 
		CONTENTCAT_ID <> 0 
	ORDER BY 
		CONTENTCAT
</cfquery> --->
<cfquery name="GET_CONTENT_CAT" datasource="#dsn#">
	SELECT 
		CONTENTCAT_ID, 
		CONTENTCAT 
	FROM 
		CONTENT_CAT LEFT JOIN CONTENT_CAT_COMPANY CCC ON CONTENT_CAT.CONTENTCAT_ID = CCC.CONTENTCAT_ID
	WHERE 
		LANGUAGE_ID = '#session.ep.language#' AND
		CONTENTCAT_ID <> 0 AND
		(
			CCC.COMPANY_ID = #session.ep.company_id# OR
			CCC.COMPANY_ID IS NULL
		)	
	ORDER BY 
		CONTENTCAT
</cfquery>
