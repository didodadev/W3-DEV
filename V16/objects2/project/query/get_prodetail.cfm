<cfquery name="PROJECT_DETAIL" datasource="#DSN#">
	SELECT 
		*,
		(
			(
				SELECT
					SUM(ISNULL(TO_COMPLETE,0))
				FROM
					PRO_WORKS PW
				WHERE
					PW.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
			)/
			(
				SELECT
					COUNT(WORK_ID)
				FROM
					PRO_WORKS PW2
				WHERE
					PW2.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
			)
		) COMPLETE_RATE
	FROM
		PRO_PROJECTS,
		SETUP_MONEY
	WHERE
    	<cfif isDefined('session.pp.userid')>
			SETUP_MONEY.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
		<cfelseif isDefined('session.pda.userid')>
			SETUP_MONEY.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#"> AND        
        </cfif>
		SETUP_MONEY.MONEY=PRO_PROJECTS.BUDGET_CURRENCY AND
        <cfif isDefined('attributes.project_id')>
			PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		<cfelseif isDefined('attributes.id')>
			PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">        
        </cfif>
	ORDER BY 
		PRO_PROJECTS.RECORD_DATE
</cfquery>
<cfquery name="GET_LAST_REC" datasource="#DSN#">
	SELECT
		MAX(HISTORY_ID) AS HIS_ID
	FROM
		PRO_HISTORY
	WHERE
        <cfif isDefined('attributes.project_id')>
			PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		<cfelseif isDefined('attributes.id')>
			PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">        
        </cfif>
</cfquery>
<cfset hist_id=get_last_rec.his_id>
<cfif len(hist_id)>
	<cfquery name="GET_HIST_DETAIL" datasource="#DSN#">
		SELECT
			PRIORITY
		FROM
			PRO_HISTORY,
			SETUP_PRIORITY
		WHERE
			PRO_HISTORY.PRO_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
			PRO_HISTORY.HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#hist_id#">
	</cfquery>
</cfif>

