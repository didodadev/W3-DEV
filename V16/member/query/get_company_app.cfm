<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY
	WHERE 
		ISPOTANTIAL = 1
		<cfif isDefined('attributes.search_status') and LEN(attributes.search_status)>
	AND 
		COMPANY_STATUS = #attributes.search_status#	  
		</cfif>		 
		<cfif isDefined("attributes.COMP_CAT") and len(attributes.COMP_CAT)>
	AND	
		COMPANYCAT_ID = #attributes.COMP_CAT# 
		</cfif>
		<cfif isDefined("attributes.KEYWORD")>
	AND 
		FULLNAME LIKE '%#attributes.KEYWORD#%'
		</cfif>
	ORDER BY 
		FULLNAME
</cfquery>
