<!---14.08.2012 E.A SQL PAGGING UYGULANDI.--->
<!---20130905 Stored Proca Çevirdim. E.A  --->
<cfif isdefined('attributes.db_source')>
	<cfif database_type is "MSSQL">
		<cfset db_source = "#DSN#_#attributes.period_year#_#attributes.db_source#">
		<cfset db_source3_alias = "#DSN#_#attributes.db_source#">
	<cfelseif database_type is "DB2">
		<cfset db_source="#DSN#_#attributes.db_source#_#Right(Trim(attributes.period_year),2)#">
		<cfset db_source3_alias="#DSN#_#attributes.db_source#_dbo">
	</cfif>
<cfelse>
	<cfset db_source = DSN2>
	<cfset db_source3_alias = DSN3_ALIAS>
</cfif>

<!---<cfquery name="ACCOUNT_PLAN" DATASOURCE="#db_source#">
	WITH CTE1 AS (
	SELECT
	<cfif isdefined("is_xml_remainder") and is_xml_remainder eq 1>
		SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
	</cfif>
		ACCOUNT_PLAN.ACCOUNT_CODE, 
		ACCOUNT_PLAN.ACCOUNT_CODE2, 
		ACCOUNT_PLAN.ACCOUNT_NAME,
		ACCOUNT_PLAN.ACCOUNT_ID,
		ACCOUNT_PLAN.SUB_ACCOUNT,
		ACCOUNT_PLAN.IFRS_CODE, 
		ACCOUNT_PLAN.IFRS_NAME
	FROM
		ACCOUNT_PLAN
		<cfif isdefined("is_xml_remainder") and is_xml_remainder eq 1>
		LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
		(
			(ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') OR
			(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
		)
		</cfif>
	WHERE
		ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
		<cfif isdefined("attributes.account_code") and len(attributes.account_code)>
			<cfif not FindNoCase(left(attributes.account_code,1),"abcçdefghıijklmnoöprsştuüvwyzq", 0) and  isnumeric(left(attributes.account_code,3))>
				AND ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.account_code#%'
			<cfelse>
				AND ACCOUNT_PLAN.ACCOUNT_NAME LIKE '%#attributes.account_code#%'
			</cfif>
		</cfif>
	<cfif isdefined("is_xml_remainder") and is_xml_remainder eq 1>
	GROUP BY
		ACCOUNT_PLAN.ACCOUNT_CODE, 
		ACCOUNT_PLAN.ACCOUNT_CODE2, 
		ACCOUNT_PLAN.ACCOUNT_NAME,
		ACCOUNT_PLAN.SUB_ACCOUNT,
		ACCOUNT_PLAN.IFRS_CODE, 
		ACCOUNT_PLAN.IFRS_NAME,
		ACCOUNT_PLAN.ACCOUNT_ID
	</cfif>
	),
	
	CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
</cfquery>--->

<cfstoredproc procedure="get_account_plan" datasource="#db_source#">
	<cfif isdefined("is_xml_remainder")>
    	<cfif is_xml_remainder eq 1 >
        	<cfprocparam cfsqltype="cf_sql_bit" value="1">
		<cfelse>
        	<cfprocparam cfsqltype="cf_sql_bit" value="0">
        </cfif>
    <cfelse>
    	<cfprocparam cfsqltype="cf_sql_bit" value="1">
    </cfif>
    <cfif isdefined("attributes.account_code") and len(attributes.account_code)>
   		<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#">
    <cfelse>
    	<cfprocparam cfsqltype="cf_sql_varchar" value="">
    </cfif>
    <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.startrow#">
    <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.maxrows#">
    <cfprocresult name="account_plan">
</cfstoredproc>
