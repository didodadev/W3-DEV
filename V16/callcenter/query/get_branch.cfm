<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_STATUS,
		BRANCH_ID,
		BRANCH_NAME,
		BRANCH_CITY
	FROM
		BRANCH 
	WHERE
		<cfif isdefined("branch_id_list") and len(branch_id_list)>
            BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#branch_id_list#">)
        <cfelseif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
        <cfelse>
            BRANCH.BRANCH_ID IN (
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                        )
        </cfif>
		AND BRANCH_STATUS = 1
	ORDER BY
		BRANCH_NAME
</cfquery>
