<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
	SELECT
		COMPBRANCH__NAME,
		COMPBRANCH_ID,
        COMPBRANCH_CODE,
        COMPBRANCH_ALIAS,
		COMPBRANCH_TELCODE,
		COMPBRANCH_TEL1,
		COMPBRANCH_FAX,
		COMPBRANCH_EMAIL,
		COUNTY_ID,
		CITY_ID,
		COUNTRY_ID,
		COORDINATE_1,
		COORDINATE_2,
        SZ_ID
	FROM
		COMPANY_BRANCH
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#">
        <cfif isdefined("attributes.branch_status") and attributes.branch_status eq 1>
        	AND COMPBRANCH_STATUS = 1
        <cfelseif isdefined("attributes.branch_status") and attributes.branch_status eq 0>
        	AND COMPBRANCH_STATUS = 0
        </cfif>
	ORDER BY
		COMPBRANCH__NAME
</cfquery>
