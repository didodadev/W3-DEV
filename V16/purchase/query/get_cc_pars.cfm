<cfquery name="GET_CC_PARS" datasource="#dsn#">
	SELECT
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	WHERE
		PARTNER_ID  IN  (#LISTSORT(attributes.CC_PARS,"NUMERIC")#)
</cfquery>
<cfset fullname = ''>
<cfloop query="get_cc_pars">
	<cfset fullname = fullname & get_cc_pars.company_partner_name & ' ' & get_cc_pars.company_partner_surname & ','>
</cfloop>
<cfif Len(fullname) gt 1>
<cfset fullname = Left(fullname,len(fullname) - 1)>
</cfif>
