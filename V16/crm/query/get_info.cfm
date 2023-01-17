<cfquery name="get_info" datasource="#dsn#">
SELECT 
		C.NICK_NAME,CP.COMPANY_PARTNER_NAME,CP.COMPANY_PARTNER_SURNAME,
FROM 
	COMPANY C, COMPANY_PARTNER CP 
WHERE 
COMPANY_ID IS NOT NULL AND
<cfif len(attributes.company_name>
C.FULLNAME LIKE '%attributes.company_name%' AND 
</cfif>
<cfif len(attributes.company_partner_name)>
COMPANY_PARTNER_NAME LIKE '%attributes.company_partner_name%' AND 
</cfif>
<cfif len(attributes.company_partner_surname)>
COMPANY_PARTNER_SURNAME LIKE '%attributes.company_partner_surname%' AND
</cfif>
<cfif len(attributes.company_partner_tax_no)>
TAXNO LIKE '%attributes.company_partner_tax_no%' AND
</cfif>
<cfif len(attributes.company_partner_tel_code)>
COMPANY_ LIKE '%attributes.company_partner_tel_code%' AND
</cfif>
<cfif len(attributes.company_partner_tel)>
COMPANY_PARTNER_NAME LIKE '%attributes.company_partner_tel%'
</cfif>
</cfquery>
