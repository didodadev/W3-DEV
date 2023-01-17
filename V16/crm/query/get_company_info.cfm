<cfif len(attributes.company_name) or len(attributes.company_partner_name) or len(attributes.company_partner_surname) or len(attributes.company_partner_tax_no) or len(attributes.company_partner_tel)>
	<cfscript>
		attributes.company_name = trim(attributes.company_name);
		attributes.company_partner_name = trim(attributes.company_partner_name);
		attributes.company_partner_surname = trim(attributes.company_partner_surname);
		attributes.company_partner_tax_no = trim(attributes.company_partner_tax_no);
		attributes.company_partner_tel = trim(attributes.company_partner_tel);
	</cfscript>
	<cfquery name="get_company_info" datasource="#dsn#">
		SELECT 
			COMPANY.COMPANY_ID,
			COMPANY.FULLNAME,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY.TAXOFFICE,
			COMPANY.TAXNO,
			COMPANY.COMPANY_TELCODE,
			COMPANY.COMPANY_TEL1,
			COMPANY.ISPOTANTIAL,
			COMPANY.COMPANY_STATE
		FROM 
			COMPANY,
			COMPANY_PARTNER
		WHERE 
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
			COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
			(
				COMPANY.COMPANY_ID IS NULL
				<cfif len(attributes.company_name)>OR COMPANY.FULLNAME LIKE '%#attributes.company_name#%'</cfif>
				<cfif len(attributes.company_partner_name) or len(attributes.company_partner_surname)>
					<cfif database_type is "MSSQL">
						OR COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' '+ COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#attributes.company_partner_name# #attributes.company_partner_surname#'
					<cfelseif database_type is "DB2">
						OR COMPANY_PARTNER.COMPANY_PARTNER_NAME ||' '|| COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#attributes.company_partner_name# #attributes.company_partner_surname#'
					</cfif>
				</cfif>
				<cfif len(attributes.company_partner_tax_no)>OR COMPANY.TAXNO = '#attributes.company_partner_tax_no#'</cfif>
				<cfif len(attributes.company_partner_tel)>OR COMPANY.COMPANY_TEL1 = '#attributes.company_partner_tel#'</cfif>
			)
		ORDER BY
			COMPANY.FULLNAME
	</cfquery>
</cfif>

