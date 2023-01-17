<cfquery name="get_partner_all" datasource="#dsn#">
	SELECT 	
		C.COMPANY_ID,C.FULLNAME,
		CP.MOBILTEL,
		CP.MOBIL_CODE, CP.IMCAT_ID,
		CP.COMPANY_PARTNER_TEL, 
		CP.COMPANY_PARTNER_TELCODE, 
		CP.MISSION, 
		CP.DEPARTMENT, 
		CP.TITLE,
		CP.COMPANY_PARTNER_SURNAME, 
		CP.COMPANY_PARTNER_NAME, 
		CP.PARTNER_ID, 
		CP.COMPANY_PARTNER_EMAIL, 
		CP.HOMEPAGE, 
		CP.COUNTY, 
		CP.COMPANY_PARTNER_ADDRESS, 
		CP.COMPANY_PARTNER_FAX
	FROM
		COMPANY_PARTNER CP, COMPANY C
	WHERE
		C.COMPANY_ID = CP.COMPANY_ID
	<cfif isDefined("attributes.search_potential") and len(attributes.search_potential)>
		AND C.ISPOTANTIAL = #attributes.search_potential#
	</cfif>		
    <cfif isDefined('attributes.search_status') and len(attributes.search_status)> 
		AND CP.COMPANY_PARTNER_STATUS = #attributes.search_status#
	</cfif>		
	<cfif len(attributes.partner_position)> 
		AND CP.MISSION = #attributes.partner_position#
	</cfif>		
	<cfif len(attributes.partner_department)> 
		AND CP.DEPARTMENT = #attributes.partner_department#
	</cfif>		
	<cfif isDefined("attributes.CPID") and len(attributes.CPID)>
		AND C.COMPANY_ID = #attributes.CPID#
	<cfelseif isDefined("attributes.COMP_CAT") and len(attributes.COMP_CAT)>
		AND C.COMPANYCAT_ID=#attributes.COMP_CAT#
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
			OR
			CP.TITLE LIKE '%#attributes.keyword#%' 
		)
	</cfif>
	ORDER BY 
		CP.COMPANY_PARTNER_NAME
</cfquery>

