<cfquery name="get_partner_all" datasource="#dsn#">
	SELECT
		CP.PARTNER_ID, 
		CP.COMPANY_PARTNER_EMAIL, 
		CP.HOMEPAGE, CP.COUNTY, 
		CP.COMPANY_PARTNER_ADDRESS, 
		CP.COMPANY_PARTNER_FAX,
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		CP.COMPANY_PARTNER_TEL,
		CP.MOBIL_CODE,
		CP.MOBILTEL,
		CP.TITLE,
		C.FULLNAME,
		C.COMPANY_ID
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE
		C.COMPANY_ID = CP.COMPANY_ID
		AND
		C.ISPOTANTIAL = 1	
	<cfif isDefined('attributes.search_status') and LEN(attributes.search_status)>
		AND CP.COMPANY_PARTNER_STATUS = #attributes.search_status#
	</cfif>	
	
	<cfif isDefined("attributes.COMP_CAT") AND not isDefined("attributes.CPID") and LEN(attributes.COMP_CAT)>
		AND	C.COMPANYCAT_ID=#attributes.COMP_CAT#
	<cfelseif isDefined("attributes.CPID")>
		AND C.COMPANY_ID = #attributes.CPID#
	<cfelseif isDefined("attributes.COMPANYCAT_ID") and LEN(attributes.COMPANYCAT_ID)>
		AND C.COMPANYCAT_ID = #attributes.COMPANYCAT_ID#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
	 AND 
		 (
		 CP.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' 
		 OR 
		 CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' 
		 OR
		 C.FULLNAME LIKE '%#attributes.keyword#%' 
		 OR 
		 C.NICKNAME LIKE '%#attributes.keyword#%'
		 )
		<cfif isDefined("attributes.COMP_CAT") and  LEN(attributes.COMP_CAT)>
		 AND 
		 C.COMPANYCAT_ID = #FORM.COMP_CAT#
		</cfif>
	</cfif>
	ORDER BY 
		CP.COMPANY_PARTNER_NAME
</cfquery>
