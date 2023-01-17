<cfquery name="get_partner_all" datasource="#dsn#">
	SELECT 	
		C.COMPANY_ID,
		C.FULLNAME,
		CP.MOBILTEL,
		CP.MOBIL_CODE, 
		CP.IMCAT_ID,
		CP.COMPANY_PARTNER_TEL, 
		CP.COMPANY_PARTNER_TELCODE,
		CP.COMPANY_PARTNER_TEL_EXT,
		CP.MISSION, 
		CP.DEPARTMENT, 
		CP.TITLE,
		CP.COMPANY_PARTNER_SURNAME, 
		CP.COMPANY_PARTNER_NAME, 
		CP.PARTNER_ID, 
		CP.COMPANY_PARTNER_EMAIL, 
		CP.HOMEPAGE, 
		CP.COUNTY,
		CP.COUNTRY,
		CP.COMPANY_PARTNER_ADDRESS, 
		CP.COMPANY_PARTNER_FAX,
		CP.PDKS_NUMBER,
		CP.START_DATE,
		CP.FINISH_DATE
	FROM
		COMPANY_PARTNER CP
		LEFT JOIN COMPANY AS C ON CP.COMPANY_ID = C.COMPANY_ID
	WHERE
		1 = 1
	<cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 1>
		AND C.IS_BUYER = 1
	<cfelseif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 2>
		AND C.IS_SELLER = 1
	</cfif>
	<cfif isDefined("attributes.search_potential") and len(attributes.search_potential)>
		AND C.ISPOTANTIAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_potential#">
	</cfif>		
    <cfif isDefined('attributes.search_status') and len(attributes.search_status)> 
		AND CP.COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_status#">
	</cfif>		
	<cfif len(attributes.partner_position)> 
		AND CP.MISSION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_position#">
	</cfif>		
	<cfif len(attributes.partner_department)> 
		AND CP.DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_department#">
	</cfif>		
	<cfif isDefined("attributes.cpid") and len(attributes.cpid)>
		AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	<cfelseif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>
		AND C.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_cat#">
	</cfif>
	<cfif len(attributes.keyword) and len(attributes.keyword) eq 1>
		AND
		(
			C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
			C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 

		)
	<cfelseif len(attributes.keyword)>
		AND
		(	C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
			C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
			C.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
			C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	<cfif len(attributes.keyword_partner)>
		AND
		(
		<cfif (database_type is 'MSSQL')>
			CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		<cfelseif (database_type is 'DB2')>
			CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		</cfif>
		CP.TITLE LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		CP.PDKS_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_partner#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	ORDER BY 
		CP.COMPANY_PARTNER_NAME
</cfquery>

