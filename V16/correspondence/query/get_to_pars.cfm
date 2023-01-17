<cfquery name="GET_TO_PARS" datasource="#DSN#">
	SELECT	
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER_EMAIL
	FROM 	
		COMPANY_PARTNER
	WHERE
		PARTNER_ID  IN  (#ListSort(attributes.to_pars,"NUMERIC")#)
</cfquery>
<cfset to_id = "">
<cfloop query="get_to_pars">
   <cfif len(company_partner_email)>
	   <cfset to_id = '#company_partner_email#,'>
   </cfif>
</cfloop>
<cfif len(to_id)>
	<cfset to_id = Left(to_id,(Len(to_id) -1))>
</cfif>
<cfset get_to_pars_fullname = "">
<cfoutput query="get_to_pars">
	<cfset get_to_pars_fullname = get_to_pars_fullname & "," & company_partner_name & " " & company_partner_surname>
</cfoutput>
