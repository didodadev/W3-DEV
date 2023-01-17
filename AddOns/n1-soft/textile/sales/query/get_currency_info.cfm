<cfif isdefined("attributes.date1") and isdate(attributes.date1)><cf_date tarih = "attributes.date1"></cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)><cf_date tarih = "attributes.date2"></cfif>
<cfif isdefined("attributes.valid_date1") and isdate(attributes.valid_date1)><cf_date tarih = "attributes.valid_date1"></cfif>
<cfif isdefined("attributes.valid_date2") and isdate(attributes.valid_date2)><cf_date tarih = "attributes.valid_date2"></cfif>
<cfquery name="GET_CURRENCY" datasource="#DSN#">
	SELECT
		MH.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		TEXTILE_MONEY_HISTORY MH,
		EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = MH.RECORD_EMP AND
		MH.MONEY <> '#session.ep.money#' AND
		MH.COMPANY_ID = #session.ep.company_id# AND
		MH.PERIOD_ID = #session.ep.period_id#
	<cfif isdefined("attributes.date1") and len(attributes.date1) and isdefined('attributes.date2') and len(attributes.date2)>
		AND MH.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
	<cfelseif isdefined("attributes.date1") and len(attributes.date1)>
		AND MH.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
	<cfelseif isdefined("attributes.date2") and len(attributes.date2)>
		AND MH.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
	</cfif>
	<cfif isdefined("attributes.valid_date1") and len(attributes.valid_date1) and isdefined("attributes.valid_date2") and len(attributes.valid_date2)>
		AND MH.VALIDATE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valid_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valid_date2#">
	<cfelseif isdefined("attributes.valid_date1") and len(attributes.valid_date1)>
		AND MH.VALIDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valid_date1#">
	<cfelseif isdefined("attributes.valid_date2") and len(attributes.valid_date2)>
		AND MH.VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.valid_date2#">
	</cfif>
	<cfif isdefined("attributes.money") and len(attributes.money)>
		AND MH.MONEY='#attributes.money#'
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND (E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')
	</cfif>
	ORDER BY
		MH.RECORD_DATE DESC
</cfquery>
