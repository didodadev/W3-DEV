<!--- get_company_cat.cfm --->
<cfquery name="GET_COMPANYCAT" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT
	WHERE
		COMPANYCAT_TYPE = 1
	ORDER BY
		COMPANYCAT
</cfquery>
