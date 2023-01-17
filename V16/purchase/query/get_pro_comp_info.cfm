<cfquery name="get_co"  datasource="#DSN#">
	SELECT
		C.COMPANY_ID,
		C.NICKNAME,
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		CP.PARTNER_ID
	FROM
		COMPANY C,
		COMPANY_PARTNER CP,
		#dsn3_alias#.PRODUCT P,
		#dsn3_alias#.STOCKS S
	WHERE
		C.COMPANY_ID = CP.COMPANY_ID AND
		C.COMPANY_ID = P.COMPANY_ID AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
		S.STOCK_ID = #attributes.STOCK_ID#
</cfquery>
<cfif get_co.recordcount>
	<cfset attributes.company_name = get_co.NICKNAME>
	<cfset attributes.company_id = get_co.COMPANY_ID>
	<cfset attributes.emp_name = "#get_co.COMPANY_PARTNER_NAME# #get_co.COMPANY_PARTNER_SURNAME#">
	<cfset attributes.partner_id = get_co.PARTNER_ID>
</cfif>

