<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT
		PC.HIERARCHY,
		CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE PRODUCT_CAT
        END AS PRODUCT_CAT,
		PC.IS_SUB_PRODUCT_CAT,
		PC.PRODUCT_CATID,
		PC.PROFIT_MARGIN,
		PC.PROFIT_MARGIN_MAX,
		PC.POSITION_CODE,
		PC.POSITION_CODE2
	FROM
		PRODUCT_CAT PC
        <cfif len(attributes.employee) and len(employee_id)>
        LEFT JOIN PRODUCT_CAT_POSITIONS PCP ON PCP.product_cat_ID = PC.PRODUCT_CATID
		LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS E ON E.POSITION_CODE = PCP.POSITION_CODE
      --  LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS E ON E.EMPLOYEE_ID = PC.RECORD_EMP
        </cfif>
        	LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PC.PRODUCT_CATID
            AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_CAT">
            AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_CAT">
            AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PC.PRODUCT_CATID IS NOT NULL AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id#
	<cfif isDefined('attributes.category') and len(attributes.category)>
		AND PC.HIERARCHY LIKE '#attributes.category#%'
	</cfif>
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		AND (PC.PRODUCT_CAT LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%' OR PC.HIERARCHY LIKE '#attributes.keyword#%')
	</cfif>
	<cfif len(attributes.employee) and len(employee_id)>
     AND (E.POSITION_ID = #employee_id#)
	</cfif>
	ORDER BY
		PC.HIERARCHY
</cfquery>
