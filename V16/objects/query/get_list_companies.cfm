<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT
		MEMBER_CODE,
		COMPANY_ID,
		COMPANY_POSTCODE,
		COMPANY_TELCODE,
		COMPANY_TEL1,
		COUNTY,
		CITY,
		COUNTRY,			
		COMPANY_ADDRESS,
		FULLNAME
	FROM 
		COMPANY
	WHERE
		COMPANY_STATUS = 1 <!--- IC 20050218 company_status pasif olanlar gelmesin diye eklendi. baska yerde sorun olursa bilgi verilsin --->
		<cfif isDefined("attributes.keyword") and len(attributes.keyword) gte 1>
			AND ( NICKNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR FULLNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' )
		</cfif>
	ORDER BY
		FULLNAME
</cfquery>
