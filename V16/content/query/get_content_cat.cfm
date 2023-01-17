<cfquery name="GET_CONTENT_CAT" datasource="#DSN#">
	SELECT  DISTINCT
		CC.CONTENTCAT_ID, 
		CONTENTCAT 
	FROM 
		CONTENT_CAT CC
	WHERE 
		CC.CONTENTCAT_ID <> 0 AND
		(
			CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
		)	
	ORDER BY 
		CONTENTCAT
</cfquery>
