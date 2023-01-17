<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT 
		WG.WORKGROUP_ID,
		WG.HIERARCHY,
		WG.WORKGROUP_NAME,
		WG.SUB_WORKGROUP,
		WG.OUR_COMPANY_ID,
		WG.MANAGER_EMP_ID,
		WG.DEPARTMENT_ID,
		WG.BRANCH_ID,
		WG.HEADQUARTERS_ID
	FROM
		<cfif isDefined("attributes.listing_type") and attributes.listing_type neq 1><!--- Alfabetik Artan (Ana Hiyerarsilere Gore) --->
			WORK_GROUP WGM,
		</cfif>
		WORK_GROUP WG
	WHERE
		<cfif isDefined("attributes.listing_type") and attributes.listing_type neq 1>
			(
				(WG.HIERARCHY NOT LIKE '%.%' AND WGM.HIERARCHY = WG.HIERARCHY) OR
				(WG.HIERARCHY LIKE '%.%' AND WGM.HIERARCHY = LEFT(WG.HIERARCHY,LEN(WGM.HIERARCHY)))
			) AND
			WGM.HIERARCHY NOT LIKE '%.%' AND
			WGM.HIERARCHY IS NOT NULL AND
		</cfif>
		<cfif Len(attributes.keyword)>
			WG.WORKGROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI AND
		</cfif>
        <cfif isdefined ("attributes.branch_id") and len (attributes.branch_id) and attributes.branch_id is not "all">
        	WG.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
        </cfif>
        <cfif isdefined("attributes.department") and len (attributes.department) and attributes.department is not "all">
        	WG.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> AND
        </cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
			WG.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif attributes.is_hierarchy eq 1>
			WG.HIERARCHY IS NOT NULL AND
		<cfelseif attributes.is_hierarchy eq 0>
			WG.HIERARCHY IS NULL AND
		</cfif>
		<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
			( WG.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#.%"> OR WG.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"> ) AND
		</cfif>
        <cfif isdefined("module_name") and module_name is 'service'>
        	ONLINE_HELP = 1 AND
        </cfif>
		WG.WORKGROUP_ID IS NOT NULL
	ORDER BY 
		<cfif isDefined("attributes.listing_type") and attributes.listing_type neq 1>
			WGM.WORKGROUP_NAME,
		</cfif>
		<!--- WG.HIERARCHY, --->
		CASE WHEN WG.HIERARCHY NOT LIKE '%.%' THEN WG.HIERARCHY ELSE WG.WORKGROUP_NAME END,
		WG.WORKGROUP_NAME
</cfquery>
