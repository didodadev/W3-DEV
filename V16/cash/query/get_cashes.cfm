<cfif application.systemParam.systemParam().fusebox.use_period eq true>
    <cfset dsn2="#DSN2#">
<cfelse>
    <cfset dsn2 = dsn>
</cfif>

<cfquery name="GET_CASHES" datasource="#DSN2#">
	SELECT 
		*
	FROM
		CASH
	WHERE
		1=1
		<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
			AND CASH.BRANCH_ID = #attributes.branch_id#
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				CASH.CASH_NAME LIKE '%#attributes.keyword#%' OR
				CASH.CASH_CODE LIKE '%#attributes.keyword#%' OR
				CASH.CASH_ACC_CODE LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif session.ep.isBranchAuthorization and not isdefined("all_cash_")>
			<cfif isdefined("is_virman_act")>
				AND    (CASH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"> OR IS_ALL_BRANCH = 1)
			<cfelse>
				AND	CASH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
			</cfif>
		<cfelseif session.ep.isBranchAuthorization and isdefined("all_cash_") and isdefined("x_store_control") and x_store_control eq 1>
			AND	(CASH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"> )
		</cfif>
		<cfif isdefined("cash_status")>
			AND	CASH.CASH_STATUS = 1
		</cfif>
	ORDER BY 
		CASH_NAME
</cfquery>
<cfquery name="GET_CASHES2" datasource="#DSN2#">
	SELECT 
		*
	FROM
		CASH
	WHERE
		1=1
	<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
		AND CASH.BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			CASH.CASH_NAME LIKE '%#attributes.keyword#%' OR
			CASH.CASH_CODE LIKE '%#attributes.keyword#%' OR
			CASH.CASH_ACC_CODE LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined("x_store_control") and x_store_control eq 1 and session.ep.isBranchAuthorization and not isdefined("all_cash_")>
		<cfif isdefined("is_virman_act")>
			AND	(CASH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"> OR IS_ALL_BRANCH = 1)
		<cfelse>
			AND	CASH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
	<cfelseif isdefined("all_cash_") and session.ep.isBranchAuthorization>
		AND	(CASH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"> OR IS_ALL_BRANCH = 1)
	</cfif>
	<cfif isdefined("cash_status")>
		AND	CASH.CASH_STATUS = 1
	</cfif>
	ORDER BY 
		CASH_NAME
</cfquery>
<cfquery name="GET_CLOSE_CASHES" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		CASH 
	WHERE 
		<cfif isdefined("cash_status")>
			CASH.CASH_STATUS = 1 AND
		</cfif>
		ISOPEN = 0 
	ORDER BY CASH_NAME
</cfquery>
<cfif isdefined("url.id") and len(url.id) and not isdefined("is_virman_act")>
	<cfquery name="GET_CACHES" datasource="#DSN2#">
	 	SELECT
			*
		FROM
			CASH_ACTIONS
		WHERE
			CASH_ACTIONS.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> 
	</cfquery>
</cfif>

