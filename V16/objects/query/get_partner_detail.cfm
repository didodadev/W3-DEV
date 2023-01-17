<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
	SELECT
		CP.COMPANY_PARTNER_NAME,	
		CP.COMPANY_PARTNER_SURNAME,
		CP.COMPANY_PARTNER_USERNAME,
		CP.COMPANY_PARTNER_EMAIL,
		CP.MOBIL_CODE,
		CP.MOBILTEL,
		CP.PARTNER_ID,
		CP.COMPANY_ID,
		C.FULLNAME,	
		C.NICKNAME
	FROM
		COMPANY_PARTNER CP,
		COMPANY C,
		COMPANY_CAT CT
	WHERE
		CP.COMPANY_ID = C.COMPANY_ID AND	
	<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>   
		CP.PARTNER_ID = #attributes.PARTNER_ID# AND
	</cfif> 
	<cfif isdefined("partner_id_list") and len(partner_id_list)>   
		CP.PARTNER_ID IN (#partner_id_list#) AND
	</cfif>
		CT.COMPANYCAT_ID = C.COMPANYCAT_ID
</cfquery>
