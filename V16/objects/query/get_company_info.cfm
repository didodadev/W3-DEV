<cfquery name="COMPANY_NAME" datasource="#DSN#">
	SELECT
		NICKNAME,
		COMPANY_ID,
		FULLNAME,
		COMPANY_ADDRESS,
		COUNTY,
		CITY,
		COUNTRY,
		TAXOFFICE,
		TAXNO
	FROM
		COMPANY
	WHERE
		COMPANY_ID = #attributes.company_id#
</cfquery>
