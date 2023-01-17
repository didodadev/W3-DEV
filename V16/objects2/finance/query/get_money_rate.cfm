<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID =  <cfif isdefined("session.pp.period_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"><cfelseif isdefined("session.ww.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"></cfif>AND
		MONEY_STATUS = 1 AND 
		RATE1=RATE2
</cfquery>
