<cfif isdefined("attributes.cpid") and len(attributes.cpid)>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT * FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
	</cfquery>
<cfelse>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT
			C.COMPANY_ID,
			C.FULLNAME,
			C.MANAGER_PARTNER_ID,
			C.COMPANYCAT_ID,
			C.MEMBER_CODE,
			C.OZEL_KOD,
			C.TAXNO,
			C.ISPOTANTIAL,
			C.COMPANY_EMAIL,
			C.COMPANY_TEL1,
			C.COMPANY_TELCODE,
			C.COMPANY_FAX,
			C.POS_CODE,
			C.COMPANYCAT_ID
		FROM
			COMPANY C,
			COMPANY_CAT CC
			<cfif isDefined('attributes.responsible_branch_id') and len(attributes.responsible_branch_id)>
			,SALES_ZONES
			</cfif>
		WHERE
			CC.COMPANYCAT_ID = C.COMPANYCAT_ID AND
			CC.COMPANYCAT_TYPE = 1
			<cfif isDefined('attributes.mem_code') and len(attributes.mem_code)>
				AND (C.MEMBER_CODE LIKE '%#attributes.mem_code#%'
					 OR C.OZEL_KOD LIKE '%#attributes.mem_code#%'
					 OR C.OZEL_KOD_1 LIKE '%#attributes.mem_code#%'
					 OR C.OZEL_KOD_2 LIKE '%#attributes.mem_code#%')
			</cfif>
			<cfif isDefined('attributes.responsible_branch_id') and len(attributes.responsible_branch_id)>AND C.COMPANY_ID = SALES_ZONES.RESPONSIBLE_COMPANY_ID AND SALES_ZONES.RESPONSIBLE_BRANCH_ID = #attributes.responsible_branch_id#</cfif>
			<cfif isDefined("attributes.city") and len(attributes.city)>AND C.CITY = #attributes.city#</cfif>
			<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>AND C.SALES_COUNTY = #attributes.sales_zones#</cfif>
			<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>AND C.POS_CODE = #attributes.pos_code#</cfif>
			<cfif isDefined("attributes.search_potential") and len(attributes.search_potential)>AND C.ISPOTANTIAL = #attributes.search_potential#</cfif>
			<cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>AND C.COMPANYCAT_ID = #attributes.comp_cat#</cfif>
			<cfif isDefined('attributes.search_status') and len(attributes.search_status)>AND C.COMPANY_STATUS = #attributes.search_status#</cfif>
			<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)> AND C.COMPANY_VALUE_ID = #attributes.customer_value#</cfif>
			<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>AND C.COMPANY_STATE = #attributes.process_stage_type#</cfif>
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			AND
			(
				<cfif isnumeric(attributes.keyword)>
					C.COMPANY_ID = #attributes.keyword# OR
				</cfif>
				<cfif len(attributes.keyword) gt 2>
					C.FULLNAME LIKE '%#attributes.keyword#%' OR
					C.NICKNAME LIKE '%#attributes.keyword#%' OR
					C.OZEL_KOD LIKE '%#attributes.keyword#%' OR
					C.TAXNO LIKE '%#attributes.keyword#%'
				<cfelse>
					C.FULLNAME LIKE '#attributes.keyword#%' OR
					C.NICKNAME LIKE '#attributes.keyword#%' OR
					C.OZEL_KOD LIKE '#attributes.keyword#%' OR
					C.TAXNO LIKE '#attributes.keyword#%'
				</cfif>
			)
			</cfif>
		ORDER BY
			C.FULLNAME
	</cfquery>
</cfif>
