<cfif isdefined("attributes.cid") or isDefined("session.ww.userid")>
	<cfset table_name = "CONSUMER_BANK">
	<cfset column_name = "CONSUMER">
	<cfset money_ = "MONEY">
	<cfif isDefined("session.ww.userid")>
		<cfset temp_id = session.ww.userid>
	<cfelse>
		<cfset temp_id = attributes.cid>
	</cfif>
	<cfset temp_cons ="RECORD_CONS,UPDATE_CONS,">
<!--- Kurumsal Uye Sayfası --->	
<cfelseif isdefined("attributes.cpid")>
	<cfset table_name = "COMPANY_BANK">
	<cfset column_name = "COMPANY">
	<cfset money_ = "COMPANY_BANK_MONEY">
	<cfset temp_id = #attributes.cpid#>
	<cfset temp_cons = "">
</cfif>

<cfif isdefined("attributes.cid") or isdefined("attributes.cpid") or isDefined("session.ww.userid")>
	<cfquery name="GET_BANK_ACCOUNT" datasource="#DSN#">
		SELECT 
			#column_name#_ACCOUNT_DEFAULT AS ACCOUNT_DEFAULT,
			#column_name#_BANK AS BANK,
			#column_name#_BANK_BRANCH AS BANK_BRANCH,
			#column_name#_BANK_CODE AS BANK_CODE,
			#column_name#_BANK_BRANCH_CODE AS BANK_BRANCH_CODE,
			#column_name#_SWIFT_CODE AS BANK_SWIFT_CODE,
			#column_name#_ACCOUNT_NO AS ACCOUNT_NO,
			#column_name#_IBAN_CODE AS IBAN_CODE,
			#money_# AS MONEY,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_EMP,
			#temp_cons#
			UPDATE_DATE,
			UPDATE_IP,
			RECORD_IP,
			BANK_STAGE
		FROM 
			#table_name#
		WHERE
			1=1
			AND #column_name#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#temp_id#">
			AND #column_name#_BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bid#"> 
		<cfif isDefined("session.ww.userid")>
			AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
  		</cfif>
	</cfquery>
<cfelseif isdefined("attributes.employee_id")>
	<cfquery name="GET_BANK_ACCOUNT" datasource="#DSN#">
		SELECT
			DEFAULT_ACCOUNT AS ACCOUNT_DEFAULT,
			BANK_NAME AS BANK,
			BANK_BRANCH_NAME AS BANK_BRANCH,
			BANK_BRANCH_CODE AS BANK_BRANCH_CODE,
			BANK_SWIFT_CODE AS BANK_SWIFT_CODE,
			'' AS BANK_CODE,
			BANK_ACCOUNT_NO AS ACCOUNT_NO,
			IBAN_NO AS IBAN_CODE,
			MONEY,
            NAME,
            SURNAME,
            TC_IDENTY_NO,
            JOIN_ACCOUNT_NAME,
            JOIN_ACCOUNT_SURNAME,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_EMP,
			UPDATE_DATE,
			UPDATE_IP,
			RECORD_IP,
			BANK_STAGE
		FROM
			EMPLOYEES_BANK_ACCOUNTS 
		WHERE 
			EMP_BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bid#">
	</cfquery>
</cfif>
