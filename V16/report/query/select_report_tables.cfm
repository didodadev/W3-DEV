<cfquery name="SELECT_REPORT_TABLES" datasource="#DSN#">
SELECT
	TABLE_ID,  
	TABLE_NAME,  
	TABLE_INREPORT,  
	PERIOD_YEAR,
	COMPANY_ID,
	NICK_NAME_TR,  
	NICK_NAME_EN
FROM
	REPORT_TABLES
WHERE
	1=1
<cfif isdefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
	AND
	(
		TABLE_NAME LIKE '%#attributes.KEYWORD#%'
		OR
		NICK_NAME_TR LIKE '%#attributes.KEYWORD#%'
		OR
		NICK_NAME_EN LIKE '%#attributes.KEYWORD#%'
		OR
		TABLE_NAME LIKE '%#attributes.KEYWORD#%'
	<cfif isnumeric(attributes.keyword)>
		OR
		PERIOD_YEAR LIKE '%#attributes.KEYWORD#%'
	</cfif>
	)
</cfif>
<cfif isdefined("attributes.in_report") and (attributes.in_report neq -1)>
	AND
	TABLE_INREPORT = #attributes.in_report#
<cfelseif not isDefined("attributes.in_report")>
	AND
	TABLE_INREPORT = 1
</cfif>
ORDER BY
	TABLE_NAME
</cfquery>
