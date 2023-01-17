<cfif attributes.userkey contains "e">
	<cfquery name="USERNAME" datasource="#DSN#">
		SELECT
			EMPLOYEE_ID,
			EMPLOYEE_NAME AS NAME,
			EMPLOYEE_SURNAME AS SURNAME,
			EMPLOYEE_EMAIL AS EMAIL,
			'ÇALIŞAN' AS MEMBER_TYPE,
			PHOTO
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
	</cfquery>	
<cfelseif attributes.userkey contains "p">
	<cfquery name="USERNAME" datasource="#DSN#">
		SELECT
			PARTNER_ID,
			COMPANY_PARTNER_NAME AS NAME,
			COMPANY_PARTNER_SURNAME AS SURNAME,
			COMPANY_PARTNER_EMAIL AS EMAIL,
			'PARTNER' AS MEMBER_TYPE,
			PHOTO  
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
	</cfquery>	
<cfelseif attributes.userkey contains "c">
	<cfquery name="USERNAME" datasource="#DSN#">
		SELECT
			CONSUMER_ID,
			CONSUMER_NAME AS NAME,
			CONSUMER_SURNAME AS SURNAME,
			CONSUMER_EMAIL AS EMAIL,
			'MÜŞTERI' AS MEMBER_TYPE,
			PICTURE
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
	</cfquery>	
</cfif>
