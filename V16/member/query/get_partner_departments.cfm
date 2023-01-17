<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#DSN#">
	SELECT
    	CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE PARTNER_DEPARTMENT
        END AS PARTNER_DEPARTMENT
		,PARTNER_DEPARTMENT_ID
	FROM
		SETUP_PARTNER_DEPARTMENT WITH (NOLOCK)
        LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_PARTNER_DEPARTMENT.PARTNER_DEPARTMENT_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PARTNER_DEPARTMENT">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PARTNER_DEPARTMENT">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY
		PARTNER_DEPARTMENT 
</cfquery>
