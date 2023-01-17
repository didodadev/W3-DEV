<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfif get_period.recordcount>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>

<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT
		*
	FROM
		#URL.TABLE_NAME#
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
		<cfif isdefined("session.pp.company_id")>
            <cfif URL.TABLE_NAME eq 'CASH_ACTIONS'>
                AND (CASH_ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    OR CASH_ACTION_TO_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
            <cfelseif URL.TABLE_NAME eq 'BANK_ACTIONS'>
                AND (ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    OR ACTION_TO_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
            <cfelseif URL.TABLE_NAME eq 'PAYROLL'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
            </cfif>
        <cfelseif isdefined("session.ww.userid")> 
            <cfif URL.TABLE_NAME eq 'CASH_ACTIONS'>
                AND (CASH_ACTION_FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                OR CASH_ACTION_TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
            <cfelseif URL.TABLE_NAME eq 'BANK_ACTIONS'>
                AND (ACTION_FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                    OR ACTION_TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
            <cfelseif URL.TABLE_NAME eq 'PAYROLL'>
                AND CONSUMER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            </cfif>
        </cfif> 
</cfquery>
