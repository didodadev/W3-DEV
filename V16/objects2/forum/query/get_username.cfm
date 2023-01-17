<cfif attributes.userkey contains "e">
	<cfquery name="GET_USERNAME" datasource="#DSN#">
		SELECT
			EMPLOYEE_USERNAME AS USERNAME,
			EMPLOYEE_EMAIL AS EMAIL,
			MEMBER_TYPE = 'ÇALIŞAN'
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
	</cfquery>
<cfelseif attributes.userkey contains "p">
	<cfquery name="GET_USERNAME" datasource="#DSN#">
		SELECT
			COMPANY_PARTNER_USERNAME AS USERNAME,
			COMPANY_PARTNER_EMAIL AS EMAIL,
			MEMBER_TYPE = 'PARTNER'
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
	</cfquery>	
<cfelseif attributes.userkey contains "c">
	<cfquery name="GET_USERNAME" datasource="#DSN#">
		SELECT
			CONSUMER_USERNAME AS USERNAME,
			CONSUMER_EMAIL AS EMAIL,
			MEMBER_TYPE = 'BİREYSEL ÜYE'
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
	</cfquery>	
</cfif>
