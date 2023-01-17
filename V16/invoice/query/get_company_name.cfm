<cfquery name="COMPANY_NAME" datasource="#dsn#">
	SELECT
		NICKNAME,
		FULLNAME
	FROM
		COMPANY
	WHERE
		COMPANY_ID = #attributes.COMPANY_ID#
</cfquery>
