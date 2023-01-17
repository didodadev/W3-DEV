<cfquery name="GET_TO_PARS" datasource="#dsn#">
	SELECT
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	WHERE
		PARTNER_ID  IN  (#LISTSORT(attributes.TO_PARS,"NUMERIC")#)
</cfquery>
<cfset fullname = ''>
<cfloop query="get_to_pars">
	<cfset fullname = fullname & get_to_pars.company_partner_name & ' ' & get_to_pars.company_partner_surname & ','>
</cfloop>
<cfif Len(fullname) gt 1>
<cfset fullname = Left(fullname,len(fullname) - 1)>
</cfif>
