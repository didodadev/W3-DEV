<cfquery name="GET_COMPANYCATS" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID, 
		#dsn#.Get_Dynamic_Language(COMPANYCAT_ID,'#session.ep.language#','COMPANY_CAT','COMPANYCAT',NULL,NULL,COMPANYCAT) AS COMPANYCAT
	FROM 
		COMPANY_CAT 
	ORDER BY
		COMPANYCAT
</cfquery>
