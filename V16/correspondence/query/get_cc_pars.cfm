<cfquery name="GET_CC_PARS" datasource="#dsn#">
	SELECT
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER_EMAIL
	FROM 
		COMPANY_PARTNER
	WHERE
		PARTNER_ID  IN  (#LISTSORT(attributes.CC_PARS,"NUMERIC")#)
</cfquery>
<cfset cc_id = "">
<cfloop query="GET_CC_PARS">
   <cfif len(COMPANY_PARTNER_EMAIL)>
	   <cfset cc_id = '#COMPANY_PARTNER_EMAIL#,'>
   </cfif>
</cfloop>
<cfif len(cc_id)>
	<cfset cc_id = Left(cc_id,(Len(cc_id) -1))>
</cfif>
<cfset GET_CC_PARS_FULLNAME = "">
<cfoutput query="GET_CC_PARS">
       <cfset GET_CC_PARS_FULLNAME = GET_CC_PARS_FULLNAME & "," & COMPANY_PARTNER_NAME & " " & COMPANY_PARTNER_SURNAME>
</cfoutput>	
