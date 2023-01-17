<cfquery name="get_ssk_offices" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,	
		BRANCH_FULLNAME,	
		SSK_OFFICE,
		COMPANY_ID,
		SSK_NO,
		BRANCH_TAX_NO,
		BRANCH_TAX_OFFICE,
		BRANCH_NAME+' ('+SSK_OFFICE+' - '+SSK_NO+')' SSK_OFFICE_NO,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH 
		INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	WHERE
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.BRANCH_STATUS = 1 AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO <> '' AND
		BRANCH.SSK_OFFICE <> '' AND
		BRANCH.SSK_BRANCH <> ''
		<cfif not session.ep.ehesap>
		AND BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
					)
		</cfif>
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
        	AND BRANCH.COMPANY_ID IN (#attributes.comp_id#)
		</cfif>
	ORDER BY
		BRANCH_NAME,
		SSK_OFFICE
</cfquery>
<cfquery name="GET_CITY_ID" datasource="#DSN#">
	SELECT DISTINCT
		BRANCH_CITY
    FROM 
    	BRANCH 
    WHERE 
    	BRANCH_STATUS = 1 
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		AND BRANCH_CITY IS NOT NULL
    ORDER BY 
	BRANCH_CITY
</cfquery>
