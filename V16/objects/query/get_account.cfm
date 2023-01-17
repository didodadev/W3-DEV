<cfif isdefined('attributes.db_source')>
	<cfif database_type is "MSSQL">
		<cfset db_source_name = "#DSN#_#attributes.PERIOD_YEAR#_#attributes.db_source#">
		<cfset db_source = "#DSN#_#attributes.PERIOD_YEAR#_#attributes.db_source#">		
		<cfset db_source3_alias = "#DSN#_#attributes.db_source#">
	<cfelseif database_type is "DB2">
		<cfset db_source_name="#DSN#_#attributes.db_source#_#Right(Trim(attributes.PERIOD_YEAR),2)#">
		<cfset db_source="#DSN#_#attributes.db_source#_#Right(Trim(attributes.PERIOD_YEAR),2)#">		
		<cfset db_source3_alias="#DSN#_#attributes.db_source#_dbo">
	</cfif>
<cfelse>
	<cfset db_source_name = DSN2 >
	<cfset db_source = DSN2 >	
	<cfset db_source3_alias = DSN3_ALIAS >
</cfif>
<cfquery name="ACCOUNT" datasource="#db_source_name#">
	SELECT 
		* 
	FROM 
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_ID = #attributes.ACCOUNT_ID#
</cfquery>
<cfif account.recordcount>
	<cfset control_account_code=account.account_code>
	<cfinclude template="../query/get_account_hareket.cfm">
<cfelse>
	<cfset get_acc.recordcount = 0>
</cfif>
