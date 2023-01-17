<cfif not isDefined('attributes.station_id')>
	<cfquery name="GET_WORKSTATION_ALL" datasource="#dsn#">
        SELECT
			T1.*,
			WORKSTATIONS2.STATION_NAME UPSTATION
		FROM
		(
			SELECT
				WORKSTATIONS.STATION_ID,
				WORKSTATIONS.STATION_NAME,
				WORKSTATIONS.EMP_ID,
				WORKSTATIONS.UP_STATION,
				WORKSTATIONS.OUTSOURCE_PARTNER,
				WORKSTATIONS.CAPACITY,
                WORKSTATIONS.COMMENT,
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME,
				DEPARTMENT.DEPARTMENT_HEAD,
				CASE WHEN WORKSTATIONS.UP_STATION IS NULL THEN
					WORKSTATIONS.STATION_ID 
				ELSE
					WORKSTATIONS.UP_STATION 
				END AS UPSTATION_ID,
				WORKSTATIONS.STATION_ID KONTROL_STATION,
				WORKSTATIONS.STATION_NAME KONTROL_NAME,
				CASE WHEN (SELECT TOP 1 WS1.UP_STATION FROM #dsn3_alias#.WORKSTATIONS WS1 WHERE WS1.UP_STATION = WORKSTATIONS.STATION_ID) IS NOT NULL THEN 0 ELSE 1 END AS TYPE,
				(SELECT TOP 1 PO.FINISH_DATE FROM #dsn3_alias#.PRODUCTION_ORDERS PO WHERE PO.STATION_ID = WORKSTATIONS.STATION_ID AND PO.IS_STAGE <> -1 ORDER BY PO.FINISH_DATE DESC) MAX_ORDER_DATE
			FROM
				#dsn3_alias#.WORKSTATIONS AS WORKSTATIONS,
				BRANCH AS BRANCH,
				DEPARTMENT AS DEPARTMENT
			WHERE
				WORKSTATIONS.BRANCH = BRANCH.BRANCH_ID AND
				WORKSTATIONS.DEPARTMENT = DEPARTMENT.DEPARTMENT_ID
				<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>AND WORKSTATIONS.STATION_ID IN(SELECT WS_ID FROM #dsn3_alias#.WORKSTATIONS_PRODUCTS WP WHERE WP.STOCK_ID IN(#attributes.stock_id#))</cfif>
				<cfif isdefined("attributes.up_search") and len(attributes.up_search)>AND WORKSTATIONS.UP_STATION = #attributes.up_search# AND</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND WORKSTATIONS.BRANCH = #attributes.branch_id#</cfif>
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>AND WORKSTATIONS.STATION_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>	
				<cfif isdefined("attributes.is_active") and len(attributes.is_active)>AND WORKSTATIONS.ACTIVE = #attributes.is_active#</cfif>
            )T1
            LEFT JOIN #dsn3_alias#.WORKSTATIONS AS WORKSTATIONS2 ON WORKSTATIONS2.STATION_ID = T1.UPSTATION_ID
        ORDER BY 
            UPSTATION,
            UPSTATION_ID,
            UP_STATION,
            TYPE,
            STATION_NAME
	</cfquery>
<cfelse>
	<cfquery name="GET_WORKSTATION_ALL" datasource="#dsn#">
		SELECT
		DISTINCT 
			WORKSTATIONS.STATION_ID,
			WORKSTATIONS.STATION_NAME
		FROM
			#dsn3_alias#.WORKSTATIONS AS WORKSTATIONS
		WHERE
			WORKSTATIONS.UP_STATION = #attributes.station_id# AND
			WORKSTATIONS.STATION_ID <> #attributes.station_id#
            <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>AND WORKSTATIONS.STATION_ID IN(SELECT WS_ID FROM #dsn3_alias#.WORKSTATIONS_PRODUCTS WP WHERE WP.STOCK_ID IN(#attributes.stock_id#))</cfif>
		ORDER BY
			WORKSTATIONS.STATION_NAME
	</cfquery>
</cfif>
